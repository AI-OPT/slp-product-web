define('app/jsp/prodcat/catadd', function (require, exports, module) {
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

    var SendMessageUtil = require("app/util/sendMessage");

    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    //定义页面组件类
    var catAddPager = Widget.extend({
    	
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
			"click #addCatBtn":"_addCatTemp"
            },
    	//重写父类
    	setup: function () {
			catAddPager.superclass.setup.call(this);
    	},
		//增加类目
		_addCatTemp:function(){
			var template = $.templates("#catAddTemplate");
			var htmlOutput = template.render();
			$("#subDiv").before(htmlOutput);
		},

    });
    
    module.exports = catAddPager
});

