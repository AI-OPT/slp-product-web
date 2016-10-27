package com.ai.slp.product.web.controller.normproduct;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.ws.rs.PathParam;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseListResponse;
import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.StringUtil;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.AttrValRequest;
import com.ai.slp.product.api.normproduct.param.NormProdInfoResponse;
import com.ai.slp.product.api.normproduct.param.NormProdSaveRequest;
import com.ai.slp.product.api.normproduct.param.NormProdUniqueReq;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.AttrQueryForCat;
import com.ai.slp.product.api.productcat.param.ProdCatAttrDef;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.service.ProdCatService;
import com.ai.slp.product.web.util.AdminUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

/**
 * 对标准品进行操作
 * 
 * @author jiawen
 *
 */
@Controller
@RequestMapping("/normprodedit")
public class NormProdEditController {

	private static final Logger LOG = LoggerFactory.getLogger(NormProdEditController.class);
	@Autowired
	private ProdCatService prodCatService;
	private INormProductSV normProductSV;
	private IProductCatSV productCatSV;

	public void initConsumer() {
		if (normProductSV == null){
			normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
		}
		if (productCatSV == null){
			productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
		}
	}

	/**
	 * 跳转到新增页面
	 * 
	 * @param uiModel
	 * @return
	 */
	@RequestMapping("/add")
	public String addView(Model uiModel) {
		Map<Short, List<ProdCatInfo>> productCatMap = prodCatService.loadCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoMap", productCatMap);
//		Set<Entry<Short, List<ProdCatInfo>>> entrySet = productCatMap.entrySet();
//		String productCatValues = "";
//		for (Entry<Short, List<ProdCatInfo>> entry : entrySet) {
//			List<ProdCatInfo> value = entry.getValue();
//			if (productCatValues != "") {
//				productCatValues = productCatValues + "&gt;" + value.get(0).getProductCatName();
//			} else {
//				productCatValues = value.get(0).getProductCatName();
//			}
//
//		}
//		uiModel.addAttribute("productCatValues", productCatValues);
		return "normproduct/add";
	}

	/**
	 * 显示添加页面
	 * 
	 * @return
	 */
	@RequestMapping("/addProduct")
	public String addinfoView(String productCatId, Model uiModel) {
		initConsumer();
		// 设置类目ID
		uiModel.addAttribute("productCatId", productCatId);
		// 查询类目链
		long queryCatLinkListStart = System.currentTimeMillis();
		LOG.info("=====查询商品类目列开始 start to queryCatLinkListl,当前时间戳: "+queryCatLinkListStart);
		uiModel.addAttribute("catLinkList", prodCatService.queryLink(productCatId));
		long queryCatLinkListEnd = System.currentTimeMillis();
		LOG.info("=====查询商品类目列结束 queryCatLinkListl is end ,当前时间戳: "+ queryCatLinkListEnd + ",用时" +(queryCatLinkListEnd-queryCatLinkListStart)+"毫秒");
		// 标准品属性对象
		uiModel.addAttribute("normProdInfo", new NormProdInfoResponse());
		// 根据类目ID 加载标准品的关键属性 和 销售属性 1关键属性 2销售属性 3非关键属性
		// 标准品关键属性
		AttrQueryForCat attrQuery = new AttrQueryForCat();
		attrQuery.setTenantId(AdminUtil.getTenantId());
		attrQuery.setProductCatId(productCatId);
		attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
		long  queryAttrStart= System.currentTimeMillis();
		LOG.info("=====查询类目下的关键属性集合 start to queryAttr, 当前时间戳" + queryAttrStart);
		BaseListResponse<ProdCatAttrDef> keyAttrlist = productCatSV.queryAttrByCatAndType(attrQuery);
		long  queryAttrEnd = System.currentTimeMillis();
		LOG.info("=====查询类目下的关键属性集合 queryAttr is end, 当前时间戳"+ queryAttrEnd + ",用时:" + (queryAttrEnd-queryAttrStart) + "毫秒");
		uiModel.addAttribute("keyAttrlist", keyAttrlist.getResult());
		
		// 标准品销售属性
		// 设置类目ID
		// 设置属性类型
		attrQuery.setTenantId(AdminUtil.getTenantId());
		attrQuery.setProductCatId(productCatId);
		attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
		long  queryAttrsStart= System.currentTimeMillis();
		LOG.info("=====查询类目下的销售属性集合 start to queryAttr, 当前时间戳" + queryAttrStart);
		BaseListResponse<ProdCatAttrDef> saleAttrlist = productCatSV.queryAttrByCatAndType(attrQuery);
		long  queryAttrsEnd= System.currentTimeMillis();
		LOG.info("=====查询类目下的销售属性集合 queryAttr is end, 当前时间戳"+ queryAttrsEnd +",用时:" + (queryAttrsEnd-queryAttrsStart) + "毫秒");
		uiModel.addAttribute("saleAttrlist", saleAttrlist.getResult());
		
		return "normproduct/editinfo";
	}

