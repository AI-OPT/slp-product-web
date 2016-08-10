package com.ai.slp.product.web.controller.product;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.param.ProductInfoQuery;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.util.AdminUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 商品管理相关的商品操作 Created by lipeng16 on 16/7/6.
 */
@Controller
@RequestMapping("/prodOperate")
public class prodOperateController {
	private static final Logger LOG = LoggerFactory.getLogger(prodOperateController.class);

	/**
	 * 待上架商品上架
	 */
	@RequestMapping("/prodToSale")
	@ResponseBody
	public ResponseData<String> prodToInSale(@RequestParam String productId,HttpSession session){
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
		IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
		//封装参数进行上架操作
		ProductInfoQuery productInfoQuery = new ProductInfoQuery();
		productInfoQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		productInfoQuery.setOperId(AdminUtil.getAdminId(session));
		productInfoQuery.setProductId(productId);
		BaseResponse baseResponse = productManagerSV.changeToInSale(productInfoQuery);
		LOG.debug("上架返回信息:"+JSonUtil.toJSon(baseResponse));
		ResponseHeader header = baseResponse.getResponseHeader();
		//上架出错
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:"+header.getResultMessage());
        }
		return responseData;
	}
	
	 /**
     * 商品手动下架
     */
    @RequestMapping("/prodInStore")
    @ResponseBody
    public ResponseData<String> prodToInStore(@RequestParam String productId,HttpSession session){
    	ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "下架成功");
		IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
		ProductInfoQuery productInfoQuery = new ProductInfoQuery();
		productInfoQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		productInfoQuery.setOperId(AdminUtil.getAdminId(session));
		productInfoQuery.setProductId(productId);
		BaseResponse baseResponse = productManagerSV.changeToInStore(productInfoQuery);
		LOG.debug("下架返回信息:"+JSonUtil.toJSon(baseResponse));
		ResponseHeader header = baseResponse.getResponseHeader();
		//下架出错
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "下架失败:"+header.getResultMessage());
        }
		
    	return responseData;
    }
}
