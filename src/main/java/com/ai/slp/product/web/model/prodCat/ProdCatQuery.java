package com.ai.slp.product.web.model.prodCat;

/**
 * Created by jackieliu on 16/8/11.
 */
public class ProdCatQuery {
	/**
	 * 分頁  默認第一頁
	 */
    private Integer pageNo = 1;
    /**
	 * 每頁數據量
	 */
    private Integer pageSize = 10;
    /**
	 * 父類目標識
	 */
    private String parentProductCatId;
    /**
	 * 類目標識
	 */
    private String productCatId;
    /**
	 * 類目名稱
	 */
    private String productCatName;
    /**
	 * 是否為子類目
	 */
    private String isChild;

    public Integer getPageNo() {
        return pageNo;
    }

    public void setPageNo(Integer pageNo) {
        this.pageNo = pageNo;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public String getParentProductCatId() {
        return parentProductCatId;
    }

    public void setParentProductCatId(String parentProductCatId) {
        this.parentProductCatId = parentProductCatId;
    }

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

    public String getIsChild() {
        return isChild;
    }

    public void setIsChild(String isChild) {
        this.isChild = isChild;
    }
}
