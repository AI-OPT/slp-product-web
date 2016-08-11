define('app/jsp/prodcat/catlist', function (require, exports, module) {
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
    var catListPager = Widget.extend({
    	
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
			"click #selectList":"_selectPageList"
            },
    	//重写父类
    	setup: function () {
			catListPager.superclass.setup.call(this);
			this._selectPageList();
    	},
    	
    	
    	//查询
    	_selectPageList:function(){
    		var _this = this;
			var catId = $("#productCatId").val();
			var parentCatId = $("#parentProductCatId").val();
			var catName = $("#productCatName").val();
			var isChile = $("#isChild").val();
    		$("#pagination-ul").runnerPagination({
	 			url: _base+"/cat/query/list",
	 			method: "POST",
	 			dataType: "json",
	 			renderId: "listData",
	 			messageId:"showMessageDiv",
	 			data:
					{
						"productCatId":catId,"parentProductCatId":parentCatId,
						"productCatName":catName,"isChild":isChile
		 			},
	           	pageSize: catListPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#listData").html(htmlOutput);
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
    
    module.exports = catListPager
});

