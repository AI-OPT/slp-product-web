package com.ai.slp.product.web.service;

import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProdCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatQuery;
import com.ai.slp.product.web.constants.ProductCatConstants;
import com.ai.slp.product.web.constants.SysCommonConstants;
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
        catQuery.setTenantId(SysCommonConstants.COMMON_TENANT_ID);
        Map<Short, List<ProdCatInfo>> productCatMap = new HashMap<>();
        ProdCatInfo prodCatInfo = null;
        do {
            // 查询同一级的类目信息
            List<ProdCatInfo> productCatInfos = productCatSV.queryCatByNameOrFirst(catQuery);
            prodCatInfo = productCatInfos.get(0);
            // 把类目信息按照类目等级放入集合
            productCatMap.put(prodCatInfo.getCatLevel(), productCatInfos);
            catQuery.setParentProductCatId(prodCatInfo.getProductCatId());
        } while (prodCatInfo.getIsChild().equals(ProductCatConstants.ProductCat.IsChild.HAS_CHILD));
        return productCatMap;
    }
}
