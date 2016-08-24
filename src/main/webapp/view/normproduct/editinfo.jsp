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

<div class="content-wrapper-iframe"><!--右侧灰色背景-->

	<div class="row"><!--外围框架-->
            <div class="col-lg-12"><!--删格化-->
                <div class="row"><!--内侧框架-->
                    <div class="col-lg-12"><!--删格化-->
                        <div class="main-box clearfix"><!--白色背景-->
                        	<div class="main-box-body clearfix">	<!--padding20-->
                        	<div class="form-label bd-bottom">
                        		<ul>
					           		<li class="width-xlag">
					                    <p class="word">类目信息</p>
					                   <%--  <c:forEach var="catInfo" items="${catLinkList}"varStatus="stat">
					                    	${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
                                    	</c:forEach> --%>
					                    <input type="hidden" id="productCatId" name="productCatId" value="${productCatId}"/>
					               </li>	
					            </ul>
					            <ul>
					                <li class="width-xlag">
					                    <p class="word"><b class="red">*</b>商品名称</p>
					                    <p><input name="standedProductName" type="text" class="int-text int-xlarge" value="${productInfo.productName}"/></p>
					                </li>  
					            </ul>
					            <ul>
					                <li class="width-xlag">
					                    <p class="word"><b class="red">*</b>商品类型</p>
					                    <p>
					                    	<select  name="productType" class="select select-medium">
							                   	<option value="1" <c:if test="${productInfo.productType == '1'}">selected="selected"</c:if>>实物</option>
							                   	<option value="2" <c:if test="${productInfo.productType == '2'}">selected="selected"</c:if>>虚拟</option>
					                    	</select>
					                    </p>
					                </li>  
					            </ul> 
					        </div> 
					        
					        <c:if test="${not empty keyAttrlist}">
					        <!--标题开始--> 
					        <header class="main-box-header clearfix ">
                            	<h5 class="pull-left">商品关键属性</h5>
                            </header> 
                            <!--标题结束--> 
				        	<div class="form-label  bd-bottom" data-widget="validator" id="keyAttrDiv"> 
				        		<input type="hidden" id="keyAttrStr" name="keyAttrStr">
								<c:forEach var="keyAttr" items="${keyAttrlist}">
									<ul>
										<li class="width-xlag">
											<p class="word" attrId="${keyAttr.attrId}" valueType="${keyAttr.valueWay}"><b class="red">*</b>${keyAttr.attrName}</p>
											<c:set var="keyAttrSet" value="${productInfo.attrAndValueIds.get(keyAttr.attrId)}"/>
											<c:choose>
												<%-- 下拉选择 --%>
												<c:when test="${keyAttr.valueWay == '1'}">
													<select class="select select-medium" attrId="keyAttr${keyAttr.attrId}">
														<c:forEach var="valInfo" items="${keyAttr.attrValList}">
														<!-- <script>alert("attrvalueDefId=${valInfo.attrvalueDefId}");</script>
														<script>alert("isOk=${fn:contains(attrValueSet,valInfo.attrvalueDefId)}");</script> -->
															<option value="${valInfo.attrvalueDefId}" <c:if test="${fn:contains(keyAttrSet,valInfo.attrvalueDefId)}">selected ="selected"</c:if>>
															${valInfo.attrValueName}
															</option>
														</c:forEach>
													</select>
												</c:when>
												
												<%--多选--%>
												<c:when test="${keyAttr.valueWay == '2'}">
													<div class="cit-width">
														<c:forEach var="valInfo" items="${keyAttr.attrValList}">
															<p><input type="checkbox" class="checkbox-small" attrId="keyAttr${keyAttr.attrId}"<c:if test="${fn:contains(keyAttrSet,valInfo.attrvalueDefId)}">checked</c:if>>${valInfo.attrValueName}</p>
														</c:forEach>
													</div>
												</c:when>
												
												<%--单行输入--%>
												<c:when test="${keyAttr.valueWay  == '3'}">
													<p><input type="text" class="int-text int-xlarge" attrId="keyAttr${keyAttr.attrId}" maxlength="100" value="${keyAttrSet[0]}"></p>
												</c:when>
												
												<%--多行输入--%>
												<c:when test="${attr.valueWay == '4'}">
													<p><textarea class="textarea-xlarge" maxlength="100"attrId="keyAttr${keyAttr.attrId}" value="${keyAttrSet[0]}"></textarea></p>
												</c:when>
												
											</c:choose>
										</li>
									</ul>
								</c:forEach>
							</div>
							</c:if>
							
							<c:if test="${not empty saleAttrlist}">
							<!--标题开始--> 
					        <header class="main-box-header clearfix ">
                            	<h5 class="pull-left">商品销售属性</h5>
                            </header> 
                            <!--标题结束--> 
				        	<div class="form-label  bd-bottom" data-widget="validator" id="saleAttrDiv"> 
					        	<c:forEach var="saleAttr" items="${saleAttrlist}">
										<ul>
											<li class="width-xlag">
												<p class="word" attrId="${saleAttr.attrId}" valueType="${saleAttr.valueWay}"><b class="red">*</b>${saleAttr.attrName}</p>
												<c:set var="saleAttrSet" value="${productInfo.attrAndValueIds.get(saleAttr.attrId)}"/>
												<c:choose>
													<%-- 下拉选择 --%>
													<c:when test="${saleAttr.valueWay == '1'}">
														<select class="select select-medium" attrId="saleAttr${saleAttr.attrId}">
															<c:forEach var="valInfo" items="${saleAttr.attrValList}">
																<option value="${valInfo.attrvalueDefId}"<c:if test="${fn:contains(saleAttrSet,valInfo.attrvalueDefId)}">selected ="selected"</c:if>>
																   ${valInfo.attrValueName}
																</option>
															</c:forEach>
														</select>
													</c:when>
													
													<%--多选--%>
													<c:when test="${saleAttr.valueWay == '2'}">
														<div class="cit-width">
															<c:forEach var="valInfo" items="${saleAttr.attrValList}">
																<p><input type="checkbox" class="checkbox-small" attrId="saleAttr${saleAttr.attrId}"<c:if test="${fn:contains(saleAttrSet,valInfo.attrvalueDefId)}">checked</c:if>>${valInfo.attrValueName}</p>
															</c:forEach>
														</div>
													</c:when>
													
													<%--单行输入--%>
													<c:when test="${saleAttr.valueWay  == '3'}">
														<p><input type="text" class="int-text int-xlarge" attrId="saleAttr${saleAttr.attrId}" maxlength="100" value="${saleAttrSet[0]}"></p>
													</c:when>
													
													<%--多行输入--%>
													<c:when test="${saleAttr.valueWay == '4'}">
														<p><textarea class="int-text textarea-xlarge" maxlength="100"attrId="saleAttr${saleAttr.attrId}" value="${saleAttrSet[0]}"></textarea></p>
													</c:when>
													
												</c:choose>
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
				                            <p class="word"><b class="red">*</b>状态</p>
				                            <p>
				                            	<select  name="state" class="select select-medium">
								                   	<option value="1"<c:if test="${productInfo.state == '1'}">selected="selected"</c:if>>可使用</option>
								                   	<option value="2"<c:if test="${productInfo.state == '2'}">selected="selected"</c:if>>不可使用</option>
						                    	</select>
				                            </p>
				                        </li>
				                    </ul>
				                 </div>
								 <div id="subDiv" class="row pt-30">
	                            	<p class="center pr-30 mt-30">
	                            		<input id="submitAddBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
	                                           value="提  交">
	                                    <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
	                                           value="返  回" onclick="javaScript:window.history.go(-1);">
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

<script type="text/javascript">
		var pager;
		var count = '${count}';
		var prodInfoList = '${prodInfoList}';
		var productEditInfo = '${productEditInfo}';
		(function () {
			seajs.use('app/jsp/normproduct/addinfo', function (normProdEditPager) {
				pager = new normProdEditPager({element : document.body});
				pager.render();
			});
		})();
</script>
</html>