package com.ai.slp.product.web.model.prodAttr;
/**
 * 用于属性值批量添加
 * @author jiawen
 * @time 2016-8-17
 *
 */
public class ProdAttrValueInfo {
	/**
	 * 属性ID,属性值修改时不能对属性ID进行操作
	 */
	private Long attrId;
	
	/**
	 * 属性值ID,属性值修改时不能为空
	 */
	private String attrvalueDefId;
	
	/**
	 * 属性值名称,添加和修改属性值时不能为空
	 */
	private String attrValueName;
	
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

	public String getAttrvalueDefId() {
		return attrvalueDefId;
	}

	public void setAttrvalueDefId(String attrvalueDefId) {
		this.attrvalueDefId = attrvalueDefId;
	}

	public String getAttrValueName() {
		return attrValueName;
	}

	public void setAttrValueName(String attrValueName) {
		this.attrValueName = attrValueName;
	}

	public String getFirstLetter() {
		return firstLetter;
	}

	public void setFirstLetter(String firstLetter) {
		this.firstLetter = firstLetter;
	}
	
}
