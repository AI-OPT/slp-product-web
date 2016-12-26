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
<!-- 点击编辑按钮弹框 -->
<div class="eject-big">
	<div class="eject-medium" id="increase-samll">
		<!--编辑-->
		<div class="eject-medium-title">
            <p>更新属性</p>
            <!-- <p id="upCloseImg" class="img"><i class="fa fa-times"></i></p> -->
        </div>
		<div class="form-label">
		<form id="prodAttrForm">
						<p><input type="hidden" id="upAttrId"  class="int-text int-medium"></p>
	           <ul>	
	               <li>
	                   <p class="word"><span>*</span>属性名称</p>
	                   <p><input id="upAttrName" type="text" name="productAttrName" class="int-text int-medium" onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')" commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/" maxlength="15" ></p>
	               </li>
	           </ul>
	           <ul>	
	               <li>
	                   <p class="word"><span>*</span>名称首字母(大写)</p>
	                   <p><input id="upFirstLetter" type="text" class="int-text int-medium" name="firstLetter" maxlength="1"></p>
	               </li>
	           </ul>
              <ul> 
                <li>
                   <p class="word"><span>*</span>属性值输入方式</p>
                   <!-- 1.下拉单选 2.多选 3.可输入文本框（单行）4.可输入文本框（多行）
								   5.日期时间 6.日期时间段 -->
                   <p>
                   	<select id="upValueWay" class="select select-medium">
	                   	<option value="1">下拉单选</option>
	                   	<option value="2">多选</option>
	                   	<option value="3">可输入文本框</option>
                   	</select>
                   </p>
              	 </li>
          	 </ul>
         </form> 	 
		</div>
		<!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="upAttrBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="确  定">
                <input id="increase-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
	</div>	
	<div class="mask" id="eject-mask"></div>	
	</div>
<!-- 编辑弹框结束 -->


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
								<li class="col-md-6">
									<p class="word">属性ID</p>
									<p><input id="attrId" type="text" class="int-text int-medium"></p>
								</li>
				                <li class="col-md-6">
				                    <p class="word">属性名称</p>
				                    <p><input id="attrName" type="text" class="int-text int-medium"></p>
				                </li>
				               </ul>
				               <ul> 
				                 <li class="col-md-6">
				                    <p class="word">属性值输入方式</p>
				                    <!-- 1.下拉单选 2.多选 3.可输入文本框（单行）4.可输入文本框（多行）
   										   5.日期时间 6.日期时间段 -->
				                    <p>
				                    	<select id="valueWay" class="select select-medium">
						                   	<option value="">全部</option>
						                   	<option value="1">下拉单选</option>
						                   	<option value="2">多选</option>
						                   	<option value="3">可输入文本框</option>
				                    	</select>
				                    </p>
				               	 </li>
				           	 </ul>
				           	 <ul>
				                <li class="width-xlag">
				               		 <p class="word">&nbsp;</p>
				                    <p><input id="selectAttrList" type="button" value="查询" class="biu-btn  btn-primary btn-blue btn-medium ml-10"/></p>
				                    <!-- <p><input type="reset" value="重置" class="biu-btn btn-blue btn-mini"/></p> -->
				                    
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
							<h2 class="pull-left">属性列表</h2>
						</header>
						<div class="row"><!--删格化-->
                                <%-- <p class="right pr-30">
                                    <a href="${_base}/attr/addAttr" class="biu-btn  btn-primary btn-blue btn-auto  ml-5" role="button">新  增</a>
                                </p> --%>
                                <p class="right pr-30">
                                    <input type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="新  增" onclick="javaScript:window.location.href = '${_base}/attr/addAttr';">
                                </p>
                            </div>
						
						<!--标题结束-->
							<!--table表格-->
							<div class="main-box-body clearfix">
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th>属性ID</th>
										<th>属性名称</th>
										<th>输入值方式</th>
										<th>属性值数量</th>
										<th>操作时间</th>
										<th>操作人</th>
										<th>操作</th>
									</tr>
									</thead>
									<tbody id="searchAttrData"></tbody>
								</table>
								<div id="showMessageDiv"></div>
								<script id="searchAttrTemple" type="text/template">
									<tr>
										<td>{{:attrId}}</td>
										<td>
											<div class="hind1 text-l pl-15">
											<div class="center-hind" >{{:attrName}}</div>
                                          	<div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:attrName}}</div>
											</div>
										</td>
										<td>{{:valueWay}}</td>
										<td>{{:attrValNum}}</td>
										<td>{{:~timesToFmatter(operTime)}}</td>
										<td>{{:operName}}</td>

										{{if valueWay == "可输入文本框" || valueWay == "可输入文本框（多行）"}}
											<td>
												<div>
													<a attrId="{{:attrId}}" name="editView" href="#" class="blue-border">编辑</a>
													<a attrId="{{:attrId}}" name="delView" href="#" class="blue-border">删除</a>
												</div>
											</td>
											{{else}}
											<td>
												<div>
													<a attrId="{{:attrId}}" name="editView" href="#" class="blue-border">编辑</a>
													<a attrId="{{:attrId}}" name="manageView" href="${_base}/attrManage/getAttrValue/{{:attrId}}" class="blue-border">管理属性值</a>
													<a attrId="{{:attrId}}" name="delView" href="#" class="blue-border">删除</a>
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
</div>
</body>

<script type="text/javascript">
    var pager;
    (function () {
    	<%-- 编辑按钮 --%>
        $('#searchAttrData').delegate("a[name='editView']", 'click', function () {
            var attrId = $(this).attr('attrId');
			if (window.console) {
				console.log("编辑链接:" + attrId);
			}
			pager._showAttr(attrId);
        });
        
        <%-- 删除按钮 --%>
        $('#searchAttrData').delegate("a[name='delView']", 'click', function () {
            var attrId = $(this).attr('attrId');
			if (window.console) {
				console.log("编辑链接:" + attrId);
			}
			pager._showDelConf(attrId);
        });
        seajs.use('app/jsp/prodAttr/attrList', function (attrlistPager) {
            pager = new attrlistPager({element: document.body});
            pager.render();
        });
    })();
</script>
<script src="${uedroot}/scripts/modular/frame.js"></script>


</html>

