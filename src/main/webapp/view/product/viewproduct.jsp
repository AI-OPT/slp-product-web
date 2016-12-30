<%@ page import="com.ai.opt.sdk.components.idps.IDPSClientFactory" %>
<%@ page import="com.ai.paas.ipaas.image.IImageClient" %>
<%@ page import="com.ai.slp.product.web.constants.SysCommonConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<title>运营管理</title>
	<%@ include file="/inc/inc.jsp" %>
</head>

<body>

<div class="content-wrapper-iframe"><!--外围框架-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                        <div id="subDiv" class="main-box-body clearfix">
                        	<header class="main-box-header clearfix">
                                <h5 class="pull-left">商品基础信息
                                </h5>
                            </header>
                        	<div class="form-label  bd-bottom">
                                <ul>
                                	<input type="hidden" id="prodId" value="${productInfo.prodId}">
                                	<input type="hidden" id="state" value="${productInfo.state}">
                                    <li class="col-md-12">
                                        <p class="word3">类目信息：</p>
                                        <p>
                                        <c:forEach var="catInfo" items="${catLinkList}"
                                               varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
	                                    </c:forEach>
	                                    </p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">商品类型：</p>
                                        <p>${prodType}</p>
                                    </li>
                                </ul>
                                <ul class="big-word">
                                    <li class="col-md-12">
                                        <p class="word3">商品名称：</p>
                                        <p class="wide-field" style="word-break:break-all;">${productInfo.prodName}</p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">商品卖点：</p>
                                        <p class="wide-field" style="word-break:break-all;">${productInfo.productSellPoint}</p>
                                    </li>
                                </ul>
                            </div>
                            <!-- 关键属性 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品关键属性</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${keyAttr}">
                                    <ul>
                                        <li class="col-md-12">
                                            <p class="word3">${aav.key.attrName}：</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            
                            
                            
                          <%--   <div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${keyAttr}">
                                    <ul>
                                        <li class="col-md-12">
                                            <p class="word3">${aav.key.attrName}：</p>
											<c:choose>
												多选
												<c:when test="${aav.key.attrType == '2'}">
													<div class="cit-width">
														<c:forEach var="attrVal" items="${aav.value}" varStatus="stat">
															<p>${attrVal.attrVal}<c:if test="${!stat.last}">、</c:if></p>
														</c:forEach>
													</div>
												</c:when>
												<c:when test="${!aav.value.isEmpty()}">
													<p>${aav.value.get(0).attrVal}</p>
												</c:when>
												<c:otherwise>
													<p></p>
												</c:otherwise>
											</c:choose>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div> --%>
                            
                            <!-- 非关键属性 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品非关键属性</h5>
                            </header>
                             <div class="form-label  bd-bottom">
                           		 <c:forEach var="attr" items="${noKeyAttr}">
                                    <ul>
                                        <li class="col-md-12">
                                            <p class="word3">${attr.attrName}：</p>
											<c:set var="noKeyAttrVals" value="${noKeyAttrValMap.get(attr.attrId)}"/>
											<c:choose>
												<%--多选--%>
												<c:when test="${attr.valueWay == '2'}">
												<c:set var="choseInt" value="0"></c:set>
													<p class="wide-field">
														<c:forEach var="attrVal" items="${noKeyAttrVals}">
															<c:if test="${attrVal.productAttrValId != null}">
																<c:if test="${choseInt>0}">、</c:if>${attrVal.attrVal}
																<c:set var="choseInt" value="${choseInt+1 }"></c:set>
															</c:if>
														</c:forEach>
														
													</p>
												</c:when>
												<c:when test="${!noKeyAttrVals.isEmpty()}">
													<p>${noKeyAttrVals.get(0).attrVal}</p>
												</c:when>
												<c:otherwise>
													<p></p>
												</c:otherwise>
											</c:choose>
                                        </li>
                                    </ul>
								 </c:forEach>
                            </div>
                            <!-- 选择商品目标地域 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品目标地域</h5>
                            </header>
                            <div class="form-label  bd-bottom">
								<ul>
									<li class="width-xlag">
										<p class="word3">目标地域：</p>
										<c:choose>
											<c:when test="${productInfo.isSaleNationwide == 'Y'}">
												<p>全部地域</p>
											</c:when>
											<c:when test="${productInfo.isSaleNationwide == 'N'}">
												<p class="wide-field" style="word-break:break-all;">${areaInfoStr}</p>
											</c:when>
										</c:choose>
									</li>
								</ul>
                            </div>
                            <!-- 发票信息 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">发票信息</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<ul>
                           		   <li class="col-md-12">
		                            	<p class="word3">是否提供发票：</P>
		                            	<p>
		                            	<c:if test="${productInfo.isInvoice == 'Y'}">提供发票</c:if>
			                            <c:if test="${productInfo.isInvoice == 'N'}">不提供发票</c:if>
		                            	</p>
                                    </li>
                            	</ul>
                            </div>
                            <!-- 商品上架时间 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品上架类型</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<ul>
                           		   <li class="col-md-12">
									   <p class="word3">
										   <c:if test="${productInfo.upshelfType == '1'}">立即上架</c:if>
										   <c:if test="${productInfo.upshelfType == '2'}">放入仓库</c:if>
										   <c:if test="${productInfo.upshelfType == '4'}">预售上架：</c:if>
									   </p>
									   <p class="wide-field" style="word-break:break-all;">
										   <c:if test="${productInfo.upshelfType == '4'}">
											   预售时间&emsp;<fmt:formatDate value="${productInfo.presaleBeginTime}" type="both"></fmt:formatDate>
											   至
											   <fmt:formatDate value="${productInfo.presaleEndTime}" type="both"></fmt:formatDate></c:if>
									   </p>
                                    </li>
                            	</ul>
                            </div>
                            <!-- 商品预览图 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品预览图</h5>
                            </header>
							<div class="form-label bd-bottom"><!--查询条件-->
								<%
									String picSize = "78x78";
									IImageClient imageClient = IDPSClientFactory.getImageClient(SysCommonConstants.ProductImage.IDPSNS);
									request.setAttribute("imgClient",imageClient);
									request.setAttribute("picSize",picSize);
								%>
								<ul>
									<li class="width-xlag">
										<p class="word"><b class="red">*</b>商品主图</p>
										<div>
											<c:set var="prodPicNum" value="${prodPic.size()}"></c:set>
											<c:forEach var="valInd" begin="0" end="5">
												<p class="img">
													<c:choose>
														<c:when test="${valInd<prodPicNum && prodPic.get(valInd)!=null}">
															<c:set var="valInfo" value="${prodPic.get(valInd)}"/>
															<img src="<c:out value="${imgClient.getImageUrl(valInfo.vfsId,valInfo.picType,picSize)}"/>"/>
														</c:when>
														<c:otherwise>
															<img src="${_slpres}/images/sp-03-a.png"/>
														</c:otherwise>
													</c:choose>
												</p>
											</c:forEach>
										</div>
									</li>
								</ul>
								<%-- 属性值图片 --%>
								<c:forEach var="attrValInfo" items="${attrValList}">
									<ul>
										<li class="width-xlag">
											<p class="word"><b class="red">*</b>${attrValInfo.attrVal}</p>
											<div class="width-img" id="prod_pic_${attrValInfo.attrValId}">
												<c:set var="attrValPic" value="${valPicMap.get(attrValInfo.attrValId)}"></c:set>
												<c:set var="attrValSize" value="${attrValPic.size()}"></c:set>
												<c:forEach var="valInd" begin="0" end="5">
													<p class="img">
														<c:choose>
															<c:when test="${valInd<attrValSize && attrValPic.get(valInd)!=null}">
																<c:set var="valInfo" value="${attrValPic.get(valInd)}"></c:set>
																<img src="<c:out value='${imgClient.getImageUrl(valInfo.vfsId,valInfo.picType,picSize)}'/>"/>
															</c:when>
															<c:otherwise>
																<img src="${_slpres}/images/sp-03-a.png"/>
															</c:otherwise>
														</c:choose>
													</p>
												</c:forEach>
											</div>
										</li>
									</ul>
								</c:forEach>
							</div>
                            <!-- 商品预览图 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品图文描述</h5>
                            </header>
                            <div class="form-label" style="width: 100%;word-wrap:break-word; "><!--查询条件-->
								${prodDetail}
							</div>
                            
	                        <div id="subDiv" class="row pt-30">
	                         <p class="center pr-30 mt-30">
                                <input type="button" class="biu-btn  btn-primary  btn-small  ml-5" value="返  回"
                                       onclick="javaScript:window.history.go(-1);">
                            </p>
                      	  </div>
                       	</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
