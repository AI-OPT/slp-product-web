package com.ai.slp.product.web.controller.normproduct;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import com.ai.slp.common.api.cache.interfaces.ICacheSV;
import com.ai.slp.product.api.normproduct.interfaces.INormProductSV;
import com.ai.slp.product.api.normproduct.param.NormProdSaveRequest;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.interfaces.IProductSV;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.AttrQueryForCat;
import com.ai.slp.product.api.productcat.param.ProdCatAttrDef;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.service.AttrAndValService;
import com.ai.slp.product.web.service.ProdCatService;

/**
 * 对标准品进行操作
 * @author jiawen
 *
 */
@Controller
@RequestMapping("/normprodedit")
public class NormProdEditController {
	
	private static final Logger LOG = LoggerFactory.getLogger(NormProdEditController.class);
	@Autowired
	private ProdCatService prodCatService;
	@Autowired
    private AttrAndValService attrAndValService;
    IProductManagerSV productManagerSV;
    IProductSV productSV;
    ICacheSV cacheSV;
    INormProductSV normProductSV;
    IProductCatSV productCatSV;

    public void initConsumer() {
        if (productManagerSV == null)
            productManagerSV = DubboConsumerFactory.getService(IProductManagerSV.class);
        if (productSV == null)
            productSV = DubboConsumerFactory.getService(IProductSV.class);
        if (cacheSV == null)
            cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        if (normProductSV == null)
            normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
        if (productCatSV == null)
            productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
    }
    /**
     * 跳转到新增页面
     * @param uiModel
     * @return
     */
    @RequestMapping("/add")
    public String addView(Model uiModel){
		Map<Short, List<ProdCatInfo>> productCatMap = prodCatService.loadCat();
		uiModel.addAttribute("count", productCatMap.size() - 1);
		uiModel.addAttribute("catInfoMap", productCatMap);
		Set<Entry<Short, List<ProdCatInfo>>> entrySet = productCatMap.entrySet();
		String productCatValues = "";
		for(Entry<Short, List<ProdCatInfo>> entry : entrySet){
			List<ProdCatInfo> value = entry.getValue();
			if(productCatValues != ""){
				productCatValues = productCatValues + "&gt;" +value.get(0).getProductCatName();
			}else{
				productCatValues = value.get(0).getProductCatName();
			}
			
		}
		uiModel.addAttribute("productCatValues", productCatValues);
    	return "normproduct/add";
    }
    
    /**
     * 显示添加页面
     * @return
     */
    @RequestMapping("/{id}")
    public String addinfoView(@PathVariable("id")String productCatId,Model uiModel){
    	//根据类目ID 加载标准品的关键属性  和  销售属性   1关键属性  2销售属性  3非关键属性
	    	//标准品关键属性 
	    	AttrQueryForCat attrQuery = new AttrQueryForCat();
	    	//设置类目ID
	    	//设置属性类型
	    	attrQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
	    	attrQuery.setProductCatId(productCatId);
	    	attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY);
			BaseListResponse<ProdCatAttrDef> keyAttrlist = productCatSV.queryAttrByCatAndType(attrQuery);
			uiModel.addAttribute("keyAttrlist",keyAttrlist.getResult());
			
			//标准品销售属性
			//设置类目ID
			//设置属性类型
			attrQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
	    	attrQuery.setProductCatId(productCatId);
	    	attrQuery.setAttrType(ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE);
			BaseListResponse<ProdCatAttrDef> saleAttrlist = productCatSV.queryAttrByCatAndType(attrQuery);
			uiModel.addAttribute("saleAttrlist",saleAttrlist.getResult());
			
			return "normproduct/addinfo";
			
			
    	
    	//根据类目ID 加载标准品的关键属性  和  销售属性
	    	//标准品关键属性
    	/*		AttrQueryForCat attrqueryforcat = new AttrQueryForCat();
    		String productCatId = request.getParameter("productCatId");
    		attrqueryforcat.setProductCatId(productCatId);
    		
    		IProductCatSV iProductCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
    	//	Map<ProdCatAttrDef, List<AttrValInfo>> attrMap = iProductCatSV.queryAttrByCatAndType(attrqueryforcat);
    		BaseListResponse<ProdCatAttrDef> catDefList = iProductCatSV.queryAttrByCatAndType(attrqueryforcat);
//    		uiModel.addAttribute("attrAndVal", attrAndValService.getAttrAndVals(attrMap));
	        
	        
    	//标准品的状态 --缓存中进行查询
    	SysParamMultiCond paramMultiCond = new SysParamMultiCond();
    	paramMultiCond.setParamCode(ComCacheConstants.NormProduct.STATUS);
    	List<SysParam> states = cacheSV.getSysParamList(paramMultiCond);
    	uiModel.addAttribute("state",states);*/
    	
    	//return "normproduct/addinfo";
    }
    
    /**
     * 保存
     */
    @RequestMapping("/save")
    @ResponseBody
    public ResponseData<String> saveProductInfo(NormProdSaveRequest normInfo, HttpServletRequest request, HttpSession session){
    	ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS, "添加成功");
        initConsumer();
    	//标准品名称
        normInfo.setProductName( request.getParameter("standedProductName"));
        
        //标准品类型
        normInfo.setProductType(request.getParameter("productType"));
        
        //标准品关键属性
        
        
    	//标准品销售属性
        
        
        //标准品状态
        normInfo.setState(request.getParameter("state"));
        
    	//保存
        INormProductSV normProductSV = DubboConsumerFactory.getService(INormProductSV.class);
        BaseResponse response = normProductSV.createProductInfo(normInfo);
        
        ResponseHeader header = response.getResponseHeader();
       //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, "更新失败:"+header.getResultMessage());
        }
        return responseData;
    }
    
}
