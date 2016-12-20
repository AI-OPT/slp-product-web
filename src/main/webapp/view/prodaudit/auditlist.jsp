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
<!-- 拒绝提示框 -->
<div class="eject-big">
    <div class="eject-medium" id="refuse-small">
        <!-- <div class="eject-medium-title">
            <p>审核拒接操作！</p>
            <p id="refuseCloseImg" class="img"><i class="fa fa-times"></i></p>
        </div> -->

        <div class="eject-medium-complete">
            <div class="form-label">
			<form id="prodAttrForm">
				<p><input type="hidden" id="upAttrId"  class="int-text int-medium"></p>
              <ul> 
                <li>
                   <p class="word"><span>*</span>拒绝原因</p>
                   <p>
                   	<select id="refuseReason" class="select select-medium">
	                   	<option value="10">信息有误</option>
	                   	<option value="11">信息未完善</option>
	                   	<option value="99">其他</option>
                   	</select>
                   </p>
              	 </li>
          	 </ul>
	           <ul>	
	               <li>
	                   <p class="word"><span>*</span>问题描述</p>
	                   <p><textarea id="refuseDes" name="refuseDes" class="int-text textarea-xlarge"
									maxlength="100" style="width:190px;height:80px;"
									required data-msg-required="问题描述不能为空"
									commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
									onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></textarea></p>
	               </li>
	           </ul>
         </form> 	 
		</div>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="refuseBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确定拒绝">
                <input id="refuseBtn-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<!-- 拒绝提示框结束 -->


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
									<p class="word">商品名称</p>
									<p><input id="productName" type="text" class="int-text int-medium"></p>
									<p class="sos"><a href="javascript:void(0);">高级搜索<i class="fa fa-caret-down"></i></a>
									</p>
								</li>
							</ul>
							<!--点击展开-->
							<div id="selectDiv" class="open" style="display:none;">
								<ul>
									<li class="col-md-6">
										<p class="word">商品ID</p>
										<p><input id="standedProdId" type="text" class="int-text int-medium"></p>
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
								<ul>
									<li class="col-md-6">
										<p class="word">操作开始时间</p>
										<p><input type="text" class="int-text int-medium" id="operStartTime" readonly="true">
											<span class="time"> <i class="fa  fa-calendar" ></i></span></p>
									</li>
									<li class="col-md-6">
										<p class="word">操作结束时间</p>
										<p><input type="text" class="int-text int-medium" id="operEndTime" readonly="true">
											<span class="time"> <i class="fa  fa-calendar" ></i></span>
										</p>
									</li>
								</ul>
								<ul>
									<li class="col-md-6">
										<p class="word">商品状态</p>
										<p>
											<select id="state" class="select select-medium">
												<option value="">全部</option>
												<option value="3">审核中</option>
												<option value="4">被拒绝</option>
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
							</div>
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
					<div class="main-box clearfix"  id="TableView"><!--白色背景-->
						<!--标题-->
						<header class="main-box-header clearfix">
							<h2 class="pull-left">商品审核列表</h2>
						</header>
						<div class="row"><!--删格化-->
                                <p class="right pr-30">
                                    <input name="refuseMoreBtn" type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="批量审核拒绝" onclick="#">
                                    <input name="auditMoreBtn" type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="批量审核通过" onclick="#">
                                </p>
                            </div>
						<!--标题结束-->
						<div class="main-box-body clearfix">
							<!--table表格-->
							<div class="table-responsive clearfix">
								<table class="table table-hover table-border table-bordered">
									<thead>
									<tr>
										<th><input id="checkall" name="checkall" type="checkbox" value="" />&nbsp;全选</th>
										<th>商品ID</th>
										<th>所属类目</th>
										<th>商品类型</th>
										<th>预览图</th>
										<th>商品名称</th>
										<th>商品状态</th>
										<th>操作时间</th>
										<th>操作</th>
									</tr>
									</thead>
									<tbody id="searchNormProductData">
									</tbody>

								</table>
								<div id="showMessageDiv"></div>
								<script id="searchNormProductTemple" type="text/template">
									<tr>
											{{if state=="3"}}
											<td><input id="box" name="box" type="checkbox" value="{{:prodId}}" /></td>
											{{else}}
											<td>
											</td>
											{{/if}}

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
											<td>{{:~timesToFmatter(operTime)}}</td>

											<td>
												<div>
													{{if state=="3"}}
													<!-- <p><a href="${_base}/prodquery/audit/{{:prodId}}" class="blue-border">审核商品</a></p> -->
													<p><a prodId="{{:prodId}}" name="toValidate" href="javaScript:void(0);" class="blue-border">审核商品</a></p>
													{{else}}
													<p><a prodId="{{:prodId}}" name="toViewReason" href="javaScript:void(0);" class="blue-border">查看原因</a></p>
													{{/if}}
													<p><a href="${_base}/prodquery/{{:prodId}}" class="blue-border">查看商品</a></p>
												</div>
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
		<%-- 全选 --%>
		$('#TableView').delegate("input[name='checkall']",'click',function(){
			pager._clickAll($(this));
		});		
		
		<%-- 单选 --%>
		$('#TableView').delegate("input[name='box']",'click',function(){
			pager._clicksingle($(this));
		});		
		
		<%-- 批量审核通过 --%>
		$('#TableView').delegate("input[name='auditMoreBtn']",'click',function(){
			pager._showAuditMore();
		});		
		
		<%-- 批量审核拒绝 --%>
		$('#TableView').delegate("input[name='refuseMoreBtn']",'click',function(){
			pager._showRefuseMore();
		});		
		<%-- 查看原因 --%>
        $('#searchNormProductData').delegate("a[name='toViewReason']", 'click', function () {
            var prodId = $(this).attr('prodId');
			if (window.console) {
				console.log("编辑链接:" + prodId);
			}
			pager._showReason(prodId);
        });
		<%-- 校验单个商品的地域 --%>
        $('#searchNormProductData').delegate("a[name='toValidate']", 'click', function () {
            var prodId = $(this).attr('prodId');
			if (window.console) {
				console.log("编辑链接:" + prodId);
			}
			pager._showToAudit(prodId);
        });
		
		seajs.use(['app/jsp/prodaudit/auditlist','app/util/center-hind'], function(auditlistPager,centerHind) {
			pager = new auditlistPager({element : document.body});
			pager.render();
			new centerHind({element : document.body}).render();
		});
	})();
</script>
</html>
