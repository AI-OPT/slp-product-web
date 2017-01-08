package com.ai.slp.product.web.controller.saleprice;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.StoNoSkuSalePrice;
import com.ai.slp.product.api.storage.param.StoNoSkuSalePriceReq;
import com.ai.slp.product.api.storage.param.StoSkuSalePrice;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

/**
 * 销售价编辑
 * Created by jackieliu on 16/8/30.
 */
@Controller
@RequestMapping("/saleprice/edit")
public class SalePriceEditController {

    /**
     * 更新未有销售属性的销售价
     * @return
     */
    @RequestMapping("/nosku")
    @ResponseBody
    public ResponseData<String> updateSalePrice(String salePriceStr){
        ResponseData<String> responseData = new ResponseData<String>(
                ResponseData.AJAX_STATUS_SUCCESS, "更新成功","");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        StoNoSkuSalePriceReq salePriceReq = new StoNoSkuSalePriceReq();
        salePriceReq.setTenantId(AdminUtil.getTenantId());
        salePriceReq.setSupplierId(AdminUtil.getSupplierId());
        salePriceReq.setOperId(AdminUtil.getAdminId());
        List<StoNoSkuSalePrice> salePriceList = JSON.parseArray(salePriceStr,StoNoSkuSalePrice.class);
        salePriceReq.setStorageSalePrice(salePriceList);
        BaseResponse baseResponse = storageSV.updateMultiStorageSalePrice(salePriceReq);
        //保存错误
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, "更新销售价失败:"+header.getResultMessage());
        }
        return responseData;
    }

    /** 
     * 更新销售价 
     */
    @RequestMapping("/sku/{id}")
    @ResponseBody
    public ResponseData<String> updateSalePrice(
            @PathVariable("id")String groupId,Short groupPn,String skuPriceStr){
        ResponseData<String> responseData =
                new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS,"更新成功");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        StoSkuSalePrice skuSalePrice = new StoSkuSalePrice();
        skuSalePrice.setTenantId(AdminUtil.getTenantId());
        skuSalePrice.setSupplierId(AdminUtil.getSupplierId());
        skuSalePrice.setOperId(AdminUtil.getAdminId());
        skuSalePrice.setGroupId(groupId);
        skuSalePrice.setPriorityNum(groupPn);
        Map<String,Long> priceMap = JSON.parseObject(skuPriceStr,new TypeReference<Map<String,Long>>(){});
        skuSalePrice.setStorageSalePrice(priceMap);
        BaseResponse baseResponse = storageSV.updateSkuStorageSalePrice(skuSalePrice);
        //保存错误
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, "更新销售价失败:"+header.getResultMessage());
        }
        return responseData;
    }
}
