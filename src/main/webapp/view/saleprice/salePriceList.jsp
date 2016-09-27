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

							<ul>
								<li class="col-md-6">
									<p class="word">商品名称</p>
									<p><input id="standedProductName" type="text" class="int-text int-medium"></p>
								</li>
								<li class="col-md-6">
									<p class="word">商品ID</p>
									<p><input id="standedProdId" type="text" class="int-text int-medium"></p>
								</li>
							</ul>
							<!--点击展开-->
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
								<input type="hidden" id="state" value="1"/>
								<%-- 类目 --%>
								<ul id="data1ProdCat">
									<li class="col-md-12">
										<p class="word">商品类目</p>
										<p id="productCat0">
											<select id="catFirst" class="select select-small" onChange="pager._selectChange(this);">
												<option value="">全部</option>
												<c:forEach var="info" items="${catInfoList}">
													<option value="${info.productCatId}">${info.productCatName}</option>
												</c:forEach>
											</select>
										</p>
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
									<li class="width-xlag">
										<p class="word">&nbsp;</p>
										<p><input type="button" class="biu-btn  btn-primary btn-blue btn-medium ml-10"
												  id="selectNormProductList" value="查  询"></p>
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
							<h2 class="pull-left">销售价列表</h2>
						</header>
						<!--标题结束-->
						<div class="main-box-body clearfix">
							<!--table表格-->
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th width="20%">商品ID</th>
										<th width="30%">商品名称</th>
										<th width="20%">所属类目</th>
										<th width="10%">类型</th>
										<th width="10%">商品状态</th>
										<th width="10%">操作</th>
									</tr>
									</thead>
									<tbody id="searchNormProductData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchNormProductTemple" type="text/template">
									<tr>
										<td>{{:productId}}</td>
										<td>
											<div class="hind1-medium text-l pl-15">
											<div class="center-hind" >{{:productName}}</div>
											<div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:productName}}</div>
											</div>
										</td>
										<td>
											<div class="hind1-medium text-l pl-15">
											<div class="center-hind" >{{:catName}}</div>
											<div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:catName}}</div>
												</div>
										</td>
										<td>{{:productTypeName}}</td>
										<td>{{:stateName}}</td>
										<td><a href="${_base}/saleprice/query/{{:productId}}" class="blue-border">修改销售价</a></td>
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
		<%-- 展示日历 --%>
		$('#selectDiv').delegate('.fa-calendar','click',function(){
			var calInput = $(this).parent().prev();
			var timeId = calInput.attr('id');
			if (window.console) {
				console.log("click calendar " + timeId);
			}
			WdatePicker({el:timeId,readOnly:true});
		});
		<%-- 高级区域 --%>
		$(".form-label ul li .sos a").click(function () {
			$(".open ").slideToggle(100);
			$(".nav-form ").toggleClass("reorder remove");
		});
		$("#catFirst").val("");//设置类目为全部.
		seajs.use(['app/jsp/saleprice/salePriceList','app/util/center-hind'], function(salePriceList,centerHind) {
			pager = new salePriceList({element : document.body});
			pager.render();
			new centerHind({element : document.body}).render();
		});
	})();
</script>
</html>

