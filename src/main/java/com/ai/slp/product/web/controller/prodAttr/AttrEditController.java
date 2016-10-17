package com.ai.slp.product.web.controller.prodAttr;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.constants.ExceptCodeConstants;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.productcat.interfaces.IAttrAndValDefSV;
import com.ai.slp.product.api.productcat.param.AttrPam;
import com.ai.slp.product.api.productcat.param.AttrParam;
import com.ai.slp.product.web.util.AdminUtil;

/**
 * 
 * 属性的编辑功能
 * @time 2016-8-16
 * @author jiawen
 *
 */
@Controller
@RequestMapping("/attrEdit")
public class AttrEditController {
	private static final Logger logger = LoggerFactory.getLogger(AttrEditController.class);
	
	/**
	 * 单个属性的编辑
	 */
	@RequestMapping("/updateAttr")
	@ResponseBody
	public ResponseData<String> updateAttr(AttrParam attrParam, HttpSession session) {
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		//设置租户ID
		attrParam.setTenantId(AdminUtil.getTenantId());
		//设置操作人ID
		attrParam.setOperId(AdminUtil.getAdminId(session));
		
		BaseResponse response = attrAndValDefSV.updateAttr(attrParam);
		ResponseHeader header = response.getResponseHeader();
		if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:"+header.getResultMessage());
        }
        return responseData;
	}
	/**
	 * 单个属性的删除
	 */
	@RequestMapping("/delAttr/{id}")
	@ResponseBody
	public ResponseData<String> delAttr(@PathVariable("id") String attrId, HttpSession session){
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "删除成功");
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		AttrPam attrPam = new AttrPam();
		//设置租户ID
		attrPam.setTenantId(AdminUtil.getTenantId());
		//设置操作人ID
		attrPam.setOperId(AdminUtil.getAdminId(session));
		//设置属性ID
		Long attrIdLong = Long.valueOf(attrId).longValue();
		attrPam.setAttrId(attrIdLong);
		
		
		//执行删除
		BaseResponse response = attrAndValDefSV.deleteAttr(attrPam);
		
		ResponseHeader header = response==null?null:response.getResponseHeader();
        if (header==null || !header.isSuccess()){
            String errorCode = header==null?ExceptCodeConstants.Special.SYSTEM_ERROR:header.getResultCode();
            String errMsg = header==null?"未知错误":header.getResultMessage();
            logger.error("Delete attr is error,errorCode:{},errorMsg:{}",errorCode,errMsg);
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, errMsg);
        }
        return responseData;
	}
}
