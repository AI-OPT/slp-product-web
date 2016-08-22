package com.ai.slp.product.web.controller.storage;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.NameUpReq;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.util.AdminUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
}
