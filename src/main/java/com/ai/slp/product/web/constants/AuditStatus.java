package com.ai.slp.product.web.constants;

public enum AuditStatus {
	PASS("1"),REJECT("0");
	private String status;
	AuditStatus(String status){
		this.status = status;
	}
	public String getStatus(){
		return this.status;
	}
}
