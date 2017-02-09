package com.ai.slp.product.web.controller.product;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.components.dss.DSSClientFactory;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.util.DateUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.dss.base.interfaces.IDSSClient;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamMultiCond;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrQuery;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.*;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProductCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatUniqueReq;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.model.product.ProductEditInfo;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * 销售商品编辑
 * Created by jackieliu on 16/6/16.
 */
@Controller
@RequestMapping("/prodedit")
public class ProdEditController {
    private static final Logger logger = LoggerFactory.getLogger(ProdEditController.class);
    @Autowired
    private AttrAndValService attrAndValService;
    IProductManagerSV productManagerSV;
    IProductSV productSV;
    ICacheSV cacheSV;
    INormProductSV normProductSV;
    IProductCatSV productCatSV;

    public void initConsumer() {
        if (productManagerSV == null){
        	productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
        }
        if (productSV == null){
        	productSV = DubboConsumerFactory.getService(IProductSV.class);
        }
        if (cacheSV == null){
        	cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        }
        if (normProductSV == null){
        	normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
        }
        if (productCatSV == null){
        	productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        }
    }
    /**
     * 显示商品编辑页面
     * @param prodId
     * @return
     */
    @RequestMapping("/{id}")
    public String editView(@PathVariable("id")String prodId,Model uiModel){
        initConsumer();
        //查询商品详情
        ProductInfoQuery infoQuery = new ProductInfoQuery();
        infoQuery.setTenantId(AdminUtil.getTenantId());
        infoQuery.setSupplierId(AdminUtil.getSupplierId());
        infoQuery.setProductId(prodId);
        ProductInfo productInfo = productSV.queryProductById(infoQuery);
        uiModel.addAttribute("productInfo",productInfo);
        //查询类目链
        ProductCatUniqueReq catUniqueReq = new ProductCatUniqueReq();
        catUniqueReq.setTenantId(AdminUtil.getTenantId());
        catUniqueReq.setProductCatId(productInfo.getProductCatId());
        List<ProductCatInfo> catLinkList =productCatSV.queryLinkOfCatById(catUniqueReq);
        uiModel.addAttribute("catLinkList",catLinkList);
        SysParamSingleCond paramSingleCond = new SysParamSingleCond();
        paramSingleCond.setTenantId(AdminUtil.getTenantId());
        paramSingleCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
        paramSingleCond.setParamCode(ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE);
        paramSingleCond.setColumnValue(productInfo.getProductType());
        //商品类型
        SysParam sysParam = cacheSV.getSysParamSingle(paramSingleCond);
        uiModel.addAttribute("prodType",sysParam.getColumnDesc());
        //标准品关键属性
        AttrQuery attrQuery = new AttrQuery();
        attrQuery.setTenantId(AdminUtil.getTenantId());
        attrQuery.setProductId(productInfo.getStandedProdId());
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
        AttrMap attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
        uiModel.addAttribute("attrAndVal",attrAndValService.getAttrAndVals(attrMap));
        //商品非关键属性
        ProdNoKeyAttr noKeyAttr = productManagerSV.queryNoKeyAttrOfProd(infoQuery);
        uiModel.addAttribute("noKeyAttr",noKeyAttr.getAttrInfoForProdList());
        uiModel.addAttribute("noKeyAttrValMap",noKeyAttr.getAttrValMap());
        //查询商品其他设置
        OtherSetOfProduct otherSet = productManagerSV.queryOtherSetOfProduct(infoQuery);
        uiModel.addAttribute("otherSet",otherSet);
        //个人受众
        ProdAudiencesInfo audiPerson = otherSet.getPersonAudiences();
        uiModel.addAttribute("audiPerson",audiPerson==null?"0":audiPerson.getUserId());
        //企业受众
        Map<String,ProdAudiencesInfo> entMap = otherSet.getEnterpriseMap();
        uiModel.addAttribute("audiEnt",audiType(entMap));
        uiModel.addAttribute("audiEnts",audiStr(entMap));
        //代理商受众
        Map<String,ProdAudiencesInfo> agentMap = otherSet.getAgentsMap();
        uiModel.addAttribute("audiAgent",audiType(agentMap));
        uiModel.addAttribute("audiAgents",audiStr(agentMap));

        //商品主图
        uiModel.addAttribute("prodPic",otherSet.getProductPics());
        //属性值图
        uiModel.addAttribute("attrValList",otherSet.getAttrValInfoList());
        uiModel.addAttribute("valPicMap",otherSet.getAttrValPics());

        SysParamMultiCond paramMultiCond = new SysParamMultiCond();
        paramMultiCond.setTenantId(AdminUtil.getTenantId());
        paramMultiCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
        paramMultiCond.setParamCode(ComCacheConstants.TypeProduct.PROD_UNIT);

        //有效期单位
        List<SysParam> prodUnits = cacheSV.getSysParamList(paramMultiCond);
        uiModel.addAttribute("prodUnits",prodUnits);
        //运营商
        paramMultiCond.setParamCode(ComCacheConstants.TypeProduct.BASIC_ORG_ID);
        List<SysParam> basicOrgIds = cacheSV.getSysParamList(paramMultiCond);
        uiModel.addAttribute("orgIds",basicOrgIds);
        //设置商品详情
        setProdDetail(productInfo.getProDetailContent(),uiModel);
        return "product/edit";
    }

