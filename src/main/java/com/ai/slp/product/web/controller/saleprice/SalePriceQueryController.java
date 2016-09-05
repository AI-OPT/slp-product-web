package com.ai.slp.product.web.controller.saleprice;

import com.ai.opt.base.exception.BusinessException;
import com.ai.opt.base.vo.BaseMapResponse;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.SkuInfo;
import com.ai.slp.product.api.product.param.SkuSetForProduct;
import com.ai.slp.product.api.product.param.StoGroupInfoQuery;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.SkuPriceOfGroupPnReq;
import com.ai.slp.product.api.storage.param.StorageGroupOfNormProdPage;
import com.ai.slp.product.api.storage.param.StorageGroupRes;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.service.StandedProdService;
import com.ai.slp.product.web.service.StorageService;
import com.ai.slp.product.web.util.AdminUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * 销售价管理
 * Created by jackieliu on 16/8/30.
 */
@Controller
@RequestMapping("/saleprice/query")
public class SalePriceQueryController {
    private static Logger logger = LoggerFactory.getLogger(SalePriceQueryController.class);

    @Autowired
    StandedProdService standedProdService;
    @Autowired
    StorageService storageService;
    @Autowired
    ProdCatService prodCatService;
    /**
     * 商品列表页
     * @return
     */
    @RequestMapping(value = {"","/"})
    public String productList(Model uiModel){
        List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoList", productCatMap);
        return "/saleprice/salePriceList";
    }

    /**
     * 查询商品价格信息
     * @param id
     * @return
     */
    @RequestMapping("/{id}")
    public String editView(@PathVariable("id")String id, Model uiModel){
        standedProdService.getInfo(id,uiModel);
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        StorageGroupOfNormProdPage prodPage = new StorageGroupOfNormProdPage();
        prodPage.setTenantId(AdminUtil.getTenantId());
        prodPage.setSupplierId(AdminUtil.getSupplierId());
        prodPage.setStandedProdId(id);
        PageInfoResponse<StorageGroupRes> response = storageSV.queryGroupByProdIdForSalePrice(prodPage);
        uiModel.addAttribute("groupList",response.getResult());
        uiModel.addAttribute("stoStatusMap",storageService.getStorageStatus());
        return "/saleprice/salePriceEdit";
    }

    @RequestMapping("/sku/{id}")
    @ResponseBody
    public ResponseData<SkuSetForProduct> querySkuInfo(@PathVariable("id") String groupId,Short groupPn){
        //查看库存组下sku信息
        ResponseData<SkuSetForProduct> responseData;
        IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        StoGroupInfoQuery infoQuery = new StoGroupInfoQuery();
        infoQuery.setTenantId(AdminUtil.getTenantId());
        infoQuery.setSupplierId(AdminUtil.getSupplierId());
        infoQuery.setGroupId(groupId);
        SkuSetForProduct skuSetForProduct = productSV.querySkuSetForGroup(infoQuery);
        ResponseHeader header = skuSetForProduct.getResponseHeader();
        try {
            //保存错误
            if (header!=null && !header.isSuccess()){
                throw new BusinessException(header.getResultCode(),header.getResultMessage());
            }
            IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
            SkuPriceOfGroupPnReq pnReq = new SkuPriceOfGroupPnReq();
            pnReq.setTenantId(AdminUtil.getTenantId());
            pnReq.setSupplierId(AdminUtil.getSupplierId());
            pnReq.setGroupId(groupId);
            pnReq.setPriorityNum(groupPn);
            BaseMapResponse<String,Long> mapResponse = storageSV.querySkuPriceByGroupPn(pnReq);
            header = skuSetForProduct.getResponseHeader();
            if (header!=null && !header.isSuccess()){
                throw new BusinessException(header.getResultCode(),header.getResultMessage());
            }
            Map<String, Long> infoMap = mapResponse.getResult();
            List<SkuInfo> skuInfoList = skuSetForProduct.getSkuInfoList();
            for (SkuInfo skuInfo:skuInfoList){
                if (!infoMap.containsKey(skuInfo.getSkuId())){
                    skuInfoList.remove(skuInfo);
                    continue;
                }
                skuInfo.setSalePrice(infoMap.get(skuInfo.getSkuId()));
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
