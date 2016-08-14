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
				                <li>
				                    <p class="word">属性名称</p>
				                    <p><input id="attrName" type="text" class="int-text int-medium"></p>
				                </li>
				                <li class="width-xlag">
									<p class="word">属性名称首字母（大写）</p>
									<p><input id="firstLetter" type="text" class="int-text int-medium"></p>
								</li>
				             </ul>
				             <ul>   
				                 <li>
				                    <p class="word">属性值输入方式</p>
				                    <p>
				                    	<select id="valueWay" class="select select-medium">
						                   	<option value="1">全部</option>
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
</div>
</body>
<script type="text/javascript">
	var pager;
	var count = '${count}';
	var prodInfoList = '${prodInfoList}';
	var productEditInfo = '${productEditInfo}';
	(function () {
		seajs.use('app/jsp/prodCat/addAttr', function(
				catlistPager) {
			pager = new catlistPager({
				element : document.body
			});
			pager.render();
		});
	})();
</script>
</html>