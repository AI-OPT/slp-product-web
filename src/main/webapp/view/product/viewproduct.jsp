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
                        <div class="main-box-body clearfix">
                        	<header class="main-box-header clearfix">
                                <h5 class="pull-left">商品基础信息
                                </h5>
                            </header>
                        	<div class="form-label  bd-bottom">
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">类目信息：</p>
                                        <p>
                                        <c:forEach var="catInfo" items="${catLinkList}"
                                               varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
	                                    </c:forEach>
	                                    </p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">商品类型：</p>
                                        <p>${prodType}</p>
                                    </li>
                                </ul>
                                <ul class="big-word">
                                    <li class="col-md-6">
                                        <p class="word">商品名称：</p>
                                        <p>${productInfo.prodName}</p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">商品卖点：</p>
                                        <p>${productInfo.productSellPoint}</p>
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
                                        <li class="col-md-6">
                                            <p class="word">${aav.key.attrName}：</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            <!-- 非关键属性 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品非关键属性</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<c:forEach var="attr" items="${noKeyAttr}">
									<ul>
										<li class="width-xlag">
										<p class="word" attrId="${attr.attrId}" valueType="${attr.valueWay}">${attr.attrName}</p>
										<c:choose>
											<%-- 下拉选择 --%>
											<c:when test="${attr.valueWay == '1'}">
												<select class="select select-medium" attrId="noKeyAttr${attr.attrId}">
													<c:forEach var="valInfo" items="${noKeyAttrValMap.get(attr.attrId)}">
														<option value="${valInfo.attrValId}" id="${valInfo.productAttrValId}"
																<c:if test="${valInfo.productAttrValId != null}">selected</c:if>>${valInfo.attrVal}</option>
													</c:forEach>
												</select>
											</c:when>
											<%--多选--%>
											<c:when test="${attr.valueWay == '2'}">
												<div class="width-xlag">
													<c:forEach var="valInfo" items="${noKeyAttrValMap.get(attr.attrId)}">
														<p><input type="checkbox" class="checkbox-small" attrId="noKeyAttr${attr.attrId}" value="${valInfo.attrValId}"
																  <c:if test="${valInfo.productAttrValId != null}">checked</c:if> >${valInfo.attrVal}</p>
													</c:forEach>
												</div>
											</c:when>
											<%--单行输入--%>
											<c:when test="${attr.valueWay == '3'}">
												<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
												<p><input type="text" class="int-text int-xlarge" attrId="noKeyAttr${attr.attrId}" maxlength="100"
														  <c:if test="${valInfo!=null}">value="${valInfo.attrVal}"</c:if> ></p>
											</c:when>
											<%--多行输入--%>
											<c:when test="${attr.valueWay == '4'}">
												<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
												<p><textarea class="textarea-xlarge" maxlength="100"
															 attrId="noKeyAttr${attr.attrId}"><c:if test="${valInfo!=null}">${valInfo.attrVal}</c:if></textarea></p>
											</c:when>
										</c:choose>
										</li>
									</ul>
								</c:forEach>
                            </div>
                            <!-- 选择商品目标地域 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">选择商品目标地域</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<c:forEach var="targetArea" items="${prodTargetArea}">
                            		<c:forEach var="targetAreaValue" items="${targetArea.targetArea}">
                            			<p>${targetAreaValue}</p>
                            		</c:forEach>
                            	</c:forEach>
                            </div>
                            <!-- 预售设置 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">预售设置</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	
                            </div>
                            <!-- 发票信息 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">发票信息</h5>
                            </header>
                            <div class="form-label  bd-bottom">
	                            <c:if test="${productInfo.getIsInvoice == 'Y'}">提供发票</c:if>
	                            <c:if test="${productInfo.getIsInvoice == 'N'}">不提供发票</c:if>
                            </div>
                            <!-- 商品上架时间 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品上架时间</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	${productInfo.getUpTime}
                            </div>
                            
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
<!-- footer -->
</body>
</html>
