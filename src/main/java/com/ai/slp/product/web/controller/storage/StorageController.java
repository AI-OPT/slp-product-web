package com.ai.slp.product.web.controller.storage;

import com.ai.opt.base.vo.BaseListResponse;
import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.common.api.cache.interfaces.ICacheSV;
import com.ai.slp.common.api.cache.param.SysParam;
import com.ai.slp.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrQuery;
import com.ai.slp.product.api.normproduct.param.NormProdInfoResponse;
import com.ai.slp.product.api.normproduct.param.NormProdUniqueReq;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.*;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.controller.product.ProdQueryController;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
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
        storageGroupQuery.setProductId(normProdInfoResponse.getProductId());
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        BaseListResponse<StorageGroupRes> storageGroupResList = storageSV.queryGroupInfoByNormProdId(storageGroupQuery);
        for (StorageGroupRes storageGroupRes : storageGroupResList.getResult()) {
            // 获取库存组状态名
            String state = storageGroupRes.getState();
            paramSingleCond = new SysParamSingleCond(SysCommonConstants.COMMON_TENANT_ID,
                    ComCacheConstants.StateStorage.STORAGEGROUP_TYPR_CODE, ComCacheConstants.StateStorage.PARAM_CODE, state);
            String stateName = cacheSV.getSysParamSingle(paramSingleCond).getColumnDesc();
            storageGroupRes.setStateName(stateName);
            // 获取库存状态名
            for (Short key : storageGroupRes.getStorageList().keySet()) {
                for (StorageRes storageRes : storageGroupRes.getStorageList().get(key)) {
                    String storState = storageRes.getState();
                    paramSingleCond = new SysParamSingleCond(SysCommonConstants.COMMON_TENANT_ID,
                            ComCacheConstants.StateStorage.STORAGE_TYPR_CODE, ComCacheConstants.StateStorage.PARAM_CODE, storState);
                    String storStateName = cacheSV.getSysParamSingle(paramSingleCond).getColumnDesc();
                    storageRes.setStateName(storStateName);
                }
            }
        }
        uiModel.addAttribute("storGroupList", storageGroupResList.getResult());
        return "storage/storageEdit";
    }

    /**
     * 添加库存组
     *
     * @param request
     * @param session
     * @return
     */
    @RequestMapping("/addGroup")
    @ResponseBody
    public ResponseData<String> addStorGroup(HttpServletRequest request, HttpSession session) {
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        STOStorageGroup storageGroup = new STOStorageGroup();
        storageGroup.setCreateId(AdminUtil.getAdminId(session));
        storageGroup.setStandedProdId(request.getParameter("standedProdId"));
        storageGroup.setStorageGroupName(request.getParameter("storageGroupName"));
        storageGroup.setTenantId(SysCommonConstants.COMMON_TENANT_ID);

        BaseResponse baseResponse = storageSV.createStorageGroup(storageGroup);
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "更新失败:" + header.getResultMessage());
        }
        return responseData;
    }

    /**
     * 添加库存
     *
     * @param request
     * @param session
     * @return
     */
    @RequestMapping("/addStorage")
    @ResponseBody
    public ResponseData<String> addStorage(HttpServletRequest request, HttpSession session) {
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        STOStorage storage = new STOStorage();
        storage.setOperId(AdminUtil.getAdminId(session));
        storage.setProductCatId(request.getParameter("productCatId"));
        storage.setStorageName(request.getParameter("storageName"));
        storage.setStorageGroupId(request.getParameter("storGroupId"));
        storage.setPriorityNumber(Short.parseShort(request.getParameter("priorityNumber")));
        storage.setTotalNum(Long.parseLong(request.getParameter("totalNum")));
        storage.setWarnNum(Long.parseLong(request.getParameter("warnNum")));
        storage.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        BaseResponse baseResponse = storageSV.saveStorage(storage);
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "更新失败:" + header.getResultMessage());
        }
        return responseData;
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
}
