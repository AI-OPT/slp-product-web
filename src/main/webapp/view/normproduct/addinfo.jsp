<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
	<meta charset="UTF-8">
	<title>运营管理</title>
	<%@ include file="/inc/inc.jsp" %>
	<link href="${_slpres }/styles/bootstrap.css"rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/font-awesome.css" rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/frame.css" rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/global.css" rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/modular.css" rel="stylesheet" type="text/css">
	
</head>

<body>

<!--顶部菜单-->
	<%@ include file="/inc/top-menu.jsp" %>
	<!--顶部菜单结束-->
	<!-- 左侧菜单 -->
	<%@ include file="/inc/left-menu.jsp" %>
	<!-- 左侧菜单结束 -->


<div class="wrapper"><!--外围框架-->
<!--右侧框架-->
 <div class="wrapper-right">
    <!--公告位置-->
        <div class="right-topnav">
            <p class="gongg"><A href="#">［公告］:</A></p>
            <div  id="elem">
            <ul id="elem1">
                <li><A href="#">公告位置！比如说系统维护，哪些功能在什么时间段可能不可用之类的，针对后台</A></li>
                <li><A href="#">公告位置！比如说系统维护，哪些功能在什么时间段可能不可用之类的，针对后台</A></li>
                <li><A href="#">公告位置！比如说系统维护，哪些功能在什么时间段可能不可用之类的，针对后台</A></li>
                <li><A href="#">公告位置！比如说系统维护，哪些功能在什么时间段可能不可用之类的，针对后台</A></li>
            </ul>
            <ul id="elem2">
            </ul>
            </div>
             <p class="dclose"><A href="#"><i class="icon-remove"></i></A></p>
        </div>
    <!--公告位置结束-->   
    <!--标签-->
    <div class="right-tags">
        <ul>
           <li>
	           <p class="none">您现在的位置：</p>
	           <p><a href="#">标准品库管理</a></p>  
	           <p>></p>  
	           <p>添加编辑页面</p>
           </li>
        </ul>  
    </div>
    
   <!--标签结束-->
      <!--查询区域-->
     
  		
    <div class="form-wrapper"><!--白底内侧-->
    <div class="nav-tplist-wrapper"><!--白底内侧-->
    
    	<form id="nromProdForm" action="${_base}/normprodedit/save" method="post">
	       <div class="nav-form-title">添加</div>
	        <div class="nav-form nav-form-border">
	           	<ul>
	                <li class="width-xlag">
	                    <p class="word"><b style="color:#f00;">*</b>标准品名称</p>
	                    <p><input id="standedProductName" name="standedProductName" type="text" class="int-text int-xlarge"></p>
	                    <p>限45字以内</p>
	                </li>   
	            </ul>
	            <ul>
	            	<li class="width-xlag">
	                    <p class="word"><b style="color:#f00;">*</b>标准品类型</p>
	                    <p>
	                    	<select id="productType" name="productType" class="select select-medium">
			                   	<option value="1">实物</option>
			                   	<option value="2">虚拟</option>
			                </select>
			            </p>
	                    
	                    <p><input id="state" name="state" type="checkbox" class="checkbox-small">标识标准品状态：未使用，已使用，已过期</p>
	               </li>
	            </ul>  
	        </div>
	        
	        
	        
	        <!-- 标准品关键属性 动态获取 1关键属性  2销售属性  3非关键属性 -->
	        <!-- 获取到类目ID 从而得到该类目下的属性值    根据属性值的name(属性值的ID跟name是一一对应) 可以得到valueWay  -->
	        <div class="nav-form-title">标准品关键属性</div>
	        <div class="nav-form nav-form-border" id="attrAndValDiv">
	        	<input type="hidden" id="keyAttrStr" name="keyAttrStr">
				<c:forEach var="attr" items="${attrAndVal}">
						<ul>
							<li>
								<p class="word">${attr.key.attrName}</p>
								<c:choose>
									<!-- 1关键属性	2销售属性		3非关键属性 -->
									<c:when test="${attr.key.attrType == '1'}">
										<ul>
											<li class="width-xlag">
												<p class="word" attrId="${attr.key.attrId}" valueType="${attr.key.valueWay}">		<!-- 属性ID 属性值输入方式 -->
													${attr.key.attrName}
												</p>
												<c:choose>
													<!-- 下拉菜单 -->
													<c:when test="${attr.key.valueWay == '1'}">
														<select class="select select-medium" attrId="attrAndVal${attr.attrId}">
															<c:forEach var="valInfo" items="${attrAndVal.get(attr.key.attrId)}">
																<option test="${valInfo.attrvalueDefId}">
																	<c:if test="${valInfo.attrvalueDefId != null}">
																		selected
																	</c:if>
																	>${valInfo.attrValueName}
																</option>
															</c:forEach>
														</select>
													</c:when>
													
													<!-- 多选 -->
													<c:when test="${attr.key.valueWay == '2'}">
														<div class="width-xlag">
															<c:forEach var="valInfo" items="${attrAndVal.get(attr.key.attrId)}">
																<p><input type="checkbox" class="checkbox-small" attrId="attrAndVal${attr.attrId}" value="${valInfo.attrvalueDefId}"
																	  <c:if test="${valInfo.attrvalueDefId != null}">checked</c:if> >
																	  ${valInfo.attrValueName}
																</p>
															</c:forEach>
														</div>
													</c:when>
													
													<%--单行输入--%>
													<c:when test="${attr.key.valueWay == '3'}">
														<c:set var="valInfo" value="${attrAndVal.get(attr.key.attrId).get(0)}"></c:set>
														<p><input type="text" class="int-text int-xlarge" attrId="attrAndVal${attr.attrId}" maxlength="100"
																  <c:if test="${valInfo!=null}">value="${valInfo.attrValueName}"</c:if> >
														</p>
													</c:when>
													<%--多行输入--%>
													<c:when test="${attr.key.valueWay == '4'}">
														<c:set var="valInfo" value="${attrAndVal.get(attr.key.attrId).get(0)}"></c:set>
														<p>
															<textarea class="textarea-xlarge" maxlength="100"
																	 attrId="attrAndVal${attr.attrId}"><c:if test="${valInfo!=null}">${valInfo.attrValueName}</c:if>
															</textarea>
														</p>
													</c:when>
												</c:choose>
											</li>
										</ul>
									</c:when>
								</c:choose>
							</li>
						</ul>
					</c:forEach>
	        </div>
	        
	        
	        <div class="nav-form-title">标准品销售属性</div>	<!-- 标题 -->
	        <div class="nav-form nav-form-border">
	        <input type="hidden" id="saleAttrStr" name="saleAttrStr">
	        	<c:forEach var="attr" items="${attrAndVal}">
						<ul>
							<li>
								<p class="word">${attr.key.attrName}</p>
								<c:choose>
									<!-- 1关键属性	2销售属性		3非关键属性 -->
									<c:when test="${attr.key.attrType == '2'}">
										<ul>
											<li class="width-xlag">
												<p class="word" attrId="${attr.key.attrId}" valueType="${attr.key.valueWay}">		<!-- 属性ID 属性值输入方式 -->
													${attr.key.attrName}
												</p>
												<c:choose>
													<!-- 下拉菜单 -->
													<c:when test="${attr.key.valueWay == '1'}">
														<select class="select select-medium" attrId="attrAndVal${attr.attrId}">
															<c:forEach var="valInfo" items="${attrAndVal.get(attr.key.attrId)}">
																<option test="${valInfo.attrvalueDefId}">
																	<c:if test="${valInfo.attrvalueDefId != null}">
																		selected
																	</c:if>
																	>${valInfo.attrValueName}
																</option>
															</c:forEach>
														</select>
													</c:when>
													
													<!-- 多选 -->
													<c:when test="${attr.key.valueWay == '2'}">
														<div class="width-xlag">
															<c:forEach var="valInfo" items="${attrAndVal.get(attr.key.attrId)}">
																<p><input type="checkbox" class="checkbox-small" attrId="attrAndVal${attr.attrId}" value="${valInfo.attrvalueDefId}"
																	  <c:if test="${valInfo.attrvalueDefId != null}">checked</c:if> >
																	  ${valInfo.attrValueName}
																</p>
															</c:forEach>
														</div>
													</c:when>
													
													<%--单行输入--%>
													<c:when test="${attr.key.valueWay == '3'}">
														<c:set var="valInfo" value="${attrAndVal.get(attr.key.attrId).get(0)}"></c:set>
														<p><input type="text" class="int-text int-xlarge" attrId="attrAndVal${attr.attrId}" maxlength="100"
																  <c:if test="${valInfo!=null}">value="${valInfo.attrValueName}"</c:if> >
														</p>
													</c:when>
													<%--多行输入--%>
													<c:when test="${attr.key.valueWay == '4'}">
														<c:set var="valInfo" value="${attrAndVal.get(attr.key.attrId).get(0)}"></c:set>
														<p>
															<textarea class="textarea-xlarge" maxlength="100"
																	 attrId="attrAndVal${attr.attrId}"><c:if test="${valInfo!=null}">${valInfo.attrValueName}</c:if>
															</textarea>
														</p>
													</c:when>
												</c:choose>
											</li>
										</ul>
									</c:when>
								</c:choose>
							</li>
						</ul>
					</c:forEach>
	        
	        <%-- 
				<c:forEach var="attr" items="${attrAndVal}">
					<ul>
						<li class="width-xlag">
							<p class="word" attrId="${attr.key.attrId}" valueType="${attr.key.valueWay}">		<!-- 属性ID 属性值输入方式 -->
								${attr.key.attrName}
							</p>
							<c:choose>
								<!-- 下拉菜单 -->
								<c:when test="${attr.key.valueWay == '1'}">
									<select class="select select-medium" attrId="attrAndVal${attr.attrId}">
										<c:forEach var="valInfo" items="${attrAndVal.get(attr.key.attrId)}">
											<option test="${valInfo.attrvalueDefId}">
												<c:if test="${valInfo.attrvalueDefId != null}">
													selected
												</c:if>
												>${valInfo.attrValueName}
											</option>
										</c:forEach>
									</select>
								</c:when>
								
								<!-- 多选 -->
								<c:when test="${attr.key.valueWay == '2'}">
									<div class="width-xlag">
										<c:forEach var="valInfo" items="${attrAndVal.get(attr.key.attrId)}">
											<p><input type="checkbox" class="checkbox-small" attrId="attrAndVal${attr.attrId}" value="${valInfo.attrvalueDefId}"
												  <c:if test="${valInfo.attrvalueDefId != null}">checked</c:if> >
												  ${valInfo.attrValueName}
											</p>
										</c:forEach>
									</div>
								</c:when>
								
								单行输入
								<c:when test="${attr.key.valueWay == '3'}">
									<c:set var="valInfo" value="${attrAndVal.get(attr.key.attrId).get(0)}"></c:set>
									<p><input type="text" class="int-text int-xlarge" attrId="attrAndVal${attr.attrId}" maxlength="100"
											  <c:if test="${valInfo!=null}">value="${valInfo.attrValueName}"</c:if> >
									</p>
								</c:when>
								多行输入
								<c:when test="${attr.key.valueWay == '4'}">
									<c:set var="valInfo" value="${attrAndVal.get(attr.key.attrId).get(0)}"></c:set>
									<p>
										<textarea class="textarea-xlarge" maxlength="100"
												 attrId="attrAndVal${attr.attrId}"><c:if test="${valInfo!=null}">${valInfo.attrValueName}</c:if>
										</textarea>
									</p>
								</c:when>
							</c:choose>
						</li>
					</ul>
				</c:forEach>


 --%>

	        </div>
	        
	        
	        
	        
	        <!-- 标准品状态  从缓存中获取 -->
	        <div class="nav-form-title">标准品状态</div>
	        <div class="nav-form">
	           		<ul>
	                <li class="width-xlag">
	                    <p class="word"><b style="color:#f00;">*</b>状态</p>
	                    <p>
	                    	<select class="select select-small" name="state">
								<c:forEach var="state" items="${state}">
									<option value="${state.columnValue}">${state.columnDesc}</option>
								</c:forEach>
							</select>
						</p>
	                    
	                </li>
	            </ul>  
	        </div>
	        <div class="nav-form">
	            <ul>
	                <li class="width-xlag">
		                <p class="word">&nbsp;</p>
		                <p><input id="saveNormProd" type="button" class="biu-btn btn-blue btn-large mr-10" value="保  存"></p>
		                <p><input id="cancel" type="button" class="biu-btn btn-blue btn-large mr-10" value="返回"></p>
	                </li>
	            </ul>   
	        </div>
		</form>
    </div>
   <!--查询区域结束-->


    </div>
    </div>
</div>	
<!-- footer -->
<div class="footer">版权所有 © SLP版权归运营家所有</div>
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