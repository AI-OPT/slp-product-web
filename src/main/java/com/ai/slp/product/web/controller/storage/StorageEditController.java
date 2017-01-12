package com.ai.slp.product.web.controller.storage;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.ProductInfo;
import com.ai.slp.product.api.product.param.ProductInfoQuery;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.*;
import com.ai.slp.product.web.constants.ProductCommentConstants;
import com.ai.slp.product.web.constants.ProductConstants;
import com.ai.slp.product.web.constants.StorageAllConstants;
import com.ai.slp.product.web.constants.StorageConstants;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

/**
 * Created by jackieliu on 16/8/22.
 */
@Controller
@RequestMapping("/storage/edit")
public class StorageEditController {

    /**
     * 更新库组名称
     * @param session
     * @return
     */
    @RequestMapping("/upGroupName/{id}")
    @ResponseBody
    public ResponseData<String> upGroupName(
            @PathVariable("id")String groupId,String groupName, HttpSession session){
        ResponseData<String> responseData;
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        NameUpReq nameUpReq = new NameUpReq();
        nameUpReq.setTenantId(AdminUtil.getTenantId());
        nameUpReq.setSupplierId(AdminUtil.getSupplierId());
        nameUpReq.setOperId(AdminUtil.getAdminId(session));
        nameUpReq.setId(groupId);
        nameUpReq.setName(groupName);
        BaseResponse baseResponse = storageSV.updateStorageGroupName(nameUpReq);
        ResponseHeader header = baseResponse.getResponseHeader();
        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else{
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK","");
        }
        return responseData;
    }

    /**
     * 更新库组状态
     * @param groupId
     * @param status
     * @param session
     * @return
     */
    @RequestMapping("/upGroupStatus/{id}")
    @ResponseBody
    public ResponseData<String> upGroupStatus(
            @PathVariable("id")String groupId,String status, HttpSession session){
        ResponseData<String> responseData;
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        StoGroupStatus groupStatus = new StoGroupStatus();
        groupStatus.setTenantId(AdminUtil.getTenantId());
        groupStatus.setSupplierId(AdminUtil.getSupplierId());
        groupStatus.setOperId(AdminUtil.getAdminId(session));
        groupStatus.setGroupId(groupId);
        groupStatus.setState(status);
        BaseResponse baseResponse = storageSV.chargeStorageGroupStatus(groupStatus);
        ResponseHeader header = baseResponse.getResponseHeader();
        //TODO...模拟成功
//        ResponseHeader header = new ResponseHeader(true, ExceptCodeConstants.Special.SUCCESS,"");
        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, "更新状态 "+header.getResultMessage());
        }else{
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK","");
        }
        return responseData;
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
        storageGroup.setTenantId(AdminUtil.getTenantId());

        BaseResponse baseResponse = storageSV.createStorageGroup(storageGroup);
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "更新失败:" + header.getResultMessage());
        }
        return responseData;
    }

    /**
     * 添加库存
     * @param storage
     * @param session
     * @return
     */
    @RequestMapping("/addStorage")
    @ResponseBody
    public ResponseData<String> addStorage(
            STOStorage storage,@RequestParam(value = "skuNumMap",required = false)String skuNumMap, HttpSession session){
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        storage.setOperId(AdminUtil.getAdminId(session));
        storage.setTenantId(AdminUtil.getTenantId());
        storage.setSupplierId(AdminUtil.getSupplierId());
        //若SKU库存量不为空
        if (StringUtils.isNotBlank(skuNumMap)){
            Map<String,Long> skuMap = JSON.parseObject(skuNumMap,new TypeReference<Map<String, Long>>() {});
            storage.setSkuStorageNum(skuMap);
        }
        BaseResponse baseResponse = storageSV.saveStorage(storage);
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:" + header.getResultMessage());
        }
        return responseData;
    }

    /**
     * 变更库存状态
     * @param stoId
     * @param session
     * @return
     */
    @RequestMapping("/status/{id}")
    @ResponseBody
    public ResponseData<String> changeStoStatus(
            @PathVariable("id")String stoId,String status,HttpSession session){
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "操作成功");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        StorageStatus storageStatus = new StorageStatus();
        storageStatus.setTenantId(AdminUtil.getTenantId());
        storageStatus.setSupplierId(AdminUtil.getSupplierId());
        storageStatus.setStorageId(stoId);
        storageStatus.setOperId(AdminUtil.getAdminId(session));
        storageStatus.setState(status);
        BaseResponse baseResponse = storageSV.chargeStorageStatus(storageStatus);
        
        //库存组re--根据库存ID获取库存组id
        String tenantId = AdminUtil.getTenantId();
        String supplierId = AdminUtil.getSupplierId();
        Long adminId = AdminUtil.getAdminId(session);
        
        StorageUniQuery storage = new StorageUniQuery();
        storage.setTenantId(tenantId);
        storage.setSupplierId(supplierId);
        storage.setStorageId(stoId);
        StorageRes storageRes = storageSV.queryStorageById(storage);
        String groupId = storageRes.getStorageGroupId();
        String prodId = storageRes.getProdId();
        
        IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        ProductInfoQuery product = new ProductInfoQuery();
        product.setTenantId(tenantId);
        product.setSupplierId(supplierId);
        product.setOperId(adminId);
        product.setProductId(prodId);
        ProductInfo productInfo = productSV.queryProductById(product);
        
        //库存id--获取库存组--获取状态
        StorageGroupQuery groupQuery = new StorageGroupQuery();
        groupQuery.setTenantId(tenantId);
        groupQuery.setSupplierId(supplierId);
        groupQuery.setGroupId(groupId);
        groupQuery.setProductId(productInfo.getStandedProdId());
        StorageGroupRes queryGroup = storageSV.queryGroupInfoByGroupId(groupQuery);
        
        String state = queryGroup.getState();
