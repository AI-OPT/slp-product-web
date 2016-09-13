package com.ai.slp.product.web.controller.product;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.product.interfaces.IProductManagerSV;
import com.ai.slp.product.api.product.param.ProductCheckParam;
import com.ai.slp.product.api.product.param.ProductInfoQuery;
import com.ai.slp.product.web.constants.AuditStatus;
import com.ai.slp.product.web.util.AdminUtil;

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
        BaseResponse baseResponse = productManagerSV.changeToInSale(productInfoQuery);
        LOG.debug("上架返回信息:" + JSonUtil.toJSon(baseResponse));
        ResponseHeader header = baseResponse.getResponseHeader();
        // 上架出错
        if (header != null && !header.isSuccess()) {
            responseData = new ResponseData<String>(ResponseData.AJAX_STATUS_FAILURE,
                    "添加失败:" + header.getResultMessage());
        }
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
        ArrayList<String> idList = new ArrayList<>();
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
        String id[] = ids.split(",");
        ArrayList<String> idList = new ArrayList<>();
        for (int i = 0; i < id.length; i++) {
            idList.add(id[i]);
        }
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
        String id[] = ids.split(",");
        ArrayList<String> idList = new ArrayList<>();
        for (int i = 0; i < id.length; i++) {
            idList.add(id[i]);
        }
        productCheckParam.setProdIdList(idList);
        return auditProduct(productCheckParam, AuditStatus.REJECT);
    }

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

}
