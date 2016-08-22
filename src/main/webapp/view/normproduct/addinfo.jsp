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
						<!-- 查询条件 -->
						<div class="form-label">
							<!-- 类目 -->
							
							<div class="form-label bd-bottom" data-widget="validator">
								<ul>
					                <li class="col-md-6">
					                    <p class="word"><b class="red">*</b>标准品名称</p>
					                    <p><input name="standedProductName" type="text" class="int-text int-medium"></p>
					                </li>
					             </ul>
					             <ul>
					             	<li class="col-md-6">
					             		<p class="word"><b class="red">*</b>标准品类型</p>
					             		<p>
					                    	<select  name="productType" class="select select-medium">
							                   	<option value="1">实物</option>
							                   	<option value="2">虚拟</option>
					                    	</select>
					                    </p>
					            	</li>
					             </ul>
                            </div> 
                            
                            <!-- 1关键属性  2销售属性  3非关键属性 -->
                            <!-- 根据类目信息动态获取关键属性,和销售属性 的  属性  以及属性值 -->
                            <div class="nav-form-title">标准品关键属性</div>
                            <div class="nav-form nav-form-border" id="keyAttrDiv">
                            	<input type="hidden" id="keyAttrStr" name="keyAttrStr">
								<c:forEach var="keyAttr" items="${keyAttrlist}">
									<ul>
										<li class="width-xlag">
											<p class="word" attrId="${keyAttr.attrId}" valueType="${keyAttr.valueWay}">${keyAttr.attrName}</p>
											<c:choose>
											
											<!-- /*** 值输入方式<br>* 1:下拉单选 2:多选* 3:可输入文本框（单行）
											* 4:可输入文本框（多行） * 5:日期时间 * 6:日期时间段 */  -->
												<%-- 下拉选择 --%>
												<c:when test="${keyAttr.valueWay == '1'}">
													<select class="select select-medium" attrId="keyAttr${keyAttr.attrId}">
														<c:forEach var="valInfo" items="${keyAttr.attrValList}">
															<option value="${valInfo.attrvalueDefId}">
															${valInfo.attrValueName}
															</option>
														</c:forEach>
													</select>
												</c:when>
												
												
												<%--多选--%>
												<c:when test="${keyAttr.valueWay == '2'}">
													<div class="width-xlag">
														<c:forEach var="valInfo" items="${keyAttr.attrValList}">
															<p><input type="checkbox" class="checkbox-small" attrId="keyAttr${keyAttr.attrId}">${valInfo.attrValueName}</p>
														</c:forEach>
													</div>
												</c:when>
												
												<%--单行输入--%>
												<c:when test="${keyAttr.valueWay  == '3'}">
													<p><input type="text" class="int-text int-xlarge" attrId="keyAttr${keyAttr.attrId}" maxlength="100"></p>
												</c:when>
												
												<%--多行输入--%>
												<c:when test="${attr.valueWay == '4'}">
													<p><textarea class="textarea-xlarge" maxlength="100"attrId="keyAttr${keyAttr.attrId}"></textarea></p>
												</c:when>
												
											</c:choose>
										</li>
									</ul>
								</c:forEach>
                            </div> 
                            
                            <div class="nav-form-title">标准品销售属性</div>
                            <div class="nav-form nav-form-border" id="saleAttrDiv">
								<c:forEach var="saleAttr" items="${saleAttrlist}">
									<ul>
										<li class="width-xlag">
											<p class="word" attrId="${saleAttr.attrId}" valueType="${saleAttr.valueWay}">${saleAttr.attrName}</p>
											<c:choose>
											
											<!-- /*** 值输入方式<br>* 1:下拉单选 2:多选* 3:可输入文本框（单行）
											* 4:可输入文本框（多行） * 5:日期时间 * 6:日期时间段 */  -->
												<%-- 下拉选择 --%>
												<c:when test="${saleAttr.valueWay == '1'}">
													<select class="select select-medium" attrId="saleAttr${saleAttr.attrId}">
														<c:forEach var="valInfo" items="${saleAttr.attrValList}">
															<option value="${valInfo.attrvalueDefId}">
															   ${valInfo.attrValueName}
															</option>
														</c:forEach>
													</select>
												</c:when>
												
												<%--多选--%>
												<c:when test="${saleAttr.valueWay == '2'}">
													<div class="width-xlag">
														<c:forEach var="valInfo" items="${saleAttr.attrValList}">
															<p><input type="checkbox" class="checkbox-small" attrId="saleAttr${saleAttr.attrId}">${valInfo.attrValueName}</p>
														</c:forEach>
													</div>
												</c:when>
												
												<%--单行输入--%>
												<c:when test="${saleAttr.valueWay  == '3'}">
													<p><input type="text" class="int-text int-xlarge" attrId="saleAttr${saleAttr.attrId}" maxlength="100"></p>
												</c:when>
												
												<%--多行输入--%>
												<c:when test="${saleAttr.valueWay == '4'}">
													<p><textarea class="textarea-xlarge" maxlength="100"attrId="saleAttr${saleAttr.attrId}"></textarea></p>
												</c:when>
												
											</c:choose>
										</li>
									</ul>
								</c:forEach>
                            </div> 
                            <div class="nav-form-title"><b class="red">*</b>标准品状态</div>
                            <div class="nav-form nav-form-border" id="stateDiv">
                            	<ul>
					             	<li class="col-md-6">
					             		<p class="word"><b class="red">*</b>状态</p>
					             		<p>
					                    	<select  name="state" class="select select-medium">
							                   	<option value="1">可使用</option>
							                   	<option value="2">不可使用</option>
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

<script src="${_slpres }/scripts/jquery-1.11.1.min.js"></script>
<script src="${_slpres }/scripts/frame.js"  type="text/javascript" ></script>
<script src="${_slpres }/scripts/metismenu.js"></script>
 <script type="text/javascript"> 
window.onload = function(){	
	var timer;
	var elem = document.getElementById('elem');
	var elem1 = document.getElementById('elem1');
	var elem2 = document.getElementById('elem2');
	elem2.innerHTML = elem1.innerHTML;
	timer = setInterval(Scroll,40);
	function Scroll(){
		if(elem.scrollTop>=elem1.offsetHeight){
			elem.scrollTop -= elem1.offsetHeight;
		}else{
			elem.scrollTop += 1;
		}
	}	
	elem.onmouseover = function(){
		clearInterval(timer);
	}	
	elem.onmouseout = function(){
		timer = setInterval(Scroll,40);
	}
}
</script>
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