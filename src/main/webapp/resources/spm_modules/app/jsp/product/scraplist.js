define('app/jsp/product/scraplist', function (require, exports, module) {
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
	    var scraplistPager = Widget.extend({
	    	
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
	            "click #selectProductList":"_selectProductList"
	            },
	    	//重写父类
	    	setup: function () {
				scraplistPager.superclass.setup.call(this);
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
	    		var productId = $("#productId").val().trim();
	    		var productName = $("#productName").val().trim();
	    		
	    		
	    		$("#pagination-ul").runnerPagination({
		 			url: _base+"/prodquery/getScrapList",
		 			method: "POST",
		 			dataType: "json",
		 			renderId:"searchNormProductData",
		 			messageId:"showMessageDiv",
		 			data: {"productCatId":productCatId,"productType":productType,"productId":productId,"prodName":productName
			 			},
		 			
		           	pageSize: scraplistPager.DEFAULT_PAGE_SIZE,
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
	    	
	    });
	    
	    module.exports = scraplistPager;
	});