	/**
	 * 显示添加页面
	 * 
	 * @return
	 */
	@RequestMapping("/{id}")
	public String modifyinfoView(@PathVariable("id") String prodId, Model uiModel) {
		initConsumer();
		// 标准品ID
		uiModel.addAttribute("standedProdId", prodId);
		// 查询标准品信息
		NormProdUniqueReq normProdUniqueReq = new NormProdUniqueReq();
		normProdUniqueReq.setProductId(prodId);
		normProdUniqueReq.setTenantId(AdminUtil.getTenantId());
		normProdUniqueReq.setSupplierId(AdminUtil.getSupplierId());
		NormProdInfoResponse normProdInfoResponse = normProductSV.queryProducById(normProdUniqueReq);
		uiModel.addAttribute("productInfo", normProdInfoResponse);
		// 查询类目链
		String productCatId = normProdInfoResponse.getProductCatId();
		uiModel.addAttribute("catLinkList", prodCatService.queryLink(productCatId));
		uiModel.addAttribute("productCatId", productCatId);

		// 标准品关键属性
		AttrQueryForCat attrForQuery = new AttrQueryForCat();
		attrForQuery.setTenantId(AdminUtil.getTenantId());
		attrForQuery.setProductCatId(productCatId);
		attrForQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
		BaseListResponse<ProdCatAttrDef> keyAttrlist = productCatSV.queryAttrByCatAndType(attrForQuery);
		List<ProdCatAttrDef> keyAttrList = keyAttrlist.getResult();
		uiModel.addAttribute("keyAttrlist", keyAttrList);
		// 标准品销售属性
		attrForQuery.setTenantId(AdminUtil.getTenantId());
		attrForQuery.setProductCatId(productCatId);
		attrForQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
		BaseListResponse<ProdCatAttrDef> saleAttrlist = productCatSV.queryAttrByCatAndType(attrForQuery);
		uiModel.addAttribute("saleAttrlist", saleAttrlist.getResult());
		
		return "normproduct/editinfo";
	}

	/**
	 * 保存
	 */
	@RequestMapping("/save")
	@ResponseBody
	public ResponseData<String> saveProductInfo(NormProdSaveRequest normInfo, HttpServletRequest request,
			HttpSession session) {
		ResponseData<String> responseData = null;

		List<AttrValRequest> attrValList = new LinkedList<AttrValRequest>();
		Gson gson = new Gson();
		// 标准品关键属性
		
		String keyAttrStr = request.getParameter("keyAttrStr");
		if (!StringUtil.isBlank(keyAttrStr)) {
			List<AttrValRequest> keyAttrValList = gson.fromJson(keyAttrStr, new TypeToken<List<AttrValRequest>>() {
			}.getType());
			attrValList.addAll(keyAttrValList);
		}
		// 标准品销售属性
		String saleAttrStr = request.getParameter("saleAttrStr");
		if (!StringUtil.isBlank(saleAttrStr)) {
			List<AttrValRequest> saleAttrValList = gson.fromJson(saleAttrStr, new TypeToken<List<AttrValRequest>>() {
			}.getType());
			attrValList.addAll(saleAttrValList);
		}
		normInfo.setAttrValList(attrValList);
		normInfo.setTenantId(AdminUtil.getTenantId());
		normInfo.setSupplierId(AdminUtil.getSupplierId());
		normInfo.setOperId(AdminUtil.getAdminId(session));
		// 保存
		if(StringUtil.isBlank(normInfo.getProductId())){
			normInfo.setCreateId(AdminUtil.getAdminId(session));
			long createStart = System.currentTimeMillis();
			LOG.info("=====执行normProductSV.createProductAndStoGroup添加标准品信息,当前时间戳: " + createStart );
			BaseResponse response = normProductSV.createProductAndStoGroup(normInfo);
			long createEnd = System.currentTimeMillis();
			LOG.info("=====执行normProductSV.createProductAndStoGroup添加标准品信息结束,当前时间戳: " + createEnd +",用时:" + (createEnd-createStart)+"毫秒" );
			if(response != null){
				ResponseHeader header = response.getResponseHeader();
				// 保存错误
				if (header != null && !header.isSuccess()) {
					responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,
							"添加失败:" + header.getResultMessage());
					LOG.error("获取信息出错：", header.getResultMessage());
				}else{
					responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
				}
			}
		}else{
			BaseResponse response = normProductSV.updateProductAndStoGroup(normInfo);	
			if(response != null){
				ResponseHeader header = response.getResponseHeader();
				// 保存错误
				if (header != null && !header.isSuccess()) {
					responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,
							"更新失败:" + header.getResultMessage());
					LOG.error("获取信息出错：", header.getResultMessage());
				}else{
					responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "更新成功");
				}
			}
		}
		return responseData;
	}
	
	/**
	 * 废弃标准品
	 * @param prodId
	 * @param session
	 * @return
	 */
	@RequestMapping("/discard")
	@ResponseBody
	public ResponseData<String> discardProduct(@PathParam("prodId") String prodId, HttpSession session ){
		initConsumer();
		NormProdUniqueReq paramNormProdUniqueReq = new NormProdUniqueReq();
		paramNormProdUniqueReq.setOperId(AdminUtil.getAdminId(session));
		paramNormProdUniqueReq.setTenantId(AdminUtil.getTenantId());
		paramNormProdUniqueReq.setSupplierId(AdminUtil.getSupplierId());
		paramNormProdUniqueReq.setProductId(prodId);
		BaseResponse discardProduct = normProductSV.discardProductWithStorage(paramNormProdUniqueReq );
		if(discardProduct.getResponseHeader().isSuccess()){
			return new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "操作成功");
		}else{
			LOG.error("获取信息出错：", discardProduct.getResponseHeader().getResultMessage());
			return new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, discardProduct.getResponseHeader().getResultMessage());
		}
	}
}
