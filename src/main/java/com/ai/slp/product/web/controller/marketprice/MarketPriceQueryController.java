package com.ai.slp.product.web.controller.marketprice;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.StringUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.platform.common.api.sysuser.interfaces.ISysUserQuerySV;
import com.ai.platform.common.api.sysuser.param.SysUserQueryRequest;
import com.ai.platform.common.api.sysuser.param.SysUserQueryResponse;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.MarketPriceUpdate;
import com.ai.slp.product.api.normproduct.param.NormProdInfoResponse;
import com.ai.slp.product.api.normproduct.param.NormProdRequest;
import com.ai.slp.product.api.normproduct.param.NormProdResponse;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.controller.normproduct.NormProdQueryController;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.service.StandedProdService;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.product.web.util.DateUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;

/**
 * 
 * 标准品市场价管理
 * 
 * @author jiawen
 *
 */
@Controller
@RequestMapping("/marketpricequery")
public class MarketPriceQueryController {
	private static final Logger LOG = LoggerFactory.getLogger(NormProdQueryController.class);

	@Autowired
	private ProdCatService prodCatService;
	@Autowired
	StandedProdService standedProdService;
	
	/**
	 * 加载类目
	 */
	@RequestMapping("/list")
	public String editQuery(Model uiModel) {
		/*Map<Short, List<ProdCatInfo>> productCatMap = prodCatService.loadCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoMap", productCatMap);*/
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoList", productCatMap);
		return "marketprice/marketPriceList";
	}
	/**
	 * 查询列表
	 * @return
	 */
	@RequestMapping("/getMarketPriceList")
	@ResponseBody
	public ResponseData<PageInfoResponse<NormProdResponse>> queryNormProduct(HttpServletRequest request,NormProdRequest productRequest){
		ResponseData<PageInfoResponse<NormProdResponse>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, productRequest);
			
			PageInfoResponse<NormProdResponse> result = queryProductByState(productRequest);
			
