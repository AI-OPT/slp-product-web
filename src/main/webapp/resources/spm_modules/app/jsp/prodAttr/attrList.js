define('app/jsp/prodAttr/attrList', function (require, exports, module) {
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
    var attrlistPager = Widget.extend({
    	
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
            "click #selectCatAttrList":"_selectCatAttrList",
            },
    	//重写父类
    	setup: function () {
    		attrlistPager.superclass.setup.call(this);
    		this._selectCatAttrList();
    	},
    	
    	
    	//查询列表
    	_selectCatAttrList:function(){
    		var _this = this;
    		
    		var attrId = $("#attrId").val().trim();
    		var attrName = $("#attrName").val().trim();
    		var valueWay = $("#valueWay").val().trim();
    		
    		$("#pagination-ul").runnerPagination({
	 			url: _base+"/attr/getAttrList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchAttrData",
	 			messageId:"showMessageDiv",
	 			
	 			data: {"attrId":attrId,"attrName":attrName,"valueWay":valueWay},
	 			
	           	pageSize: attrlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchAttrTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchAttrData").html(htmlOutput);
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
    
    module.exports = attrlistPager
});

