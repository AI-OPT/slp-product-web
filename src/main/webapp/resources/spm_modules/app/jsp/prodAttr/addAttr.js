define('app/jsp/prodAttr/addAttr', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
	Validator = require("arale-validator/0.10.2/index"),
    Dialog = require("optDialog/src/dialog"),
    Paging = require('paging/0.0.1/paging'),
    AjaxController = require('opt-ajax/1.0.0/index');
require("jsviews/jsrender.min");
require("jsviews/jsviews.min");
require("bootstrap-paginator/bootstrap-paginator.min");
require("app/util/jsviews-ext");

require("arale-validator/0.10.2/alice.components.ui-button-orange-1.3-full.css");
require("arale-validator/0.10.2/alice.components.ui-form-1.0-src.css");

    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
  //表单校验对象
	var validator = new Validator({
		element: $(".form-label")
	});
	validator.addItem({
		element: "input[name=attrName]",
		required: true,
		errormessageRequired:"属性名称不能为空"
	}).addItem({
		element: "input[name=firstLetter]",
		required: true,
		pattern: "[A-Z]{1}",
		errormessagePattern:'请输入大写字母'
	}).addItem({
		element: "select",
		required: true,
		errormessageRequired:'请选择属性值输入方式'
	});
    //定义页面组件类
    var attrAddPager = Widget.extend({
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
    		//保存
    		"click #addAttrBtn":"_addAttrBtn",
            "click #submitAddBtn":"_saveAttr",
            },
    	//重写父类
    	setup: function () {
    		attrAddPager.superclass.setup.call(this);
    	},
    	//增加类目
    	_addAttrBtn:function(){
			attrNum['num']=attrNum['num']+1;
			var template = $.templates("#attrAddTemplate");
			var htmlOutput = template.render(attrNum);
			$("#subDiv").before(htmlOutput);
		},
		
		//提交
		_saveAttr:function(){
			validator.execute(function(error, results, element) {
			//获取from-label下的数据
			var attrArr = [];
			$("#addViewDiv > .form-label ").each(function(index,form){
				var attrObj = {};
				console.log(index+" form-label");
				//属性名称
				var attrName = $(this).find("input[name='attrName']")[0];
				attrObj['attrName'] = attrName.value;
				//首字母
				var firstLetter = $(this).find("input[name='firstLetter']")[0];
				attrObj['firstLetter'] = firstLetter.value;
				//输入方式
				var valueWay = $(this).find("select")[0];
				attrObj['valueWay'] = valueWay.value;
				attrArr.push(attrObj);
			});
		
		console.log("attr arr lengeth "+attrArr.length);
		ajaxController.ajax({
			type: "post",
			processing: true,
			message: "保存中，请等待...",
			url: _base+"/attr/saveAttr",
			data:{'attrListStr':JSON.stringify(attrArr)},
			success: function(data){
				if("1"===data.statusCode){
					//alert("保存成功");
					//保存成功,回退到进入的列表页
					window.history.go(-1)
				}
			}
		});
	});	
    }
    });
    
    module.exports = attrAddPager
});

