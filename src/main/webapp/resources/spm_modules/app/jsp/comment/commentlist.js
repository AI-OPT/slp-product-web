define('app/jsp/comment/commentlist', function (require, exports, module) {
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
    //定义页面组件类
    var commentListPage = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 10
    	},
    	//事件代理
    	events: {
    		//查询在售商品
            "click #selectCommentList":"_selectCommentList",
            },
    	//重写父类
    	setup: function () {
    		commentListPage.superclass.setup.call(this);
    		this._clearQueryParams();
    		this._selectCommentList();
    	},
    	//清空查询条件
    	_clearQueryParams:function(){
    		$("#shopScoreMs option:selected").val("");
    		$("#commentTimeBegin").val("");
    		$("#commentTimeEnd").val("");
    		$("#shopScoreWl option:selected").val("");
    		$("#shopScoreFw option:selected").val("");
    		$("#standedProdId").val("");
    		$("#orderId").val("");
    	},
    	//查询评论列表
    	_selectCommentList:function(){
    		var _this = this;
    		var shopScoreMsStr = $("#shopScoreMs option:selected").val();
    		var shopScoreMs = shopScoreMsStr?parseInt(shopScoreMsStr):null;
    		var commentTimeBegin = $("#commentTimeBegin").val();
    		var commentTimeEnd = $("#commentTimeEnd").val();
    		var shopScoreWlStr = $("#shopScoreWl option:selected").val();
    		var shopScoreWl = shopScoreWlStr?parseInt(shopScoreWlStr):null;
    		var shopScoreFwStr = $("#shopScoreFw option:selected").val();
    		var shopScoreFw = shopScoreFwStr?parseInt(shopScoreFwStr):null;
    		var standedProdId = $("#standedProdId").val()?$("#standedProdId").val().trim():"";
    		var orderId = $("#orderId").val()?$("#orderId").val().trim():"";
    		
    		$("#pagination-ul").runnerPagination({
    			
	 			url: _base+"/productcomment/getCommentList",
	 			
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchCommentData",
	 			messageId:"showMessageDiv",
	 			
	 			data: {
	 				"shopScoreMs":shopScoreMs,
	 				"commentTimeBeginStr":commentTimeBegin,
	 				"commentTimeEndStr":commentTimeEnd,
	 				"shopScoreWl":shopScoreWl,
	 				"shopScoreFw":shopScoreFw,
	 				"standedProdId":standedProdId,
	 				"orderId":orderId
		 		},
	 			
	           	pageSize: commentListPage.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchCommentTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchCommentData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	}
    	
    });
    
    module.exports = commentListPage;
});

