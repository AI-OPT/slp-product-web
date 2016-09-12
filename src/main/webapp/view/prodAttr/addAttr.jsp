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
						<form id="prodAttrForm" action="${_base}/attr/saveAttr" method="post">
						<div id="addViewDiv" class="main-box-body clearfix">
                            <!-- 查询条件 -->
                            <div class="form-label bd-bottom ui-form" data-widget="validator">
								<ul>
					                <li class="col-md-12 ui-form-item">
					                    <p class="word"><span>*</span>属性名称</p>
					                    <p><input name="attrName0" type="text" class="int-text int-medium" maxlength="20" required data-msg-required="属性名称不能为空"
                                                  val-tag="attrName"></p>
					                </li>
					                <li class="col-md-12 ui-form-item">
										<p class="word"><span>*</span>名称首字母(大写)</p>
										<p><input  name="firstLetter0" type="text" class="int-text int-medium"  maxlength="1" required data-msg-required="名称首字母不能为空" regexp="[A-Z]{1}"
                                                  data-msg-regexp="请输入大写的名称首字母" val-tag="firstLetter"></p>
									</li>
					             </ul>
					             <ul>
					             	<li class="col-md-12 ui-form-item">
					             		<p class="word"><span>*</span>属性值输入方式</p>
					             		<p>
					                    	<select id="test" name="valueWay" class="select select-medium">
							                   	<option value="1">下拉单选</option>
							                   	<option value="2">多选</option>
							                   	<option value="3">可输入文本框(单行)</option>
							                   	<option value="4">可输入文本框(多行)</option>
					                    	</select>
					                    </p>
					            	</li>
					             </ul>
					             
					            <!--  <div class="title-right">
					             	<p id="addAttrBtn" class="plus-word btn-primary" >
					             		 <a href="javaScript:void(0);"><i class="fa fa-plus"></i>新  增</a>
					             	</p>
					             </div> -->
                            </div> 
                            <div id="subDiv" class="form-label">
                            <div class="left row title-right">
                                <p id="addAttrBtn" class="plus-word btn-primary">
                                    <a href="javaScript:void(0);"><i class="fa fa-plus"></i>新  增</a></p>
                            </div>
                            </div>
                            <div  class="row pt-30">
                            	<p class="center pr-30 mt-30">
                            		<input id="submitAddAttrBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                           value="提  交">
                                    <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                           value="返  回" onclick="javaScript:window.history.go(-1);">
                            	</p>
                            </div>
                            
						</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script id="attrAddTemplate"  type="text/template">
	 <!-- 查询条件 -->
                            <div class="form-label bd-bottom ui-form" data-widget="validator">
								<div class="title-right">
                                   <p class="plus-word btn-primary">

                                     <a href="javaScript:void(0);" name="delBtn"><i class="fa fa-times"></i>删  除</a> 
									
									</p>
                                </div>
								<input name="num{{:num}}" type="hidden" class="int-text int-medium">
								<ul>
					                <li class="col-md-12 ui-form-item">
					                    <p class="word"><span>*</span>属性名称</p>
					                    <p><input name="attrName" type="text" class="int-text int-medium" maxlength="20"></p>
					                </li>
					                <li class="col-md-12 ui-form-item">
										<p class="word"><span>*</span>属性名称首字母</p>
										<p><input  name="firstLetter" type="text" class="int-text int-medium"  maxlength="1"></p>
									</li>
					             </ul>
					             <ul>
					             	<li class="col-md-12 ui-form-item">
					             		<p class="word"><span>*</span>属性值输入方式</p>
					             		<p>
					                    	<select id="test" name="valueWay" class="select select-medium">
							                   	<option value="1">下拉单选</option>
							                   	<option value="2">多选</option>
							                   	<option value="3">可输入文本框(单行)</option>
							                   	<option value="4">可输入文本框(多行)</option>
							                   	<option value="5">日期时间</option>
							                   	<option value="6">日期时间段</option>
					                    	</select>
					                    </p>
					            	</li>
					             </ul>
							</div>
