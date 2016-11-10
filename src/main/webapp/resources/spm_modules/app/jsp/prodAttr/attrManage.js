define('app/jsp/prodAttr/attrManage', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("optDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
    
require("jsviews/jsrender.min");
require("jsviews/jsviews.min");
require("my97DatePicker/WdatePicker");
require("bootstrap-paginator/bootstrap-paginator.min");
require("app/util/jsviews-ext");
require("opt-paging/aiopt.pagination");
require("jquery-validation/1.15.1/jquery.validate");
require("app/util/aiopt-validate-ext");
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    var upValidator;
    
  //表单校验对象
	/*var validator = new Validator({
		element: $(".form-label")
	});
	validator.addItem({
		element: "#upAttrValueName",
		required: true,
		errormessageRequired:"属性值名称不能为空"
	}).addItem({
		element: "#upFirstLetter",
		required: true,
		pattern: "[A-Z]{1}",
		errormessagePattern:'请输入大写字母'
	});*/
    
	
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
            "click #selectAttrValueList":"_selectAttrValueList",
            "click #increase-close":"_closeEditDiv",
            "click #upCloseImg":"_closeEditDiv",
            "click #upAttrValueBtn":"_updateAttr",
//           "click #delAttrValueBtn":"_delAttr",
//            "click #aband-close":"_closeDelConf",
//            "click #delCloseImg":"_closeDelConf",
            /*"click #addAttrValueButton":"_addAttrValueButton",*/
            /*"click #addAttrValue-close":"_closeAddAttrValueDiv",*/
            /*"click #createCloseImg":"_closeAddAttrValueDiv",*/
            /*"click #submitAddBtn":"_saveAttrValue"*/
            },
    	//重写父类
    	setup: function () {
    		attrlistPager.superclass.setup.call(this);
    		this._selectAttrValueList();
    		upValidator = this._initValidator();
			$(":input").bind("focusout",function(){
				upValidator.element(this);
			});
    	},
    	//初始化表单验证
    	_initValidator:function(){
			return $("#prodAttrValueForm").validate({
				rules:{
					productAttrValueName:{
						required: true,
						maxlength: 20
					},
					firstLetter:{
						required: true,
						maxlength:1,
						regexp:/^[A-Z]+$/
					}
				},
				messages:{
					productAttrValueName:{
						required:"名称不能为空",
						maxlength:"名称不能超过20位(一个汉字占2位)"
					},
					firstLetter:{
						required:"名称首字母不能为空",
						maxlength:"必须为大写名称首字母",
						regexp:"必须为大写字母"
					}
				}
			});

		},
    	
    	//查询列表
    	_selectAttrValueList:function(){
    		var _this = this;
    		var attrId = $("#attrId").val().trim();
    		var attrvalueDefId = $("#attrvalueDefId").val().trim();
    		var attrValueName = $("#attrValueName").val().trim();
    		
    		$("#pagination-ul").runnerPagination({
	 			url: _base+"/attrManage/getAttrValueList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchAttrData",
	 			messageId:"showMessageDiv",
	 			
	 			data: {"attrId":attrId,"attrvalueDefId":attrvalueDefId,"attrValueName":attrValueName},
	 			
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
    	
    	//弹出编辑框
    	_showAttr:function(attrvalueDefId){
			//后台获取数据,
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据获取中,请等待...",
				url: _base+"/attrManage/"+attrvalueDefId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						var attrValueInfo = data.data;
						$("#upAttrValueName").val(attrValueInfo.attrValueName);
						$("#upFirstLetter").val(attrValueInfo.firstLetter);
						$("#upAttrvalueDefId").val(attrvalueDefId);
						$("#upAttrId").val(attrValueInfo.attrId);
						
						$('#eject-mask').fadeIn(100);
						$('#increase-samll').slideDown(200);
					}
				}
			});

		},
		//关闭编辑页面弹出
		_closeEditDiv:function(){
			$('#eject-mask').fadeOut(100);
			$('#increase-samll').slideUp(150);
			//清空数据
			$("#upAttrvalueDefId").val("");
			$("#upAttrValueName").val("");
			$("#upFirstLetter").val("");
			$("#upAttrId").val("");
		},
		//提交更新
		_updateAttr:function(){
			upValidator.form();
			if ($("#prodAttrValueForm").valid()!=true)
				return false;
			var _this = this;
//			validator.execute();
			var attrvalueDefId = $("#upAttrvalueDefId").val();
			var attrValueName = $("#upAttrValueName").val();
			var firstLetter = $("#upFirstLetter").val();
			var attrId = $("#upAttrId").val();
			this._closeEditDiv();
			if (attrValueName == null || typeof (attrValueName) == undefined || attrValueName.trim() == ""
				|| firstLetter == null || typeof (firstLetter) == undefined || firstLetter.trim() == "") {
				_this._showMsg("未输入正确格式信息,无法提交");
				return false;
			}
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				
				url: _base+"/attrManage/updateAttrValue",
				
				data:{"attrId":attrId,"attrvalueDefId":attrvalueDefId,"attrValueName":attrValueName,"firstLetter":firstLetter},
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//刷新当前数据
						//$("#pagination-ul .page .active").trigger("click");
						window.location.reload();
					}
				}
			});
		},
		
		//删除确认提示框
		_showDelConf:function(attrvalueDefId){

			var _this = this;
    		new Dialog({
				content:'确定删除该属性值吗？',
				icon:'help',
				okValue: '确 定',
				title:'提示',
				ok:function(){
					this.close();
					_this._delAttrValue(attrvalueDefId);
				},
				cancelValue: '取消',
				cancel: function () {
					this.close();
				}
			}).show();
		
		},
		
		
