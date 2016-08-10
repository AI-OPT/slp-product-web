define('app/jsp/productcat/catlist', function (require, exports, module) {
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
    require("twbs-pagination/jquery.twbsPagination.min");
   
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    //定义页面组件类
    var catlistPager = Widget.extend({
    	
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
    		//查询
            },
    	//重写父类
    	setup: function () {
    		catlistPager.superclass.setup.call(this);
    	},
    	
    	
    	//查询
    	_selectNormProductList:function(){
    		var _this = this;
    		/*var div = document.getElementById("data1ProdCat");
    		var length = document.getElementsByTagName("select").length-3;
    		var productCatId = $("#productCat"+length+" option:selected").val();
    		var productType = $("#productType").val().trim();
    		var productId = $("#standedProdId").val().trim();
    		var productName = $("#standedProductName").val().trim();
    		
    		var state = $("#state").val().trim();
    		var operStartTime = $("#operStartTime").val().trim();
    		var operEndTime = $("#operEndTime").val().trim();*/
    		
    		$("#pagination-ul").runnerPagination({
    			
	 			url: _base+"/normprodquery/getNormProductList",
	 			
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchNormProductData",
	 			messageId:"showMessageDiv",
	 			
	           /* data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	            */
	 			/*data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName,
		 			"operStartTimeStr":operStartTime,"operEndTimeStr":operEndTime,"state":state
		 			},*/
	 			
	           	pageSize: catlistPager.DEFAULT_PAGE_SIZE,
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
    
    module.exports = catlistPager
});