    /**
     * 保存编辑信息
     * @return
     */
    @RequestMapping("/save")
    @ResponseBody
    public ResponseData<String> saveProductInfo(
            ProductEditInfo editInfo, String detailConVal, HttpSession session){
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
        initConsumer();
        //商品详情信息
        IDSSClient client= DSSClientFactory.getDSSClient(SysCommonConstants.ProductDetail.DSSNS);
        String fileId = editInfo.getProDetailContent();
        //若已经存在,则直接删除
        if (StringUtils.isNotBlank(fileId) && client.isIndexExist(fileId)){
            client.deleteById(fileId);
            fileId = "";
        }

        if (StringUtils.isNotBlank(detailConVal)){
        	fileId = client.insert(detailConVal);
        }
        logger.info("fileId="+fileId);
        editInfo.setProDetailContent(fileId);
        //非关键属性
        Map<Long, List<ProdAttrValInfo>> attrValMap = JSON.parseObject(editInfo.getNoKeyAttrStr(),
                new TypeReference<Map<Long, List<ProdAttrValInfo>>>(){});
        ProductInfoForUpdate prodInfo = new ProductInfoForUpdate();
        BeanUtils.copyProperties(prodInfo,editInfo);
        prodInfo.setTenantId(AdminUtil.getTenantId());
        prodInfo.setSupplierId(AdminUtil.getSupplierId());
        prodInfo.setOperId(AdminUtil.getAdminId(session));
        prodInfo.setNoKeyAttrValMap(attrValMap);
        //添加省份编码
        if ("N".equals(editInfo.getIsSaleNationwide()) && StringUtils.isNotBlank(editInfo.getTargetProd())){
        	prodInfo.setProvCodes(JSON.parseArray(editInfo.getTargetProd(),Long.class));
        }
        //添加企业受众
        if ("1".equals(editInfo.getAudiencesEnterprise()) && StringUtils.isNotBlank(editInfo.getAudiEntIds())){
        	prodInfo.setEnterpriseIds(JSON.parseArray(editInfo.getAudiEntIds(),String.class));
        }
        //代理商受众
        if ("1".equals(editInfo.getAudiencesAgents()) && StringUtils.isNotBlank(editInfo.getAudiAgentIds())){
        	prodInfo.setAgentIds(JSON.parseArray(editInfo.getAudiAgentIds(),String.class));
        }
        //商品图片
        Map<String,List<ProdPicInfo>> picInfoMap = genProdAttrPic(editInfo.getProdId(),editInfo.getProdPicStr());
        //属性值为0,表示为商品图片
        prodInfo.setProdPics(picInfoMap.get("0"));
        //属性值图片
        picInfoMap = genProdAttrPic(editInfo.getProdId(),editInfo.getProdAttrValPicStr());
        prodInfo.setAttrValPics(picInfoMap);
        if (StringUtils.isNotBlank(editInfo.getPresaleBeginTimeStr())){
            prodInfo.setPresaleBeginTime(
                    DateUtil.getTimestamp(editInfo.getPresaleBeginTimeStr(),DateUtil.DATETIME_FORMAT));
        }
        if (StringUtils.isNotBlank(editInfo.getPresaleEndTimeStr())){
            prodInfo.setPresaleEndTime(
                    DateUtil.getTimestamp(editInfo.getPresaleEndTimeStr(),DateUtil.DATETIME_FORMAT));
        }
        //保存商品详情信息
        BaseResponse response = productManagerSV.updateProduct(prodInfo);
        ResponseHeader header = response.getResponseHeader();

        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "更新失败:"+header.getResultMessage());
        }
        return responseData;
    }
    //设置商品详情
    public void setProdDetail(String fileId,Model uiModel){
        if (StringUtils.isBlank(fileId)){
            return;
        }
        IDSSClient client= DSSClientFactory.getDSSClient(SysCommonConstants.ProductDetail.DSSNS);
        String context = client.findById(fileId);
        if (StringUtils.isNotBlank(context)){
            JSONObject object = JSON.parseObject(context);
            uiModel.addAttribute("prodDetail",object.getString("content"));
        }
    }
    /** 
     * 受众类型 
     */
    private String audiType(Map<String,ProdAudiencesInfo> audiMap){
        //默认部分可见
        String audiEnt = "1";
        //代理商受众
        //为空表示全部不可见
        if (audiMap==null || audiMap.isEmpty()){
            audiEnt = "0";
        }
        //包含-1表示全部可见
        else if(audiMap.containsKey("-1")){
            audiEnt = "-1";
        }
        return audiEnt;
    }

    /**
     * 获取受众json格式字符串
     * @param audiMap
     * @return
     */
    private String audiStr(Map<String,ProdAudiencesInfo> audiMap){
        Map<String,String> strMap = new HashMap<>();
        //不是全部可见,且具有受众用户
        if (audiMap!=null && !audiMap.isEmpty() && !audiMap.containsKey("-1")){
            Set<Map.Entry<String,ProdAudiencesInfo>> mapEntry = audiMap.entrySet();
            for (Map.Entry<String,ProdAudiencesInfo> entry:mapEntry){
                strMap.put(entry.getKey(),entry.getValue().getUserName());
            }
        }
        return JSON.toJSONString(strMap);
    }

    /**
     * 获取商品主图图片
     * @param prodId
     * @param prodAttrPic
     * @return
     */
    private Map<String,List<ProdPicInfo>> genProdAttrPic(String prodId,String prodAttrPic){
        Map<String,List<ProdPicInfo>> attrPicMap = new HashMap<>();
        if (StringUtils.isBlank(prodAttrPic)){
        	return attrPicMap;
        }
        List<ProdPicInfo> picInfoList = JSON.parseArray(prodAttrPic,ProdPicInfo.class);
        for (ProdPicInfo picInfo:picInfoList){
            picInfo.setProdId(prodId);
            //页面序列号比数据库中小1,因此要进行+1处理
            picInfo.setSerialNumber((short)(picInfo.getSerialNumber()+1));
            if (picInfo.getSerialNumber().equals(new Short("1"))){
                picInfo.setIsMainPic("Y");
            }else{
            	picInfo.setIsMainPic("N");
            }
            List<ProdPicInfo> infoList = attrPicMap.get(picInfo.getAttrvalueDefId());
            if (infoList==null){
                infoList = new ArrayList<ProdPicInfo>();
                attrPicMap.put(picInfo.getAttrvalueDefId(),infoList);
            }
            infoList.add(picInfo);
        }
        return attrPicMap;
    }
    
}