//        if (state != null && !ProductConstants.Product.State.IN_SALE.equals(productInfo.getState())) {
        if (state != null) {
        	if (StorageAllConstants.StorageGroup.State.ACTIVE.equals(state) 
        			|| StorageAllConstants.StorageGroup.State.AUTO_ACTIVE.equals(state)) {
        		StoGroupStatus stogroupstatus = new StoGroupStatus();
        		stogroupstatus.setTenantId(tenantId);
        		stogroupstatus.setSupplierId(supplierId);                
        		stogroupstatus.setGroupId(groupId);
        		stogroupstatus.setOperId(adminId);
        		stogroupstatus.setState(StorageAllConstants.StorageGroup.State.STOP);
        		storageSV.chargeStorageGroupStatus(stogroupstatus);
        		StoGroupStatus stogroupstatus2 = new StoGroupStatus();
        		stogroupstatus2.setTenantId(tenantId);
        		stogroupstatus2.setSupplierId(supplierId);
        		stogroupstatus2.setGroupId(groupId);
        		stogroupstatus2.setOperId(adminId);
        		stogroupstatus2.setState(StorageAllConstants.StorageGroup.State.ACTIVE);
        		storageSV.chargeStorageGroupStatus(stogroupstatus2);
        	}else{
        		StoGroupStatus stogroupstatus = new StoGroupStatus();
        		stogroupstatus.setTenantId(tenantId);
        		stogroupstatus.setSupplierId(supplierId);                
        		stogroupstatus.setGroupId(groupId);
        		stogroupstatus.setOperId(adminId);
        		//stogroupstatus.setState(StorageAllConstants.StorageGroup.State.STOP);
        		stogroupstatus.setState(StorageAllConstants.StorageGroup.State.ACTIVE);
        		storageSV.chargeStorageGroupStatus(stogroupstatus);
        		StoGroupStatus stogroupstatus2 = new StoGroupStatus();
        		stogroupstatus2.setTenantId(tenantId);
        		stogroupstatus2.setSupplierId(supplierId);
        		stogroupstatus2.setGroupId(groupId);
        		stogroupstatus2.setOperId(adminId);
        		//stogroupstatus2.setState(StorageAllConstants.StorageGroup.State.ACTIVE);
        		stogroupstatus2.setState(StorageAllConstants.StorageGroup.State.STOP);
        		storageSV.chargeStorageGroupStatus(stogroupstatus2);
        	}
        }
        
        
      		
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "操作失败:" + header.getResultMessage());
        }
        return responseData;
    }

    /**
     * 变更库存名称
     * @param stoId
     * @param session
     * @return
     */
    @RequestMapping("/stoName/{id}")
    @ResponseBody
    public ResponseData<String> updateStoName(
            @PathVariable("id")String stoId,String stoName,HttpSession session){
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "操作成功");
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        NameUpReq upReq = new NameUpReq();
        upReq.setTenantId(AdminUtil.getTenantId());
        upReq.setSupplierId(AdminUtil.getSupplierId());
        upReq.setId(stoId);
        upReq.setOperId(AdminUtil.getAdminId(session));
        upReq.setName(stoName);
        BaseResponse baseResponse = storageSV.updateStorageName(upReq);
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "操作失败:" + header.getResultMessage());
        }
        return responseData;
    }

}
