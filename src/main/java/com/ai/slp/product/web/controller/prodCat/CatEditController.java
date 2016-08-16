package com.ai.slp.product.web.controller.prodCat;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.constants.ExceptCodeConstants;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProductCatParam;
import com.ai.slp.product.api.productcat.param.ProductCatUniqueReq;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.model.prodCat.ProdCatInfo;
import com.ai.slp.product.web.util.AdminUtil;
import com.alibaba.fastjson.JSON;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by jackieliu on 16/8/11.
 */
@Controller
@RequestMapping("/cat/edit")
public class CatEditController {
    private static Logger logger = LoggerFactory.getLogger(CatEditController.class);

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
        ResponseData<String> responseData = new ResponseData<String>(
                ResponseData.AJAX_STATUS_SUCCESS, ExceptCodeConstants.Special.SUCCESS);
        List<ProdCatInfo> catInfoList = JSON.parseArray(catListStr,ProdCatInfo.class);
        List<ProductCatParam> catParamList = new ArrayList<>();
        for (ProdCatInfo catInfo:catInfoList){
            ProductCatParam catParam = new ProductCatParam();
            System.out.println(catInfo.getProductCatName()+":"+catInfo.getParentProductCatId());
            BeanUtils.copyProperties(catParam,catInfo);
            catParam.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            catParam.setOperId(AdminUtil.getAdminId(session));
            catParamList.add(catParam);
        }
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        BaseResponse response = productCatSV.createProductCat(catParamList);
        ResponseHeader header = response==null?null:response.getResponseHeader();
        if (header==null || !header.isSuccess()){
            String errorCode = header==null?ExceptCodeConstants.Special.SYSTEM_ERROR:header.getResultCode();
            String errMsg = header==null?"未知错误":header.getResultMessage();
            logger.error(" Create cat is error,errorCode:{},errorMsg:{}",errorCode,errMsg);
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, errorCode,errMsg);
        }
        return responseData;
    }

    /**
     * 更新类目信息
     * @return
     */
    @RequestMapping(value = "/update",method = RequestMethod.POST)
    @ResponseBody
    public ResponseData<String> updateCat(ProductCatParam catParam,HttpSession session){
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS,"","");
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        catParam.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        catParam.setOperId(AdminUtil.getAdminId(session));
        BaseResponse response = productCatSV.updateProductCat(catParam);
        ResponseHeader header = response==null?null:response.getResponseHeader();
        if (header==null || !header.isSuccess()){
            String errorCode = header==null?ExceptCodeConstants.Special.SYSTEM_ERROR:header.getResultCode();
            String errMsg = header==null?"未知错误":header.getResultMessage();
            logger.error("Update cat is error,errorCode:{},errorMsg:{}",errorCode,errMsg);
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, errorCode,errMsg);
        }
        return responseData;
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
        ResponseData<String> responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_SUCCESS,"","");
        IProductCatSV productCatSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProductCatUniqueReq uniqueReq = new ProductCatUniqueReq();
        uniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        uniqueReq.setProductCatId(catId);
        uniqueReq.setOperId(AdminUtil.getAdminId(session));
        BaseResponse response = productCatSV.deleteProductCat(uniqueReq);
        ResponseHeader header = response==null?null:response.getResponseHeader();
        if (header==null || !header.isSuccess()){
            String errorCode = header==null?ExceptCodeConstants.Special.SYSTEM_ERROR:header.getResultCode();
            String errMsg = header==null?"未知错误":header.getResultMessage();
            logger.error("Delete cat is error,errorCode:{},errorMsg:{}",errorCode,errMsg);
            responseData = new ResponseData<String>(
                    ResponseData.AJAX_STATUS_FAILURE, errorCode,errMsg);
        }
        return responseData;
    }
}
