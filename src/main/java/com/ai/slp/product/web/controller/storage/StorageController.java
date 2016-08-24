package com.ai.slp.product.web.controller.storage;

import com.ai.opt.base.exception.BusinessException;
import com.ai.opt.base.vo.BaseListResponse;
import com.ai.opt.base.vo.BaseMapResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.common.api.cache.interfaces.ICacheSV;
import com.ai.slp.common.api.cache.param.SysParam;
import com.ai.slp.common.api.cache.param.SysParamMultiCond;
import com.ai.slp.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrQuery;
import com.ai.slp.product.api.normproduct.param.NormProdInfoResponse;
import com.ai.slp.product.api.normproduct.param.NormProdUniqueReq;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.SkuInfo;
import com.ai.slp.product.api.product.param.SkuSetForProduct;
import com.ai.slp.product.api.product.param.StoGroupInfoQuery;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.*;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.controller.product.ProdQueryController;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/storage")
public class StorageController {
    private static final Logger LOG = LoggerFactory.getLogger(ProdQueryController.class);

    @Autowired
    private ProdCatService prodCatService;
    @Autowired
    private AttrAndValService attrAndValService;

    /**
     * 显示标准品库存编辑页面
     *
     * @param standedProdId
     * @return
     */
    @RequestMapping("/{id}")
    public String storageEdit(@PathVariable("id") String standedProdId, Model uiModel) {
        //标准品ID
        uiModel.addAttribute("standedProdId", standedProdId);
        //查询标准品信息
        NormProdUniqueReq normProdUniqueReq = new NormProdUniqueReq();
        normProdUniqueReq.setProductId(standedProdId);
        normProdUniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        normProdUniqueReq.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
        INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
        NormProdInfoResponse normProdInfoResponse = normProductSV.queryProducById(normProdUniqueReq);
        uiModel.addAttribute("normProdInfo", normProdInfoResponse);
        //查询类目链
        uiModel.addAttribute("catLinkList", prodCatService.queryLink(normProdInfoResponse.getProductCatId()));
        uiModel.addAttribute("productCatId", normProdInfoResponse.getProductCatId());
        //商品类型
        SysParamSingleCond paramSingleCond = new SysParamSingleCond();
        paramSingleCond.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        paramSingleCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
        paramSingleCond.setParamCode(ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE);
        paramSingleCond.setColumnValue(normProdInfoResponse.getProductType());
        ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        SysParam sysParam = cacheSV.getSysParamSingle(paramSingleCond);
        uiModel.addAttribute("prodType", sysParam.getColumnDesc());
        //标准品关键属性
        AttrQuery attrQuery = new AttrQuery();
        attrQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        attrQuery.setProductId(normProdInfoResponse.getProductId());
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
        AttrMap attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
        uiModel.addAttribute("keyAttr", attrAndValService.getAttrAndVals(attrMap));
        //查询销售属性
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
        attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
        uiModel.addAttribute("saleAttr", attrAndValService.getAttrAndVals(attrMap));

        //查询库存组和库存信息
        StorageGroupQuery storageGroupQuery = new StorageGroupQuery();
        storageGroupQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        storageGroupQuery.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
        storageGroupQuery.setProductId(normProdInfoResponse.getProductId());
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        BaseListResponse<StorageGroupRes> storageGroupResList = storageSV.queryGroupInfoByNormProdId(storageGroupQuery);
        Map<String,SysParam> paramMap = getStorageStatus();
        for (StorageGroupRes storageGroupRes : storageGroupResList.getResult()) {
            // 获取库存组状态名
            String state = storageGroupRes.getState();
            paramSingleCond = new SysParamSingleCond(SysCommonConstants.COMMON_TENANT_ID,
                    ComCacheConstants.StateStorage.STORAGEGROUP_TYPR_CODE, ComCacheConstants.StateStorage.PARAM_CODE, state);
            String stateName = cacheSV.getSysParamSingle(paramSingleCond).getColumnDesc();
            storageGroupRes.setStateName(stateName);
            // 库存组优先级
            for (Short key : storageGroupRes.getStorageList().keySet()) {
                // 获取库存状态名
                for (StorageRes storageRes : storageGroupRes.getStorageList().get(key)) {
                    SysParam param = paramMap.get(storageRes.getState());
                    if (param!=null)
                    storageRes.setStateName(param.getColumnDesc());
                }
            }
        }
        uiModel.addAttribute("storGroupList", storageGroupResList.getResult());
        return "storage/storageEdit";
    }