			responseData = new ResponseData<PageInfoResponse<NormProdResponse>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<NormProdResponse>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	
	/**
	 * 根据状态不同查询商品
	 * 
	 * @param 
	 * @return
	 * @throws 
	 */
	private PageInfoResponse<NormProdResponse> queryProductByState(NormProdRequest productRequest) {
		INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		PageInfoResponse<NormProdResponse> result = normProductSV.queryNormProduct(productRequest);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		ISysUserQuerySV sysUserQuerySV = DubboConsumerFactory.getService(ISysUserQuerySV.class);
		SysParamSingleCond sysParamSingleCond = null;
		for (NormProdResponse normProdResponse : result.getResult()) {
			// 获取类型和状态
			if (StringUtils.isNotBlank(normProdResponse.getProductType())) {
				// 获取类型
				String productType = normProdResponse.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE,
						productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				normProdResponse.setProductType(productTypeName);
				// 获取状态
				String state = normProdResponse.getState();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.NormProduct.CODE, ComCacheConstants.NormProduct.STATUS, state);
				String stateName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				normProdResponse.setState(stateName);
				
				//设置人员名称
				SysUserQueryRequest userQuery = new SysUserQueryRequest();
	            userQuery.setTenantId(AdminUtil.getTenantId());
	            Long createId = normProdResponse.getCreateId();
	            //设置创建者名称
	            if(createId != null){
	            	userQuery.setId(Long.toString(createId));
	            	SysUserQueryResponse serInfo = sysUserQuerySV.queryUserInfo(userQuery);
	            	if(serInfo != null){
	            		normProdResponse.setCreateName(serInfo.getName());
	            	}
	            }
	            Long operId = normProdResponse.getOperId();
	            //设置操作者名称
	            if(operId != null){
	            	userQuery.setId(Long.toString(operId));
	            	SysUserQueryResponse serInfo = sysUserQuerySV.queryUserInfo(userQuery);
	            	if(serInfo != null){
	            		normProdResponse.setOperName(serInfo.getName());
	            	}
	            }
	            
			}
			
		}
		return result;
	}
	
	/**
	 * 查询条件检查设置  
	 */
	private void queryBuilder(HttpServletRequest request,NormProdRequest productRequest) {
		productRequest.setSupplierId(AdminUtil.getSupplierId());
		productRequest.setTenantId(AdminUtil.getTenantId());
		productRequest.setSupplierId(AdminUtil.getSupplierId());
		if(!request.getParameter("productId").isEmpty()){
			productRequest.setStandedProdId(request.getParameter("productId"));
		}
		if(!request.getParameter("productName").isEmpty()){
			productRequest.setStandedProductName(request.getParameter("productName"));
		}
		
		
		if (StringUtils.isNotBlank(request.getParameter("operStartTimeStr"))) {
			String startTime = request.getParameter("operStartTimeStr")+" 00:00:00";
			productRequest.setOperStartTime(DateUtil.getTimestamp(startTime, "yyyy-MM-dd HH:mm:ss"));
		}
		
		if (StringUtils.isNotBlank(request.getParameter("operEndTimeStr"))) {
				String endTime = request.getParameter("operEndTimeStr")+" 23:59:59";
				productRequest.setOperEndTime(DateUtil.getTimestamp(endTime, "yyyy-MM-dd HH:mm:ss"));
			}
		
	}
	
	/**
	 * 点击添加市场价
	 * 显示市场价的添加页面
	 * param standedProdId
     * @return
	 */
	@RequestMapping("/{id}")
    public String storageEdit(@PathVariable("id") String standedProdId, Model uiModel) {
		NormProdInfoResponse normProdResponse = standedProdService.getInfo(standedProdId,uiModel);
		
		//查询出市场价进行转换
        String price;
        if (normProdResponse.getMarketPrice() != null) {
        DecimalFormat df = new DecimalFormat("#0.00");
        price = normProdResponse.getMarketPrice().toString();
        if (StringUtil.isBlank(normProdResponse.getMarketPrice().toString())) {
        	price = "0.00";
		}else {
			BigDecimal input = new BigDecimal(price);
        	BigDecimal devide = new BigDecimal(1000);
        	Double yuanmoey = input.divide(devide).setScale(2, BigDecimal.ROUND_DOWN).doubleValue();
        	price = df.format(yuanmoey);
		}
        uiModel.addAttribute("price", price);
        }else {
        	price = "0.00";
        	uiModel.addAttribute("price", price);
		}
        uiModel.addAttribute("normProdResponse", normProdResponse);
		return "marketprice/marketPriceEdit";
		
	}
	
	/**
	 * 更新市场价
	 */
	@RequestMapping("/updateMarketPrice")
	@ResponseBody
	public ResponseData<String> updateMarketPrice(MarketPriceUpdate updatePrice,HttpSession session){
		ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS,"添加成功");
		INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		//设置租户ID 
		updatePrice.setTenantId(AdminUtil.getTenantId());
		//设置商户ID
		updatePrice.setSupplierId(AdminUtil.getSupplierId());
		//设置操作人
		updatePrice.setOperId(AdminUtil.getAdminId(session));
		//将页面获取的以元为单位的金额转换为以厘为单位的金额
		/*double price = updatePrice.getMarketPrice();
		 if (StringUtils.isBlank(String.valueOf(price))) {
	        	updatePrice.setMarketPrice(0);
			}else {
				BigDecimal bdm = new BigDecimal(price);
				BigDecimal result = (bdm.setScale(2, BigDecimal.ROUND_DOWN)).multiply(new BigDecimal(1000));
				Long value = result.longValue();
				updatePrice.setMarketPrice(value);
			}
		*/
		
		//保存
		BaseResponse response = normProductSV.updateMarketPrice(updatePrice);
		ResponseHeader header = response.getResponseHeader();
		if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "添加失败:"+header.getResultMessage());
        }
        return responseData;
	}
}
