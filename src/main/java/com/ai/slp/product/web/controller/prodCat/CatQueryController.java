package com.ai.slp.product.web.controller.prodCat;

import com.ai.opt.base.vo.*;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.productcat.interfaces.IAttrAndValDefSV;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.*;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.model.prodCat.ProdCatQuery;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.vo.ProdQueryCatVo;
import com.alibaba.fastjson.JSON;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * 类目查询
 * Created by jackieliu on 16/7/26.
 */
@Controller
@RequestMapping("/cat/query")
public class CatQueryController {
    private static Logger logger = LoggerFactory.getLogger(CatQueryController.class);
    @Autowired
    private ProdCatService prodCatService;

    /**
     * 查询类目的子类目
     *
     * @return
     */
    @RequestMapping("/child")
    @ResponseBody
    public List<ProdQueryCatVo> queryChildCat(String prodCatId) {
        List<ProdQueryCatVo> prodQueryCatVoList = new ArrayList<>();
        try {
            IProductCatSV productCatSV = DubboConsumerFactory.getService("iProductCatSV");
            //通过id查询当前类目信息
            ProductCatUniqueReq productCatUniqueReq = new ProductCatUniqueReq();
            productCatUniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            productCatUniqueReq.setProductCatId(prodCatId);
            ProductCatInfo productCatInfo = productCatSV.queryByCatId(productCatUniqueReq);
            ProductCatQuery catQuery = new ProductCatQuery();
            ProdCatInfo prodCatInfo = null;
            catQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            //如果当前类目有子类则查询下一级类目
            if(productCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD)){
                catQuery.setParentProductCatId(prodCatId);
                do{
                    // 查询同一级的类目信息
                    List<ProdCatInfo> productCatInfos = productCatSV.queryCatByNameOrFirst(catQuery);
                    prodCatInfo = productCatInfos.get(0);
                    ProdQueryCatVo prodQueryCatVo = new ProdQueryCatVo();
                    prodQueryCatVo.setLevel((short)(prodCatInfo.getCatLevel()-1));
                    prodQueryCatVo.setProdCatList(productCatInfos);
                    prodQueryCatVoList.add(prodQueryCatVo);
                    catQuery.setParentProductCatId(prodCatInfo.getProductCatId());
                }while(prodCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD));
            }
            logger.debug("获取类目信息出参:" + JSonUtil.toJSon(prodQueryCatVoList));
        } catch (Exception e) {
            prodQueryCatVoList = null;
            logger.error("获取类目信息出错", e);
        }
        return prodQueryCatVoList;
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
        pageQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        PageInfoResponse<ProductCatInfo> catInfoPageRes = catSV.queryPageProductCat(pageQuery);
        ResponseHeader header = catInfoPageRes.getResponseHeader();

        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<PageInfoResponse<ProductCatInfo>>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else
            responseData = new ResponseData<PageInfoResponse<ProductCatInfo>>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",catInfoPageRes);

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
        uniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        uniqueReq.setProductCatId(catId);
        ProductCatInfo catInfo = catSV.queryByCatId(uniqueReq);
        ResponseHeader header = catInfo.getResponseHeader();

        //保存错误
        if (header!=null && !header.isSuccess()){
            logger.error("Query by catId is fail,catId:{},headInfo:\r\n",catId, JSON.toJSONString(header));
            responseData = new ResponseData<ProductCatInfo>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else
            responseData = new ResponseData<ProductCatInfo>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",catInfo);
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
        }
        //查询所有属性及属性值
        IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
        BaseInfo baseInfo = new BaseInfo();
        baseInfo.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        BaseListResponse<AttrDef> response = attrAndValDefSV.queryAllAttrAndVal(baseInfo);
        uiModel.addAttribute("attrList",response.getResult());
        uiModel.addAttribute("nowMap",nowMap);
        uiModel.addAttribute("otherMap",otherAttr);
        return "prodcat/catattrall";
    }

    public Map<Long,Set<String>> getAttr(String catId,String attrType,String queryType,
                                         Set<Long> otherAttr){
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        AttrQueryForCat queryForCat = new AttrQueryForCat();
        queryForCat.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
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

    private void addAttr(String catId,Model uiModel){
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        //类目链
        uiModel.addAttribute("catLink", prodCatService.queryLink(catId));

        //关键属性
        AttrQueryForCat attrQuery = new AttrQueryForCat();
        attrQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
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
}
