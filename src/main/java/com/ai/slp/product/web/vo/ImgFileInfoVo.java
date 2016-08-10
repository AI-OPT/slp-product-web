package com.ai.slp.product.web.vo;

/**
 * 图片上传返回信息
 * Created by jackieliu on 16/6/22.
 */
public class ImgFileInfoVo extends FileInfoVo {
    /**
     * 如果上传图片,则返回图片地址
     */
    private String imgUrl;

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }
}
