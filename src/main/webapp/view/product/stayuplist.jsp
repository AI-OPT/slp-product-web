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
<!--确认是否上架弹出框 -->
<%-- <div class="eject-big">
    <div class="eject-samll" id="aband-small">
        <input type="hidden" id="insaleId">
        <div class="eject-medium-title">
            <p>确认上架</p>
            <p id="createCloseImg" class="img"><i class="fa fa-times"></i></p>
        </div>

        <div class="eject-medium-complete">
            <p><img src="${uedroot}/images/eject-icon-help.png"></p>
            <p class="word">确定上架销售吗？</p>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="submitBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
                <input id="addBtn-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div> --%>
<!--确认是否上架弹出框 结束-->

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
										<p><input id="productName" type="text" class="int-text int-medium"></p>
									</li>
									<li class="col-md-6">
										<p class="word">商品ID</p>
										<p><input id="standedProdId" type="text" class="int-text int-medium"></p>
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
									<li class="col-md-6">
										<p class="word">商品状态</p>
										<p>
											<select id="state" class="select select-medium">
												<option value="">全部</option>
												<option value="6">待上架</option>
												<option value="61">售罄下架</option>
												<option value="62">库存暂停下架</option>
											</select>
										</p>
									</li>
								</ul>
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
							<h2 class="pull-left">待上架商品列表</h2>
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
										<th>商品类型</th>
										<th>预览图</th>
										<th>商品名称</th>
										<th>商品状态</th>
										<!-- <th>生成时间</th> -->
										<th>操作</th>
									</tr>
									</thead>
									<tbody id="searchNormProductData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchNormProductTemple" type="text/template">
									<tr>
											<!-- <td>{{:prodId}}</td> -->
											<td>{{:standedProdId}}</td>
											<td>
												<div class="hind1 text-l pl-15">
												<div class="center-hind" >{{:productCatName}}</div>
                                          		<div class="showbj showbj1"><i class="fa fa-posi fa-caret-up"></i>{{:productCatName}}</div>
												</div>
											</td>
											<td>{{:productTypeName}}</td>
											{{if picUrl==null || picUrl==""}}
											<td><img src="${_slpres}/images/sp-03-a.png"></td>
											{{else}}
											<td><img src="{{:picUrl}}"></td>
											{{/if}}
											<td>
												<div class="hind1 text-l pl-15">
												<div class="center-hind" >{{:prodName}}</div>
                                          		<div class="showbj showbj1"><i class="fa fa-posi fa-caret-up"></i>{{:prodName}}</div>
												</div>
											</td>
											<td>{{:stateName}}</td>
											<!-- <td>{{:~timesToFmatter(createTime)}}</td> -->

											{{if state=="6"}}
											<td>
												<div>
													<p><a name="insaleBtnView" prodId="{{:prodId}}" href="javaScript:void(0)" class="blue-border">上架销售</a></p> 
													<p><a href="${_base}/prodedit/{{:prodId}}" class="blue-border">编辑商品</a></p>
												</div>
											</td>
											{{else}}
											<td>
												<div>
													<p><a href="${_base}/prodedit/{{:prodId}}" class="blue-border">编辑商品</a></p>
													<p><a href="${_base}/prodquery/{{:prodId}}" class="blue-border">查看商品</a></p> 
												</div>
											</td>
											{{/if}}
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
		<%-- 高级区域 --%>
		$(".form-label ul li .sos a").click(function () {
			$(".open ").slideToggle(100);
			$(".nav-form ").toggleClass("reorder remove");
		});
		<%-- 上架确认框 --%>
		$('#searchNormProductData').delegate("a[name='insaleBtnView']", 'click', function () {
			var productId = $(this).attr('prodId');
			if (window.console) {
				console.log("编辑链接:" + productId);
			}
            pager._showInSale(productId);
        });
		
		seajs.use(['app/jsp/product/stayuplist','app/util/center-hind'], function(stayuplistPager,centerHind) {
			pager = new stayuplistPager({element : document.body});
			pager.render();
			new centerHind({element : document.body}).render();
		});
	})();
</script>
</html>