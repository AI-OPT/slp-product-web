package com.ai.slp.product.web.controller.pricemanage;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.platform.common.api.sysuser.interfaces.ISysUserQuerySV;
import com.ai.platform.common.api.sysuser.param.SysUserQueryRequest;
import com.ai.platform.common.api.sysuser.param.SysUserQueryResponse;
import com.ai.slp.common.api.cache.interfaces.ICacheSV;
import com.ai.slp.common.api.cache.param.SysParam;
import com.ai.slp.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrQuery;
import com.ai.slp.product.api.normproduct.param.NormProdInfoResponse;
import com.ai.slp.product.api.normproduct.param.NormProdRequest;
import com.ai.slp.product.api.normproduct.param.NormProdResponse;
import com.ai.slp.product.api.normproduct.param.NormProdUniqueReq;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.controller.normproduct.NormProdQueryController;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.DateUtil;

/**
 * 
 * 标准品市场价管理
 * 
 * @author jiawen
 *
 */
@RequestMapping("/marketpricequery")
@ResponseBody
public class MarketPriceQueryController {
	private static final Logger LOG = LoggerFactory.getLogger(NormProdQueryController.class);

	@Autowired
	private ProdCatService prodCatService;
    @Autowired
    private AttrAndValService attrAndValService;
	
	/**
	 * 加载类目
	 */
	@RequestMapping("/list")
	public String editQuery(Model uiModel) {
		Map<Short, List<ProdCatInfo>> productCatMap = prodCatService.loadCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoMap", productCatMap);
		return "normproduct/normproductlist";
	}
	/**
	 * 查询列表
	 * @return
	 */
	@RequestMapping("/getMarketPriceList")
	@ResponseBody
	private ResponseData<PageInfoResponse<NormProdResponse>> queryNormProduct(HttpServletRequest request,NormProdRequest productRequest){
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
				sysParamSingleCond = new SysParamSingleCond(SysCommonConstants.COMMON_TENANT_ID,
						ComCacheConstants.TypeProduct.CODE, ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE,
						productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				normProdResponse.setProductType(productTypeName);
				// 获取状态
				String state = normProdResponse.getState();
				sysParamSingleCond = new SysParamSingleCond(SysCommonConstants.COMMON_TENANT_ID,
						ComCacheConstants.NormProduct.CODE, ComCacheConstants.NormProduct.STATUS, state);
				String stateName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				normProdResponse.setState(stateName);
				
				//设置人员名称
				SysUserQueryRequest userQuery = new SysUserQueryRequest();
	            userQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
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
		productRequest.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
		productRequest.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		productRequest.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
		if(!request.getParameter("productId").isEmpty())
			productRequest.setStandedProdId(request.getParameter("productId"));
		if(!request.getParameter("productName").isEmpty())
			productRequest.setStandedProductName(request.getParameter("productName"));
		
		
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
		INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		//根据ID查询单个商品的信息
		NormProdUniqueReq req = new NormProdUniqueReq();
		req.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
		req.setSupplierId(SysCommonConstants.COMMON_SUPPLIER_ID);
		req.setProductId(standedProdId);
		NormProdInfoResponse normProdResponse = normProductSV.queryProducById(req);
		uiModel.addAttribute("normProd",normProdResponse);
		//查询类目链
        uiModel.addAttribute("catLinkList", prodCatService.queryLink(normProdResponse.getProductCatId()));
        uiModel.addAttribute("productCatId", normProdResponse.getProductCatId());
        //商品类型
        SysParamSingleCond paramSingleCond = new SysParamSingleCond();
        paramSingleCond.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        paramSingleCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
        paramSingleCond.setParamCode(ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE);
        paramSingleCond.setColumnValue(normProdResponse.getProductType());
        ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        SysParam sysParam = cacheSV.getSysParamSingle(paramSingleCond);
        uiModel.addAttribute("prodType", sysParam.getColumnDesc());
        //标准品关键属性
        AttrQuery attrQuery = new AttrQuery();
        attrQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        attrQuery.setProductId(normProdResponse.getProductId());
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
        AttrMap attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
        uiModel.addAttribute("keyAttr", attrAndValService.getAttrAndVals(attrMap));
        //查询销售属性
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
        attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
        uiModel.addAttribute("saleAttr", attrAndValService.getAttrAndVals(attrMap));
		
		return "/marketprice/addMarketPrice";
		
	}
	
}