/*		_showDelConf:function(attrvalueDefId){
			
			//后台获取数据,
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据获取中,请等待...",
				url: _base+"/attrManage/"+attrvalueDefId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						var attrValueInfo = data.data;
						$("#delAttrvalueDefId").val(attrvalueDefId);
						$("#delAttrId").val(attrValueInfo.attrId);
						
						$('#eject-mask').fadeIn(100);
						$('#aband-small').slideDown(200);
					}
				}
			});
			
			$('#eject-mask').fadeIn(100);
			$('#aband-small').slideDown(200);
			console.log("del attrvalue id is "+ attrvalueDefId);
			$("#delAttrValueId").val(attrvalueDefId);
		},*/
		
		//删除
		_delAttrValue:function(attrvalueDefId){
			var _this = this;
			var attrId = $("#attrId").val();
			
			this._closeDelConf();
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据删除中,请等待...",
				url: _base+"/attrManage/delAttrValue/"+attrvalueDefId,
				data:{"attrId":attrId,"attrvalueDefId":attrvalueDefId},
				
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//刷新当前数据
						//$("#pagination-ul .page .active").trigger("click");
						window.location.reload();
					}
				}
			});
		},
		//关闭确认提示框
		_closeDelConf:function(){
			$('#eject-mask').fadeOut(100);
			$('#aband-small').slideUp(150);
			$("#delAttrValueId").val('');
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
		/*//新增属性值的弹框
		_showAddAttr:function(){
			$('#eject-mask').fadeIn(100);
			$('#addAttrValue-samll').slideDown(200);
		},*/
		
		/*//增加属性值输入框
    	_addAttrValueButton:function(){
			attrNum['num']=attrNum['num']+1;
			var template = $.templates("#attrAddTemplate");
			var htmlOutput = template.render(attrNum);
			$("#subDiv").before(htmlOutput);
		},*/
	/*	//关闭属性值添加的弹框
		_closeAddAttrValueDiv:function(){
			$('#eject-mask').fadeOut(100);
			$('#addAttrValue-samll').slideUp(150);
			//清空数据
				$("#firstLetter").val("");
				$("#upAttrValueName").val("");
			
		},*/
		
/*		//提交
		_saveAttrValue:function(){
			validator.execute(function(error, results, element) {
			//获取from-label下的数据
			var attrValueArr = [];
			$("#addAttrValue-samll > .form-label ").each(function(index,form){
				var attrObj = {};
				console.log(index+" form-label");
				//属性值名称
				var attrValueName = $(this).find("input[name='attrValueName']")[0];
				attrObj['attrValueName'] = attrValueName.value;
				//首字母
				var firstLetter = $(this).find("input[name='firstLetter']")[0];
				attrObj['firstLetter'] = firstLetter.value;
				//属性ID
				var attrId = $(this).find("input[name='attrId']")[0];
				attrObj['attrId'] = attrId.value;
				attrValueArr.push(attrObj);
			});
		
		console.log("attr value arr lengeth "+attrValueArr.length);
		ajaxController.ajax({
			type: "post",
			processing: true,
			message: "保存中，请等待...",
			url: _base+"/attrManage/saveAttrValue",
			data:{'attrValueListStr':JSON.stringify(attrValueArr)},
			success: function(data){
				if("1"===data.statusCode){
					//alert("保存成功");
					//保存成功,回退到进入的列表页
					//window.history.go(-1)
					$("#pagination-ul .page .active").trigger("click");
				}
			}
		});
	});	
    }*/
    	
    });
    
    module.exports = attrlistPager
});

