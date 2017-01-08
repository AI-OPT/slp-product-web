package com.ai.slp.product.web.controller.prodCat;

import java.util.*;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.*;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.util.CollectionUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.productcat.interfaces.IAttrAndValDefSV;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.*;
import com.ai.slp.product.web.constants.ProdAttrDefConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.model.prodCat.ProdCatQuery;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.product.web.vo.ProdQueryCatVo;
import com.alibaba.fastjson.JSON;

/**
 * 类目查询
 * Created by jackieliu on 16/7/26.
 */
@Controller
@RequestMapping("/cat/query")
public class CatQueryController {
    private static final Logger logger = LoggerFactory.getLogger(CatQueryController.class);
    @Autowired
    private ProdCatService prodCatService;

    /**
     * 查询类目的子类目
     *
     * @return
     */
    @RequestMapping("/child")
    @ResponseBody
    public ResponseData<List<ProdQueryCatVo>> queryChildCat(String prodCatId) {
        ResponseData<List<ProdQueryCatVo>> responseData;
        List<ProdQueryCatVo> prodQueryCatVoList = new ArrayList<>();
        try {
            IProductCatSV productCatSV = DubboConsumerFactory.getService("iProductCatSV");
            //通过id查询当前类目信息
            ProductCatUniqueReq productCatUniqueReq = new ProductCatUniqueReq();
            productCatUniqueReq.setTenantId(AdminUtil.getTenantId());
            productCatUniqueReq.setProductCatId(prodCatId);
            ProductCatInfo productCatInfo = productCatSV.queryByCatId(productCatUniqueReq);
            //如果当前类目有子类则查询下一级类目
            if(productCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD)){
                ProductCatQuery catQuery = new ProductCatQuery();
                catQuery.setTenantId(AdminUtil.getTenantId());
                catQuery.setParentProductCatId(prodCatId);
                ProdCatInfo prodCatInfo = null;
                do{
                    // 查询同一级的类目信息
                    List<ProdCatInfo> productCatInfos = productCatSV.queryCatByNameOrFirst(catQuery);
                    if (CollectionUtil.isEmpty(productCatInfos)){
                    	break;
                    }
                    prodCatInfo = productCatInfos.get(0);
                    ProdQueryCatVo prodQueryCatVo = new ProdQueryCatVo();
                    prodQueryCatVo.setLevel((short)(prodCatInfo.getCatLevel()-1));
                    prodQueryCatVo.setProdCatList(productCatInfos);
                    prodQueryCatVoList.add(prodQueryCatVo);
                    catQuery.setParentProductCatId(prodCatInfo.getProductCatId());
                }while(prodCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD));
            }
            logger.debug("获取类目信息出参:" + JSonUtil.toJSon(prodQueryCatVoList));
            responseData = new ResponseData<List<ProdQueryCatVo>>(ResponseData.AJAX_STATUS_SUCCESS,"",prodQueryCatVoList);
        } catch (Exception e) {
            logger.error("获取类目信息出错", e);
            responseData = new ResponseData<List<ProdQueryCatVo>>(ResponseData.AJAX_STATUS_FAILURE,e.getMessage());
        }
        return responseData;
    }
    
    
    
    /**
     * 类目分页列表页
     */
    @RequestMapping(value = {"","/"})
    public String inSalelistQuery(String parentProductCatId, Model uiModel) {
        //若父类目不为空,查询类目链
        if (StringUtils.isNotBlank(parentProductCatId)) {
            uiModel.addAttribute("catLink", prodCatService.queryLink(parentProductCatId));
            uiModel.addAttribute("parentProductCatId",parentProductCatId);
        }//默认只查询根类目
        else {
            uiModel.addAttribute("parentProductCatId","0");
        }
        return "prodcat/catlist";
    }

    /**
     * 查询分页数据
     * @param catQuery
     * @return
     */
    @RequestMapping("/list")
    @ResponseBody
    public ResponseData<PageInfoResponse<ProductCatInfo>> queryCat(ProdCatQuery catQuery){
        ResponseData<PageInfoResponse<ProductCatInfo>> responseData;
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProductCatPageQuery pageQuery = new ProductCatPageQuery();
        BeanUtils.copyProperties(pageQuery,catQuery);
        pageQuery.setTenantId(AdminUtil.getTenantId());
        PageInfoResponse<ProductCatInfo> catInfoPageRes = catSV.queryPageProductCat(pageQuery);
        ResponseHeader header = catInfoPageRes.getResponseHeader();

        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<PageInfoResponse<ProductCatInfo>>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else{
            responseData = new ResponseData<PageInfoResponse<ProductCatInfo>>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",catInfoPageRes);
        }

        return responseData;
    }

    /**
     * 查询单个类目信息
     * @return
     */
    @RequestMapping("/{id}")
    @ResponseBody
    public ResponseData<ProductCatInfo> queryCatById(@PathVariable("id") String catId){
        ResponseData<ProductCatInfo> responseData;
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProductCatUniqueReq uniqueReq = new ProductCatUniqueReq();
        uniqueReq.setTenantId(AdminUtil.getTenantId());
        uniqueReq.setProductCatId(catId);
        ProductCatInfo catInfo = catSV.queryByCatId(uniqueReq);
        ResponseHeader header = catInfo.getResponseHeader();

        //保存错误
        if (header!=null && !header.isSuccess()){
            logger.error("Query by catId is fail,catId:{},headInfo:\r\n",catId, JSON.toJSONString(header));
            responseData = new ResponseData<ProductCatInfo>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else{
            responseData = new ResponseData<ProductCatInfo>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",catInfo);
        }
        return responseData;
    }

    /**
     * 查询类目属性信息
     * @return
     */
    @RequestMapping("/attr/{id}")
    public String queryAttrOfCat(@PathVariable("id")String catId,Model uiModel){
        addAttr(catId,uiModel);
        return "prodcat/catattrview";
    }

    /**
     * 显示类目属性编辑页面
     * @param catId
     * @param uiModel
     * @return
     */
    @RequestMapping("/attr/edit/{id}")
    public String attrOfCatEditView(@PathVariable("id")String catId,Model uiModel){
        addAttr(catId,uiModel);
        uiModel.addAttribute("catId",catId);
        return "prodcat/catattredit";
    }

    /**
     * 显示属性及属性值列表
     * @return
     */
    @RequestMapping("/attr/view/{id}")
    public String queryAttr(@PathVariable("id")String catId,String attrType,Model uiModel){
        uiModel.addAttribute("catId",catId);
        uiModel.addAttribute("attrType",attrType);
        uiModel.addAttribute("catLink",prodCatService.queryLink(catId));
        Map<Long,Set<String>> nowMap = new HashMap<>();
        Set<Long> otherAttr = new HashSet<>();
        //查询关键属性
        Map<Long,Set<String>> keyMap = getAttr(
                catId,attrType,ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY,otherAttr);
        //查询销售属性
        Map<Long,Set<String>> saleMap = getAttr(
                catId,attrType,ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE,otherAttr);
        Map<Long,Set<String>> noKeyMap = getAttr(
                catId,attrType,ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_NONKEY,otherAttr);
        switch (attrType){
            case ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY:
                nowMap = keyMap;
                break;
            case ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE:
                nowMap = saleMap;
                break;
            case ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_NONKEY:
                nowMap = noKeyMap;
                break;
            default:
                logger.debug("未知类型");
                break;
        }
        //查询所有属性及属性值
        IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
        BaseInfo baseInfo = new BaseInfo();
        baseInfo.setTenantId(AdminUtil.getTenantId());
        BaseListResponse<AttrDef> response = attrAndValDefSV.queryAllAttrAndVal(baseInfo);
        List<AttrDef> attrDefList = response.getResult();
        if (ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE.equals(attrType)) {
            attrDefList = delNoSaleAttr(attrDefList);
        }
        uiModel.addAttribute("attrList",attrDefList);
        uiModel.addAttribute("nowMap",nowMap);
        uiModel.addAttribute("otherSet",otherAttr);
        return "prodcat/catattrall";
    }
    
    /**
     * 查询属性 
     */
    public Map<Long,Set<String>> getAttr(String catId,String attrType,String queryType,
                                         Set<Long> otherAttr){
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        AttrQueryForCat queryForCat = new AttrQueryForCat();
        queryForCat.setTenantId(AdminUtil.getTenantId());
        queryForCat.setProductCatId(catId);
        queryForCat.setAttrType(queryType);
        BaseMapResponse<Long, Set<String>> mapResponse = catSV.queryAttrAndValIdByCatAndType(queryForCat);
        if (queryType.equals(attrType)){
            return mapResponse.getResult();
        }else {
            otherAttr.addAll(mapResponse.getResult().keySet());
            return null;
        }
    }
    /**
     * 添加属性 
     */
    private void addAttr(String catId,Model uiModel){
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        //类目链
        uiModel.addAttribute("catLink", prodCatService.queryLink(catId));

        //关键属性
        AttrQueryForCat attrQuery = new AttrQueryForCat();
        attrQuery.setTenantId(AdminUtil.getTenantId());
        attrQuery.setProductCatId(catId);
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
        BaseListResponse<ProdCatAttrDef> attrMap = catSV.queryAttrByCatAndType(attrQuery);
        uiModel.addAttribute("keyAttr",attrMap.getResult());

        //销售属性
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
        BaseListResponse<ProdCatAttrDef> salAttrMap = catSV.queryAttrByCatAndType(attrQuery);
        uiModel.addAttribute("saleAttr",salAttrMap.getResult());
        //非关键属性
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_NONKEY);
        BaseListResponse<ProdCatAttrDef> noKeyAttrMap = catSV.queryAttrByCatAndType(attrQuery);
        uiModel.addAttribute("noKeyAttr",noKeyAttrMap.getResult());
    }

    //删除不适用于销售属性的属性
    private List<AttrDef> delNoSaleAttr(List<AttrDef> attrDefList){
        if (CollectionUtil.isEmpty(attrDefList)){
        	return attrDefList;
        } 
        List<AttrDef> newAttrDefList = new ArrayList<>();
        for (AttrDef attrDef:attrDefList){
            //若是复选框,则选中.
            if (ProdAttrDefConstants.ValueWay.CHECKBOX.equals(attrDef.getValueWay())
                    ||ProdAttrDefConstants.ValueWay.RADIO.equals(attrDef.getValueWay())){
                newAttrDefList.add(attrDef);
            }
        }
        return newAttrDefList;
    }
}
