define('app/jsp/product/stayuplist', function (require, exports, module) {
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

	    var SendMessageUtil = require("app/util/sendMessage");
	    
	    //实例化AJAX控制处理对象
	    var ajaxController = new AjaxController();
	    var clickId = "";
	    //定义页面组件类
	    var stayuplistPager = Widget.extend({
	    	
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
	    		//查询
	            "click #selectProductList":"_selectProductList",
//	            "click #addBtn-close":"_closeConf",
//	            "click #createCloseImg":"_closeConf",
//	            "click #submitBtn":"_prodToInSale",//上架操作
	            },
	    	//重写父类
	    	setup: function () {
				stayuplistPager.superclass.setup.call(this);
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
	    		var length = document.getElementsByTagName("select").length-3;
	    		var productCatId = $("#productCat"+length+" option:selected").val();
	    		var productType = $("#productType").val().trim();
	    		var standedProdId = $("#standedProdId").val().trim();
	    		var productName = $("#productName").val().trim();
	    		var state = $("#state").val().trim();
	    		
	    		$("#pagination-ul").runnerPagination({
		 			url: _base+"/prodquery/getStayUpList",
		 			method: "POST",
		 			dataType: "json",
		 			renderId:"searchNormProductData",
		 			messageId:"showMessageDiv",
		 			data: {"productCatId":productCatId,"productType":productType,"standedProdId":standedProdId,"productName":productName,
			 			"state":state},
		 			
		           	pageSize: stayuplistPager.DEFAULT_PAGE_SIZE,
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
	    	
	    	//确认上架弹框
/*	    	_showInSale:function(productId){
	    		$('#eject-mask').fadeIn(100);
	    		$('#aband-small').slideDown(200);
	    		if (window.console) {
	    			console.log("insale id is " + productId);
	    		}
	    		$("#insaleId").val(productId);
	    	},
	    	
*/	  
	    	_showInSale:function(productId){
	    		var _this = this;
	    		new Dialog({
					content:'确定上架销售吗?',
					icon:'help',
					okValue: '确 定',
					title: '提示',
					ok:function(){
						this.close();
						_this._prodToInSale(productId);
					},
					cancelValue: '取消',
					cancel: function () {
						this.close();
					}
				}).show();
	    	},
	    	
			//关闭确认提示框
			_closeConf:function(){
				$('#eject-mask').fadeOut(100);
				$('#aband-small').slideUp(150);
			},
			//上架销售
	    	_prodToInSale: function(productId){
	    		var _this = this;
	    		_this._closeConf();
	    		ajaxController.ajax({
					type: "post",
					processing: false,
					message: "上架中，请等待...",
					url: _base+"/prodOperate/prodToSale",
					data:{"productId":productId},
					success: function(data){
						if("1"===data.statusCode){
							var d = Dialog({
								content:"上架成功",
								icon:'success',
								okValue: '确 定',
								title: '提示',
								ok:function(){
									this.close();
									_this._selectProductList();
								}
							});
							d.show();
		            	}else{
		            		var d = Dialog({
								content:"上架失败:"+data.statusInfo,
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
			
	    	/*_showSuccessMsg:function(msg){
	    		var _this=this;
				var msg = Dialog({
					title: '提示',
					icon:'prompt',
					content:msg,
					okValue: '确 定',
					ok:function(){
						//this.close();
						window.history.go(-1);
					}
				});
				msg.showModal();
			},*/
	    	//滚动到顶部
	    	_returnTop:function(){
	    		var container = $('.wrapper-right');
	    		container.scrollTop(0);//滚动到div 顶部
	    	},
	    	
	    });
	    
	    module.exports = stayuplistPager;
	});