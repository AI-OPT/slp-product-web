define('app/jsp/pricemanage/priceList', function (require, exports, module) {
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
    //优先级重复添加控制
    var priorityString = "";
    //定义页面组件类
    var addMarketPricePager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
    	},
    	//事件代理
    	events: {
    		//查询标准品
            "click #addStorGroup":"_addStorGroup",
			"click #add-close":"_closeUpGroupView",
            "click #goBack":"_goBack",
            "click #addStorage":"_addStorage",
        },
    	//重写父类
    	setup: function () {
    		addMarketPricePager.superclass.setup.call(this);
    	},
		//显示编辑库存组名称
		_showUpGroupView:function(obj){
			var groupId=obj.attr("groupId");
			$("upGroupId").val(groupId);
			var name = $(this).parent().next().text();
			name = name.substring(6);
			$("#upGroupName").val(name);
			$('#eject-mask').fadeIn(100);
			$('#add-samll').slideDown(200);
		},
		//显示添加库存
		_showAddStoView:function(groupId,pNum){
			$('#eject-mask').fadeIn(100);
			$('#edit-medium').slideDown(200);
		},
    	//添加库存组
    	_addStorGroup:function(){
    		var _this = this;
    		var storageGroupName = $("#storageGroupName").val();
    		var length = _this._getLen(storageGroupName);
    		if(length == 0 || length>30){
    			_this._showMsg("库存组名称不能为空且最大长度为15个字（30个字符）");
    			return;
    		}
    		$(".eject-big").hide();
    		$(".eject-samll").hide();
    		$(".eject-mask").hide();
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "添加中，请等待...",
				url: _base+"/storage/addGroup",
				data:{"standedProdId":standedProdId,"storageGroupName":storageGroupName},
				success: function(data){
					if("1"===data.statusCode){
//	            		var template = $.templates("#storGroupTemple");
//	            	    var htmlOutput = template.render(data.data);
//	            	    $("#storGroupMarked").before(htmlOutput);
						window.location.reload();
//						window.history.go(0);
					}else{
						_this._showMsg("添加库存组失败:"+data.statusInfo);
	            	}
				}
			});
    	},

    	//返回之前的页面
    	_goBack:function(){
    		window.history.go(-1);
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	_showMsg:function(msg){
			var msg = Dialog({
				title: '提示',
				icon:'prompt',
				content:msg,
				okValue: '确 定',
				ok:function(){
					this.close();
				}
			});
			msg.showModal();
		}
    	
    });
    
    module.exports = addMarketPricePager
});

