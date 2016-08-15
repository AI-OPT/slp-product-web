package com.ai.slp.product.web.model.prodCat;

/**
 * Created by jackieliu on 16/8/14.
 */
public class ProdCatInfo {
    /**
     * 商品类目ID,更新时必填
     */
    private String productCatId;

    /**
     * 商品类目名称
     */
    private String productCatName;

    /**
     * 父类目
     */
    private String parentProductCatId;

    /**
     * 是否有子分类,必填
     */
    private String isChild;

    /**
     * 首字母
     */
    private String firstLetter;

    /**
     * 序列号-用于排序
     */
    private short serialNumber;

    public String getProductCatId() {
        return productCatId;
    }

    public void setProductCatId(String productCatId) {
        this.productCatId = productCatId;
    }

    public String getProductCatName() {
        return productCatName;
    }

    public void setProductCatName(String productCatName) {
        this.productCatName = productCatName;
    }

    public String getParentProductCatId() {
        return parentProductCatId;
    }

    public void setParentProductCatId(String parentProductCatId) {
        this.parentProductCatId = parentProductCatId;
    }

    public String getIsChild() {
        return isChild;
    }

    public void setIsChild(String isChild) {
        this.isChild = isChild;
    }

    public String getFirstLetter() {
        return firstLetter;
    }

    public void setFirstLetter(String firstLetter) {
        this.firstLetter = firstLetter;
    }

    public short getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(short serialNumber) {
        this.serialNumber = serialNumber;
    }
}
