define('app/jsp/normproduct/editinfo', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	Events = require('arale-events/1.2.0/events'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("optDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
	require("ckeditor/ckeditor.js")
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("app/util/jsviews-ext");
    
    require("jquery-validation/1.15.1/jquery.validate");
	require("app/util/aiopt-validate-ext");
    

    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();

    //定义页面组件类
    var prodEditPager = Widget.extend({
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	//事件代理
    	events: {
			//保存数据
			"click #saveNormProd":"_saveNormProd",
        },
        //重写父类
    	setup: function () {
    		prodEditPager.superclass.setup.call(this);
    	},
    	//保存商品信息
      	_saveNormProd:function(){
			var _this = this;
			var formValidator=$("#nromProdForm").validate({
				errorPlacement: function(error, element) {
					if (element.is(":checkbox")){
						$("#error_" + element.attr( "name" )+"_title").append( error );
					}
				    else{
				    	$("#error_" + element.attr( "name" )).append( error );
				    } 
				}
			});
			$.extend($.validator.messages, {  
			    required: '该项为必填项'
			});  
			if(!formValidator.form()){
				return;
			}
			//验证通过,则进行保存操作.this._checkInput() &&
			if(this._convertKeyAttr() && this._convertSaleAttr()){
				ajaxController.ajax({
					type: "post",
					processing: true,
					message: "保存中，请等待...",
					url: _base+"/normprodedit/save",
					data:$('#nromProdForm').serializeArray(),
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
									window.location.href = _base+'/normprodquery/list';
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
		},
		//将关键属性转换json字符串
		_convertKeyAttr:function(){
			var attrValArray = [];
			//获取所有
			$("#keyAttrDiv .word3").each(function(i){
				var attrId = $(this).attr('attrId');
				var valWay = $(this).attr('valueType');
				switch (valWay){
					case '1'://下拉
						var obj = $("#keyAttrDiv select[attrId='keyAttr"+attrId+"']")[0];
						var val = obj.value;
						attrValArray.push({'attrId':attrId,'attrValId':val,'attrVal':'','attrVal2':''});
						break;
					case '2'://多选
						$("#keyAttrDiv input:checkbox[attrId='keyAttr"+attrId+"']:checked").each(function(i){
							attrValArray.push({'attrId':attrId,'attrValId':$(this).val(),'attrVal':'','attrVal2':''});
						});
						break;
					case '3'://单行输入
						var val = $("#keyAttrDiv input[attrId='keyAttr"+attrId+"'")[0].value;
						attrValArray.push({'attrId':attrId,'attrValId':'','attrVal':val,'attrVal2':''});
						break;
					case '4'://多行输入
						var val = $("#keyAttrDiv textarea[attrId='keyAttr"+attrId+"'")[0].value;
						attrValArray.push({'attrId':attrId,'attrValId':'','attrVal':val,'attrVal2':''});
						break;

				};
			});
			var keyJsonStr = JSON.stringify(attrValArray,null);
			if (window.console){
				console.log($('#keyAttrStr').val());
			}
			$('#keyAttrStr').val(keyJsonStr);
			return true;
		},
		//将销售属性转换json字符串
		_convertSaleAttr:function(){
			var attrValArray = [];
			//获取所有
			$("#saleAttrDiv .word3").each(function(i){
				var attrId = $(this).attr('attrId');
				var valWay = $(this).attr('valueType');
				switch (valWay){
				case '1'://下拉
					var obj = $("#saleAttrDiv select[attrId='saleAttr"+attrId+"']")[0];
					var val = obj.value;
					attrValArray.push({'attrId':attrId,'attrValId':val,'attrVal':'','attrVal2':''});
					break;
				case '2'://多选
					$("#saleAttrDiv input:checkbox[attrId='saleAttr"+attrId+"']:checked").each(function(i){
						attrValArray.push({'attrId':attrId,'attrValId':$(this).val(),'attrVal':'','attrVal2':''});
					});
					break;
				case '3'://单行输入
					var val = $("#saleAttrDiv input[attrId='saleAttr"+attrId+"'")[0].value;
					attrValArray.push({'attrId':attrId,'attrValId':'','attrVal':val,'attrVal2':''});
					break;
				case '4'://多行输入
					var val = $("#saleAttrDiv textarea[attrId='saleAttr"+attrId+"'")[0].value;
					attrValArray.push({'attrId':attrId,'attrValId':'','attrVal':val,'attrVal2':''});
					break;
					
				};
			});
			var saleJsonStr = JSON.stringify(attrValArray,null);
			if (window.console) {
				console.log($('#saleAttrStr').val());
			}
			$('#saleAttrStr').val(saleJsonStr);
			return true;
		}
    });
    module.exports = prodEditPager
});

