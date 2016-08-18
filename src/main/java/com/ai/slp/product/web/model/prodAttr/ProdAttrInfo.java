package com.ai.slp.product.web.model.prodAttr;

/**
 * 
 * @author jiawen
 * @time 2016-8-16
 *
 */

public class ProdAttrInfo {
	/**
	 * 属性标识
	 */
	private Long attrId;
	/**
	 * 属性名称
	 */
    private String attrName;
    /**
	 * 输入方式
	 */
    private String valueWay;
    /**
	 * 首字母
	 */
    private String firstLetter;
	public Long getAttrId() {
		return attrId;
	}
	public void setAttrId(Long attrId) {
		this.attrId = attrId;
	}
	public String getAttrName() {
		return attrName;
	}
	public void setAttrName(String attrName) {
		this.attrName = attrName;
	}
	public String getValueWay() {
		return valueWay;
	}
	public void setValueWay(String valueWay) {
		this.valueWay = valueWay;
	}
	public String getFirstLetter() {
		return firstLetter;
	}
	public void setFirstLetter(String firstLetter) {
		this.firstLetter = firstLetter;
	}
    
    
}
