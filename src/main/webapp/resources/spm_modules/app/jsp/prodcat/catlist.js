define('app/jsp/prodcat/catlist', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
		Validator = require("arale-validator/0.10.2/index"),
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
	Validator.addRule('upperCaseRule', /^[A-Z]{1}$/, '请输入大写字母');
	var validator = new Validator({
		element: $(".form-label")[0]
	});
	validator.addItem({
		element: $('#upCatName'),
		required: true,
		errormessageRequired:"类目名称不能为空"
	}).addItem({
		element: $('#upFletter'),
		required: true,
		rule:'upperCaseRule',
		errormessage:'请输入名称首字母(大写)',
	}).addItem({
		element: $('#upSerialNum'),
		required: true,
		rule:'number min{min:1} max{max:10000}',
		errormessage:'请输入1至10000的数字',
	});
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
			"click #selectList":"_selectPageList",
			"click #increase-close":"_closeEditDiv",
			"click #upCloseImg":"_closeEditDiv",
			"click #upCatBtn":"_updateCat",//提交更新
			"click #aband-close":"_closeDelConf",
			"click #delCloseImg":"_closeDelConf",
			"click #delCatBtn":"_delCat"
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
						if ( catInfo.isChild == "Y")
							$("#upIsChildY").attr("checked",true);
						else
							$("#upIsChildN").attr("checked",true);
						$('#eject-mask').fadeIn(100);
						$('#increase-samll').slideDown(200);
					}
				}
			});

		},
		//删除确认提示框
		_showDelConf:function(catId){
			$('#eject-mask').fadeIn(100);
			$('#aband-small').slideDown(200);
			console.log("del cat id is "+ catId);
			$("#delCatId").val(catId);
		},
		//关闭编辑页面弹出
		_closeEditDiv:function(){
			$('#eject-mask').fadeOut(100);
			$('#increase-samll').slideUp(150);
			//清空数据
			$("#upCatId").val("");//类目标识
			$("#parentCatId").val("");//父类目
			$("#upCatName").val("");//类目名称
			$("#upFletter").val("");//首字母
			$("#upSerialNum").val("");//序列号
			//是否有子目录
			$("input[name=isChild][value=´Y´]").removeAttr("checked");
			$("input[name=isChild][value=´N´]").removeAttr("checked");
		},
		//关闭确认提示框
		_closeDelConf:function(){
			$('#eject-mask').fadeOut(100);
			$('#aband-small').slideUp(150);
			$("#delCatId").val('');
		},
		//提交更新
		_updateCat:function(){
			var hasError = false;
			var errMsg = "";
			validator.execute(function(error, results, element) {
				if (!error){
					return;
				}
				hasError = true;
				$.each(results,function(n,value){
					if (value[1]!=null && value[1]!=undefined){
						errMsg = value[1];
						return;
					}
				});
			});
			if (errMsg!= "")
				alert(errMsg);
			if (hasError)
				return;
			var _this = this;
			var catId = $("#upCatId").val();//类目标识
			var parentId = $("#parentCatId").val();//父类目
			var catName = $("#upCatName").val();//类目名称
			var fLetter = $("#upFletter").val();//首字母
			var sn = $("#upSerialNum").val();//序列号
			var isChild = $('input:radio[name=isChild]:checked').val();
			this._closeEditDiv();
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
						$("#pagination-ul .page .active").trigger("click");
					}
				}
			});
		},
		//删除类目
		_delCat:function(){
			var _this = this;
			var catId = $("#delCatId").val();//类目标识
			this._closeDelConf();
			ajaxController.ajax({
				type: "get",
				processing: true,
				message: "数据删除中,请等待...",
				url: _base+"/cat/edit/del/"+catId,
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//刷新当前数据
						$("#pagination-ul .page .active").trigger("click");
					}
				}
			});
		}
    });
    
    module.exports = catListPager
});

