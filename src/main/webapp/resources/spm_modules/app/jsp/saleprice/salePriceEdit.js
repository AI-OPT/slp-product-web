define('app/jsp/saleprice/salePriceEdit', function (require, exports, module) {
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

    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    //优先级重复添加控制
    var priorityString = "";
    //定义页面组件类
    var salePriceEditPage = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
			PRICE_REGEX:/^(([1-9]{1}\d*)|([0]{1}))(\.(\d){1,2})?$/
    	},
    	//事件代理
    	events: {
            "click #goBack":"_goBack",
			"click #submitAddBtn":"_upNoSkuPrice",
			"click #saveInfo":"_saveSkuPrice"
        },
    	//重写父类
    	setup: function () {
			salePriceEditPage.superclass.setup.call(this);
    	},
		//更新没有SKU的销售价
		_upNoSkuPrice:function(){
			var _this = this;
			var priceArry = [];
			var hasError = false;
			//查询所有的价格信息
			$("input:text[name='salePrice']").each(function(index,item){
				var price = $(item).val();
				if (window.console) {
					console.log("price=" + price);
				}
				if (price == null || typeof (price) == undefined || price.trim() == "" ){
					hasError = true;
					_this._showMsg("有部分价格为填写,无法提交");
					return false;
				}
				if (!salePriceEditPage.PRICE_REGEX.test(price)){
					hasError = true;
					_this._showMsg("请输入正确格式的价格,\n 如:123,12.3,1.23");
					return false;
				}
				var salePrice = {};
				salePrice['groupId']=$(item).attr('groupId');
				salePrice['PriorityNumber']=$(item).attr('stoSn');
				salePrice['salePrice']=Number(price)*1000;
				priceArry.push(salePrice);
			});
			if (hasError==true){
				request;
			}
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "更新数据中，请等待...",
				url: _base+"/saleprice/edit/nosku/",
				data:{"salePriceStr":JSON.stringify(priceArry)},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						Dialog({
							title: '提示',
							icon:'success',
							content:"更新完成",
							okValue: '确 定',
							ok:function(){
								this.close();
								window.location.reload();//刷新当前页面.
							}
						}).show();
					}
				}
			});
		},
		//显示设置价格
		_showSkuPriceView:function(groupId,pNum){
			$("#upGroupId").val(groupId);
			$("#upGroupPn").val(pNum);
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "获取数据中，请等待...",
				url: _base+"/saleprice/query/sku/"+groupId,
				data:{"groupPn":pNum},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						//属性标题信息
						var attrValTr = "";
						var attrVal = data.data.attrInfoList;
						$.each( attrVal, function(index,item){
							attrValTr = attrValTr+"<th>"+item.attrName+"</th>";
						});
						attrValTr = attrValTr+"<th>销售价(元)</th>";
						$("#attrValTr").html(attrValTr);
						//SKU信息
						var template = $.templates("#skuInfoTemp");
	            	    var htmlOutput = template.render(data.data.skuInfoList);
	            	    $("#skuInfo").html(htmlOutput);
						//是否显示"取消"按钮
						if(data.data.upPrice)
							$("#edit-close").show();
						else
							$("#edit-close").hide();
						$('#eject-mask').fadeIn(100);
						$('#edit-medium').slideDown(200);
					}
				}
			});
		},
		//关闭添加库存弹出框
		_closeSkuPriceView:function(){
			$("#upGroupId").val("");
			$("#upGroupPn").val("");
			$('#eject-mask').fadeOut(100);
			$('#edit-medium').slideUp(150);
		},
		//保存SKU的销售价信息
		_saveSkuPrice:function(){
			var _this = this;
			var groupId = $("#upGroupId").val();
			var pNum = $("#upGroupPn").val();
			var skuPriceMap = {};
			var hasError = false;
			var priceNum = 0;
			$("input:text[name='skuNum']").each(function(index,item){
				var skuId = $(item).attr("skuId");
				var price = $(item).val();
				if (window.console) {
					console.log("skuId:" + skuId + ",price=" + price);
				}
				if (price == null || typeof (price) == undefined || price.trim() == ""){
					hasError = true;
					_this._showMsg("有部分价格为填写,无法提交");
					return false;
				}
				if (!salePriceEditPage.PRICE_REGEX.test(price)){
					hasError = true;
					_this._showMsg("请输入正确格式的价格,\n 如:123,12.3,1.23");
					return false;
				}
				//只在有输入值时才进行赋值
				skuPriceMap[skuId] = Number(price)*1000;
				priceNum++;
			});

			if(hasError)
				return;
			//没有需要保存的价格,则直接
			if(priceNum < 1){
				_this._closeSkuPriceView();
				return;
			}
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "更新数据中，请等待...",
				url: _base+"/saleprice/edit/sku/"+groupId,
				data:{"groupPn":pNum,"skuPriceStr":JSON.stringify(skuPriceMap)},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						_this._closeSkuPriceView();
						_this._showSuccessMsg("更新成功");
					}
				}
			});
		},
    	//判断字符串的长度-中文2个,英文1个
    	_getLen:function(str) {  
    	    if (str == null) return 0;  
    	    if (typeof str != "string"){  
    	        str += "";  
    	    }  
    	    return str.replace(/[^\x00-\xff]/g,"01").length;  
    	},
		//判断是否是正整数
		_isNum : function(str){
			if(/^\d+$/.test(str)){
				return true;
			}
			return false;
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
    	_showSuccessMsg:function(msg){
			var msg = Dialog({
				title: '提示',
				icon:'success',
				content:msg,
				okValue: '确 定',
				ok:function(){
					this.close();
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
    
    module.exports = salePriceEditPage
});

