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
								<li class="col-md-12">
									<p class="word">商品评价</p>
									<p>
										<select id="shopScoreMs" class="select select-medium">
											<option value="">全部</option>
											<option value="5">好评</option>
											<option value="3">中评</option>
											<option value="1">差评</option>
										</select>
									</p>
									<p class="sos"><a href="javascript:void(0);">高级搜索<i class="fa fa-caret-down"></i></a>
									</p>
								</li>
							</ul>
							<!--点击展开-->
							<div id="selectDiv" class="open" style="display:none;">
								<ul>
									<li class="col-md-6">
										<p class="word">评价时间</p>
										<p><input id="commentTimeBegin" type="text" class="int-text int-medium"></p>
										<p><input id="commentTimeEnd" type="text" class="int-text int-medium"></p>
									</li>
								</ul>
								<ul>
									<li class="col-md-6">
										<p class="word">服务态度</p>
										<select id="shopScoreWl" class="select select-medium">
											<option value="">全部</option>
											<option value="1">1分</option>
											<option value="2">2分</option>
											<option value="3">3分</option>
											<option value="3">4分</option>
											<option value="3">5分</option>
										</select>
									</li>
									<li class="col-md-6">
										<p class="word">物流服务</p>
										<select id="shopScoreFw" class="select select-medium">
											<option value="">全部</option>
											<option value="1">1分</option>
											<option value="2">2分</option>
											<option value="3">3分</option>
											<option value="3">4分</option>
											<option value="3">5分</option>
										</select>
									</li>
								</ul>
								<ul>
									<li class="col-md-6">
										<p class="word">商品ID</p>
										<p><input id="standedProdId" type="text" class="int-text int-medium"></p>
									</li>
									<li class="col-md-6">
										<p class="word">订单号</p>
										<p><input id="orderId" type="text" class="int-text int-medium"></p>
									</li>
								</ul>
							</div>
								<ul>
									<li class="width-xlag">
										<p class="word">&nbsp;</p>
										<p><input type="button" class="biu-btn  btn-primary btn-blue btn-medium ml-10"
												  id="selectCommentList" value="查  询"></p>
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
										<th></th>
										<th>商品评价</th>
										<th>评价时间</th>
										<th>评价人</th>
										<th>评价内容</th>
										<th>评价图片</th>
										<th>物流服务</th>
										<th>服务态度</th>
										<th>商品ID</th>
										<th>商品名称</th>
										<th>订单号</th>
										<th>操作</th>
									</tr>
									</thead>
									<tbody id="searchCommentData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchCommentTemple" type="text/template">
									<tr>
										<td></td>
										<td>({{:shopScoreMs}}星)</td>
										<td>{{:commentTime}}</td>
										<td>{{:userName}}</td>
										<td class="hind1-medium text-l pl-15">
											<div class="center-hind" >{{:commentBody}}</div>
                                          	<div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:commentBody}}</div>
										</td>
										<td>{{:shopScoreFw}}分</td>
										<td>{{:shopScoreWl}}分</td>
										<td>{{:standedProdId}}</td>
										<td>{{:prodName}}</td>
										<td>{{:orderId}}</td>
                                        <td>
											<a href="${_base}/productcomment/delete?commentId='{{:commentId}}'" class="blue-border">废弃</a>
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
		<%-- 高级区域 --%>
		$(".form-label ul li .sos a").click(function () {
			$(".open ").slideToggle(100);
			$(".nav-form ").toggleClass("reorder remove");
		});
		seajs.use(['app/jsp/comment/commentlist','app/util/center-hind'], function(commentListPage,centerHind) {
			pager = new commentListPage({element : document.body});
			pager.render();
			new centerHind({element : document.body}).render();
		});
	})();
</script>
</html>