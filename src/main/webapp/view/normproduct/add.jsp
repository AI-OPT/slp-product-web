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
						<!--标题-->
						<header class="main-box-header clearfix">
							<h2 class="pull-left">选择类目</h2>
						</header>
						<div class="main-box-body clearfix">
							<!-- 类目链 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left"><div id="productCatValues">您当前选择的商品类别是：${productCatValues}</div>
                                </h5>
                            </header>
                            <header class="main-box-header clearfix">
                                <h6 class="pull-left">（商品一旦生成，类目信息不可更改，请谨慎选择类目信息）</h6>
                            </header>
                            <div class="form-label">
                            <ul id="dataProdCat">
								<li class="col-md-12">
									<p><span>*</span>商品类目</p>
									<c:forEach var="map" items="${catInfoMap}" varStatus="status">
										<p id="productCat${status.index}">
											<select name="selectProductCat" id="selectCat${status.index}" class="select select-small" onChange="pager._selectChange(this);">
												<c:forEach var="info" items="${map.value}">
													<option value="${info.productCatId}">${info.productCatName}</option>
												</c:forEach>
											</select>
										</p>
									</c:forEach>
									<script id="prodCatTemple" type="text/template">
										<p id="productCat{{:level}}">
											<select name="selectProductCat" id="selectCat{{:level}}" class="select select-small" onChange="pager._selectChange(this);">
												{{for prodCatList}}
												<option value="{{:productCatId}}">{{:productCatName}}</option>
												{{/for}}
											</select>
										</p>
									</script>
								</li>
							</ul>
							</div>	
							<div id="subDiv" class="row pt-30">
                            	<p class="center pr-30 mt-30">
                            		<input id="next" type="button" class="biu-btn  btn-primary  btn-xxlarge  ml-5"
                                           value="下一步，填写详细信息">
                                    <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-mini  ml-5"
                                           value="返  回" onclick="javaScript:window.history.go(-1);">
                            	</p>
                            </div>
						</div>
						
						<%-- <!-- 查询条件 -->
						<div class="form-label">
							类目


							<div class="contains">
							
							<div class="selectedSort"><b>您当前选择的商品类别是：</b><i id="selectedSort"></i></div>
							
							<!--商品分类-->
						    <div class="wareSort clearfix">
								<ul id="sort1"></ul>
								<ul id="sort2" style="display: none;"></ul>
								<ul id="sort3" style="display: none;"></ul>
							</div>
							
							
							<div class="wareSortBtn">
							
								<p class="right pr-30">
                                    <input type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="下一步" onclick="javaScript:window.location.href = '${_base}/normprodedit/addinfo';">
                                </p>
							</div>
							
							<div class="nav-form">
					            <ul>
					                <li class="width-xlag">
					                <input type="hidden" productCatId = "2">
					                 <p class="blling-btn add-btn"><a href="${_base}/normprodedit/2">下一步，填写详细信息</a></p>
					            </ul>   
					        </div>
							
						</div>


						</div> --%>
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
		seajs.use('app/jsp/normproduct/add', function(addPager) {
			pager = new addPager({element : document.body});
			pager.render();
		});
	})();
	
	
	

	
	
</script>
</html>















<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
				
				            <div class="nav-form-title">选择类目</div>
				           	<div class="add-commodity-title">
				           		<ul>
				           			<li>您当前选择的是：<a href="#">登山野营/旅行装备</a>><a href="#">户外露营/野炊装备</a>><a href="#">帐篷/天幕/帐篷配件</a></li>
				           			<li class="color-word">（标准品一旦生成，类目信息不可更改，请谨慎选择类目信息）</li>
				           		</ul>
				           	</div>
				            
				                <!--结果标题-->
				                <div id="date1">
				                    <div class="form-label">
				                        <ul id="data1ProdCat">
				                            <li class="width-xlag">
				                            
				                                <c:forEach var="map" items="${catInfoMap}" varStatus="status">
													<p id="productCat${status.index}">
														<div class="add-ctn-list">
															<div class="add-ctn-list-title"><input type="text" class="int-large" placeholder="输入名称/拼音首字母"><a href="#"><i class="icon-search"></i></a></div>
											           			<div class="add-ctn-list-table">
											           				<ul>
											           					<c:forEach var="info" items="${map.value}">
											           						<li><a href="#" value="${info.productCatId}">${info.productCatName}</a></li>
																			<option value="${info.productCatId}">${info.productCatName}</option>   	
																		</c:forEach>
											           				</ul>
											           			</div>
										           		</div>
													</p>
												</c:forEach> 
				                                
				                                <script id="prodCatTemple" type="text/template">
                                	 <p id="productCat{{:level}}">
										<select class="select select-small" onChange="pager._selectChange(this);">
											{{for prodCatList}}
                                   			 	<option value="{{:productCatId}}">{{:productCatName}}</option>
											{{/for}}
                               			</select>
									</p>
								</script>
				                            </li>
				                        </ul>
				                    </div>
				                    
				                </div>
					            <div class="nav-form">
					            <ul>
					                <li class="width-xlag">
					                <p><input type="button" class="blling-btn add-btn" value="下一步，填写详细信息"></p>
					                
					                 
					                 <p class="blling-btn add-btn"><a href="${_base}/normprodedit/addinfo">下一步，填写详细信息</a></p>
					            </ul>   
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
<script type="text/javascript">
	(function () {
		seajs.use('app/jsp/product/addlist', function (AddlistPager) {
			pager = new AddlistPager({element: document.body});
		});
	})();
</script>
</html> --%>