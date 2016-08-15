package com.ai.slp.product.web.controller.prodCat;

import com.ai.opt.sdk.constants.ExceptCodeConstants;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.web.model.prodCat.ProdCatInfo;
import com.alibaba.fastjson.JSON;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

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

    /**
     * 批量添加类目
     * @return
     */
    @RequestMapping(value = "/create",method = RequestMethod.POST)
    @ResponseBody
    public ResponseData<String> addCat(String catListStr){
        ResponseData<String> responseData = new ResponseData<String>(
                ResponseData.AJAX_STATUS_SUCCESS, ExceptCodeConstants.Special.SUCCESS);
        List<ProdCatInfo> catInfoList = JSON.parseArray(catListStr,ProdCatInfo.class);
        for (ProdCatInfo catInfo:catInfoList){
            System.out.println(catInfo.getProductCatName()+":"+catInfo.getParentProductCatId());
        }
        return responseData;
    }
}
