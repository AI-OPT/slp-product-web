package com.ai.slp.product.web.controller.prodAttr;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.platform.common.api.sysuser.interfaces.ISysUserQuerySV;
import com.ai.platform.common.api.sysuser.param.SysUserQueryRequest;
import com.ai.platform.common.api.sysuser.param.SysUserQueryResponse;
import com.ai.slp.product.api.productcat.interfaces.IAttrAndValDefSV;
import com.ai.slp.product.api.productcat.param.*;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.model.prodAttr.ProdAttrInfo;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * 属性的管理 
 * @author jiawen
 *
 */

@Controller
@RequestMapping("/attr")
public class AttrController {
	private static final Logger LOG = LoggerFactory.getLogger(AttrController.class);
	
	/**
	 * 进入页面
	 */
	@RequestMapping("/attrList")
	public String attrList() {
		
		return "prodAttr/attrList";
	}
	
	/**
	 * 查询商品类目属性列表
	 */
	@RequestMapping("/getAttrList")
	@ResponseBody
	public ResponseData<PageInfoResponse<AttrDefInfo>> queryAttrList(HttpServletRequest request,AttrDefParam attrDefParam){
		ResponseData<PageInfoResponse<AttrDefInfo>> responseData = null;
		try {
			attrDefParam.setTenantId(AdminUtil.getTenantId());
			
			PageInfoResponse<AttrDefInfo> result = queryAttrByValueWay(attrDefParam);
			responseData = new ResponseData<PageInfoResponse<AttrDefInfo>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<AttrDefInfo>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	
	/**
	 * 查询属性列表
	 * 
	 * @param 
	 * @return
	 */
	private PageInfoResponse<AttrDefInfo> queryAttrByValueWay(AttrDefParam attrDefParam) {
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		PageInfoResponse<AttrDefInfo> result = attrAndValDefSV.queryPageAttrs(attrDefParam);
		ISysUserQuerySV sysUserQuerySV = DubboConsumerFactory.getService(ISysUserQuerySV.class);
		SysUserQueryRequest userQueryRequest= new SysUserQueryRequest();
		
		for (AttrDefInfo attrDefInfo : result.getResult()) {
			//获取输入值方式
			if (StringUtils.isNotBlank(attrDefInfo.getValueWay())) {
			 String valueWay = attrDefInfo.getValueWay();
			 sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(), ComCacheConstants.ProdAttr.CODE, ComCacheConstants.ProdAttr.VALUE_WAY, valueWay);
			 String valueWayName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
			 attrDefInfo.setValueWay(valueWayName);
			}
			//设置操作员名称
			Long operId = attrDefInfo.getOperId();
			if(operId != null){
				userQueryRequest.setId(Long.toString(operId));
				userQueryRequest.setTenantId(AdminUtil.getTenantId());
				SysUserQueryResponse userInfo = sysUserQuerySV.queryUserInfo(userQueryRequest);
				if(userInfo != null){
					attrDefInfo.setOperName(userInfo.getName());
				}
			}
		}
		return result;
	}
	
	/**
	 * 进入添加属性页面
	 */
	@RequestMapping("/addAttr")
	public String addAttr() {
		
		return "prodAttr/addAttr";
	}
	
	/**
	 * 批量添加
	 * 保存属性
	 */
	@RequestMapping("/saveAttr")
	@ResponseBody
	public ResponseData<String> saveAttr(String attrListStr, HttpSession session) {
		//List<AttrParam>
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
		List<ProdAttrInfo> attrInfoList = JSON.parseArray(attrListStr,ProdAttrInfo.class);
		List<AttrParam> attrParamList = new ArrayList<>();
		for (ProdAttrInfo attrInfo : attrInfoList) {
			AttrParam attrParam = new AttrParam();
			BeanUtils.copyProperties(attrParam, attrInfo);
			attrParam.setTenantId(AdminUtil.getTenantId());
			attrParam.setOperId(AdminUtil.getAdminId(session));
			attrParamList.add(attrParam);
		}		
		
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		BaseResponse response = attrAndValDefSV.createAttrs(attrParamList);
		ResponseHeader header = response.getResponseHeader();
		
		if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:"+header.getResultMessage());
        }
        return responseData;
	}
	/**
	 * 根据ID查询单个属性
	 */
	@RequestMapping("/{id}")
    @ResponseBody
    public ResponseData<AttrInfo> queryAttrById(@PathVariable("id") String attrId){
		ResponseData<AttrInfo> responseData;
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		AttrPam attrPam = new AttrPam();
		//设置租户ID
		attrPam.setTenantId(AdminUtil.getTenantId());
		//设置属性ID
		Long attrIdLong = Long.valueOf(attrId).longValue();
		attrPam.setAttrId(attrIdLong);
		AttrInfo attrInfo = attrAndValDefSV.queryAttr(attrPam);
		ResponseHeader header = attrInfo.getResponseHeader();
		
		 //保存错误
        if (header!=null && !header.isSuccess()){
        	LOG.error("Query by attrId is fail,attrId:{},headInfo:\r\n",attrId, JSON.toJSONString(header));
            responseData = new ResponseData<AttrInfo>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else{
            responseData = new ResponseData<AttrInfo>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",attrInfo);
        }
        return responseData;
	}
	
}
