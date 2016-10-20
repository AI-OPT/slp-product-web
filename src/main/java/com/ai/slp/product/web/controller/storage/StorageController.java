package com.ai.slp.product.web.controller.storage;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.exception.BusinessException;
import com.ai.opt.base.vo.BaseListResponse;
import com.ai.opt.base.vo.BaseMapResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.SkuInfo;
import com.ai.slp.product.api.product.param.SkuSetForProduct;
import com.ai.slp.product.api.product.param.StoGroupInfoQuery;
import com.ai.slp.product.api.product.param.StorageInfoQuery;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.*;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.controller.product.ProdQueryController;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.service.StandedProdService;
import com.ai.slp.product.web.service.StorageService;
import com.ai.slp.product.web.util.AdminUtil;

@Controller
@RequestMapping("/storage")
public class StorageController {
    private static final Logger LOG = LoggerFactory.getLogger(ProdQueryController.class);

    @Autowired
    private ProdCatService prodCatService;
    @Autowired
    private StandedProdService standedProdService;
    @Autowired
    private StorageService storageService;

    /**
     * 显示标准品库存编辑页面
     *
     * @param standedProdId
     * @return
     */
    @RequestMapping("/{id}")
    public String storageEdit(@PathVariable("id") String standedProdId, Model uiModel) {
        //获取标准品信息
        standedProdService.getInfo(standedProdId,uiModel);

        //查询库存组和库存信息
        StorageGroupQuery storageGroupQuery = new StorageGroupQuery();
        storageGroupQuery.setTenantId(AdminUtil.getTenantId());
        storageGroupQuery.setSupplierId(AdminUtil.getSupplierId());
        storageGroupQuery.setProductId(standedProdId);
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        BaseListResponse<StorageGroupRes> storageGroupResList = storageSV.queryGroupInfoByNormProdId(storageGroupQuery);
        Map<String,SysParam> paramMap = storageService.getStorageStatus();
        ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        SysParamSingleCond paramSingleCond = new SysParamSingleCond();
        paramSingleCond.setTenantId(AdminUtil.getTenantId());
        paramSingleCond.setTypeCode(ComCacheConstants.StateStorage.STORAGEGROUP_TYPR_CODE);
        paramSingleCond.setParamCode(ComCacheConstants.StateStorage.PARAM_CODE);
        for (StorageGroupRes storageGroupRes : storageGroupResList.getResult()) {
            // 获取库存组状态名
            paramSingleCond.setColumnValue(storageGroupRes.getState());
            String stateName = cacheSV.getSysParamSingle(paramSingleCond).getColumnDesc();
            storageGroupRes.setStateName(stateName);
            // 库存组优先级
            for (Short key : storageGroupRes.getStorageList().keySet()) {
                // 获取库存状态名
                for (StorageRes storageRes : storageGroupRes.getStorageList().get(key)) {
                    SysParam param = paramMap.get(storageRes.getState());
                    if (param!=null){
                    	storageRes.setStateName(param.getColumnDesc());
                    }
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
        List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoList", productCatMap);
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
        infoQuery.setTenantId(AdminUtil.getTenantId());
        infoQuery.setSupplierId(AdminUtil.getSupplierId());
        infoQuery.setGroupId(groupId);
        SkuSetForProduct skuSetForProduct = productSV.querySkuSetForGroup(infoQuery);
        ResponseHeader header = skuSetForProduct.getResponseHeader();
        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<SkuSetForProduct>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else{
            responseData = new ResponseData<SkuSetForProduct>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",skuSetForProduct);
        }
        return responseData;
    }
    /**
     * 获取库存下SKU库存的信息
     * @param storageId
     * @return
     */
    @RequestMapping("/skuSto/{id}")
    @ResponseBody
    public ResponseData<SkuSetForProduct> querySkuStorage(@PathVariable("id")String storageId,String groupId){
        ResponseData<SkuSetForProduct> responseData;
        IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        StorageInfoQuery infoQuery = new StorageInfoQuery();
        infoQuery.setTenantId(AdminUtil.getTenantId());
        infoQuery.setSupplierId(AdminUtil.getSupplierId());
        infoQuery.setStorageId(storageId);
        SkuSetForProduct skuSetForProduct = productSV.querySkuSetForStorage(infoQuery);
        ResponseHeader header = skuSetForProduct.getResponseHeader();
        try {
            //保存错误
            if (header!=null && !header.isSuccess()){
                throw new BusinessException(header.getResultCode(),header.getResultMessage());
            }
            IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
            StorageUniQuery query = new StorageUniQuery();
            query.setTenantId(AdminUtil.getTenantId());
            query.setSupplierId(AdminUtil.getSupplierId());
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
                if (info!=null){
                	skuInfo.setTotalNum(info.getTotalNum());
                }
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
