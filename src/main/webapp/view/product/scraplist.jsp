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
							<%-- 类目 --%>
							<ul id="data1ProdCat">
								<li class="col-md-12">
									<p class="word">商品类目</p>
										<p id="productCat0">
											<select class="select select-small" onChange="pager._selectChange(this);">
													<option value="">全部</option>
												<c:forEach var="info" items="${catInfoList}">
													<option value="${info.productCatId}">${info.productCatName}</option>
												</c:forEach>
											</select>
										</p>
								<%-- 	<c:forEach var="map" items="${catInfoMap}" varStatus="status">
										<p id="productCat${status.index}">
											<select class="select select-small" onChange="pager._selectChange(this);">
												<c:forEach var="info" items="${map.value}">
													<option value="${info.productCatId}">${info.productCatName}</option>
												</c:forEach>
											</select>
										</p>
									</c:forEach> --%>
									
									
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
							 <ul>
	                            <li class="col-md-6">
	                                <p class="word">商品名称</p>
	                                <p><input id="productName" type="text" class="int-text int-medium"></p>
	                            </li>
	                            <li>
	                                <p class="word">商品ID</p>
	                                <p><input id="productId" type="text" class="int-text int-medium"></p>
	                            </li>
							</ul>
							 <ul>
	                        	<li class="col-md-6">
	                                <p class="word">商品类型</p>
	                                <p>
		                                <select id="productType" class="select select-medium">
		                                	<option value="">全部</option>
		                                	<option value="1">实物</option>
		                                	<option value="2">虚拟</option>
		                                </select>
	                                </p>
	                            </li>
	                            
	                        </ul>
							<ul>
								<li class="width-xlag">
									<p class="word">&nbsp;</p>
									<p><input type="button" class="biu-btn  btn-primary btn-blue btn-medium ml-10"
											  id="selectProductList" value="查  询"></p>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row"><!--外围框架-->
		<div class="col-lg-12"><!--删格化-->
			<div class="row"><!--内侧框架-->
				<div class="col-lg-12"><!--删格化-->
					<div class="main-box clearfix"><!--白色背景-->
						<!--标题-->
						<header class="main-box-header clearfix">
							<h2 class="pull-left">查询结果</h2>
						</header>
						<!--标题结束-->
						<div class="main-box-body clearfix">
							<!--table表格-->
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th>商品ID</th>
										<th>所属类目</th>
										<th>类型</th>
										<th>预览图</th>
										<th width="30%">商品名称</th>
										<th>状态</th>
										<th>生成时间</th>
										<th>操作</th>
									</tr>
									</thead>
									<tbody id="searchNormProductData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchNormProductTemple" type="text/template">
									<tr>
											<td>{{:prodId}}</td>
											<td>{{:productCatName}}</td>
											<td>{{:productTypeName}}</td>
											{{if picUrl==null || picUrl==""}}
											<td><img src="${_slpres}/images/sp-03-a.png"></td>
											{{else}}
											<td><img src="{{:picUrl}}"></td>
											{{/if}}
											<td>{{:prodName}}</td>
											<td>{{:stateName}}</td>
											<td>{{:~timesToFmatter(createTime)}}</td>
											<td>
												<div>
													<p><a href="${_base}/prodedit/{{:prodId}}" class="blue-border">查看商品</a></p>
												</div>
											</td>
										</tr>
								</script>
							</div>
							<!--分页-->
							<div class="paging">
								<ul id="pagination-ul">
								</ul>
							</div>
							<!--分页结束-->
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
		seajs.use('app/jsp/product/scraplist', function(scraplistPager) {
			pager = new scraplistPager({element : document.body});
			pager.render();
		});
	})();
</script>
</html>

