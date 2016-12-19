define('app/jsp/prodAttr/addAttr', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("optDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
require("jsviews/jsrender.min");
require("jsviews/jsviews.min");
require("bootstrap-paginator/bootstrap-paginator.min");
require("app/util/jsviews-ext");

require("jquery-validation/1.15.1/jquery.validate");
require("app/util/aiopt-validate-ext");

    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
   /* Validator.addRule('upperCaseRule', /^[A-Z]{1}$/, '请输入大写字母');*/
    
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
            "click #submitAddAttrBtn":"_saveAttr",
            },
    	//重写父类
    	setup: function () {
    		attrAddPager.superclass.setup.call(this);
    	},
    	
    	//添加输入验证
/*    	_addValidator:function(validator){
    		validator.addItem({
    			element: "input[name=attrName]",
    			required: true,
    			errormessageRequired:"属性名称不能为空"
    		}).addItem({
    			element: "input[name=firstLetter]",
    			required: true,
    			rule:'upperCaseRule',
    			errormessage:'请输入名称首字母(大写)',
    		});
    	},*/
    	
    	//增加
    	_addAttrBtn:function(){
			attrNum['num']=attrNum['num']+1;
			var template = $.templates("#attrAddTemplate");
			var htmlOutput = template.render(attrNum);
			$("#subDiv").before(htmlOutput);
		},
		
		//提交
		_saveAttr:function(){
			var _this= this;
			//获取from-label下的数据
			var attrArr = [];
			var hasError = false;
			var validateForm = $("#prodAttrForm").validate();
			if(!validateForm.form()){
				return;
			}
			
			$("#addViewDiv > .form-label.bd-bottom ").each(function(index,form){
				
				/*var validator = new Validator({
					element: $(form)
				});
				_this._addValidator(validator);
				validator.execute(function(error, results, element) {
					if (error){
						hasError = true;
					}
				});*/
				
				var attrObj = {};
				if (window.console) {
					console.log(index + " form-label");
				}
				//属性名称
				var attrName = $(this).find("input[val-tag='attrName']")[0];
				attrObj['attrName'] = attrName.value;
				//首字母
				var firstLetter = $(this).find("input[val-tag='firstLetter']")[0];
				attrObj['firstLetter'] = firstLetter.value;
				//输入值方式
				var valueWay = $(this).find("select[id='test']")[0];
				attrObj['valueWay'] = valueWay.value;
				attrArr.push(attrObj);
			});
		
			/*console.log("No error");
			if (hasError)
				return;*/
			if (window.console) {
				console.log("No error");
			}
			if (window.console) {
				console.log("attr arr lengeth " + attrArr.length);
			}
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
					//window.history.go(-1)
					_this._showSuccessMsg("保存成功");
				}else {
					_this._showMsg("有部分内容未填写,无法提交");
				}
			}
		});
    },
    _showSuccessMsg:function(msg){
		var _this=this;
		var msg = Dialog({
			title: '提示',
			icon:'success',
			content:msg,
			okValue: '确 定',
			ok:function(){
				//this.close();
				window.history.go(-1);
			}
		});
		msg.showModal();
	},
	_showMsg:function(msg){
		var msg = Dialog({
			title: '提示',
			icon:'fail',
			content:msg,
			okValue: '确 定',
			ok:function(){
				this.close();
			}
		});
		msg.showModal();
	}
	
    });
    
    module.exports = attrAddPager
});

