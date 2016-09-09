package com.ai.slp.product.web.controller.product;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.components.dss.DSSClientFactory;
import com.ai.opt.sdk.components.idps.IDPSClientFactory;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.StringUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.dss.base.interfaces.IDSSClient;
import com.ai.paas.ipaas.image.IImageClient;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamMultiCond;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrQuery;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.OtherSetOfProduct;
import com.ai.slp.product.api.product.param.ProdNoKeyAttr;
import com.ai.slp.product.api.product.param.ProductEditQueryReq;
import com.ai.slp.product.api.product.param.ProductEditUp;
import com.ai.slp.product.api.product.param.ProductInfo;
import com.ai.slp.product.api.product.param.ProductInfoQuery;
import com.ai.slp.product.api.product.param.ProductQueryInfo;
import com.ai.slp.product.api.product.param.TargetAreaForProd;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatUniqueReq;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.product.web.util.DateUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

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

import java.util.ArrayList;
import java.util.List;

/**
 * 商城商品管理查询 Created by jackieliu on 16/6/16.
 */
@Controller
@RequestMapping("/prodquery")
public class ProdQueryController {
	private static final Logger LOG = LoggerFactory.getLogger(ProdQueryController.class);
	@Autowired
	private ProdCatService prodCatService;
	@Autowired
    private AttrAndValService attrAndValService;
	/**
	 * 进入页面调用-加载类目
	 */
	@RequestMapping("/add")
	public String editQuery(Model uiModel) {
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoList", productCatMap);
		
		return "product/addlist";
	}

	/**
	 * 进入页面调用-加载类目
	 */
	@RequestMapping("/storprod")
	public String storProdQuery(Model uiModel) {
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoList", productCatMap);
		return "product/storprodlist";
	}
	
	/**
	 * 进入在售商品页面
	 * 
	 */
	@RequestMapping("/insale")
	public String inSalelistQuery(Model uiModel) {
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
        uiModel.addAttribute("count", productCatMap.size() - 1);
        uiModel.addAttribute("catInfoList", productCatMap);
		return "product/insalelist";
	}

	/**
	 * 进入查询在仓库中的页面    ---仓库中（审核通过、手动下架放入）
	 * 加载类目
	 */
	@RequestMapping("/stayUp")
	public String stayUpListQuery(Model uiModel){
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoList", productCatMap);
		
		return "product/stayuplist";
	}
	
	/**
	 * 进入查询废弃的页面 
	 * 加载类目
	 */
	@RequestMapping("/scrap")
	public String scrapListQuery(Model uiModel){
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoList", productCatMap);
		return "product/scraplist";
		
	}
	/**
	 * 进入查询商品审核的页面
	 * 加载类目
	 */
	@RequestMapping("/audit")
	public String auditListQuery(Model uiModel){
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoList", productCatMap);
		return "prodaudit/auditlist";

	}

	/**
	 * 查询条件检查设置
	 * @param request
	 * @param productEditQueryReq
	 */
	private void queryBuilder(HttpServletRequest request, ProductEditQueryReq productEditQueryReq) {
		productEditQueryReq.setTenantId(AdminUtil.getTenantId());
		productEditQueryReq.setSupplierId(AdminUtil.getSupplierId());
		productEditQueryReq.setProductCatId(request.getParameter("productCatId"));
		if(!request.getParameter("productType").isEmpty())
			productEditQueryReq.setProductType(request.getParameter("productType"));
		/*if(!request.getParameter("productId").isEmpty())
			productEditQueryReq.setProdId(request.getParameter("productId"));*/
		if(!request.getParameter("standedProdId").isEmpty())
			productEditQueryReq.setStandedProdId(request.getParameter("standedProdId"));
		if(!request.getParameter("productName").isEmpty())
			productEditQueryReq.setProdName(request.getParameter("productName"));

	}
	
