define('app/jsp/salableproduct/salableProductList', function (require, exports, module) {
    'use strict';
	var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
	AjaxController=require('opt-ajax/1.0.0/index'),
	Validator = require('arale-validator/0.10.2/index'),
	Dialog=require('artDialog/src/dialog'),
	Calendar = require('arale-calendar/1.1.2/index'),
	moment = require('moment/2.9.0/moment'),
	SendMessageUtil = require("app/util/sendMessage");

	require("bootstrap-paginator/bootstrap-paginator.min");
	require("twbs-pagination/jquery.twbsPagination.min");
	require('opt-paging/aiopt.pagination'),

    require("jsviews/jsrender.min");
	require("jsviews/jsviews.min");
	require("app/util/jsviews-ext");

	//实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    
    //定义页面组件类
    var SalableProductListPager = Widget.extend({
		Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 6
    	},
    	//事件代理
    	events: {
    		//key的格式: 事件+空格+对象选择器;value:事件方法
            "click #sp-search":"searchProductList",
			"click #PHONE_IDENTIFY":"_getPhoneVerifyCode"
		},
    	//重写父类
    	setup: function () {
			SalableProductListPager.superclass.setup.call(this);
			this._setMenu();
			this._bindCalendar();
			this._bindValidator();
			this._bindPopClose();
			this._getServiceType();
			this._getGroupBillingType();
			this._bindSendMessage();
			this.searchProductList();
    	},
		_setMenu:function () {
			setBreadCrumb("可销售产品管理","可销售产品查询");
			$("#mnu_bmc_config").addClass("current");
		},
		_bindPopClose:function () {
			$("#setvalid .pop-close").click(function () {
				$(this).parents("#setvalid").hide(300);
			});
		},
		_bindCalendar:function(){
			new Calendar({trigger: '#beginTime'});
			new Calendar({trigger: '#endTime'});
			$(".icon-calendar").each(function () {
				new Calendar({
					trigger: $(this),
					output:$(this).parent().siblings("input"),
					align: {
						selfXY: [0, 0],
						baseElement:$(this).parent().siblings("input"),
						baseXY: [0, '100%']
					}
				});
			});
		},
		_bindValidator:function(){
			var validator = new Validator({
				element:'#sp-form',
				failSilently:true
			});

			validator.addItem({
				element:'#price-start',
				rule:'number',
				display:'价格',
				alertFlag:true,
				errormessageNumber:'{{display}}必须是数字格式'
			});
		},
		_bindSendMessage:function(){
			var _this = this;
			var func = function(){
				$.ajax({
					type : "POST",
					url : _base + "/salableProduct/updateProductStatus",
					data: {
						productId : $("#setvalid input[name='productId']").val(),
						status : $("input[name='feeStatus']:checked").val()
					},
					processing: true,
					message : "正在处理中，请稍候...",
					success : function(data) {
						$("#setvalid").attr("style","display:none");
						Dialog({
							content: data.statusInfo,
							okValue:"确定",
							ok:function () {
								this.close();
								window.location.reload();
							}
						}).showModal();
					}
				});
			};
			$('#BTN_UPDATE_STATUS').bind("click", function(){
				_this._verifyPhoneCode(func);
			});
		},
		searchProductList:function(){
			var beginTime = $.trim($("#beginTime").val());
			var endTime = $.trim($("#endTime").val());
			if(beginTime!=""&&endTime!=""){
				var begin = moment(beginTime,"YYYY-MM-DD");
				var end = moment(endTime,"YYYY-MM-DD");
				if(end.diff(begin)<=0){
					var dc = Dialog({
						content:"生效截止日期必须大于生效开始日期",
						okValue:"确定",
						ok:function () {
							this.close();
						}
					});
					dc.show();
					return;
				}
			}
			var data = $("#sp-form :input,#sp-form select").serializeArray();
			$("#pagination").runnerPagination({
				url: _base+"/salableProduct/getSalableProductList",
				method: "POST",
				dataType: "json",
				processing: true,
				data : data,
				pageSize: SalableProductListPager.DEFAULT_PAGE_SIZE,
				visiblePages:5,
				message: "正在为您查询数据..",
				render: function (data) {
					if(data&&data.length>0){
						var template = $.templates("#productDataTmpl");
						var htmlOut = template.render(data);
						$("#productData").html(htmlOut);

						//绑定修改状态
						$(".sp-setvalid").click(function () {
							var productId = $(this).parents("td").siblings(".productId").text();
							var status = $(this).prev().val();
							$("#setvalid input[name='productId']").val(productId);
							$("#setvalid input:radio").removeAttr("checked");
							$("#valid").removeAttr("disabled");
							$("#invalid").removeAttr("disabled");
							if(status=='ACTIVE'){
								$("#invalid").prop("checked","checked");
								$("#valid").attr("disabled","disabled");
							}else{
								$("#valid").prop("checked","checked");
								$("#invalid").attr("disabled","disabled");
							}
							$("#setvalid").show();
						});

						//绑定删除
						$(".delProduct").click(function () {
							var status = $(this).parent().siblings(".pop-re").children("input:hidden").val();
							if(status=='ACTIVE'){
								var da = Dialog({
									content:"生效状态下的产品无法删除",
									okValue:"确定",
									ok:function () {
										this.close();
									}
								});
								da.showModal();
								return;
							}else {
								var productId = $(this).parents("td").siblings(".productId").text();
								var billingType = $(this).parents("td").siblings(".billingType").attr("billingType");
								var db = Dialog({
									content:"确定删除该商品？",
									okValue:"确定",
									cancelValue:"取消",
									ok:function () {
										ajaxController.ajax({
											type: "post",
											dataType: "json",
											processing: true,
											message: "正在删除，请等待...",
											url: _base+"/salableProduct/deleteProduct",
											data:{
												productId:productId,
												billingType:billingType
											},
											success: function(data){
												if(data&&data.statusCode=='1'){
													var dd = Dialog({
														content:"删除成功",
														okValue:"确定",
														ok:function () {
															this.close();
															window.location.reload();
														}
													});
													dd.showModal();
												}
											}
										});
									},
									cancel:function () {
										this.close();
									}
								});
								db.showModal();
							}
						});
						
						//绑定修改
						$(".updateProduct").click(function () {
							var status = $(this).parents("td").siblings().children("input:hidden").val();
							if(status=='ACTIVE'){
								var d = Dialog({
									content:"生效状态下的产品不能进行编辑",
									okValue:"确定",
									ok:function () {
										this.close();
									}
								});
								d.showModal();
							}else{
								var productId = $(this).parents("td").siblings(".productId").text();
								var billingType = $(this).parents("td").siblings(".billingType").attr("billingType");
								window.location.href = _base+"/salableProduct/toEdit?productId="+productId+"&billingType="+billingType
							}
						});
					}else{
						$("#productData").html("未搜索到信息");
					}
				}
			});
		},
		_getServiceType: function() {
			this.setSelectValue(_base + '/param/getServiceType', function(data){
				$("#serviceType").html('<option value="">请选择</option>');
				var json = eval(data);
				$.each(json,function(index, item) {
							// 循环获取数据
							var paramName = json[index].paramName;
							var paramCode = json[index].paramCode;
							$("#serviceType").append('<option cid="'+json[index].id+'" value="'+paramCode+'">'+paramName+'</option>');
						});
				$("#serviceType").append("<label id='accesstype_error'></label>");
			});
		},
		_getGroupBillingType: function() {
			this.setSelectValue(_base + '/param/getGroupBillingType', function(data){
				var json = eval(data);
				$.each(json,function(index, item) {
							// 循环获取数据
							var paramName = json[index].paramName;
							var paramCode = json[index].paramCode;
							$("#groupBillingType")
								.append('<option value="'+paramCode+'">'+paramName+'</option>');
						});
				$("#groupBillingType").append("<label id='accesstype_error'></label>");
			});
		},
		setSelectValue: function(url, callback){
			$.ajax({
					url : url,
					type : "post",
					async : false,
					dataType : "html",
					timeout : "10000",
					error : function() {
						alert("服务加载出错");
					},
					success : function(data) {
						callback.call(this,data);
					}
				});
		},
		serializeObjectToJson:function(obj){
			var o={};
			$.each(obj,function(index,e){
				if(o[e.name]){
					if(!o[e.name].push){
						o[e.name] = [o[e.name]];
					}
					o[e.name].push(e.value||'');
				}else{
					o[e.name] = e.value||'';
				}
			});
			return o;
		}
    });




    module.exports = SalableProductListPager
});