    /**
     * 进入页面调用-加载类目
     */
    @RequestMapping(value = {"","/","/list"})
    public String editQuery(Model uiModel) {
        Map<Short, List<ProdCatInfo>> productCatMap = prodCatService.loadCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoMap", productCatMap);
        return "storage/storageList";
    }

    /**
     * 获取库存组的SKU
     * @param groupId
     * @return
     */
    @RequestMapping("/sku/{id}")
    @ResponseBody
    public ResponseData<SkuSetForProduct> querySku(@PathVariable("id")String groupId){
        ResponseData<SkuSetForProduct> responseData;
        IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        StoGroupInfoQuery infoQuery = new StoGroupInfoQuery();
        infoQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        infoQuery.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
        infoQuery.setGroupId(groupId);
        SkuSetForProduct skuSetForProduct = productSV.querySkuSetForGroup(infoQuery);
        ResponseHeader header = skuSetForProduct.getResponseHeader();
        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<SkuSetForProduct>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else
            responseData = new ResponseData<SkuSetForProduct>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",skuSetForProduct);
        return responseData;
    }

    /**
     * 获取库存状态字典信息
     * @return
     */
    private Map<String,SysParam> getStorageStatus(){
        ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        SysParamMultiCond multiCond = new SysParamMultiCond(SysCommonConstants.COMMON_TENANT_ID,
                ComCacheConstants.StateStorage.STORAGE_TYPR_CODE, ComCacheConstants.StateStorage.PARAM_CODE);
        List<SysParam> sysParamList = cacheSV.getSysParamList(multiCond);
        Map<String,SysParam> paramMap = new HashMap<>();
        for (SysParam sysParam:sysParamList){
            paramMap.put(sysParam.getColumnValue(),sysParam);
        }
        return paramMap;
    }
    /**
     * 获取库存下SKU库存的信息
     * @param storageId
     * @return
     */
    @RequestMapping("/skuSto/{id}")
    @ResponseBody
    private ResponseData<SkuSetForProduct> querySkuStorage(@PathVariable("id")String storageId,String groupId){
        ResponseData<SkuSetForProduct> responseData;
        IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        StoGroupInfoQuery infoQuery = new StoGroupInfoQuery();
        infoQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        infoQuery.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
        infoQuery.setGroupId(groupId);
        SkuSetForProduct skuSetForProduct = productSV.querySkuSetForGroup(infoQuery);
        ResponseHeader header = skuSetForProduct.getResponseHeader();
        try {
            //保存错误
            if (header!=null && !header.isSuccess()){
                throw new BusinessException(header.getResultCode(),header.getResultMessage());
            }
            IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
            StorageUniQuery query = new StorageUniQuery();
            query.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            query.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
            query.setStorageId(storageId);
            //获取SKU库存信息
            BaseMapResponse<String, SkuStorageInfo> mapResponse = storageSV.querySkuStorageById(query);
            header = skuSetForProduct.getResponseHeader();
            if (header!=null && !header.isSuccess()){
                throw new BusinessException(header.getResultCode(),header.getResultMessage());
            }
            Map<String, SkuStorageInfo> infoMap = mapResponse.getResult();
            List<SkuInfo> skuInfoList = skuSetForProduct.getSkuInfoList();
            for (SkuInfo skuInfo:skuInfoList){
                SkuStorageInfo info = infoMap.get(skuInfo.getSkuId());
                if (info!=null)
                    skuInfo.setTotalNum(info.getTotalNum());
            }
            responseData = new ResponseData<SkuSetForProduct>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",skuSetForProduct);
        }catch (BusinessException ex){
            responseData = new ResponseData<SkuSetForProduct>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+ex.getMessage());
        }

        return responseData;
    }
}
