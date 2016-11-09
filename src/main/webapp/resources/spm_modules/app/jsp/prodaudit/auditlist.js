define('app/jsp/prodaudit/auditlist', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging-debug'),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("my97DatePicker/WdatePicker");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    require("opt-paging/aiopt.pagination");

    //require("jquery-validation/1.15.1/jquery.validate");
	require("app/util/aiopt-validate-ext");
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    //定义页面组件类
    var auditlistPager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 10
    	},
    	//事件代理
    	events: {
            "click #refuseBtn-close":"_closeRefuse",
            "click #refuseCloseImg":"_closeRefuse",
            "click #submitBtn":"_auditProduct",//批量审核通过
            "click #refuseBtn":"_refuseProduct",//批量审核拒绝
    		//查询
            "click #selectProductList":"_selectProductList"
            },
    	//重写父类
    	setup: function () {
			auditlistPager.superclass.setup.call(this);
    		this._selectProductList();
    	},
    	
    	// 改变商品类目
    	_selectChange:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(10))+1;
    		//获取下拉菜单的总个数
    		var prodCat = document.getElementById("data1ProdCat");
    		var length = prodCat.getElementsByTagName("select").length;
    		//从当前元素开始移除后面的下拉菜单
    		for(var i=index;i<length;i++){
    			$("#productCat"+i).remove();
    		}
    		
    		//若为全部,则不查询.
			if (prodCatId === '')
				return;
			
    		ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/cat/query/child",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.data.length>0){
	            		var template = $.templates("#prodCatTemple");
	            	    var htmlOutput = template.render(data.data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else if(data.statusCode === AjaxController.AJAX_STATUS_FAILURE){
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
							icon:'fail',
							okValue: '确 定',
							title: '提示',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}
				}
			});
    	},
    	
    	
    	//查询商品列表
    	_selectProductList:function(){
    		var _this = this;
    		var div = document.getElementById("data1ProdCat");
    		var length = document.getElementsByTagName("select").length-4;
    		var productCatId = $("#productCat"+length+" option:selected").val();
    		var productType = $("#productType").val().trim();
    		var standedProdId = $("#standedProdId").val().trim();
    		var productName = $("#productName").val().trim();
    		var operStartTime = $("#operStartTime").val().trim(); 
    		var operEndTime = $("#operEndTime").val().trim();
    		var state = $("#state").val().trim();
    		
    		$("#pagination-ul").runnerPagination({
	 			url: _base+"/prodquery/getAuditList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchNormProductData",
	 			messageId:"showMessageDiv",
	 			data: {"productCatId":productCatId,"productType":productType,"standedProdId":standedProdId,"productName":productName,
		 			"operStartTimeStr":operStartTime,"operEndTimeStr":operEndTime,"state":state},
	 			
	           	pageSize: auditlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchNormProductTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchNormProductData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	
    	//全选
		_clickAll: function (obj) {
			var check = true;
			if (!obj.is(':checked')) {
				check = false;
			}
			$("input:checkbox[name='box']").prop("checked", check);
		},

		//如果列表子项都选中  全选按钮则选中
		_clicksingle: function (obj) {
			var prodId = obj.attr("prodId");
			var attrVal = obj.val();
			if (window.console) {
				console.log("prodId:" + prodId + ",click");
			}
			// 若子项没有都选中,则全选也取消 --%>
			if (!obj.is(':checked')) {
				$("input:checkbox[name='checkall']").prop("checked", false);
				return;
			}

			//获取列表中数据数量
			var valNum = $("input:checkbox[name='box']").size();
			//获取选中的数据数量
			var checkNum = $("input:checkbox:checked[name='box']").size();
			if (valNum == checkNum) {
				$("input:checkbox[name='checkall']").prop("checked", true);
			} else {
				$("input:checkbox[name='checkall']").prop("checked", false);
			}
		},

		//批量审核通过弹框
		_showAuditMore: function () {
			var _this = this;
			var checkNum = $("input:checkbox:checked[name='box']").size();
			if (checkNum == 0) {
				var d = Dialog({
					content: "请选择商品进行处理!",
					icon: 'prompt',
					okValue: '确 定',
					title: '提示',
					ok: function () {
						this.close();
					}
				});
				d.show();
			} else {
				Dialog({
					title: '提示',
					content: "确定全部通过审核吗?",
					icon: 'help',
					cancelValue:'取 消',
					okValue: '确 定',
					ok: function () {
						_this._auditProduct();
						this.close();
					},
					cancel:function(){
						this.close();
					}
				}).show();
			}
		},
		//关闭确认提示框
		_closeAudit:function(){
			$('#eject-mask').fadeOut(100);
			$('#audit-small').slideUp(150);
		},
		
		//点击确认批量审核通过
		_auditProduct: function () {
			var _this = this;
			var prodId = '';
			//获取列表中的选中项
			$("[name='box']:checked").each(function (index, element) {
				prodId += $(this).val() + ",";
			});
			this._closeAudit();
			
			//校验仓库分配地域是否大于等于商品销售地域
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				url: _base + "/prodOperate/toValidateMore",
				data: {"ids": prodId},
				success: function (data) {
					//获取数据成功
					if ("false" === data) {
						//返回false 弹框提示
						var d = Dialog({
							content:"请确认商品所属仓库分配地域不少于商品销售地域!",
							icon:'prompt',
							okValue: '确 定',
							title: '提示',
							ok:function(){
								this.close();
							}
						});
						d.show();
						_this.break;
					}else{
						ajaxController.ajax({
							type: "post",
							processing: true,
							message: "数据更新中,请等待...",
							url: _base + "/prodOperate/auditPassMore",
							data: {"ids": prodId},
							success: function (data) {
								//获取数据成功
								if ("1" === data.statusCode) {
									//返回列表
									//window.location.reload();
									_this._showPassSuccess();
								}
							}
						});
					}
				}
			});
			
			
			/*ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				url: _base + "/prodOperate/auditPassMore",
				data: {"ids": prodId},
				success: function (data) {
					//获取数据成功
					if ("1" === data.statusCode) {
						//返回列表
						//window.location.reload();
						_this._showPassSuccess();
					}
				}
			});*/
		},
		
		//点击确认批量审核拒绝
		_refuseProduct: function () {
			var _this = this;
			var prodId = '';
			var validateForm = $("#prodAttrForm").validate();
			if(!validateForm.form()){
				return;
			}
			var refuseReason = $("#refuseReason").val();
			var refuseDes = $("#refuseDes").val();
			//获取列表中的选中项
			$("[name='box']:checked").each(function (index, element) {
				prodId += $(this).val() + ",";
			});
			this._closeRefuse();
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				url: _base + "/prodOperate/auditRejectMore",
				data: {"ids": prodId, "refuseReason": refuseReason, "refuseDes": refuseDes},
				success: function (data) {
					//获取数据成功
					if ("1" === data.statusCode) {
						//返回列表
						//window.location.reload();
						_this._showRefuseSuccess();
					}
				}
			});
			
		},
		
		//批量审核拒绝
		_showRefuseMore:function(){
			 var checkNum = $("input:checkbox:checked[name='box']").size();
        	 if (checkNum == 0) {
        		 var d = Dialog({
						content:"请选择商品进行处理!",
						icon:'prompt',
						okValue: '确 定',
						title: '提示',
						ok:function(){
							this.close();
						}
					});
        		 d.show();
			}else{
				$('#eject-mask').fadeIn(100);
				$('#refuse-small').slideDown(200);
			}
		},
		
		//审核拒绝成功后弹框
		_showRefuseSuccess:function(){
			var d = Dialog({
				content:"商品审核拒绝成功",
				icon:'success',
				okValue: '确 定',
				title: '提示',
				ok:function(){
					this.close();
					window.location.reload();
				}
			});
		 d.show();
		},
		
		//审核通过成功弹框
		_showPassSuccess:function(){
			var d = Dialog({
				content:"商品审核通过成功",
				icon:'success',
				okValue: '确 定',
				title: '提示',
				ok:function(){
					this.close();
					window.location.reload();
				}
			});
		 d.show();
		},
		
		
		//关闭确认提示框
		_closeRefuse:function(){
			$('#eject-mask').fadeOut(100);
			$('#refuse-small').slideUp(150);
			$("#refuseReason").val("");
			$("#refuseDes").val("");
		},
		//弹出原因框
    	_showReason:function(prodId){
			//后台获取数据,
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据获取中,请等待...",
				url: _base+"/prodquery/toViewReason/"+prodId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//获取数据成功
						if("1"===data.statusCode){
							var reason= data.data.refuseDes;
							var reasonHtml="<textarea id=\"refuseDes\" name=\"refuseDes\" " +
									"style=\"width:270px;height:160px;overflow:hidden; resize:none;\" readOnly=\"true\">";
							reasonHtml += reason+"</textarea>";
							new Dialog({
								content:reasonHtml,
								okValue: '确 定',
								title:'商品拒绝原因',
								ok:function(){
									this.close();
								}
							}).show();
						}
					}
				}
			});

		},
		//关闭编辑页面弹出
		_closeEditDiv:function(){
			$('#eject-mask').fadeOut(100);
			$('#refuseReason-samll').slideUp(150);
			//清空数据
			$("#prodRefuseDes").val("");
		},
		
		//审核单个商品--根据商品ID获取仓库地域信息
		_showToAudit: function (prodId) {
			var _this = this;
			/*var prodId = '';*/
			
			//后台获取数据,
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据获取中,请等待...",
				url: _base+"/prodOperate/toValidate/"+prodId,
				success: function(data){
					//获取数据成功
					if("false"==data){
						var d = Dialog({
							content:"请确认商品所属仓库分配地域不少于商品销售地域!",
							icon:'prompt',
							okValue: '确 定',
							title: '提示',
							ok:function(){
								this.close();
							}
						});
						d.show();
						_this.break;
					}else{
						window.location.href = _base+"/prodquery/audit/"+prodId;
					
					}
				}
			});
		}
		
		
    });
    
    module.exports = auditlistPager;
});