	/**
	 * 根据状态不同查询商品
	 * 
	 * @param productEditQueryReq
	 * @return
	 */
	private PageInfoResponse<ProductEditUp> queryProductByState(ProductEditQueryReq productEditQueryReq) {
		productEditQueryReq.setSupplierId(AdminUtil.getSupplierId());
		IProductManagerSV productManagerSV = DubboConsumerFactory.getService("iProductManagerSV");
		PageInfoResponse<ProductEditUp> result = productManagerSV.queryProductEdit(productEditQueryReq);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		for (ProductEditUp productEditUp : result.getResult()) {
			// 获取类型和状态
			if (StringUtils.isNotBlank(productEditUp.getProductType())) {
				// 获取类型
				String productType = productEditUp.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE,
						productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setProductTypeName(productTypeName);
			}
			if (StringUtils.isNotBlank(productEditUp.getState())) {
				// 获取状态
				String state = productEditUp.getState();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, ComCacheConstants.TypeProduct.PROC_STATUS, state);
				String stateName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setStateName(stateName);
			}
			// 产生图片地址
			if (StringUtils.isNotBlank(productEditUp.getVfsId())) {
				String attrImageSize = "80x80";
				String vfsId = productEditUp.getVfsId();
				String picType = productEditUp.getPicType();
				String imageUrl = getImageUrl(attrImageSize, vfsId, picType);
				productEditUp.setPicUrl(imageUrl);
			}
		}
		return result;
	}

	/**
	 * 获取图片地址
	 * @param attrImageSize
	 * @param vfsId
	 * @param picType
	 * @return
	 */
	private String getImageUrl(String attrImageSize, String vfsId, String picType) {
		IImageClient imageClient = IDPSClientFactory.getImageClient(SysCommonConstants.ProductImage.IDPSNS);
		if (StringUtils.isBlank(picType))
			picType = ".jpg";
		if (!picType.startsWith("."))
			picType = "." + picType;
		String imageUrl = imageClient.getImageUrl(vfsId, picType, attrImageSize);
		return imageUrl;
	}

	/**
	 * 点击查询按钮调用方法-获取待编辑商品
	 * @return
	 */
	@RequestMapping("/getProductList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getProductList(HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, productEditQueryReq);
			// 设置状态
			List<String> stateList = new ArrayList<>();
			if (StringUtil.isBlank(request.getParameter("state"))) {
				stateList.add("1");
				stateList.add("3");
				stateList.add("4");
			}else {
				stateList.add(request.getParameter("state"));
			}
			productEditQueryReq.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	
	/**
	 * 点击查询按钮调用方法-查询在售商品
	 * @return
	 */
	@RequestMapping("/getInsaleList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> queryinsaleProduct(HttpServletRequest request,ProductQueryInfo queryInSale) {
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryInSale.setTenantId(AdminUtil.getTenantId());
			queryInSale.setSupplierId(AdminUtil.getSupplierId());
			
			if (StringUtils.isNotBlank(request.getParameter("upStartTimeStr"))) {
				String startTime = request.getParameter("upStartTimeStr")+" 00:00:00";
				queryInSale.setUpStartTime(DateUtil.getTimestamp(startTime, "yyyy-MM-dd HH:mm:ss"));
			}
			
			if (StringUtils.isNotBlank(request.getParameter("upEndTimeStr"))) {
					String endTime = request.getParameter("upEndTimeStr")+" 23:59:59";
					queryInSale.setUpEndTime(DateUtil.getTimestamp(endTime, "yyyy-MM-dd HH:mm:ss"));
				}
			
			// 设置商品状态为新增和未编辑
			List<String> stateList = new ArrayList<>();
			stateList.add("5");
			queryInSale.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductInSale(queryInSale);
			
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}

	private PageInfoResponse<ProductEditUp> queryProductInSale(ProductQueryInfo queryInSale) {
		queryInSale.setSupplierId(AdminUtil.getSupplierId());
		IProductManagerSV productManagerSV = DubboConsumerFactory.getService("iProductManagerSV");
		PageInfoResponse<ProductEditUp> result = productManagerSV.searchInSale(queryInSale);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		for (ProductEditUp productEditUp : result.getResult()) {
			// 获取类型和状态
			if (StringUtils.isNotBlank(productEditUp.getProductType())) {
				// 获取类型
				String productType = productEditUp.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE,
						productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setProductTypeName(productTypeName);
			}
			if (StringUtils.isNotBlank(productEditUp.getState())) {
				// 获取状态
				String state = productEditUp.getState();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, "STATE", state);
				String stateName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setStateName(stateName);
			}
			
			// 产生图片地址
			if (StringUtils.isNotBlank(productEditUp.getVfsId())) {
				String attrImageSize = "80x80";
				String vfsId = productEditUp.getVfsId();
				String picType = productEditUp.getPicType();
				String imageUrl = getImageUrl(attrImageSize, vfsId, picType);
				productEditUp.setPicUrl(imageUrl);
			}
		}
		return result;
	}

	/**
	 * 点击查询按钮调用方法-获取待上架商品
	 * @return
	 */
	@RequestMapping("/getStayUpList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getStayUpProduct(HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, productEditQueryReq);
			// 设置状态，6待上架（审核通过、手动下架放入）.61售罄下架.62库存暂停商品
			List<String> stateList = new ArrayList<>();
			if (StringUtil.isBlank(request.getParameter("state"))) {
				stateList.add("6");
				stateList.add("61");
				stateList.add("62");
			}else {
				stateList.add(request.getParameter("state"));
			}
			productEditQueryReq.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	/**
	 * 点击查询按钮调用方法-获取商品审核列表
	 * @return
	 */
	@RequestMapping("/getAuditList")
	@ResponseBody
	private ResponseData<PageInfoResponse<ProductEditUp>> queryAuditProduct(HttpServletRequest request,ProductQueryInfo queryInfo) {
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryInfo.setTenantId(AdminUtil.getTenantId());
			queryInfo.setSupplierId(AdminUtil.getSupplierId());
			queryInfo.setProductCatId(request.getParameter("productCatId"));
			if(!request.getParameter("productType").isEmpty())
				queryInfo.setProductType(request.getParameter("productType"));
			if(!request.getParameter("standedProdId").isEmpty())
				queryInfo.setStandedProdId(request.getParameter("standedProdId"));
			if(!request.getParameter("productName").isEmpty())
				queryInfo.setProdName(request.getParameter("productName"));
			// 设置状态
			List<String> stateList = new ArrayList<>();
			if (StringUtil.isBlank(request.getParameter("state"))) {
				stateList.add("3");
				stateList.add("4");
			}else {
				stateList.add(request.getParameter("state"));
			}
			queryInfo.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductAudit(queryInfo);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;

	}

	private PageInfoResponse<ProductEditUp> queryProductAudit(ProductQueryInfo queryInfo) {
		queryInfo.setSupplierId(AdminUtil.getSupplierId());
		IProductManagerSV productManagerSV = DubboConsumerFactory.getService("iProductManagerSV");
		PageInfoResponse<ProductEditUp> result = productManagerSV.searchAudit(queryInfo);
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		for (ProductEditUp productEditUp : result.getResult()) {
			// 获取类型和状态
			if (StringUtils.isNotBlank(productEditUp.getProductType())) {
				// 获取类型
				String productType = productEditUp.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE,
						productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setProductTypeName(productTypeName);
			}
			if (StringUtils.isNotBlank(productEditUp.getState())) {
				// 获取状态
				String state = productEditUp.getState();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE, "STATE", state);
				String stateName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setStateName(stateName);
			}

			// 产生图片地址
			if (StringUtils.isNotBlank(productEditUp.getVfsId())) {
				String attrImageSize = "80x80";
				String vfsId = productEditUp.getVfsId();
				String picType = productEditUp.getPicType();
				String imageUrl = getImageUrl(attrImageSize, vfsId, picType);
				productEditUp.setPicUrl(imageUrl);
			}
		}
		return result;
	}




	/**
	 * 点击查询按钮调用方法-获取售罄下架商品
	 * @return
	 */
	@RequestMapping("/getSaleDownList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getSaleDownProduct(HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, productEditQueryReq);
			// 设置状态，61售罄下架.
			List<String> stateList = new ArrayList<>();
			stateList.add("61");
			productEditQueryReq.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	/**
	 * 点击查询按钮调用方法-获取库存暂停商品
	 * @return
	 */
	@RequestMapping("/getStorStopList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getStorStopProduct(HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, productEditQueryReq);
			// 设置状态，62停用下架.
			List<String> stateList = new ArrayList<>();
			stateList.add("62");
			productEditQueryReq.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	
	
	/**
	 * 查询 废弃商品
	 */
	@RequestMapping("/getScrapList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getScrap(HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			//查询条件
			queryBuilder(request, productEditQueryReq);
			// 设置状态，7废弃
			List<String> stateList = new ArrayList<>();
			stateList.add("7");
			productEditQueryReq.setStateList(stateList);
			PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(ResponseData.AJAX_STATUS_FAILURE,
					"获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	
	/**
	 * 根据ID查询单个商品的详细信息
	 */
	@RequestMapping("/{id}")
	public String toViewProduct(@PathVariable("id") String prodId, Model uiModel){
		//查询商品的基础信息--类目信息,商品类型,商品名称,商品买点
		ProductInfoQuery productInfoQuery = new ProductInfoQuery();
		productInfoQuery.setProductId(prodId);
		productInfoQuery.setTenantId(AdminUtil.getTenantId());
		productInfoQuery.setSupplierId(AdminUtil.getSupplierId());
		IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
		ProductInfo productInfo = productSV.queryProductById(productInfoQuery);
		uiModel.addAttribute("productInfo", productInfo);
		
        //查询类目链
        ProductCatUniqueReq catUniqueReq = new ProductCatUniqueReq();
        catUniqueReq.setTenantId(AdminUtil.getTenantId());
        catUniqueReq.setProductCatId(productInfo.getProductCatId());
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        List<ProductCatInfo> catLinkList =productCatSV.queryLinkOfCatById(catUniqueReq);
        uiModel.addAttribute("catLinkList",catLinkList);
        SysParamSingleCond paramSingleCond = new SysParamSingleCond();
        paramSingleCond.setTenantId(AdminUtil.getTenantId());
        paramSingleCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
        paramSingleCond.setParamCode(ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE);
        paramSingleCond.setColumnValue(productInfo.getProductType());
        //商品类型
        ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        SysParam sysParam = cacheSV.getSysParamSingle(paramSingleCond);
        uiModel.addAttribute("prodType",sysParam.getColumnDesc());
        //标准品关键属性
        AttrQuery attrQuery = new AttrQuery();
        attrQuery.setTenantId(AdminUtil.getTenantId());
        attrQuery.setProductId(productInfo.getStandedProdId());
        attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
        INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
        AttrMap attrMap = normProductSV.queryAttrByNormProduct(attrQuery);
        uiModel.addAttribute("keyAttr",attrAndValService.getAttrAndVals(attrMap));
        //商品非关键属性
        IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
        ProdNoKeyAttr noKeyAttr = productManagerSV.queryNoKeyAttrOfProd(productInfoQuery);
        uiModel.addAttribute("noKeyAttr",noKeyAttr.getAttrInfoForProdList());
        uiModel.addAttribute("noKeyAttrValMap",noKeyAttr.getAttrValMap());
        //选择商品的目标地域
        ProductEditQueryReq queryReq = new ProductEditQueryReq();
        queryReq.setProdId(prodId);
        queryReq.setTenantId(AdminUtil.getTenantId());
        queryReq.setSupplierId(AdminUtil.getSupplierId());
        PageInfoResponse<TargetAreaForProd> prodTargetArea = productSV.searchProdTargetArea(queryReq);
        uiModel.addAttribute("prodTargetArea", prodTargetArea.getResult());

        //发票信息
        String invoice = productInfo.getIsInvoice();
        uiModel.addAttribute("invoice", invoice);
        
        //商品上架时间
        String upshelfType = productInfo.getUpshelfType();
        uiModel.addAttribute("upType", upshelfType);
        
        //查询商品其他设置
        OtherSetOfProduct otherSet = productManagerSV.queryOtherSetOfProduct(productInfoQuery);
        uiModel.addAttribute("otherSet",otherSet);

        //商品主图
        uiModel.addAttribute("prodPic",otherSet.getProductPics());
        //属性值图
        uiModel.addAttribute("attrValList",otherSet.getAttrValInfoList());
        uiModel.addAttribute("valPicMap",otherSet.getAttrValPics());

        SysParamMultiCond paramMultiCond = new SysParamMultiCond();
        paramMultiCond.setTenantId(AdminUtil.getTenantId());
        paramMultiCond.setTypeCode(ComCacheConstants.TypeProduct.CODE);
        paramMultiCond.setParamCode(ComCacheConstants.TypeProduct.PROD_UNIT);

        //设置商品详情
        setProdDetail(productInfo.getProDetailContent(),uiModel);
		
		return "product/viewproduct";
	}
	
	public void setProdDetail(String fileId,Model uiModel){
        if (StringUtils.isBlank(fileId)){
	            return;
	        }
	        IDSSClient client= DSSClientFactory.getDSSClient(SysCommonConstants.ProductDetail.DSSNS);
	        String context = client.findById(fileId);
	        if (StringUtils.isNotBlank(context)){
	            JSONObject object = JSON.parseObject(context);
	            uiModel.addAttribute("prodDetail",object.getString("content"));
	    }
	}
	
	/**
	 * 根据ID查询单个商品的详细信息
	 */
	@RequestMapping("/audit/{id}")
	public String auditProduct(@PathVariable("id") String prodId, Model uiModel){
		toViewProduct(prodId, uiModel);
		return "prodaudit/auditproduct";
	}
}
