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
                        <form id="nromProdForm" action="${_base}/normprodedit/save" method="post">
                        	<input type="hidden" id="productId" name="productId" value="${productInfo.productId}"/>
                        	<div class="main-box-body clearfix">	<!--padding20-->
                        	<!--标题开始--> 
                        	<!-- 类目链 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品基础信息</h5>
                            </header>
                            <!--标题结束-->
                        	<div class="form-label bd-bottom">
					            <input type="hidden" id="productCatId" name="productCatId" value="${productCatId}"/>
					            <ul>
					                <li class="width-xlag">
					                    <p class="word3">类目信息</p>
					                    <p><c:forEach var="catInfo" items="${catLinkList}" varStatus="stat">
					                    	${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
                                    	</c:forEach></p> 
					                </li> 
					            </ul>
					            <ul>
					                <li class="width-xlag">
					                    <p class="word3"><b class="red">*</b>商品名称</p>
					                    <p><input required id="productName" name="productName" type="text" maxlength='100' class="int-text int-xlarge"  
					                    value="${productInfo.productName}" 
					                    commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
					                    onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"/></p>
					               	 	<p id="error_productName"></p> 
					                </li> 
					            </ul>
					            <ul>
					                <li class="width-xlag">
					                    <p class="word3"><b class="red">*</b>商品类型</p>
					                    <p>
					                    	<select required id="productType" name="productType" class="select select-medium >
					                    		<option value="">--请选择--</option>
							                   	<option value="1" <c:if test="${productInfo.productType == '1'}">selected="selected"</c:if>>实物</option>
							                   	<option value="2" <c:if test="${productInfo.productType == '2'}">selected="selected"</c:if>>虚拟</option>
					                    	</select>
					                    </p>
					                	<p id="error_productType"></p> 
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
											<p class="word3" attrId="${keyAttr.attrId}" valueType="${keyAttr.valueWay}"><b class="red">*</b>${keyAttr.attrName}</p>
											<p id="error_keyAttr${keyAttr.attrId}_title"></p>
											<c:set var="keyAttrSet" value="${productInfo.attrAndValueIds.get(keyAttr.attrId)}"/>
											<c:set var="keyAttrValue" value="${productInfo.attrAndValueMap.get(keyAttr.attrId)}"/>
											<p><c:choose>
												<%-- 下拉选择 --%>
												<c:when test="${keyAttr.valueWay == '1'}">
													<select required class="select select-medium" attrId="keyAttr${keyAttr.attrId}" name="keyAttr${keyAttr.attrId}">
														<option value="">--请选择--</option>
														<c:forEach var="valInfo" items="${keyAttr.attrValList}">
															<option value="${valInfo.attrvalueDefId}" <c:if test="${fn:contains(keyAttrSet,valInfo.attrvalueDefId)}">selected ="selected"</c:if>>
																${valInfo.attrValueName}
															</option>
														</c:forEach>
													</select>
												</c:when>
												
												<%--多选--%>
												<c:when test="${keyAttr.valueWay == '2'}">
													<div class="cit-width" style="padding:0 200px 0 210px;">
														<c:forEach var="valInfo" items="${keyAttr.attrValList}">
															<p><input required type="checkbox" class="checkbox-small" name="keyAttr${keyAttr.attrId}" attrId="keyAttr${keyAttr.attrId}" value="${valInfo.attrvalueDefId}" <c:if test="${fn:contains(keyAttrSet,valInfo.attrvalueDefId)}">checked</c:if>>${valInfo.attrValueName}</p>
														</c:forEach>
													</div>
												</c:when>
												
												<%--单行输入--%>
												<c:when test="${keyAttr.valueWay  == '3'}">
													<p><input required type="text" class="int-text int-xlarge" name="keyAttr${keyAttr.attrId}" attrId="keyAttr${keyAttr.attrId}" maxlength="20" value="${keyAttrValue}"></p>
												</c:when>
												
												<%--多行输入--%>
												<c:when test="${attr.valueWay == '4'}">
													<p><textarea required class="textarea-xlarge"  maxlength="20" name="keyAttr${keyAttr.attrId}" attrId="keyAttr${keyAttr.attrId}" value="${keyAttrValue}"</textarea></p>
												</c:when>
												
											</c:choose></p>
											<p id="error_keyAttr${keyAttr.attrId}"></p>
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
				        		<input type="hidden" id="saleAttrStr" name="saleAttrStr">
					        	<c:forEach var="saleAttr" items="${saleAttrlist}">
										<ul>
											<li class="width-xlag">
												<p class="word3" attrId="${saleAttr.attrId}" valueType="${saleAttr.valueWay}"><b class="red">*</b>${saleAttr.attrName}</p>
												<p id="error_saleAttr${saleAttr.attrId}_title"></p>
												<c:set var="saleAttrSet" value="${productInfo.attrAndValueIds.get(saleAttr.attrId)}"/>
												<c:set var="saleAttrValue" value="${productInfo.attrAndValueMap.get(saleAttr.attrId)}"/>
												<p><c:choose>
													<%-- 下拉选择 --%>
													<c:when test="${saleAttr.valueWay == '1'}">
														<select required class="select select-medium" name="saleAttr${saleAttr.attrId}" attrId="saleAttr${saleAttr.attrId}">
															<option value="">--请选择--</option>
															<c:forEach var="valInfo" items="${saleAttr.attrValList}">
																<option value="${valInfo.attrvalueDefId}" <c:if test="${fn:contains(saleAttrSet,valInfo.attrvalueDefId)}">selected ="selected"</c:if>>
																   ${valInfo.attrValueName}
																</option>
															</c:forEach>
														</select>
													</c:when>
													
													<%--多选--%>
													<c:when test="${saleAttr.valueWay == '2'}">
														<div class="cit-width"  style="padding:0 200px 0 210px;">
															<c:forEach var="valInfo" items="${saleAttr.attrValList}">
																<p><input required type="checkbox" class="checkbox-small" name="saleAttr${saleAttr.attrId}" attrId="saleAttr${saleAttr.attrId}" value="${valInfo.attrvalueDefId}" <c:if test="${fn:contains(saleAttrSet,valInfo.attrvalueDefId)}">checked</c:if>>${valInfo.attrValueName}</p>
															</c:forEach>
														</div>
													</c:when>
													
													<%--单行输入--%>
													<c:when test="${saleAttr.valueWay  == '3'}">
														<p><input required type="text" class="int-text int-xlarge" name="saleAttr${saleAttr.attrId}" attrId="saleAttr${saleAttr.attrId}" maxlength="20" value="${saleAttrValue}"></p>
													</c:when>
													
													<%--多行输入--%>
													<c:when test="${saleAttr.valueWay == '4'}">
														<p><textarea required class="int-text textarea-xlarge" maxlength="20" name="saleAttr${saleAttr.attrId}" attrId="saleAttr${saleAttr.attrId}" value="${saleAttrValue}"></textarea></p>
													</c:when>
													
												</c:choose></p>
												<p id="error_saleAttr${saleAttr.attrId}"></p>
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
				                            <p class="word3"><b class="red">*</b>状态</p>
				                            <p>
				                            	<select required id="state" name="state" class="select select-medium">
								                   	<option value="1"<c:if test="${productInfo.state == '1'}">selected="selected"</c:if>>可使用</option>
								                   	<option value="2"<c:if test="${productInfo.state == '2'}">selected="selected"</c:if>>不可使用</option>
						                    	</select>
				                            </p>
				                        </li>
				                    </ul>
				                 </div>
								 <div id="subDiv" class="row pt-30">
	                            	<p class="center pr-30 mt-30">
	                            		<input id="saveNormProd" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
	                                           value="保  存">
	                                    <input id="cancel" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
	                                           value="返  回" onclick="javaScript:window.history.go(-1);">
	                            	</p>
	                            </div>
	                        </div>
	                        </form>
	                    </div>
	                </div>
	            </div>
	        </div>
		</div>
	</div>

</body>

<script type="text/javascript">
		var pager;
		(function () {
			seajs.use('app/jsp/normproduct/editinfo', function (prodEditPager) {
				pager = new prodEditPager({element : document.body});
				pager.render();
			});
		})();
</script>
</html>