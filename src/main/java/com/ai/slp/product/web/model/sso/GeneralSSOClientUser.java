package com.ai.slp.product.web.model.sso;

import java.io.Serializable;

/**
 * SSOUser 单点登录成功后的User实体
 * Created by jackieliu on 16/8/19.
 */
public class GeneralSSOClientUser implements Serializable {
    private static final long serialVersionUID = -8147635836938729264L;
    //租户
    private String tenantId;
    //登录名称
    private String username;

    //账号ID
    private String userId;
    //账号名称
    private String loginName;
    //手机号码
    private String mobile;
    //邮件
    private String email;

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public String getLoginName() {
        return loginName;
    }
    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }
    public String getMobile() {
        return mobile;
    }
    public void setMobile(String mobile) {
        this.mobile = mobile;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
}
