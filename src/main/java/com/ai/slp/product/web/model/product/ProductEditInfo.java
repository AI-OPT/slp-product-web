package com.ai.slp.product.web.model.product;

import java.sql.Timestamp;

/**
 * 商品编辑信息提交信息
 * Created by jackieliu on 16/6/20.
 */
public class ProductEditInfo {
    /**
     * 商品标识
     */
    private String prodId;
    /**
     * 商品名称
     */
    private String prodName;
    /**
     * 商品卖点
     */
    private String productSellPoint;
    /**
     * 有效期类型
     */
    private String activeType;
    /**
     * 有效期周期
     */
    private Short activeCycle;
    /**
     * 有效期单位
     */
    private String unit;
    /**
     * 商品详情索引
     */
    private String proDetailContent;
    /**
     * 是否全国销售
     */
    private String isSaleNationwide;
    /**
     * 是否允许平台代售
     */
    private String isReplaceSell;
    /**
     * 是否开发票
     */
    private String isInvoice;
    /**
     * 上架类型
     */
    private String upshelfType;
    /**
     * 上架时间
     */
    private Timestamp upTime;

    private String rechargeType;

    private String basicOrgId;

    private String audiencesPerson;

    private String audiencesEnterprise;
    /**
     * 企业用户ID集合json
     */
    private String audiEntIds;

    private String audiencesAgents;
    /**
     * 代理商用户ID集合json
     */
    private String audiAgentIds;
    /**
     * 目标地域
     */
    private String targetProd;
    /**
     * 商品主图图片信息json字符串
     */
    private String prodPicStr;
    /**
     * 商品属性值图片信息json字符串
     */
    private String prodAttrValPicStr;
    /**
     * 非关键属性
     */
    private String noKeyAttrStr;
    /**
     * 预售开始时间
     */
    private String presaleBeginTimeStr;
    /**
     * 预售结束时间
     */
    private String presaleEndTimeStr;

	public String getProdId() {
        return prodId;
    }

    public void setProdId(String prodId) {
        this.prodId = prodId;
    }

    public String getProdName() {
        return prodName;
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }

    public String getProductSellPoint() {
        return productSellPoint;
    }

    public void setProductSellPoint(String productSellPoint) {
        this.productSellPoint = productSellPoint;
    }

    public String getActiveType() {
        return activeType;
    }

    public void setActiveType(String activeType) {
        this.activeType = activeType;
    }

    public Short getActiveCycle() {
        return activeCycle;
    }

    public void setActiveCycle(Short activeCycle) {
        this.activeCycle = activeCycle;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getProDetailContent() {
        return proDetailContent;
    }

    public void setProDetailContent(String proDetailContent) {
        this.proDetailContent = proDetailContent;
    }

    public String getIsSaleNationwide() {
        return isSaleNationwide;
    }

    public void setIsSaleNationwide(String isSaleNationwide) {
        this.isSaleNationwide = isSaleNationwide;
    }

    public String getIsReplaceSell() {
        return isReplaceSell;
    }

    public void setIsReplaceSell(String isReplaceSell) {
        this.isReplaceSell = isReplaceSell;
    }

    public String getUpshelfType() {
        return upshelfType;
    }

    public void setUpshelfType(String upshelfType) {
        this.upshelfType = upshelfType;
    }

    public Timestamp getUpTime() {
        return upTime;
    }

    public void setUpTime(Timestamp upTime) {
        this.upTime = upTime;
    }

    public String getRechargeType() {
        return rechargeType;
    }

    public void setRechargeType(String rechargeType) {
        this.rechargeType = rechargeType;
    }

    public String getBasicOrgId() {
        return basicOrgId;
    }

    public void setBasicOrgId(String basicOrgId) {
        this.basicOrgId = basicOrgId;
    }

    public String getAudiencesPerson() {
        return audiencesPerson;
    }

    public void setAudiencesPerson(String audiencesPerson) {
        this.audiencesPerson = audiencesPerson;
    }

    public String getAudiencesEnterprise() {
        return audiencesEnterprise;
    }

    public void setAudiencesEnterprise(String audiencesEnterprise) {
        this.audiencesEnterprise = audiencesEnterprise;
    }

    public String getAudiencesAgents() {
        return audiencesAgents;
    }

    public void setAudiencesAgents(String audiencesAgents) {
        this.audiencesAgents = audiencesAgents;
    }

    public String getTargetProd() {
        return targetProd;
    }

    public void setTargetProd(String targetProd) {
        this.targetProd = targetProd;
    }

    public String getAudiEntIds() {
        return audiEntIds;
    }

    public void setAudiEntIds(String audiEntIds) {
        this.audiEntIds = audiEntIds;
    }

    public String getAudiAgentIds() {
        return audiAgentIds;
    }

    public void setAudiAgentIds(String audiAgentIds) {
        this.audiAgentIds = audiAgentIds;
    }

    public String getProdPicStr() {
        return prodPicStr;
    }

    public void setProdPicStr(String prodPicStr) {
        this.prodPicStr = prodPicStr;
    }

    public String getProdAttrValPicStr() {
        return prodAttrValPicStr;
    }

    public void setProdAttrValPicStr(String prodAttrValPicStr) {
        this.prodAttrValPicStr = prodAttrValPicStr;
    }

    public String getNoKeyAttrStr() {
        return noKeyAttrStr;
    }

    public void setNoKeyAttrStr(String noKeyAttrStr) {
        this.noKeyAttrStr = noKeyAttrStr;
    }

    public String getPresaleBeginTimeStr() {
        return presaleBeginTimeStr;
    }

    public void setPresaleBeginTimeStr(String presaleBeginTimeStr) {
        this.presaleBeginTimeStr = presaleBeginTimeStr;
    }

    public String getPresaleEndTimeStr() {
        return presaleEndTimeStr;
    }

    public void setPresaleEndTimeStr(String presaleEndTimeStr) {
        this.presaleEndTimeStr = presaleEndTimeStr;
    }

    public String getIsInvoice() {
        return isInvoice;
    }

    public void setIsInvoice(String isInvoice) {
        this.isInvoice = isInvoice;
    }
}
