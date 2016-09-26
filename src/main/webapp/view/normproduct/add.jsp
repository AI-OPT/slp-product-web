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
                                <h5 class="pull-left"><div id="productCatValues">您当前选择的商品类目是：${productCatValues}</div>
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
												<c:if test="${status.index==0}"><option value="">--请选择--</option></c:if>
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
	(function () {
		seajs.use('app/jsp/normproduct/add', function(addPager) {
			pager = new addPager({element : document.body});
			pager.render();
		});
	})();
	
</script>
</html>
