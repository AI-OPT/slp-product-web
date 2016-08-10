package com.ai.slp.product.web.controller.productCat;

import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.paas.ipaas.util.JSonUtil;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatQuery;
import com.ai.slp.product.api.productcat.param.ProductCatUniqueReq;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
import com.ai.slp.product.web.vo.ProdQueryCatVo;
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
     * 类目分页查询
     */
    @RequestMapping("/catList")
	public String inSalelistQuery(Model uiModel) {
    	
		return "productcat/catlist";
	}
}
