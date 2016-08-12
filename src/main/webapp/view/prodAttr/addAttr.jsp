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
	<div class="row" id="table1"><!--外围框架-->
		<div class="col-lg-12"><!--删格化-->
			<div class="row"><!--内侧框架-->
				<div class="col-lg-12"><!--删格化-->
					<div class="main-box clearfix"><!--白色背景-->
						<!-- 查询条件 -->
						<div class="form-label">
							<%-- 类目 --%>
							<form id="attrForm" action="${_base}/attr/saveAttr" method="post">
								<ul>
					                <li>
					                    <p class="word">属性名称</p>
					                    <p><input id="attrName" type="text" class="int-text int-medium"></p>
					                </li>
					                <li class="width-xlag">
										<p class="word">属性名称首字母</p>
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
					          </form> 	 
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
					 <ul>
		           	 <input type="button" id="add" class="biu-btn btn-blue btn-mini" value="添加"/>
		           	 </ul>
					 <ul>
		           	 <input type="button" id="saveAttr" class="biu-btn btn-blue btn-mini" value="保存"/>
		           	 <input type="button" id="cancel" class="biu-btn btn-blue btn-mini" value="取消"/>
		           	 </ul>
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
</body>
<script type="text/javascript">
	var pager;
	var count = '${count}';
	(function () {
		seajs.use('app/jsp/prodAttr/addAttr', function(
				addAttrPager) {
			pager = new addAttrPager({
				element : document.body
			});
			pager.render();
		});
	})();
</script>

<script type="text/javascript">
	


</script>


<script type="text/javascript">
		i = 1;
	document.getElementById("add").onclick=function(){
	  
		 document.getElementById("table1").innerHTML+=
			 '<div id="div_'+i+'"><div class="row"><div class="col-lg-12"><div class="row"><div class="col-lg-12"><div class="main-box clearfix"><div class="form-label"><ul><li><p class="word">属性名称</p><p><input id="attrName_'+i +'"class="int-text int-medium"></p></li><li class="width-xlag"><p class="word">属性名称首字母</p><p><input id="firstLetter_'+i+'"class="int-text int-medium"></p></li></ul><ul><li><p class="word">属性值输入方式</p><p><select id="valueWay_'+i+'"class="select select-medium"><option value="1">全部</option><option value="1">下拉单选</option><option value="2">多选</option></select></p>  <input type="button" class="biu-btn btn-blue btn-mini" value="删除"  onclick="del('+i+')"/></li></ul></div></div></div></div></div></div>'
		 
	  i = i + 1;
	}

	function del(o){
	 document.getElementById("table1").removeChild(document.getElementById("div_"+o));
	}
</script>


</html>