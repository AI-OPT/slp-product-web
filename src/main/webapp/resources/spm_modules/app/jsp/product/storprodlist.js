define('app/jsp/product/storprodlist', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging-debug'),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    //定义页面组件类
    var StorprodlistPager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 30
    	},
    	//事件代理
    	events: {
    		//查询待上架商品
            "click #searchStayUpProd":"_selectStayUpProd",
            //查询售罄下架商品
            "click #searchSaleDownProd":"_selectSaleDownProd",
            //查询库存暂停商品
            "click #searchStorStopProd":"_selectStorStopProd",
            
            "click #stayUpPage":"_selectStayUpProd",
            "click #saleDownPage":"_selectSaleDownProd",
            "click #storStopPage":"_selectStorStopProd",
            "click #upConfirm":"_prodToInSale"
        },
    	//重写父类
    	setup: function () {
    		StorprodlistPager.superclass.setup.call(this);
    		this._selectStayUpProd();
    	},
    	//弹出上架确认提示框
    	_showUpConfirm:function(prodId){
    		$(".eject-big").show();
    		$(".eject-samll").show();
    		$(".eject-mask").show();
    		clickId = prodId;
    	},
    	//上架销售
    	_prodToInSale: function(){
    		$(".eject-big").hide();
    		$(".eject-samll").hide();
    		$(".eject-mask").hide();
    		var _this = this;
    		var prodId = clickId;
    		ajaxController.ajax({
				type: "post",
				processing: false,
				message: "上架中，请等待...",
				url: _base+"/prodOperate/prodToSale",
				data:{"productId":prodId},
				success: function(data){
					if("1"===data.statusCode){
						_this._selectStayUpProd();
						var d = Dialog({
							content:"上架成功.",
							icon:'success',
							okValue: '确 定',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}else{
	            		var d = Dialog({
							content:"上架失败:"+data.statusInfo,
							icon:'fail',
							okValue: '确 定',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}
				}
			});
    	},
    	// 改变商品类目
    	_selectChange:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(10))+1;
    		//获取下拉菜单的总个数
    		var div = document.getElementById("date1ProdCat");
    		var length = div.getElementsByTagName("select").length;
    		if(index==length){
    			return;
    		}
    		//从当前元素开始移除后面的下拉菜单
    		for(var i=index;i<length;i++){
    			$("#productCat"+i).remove();
    		}
    		ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/cat/query/child",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
							icon:'fail',
							okValue: '确 定',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}
				}
			});
    	},
    	// 售罄下架改变商品类目
    	_selectChange2:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(11))+1;
    		//获取下拉菜单的总个数
    		var div = document.getElementById("date2ProdCat");
    		var length = div.getElementsByTagName("select").length;
    		if(index==length){
    			return;
    		}
    		//从当前元素开始移除后面的下拉菜单
    		for(var i=index;i<length;i++){
    			$("#productCat2"+i).remove();
    		}
    		ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/prodquery/getCat",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple2");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
							icon:'fail',
							okValue: '确 定',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}
				}
			});
    	},
    	// 库存暂停改变商品类目
    	_selectChange3:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(11))+1;
    		//获取下拉菜单的总个数
    		var div = document.getElementById("date3ProdCat");
    		var length = div.getElementsByTagName("select").length;
    		if(index==length){
    			return;
    		}
    		//从当前元素开始移除后面的下拉菜单
    		for(var i=index;i<length;i++){
    			$("#productCat3"+i).remove();
    		}
    		ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/prodquery/getCat",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple3");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
							icon:'fail',
							okValue: '确 定',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}
				}
			});
    	},
    	//查询待上架商品-点击查询触发
    	_selectStayUpProd:function(){
    		var _this = this;
    		//获取下拉菜单的总个数
    		var div = document.getElementById("date1ProdCat");
    		var length = div.getElementsByTagName("select").length-1;
    		var	productCatId = $("#productCat"+length+" option:selected").val();
    		var productType = $("#productType").val().trim();
    		var productId = $("#productId").val().trim();
    		var productName = $("#productName").val().trim();
    		$("#stayup-pagination-ul").runnerPagination({
	 			url: _base+"/prodquery/getStayUpList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"selectStayUpProdData",
	 			messageId:"showMessageDiv",
	            data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	           	pageSize: StorprodlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#selectStayUpProdTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#selectStayUpProdData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//查询库存暂停商品-点击查询触发
    	_selectStorStopProd:function(){
    		var _this = this;
    		//获取下拉菜单的总个数
    		var div = document.getElementById("date3ProdCat");
    		var length = div.getElementsByTagName("select").length-1;
    		var	productCatId = $("#productCat3"+length+" option:selected").val();
    		var productType = $("#productType3").val().trim();
    		var productId = $("#productId3").val().trim();
    		var productName = $("#productName3").val().trim();
    		$("#storstop-pagination-ul").runnerPagination({
	 			url: _base+"/prodquery/getStorStopList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"selectStorStopProdData",
	 			messageId:"showMessageDiv3",
	            data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	           	pageSize: StorprodlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#selectStorStopProdTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#selectStorStopProdData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//查询售罄下架商品-点击查询触发
    	_selectSaleDownProd:function(){
    		var _this = this;
    		//获取下拉菜单的总个数
    		var div = document.getElementById("date2ProdCat");
    		var length = div.getElementsByTagName("select").length-1;
    		var	productCatId = $("#productCat2"+length+" option:selected").val();
    		var productType = $("#productType2").val().trim();
    		var productId = $("#productId2").val().trim();
    		var productName = $("#productName2").val().trim();
    		$("#saledown-pagination-ul").runnerPagination({
	 			url: _base+"/prodquery/getSaleDownList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"selectSaleDownProdData",
	 			messageId:"showMessageDiv2",
	            data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	           	pageSize: StorprodlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#selectSaleDownProdTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#selectSaleDownProdData").html(htmlOutput);
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
    
    module.exports = StorprodlistPager
});

