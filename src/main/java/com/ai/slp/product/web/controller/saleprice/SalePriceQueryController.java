package com.ai.slp.product.web.controller.saleprice;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
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

import java.util.List;

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
}
