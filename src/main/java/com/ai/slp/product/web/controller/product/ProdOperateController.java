package com.ai.slp.product.web.controller.product;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseListResponse;
import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.CollectionUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.product.param.OtherSetOfProduct;
import com.ai.slp.product.api.product.param.ProdTargetAreaInfo;
import com.ai.slp.product.api.product.param.ProductCheckParam;
import com.ai.slp.product.api.product.param.ProductInfo;
import com.ai.slp.product.api.product.param.ProductInfoQuery;
import com.ai.slp.product.api.product.param.SaleAreaInfoNew;
import com.ai.slp.product.api.storage.interfaces.IStorageSV;
import com.ai.slp.product.api.storage.param.StorageGroupQuery;
import com.ai.slp.product.api.storage.param.StorageGroupRes;
import com.ai.slp.product.api.storage.param.StorageGroupRestwo;
import com.ai.slp.product.web.constants.AuditStatus;
import com.ai.slp.product.web.constants.ProductConstants;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.route.api.routeitemmanage.interfaces.IRouteItemManageSV;
import com.ai.slp.route.api.routeitemmanage.param.RouteGroupIdQueryRequest;
import com.ai.slp.route.api.routeitemmanage.param.RouteItemListResponse;
import com.ai.slp.route.api.routeitemmanage.param.RouteItemVo;
import com.ai.slp.route.api.routetargetarea.interfaces.IRouteTargetAreaSV;
import com.ai.slp.route.api.routetargetarea.param.AreaQueryByRouteItemIdRequest;
import com.ai.slp.route.api.routetargetarea.param.AreaQueryByRouteItemIdResponse;
import com.ai.slp.route.api.routetargetarea.param.AreaQueryByRouteItemIdVo;
import com.alibaba.fastjson.JSON;
import com.fasterxml.jackson.annotation.JsonTypeInfo.Id;

/**
 * 商品管理相关的商品操作 Created by lipeng16 on 16/7/6.
 */
@Controller
@RequestMapping("/prodOperate")
public class ProdOperateController {
    private static final Logger LOG = LoggerFactory.getLogger(ProdOperateController.class);

