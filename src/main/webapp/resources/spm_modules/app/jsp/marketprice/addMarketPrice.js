define('app/jsp/marketprice/addMarketPrice', function (require, exports, module) {
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
    		var price=$("#marketPrice").val();
    		if (price=="" && price==null && price=="0.00" && price=="0.0") {
    			var marketPrice = "0";
			}else {
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
    	
    });
    
    module.exports = addMarketPricePager;
});



















/*define('app/jsp/marketprice/addMarketPrice', function (require, exports, module) {
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
    require("arale-validator/0.10.2/alice.components.ui-button-orange-1.3-full.css");
    require("arale-validator/0.10.2/alice.components.ui-form-1.0-src.css");
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    Validator.addRule('upperCaseRule', /^(0|([1-9]\d{0,9}(\.\d{1,2})?))$/, '请输入正确的价格');
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
    	
    	//添加市场价校验  ^(0|[1-9][0-9]{0,9})(\.[0-9]{1,2})?$
    	_addValidator:function(validator){
    		validator.addItem({
    			element: "input[name=marketPrice]",
    			required: true,
    			rule:'upperCaseRule',
    			errormessage:'请输入正确的价格',
    		});
    	},
    	
    	
    	
    	//保存
    	_saveMarketPrice:function(){

    		var _this=this;
    		var hasError = false;
    		var price = 0;
    		$("#addViewDiv > .form-label.bd-bottom ").each(function(index,form){
				
				var validator = new Validator({
					element: $(form)
				});
				_this._addValidator(validator);
				validator.execute(function(error, results, element) {
					if (error){
						hasError = true;
					}
				});
				 price=$("#marketPrice").val();
				
			});
    		var productId = $("#productId").val();
    		
    		console.log("No error");
			if (hasError)
				return;
    		
    		if (price=="" || price==null || price=="0.00" || price=="0.0" || price=="0") {
    			var marketPrice = "0";
			}else {
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
		
    	//返回之前的页面
    	_goBack:function(){
    		window.history.go(-1);
    	},
    	
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	
    });
    
    module.exports = addMarketPricePager;
});
*/