package com.ai.slp.product.web.controller.prodAttr;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.constants.ExceptCodeConstants;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.common.api.cache.interfaces.ICacheSV;
import com.ai.slp.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.productcat.interfaces.IAttrAndValDefSV;
import com.ai.slp.product.api.productcat.param.AttrDefInfo;
import com.ai.slp.product.api.productcat.param.AttrDefParam;
import com.ai.slp.product.api.productcat.param.AttrInfo;
import com.ai.slp.product.api.productcat.param.AttrPam;
import com.ai.slp.product.api.productcat.param.AttrParam;
import com.ai.slp.product.api.productcat.param.AttrVal;
import com.ai.slp.product.api.productcat.param.AttrValInfo;
import com.ai.slp.product.api.productcat.param.AttrValPageQuery;
import com.ai.slp.product.api.productcat.param.AttrValParam;
import com.ai.slp.product.api.productcat.param.AttrValUniqueReq;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.model.prodAttr.ProdAttrInfo;
import com.ai.slp.product.web.model.prodAttr.ProdAttrValueInfo;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;

/**
 * 属性值管理
 * @author jiawen
 * @time 2016-8-16
 *
 */
@Controller
@RequestMapping("/attrManage")
public class AttrValueController {
	private static Logger LOG = LoggerFactory.getLogger(AttrController.class);
	/**
	 * 进入页面
	 */
	@RequestMapping("/getAttrValue/{id}")
	public String attrList(@PathVariable("id")String attrId,Model uiModel) {
		/*//设置属性ID
		Long attrIdLong = Long.valueOf(attrId).longValue();
		pageQuery.setAttrId(attrIdLong);*/
		uiModel.addAttribute("attrId", attrId);
		return "prodAttr/attrManage";
	}
	
	/**
	 * 查询属性值列表
	 */
	@RequestMapping("/getAttrValueList")
	@ResponseBody
	public ResponseData<PageInfoResponse<AttrValInfo>> queryAttrValueList(HttpServletRequest request,AttrValPageQuery pageQuery){
		ResponseData<PageInfoResponse<AttrValInfo>> responseData = null;
		
		try {
			//查询条件
		//	queryBuilder(request, pageQuery);
			pageQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
			
			PageInfoResponse<AttrValInfo> result = queryAttrByAttrvalId(pageQuery);
			responseData = new ResponseData<PageInfoResponse<AttrValInfo>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<AttrValInfo>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		
		return responseData;
	}
	
	/*private void queryBuilder(HttpServletRequest request, AttrValPageQuery pageQuery) {
		//设置租户ID
		pageQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		
		if (StringUtils.isNotBlank(request.getParameter("attrvalueDefId"))) {
			pageQuery.setAttrvalueDefId(request.getParameter("attrvalueDefId"));
		}j
		if (StringUtils.isNotBlank(request.getParameter("attrValueName"))) 
			pageQuery.setAttrValueName(request.getParameter("attrValueName"));
	}*/
	
	private PageInfoResponse<AttrValInfo> queryAttrByAttrvalId(AttrValPageQuery pageQuery) {
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		PageInfoResponse<AttrValInfo> result = attrAndValDefSV.queryPageAttrvalue(pageQuery);
		
		return result;
	}
	
	/**
	 * 进入添加属性值的页面
	 */
	@RequestMapping("/addAttrValue")
	public String addAttr() {
		
		return "prodAttr/addAttrValue";
	}
	
	/**
	 * 批量添加属性值
	 */
	@RequestMapping("saveAttrValue")
	@ResponseBody
	public ResponseData<String> saveAttrValue(String attrValueListStr, HttpSession session) {
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
		List<ProdAttrValueInfo> attrValueInfoList = JSON.parseArray(attrValueListStr,ProdAttrValueInfo.class);
		//创建用于接收页面传入的数据的集合
		ArrayList<AttrValParam> attrValueList = new ArrayList<>();
		for (ProdAttrValueInfo attrValueInfo : attrValueInfoList) {
			AttrValParam attrValParam = new AttrValParam();
			BeanUtils.copyProperties(attrValParam, attrValueInfo);
			//补全属性值的字段
			attrValParam.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
			attrValParam.setOperId(AdminUtil.getAdminId(session));
			attrValueList.add(attrValParam);
		}
		
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		BaseResponse response = attrAndValDefSV.createAttrvalue(attrValueList);
		ResponseHeader header = response.getResponseHeader();
		
		if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:"+header.getResultMessage());
        }
        return responseData;
	}
	
	/**
	 * 根据ID查询单个属性值
	 */
	@RequestMapping("/{id}")
	@ResponseBody
	public ResponseData<AttrVal> queryAttrValueById(@PathVariable("id") String attrvalueDefId){
		ResponseData<AttrVal> responseData;
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		AttrValUniqueReq attrValUniqueReq = new AttrValUniqueReq();
		//设置租户
		attrValUniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		//设置属性值ID
		attrValUniqueReq.setAttrvalueDefId(attrvalueDefId);
		//查询结果
		AttrVal attrvalue = attrAndValDefSV.queryAttrvalue(attrValUniqueReq);
		ResponseHeader header = attrvalue.getResponseHeader();
		// 保存错误信息
		if (header != null && !header.isSuccess()) {
			LOG.error("Query by attrvalueDefId is fail,attrvalueDefId:{},headInfo:\r\n",attrvalueDefId, JSON.toJSONString(header));
			responseData = new ResponseData<AttrVal>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
		}else {
			responseData = new ResponseData<AttrVal>(ResponseData.AJAX_STATUS_SUCCESS,"OK",attrvalue);
		}
		
		return responseData;
	}
	
	/**
	 * 单个属性的编辑
	 */
	@RequestMapping("/updateAttrValue")
	@ResponseBody
	public ResponseData<String> updateAttrValue(AttrValParam attrValParam, HttpSession session) {
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		//设置租户ID
		attrValParam.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		//设置操作人ID
		attrValParam.setOperId(AdminUtil.getAdminId(session));
		
		BaseResponse response = attrAndValDefSV.updateAttrvalue(attrValParam);
		ResponseHeader header = response.getResponseHeader();
		if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:"+header.getResultMessage());
        }
        return responseData;
	}
	
	/**
	 * 单个属性值的删除
	 */
	@RequestMapping("/delAttrValue/{id}")
	@ResponseBody
	public ResponseData<String> delAttr(@PathVariable("id") String attrvalueDefId,AttrValUniqueReq attrVal, HttpSession session){
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "删除成功");
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		//设置租户ID
		attrVal.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		//设置操作人ID
		attrVal.setOperId(AdminUtil.getAdminId(session));
		//设置属性值ID
		attrVal.setAttrvalueDefId(attrvalueDefId);
		//执行删除
		BaseResponse response = attrAndValDefSV.deleteAttrvalue(attrVal);
		
		ResponseHeader header = response==null?null:response.getResponseHeader();
        if (header==null || !header.isSuccess()){
            String errorCode = header==null?ExceptCodeConstants.Special.SYSTEM_ERROR:header.getResultCode();
            String errMsg = header==null?"未知错误":header.getResultMessage();
            LOG.error("Delete attr value is error,errorCode:{},errorMsg:{}",errorCode,errMsg);
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, errorCode,errMsg);
        }
        return responseData;
	}
	
}
