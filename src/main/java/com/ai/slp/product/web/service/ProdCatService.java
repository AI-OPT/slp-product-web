package com.ai.slp.product.web.service;

import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.CollectionUtil;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatQuery;
import com.ai.slp.product.api.productcat.param.ProductCatUniqueReq;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.util.AdminUtil;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by jackieliu on 16/7/26.
 */
@Service
public class ProdCatService {

    public Map<Short, List<ProdCatInfo>> loadCat() {
        IProductCatSV productCatSV = DubboConsumerFactory.getService("iProductCatSV");
        ProductCatQuery catQuery = new ProductCatQuery();
        catQuery.setTenantId(AdminUtil.getTenantId());
        Map<Short, List<ProdCatInfo>> productCatMap = new HashMap<>();
        ProdCatInfo prodCatInfo = null;
        do {
            // 查询同一级的类目信息
            List<ProdCatInfo> productCatInfos = productCatSV.queryCatByNameOrFirst(catQuery);
            if (CollectionUtil.isEmpty(productCatInfos)){
            	break;
            }
            prodCatInfo = productCatInfos.get(0);
            // 把类目信息按照类目等级放入集合
            productCatMap.put(prodCatInfo.getCatLevel(), productCatInfos);
            catQuery.setParentProductCatId(prodCatInfo.getProductCatId());
        } while (prodCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD));
        return productCatMap;
    }

    public List<ProdCatInfo> loadRootCat(){
        IProductCatSV productCatSV = DubboConsumerFactory.getService("iProductCatSV");
        ProductCatQuery catQuery = new ProductCatQuery();
        catQuery.setTenantId(AdminUtil.getTenantId());
        // 查询同一级的类目信息
        return productCatSV.queryCatByNameOrFirst(catQuery);
    }

    public List<ProductCatInfo> queryLink(String catId){
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        //类目链
        ProductCatUniqueReq uniqueReq = new ProductCatUniqueReq();
        uniqueReq.setTenantId(AdminUtil.getTenantId());
        uniqueReq.setProductCatId(catId);
        return catSV.queryLinkOfCatById(uniqueReq);
    }
}
