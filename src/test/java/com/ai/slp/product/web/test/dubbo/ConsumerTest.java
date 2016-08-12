package com.ai.slp.product.web.test.dubbo;

import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.slp.product.api.productcat.interfaces.IProductCatSV;
import com.ai.slp.product.api.productcat.param.ProductCatInfo;
import com.ai.slp.product.api.productcat.param.ProductCatPageQuery;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by jackieliu on 16/8/11.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:context/core-context.xml")
public class ConsumerTest {

    @Test
    public void testCatPage(){
        IProductCatSV catSV = DubboConsumerFactory.getService(IProductCatSV.class);
        ProductCatPageQuery pageQuery = new ProductCatPageQuery();
        pageQuery.setTenantId("SLP");
        pageQuery.setPageSize(10);
        pageQuery.setPageNo(1);
        pageQuery.setIsChild("");
        pageQuery.setProductCatId("");
        pageQuery.setParentProductCatId("");
        pageQuery.setProductCatName("");
        PageInfoResponse<ProductCatInfo> catInfoRes = catSV.queryPageProductCat(pageQuery);
        System.out.println(catInfoRes.getResponseHeader().getIsSuccess());
    }
}
