package com.ai.slp.product.web.controller.storage;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.NameUpReq;
import com.ai.slp.product.api.storage.param.STOStorageGroup;
import com.ai.slp.product.api.storage.param.StoGroupStatus;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.util.AdminUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
        nameUpReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        nameUpReq.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
        nameUpReq.setOperId(AdminUtil.getAdminId(session));
        nameUpReq.setId(groupId);
        nameUpReq.setName(groupName);
        BaseResponse baseResponse = storageSV.updateStorageGroupName(nameUpReq);
        ResponseHeader header = baseResponse.getResponseHeader();
        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK","");
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
        groupStatus.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        groupStatus.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
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
        }else
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK","");
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
        storageGroup.setTenantId(SysCommonConstants.COMMON_TENANT_ID);

        BaseResponse baseResponse = storageSV.createStorageGroup(storageGroup);
        ResponseHeader header = baseResponse.getResponseHeader();
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "更新失败:" + header.getResultMessage());
        }
        return responseData;
    }
}
