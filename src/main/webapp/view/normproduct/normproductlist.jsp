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
									<!-- <p class="sos"><a href="javascript:void(0);">高级搜索<i class="fa fa-caret-down"></i></a></p> -->
								</li>
								<li class="col-md-6">
									<p class="word">商品ID</p>
									<p><input id="standedProdId" type="text" class="int-text int-medium"></p>
								</li>
							</ul>
							<!--点击展开-->
							<!-- <div id="selectDiv" class="open" style="display:none;"> -->
								<ul>
									<li class="col-md-6">
										<p class="word">商品状态</p>
										<p>
											<select id="state" class="select select-medium">
												<option value="">全部</option>
												<option value="1">可使用</option>
												<option value="2">不可使用</option>
												<option value="0">废弃</option>
											</select>
										</p>
									</li>
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
							<%-- 类目 --%>
							<ul id="data1ProdCat">
								<li class="col-md-12">
									<p class="word">商品类目</p>
									<c:forEach var="map" items="${catInfoMap}" varStatus="status">
										<p id="productCat${status.index}">
											<select name="selectProductCat" class="select select-small" onChange="pager._selectChange(this);">
												<c:if test="${status.index==0}"><option value="">全部</option></c:if>
												<c:forEach var="info" items="${map.value}">
													<option value="${info.productCatId}">${info.productCatName}</option>
												</c:forEach>
											</select>
										</p>
									</c:forEach>
									<script id="prodCatTemple" type="text/template">
										<p id="productCat{{:level}}">
											<select name="selectProductCat" class="select select-small" onChange="pager._selectChange(this);">
												{{for prodCatList}}
												<option value="{{:productCatId}}">{{:productCatName}}</option>
												{{/for}}
											</select>
										</p>
									</script>
								</li>
							</ul>
							<!-- </div> -->
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
							<h2 class="pull-left">商品列表</h2>
						</header>
						<div class="row"><!--删格化-->
                                <p class="right pr-30">
                                    <input type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="新  增" onclick="javaScript:window.location.href = '${_base}/normprodedit/add';">
                                </p>
                        </div>
						<!--标题结束-->
						<div class="main-box-body clearfix">
							<!--table表格-->
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th width="20%">商品ID</th>
										<th width="25%">商品名称</th>
										<th width="20%">所属类目</th>
										<th width="10%">类型</th>
										<th width="10%">商品状态</th>
										<th width="15%">操作</th>
									</tr>
									</thead>
									<tbody id="searchNormProductData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchNormProductTemple" type="text/template">
									{{for result ~pageNo=pageNo ~pageSize=pageSize}}
									<tr>
										<td>{{:productId}}</td>
										<td>
											<div class="hind1 text-l pl-15">
                                                <div class="center-hind" >{{:productName}}</div>
                                                <div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:productName}}</div>
                                            </div>
										</td>
										<td>
											<div class="hind1 text-l pl-15">
                                                <div class="center-hind" >{{:catName}}</div>
                                                <div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:catName}}</div>
                                            </div>
										</td>
										<td>{{:productTypeName}}</td>
										<td>{{:stateName}}</td>
                                        <td>
											<a href="${_base}/normprodquery/{{:productId}}" class="blue-border">查看详情</a>
											{{if state!='0'}}
												<a href="${_base}/normprodedit/{{:productId}}" class="blue-border">编辑</a>
                                            	<a href="javaScript:void(0)" onclick="pager._isDiscardDialog('{{:productId}}')" class="blue-border">废弃</a>
											{{/if}}
										</td>
									</tr>
									{{/for}}
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
		/* $('#selectDiv').delegate('.fa-calendar','click',function(){
			var calInput = $(this).parent().prev();
			var timeId = calInput.attr('id');
			console.log("click calendar "+timeId);
			WdatePicker({el:timeId,readOnly:true});
		}); */
		<%-- 高级区域 --%>
		/* $(".form-label ul li .sos a").click(function () {
			$(".open ").slideToggle(100);
			$(".nav-form ").toggleClass("reorder remove");
		}); */
		seajs.use(['app/jsp/normproduct/normproductlist','app/util/center-hind'], function(storageList,centerHind) {
			pager = new storageList({element : document.body});
			pager.render();
			new centerHind({element : document.body}).render(); 
		});
	})();
</script>
</html>