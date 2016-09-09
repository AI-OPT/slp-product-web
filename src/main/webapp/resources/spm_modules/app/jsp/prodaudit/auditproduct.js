define('app/jsp/prodaudit/auditproduct', function (require, exports, module) {
	    'use strict';
	    var $=require('jquery'),
		    Widget = require('arale-widget/1.2.0/widget'),
		    Dialog = require("optDialog/src/dialog"),
		    Paging = require('paging/0.0.1/paging-debug'),
		    AjaxController = require('opt-ajax/1.0.0/index');
	    require("jsviews/jsrender.min");
	    require("jsviews/jsviews.min");
	    require("bootstrap-paginator/bootstrap-paginator.min");
	    require("app/util/jsviews-ext");
	    require("opt-paging/aiopt.pagination");
	    require("twbs-pagination/jquery.twbsPagination.min");
	   
	    
	    var SendMessageUtil = require("app/util/sendMessage");
	    
	    //实例化AJAX控制处理对象
	    var ajaxController = new AjaxController();
	    var clickId = "";
	    //定义页面组件类
	    var auditproductPager = Widget.extend({
	    	
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
	    		"click #auditBtn-close":"_closeAudit",
	            "click #auditCloseImg":"_closeAudit",
	            "click #refuseBtn-close":"_closeRefuse",
	            "click #refuseCloseImg":"_closeRefuse",
	    		"click #submitBtn":"_auditProduct",//审核商品
	    		"click #refuseBtn":"_auditRefuse",//审核拒绝商品
	            "click #auditMoreBtn":"_showAuditMore",
	            "click #refuseMoreBtn":"_showRefuseMore"
	            },
	    	//重写父类
	    	setup: function () {
	    		auditproductPager.superclass.setup.call(this);
	    	},
	    	
	    	//滚动到顶部
	    	_returnTop:function(){
	    		var container = $('.wrapper-right');
	    		container.scrollTop(0);//滚动到div 顶部
	    	},
	    	 //审核通过
	         _showAuditMore:function(){
				$('#eject-mask').fadeIn(100);
				$('#audit-small').slideDown(200);
			},
			//确认提示框
			_closeAudit:function(){
				$('#eject-mask').fadeOut(100);
				$('#audit-small').slideUp(150);
			},
			//点击确认通过审核
			_auditProduct:function(){
			var _this = this;
			var prodIdList = new Array();
			var prodId = $("#prodId").val();
			prodIdList.push(prodId);
			//prodIdList[0]=prodId;
			this._closeAudit();
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				url: _base+"/prodOperate/auditPass",
				data:{"id":prodId},
				success: function(data){
					//获取数据成功
					if("1"===data.statusCode){
						//返回列表
						window.history.go(-1)
					}
				}
			});
			},
			//点击确认审核拒绝
			_auditRefuse:function(){
				var _this = this;
				var prodIdList = new Array();
				var prodId = $("#prodId").val();
				var refuseReason = $("#refuseReason").val();
				var refuseDes = $("#refuseDes").val();
				prodIdList.push(prodId);
				//prodIdList[0]=prodId;
				this._closeAudit();
				ajaxController.ajax({
					type: "post",
					processing: true,
					message: "数据更新中,请等待...",
					url: _base+"/prodOperate/auditReject",
					data:{"prodIdList":prodId,"refuseReason":refuseReason,"refuseDes":refuseDes},
					success: function(data){
						//获取数据成功
						if("1"===data.statusCode){
							//返回列表
							window.history.go(-1)
						}
					}
				});
			},
			
			
			//审核拒绝
			_showRefuseMore:function(){
				$('#eject-mask').fadeIn(100);
				$('#refuse-small').slideDown(200);
			},
				
			//确认提示框
			_closeRefuse:function(){
				$('#eject-mask').fadeOut(100);
				$('#refuse-small').slideUp(150);
			}
	    	
	    });
	    
	    module.exports = auditproductPager;
	});