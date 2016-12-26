define('app/jsp/prodcat/catlist', function (require, exports, module) {
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
			"click #selectList":"_selectPageList",
			"click #aband-close":"_closeDelConf",
			"click #delCloseImg":"_closeDelConf",
			"click #delCatBtn":"_delCat"
            },
    	//重写父类
    	setup: function () {
			catListPager.superclass.setup.call(this);
			this._selectPageList();
    	},
		//初始化表单验证
    	_initValidator:function(){
			return $("#upCatForm").validate({
				rules:{
					productCatName:{
						required: true,
						maxlength: 10
					},
					firstLetter:{
						required: true,
						maxlength:1,
						regexp:/^[A-Z]{1}$/
					},
					upSerialNum:{
						required:true,
						digits:true,
						min:1,
						max:999
					}
				},
				messages:{
					productCatName:{
						required:"类目名称不能为空",
						maxlength:"类目名称不能超过10位"
					},
					firstLetter:{
						required:"名称首字母不能为空",
						maxlength:"必须为大写名称首字母",
						regexp:"必须为大写字母"
					},
					upSerialNum:{
						required:"排序不能为空",
						digits:"必须为1至999的整数",
						min:"必须为1至999的整数",
						max:"必须为1至999的整数"
					}
				}
			});

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
	 			data:{"productCatId":catId,"parentProductCatId":parentCatId,
						"productCatName":catName,"isChild":isChile},
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
		//显示类目编辑页面
		_showCat:function(catId){
			var _this = this;
//			var innerHtml=$("#editDialogDiv").html();
			var innerHtml = "<div class='form-label ml-50'>"
//			var innerHtml = "<div class='form-label'>"
            +"<form id='upCatForm'>"
            +"<input type='hidden' name='productCatId' id='upCatId'>"
            +"<input type='hidden' name='parentProductCatId' id='parentCatId'>"
            +"<ul>"
            +"    <li>"
            +"        <p class='word'><span>*</span>类目名称:</p>"
            +"        <p><input id='upCatName' type='text' class='int-text int-small'"
            +"                  commonText='/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/' onblur=\""+"this.value=this.value.replace(/^\\s+|\\s+$/g,'')\""+" name='prductCatName' maxlength='10'></p>"
            +"    </li>"
            +"</ul>"
            +"<ul>"
            +"    <li>"
            +"        <p class='word'><span>*</span>名称首字母(大写):</p>"
            +"        <p><input id='upFletter' type='text' class='int-text int-small'"
            +"                  name='firstLetter' maxlength='1'></p>"
            +"    </li>"
            +"</ul>"
            +"<ul>"
            +"   <li>"
            +"        <p class='word'><span>*</span>排序:</p>"
            +"        <p><input id='upSerialNum' type='text' class='int-text int-small'"
            +"                  name='upSerialNum' maxlength='3'></p>"
            +"    </li>"
            +"</ul>"
            +"<ul>"
            +"    <li>"
            +"        <input type='hidden' id='upIsChile' name='upIsChile'>"
            +"        <p class='word'>是否存在子分类:</p>"
            +"        <p id='isChildVal'></p>"
            +"    </li>"
            +"</ul>"
            +"</form>"
            +"</div>";
			var d = Dialog({
				title:"更新类目",
				width:"550px",
				innerHtml:innerHtml,
				okValue: '确 定',
				ok: function () {
					//upValidator = _this._initValidator();
					//验证不通过,则不处理
					if (upValidator.form()){
						_this._updateCat();
						this.close();
					}else{
						return false;
					}
				},
				cancelValue: '取消',
				cancel: function () {
					this.close();
				}
			});

			//后台获取数据,
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据获取中,请等待...",
				url: _base+"/cat/query/"+catId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						var catInfo = data.data;
						$("#upCatId").val(catInfo.productCatId);//类目标识
						$("#parentCatId").val(catInfo.parentProductCatId);//父类目
						$("#upCatName").val(catInfo.productCatName);//类目名称
						$("#upFletter").val(catInfo.firstLetter);//首字母
						$("#upSerialNum").val(catInfo.serialNumber);//序列号
						//是否有子目录
						$("#upIsChile").val(catInfo.isChild);
						if ( catInfo.isChild == "Y")
							$("#isChildVal").html("是");
						else
							$("#isChildVal").html("否");
						d.show();
					}
				}
			});
			upValidator = this._initValidator();
			$("#upCatForm input").bind("focusout",function(){
				upValidator.element(this);
			});
		},
		//删除确认提示框
		_showDelConf:function(catId){
			var _this=this;
			var d = Dialog({
				title:"提示",
				content: '确定删除该类目吗？',
				icon:'help',
				okValue: '确 定',
				ok: function () {
					var isOk =_this._delCat(catId);
					if(isOk){
						this.close();
					}
				},
				cancelValue: '取消',
				cancel: function () {
					this.close();
				}
			});
			d.show();
		},
		//提交更新
		_updateCat:function(){
			var _this = this;
			var catId = $("#upCatId").val();//类目标识
			var parentId = $("#parentCatId").val();//父类目
			var catName = $("#upCatName").val();//类目名称
			var fLetter = $("#upFletter").val();//首字母
			var sn = $("#upSerialNum").val();//序列号
			var isChild = $("#upIsChile").val();
			
			if (catName == null || typeof (catName) == undefined || catName.trim() == ""
				|| fLetter == null || typeof (fLetter) == undefined || fLetter.trim() == ""
					|| sn == null || typeof (sn) == undefined || sn.trim() == "") {
				_this._showMsg("未输入正确格式信息,无法提交");
				return false;
			}
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				url: _base+"/cat/edit/update",
				data:{"productCatId":catId,"productCatName":catName,"parentProductCatId":parentId,
					"isChild":isChild,"firstLetter":fLetter,"serialNumber":sn},
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//刷新当前数据
						_this._selectPageList();
					}
				}
			});
		},
		//删除类目
		_delCat:function(catId){
			var _this = this;
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据删除中,请等待...",
				url: _base+"/cat/edit/del/"+catId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//刷新当前数据
						_this._selectPageList();
					}
				}
			});
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
    
    module.exports = catListPager
});

