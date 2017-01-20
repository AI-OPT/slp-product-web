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
            <p>更新属性值</p>
        </div>
		<div class="form-label">
		<form id="prodAttrValueForm">
			<input type="hidden" id="upAttrvalueDefId" />
			<input type="hidden" id="upAttrId" />
			<ul>
				<li>
                   <p class="word"><span>*</span>属性值名称</p>

                   <p><input id=upAttrValueName type="text" name="productAttrValueName" class="int-text int-medium" 
                   			onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')" commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/" maxlength="20"></p>

               </li>
				<li class="width-xlag">
					<p class="word"><span>*</span>名称首字母(大写)</p>
					<p><input id="upFirstLetter" type="text" name="firstLetter" class="int-text int-medium" maxlength="1" required data-msg-required="首字母不能为空"></p>
				</li>
	        </ul>
	    </form>   
		</div>
		<!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="upAttrValueBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="确  定">
                <input id="increase-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
	</div>	
	<div class="mask" id="eject-mask"></div>	
</div>
<!-- 编辑弹框结束 -->

<!-- 删除单个属性弹框 -->
<div class="eject-big">
    <div class="eject-samll" id="aband-small">
        	<input type="hidden" id="delAttrvalueDefId" />
			<input type="hidden" id="delAttrId" />
        <div class="eject-medium-title">
            <p>删除属性值</p>
            <p id="delCloseImg" class="img"><i class="fa fa-times"></i></p>
        </div>

        <div class="eject-medium-complete">
            <p><img src="${uedroot}/images/eject-icon-prompt.png"></p>
            <p class="word">确定删除该属性值吗？</p>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="delAttrValueBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
                <input id="aband-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<!-- 删除单个属性弹框结束 -->




<div class="content-wrapper-iframe"><!--右侧灰色背景-->
	<div class="row"><!--外围框架-->
		<div class="col-lg-12"><!--删格化-->
			<div class="row"><!--内侧框架-->
				<div class="col-lg-12"><!--删格化-->
					<div class="main-box clearfix"><!--白色背景-->
						<!-- 查询条件 -->
						<div class="form-label">
						<input type="hidden" id="attrId" name="attrId" value="${attrId}"/>
							<%-- 类目 --%>
							<ul>
								<li class="col-md-6">
									<p class="word">属性值ID</p>
									<p><input id="attrvalueDefId" type="text" class="int-text int-medium"></p>
								</li>
				                <li class="col-md-6">
				                    <p class="word">属性值名称</p>
				                    <p><input id="attrValueName" type="text" class="int-text int-medium"></p>
				                </li>
				               </ul>
				           	 <ul>
				                <li class="width-xlag">
				               		 <p class="word">&nbsp;</p>
				                    <p><input id="selectAttrValueList" type="button" value="查询" class="biu-btn  btn-primary btn-blue btn-medium ml-10"/></p>
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
							<h2 class="pull-left">属性值列表</h2>
						</header>
						<div class="row"  id="addAttrValueBtn"><!--删格化-->
                                <%-- <p class="right pr-30">
                                    <a name="addAttrValueView" href="${_base}/attrManage/addAttrValue" class="biu-btn  btn-primary btn-blue btn-auto  ml-5">新  增</a>
                                </p> --%>
                              <p class="right pr-30">
                                    <input id="addAttrValueBtn" name="addAttrValueView" type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="新  增" onclick="javaScript:window.location.href = '${_base}/attrManage/addAttrValue?attrId=${attrId}';">
                              </p>
                        </div>
						
						<!--标题结束-->
							<!--table表格-->
							<div class="main-box-body clearfix">
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th>属性值ID</th>
										<th>属性值名称</th>
										<th>输入值首字母</th>
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
										<td>{{:attrvalueDefId}}</td>
										<td>
											<div class="hind1 text-l pl-15">
											<div class="center-hind" >{{:attrValueName}}</div>
                                          	<div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:attrValueName}}</div>
											</div>
										</td>
										<td>{{:firstLetter}}</td>
										<td>{{:~timesToFmatter(operTime)}}</td>
										<td>{{:operName}}</td>
										<td>
											<a attrvalueDefId="{{:attrvalueDefId}}" name="editView" href="javaScript:void(0)" class="blue-border">编辑</a>
											<a attrvalueDefId="{{:attrvalueDefId}}" name="delView" href="javaScript:void(0)" class="blue-border">删除</a>
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
							  <div id="subDiv" class="row pt-30">
                            	<p class="center pr-30 mt-30">
                                    <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                           value="返  回" onclick="javaScript:window.history.go(-1);">
                            	</p>
                            </div>
						</div>
					</div> 
				</div>
			</div>
		</div>
	</div>
<%-- <script id="attrAddTemplate"  type="text/template">
	 <!-- 查询条件 -->
          <div class="form-label bd-bottom" data-widget="validator">
			<input type="hidden" id="attrId" name="attrId" value="${attrId}"/>
			<div class="title-right">
              <p class="plus-word btn-primary">
                   <a href="javaScript:void(0);" name="delBtn"><i class="fa fa-times"></i>删  除</a> 
			  </p>
            </div>
			<ul>
				<li>
                   <p class="word">属性值名称</p>
                   <p><input id="attrValueName{{:num}}" name="attrValueName" type="text" class="int-text int-medium"></p>
               </li>
				<li class="width-xlag">
					<p class="word">名称首字母(大写)</p>
					<p><input id="firstLetter" name="firstLetter" type="text" class="int-text int-medium"></p>
				</li>
	        </ul>
		</div>
</script>--%>
</body>

<script type="text/javascript">
    var pager;
    var attrNum = {'num':0};
    (function () {
    	<%-- 新增属性值的删除按钮 --%>
        /*  $('#addViewDiv').delegate("a[name='delBtn']", 'click', function () {
            console.log("删除");
            $(this).parent().parent().parent().remove();
        });  */
    	
    	<%-- 新增按钮 --%>
    	 /*  $('#addAttrValueBtn').delegate("a[name='addAttrValueView']", 'click', function () {
            pager._showAddAttr();
        }); */
    	 
    	
    	<%-- 编辑按钮 --%>
         $('#searchAttrData').delegate("a[name='editView']", 'click', function () {
            var attrvalueDefId = $(this).attr('attrvalueDefId');
			 if (window.console) {
				 console.log("编辑链接:" + attrvalueDefId);
			 }
            pager._showAttr(attrvalueDefId);
        });
         
        <%-- 删除按钮 --%>
         $('#searchAttrData').delegate("a[name='delView']", 'click', function () {
            var attrvalueDefId = $(this).attr('attrvalueDefId');
			 if (window.console) {
				 console.log("编辑链接:" + attrvalueDefId);
			 }
            pager._showDelConf(attrvalueDefId);
        });
        
        seajs.use('app/jsp/prodAttr/attrManage', function (attrlistPager) {
            pager = new attrlistPager({element: document.body});
            pager.render();
        });
    })();
</script>
<script src="${uedroot}/scripts/modular/frame.js"></script>



</html>