</script>


</body>
<script type="text/javascript">
    var pager;
    var attrNum = {'num':0};
    (function () {
        <%-- 删除按钮 --%>
        $('#addViewDiv').delegate("a[name='delBtn']", 'click', function () {
            console.log("删除");
            $(this).parent().parent().parent().remove();
        });
        
        seajs.use('app/jsp/prodAttr/addAttr', function (attrAddPager) {
            pager = new attrAddPager({element: document.body});
            pager.render();
        });
    })();
</script>

<!-- <script type="text/javascript">
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
</script> -->

<!-- <script type="text/javascript">
	var i=1;
	function add(){
		i++;
		var div=document.createElement('div');
		var html= '<div class="col-lg-12"><div class="row"><div class="col-lg-12"><div class="main-box clearfix"><div class="form-label"><ul><li><p class="word">'
		+'属性名称</p><p><input id="attrName_'+i +'"class="int-text int-medium"></p></li><li class="width-xlag"><p class="word">'
		+'属性名称首字母</p><p><input id="firstLetter_'+i+'"class="int-text int-medium"></p></li></ul><ul><li><p class="word">'
		+'属性值输入方式</p><p><select id="valueWay_'+i+'"class="select select-medium"><option value="1">全部</option><option value="1">下拉单选</option><option value="2">多选</option></select></p> '
		+' <a href="javascript:" class="biu-btn btn-blue btn-mini" onclick="RemoveAdd('+i+')">删除</a></li></ul></div></div></div></div>';
		div.innerHTML=html;
		div.setAttribute("id","talbe"+i);
		div.class="row";
		document.getElementById('table0').appendChild(div);
	 }
	
	function RemoveAdd(id)
	{
	 var div=document.getElementById('talbe'+id);
	 var div2=document.getElementById('table0');
	 div2.removeChild(div);
	}  
	
</script> -->



<!-- <script type="text/javascript">
	function a2(){
		i = 1;
		var a  = $("#table_0");
		var b = a.clone(true);
		
		var div = $("#table_0");
		div.append(b);
		i = i + 1;
		}
</script> -->


<!-- <script type="text/javascript">
		i = 1;
 	document.getElementById("add").onclick=function(){
	  
		 document.getElementById("table1").innerHTML+=
			 '<div id="table_'+i+'"><div class="row"><div class="col-lg-12"><div class="row"><div class="col-lg-12"><div class="main-box clearfix"><div class="form-label"><ul><li><p class="word">属性名称</p><p><input id="attrName_'+i +'"class="int-text int-medium"></p></li><li class="width-xlag"><p class="word">属性名称首字母</p><p><input id="firstLetter_'+i+'"class="int-text int-medium"></p></li></ul><ul><li><p class="word">属性值输入方式</p><p><select id="valueWay_'+i+'"class="select select-medium"><option value="1">全部</option><option value="1">下拉单选</option><option value="2">多选</option></select></p>  <input type="button" class="biu-btn btn-blue btn-mini" value="删除"  onclick="del('+i+')"/></li></ul></div></div></div></div></div></div>'
		 
	  i = i + 1;
	} 
	function del(o){
	 document.getElementById("table1").removeChild(document.getElementById("table_"+o));
	}
</script> -->

<!-- <script type="text/javascript">
//提交表单
function submitForm(){
	//有效性验证
	if(!$('#itemAddForm').form('validate')){
		$.messager.alert('提示','还未填写完成!');
		return ;
	}
	
	if("" == $("input[id='attrName']").val()){
		$.messager.alert('提示','属性名未填写!');
		return ;
	}
	
	$.post("/item/save",$("#itemAddForm").serialize(), function(data){
		if(data.status == 200){
			$.messager.alert('提示','新增成功!');
		}
	});
}
</script> -->

</html>