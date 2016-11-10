define('app/jsp/prodAttr/attrList', function (require, exports, module) {
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

//require("jquery-validation/1.15.1/jquery.validate");
require("app/util/aiopt-validate-ext");


    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    var upValidator;
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
            "click #selectAttrList":"_selectAttrList",
//            "click #upCloseImg":"_closeEditDiv",
            "click #increase-close":"_closeEditDiv",
            "click #upAttrBtn":"_updateAttr"
            },
    	//重写父类
    	setup: function () {
    		attrlistPager.superclass.setup.call(this);
    		this._selectAttrList();
    		upValidator = this._initValidator();
			$(":input").bind("focusout",function(){
				upValidator.element(this);
			});
    	},
    	//初始化表单验证
    	_initValidator:function(){
			return $("#prodAttrForm").validate({
				rules:{
					productAttrName:{
						required: true,
						maxlength: 15
					},
					firstLetter:{
						required: true,
						maxlength:1,
						regexp:/^[A-Z]+$/
					}
				},
				messages:{
					productAttrName:{
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
    	_selectAttrList:function(){
    		var _this = this;
    		
    		var attrId = $("#attrId").val().trim();
    		if (isNaN(attrId)) {
    			var d = Dialog({
					content:"请输入正确格式的属性ID.",
					icon:'prompt',
					okValue: '确 定',
					title:'提示',
					ok:function(){
						this.close();
					}
				});
				d.show();
				return;
			}
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
    	
    	//弹出编辑框
    	_showAttr:function(attrId){
			//后台获取数据,
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据获取中,请等待...",
				url: _base+"/attr/"+attrId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						var attrInfo = data.data;
						$("#upAttrId").val(attrInfo.attrId);
						$("#upAttrName").val(attrInfo.attrName);
						$("#upFirstLetter").val(attrInfo.firstLetter);
						$("#upValueWay").val(attrInfo.valueWay);
						
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
			//$("#upAttrId").val("");
			$("#upAttrName").val("");
			$("#upFirstLetter").val("");
			$("#upValueWay").val("");
			upValidator.resetForm();
		},
		//提交更新
		_updateAttr:function(){
			upValidator.form();
			if ($("#prodAttrForm").valid()!=true)
				return false;
			
			var _this = this;
			var attrId = $("#upAttrId").val();
			var attrName = $("#upAttrName").val();
			var firstLetter = $("#upFirstLetter").val();
			var valueWay = $("#upValueWay").val();
			this._closeEditDiv();
			if (attrName == null || typeof (attrName) == undefined || attrName.trim() == ""
				|| firstLetter == null || typeof (firstLetter) == undefined || firstLetter.trim() == "") {
				_this._showMsg("未输入正确格式信息,无法提交");
				return false;
			}
			/*var validateForm = $("#prodAttrForm").validate();
			if(!validateForm.form()){
				return;
			}*/
			
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				
				url: _base+"/attrEdit/updateAttr",
				
				data:{"attrId":attrId,"attrName":attrName,"firstLetter":firstLetter,"valueWay":valueWay},
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
		_showDelConf:function(attrId){
			var _this = this;
    		new Dialog({
				content:'确定删除该属性吗？',
				icon:'help',
				okValue: '确 定',
				title:'提示',
				ok:function(){
					this.close();
					_this._delAttr(attrId);
				},
				cancelValue: '取消',
				cancel: function () {
					this.close();
				}
			}).show();
		},
		//删除
		_delAttr:function(attrId){
			var _this = this;
			this._closeDelConf();
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据删除中,请等待...",
				url: _base+"/attrEdit/delAttr/"+attrId,
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
			$("#delAttrId").val('');
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
    
    module.exports = attrlistPager
});

