package com.ai.slp.product.web.controller.saleprice;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 销售价管理
 * Created by jackieliu on 16/8/30.
 */
@Controller
@RequestMapping("/saleprice/query")
public class SalePriceQueryController {

    /**
     * 商品列表页
     * @return
     */
    @RequestMapping(value = {"","/"})
    public String productList(){
        return "/saleprice/salePriceList";
    }
}
