package com.ai.slp.product.web.controller.prodCat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.constants.ExceptCodeConstants;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.*;
import com.ai.slp.product.web.model.prodCat.ProdCatInfo;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

/**
 * Created by jackieliu on 16/8/11.
 */
@Controller
@RequestMapping("/cat/edit")
public class CatEditController {
    private static final Logger logger = LoggerFactory.getLogger(CatEditController.class);

    /**
     * 显示添加页面
     * @param parentId 父类目
     * @return
     */
    @RequestMapping("/addview")
    public String addView(String parentId, Model uiModel){
        uiModel.addAttribute("parentCatId",parentId);
        return "prodcat/catadd";
    }

    /**
     * 批量添加类目
     * @return
     */
    @RequestMapping(value = "/create",method = RequestMethod.POST)
    @ResponseBody
    public ResponseData<String> addCat(String catListStr, HttpSession session){
        List<ProdCatInfo> catInfoList = JSON.parseArray(catListStr,ProdCatInfo.class);
        List<ProductCatParam> catParamList = new ArrayList<>();
        for (ProdCatInfo catInfo:catInfoList){
            ProductCatParam catParam = new ProductCatParam();
            BeanUtils.copyProperties(catParam,catInfo);
            catParam.setTenantId(AdminUtil.getTenantId());
            catParam.setOperId(AdminUtil.getAdminId(session));
            catParamList.add(catParam);
        }
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        BaseResponse response = productCatSV.createProductCat(catParamList);
        return genResponse(response);
    }

    /**
     * 更新类目信息
     * @return
     */
    @RequestMapping(value = "/update",method = RequestMethod.POST)
    @ResponseBody
    public ResponseData<String> updateCat(ProductCatParam catParam,HttpSession session){
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        catParam.setTenantId(AdminUtil.getTenantId());
        catParam.setOperId(AdminUtil.getAdminId(session));
        BaseResponse response = productCatSV.updateProductCat(catParam);
        return genResponse(response);
    }

    /**
     * 删除类目信息
     * @param catId
     * @param session
     * @return
     */
    @RequestMapping(value = "/del/{id}")
    @ResponseBody
    public ResponseData<String> updateCat(@PathVariable("id") String catId, HttpSession session){
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProductCatUniqueReq uniqueReq = new ProductCatUniqueReq();
        uniqueReq.setTenantId(AdminUtil.getTenantId());
        uniqueReq.setProductCatId(catId);
        uniqueReq.setOperId(AdminUtil.getAdminId(session));
        BaseResponse response = productCatSV.deleteProductCat(uniqueReq);
        return genResponse(response);
    }

    /**
     * 更新类目的某个类型属性和属性值
     * @param catId
     * @param attrType
     * @param attrMap
     * @return
     */
    @RequestMapping(value = "/attr/type/{id}")
    @ResponseBody
    public ResponseData<String> upCatAttrByType(
            @PathVariable("id")String catId,String attrType, String attrMap,HttpSession session){
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        Map<Long,Set<String>> attrValMap = JSON.parseObject(attrMap,new TypeReference<Map<Long, Set<String>>>() {});
        ProdCatAttrAddParam addParam = new ProdCatAttrAddParam();
        addParam.setTenantId(AdminUtil.getTenantId());
        addParam.setOperId(AdminUtil.getAdminId(session));
        addParam.setProductCatId(catId);
        addParam.setAttrType(attrType);
        addParam.setAttrAndVal(attrValMap);
        BaseResponse response = productCatSV.addAttrForCatAndType(addParam);
        return genResponse(response);
    }

    /**
     * 删除属性关联或属性值关联
     * @param catAttrVal
     * @return
     */
    @RequestMapping("/attr/del")
    @ResponseBody
    public ResponseData<String> deleteCatAttrOrVal(ProdCatAttrVal catAttrVal,HttpSession session){
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        catAttrVal.setTenantId(AdminUtil.getTenantId());
        catAttrVal.setOperId(AdminUtil.getAdminId(session));
        BaseResponse response = productCatSV.deleteProductCatAttrOrVal(catAttrVal);
        return genResponse(response);
    }

    /**
     * 更新属性和属性值 
     */
    @RequestMapping("/attr/update")
    @ResponseBody
    public ResponseData<String> updateCatAttrAndVal(String catUpParamStr,HttpSession session){
        List<ProdCatAttrUpdateParam> paramList = JSON.parseArray(catUpParamStr,ProdCatAttrUpdateParam.class);
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProdCatAttrUpdateReq updateReq = new ProdCatAttrUpdateReq();
        updateReq.setTenantId(AdminUtil.getTenantId());
        updateReq.setOperId(AdminUtil.getAdminId(session));
        updateReq.setUpdateParamList(paramList);
        BaseResponse response = productCatSV.updateCatAttrAndVal(updateReq);
        return genResponse(response);
    }
    /**
     * 返回信息
     */
    private ResponseData<String> genResponse(BaseResponse response){
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS,"","");
        ResponseHeader header = response==null?null:response.getResponseHeader();
        if (header==null || !header.isSuccess()){
            String errorCode = header==null?ExceptCodeConstants.Special.SYSTEM_ERROR:header.getResultCode();
            String errMsg = header==null?"未知错误":header.getResultMessage();
            logger.error("Option cat is error,errorCode:{},errorMsg:{}",errorCode,errMsg);
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE, errMsg);
        }
        return responseData;
    }
}
