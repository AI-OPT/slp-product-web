package com.ai.slp.product.web.model.comment;

import com.ai.slp.product.api.productcomment.param.CommentPageResponse;

public class CommentPageInfo extends CommentPageResponse {
	private static final long serialVersionUID = 1L;
	
	/**
	 * 评价人姓名
	 */
	private String userName;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

}
