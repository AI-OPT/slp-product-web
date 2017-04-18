<%@ page import="com.ai.slp.product.web.constants.StorageConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("stoActive",StorageConstants.STATUS_ACTIVE);
    request.setAttribute("stoStop",StorageConstants.STATUS_STOP);
    request.setAttribute("stoDiscard",StorageConstants.STATUS_DISCARD);
%>
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
                            <!-- 类目链 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品基础信息</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                            	<ul class="big-word">
                                    <li class="col-md-12">
                                        <p class="word3">所属类目：</p>
                                        <p> 
                                        <c:forEach var="catInfo" items="${catLinkList}"
                                               varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
                                    	</c:forEach>
                                    	</p>
                                    </li>
                                </ul>
                                <ul class="big-word">
                                    <li class="col-md-12">
                                        <p class="word3">商品名称：</p>
                                        <p class="wide-field">${normProdInfo.productName}</p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">商品类型：</p>
                                        <p>${prodType}</p>
                                    </li>
                                </ul>
                            </div>
                            <c:if test="${!keyAttr.isEmpty()}">
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
                            </c:if>
                            <c:if test="${!saleAttr.isEmpty()}">
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品销售属性</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${saleAttr}">
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
                            </c:if>
                            
                            <!--标题开始--> 
						    <header class="main-box-header clearfix ">
	                           <h5 class="pull-left">商品状态</h5>
	                        </header> 
	                         <!--标题结束--> 
	                         <div class="form-label  bd-bottom"> 
		                         <ul>
						             <li class="width-xlag">
				                        <p class="word3">状态：</p>
				                        <p>
				                        	<c:if test="${normProdInfo.state == '0'}">废弃</c:if>
				                            <c:if test="${normProdInfo.state == '1'}">可使用</c:if>
				                            <c:if test="${normProdInfo.state == '2'}">不可使用</c:if>
				                        </p>
				                     </li>
				                 </ul>
				             </div>
                        <!--标题开始--> 
	                         <!--标题结束--> 
	                         <div class="form-label  bd-bottom"> 
		                         <ul>
						             <li class="width-xlag">
						             	<c:choose>
							             	<c:when test="${normProdInfo.state == '0'}">
							             		<p class="word3">废弃人：</p>
							             		<p>${normProdInfo.operName}</p>
							             		<p class="word3">废弃时间：</p>
							             		<p><fmt:formatDate value="${normProdInfo.operTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
							             		<%-- <p>${normProdInfo.operTime}</p> --%>
											</c:when>  
											     
											<c:otherwise>
					                        	<p class="word3">添加人：</p>
						                        <p>${normProdInfo.operName}</p>
						                        <p class="word3">添加时间：</p>
							             		<p><fmt:formatDate value="${normProdInfo.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
<%-- 							             		<p>${normProdInfo.operTime}</p> --%>
											</c:otherwise>
				                        </c:choose>
				                     </li>
				                 </ul>
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
        </div>
</div>
<!-- footer -->
</body>
</html>
