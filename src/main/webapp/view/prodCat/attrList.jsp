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
							<ul>
								<li class="width-xlag">
									<p class="word">属性ID</p>
									<p><input id="attrId" type="text" class="int-text int-medium"></p>
								</li>
				                <li>
				                    <p class="word">属性名称</p>
				                    <p><input id="attrName" type="text" class="int-text int-medium"></p>
				                </li>
				                 <li>
				                    <p class="word">属性值输入方式</p>
				                    <p>
				                    	<select id="valueWay" class="select select-medium">
						                   	<option value="">全部</option>
						                   	<option value="1">下拉单选</option>
						                   	<option value="2">多选</option>
						                   	<!-- <option value="">可输入文本框(单行)</option>
						                   	<option value="">可输入文本框(多行)</option>
						                   	<option value="">日期时间</option>
						                   	<option value="">日期时间段</option> -->
				                    	</select>
				                    </p>
				               	 </li>
				           	 </ul>
				           	 <ul>
				                <li class="width-xlag">
				                    <p><input id="selectCatAttrList" type="button" value="查询" class="biu-btn btn-blue btn-mini"/></p>
				                    <p><input type="reset" value="重置" class="biu-btn btn-blue btn-mini"/></p>
				                    
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
							<div class="nav-tplist-title">
				                   <div class="nav-tplist-title nav-tplist-title-border">
					                  <ul>
					                    <div class="title-right">
						                    <p><input id="#" type="button" value="新增属性" class="biu-btn btn-blue btn-mini"/></p>
					                    </div>
					                  </ul>
				              		</div>
			              	</div>
			             </div>
							<!--table表格-->
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th>序号</th>
										<th>属性ID</th>
										<th>属性名称</th>
										<th>输入值方式</th>
										<th>属性值数量</th>
										<th>操作时间</th>
										<th>操作人</th>
										<th>操作</th>
									</tr>
									</thead>
									<tbody id="searchAttrData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchAttrTemple" type="text/template">
									<tr>
										<td>{{:#index+1}}</td>
										<td>{{:attrId}}</td>
										<td>{{:attrName}}</td>
										<td>{{:valueWay}}</td>
										<td>{{:attrValNum}}</td>
										<td>{{:operTime}}</td>
										<td>{{:operId}}</td>
										<td><a href="#" class="blue-border">编辑</a></td>
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
		seajs.use('app/jsp/prodCat/attrList', function(
				catlistPager) {
			pager = new catlistPager({
				element : document.body
			});
			pager.render();
		});
	})();
</script>
</html>

