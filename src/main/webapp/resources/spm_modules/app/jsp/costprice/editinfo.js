define('app/jsp/costprice/editinfo', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	Events = require('arale-events/1.2.0/events'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("optDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("app/util/jsviews-ext");
    
    require("opt-paging/aiopt.pagination");
    
    require("jquery-validation/1.15.1/jquery.validate");
	require("app/util/aiopt-validate-ext");
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();

    //定义页面组件类
    var prodEditPager = Widget.extend({
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 10
    	},
    	//事件代理
    	events: {
			//保存数据
			"click #saveBtn":"_saveCostPrice",
        },
        //重写父类
    	setup: function () {
    		prodEditPager.superclass.setup.call(this);
    		this._searchProdRouteList();
    	},
    	//查询库存列表
    	_searchProdRouteList:function(){
    		$("#pagination-ul").runnerPagination({
	 			url: _base+"/costprice/prodRouteList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchProdRouteData",
	 			messageId:"showMessageDiv",
	 			data: {"standedProdId":standedProdId},
	           	pageSize: prodEditPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	           	callback: function (data) {
	            	if(data && data.result && data.result.length>0){
	            		var template = $.templates("#searchProdRouteTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchProdRouteData").html(htmlOutput);
	            	}
	            }
    		});
    	},
    	//保存成本信息
    	_saveCostPrice:function(){
			var _this = this;
			var formValidator=$("#costpriceForm").validate({
				/*errorPlacement: function(error, element) {
					$("#" + element.attr( "name" )).append( error );
				}*/
			});
			$.extend($.validator.messages, {  
			    required: '该项为必填项'
			});
			if(!formValidator.form()){
				return;
			}
			var updateData = [];
			$("#searchProdRouteData input[for='costPrice']").each(function(i){
				var costPrice = $(this).val()?parseFloat($(this).val())*1000:null;
				var tenantId = $(this).attr('tenantId');
				var standedProdId = $(this).attr('standedProdId');
				var supplyId = $(this).attr('supplyId');
				var routeId = $(this).attr('routeId');
				var data = {"tenantId":tenantId,"costPrice":costPrice,"standedProdId":standedProdId,"supplyId":supplyId,"routeId":routeId};
				updateData.push(data);
			});
			//验证通过,则进行保存操作.this._checkInput() &&
				ajaxController.ajax({
					type: "post",
					processing: true,
					message: "保存中，请等待...",
					url: _base+"/costprice/save",
					data:{"costPriceList":JSON.stringify(updateData)},
					success: function(data){
						if("1"===data.statusCode){
							var d = Dialog({
								title:"提示",
								content:data.statusInfo,
								icon:'success',
								cancelValue: '确 定',
								cancel:function(){
									this.close();
									//保存成功,回退到进入的列表页
									window.location.href=_base+"/costprice/"+standedProdId;
								}
							});
							d.show();
						}else{
							var d = Dialog({
								title:"错误",
								content:data.statusInfo,
								icon:'fail',
								cancelValue: '确 定',
								cancel:function(){
									this.close();
								}
							});
							d.show();
						}
					}
				});
		}
		
    });
    module.exports = prodEditPager
});

