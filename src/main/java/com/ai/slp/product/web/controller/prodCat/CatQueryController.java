package com.ai.slp.product.web.controller.prodCat;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.base.vo.ResponseHeader;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.*;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.model.prodCat.ProdCatQuery;
import com.ai.slp.product.web.vo.ProdQueryCatVo;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * 类目查询
 * Created by jackieliu on 16/7/26.
 */
@Controller
@RequestMapping("/cat/query")
public class CatQueryController {
    private static Logger logger = LoggerFactory.getLogger(CatQueryController.class);

    /**
     * 查询类目的子类目
     *
     * @return
     */
    @RequestMapping("/child")
    @ResponseBody
    public List<ProdQueryCatVo> queryChildCat(String prodCatId) {
        List<ProdQueryCatVo> prodQueryCatVoList = new ArrayList<>();
        try {
            IProductCatSV productCatSV = DubboConsumerFactory.getService("iProductCatSV");
            //通过id查询当前类目信息
            ProductCatUniqueReq productCatUniqueReq = new ProductCatUniqueReq();
            productCatUniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            productCatUniqueReq.setProductCatId(prodCatId);
            ProductCatInfo productCatInfo = productCatSV.queryByCatId(productCatUniqueReq);
            ProductCatQuery catQuery = new ProductCatQuery();
            ProdCatInfo prodCatInfo = null;
            catQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            //如果当前类目有子类则查询下一级类目
            if(productCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD)){
                catQuery.setParentProductCatId(prodCatId);
                do{
                    // 查询同一级的类目信息
                    List<ProdCatInfo> productCatInfos = productCatSV.queryCatByNameOrFirst(catQuery);
                    prodCatInfo = productCatInfos.get(0);
                    ProdQueryCatVo prodQueryCatVo = new ProdQueryCatVo();
                    prodQueryCatVo.setLevel((short)(prodCatInfo.getCatLevel()-1));
                    prodQueryCatVo.setProdCatList(productCatInfos);
                    prodQueryCatVoList.add(prodQueryCatVo);
                    catQuery.setParentProductCatId(prodCatInfo.getProductCatId());
                }while(prodCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD));
            }
            logger.debug("获取类目信息出参:" + JSonUtil.toJSon(prodQueryCatVoList));
        } catch (Exception e) {
            prodQueryCatVoList = null;
            logger.error("获取类目信息出错", e);
        }
        return prodQueryCatVoList;
    }
    
    
    
    /**
     * 类目分页列表页
     */
    @RequestMapping(value = {"","/"})
    public String inSalelistQuery(String parentProductCatId, Model uiModel) {
        //若父类目不为空,查询类目链
        if (StringUtils.isNotBlank(parentProductCatId)) {
            IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
            ProductCatUniqueReq uniqueReq = new ProductCatUniqueReq();
            uniqueReq.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
            uniqueReq.setProductCatId(parentProductCatId);
            List<ProductCatInfo> catLink = catSV.queryLinkOfCatById(uniqueReq);
            uiModel.addAttribute("catLink", catLink);
            uiModel.addAttribute("parentProductCatId",parentProductCatId);
        }
        return "prod-cat/catlist";
    }

    /**
     *
     * @param catQuery
     * @return
     */
    @RequestMapping("/list")
    @ResponseBody
    public ResponseData<PageInfoResponse<ProductCatInfo>> queryCat(ProdCatQuery catQuery){
        ResponseData<PageInfoResponse<ProductCatInfo>> responseData;
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProductCatPageQuery pageQuery = new ProductCatPageQuery();
        BeanUtils.copyProperties(pageQuery,catQuery);
        pageQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        PageInfoResponse<ProductCatInfo> catInfoPageRes = catSV.queryPageProductCat(pageQuery);
        ResponseHeader header = catInfoPageRes.getResponseHeader();

        //保存错误
        if (header!=null && !header.isSuccess()){
            responseData = new ResponseData<PageInfoResponse<ProductCatInfo>>(
                    ResponseData.AJAX_STATUS_FAILURE, "获取信息失败 "+header.getResultMessage());
        }else
            responseData = new ResponseData<PageInfoResponse<ProductCatInfo>>(
                    ResponseData.AJAX_STATUS_SUCCESS, "OK",catInfoPageRes);

        return responseData;
    }
}
