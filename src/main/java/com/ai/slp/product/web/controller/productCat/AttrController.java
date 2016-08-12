package com.ai.slp.product.web.controller.productCat;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.xml.resolver.apps.resolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.common.api.cache.interfaces.ICacheSV;
import com.ai.slp.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.NormProdRequest;
import com.ai.slp.product.api.normproduct.param.NormProdResponse;
import com.ai.slp.product.api.productcat.interfaces.IAttrAndValDefSV;
import com.ai.slp.product.api.productcat.param.AttrDefInfo;
import com.ai.slp.product.api.productcat.param.AttrDefParam;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.DateUtil;

/**
 * 属性及属性值的管理 
 * @author jiawen
 *
 */

@Controller
@RequestMapping("/cat")
public class AttrController {
	private static Logger LOG = LoggerFactory.getLogger(AttrController.class);
	
	/**
	 * 进入页面
	 */
	@RequestMapping("/catList")
	public String catList() {
		
		return "prodCat/catList";
	}
	
	/**
	 * 查询商品类目属性列表
	 */
	@RequestMapping("/getAttrList")
	@ResponseBody
	private ResponseData<PageInfoResponse<AttrDefInfo>> queryAttrList(HttpServletRequest request,AttrDefParam attrDefParam){
		ResponseData<PageInfoResponse<AttrDefInfo>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, attrDefParam);
			
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
	 * 查询条件检查设置  
	 */
	private void queryBuilder(HttpServletRequest request,AttrDefParam attrDefParam) {
		attrDefParam.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		attrDefParam.setValueWay(request.getParameter("valueWay"));
		
		if (StringUtils.isNotBlank(request.getParameter("attrId"))) {
			String parameter = request.getParameter("attrId");
			attrDefParam.setAttrId(Long.valueOf("parameter"));
		}
		if (StringUtils.isNotBlank(request.getParameter("attrName"))) 
			attrDefParam.setAttrName(request.getParameter("attrName"));
		
	}
	/**
	 * 查询属性列表
	 * 
	 * @param 
	 * @return
	 */
	private PageInfoResponse<AttrDefInfo> queryAttrByValueWay(AttrDefParam attrDefParam) {
		IAttrAndValDefSV attrAndValDefSV = DubboConsumerFactory.getService(IAttrAndValDefSV.class);
		PageInfoResponse<AttrDefInfo> result = attrAndValDefSV.queryPageAttrs(attrDefParam);
		
		return result;
	}
	
}
