package com.ai.slp.product.web.model.product;

import com.ai.slp.product.api.normproduct.param.NormProdResponse;

public class NormProdQueryInfo extends NormProdResponse {

	private static final long serialVersionUID = 1L;
	
	private String stateName;
	
	public String getStateName() {
		return stateName;
	}

	public void setStateName(String stateName) {
		this.stateName = stateName;
	}


}