    /**
     * 待上架商品上架
     */
    @RequestMapping("/prodToSale")
    @ResponseBody
    public ResponseData<String> prodToInSale(@RequestParam String productId, HttpSession session) {
        LOG.info("start to in sale");
        ResponseData<String> responseData = new ResponseData<String>(
                ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
        IProductManagerSV productManagerSV = DubboConsumerFactory
                .getService(IProductManagerSV.class);
        // 封装参数进行上架操作
        ProductInfoQuery productInfoQuery = new ProductInfoQuery();
        productInfoQuery.setTenantId(AdminUtil.getTenantId());
        productInfoQuery.setSupplierId(AdminUtil.getSupplierId());
        productInfoQuery.setOperId(AdminUtil.getAdminId(session));
        productInfoQuery.setProductId(productId);
        long inSaleStart = System.currentTimeMillis();
        LOG.info("=====执行productManagerSV.changeToInSale进行上架操作,当前时间戳: " + inSaleStart );
        BaseResponse baseResponse = productManagerSV.changeToInSale(productInfoQuery);
        long inSaleEnd = System.currentTimeMillis();
        LOG.info("=====上架操作执行完毕,当前时间戳: " + inSaleEnd + ",用时:" + (inSaleEnd-inSaleStart) +"毫秒");
        LOG.info("call changeToInSale is end");
        LOG.debug("上架返回信息:" + JSonUtil.toJSon(baseResponse));
        ResponseHeader header = baseResponse.getResponseHeader();
        // 上架出错
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,
                    "添加失败:" + header.getResultMessage());
        }
        LOG.info("to sale is finish");
        return responseData;
    }

    /**
     * 商品手动下架
     */
    @RequestMapping("/prodInStore")
    @ResponseBody
    public ResponseData<String> prodToInStore(@RequestParam String productId, HttpSession session) {
        ResponseData<String> responseData = new ResponseData<String>(
                ResponseData.AJAX_STATUS_SUCCESS, "下架成功");
        IProductManagerSV productManagerSV = DubboConsumerFactory
                .getService(IProductManagerSV.class);
        ProductInfoQuery productInfoQuery = new ProductInfoQuery();
        productInfoQuery.setTenantId(AdminUtil.getTenantId());
        productInfoQuery.setSupplierId(AdminUtil.getSupplierId());
        productInfoQuery.setOperId(AdminUtil.getAdminId(session));
        productInfoQuery.setProductId(productId);
        BaseResponse baseResponse = productManagerSV.changeToInStore(productInfoQuery);
        LOG.debug("下架返回信息:" + JSonUtil.toJSon(baseResponse));
        ResponseHeader header = baseResponse.getResponseHeader();
        // 下架出错
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,
                    "下架失败:" + header.getResultMessage());
        }

        return responseData;
    }

    /**
     * 单个商品审核通过
     */
    @RequestMapping("/auditPass")
    @ResponseBody
    public ResponseData<String> passProduct(String id) {
        ProductCheckParam productCheckParam = new ProductCheckParam();
        List<String> idList = new ArrayList<>();
        idList.add(id);
        productCheckParam.setProdIdList(idList);
        return auditProduct(productCheckParam, AuditStatus.PASS);
    }

    /**
     * 批量审核通过
     *
     * @param ids
     * @return
     */
    @RequestMapping("/auditPassMore")
    @ResponseBody
    public ResponseData<String> passProducts(String ids) {
        ProductCheckParam productCheckParam = new ProductCheckParam();
        String[] idArry = ids.split(",");
        List<String> idList = Arrays.asList(idArry);
        productCheckParam.setProdIdList(idList);
        return auditProduct(productCheckParam, AuditStatus.PASS);
    }

    /**
     * 单个商品审核拒绝
     */
    @RequestMapping("/auditReject")
    @ResponseBody
    public ResponseData<String> rejectProduct(ProductCheckParam productCheckParam) {
        return auditProduct(productCheckParam, AuditStatus.REJECT);
    }

    /**
     * 批量商品审核拒绝
     *
     * @param ids
     * @return
     */
    @RequestMapping("/auditRejectMore")
    @ResponseBody
    public ResponseData<String> rejectProducts(String ids, ProductCheckParam productCheckParam) {
        String[] idArry = ids.split(",");
        List<String> idList = Arrays.asList(idArry);
        productCheckParam.setProdIdList(idList);
        return auditProduct(productCheckParam, AuditStatus.REJECT);
    }
    //商品审核
    private ResponseData<String> auditProduct(ProductCheckParam productCheckParam,
            AuditStatus status) {
        ResponseData<String> responseData = new ResponseData<String>(
                ResponseData.AJAX_STATUS_SUCCESS, "审核成功");
        IProductManagerSV productManagerSV = DubboConsumerFactory
                .getService(IProductManagerSV.class);
        // 设置租户ID
        productCheckParam.setTenantId(AdminUtil.getTenantId());
        // 设置操作人
        productCheckParam.setOperId(AdminUtil.getAdminId());
        // 设置点击按钮 0:通过按钮 1:拒绝按钮
        productCheckParam.setState(status.getStatus());

        BaseResponse baseResponse = productManagerSV.productCheck(productCheckParam);
        LOG.debug("审核返回信息:" + JSonUtil.toJSon(baseResponse));
        ResponseHeader header = baseResponse.getResponseHeader();
        // 审核通过出错
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,
                    "审核失败:" + header.getResultMessage());
        }
        return responseData;
    }

	
	/**
	 * 单个商品的地域校验
	 * 校验仓库分配地域是否大于等于商品销售地域
	 */
	@RequestMapping("/toValidate/{id}")
	@ResponseBody
    public String toValidate(@PathVariable("id") String prodId) {
		
        String tenantId = AdminUtil.getTenantId();
        String supplierId = AdminUtil.getSupplierId();
        Long adminId = AdminUtil.getAdminId();
        
        //获取商品的销售地域
        ProductInfoQuery productInfoQuery = new ProductInfoQuery();
        productInfoQuery.setTenantId(tenantId);
        productInfoQuery.setSupplierId(supplierId);
        productInfoQuery.setOperId(adminId);
        productInfoQuery.setProductId(prodId);
        
        //查询单个商品的销售地域
       /* IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
        OtherSetOfProduct otherSetOfProduct = productManagerSV.queryOtherSetOfProduct(productInfoQuery);
        List<ProdTargetAreaInfo> areaInfos = otherSetOfProduct.getAreaInfos();*/
        IProductSV prodSV = DubboConsumerFactory.getService(IProductSV.class);
		ProductInfo productInfo = prodSV.queryProductById(productInfoQuery);
		IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
		OtherSetOfProduct otherSet = productManagerSV.queryOtherSetOfProduct(productInfoQuery);
		List<ProdTargetAreaInfo> areaInfoList = new ArrayList<>();
        if (ProductConstants.IsSaleNationwide.NO.equals(productInfo.getIsSaleNationwide())){
			//目标地域
        	//List<SaleAreaInfoNew> saleAreaInfos = productInfo.getSaleAreaInfos();
        	for (SaleAreaInfoNew saleAreaInfos : productInfo.getSaleAreaInfos()) {
        		ProdTargetAreaInfo areaInfo = new ProdTargetAreaInfo();
        		areaInfo.setProvinceCode(saleAreaInfos.getProvcode());
        		areaInfoList.add(areaInfo);
			}
        	
        	/*for (ProdTargetAreaInfo areaInfo:otherSet.getAreaInfos()){
        		if (areaInfo.isOwn()){
        			areaInfoList.add(areaInfo);
        		}
        	}*/
		}else {
			for (int i = 0; i < otherSet.getAreaInfos().size(); i++) {
				areaInfoList.add(otherSet.getAreaInfos().get(i));
			}
		}
        
        
		//1.根据routeGroupid查询出routeItemList
		//查询routeGroupId   prodid--standedprodid--rougroupid
        IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        ProductInfo queryProductById = productSV.queryProductById(productInfoQuery);
        
        IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        StorageGroupQuery groupQuery = new StorageGroupQuery();
        groupQuery.setTenantId(tenantId);
        groupQuery.setSupplierId(supplierId);
        groupQuery.setProductId(queryProductById.getStandedProdId());
        groupQuery.setGroupId(queryProductById.getStorageGroupId());
        StorageGroupRestwo groupRes = storageSV.queryGroupInfoAllByGroupId(groupQuery);
        
        IRouteItemManageSV itemManageSV = DubboConsumerFactory.getService(IRouteItemManageSV.class);
        RouteGroupIdQueryRequest routeGroupIdQueryRequest = new RouteGroupIdQueryRequest();
        routeGroupIdQueryRequest.setRouteGroupId(groupRes.getRouteGroupId());
        //路由组成
		RouteItemListResponse routeItemListResponse = itemManageSV.queryRouteItemList(routeGroupIdQueryRequest);
		//遍历   获取集合所有地域信息
		List<String> routeAreaList = new ArrayList<>();
		
		if(!CollectionUtil.isEmpty(routeItemListResponse.getVoList())){
			for(RouteItemVo routeItemVo : routeItemListResponse.getVoList()){
				IRouteTargetAreaSV routeTargetAreaSV = DubboConsumerFactory.getService(IRouteTargetAreaSV.class);
				AreaQueryByRouteItemIdRequest request = new AreaQueryByRouteItemIdRequest();
				request.setTenantId(tenantId);
				request.setRouteItemId(routeItemVo.getRouteItemId());
				AreaQueryByRouteItemIdResponse areaListByRouteItemId = routeTargetAreaSV.queryAreaListByRouteItemId(request);
				for (int i = 0; i < areaListByRouteItemId.getVoList().size(); i++) {
					routeAreaList.add(areaListByRouteItemId.getVoList().get(i).getAreaCode());
				}
			}
		}
		
        return routeItemIdInTargetArea(areaInfoList,routeAreaList);
    }
	
	
	
	/**
	 * 判断商品域的区域是否在配货组下的仓库域已经选择
	 * @param routeItemId
	 * @param areaQueryByRouteItemIdResponse
	 * @return
	 * @author jiawen
	 * @ApiDocMethod
	 * @ApiCode
	 */
	public String routeItemIdInTargetArea(List<ProdTargetAreaInfo> areaInfos,List<String> routeAreaList){
		String flag = "true";
		
		if (routeAreaList != null && areaInfos != null) {
			for(ProdTargetAreaInfo area :areaInfos){
				if(!routeAreaList.contains(area.getProvinceCode())){
					flag = "false";
					break;
				}
			}
		}else if(CollectionUtil.isEmpty(routeAreaList)){            //else if (StringUtils.isEmpty(routeAreaList.get(0))) {
			flag = "false";
		}
		return flag;
	}
	
	/**
	 * 批量商品的地域校验
	 * 
	 */
	@RequestMapping("/toValidateMore")
	@ResponseBody
    public String toValidateMore(String ids) {
		String flag = "true";
		String[] idArry = ids.split(",");
        List<String> idList = Arrays.asList(idArry);
		
		
        String tenantId = AdminUtil.getTenantId();
        String supplierId = AdminUtil.getSupplierId();
        Long adminId = AdminUtil.getAdminId();
        
        //获取商品的销售地域
        for (int i = 0; i < idArry.length; i++) {
	        ProductInfoQuery productInfoQuery = new ProductInfoQuery();
	        productInfoQuery.setTenantId(tenantId);
	        productInfoQuery.setSupplierId(supplierId);
	        productInfoQuery.setOperId(adminId);
        	productInfoQuery.setProductId(idList.get(i));
        	//查询单个商品的销售地域
/*        	IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
        	OtherSetOfProduct otherSetOfProduct = productManagerSV.queryOtherSetOfProduct(productInfoQuery);
        	List<ProdTargetAreaInfo> areaInfos = otherSetOfProduct.getAreaInfos();*/
        	
        	 IProductSV prodSV = DubboConsumerFactory.getService(IProductSV.class);
     		ProductInfo productInfo = prodSV.queryProductById(productInfoQuery);
     		IProductManagerSV productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
     		OtherSetOfProduct otherSet = productManagerSV.queryOtherSetOfProduct(productInfoQuery);
     		List<ProdTargetAreaInfo> areaInfoList = new ArrayList<>();
             if (ProductConstants.IsSaleNationwide.NO.equals(productInfo.getIsSaleNationwide())){
     			//目标地域
             	for (ProdTargetAreaInfo areaInfo:otherSet.getAreaInfos()){
             		if (areaInfo.isOwn()){
             			areaInfoList.add(areaInfo);
             		}
             	}
     		}else{
     			for (int n = 0; n < otherSet.getAreaInfos().size(); n++) {
    				areaInfoList.add(otherSet.getAreaInfos().get(n));
    			}
     		}
			
        	//1.根据routeGroupid查询出routeItemList
        	//查询routeGroupId   prodid--standedprodid--rougroupid
        	IProductSV productSV = DubboConsumerFactory.getService(IProductSV.class);
        	ProductInfo queryProductById = productSV.queryProductById(productInfoQuery);
        	
        	IStorageSV storageSV = DubboConsumerFactory.getService(IStorageSV.class);
        	StorageGroupQuery groupQuery = new StorageGroupQuery();
        	groupQuery.setTenantId(tenantId);
        	groupQuery.setSupplierId(supplierId);
        	groupQuery.setProductId(queryProductById.getStandedProdId());
        	groupQuery.setGroupId(queryProductById.getStorageGroupId());
        	StorageGroupRestwo groupRes = storageSV.queryGroupInfoAllByGroupId(groupQuery);
        	
        	IRouteItemManageSV itemManageSV = DubboConsumerFactory.getService(IRouteItemManageSV.class);
        	RouteGroupIdQueryRequest routeGroupIdQueryRequest = new RouteGroupIdQueryRequest();
        	routeGroupIdQueryRequest.setRouteGroupId(groupRes.getRouteGroupId());
        	//路由组成
        	RouteItemListResponse routeItemListResponse = itemManageSV.queryRouteItemList(routeGroupIdQueryRequest);
        	//2遍历   获取集合所有地域信息
        	List<String> routeAreaList = new ArrayList<>();
        	
        	if(!CollectionUtil.isEmpty(routeItemListResponse.getVoList())){
        		for(RouteItemVo routeItemVo : routeItemListResponse.getVoList()){
        			IRouteTargetAreaSV routeTargetAreaSV = DubboConsumerFactory.getService(IRouteTargetAreaSV.class);
        			AreaQueryByRouteItemIdRequest request = new AreaQueryByRouteItemIdRequest();
        			request.setTenantId(tenantId);
        			request.setRouteItemId(routeItemVo.getRouteItemId());
        			AreaQueryByRouteItemIdResponse areaListByRouteItemId = routeTargetAreaSV.queryAreaListByRouteItemId(request);
        			for (int l = 0; l < areaListByRouteItemId.getVoList().size(); l++) {
        				routeAreaList.add(areaListByRouteItemId.getVoList().get(l).getAreaCode());
        			}
        		}
        	}
        	
          flag = routeItemIdInTargetArea(areaInfoList,routeAreaList);
          if (flag.equals("false")) {
			return flag;
          }
		}
		return flag;
    }
	
}
