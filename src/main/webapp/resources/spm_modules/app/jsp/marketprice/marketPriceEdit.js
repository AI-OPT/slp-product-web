define('app/jsp/marketprice/marketPriceEdit', function (require, exports, module) {
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
    		//保存
    		"click #submitSaveBtn":"_saveMarketPrice",
    		"click #successBtn":"_goBack",
        },
    	//重写父类
    	setup: function () {
    		addMarketPricePager.superclass.setup.call(this);
    	},
    	
    	//保存
    	_saveMarketPrice:function(){
    		var _this=this;
    		var productId = $("#productId").val();
    		var validateForm = $("#prodForm").validate({
				errorPlacement: function(error, element) {
	                $("#marketPriceValidate").append( error );
	             }
    		});
    		
			if(!validateForm.form()){
				return;
			}
			
    		var price=$("#marketPrice").val();
    		if (price=="0.00" && price=="0.0") {
    			var marketPrice = "0";
			}else if (price == null || typeof (price) == undefined || price.trim() == "") {
				_this._showMsg("有部分价格未填写,无法提交");
				return false;
			}
    		else {
				var marketPrice = price*1000;
			}
    		
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "数据更新中,请等待...",
				
				url: _base+"/marketpricequery/updateMarketPrice",
				
				data:{"productId":productId,"marketPrice":marketPrice},
				success: function(data){
					if("1"===data.statusCode){
						//window.location.reload();
						_this._showSuccessMsg("市场价更新成功");
						//window.history.go(-1)
					}else {
						_this._showFailMsg("输入正确市场价");
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
		_showFailMsg:function(msg){

    		var _this=this;
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
    
    module.exports = addMarketPricePager;
});
