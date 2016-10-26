package com.ai.slp.product.web.controller.normproduct;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.platform.common.api.sysuser.interfaces.ISysUserQuerySV;
import com.ai.platform.common.api.sysuser.param.SysUserQueryRequest;
import com.ai.platform.common.api.sysuser.param.SysUserQueryResponse;
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
import com.ai.slp.product.web.model.product.NormProdQueryInfo;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.product.web.util.DateUtil;

/**
 * 标准品查询
 * 
 * @author jiawen
 */
@Controller
@RequestMapping("/normprodquery")
public class NormProdQueryController {
	private static final Logger LOG = LoggerFactory.getLogger(NormProdQueryController.class);

	@Autowired
	private ProdCatService prodCatService;
	@Autowired
	private AttrAndValService attrAndValService;

	/**
	 * 进入页面调用-加载类目
	 */
	@RequestMapping("/list")
	public String editQuery(Model uiModel) {
		Map<Short, List<ProdCatInfo>> productCatMap = prodCatService.loadCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoMap", productCatMap);
		return "normproduct/normproductlist";
	}

	/**
	 * 点击查询按钮调用方法-查询标准品
	 * 
	 * @return
	 */
	@RequestMapping("/getNormProductList")
	@ResponseBody
	public ResponseData<PageInfoResponse<NormProdQueryInfo>> queryNormProduct(HttpServletRequest request,
			NormProdRequest productRequest) {
		long queryStart=System.currentTimeMillis();
		LOG.info("====商品查询开始 start to in getNormProductList，当前时间戳："+queryStart);
		ResponseData<PageInfoResponse<NormProdQueryInfo>> responseData = null;
		try {
			// 查询条件
			queryBuilder(request, productRequest);

			PageInfoResponse<NormProdQueryInfo> result = queryProductByState(productRequest);

			responseData = new ResponseData<PageInfoResponse<NormProdQueryInfo>>(ResponseData.AJAX_STATUS_SUCCESS,
					"查询成功", result);
			long queryEnd=System.currentTimeMillis();
			LOG.info("getNormProductList is end，当前时间戳："+queryEnd+",用时:"+(queryEnd-queryStart)+"毫秒");
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<NormProdQueryInfo>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		long finshEnd=System.currentTimeMillis();
		LOG.info("====商品查询结束 getNormProductList is finish，当前时间戳："+finshEnd+",用时:"+(finshEnd-queryStart)+"毫秒");
		return responseData;
	}

	/**
	 * 根据状态不同查询商品
	 * 
	 * @param
	 * @return
	 */
	private PageInfoResponse<NormProdQueryInfo> queryProductByState(NormProdRequest productRequest) {
		PageInfoResponse<NormProdQueryInfo> result = new PageInfoResponse<NormProdQueryInfo>();
		INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		long queryStart=System.currentTimeMillis();
		LOG.info("开始执行商品查询normProductSV.queryNormProduct开始 ，当前时间戳："+queryStart);
		PageInfoResponse<NormProdResponse> productPageInfo = normProductSV.queryNormProduct(productRequest);
		long queryEnd=System.currentTimeMillis();
		LOG.info("完成执行商品查询normProductSV.queryNormProduct，当前时间戳："+queryEnd+",用时:"+(queryEnd-queryStart)+"毫秒");
		// ISysUserQuerySV sysUserQuerySV =
		// DubboConsumerFactory.getService(ISysUserQuerySV.class);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		List<NormProdQueryInfo> productList=new ArrayList<NormProdQueryInfo>();
		long cacheStart=System.currentTimeMillis();
		LOG.info("开始执行循环调用cacheSV.getSysParamSingle ，当前时间戳："+cacheStart);
		for (NormProdResponse normProdResponse : productPageInfo.getResult()) {
			NormProdQueryInfo productInfo = new NormProdQueryInfo();
			BeanUtils.copyProperties(productInfo, normProdResponse);
			// 获取类型和状态
			if (StringUtils.isNotBlank(productInfo.getProductType())) {
				// 获取类型
				String productType = productInfo.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(), ComCacheConstants.TypeProduct.CODE,
						ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE, productType);
				SysParam sysParamSingle = cacheSV.getSysParamSingle(sysParamSingleCond);
				if(sysParamSingle != null){
					String productTypeName = sysParamSingle.getColumnDesc();
					productInfo.setProductTypeName(productTypeName);
				}
				// 获取状态
				String state = productInfo.getState();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(), ComCacheConstants.NormProduct.CODE,
						ComCacheConstants.NormProduct.STATUS, state);
				sysParamSingle = cacheSV.getSysParamSingle(sysParamSingleCond);
				if(sysParamSingle!=null){
					String stateName = sysParamSingle.getColumnDesc();
					productInfo.setStateName(stateName);
				}

				// 设置人员名称
				// SysUserQueryRequest userQuery = new SysUserQueryRequest();
				// userQuery.setTenantId(AdminUtil.getTenantId());
				// Long createId = productInfo.getCreateId();
				// //设置创建者名称
				// if(createId != null){
				// userQuery.setId(Long.toString(createId));
				// SysUserQueryResponse serInfo =
				// sysUserQuerySV.queryUserInfo(userQuery);
				// if(serInfo != null){
				// productInfo.setCreateName(serInfo.getName());
				// }
				// }
				// Long operId = productInfo.getOperId();
				// //设置操作者名称
				// if(operId != null){
				// userQuery.setId(Long.toString(operId));
				// SysUserQueryResponse serInfo =
				// sysUserQuerySV.queryUserInfo(userQuery);
				// if(serInfo != null){
				// productInfo.setOperName(serInfo.getName());
				// }
				// }
			}
			productList.add(productInfo);
		}
		long cacheEnd=System.currentTimeMillis();
		LOG.info("完成执行循环调用cacheSV.getSysParamSingle，当前时间戳："+cacheEnd+",用时:"+(cacheEnd-cacheStart)+"毫秒");
		result.setCount(productPageInfo.getCount());
		result.setPageCount(productPageInfo.getPageCount());
		result.setPageNo(productPageInfo.getPageNo());
		result.setPageSize(productPageInfo.getPageSize());
		result.setResponseHeader(productPageInfo.getResponseHeader());
		result.setResult(productList);
		return result;
	}

	/**
	 * 查询条件检查设置
	 */
	private void queryBuilder(HttpServletRequest request, NormProdRequest productRequest) {
		productRequest.setSupplierId(AdminUtil.getSupplierId());
		productRequest.setTenantId(AdminUtil.getTenantId());
		productRequest.setSupplierId(AdminUtil.getSupplierId());
		if (!request.getParameter("productId").isEmpty()){
			productRequest.setStandedProdId(request.getParameter("productId"));
		}
		if (!request.getParameter("productName").isEmpty()){
			productRequest.setStandedProductName(request.getParameter("productName"));
		}

		if (StringUtils.isNotBlank(request.getParameter("operStartTimeStr"))) {
			String startTime = request.getParameter("operStartTimeStr") + " 00:00:00";
			productRequest.setOperStartTime(DateUtil.getTimestamp(startTime, "yyyy-MM-dd HH:mm:ss"));
		}

		if (StringUtils.isNotBlank(request.getParameter("operEndTimeStr"))) {
			String endTime = request.getParameter("operEndTimeStr") + " 23:59:59";
			productRequest.setOperEndTime(DateUtil.getTimestamp(endTime, "yyyy-MM-dd HH:mm:ss"));
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
		// 设置操作人姓名
		Long operId = normProdInfoResponse.getOperId();
		String operName = getOperName(operId);
		normProdInfoResponse.setOperName(operName);
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
		if(sysParam != null){
			uiModel.addAttribute("prodType", sysParam.getColumnDesc());
		}
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
		return "normproduct/info";
	}

	private String getOperName(Long operId) {
		String name = null;
		// 设置操作者名称
		if (operId != null) {
			SysUserQueryRequest userQuery = new SysUserQueryRequest();
			userQuery.setTenantId(AdminUtil.getTenantId());
			userQuery.setId(Long.toString(operId));
			ISysUserQuerySV sysUserQuerySV = DubboConsumerFactory.getService(ISysUserQuerySV.class);
			SysUserQueryResponse serInfo = sysUserQuerySV.queryUserInfo(userQuery);
			if (serInfo != null) {
				name = serInfo.getName();
			}
		}
		return name;
	}
}
