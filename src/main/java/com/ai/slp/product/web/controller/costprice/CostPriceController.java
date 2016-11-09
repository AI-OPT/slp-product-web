package com.ai.slp.product.web.controller.costprice;

import com.ai.opt.base.vo.PageInfo;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.*;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.ProductConstants;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.route.api.routeprodsupplymanage.interfaces.IRouteProdSupplyManageSV;
import com.ai.slp.route.api.routeprodsupplymanage.param.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
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
import java.util.List;

/**
 * 标准品查询
 * 
 * @author jiawen
 */
@Controller
@RequestMapping("/costprice")
public class CostPriceController {
	private static final Logger LOG = LoggerFactory.getLogger(CostPriceController.class);

	@Autowired
	private ProdCatService prodCatService;
	@Autowired
	private AttrAndValService attrAndValService;

	/**
	 * 进入页面调用-加载类目
	 */
	@RequestMapping("/list")
	public String editQuery(Model uiModel) {
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoList", productCatMap);
		return "costprice/costPricelist";
	}

	/**
	 * 点击查询按钮调用方法-查询标准品
	 * 
	 * @return
	 */
	@RequestMapping("/getProductList")
	@ResponseBody
	public ResponseData<PageInfoResponse<NormProdResponse>> queryNormProduct(HttpServletRequest request,
			NormProdRequest productRequest) {
		ResponseData<PageInfoResponse<NormProdResponse>> responseData = null;
		try {
			// 查询条件
			queryBuilder(request, productRequest);

			PageInfoResponse<NormProdResponse> result = queryProductList(productRequest);

			responseData = new ResponseData<PageInfoResponse<NormProdResponse>>(ResponseData.AJAX_STATUS_SUCCESS,
					"查询成功", result);
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
	private PageInfoResponse<NormProdResponse> queryProductList(NormProdRequest productRequest) {
		INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		PageInfoResponse<NormProdResponse> result = normProductSV.queryNormProduct(productRequest);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		for (NormProdResponse normProdResponse : result.getResult()) {
			// 获取类型和状态
			if (StringUtils.isNotBlank(normProdResponse.getProductType())) {
				// 获取类型
				String productType = normProdResponse.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(), ComCacheConstants.TypeProduct.CODE,
						ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE, productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				normProdResponse.setProductTypeName(productTypeName);
			}

		}
		return result;
	}

	/**
	 * 查询条件检查设置
	 */
	private void queryBuilder(HttpServletRequest request, NormProdRequest productRequest) {
		productRequest.setSupplierId(AdminUtil.getSupplierId());
		productRequest.setTenantId(AdminUtil.getTenantId());
		productRequest.setSupplierId(AdminUtil.getSupplierId());
		productRequest.setState(ProductConstants.NormProduct.State.ENABLE);
		if (!request.getParameter("productId").isEmpty()){
			productRequest.setStandedProdId(request.getParameter("productId"));
		}
		if (!request.getParameter("productName").isEmpty()){
			productRequest.setStandedProductName(request.getParameter("productName"));
		}
	}

	/**
	 * 显示标准品库存编辑页面
	 *
	 * @param standedProdId
	 * @return
	 */
	@RequestMapping("/{id}")
	public String storageEdit(@PathVariable("id") String standedProdId, Model uiModel) {
		// 标准品ID
		uiModel.addAttribute("standedProdId", standedProdId);
		// 查询标准品信息
		NormProdUniqueReq normProdUniqueReq = new NormProdUniqueReq();
		normProdUniqueReq.setProductId(standedProdId);
		normProdUniqueReq.setTenantId(AdminUtil.getTenantId());
		normProdUniqueReq.setSupplierId(AdminUtil.getSupplierId());
		INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		NormProdInfoResponse normProdInfoResponse = normProductSV.queryProducById(normProdUniqueReq);
		uiModel.addAttribute("normProdInfo", normProdInfoResponse);
		// 查询类目链
		uiModel.addAttribute("catLinkList", prodCatService.queryLink(normProdInfoResponse.getProductCatId()));
		uiModel.addAttribute("productCatId", normProdInfoResponse.getProductCatId());
		// 商品类型
		SysParamSingleCond paramSingleCond = new SysParamSingleCond();
		paramSingleCond.setTenantId(AdminUtil.getTenantId());
		paramSingleCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
		paramSingleCond.setParamCode(ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE);
		paramSingleCond.setColumnValue(normProdInfoResponse.getProductType());
		ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
		SysParam sysParam = cacheSV.getSysParamSingle(paramSingleCond);
		uiModel.addAttribute("prodType", sysParam.getColumnDesc());
		// 标准品关键属性
		AttrQuery attrQuery = new AttrQuery();
		attrQuery.setTenantId(AdminUtil.getTenantId());
		attrQuery.setProductId(normProdInfoResponse.getProductId());
		attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
		AttrMap attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
		uiModel.addAttribute("keyAttr", attrAndValService.getAttrAndVals(attrMap));
		// 查询销售属性
		attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
		attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
		uiModel.addAttribute("saleAttr", attrAndValService.getAttrAndVals(attrMap));
		// 查询成本价列表
		return "costprice/costPriceEdit";
	}

	/**
	 * 查询仓库列
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping("/prodRouteList")
	@ResponseBody
	public ResponseData<PageInfo<StandedProdRouteVo>> queryStandedProdRouteList(StandedProdIdPageSearchRequest queryRequest) {
		ResponseData<PageInfo<StandedProdRouteVo>> responseData = null;
		try {
			IRouteProdSupplyManageSV  routeProdSupplyManageSV = DubboConsumerFactory.getService(IRouteProdSupplyManageSV.class);
			queryRequest.setTenantId(AdminUtil.getTenantId());
			StandedProdRoutePageSearchResponse prodRoutePageResponse = routeProdSupplyManageSV.queryStandedProdRoutePageSearch(queryRequest);
			PageInfo<StandedProdRouteVo> pageInfo = prodRoutePageResponse.getPageInfo();
			if(prodRoutePageResponse.getResponseHeader().isSuccess()){
				responseData = new ResponseData<PageInfo<StandedProdRouteVo>>(ResponseData.AJAX_STATUS_SUCCESS,
						"查询成功", pageInfo);
			}else{
				responseData = new ResponseData<PageInfo<StandedProdRouteVo>>(ResponseData.AJAX_STATUS_FAILURE,
						"查询失败");
			}
		} catch (Exception e) {
			responseData = new ResponseData<PageInfo<StandedProdRouteVo>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}

	/**
	 * 保存成本价
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping("/save")
	@ResponseBody
	public ResponseData<String> saveProductCostPrice(String costPriceList) {
		ResponseData<String> responseData = null;
		CostPriceUpdateListRequest paramCostPriceUpdateListRequest = new CostPriceUpdateListRequest();
		Gson gson = new Gson();
		List<CostPriceUpdateVo> costPriceUpdateVoList = gson.fromJson(costPriceList, new TypeToken<List<CostPriceUpdateVo>>(){}.getType());
		if(costPriceUpdateVoList != null && costPriceUpdateVoList.size()>0){
			paramCostPriceUpdateListRequest.setVoList(costPriceUpdateVoList);
			try {
				IRouteProdSupplyManageSV routeProdSupplyManageSV = DubboConsumerFactory.getService(IRouteProdSupplyManageSV .class);
				CostPriceUpdateResponse updateCostPrice = routeProdSupplyManageSV.updateCostPrice(paramCostPriceUpdateListRequest);
				ResponseHeader responseHeader = updateCostPrice.getResponseHeader();
				if(responseHeader.isSuccess()){
					responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS,"保存成功");
				}else{
					responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,"有部分价格未填写,无法提交");
				}
			} catch (Exception e) {
				responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,"保存失败");
				LOG.error("获取信息出错：", e);
			}
		}else{
			responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,"无数据");
		}
		return responseData;
	}
	
}
