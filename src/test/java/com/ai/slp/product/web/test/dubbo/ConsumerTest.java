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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

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

    @Test
    public void test(){
        //初始化 开始
        String[] a = {"aaaa","aaaa","aaaa","aaaa"};
        String[] c = {"cccc","cccc","cccc","cccc"};

        List<String> acList = new ArrayList<>();
        Collections.addAll(acList,a);
        Collections.addAll(acList,c);
        Collections.addAll(acList,a);
        Collections.addAll(acList,c);
        Collections.addAll(acList,a);
        Collections.addAll(acList,"cccc","cccc");
        //初始化 结束
        String prev = "";
        String cccc = "cccc";
        List<List<String>> ccList = new ArrayList<>();
        for (String acEl:acList){
            //若不是"cccc"则直接忽略
            if (!cccc.equals(acEl)) {
                prev = acEl;
                continue;
            }

            List<String> cccList = ccList.isEmpty()?null:ccList.get(ccList.size() -1);
            //判断上一个是否为cccc
            if (cccList==null || !cccc.equals(prev)){
                cccList = new ArrayList<>();
                ccList.add(cccList);
            }
            cccList.add(acEl);
            prev = acEl;
        }
        //开始打印
        for (int i = 0;i<ccList.size();i++){
            System.out.println(i+"=="+Arrays.toString(ccList.get(i).toArray()));
        }
    }
}
