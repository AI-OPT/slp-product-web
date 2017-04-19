package com.ai.slp.product.web.controller.product;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.exception.BusinessException;
import com.ai.opt.base.exception.SystemException;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.components.dss.DSSClientFactory;
import com.ai.opt.sdk.components.idps.IDPSClientFactory;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.CollectionUtil;
import com.ai.opt.sdk.util.StringUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.dss.base.interfaces.IDSSClient;
import com.ai.paas.ipaas.image.IImageClient;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamSingleCond;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrQuery;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.interfaces.IProductServerSV;
import com.ai.slp.product.api.product.param.*;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.AttrInfo;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatUniqueReq;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.ProductConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.product.web.util.DateUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

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
	 * 显示待编辑商品列表页面
	 */
	@RequestMapping("/add")
	public String editQuery(Model uiModel) {
		getViewWithCats(uiModel);
		return "product/addlist";
	}

	/**
	 * 显示仓库中商品列表页面
	 */
	@RequestMapping("/storprod")
	public String storProdQuery(Model uiModel) {
		getViewWithCats(uiModel);
		return "product/storprodlist";
	}
	
	/**
	 * 显示在售商品列表页面
	 */
	@RequestMapping("/insale")
	public String inSalelistQuery(Model uiModel) {
		getViewWithCats(uiModel);
		return "product/insalelist";
	}

	/**
	 * 显示待上架列表页面
	 */
	@RequestMapping("/stayUp")
	public String stayUpListQuery(Model uiModel){
		getViewWithCats(uiModel);
		return "product/stayuplist";
	}
	
	/**
	 * 显示废弃商品列表页面
	 */
	@RequestMapping("/scrap")
	public String scrapListQuery(Model uiModel){
		getViewWithCats(uiModel);
		return "product/scraplist";
	}
	/**
	 * 显示审核商品列表页面
	 */
	@RequestMapping("/audit")
	public String auditListQuery(Model uiModel){
		getViewWithCats(uiModel);
		return "prodaudit/auditlist";
	}

	/**
	 * 点击查询按钮调用方法-获取待编辑商品
	 * @return
	 */
	@RequestMapping("/getProductList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getProductList(
			HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
        ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
        try {
            // 查询条件
            queryBuilder(request, productEditQueryReq);
            // 设置状态
            List<String> stateList = new ArrayList<>();
            if (StringUtil.isBlank(request.getParameter("state"))) {
                stateList.add("1");
                stateList.add("3");
                stateList.add("4");
            } else {
                stateList.add(request.getParameter("state"));
            }
            productEditQueryReq.setStateList(stateList);
            PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
            responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
                    ResponseData.AJAX_STATUS_SUCCESS, "查询成功", result);
        } catch (Exception e) {
            responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息异常");
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
	public ResponseData<PageInfoResponse<ProductEditUp>> queryInSaleProduct(
			@RequestParam(value = "upStartTimeStr",required = false) String upStartTimeStr,
			@RequestParam(value = "upEndTimeStr",required = false) String upEndTimeStr,
			ProductQueryInfo queryInSale) {
        ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
        try {
            // 查询条件
            queryInSale.setTenantId(AdminUtil.getTenantId());
            queryInSale.setSupplierId(AdminUtil.getSupplierId());

            if (StringUtils.isNotBlank(upStartTimeStr)) {
                String startTime = upStartTimeStr + " 00:00:00";
                queryInSale.setUpStartTime(DateUtil.getTimestamp(startTime, "yyyy-MM-dd HH:mm:ss"));
            }

            if (StringUtils.isNotBlank(upEndTimeStr)) {
                String endTime = upEndTimeStr + " 23:59:59";
                queryInSale.setUpEndTime(DateUtil.getTimestamp(endTime, "yyyy-MM-dd HH:mm:ss"));
            }

            // 设置商品状态为新增和未编辑
            List<String> stateList = new ArrayList<>();
            stateList.add("5");
            queryInSale.setStateList(stateList);
            PageInfoResponse<ProductEditUp> result = queryProductInSale(queryInSale);

            responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
                    ResponseData.AJAX_STATUS_SUCCESS, "查询成功", result);
        } catch (Exception e) {
            responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息异常");
            LOG.error("获取信息出错：", e);
        }
        return responseData;
	}

	/** 
	 * 查询在售商品 
	 */
	private PageInfoResponse<ProductEditUp> queryProductInSale(ProductQueryInfo queryInSale) {
        queryInSale.setSupplierId(AdminUtil.getSupplierId());
        IProductManagerSV productManagerSV = DubboConsumerFactory.getService("iProductManagerSV");
        PageInfoResponse<ProductEditUp> result = productManagerSV.searchInSale(queryInSale);
        return fillProductInfo(result);
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
	public ResponseData<PageInfoResponse<ProductEditUp>> queryAuditProduct(
			@RequestParam(value = "operStartTimeStr",required = false) String operStartTimeStr,
			@RequestParam(value = "operEndTimeStr",required = false) String operEndTimeStr,
			String productName,String state,ProductQueryInfo queryInfo) {
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
        try {
            // 查询条件
            if (StringUtils.isNotBlank(productName)){
            	queryInfo.setProdName(productName);
            }
            //设置时间
            if (StringUtils.isNotBlank(operStartTimeStr)) {
                String operStartTime = operStartTimeStr + " 00:00:00";
                queryInfo.setOperStartTime(DateUtil.getTimestamp(operStartTime, "yyyy-MM-dd HH:mm:ss"));
            }
            if (StringUtils.isNotBlank(operEndTimeStr)) {
                String operEndTime = operEndTimeStr + " 23:59:59";
                queryInfo.setOperEndTime(DateUtil.getTimestamp(operEndTime, "yyyy-MM-dd HH:mm:ss"));
            }
            
            // 设置状态
            List<String> stateList = new ArrayList<>();
            if (StringUtil.isBlank(state)) {
                stateList.add("3");
                stateList.add("4");
            } else {
                stateList.add(state);
            }
            queryInfo.setStateList(stateList);
            PageInfoResponse<ProductEditUp> result = queryProductAudit(queryInfo);
            responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
                    ResponseData.AJAX_STATUS_SUCCESS, "查询成功", result);
        } catch (Exception e) {
            responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息异常");
            LOG.error("获取信息出错：", e);
        }
        return responseData;

	}

	/**
	 * 查询待审核商品 
	 */
	private PageInfoResponse<ProductEditUp> queryProductAudit(ProductQueryInfo queryInfo) {
		queryInfo.setTenantId(AdminUtil.getTenantId());
		queryInfo.setSupplierId(AdminUtil.getSupplierId());
        IProductManagerSV productManagerSV = DubboConsumerFactory.getService("iProductManagerSV");
        PageInfoResponse<ProductEditUp> result = productManagerSV.searchAudit(queryInfo);
        return fillProductInfo(result);
	}

	/**
	 * 点击查询按钮调用方法-获取售罄下架商品
	 * @return
	 */
	@RequestMapping("/getSaleDownList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getSaleDownProduct(
			HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		if(!request.getParameter("productName").isEmpty()){
			productEditQueryReq.setProdName(request.getParameter("productName"));
		}
		// 设置状态，62停用下架.
		List<String> stateList = new ArrayList<>();
		stateList.add("61");
		productEditQueryReq.setStateList(stateList);
		productEditQueryReq.setStateList(stateList);
		return queryByState(productEditQueryReq);
	}
	/**
	 * 点击查询按钮调用方法-获取库存暂停商品
	 * @return
	 */
	@RequestMapping("/getStorStopList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getStorStopProduct(
			HttpServletRequest request,ProductEditQueryReq productEditQueryReq){
		if(!request.getParameter("productName").isEmpty()){
			productEditQueryReq.setProdName(request.getParameter("productName"));
		}
		// 设置状态，62停用下架.
		List<String> stateList = new ArrayList<>();
		stateList.add("62");
		productEditQueryReq.setStateList(stateList);
        return queryByState(productEditQueryReq);
	}
	
	
	/**
	 * 查询 废弃商品
	 */
	@RequestMapping("/getScrapList")
	@ResponseBody
	public ResponseData<PageInfoResponse<ProductEditUp>> getScrap(ProductEditQueryReq productEditQueryReq){
		List<String> stateList = new ArrayList<>();
		stateList.add("7");
		productEditQueryReq.setStateList(stateList);
        return queryByState(productEditQueryReq);
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
        
        //查询商品其他设置
        OtherSetOfProduct otherSet = productManagerSV.queryOtherSetOfProduct(productInfoQuery);
        uiModel.addAttribute("otherSet",otherSet);
		if (ProductConstants.IsSaleNationwide.NO.equals(productInfo.getIsSaleNationwide())){
			//目标地域
			uiModel.addAttribute("areaInfoStr",getTargetOfProduct(otherSet.getAreaInfos()));
		}

        //商品主图
        uiModel.addAttribute("prodPic",otherSet.getProductPics());
        //属性值图
        uiModel.addAttribute("attrValList",otherSet.getAttrValInfoList());
        uiModel.addAttribute("valPicMap",otherSet.getAttrValPics());
        //设置商品详情
        setProdDetail(productInfo.getProDetailContent(),uiModel);
		
		return "product/viewproduct";
	}

	/**
	 * 根据ID查询单个商品的详细信息
	 */
	@RequestMapping("/audit/{id}")
	public String auditProduct(@PathVariable("id") String prodId, Model uiModel){
		toViewProduct(prodId, uiModel);
		return "prodaudit/auditproduct";
	}

	private ResponseData<PageInfoResponse<ProductEditUp>> queryByState(
			ProductEditQueryReq productEditQueryReq){
		ResponseData<PageInfoResponse<ProductEditUp>> responseData = null;
		try {
			// 查询条件
			PageInfoResponse<ProductEditUp> result = queryProductByState(productEditQueryReq);
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
					ResponseData.AJAX_STATUS_SUCCESS, "查询成功", result);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfoResponse<ProductEditUp>>(
					ResponseData.AJAX_STATUS_FAILURE, "获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}

	/**
	 * 设置商品详情信息
	 * @param fileId
	 * @param uiModel
	 */
	private void setProdDetail(String fileId, Model uiModel) {
		if (StringUtils.isBlank(fileId)) {
			return;
		}
		IDSSClient client = DSSClientFactory.getDSSClient(SysCommonConstants.ProductDetail.DSSNS);
		String context = client.findById(fileId);
		if (StringUtils.isNotBlank(context)) {
			JSONObject object = JSON.parseObject(context);
			uiModel.addAttribute("prodDetail", object.getString("content"));
		}
	}

	/**
	 * 查询条件检查设置
	 * @param request
	 * @param productEditQueryReq
	 */
	private void queryBuilder(HttpServletRequest request, ProductEditQueryReq productEditQueryReq) {
		productEditQueryReq.setTenantId(AdminUtil.getTenantId());
		productEditQueryReq.setSupplierId(AdminUtil.getSupplierId());
		if(!request.getParameter("productName").isEmpty()){
			productEditQueryReq.setProdName(request.getParameter("productName"));
		}

	}

	/**
	 * 根据状态不同查询商品
	 *
	 * @param productEditQueryReq
	 * @return
	 */
	private PageInfoResponse<ProductEditUp> queryProductByState(ProductEditQueryReq productEditQueryReq) {
		productEditQueryReq.setTenantId(AdminUtil.getTenantId());
        productEditQueryReq.setSupplierId(AdminUtil.getSupplierId());
        IProductManagerSV productManagerSV = DubboConsumerFactory.getService("iProductManagerSV");
        PageInfoResponse<ProductEditUp> result = productManagerSV.queryProductEdit(productEditQueryReq);
        return fillProductInfo(result);
	}

	/**
	 * 完善商品信息
	 * @param result
	 * @return
     */
	public PageInfoResponse<ProductEditUp> fillProductInfo(PageInfoResponse<ProductEditUp> result){
		ICacheSV cacheSV = DubboConsumerFactory.getService("iCacheSV");
		SysParamSingleCond sysParamSingleCond = null;
		for (ProductEditUp productEditUp : result.getResult()) {
			// 获取类型
			if (StringUtils.isNotBlank(productEditUp.getProductType())) {
				String productType = productEditUp.getProductType();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE,
						ComCacheConstants.TypeProduct.PROD_PRODUCT_TYPE, productType);
				String productTypeName = cacheSV.getSysParamSingle(sysParamSingleCond)
						.getColumnDesc();
				productEditUp.setProductTypeName(productTypeName);
			}
			// 获取状态
			if (StringUtils.isNotBlank(productEditUp.getState())) {
				String state = productEditUp.getState();
				sysParamSingleCond = new SysParamSingleCond(AdminUtil.getTenantId(),
						ComCacheConstants.TypeProduct.CODE,
						ComCacheConstants.TypeProduct.PROC_STATUS, state);
				String stateName = cacheSV.getSysParamSingle(sysParamSingleCond).getColumnDesc();
				productEditUp.setStateName(stateName);
			}
			// 产生图片地址
			if (StringUtils.isNotBlank(productEditUp.getVfsId())) {
				String vfsId = productEditUp.getVfsId();
				String picType = productEditUp.getPicType();
				String imageUrl = getImageUrl("80x80", vfsId, picType);
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
		if (StringUtils.isBlank(picType)){
			picType = ".jpg";
		}
		if (!picType.startsWith(".")){
			picType = "." + picType;
		}
		return imageClient.getImageUrl(vfsId, picType, attrImageSize);
	}

	/**
	 * 获取商品目标地域的字符串内容
	 * @param areaInfoList
	 * @return
     */
	private String getTargetOfProduct(List<ProdTargetAreaInfo> areaInfoList){
		if (CollectionUtil.isEmpty(areaInfoList)){
			return "";
		} 
		StringBuffer sb = new StringBuffer();
		for (ProdTargetAreaInfo areaInfo:areaInfoList){
			if (areaInfo.isOwn()){
				sb.append(areaInfo.getAreaName()+"、");
			}
		}
		//删除最后一个分隔号
		if(sb.length()>0){
			int last = sb.lastIndexOf("、");
			if (last==(sb.length()-1)){
				sb.deleteCharAt(last);
			}
		}
		return sb.toString();
	}

	/**
	 * 填充类目信息
     */
	private void getViewWithCats(Model uiModel){
		List<ProdCatInfo> productCatMap = prodCatService.loadRootCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoList", productCatMap);
	}
	
	/**
	 * 查询商品被拒绝原因
	 */
	@RequestMapping("/toViewReason/{id}")
	@ResponseBody
	public ResponseData<ProdStateLog> getRefuseReason(@PathVariable("id") String prodId){
		ResponseData<ProdStateLog> responseData;
			//根据商品ID查询商品被拒绝的原因
			IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
			ProductInfoQuery queryReq = new ProductInfoQuery();
			queryReq.setTenantId(AdminUtil.getTenantId());
			queryReq.setSupplierId(AdminUtil.getSupplierId());
			queryReq.setProductId(prodId);
		    ProdStateLog refuse = productManagerSV.queryRefuseByPordId(queryReq);
		    ResponseHeader header = refuse.getResponseHeader();
			
			 //保存错误
	        if (header!=null && !header.isSuccess()){
	        	LOG.error("Query by prodId is fail,prodId:{},headInfo:\r\n",prodId, JSON.toJSONString(header));
	            responseData = new ResponseData<ProdStateLog>(
	                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
	        }else{
	            responseData = new ResponseData<ProdStateLog>(
	                    ResponseData.AJAX_STATUS_SUCCESS, "OK",refuse);
	        }
		
		return responseData;
		
	}
}
