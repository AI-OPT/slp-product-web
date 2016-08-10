package com.ai.slp.product.web.vo;

import com.ai.slp.product.api.productcat.param.ProdCatInfo;

import java.io.Serializable;
import java.util.List;

/**
 * 商品管理页面-商品未编辑查询类目出参
 * 
 * @author lipeng16
 *
 */
public class ProdQueryCatVo implements Serializable{
	private static final long serialVersionUID = 1L;
	/**
	 * 类目等级
	 */
	private short level;
	/**
	 * 次类目等级下对应的类目对象集合-针对选中类目
	 */
	private List<ProdCatInfo> prodCatList;
	public short getLevel() {
		return level;
	}
	public void setLevel(short level) {
		this.level = level;
	}
	public List<ProdCatInfo> getProdCatList() {
		return prodCatList;
	}
	public void setProdCatList(List<ProdCatInfo> prodCatList) {
		this.prodCatList = prodCatList;
	}
	
}
