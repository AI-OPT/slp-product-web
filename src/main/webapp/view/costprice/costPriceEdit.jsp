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
                                <!-- 类目链 -->
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">类目信息：</p>
                                        <p><c:forEach var="catInfo" items="${catLinkList}"
                                                      varStatus="stat">${catInfo.productCatName}
                                            <c:if test="${!stat.last}">&gt;</c:if></c:forEach>
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
	                           <h5 class="pull-left">成本价</h5>
	                        </header> 
	                        <div class="main-box-body clearfix">
							<!--table表格-->
							<form id="costpriceForm" action="${_base}/costprice/save" method="post">
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th>商品ID</th>
										<th>商品名称</th>
										<th>仓库ID</th>
										<th>仓库名称</th>
										<th>供货量</th>
										<th>成本价(元)</th>
									</tr>
									</thead>
									<tbody id="searchProdRouteData">
									</tbody>
								</table>
								<div id="showMessageDiv"></div>
								<script id="searchProdRouteTemple" type="text/template">
									{{for result ~pageNo=pageNo ~pageSize=pageSize}}
									<tr>
										<td>{{:supplyId}}</td>
										<td>
											<div class="hind1 text-l pl-15">
                                                <div class="center-hind" >{{:supplyName}}</div>
                                                <div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:supplyName}}</div>
                                            </div>
										</td>
										<td>{{:routeId}}</td>
										<td>
											<div class="hind1 text-l pl-15">
                                                <div class="center-hind" >{{:routeName}}</div>
                                                <div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:routeName}}</div>
                                            </div>
										</td>
										<td>{{:usableNum}}</td>
                                        <td class="text-l">
											<input for="costPrice" name="costPrice{{:#index}}" standedProdId="{{:standedProdId}}" supplyId="{{:supplyId}}" routeId="{{:routeId}}" value="{{:~liToYuan2(costPrice)}}" tenantId="{{:tenantId}}" type="text"  class="int-text int-mini ml-30" regexp="^(([1-9]\d{0,6})|0)(\.\d{1,2})?$" data-msg-regexp="请输入0到9999999.99的数字" required moneyNumber="true" data-msg-moneyNumber="请输入正确格式">
											<div id="costPrice{{:#index}}" style="float:left;text-align:left;"></div>
										</td>
									</tr>
									{{/for}}
								</script>
							</div>
							</form>
							<!--分页-->
							<div class="paging">
								<ul id="pagination-ul">
								</ul>
							</div>
							<!--分页结束-->
						 </div>
                        </div>
                        <div id="subDiv" class="row pt-30">
	                            	<p class="center pr-30 mt-30">
	                            <input id="saveBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5" value="保  存">
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
<script type="text/javascript">
	var pager;
	var standedProdId = '${standedProdId}';
	(function () {
		seajs.use(['app/jsp/costprice/editinfo','app/util/center-hind'], function(costpricePage,centerHind) {
			pager = new costpricePage({element : document.body});
			pager.render();
			new centerHind({element : document.body}).render();
		});
	})();
</script>
</html>
