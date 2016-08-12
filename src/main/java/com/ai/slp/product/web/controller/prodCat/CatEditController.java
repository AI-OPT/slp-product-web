package com.ai.slp.product.web.controller.prodCat;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by jackieliu on 16/8/11.
 */
@Controller
@RequestMapping("/cat/edit")
public class CatEditController {

    /**
     * 显示添加页面
     * @param parentId 父类目
     * @return
     */
    @RequestMapping("/addview")
    public String addView(String parentId, Model uiModel){
        uiModel.addAttribute("parentCatId",parentId);
        return "prod-cat/catadd";
    }
}
