define('app/jsp/normproduct/editinfo', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	Events = require('arale-events/1.2.0/events'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("artDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
	require("ckeditor/ckeditor.js")
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
    var SendMessageUtil = require("app/util/sendMessage");
    
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
			"click #cancel":"_cancel"
        },
        //重写父类
    	setup: function () {
    		prodEditPager.superclass.setup.call(this);

    	},
		
		//返回
		_cancel:function(){
			var _this = this;
			window.history.go(-2);
		},
		
    	//保存商品信息
      	_saveNormProd:function(){
			var _this = this;
			//验证通过,则进行保存操作.
			if(this._checkInput() && this._convertKeyAttr() && this._convertSaleAttr()){
				ajaxController.ajax({
					type: "post",
					processing: true,
					message: "保存中，请等待...",
					url: _base+"/normprodedit/save",
					data:$('#nromProdForm').serializeArray(),
					success: function(data){
						if("1"===data.statusCode){
							var d = Dialog({
								content:data.statusInfo,
								icon:'success',
								okValue: '确 定',
								ok:function(){
									this.close();
									//保存成功,回退到进入的列表页
									window.history.go(-2);
								}
							});
							d.show();
						}else{
							var d = Dialog({
								content:data.statusInfo,
								icon:'fail',
								okValue: '确 定',
								ok:function(){
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
			//var keyVal = {};
			var attrValArray = [];
			//获取所有
			$("#keyAttrDiv .word").each(function(i){
				var attrId = $(this).attr('attrId');
				var valWay = $(this).attr('valueType');
				//var attrValArray = [];
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
				//keyVal[attrId] = attrValArray;
			});
			var keyJsonStr = JSON.stringify(attrValArray,null);
			console.log($('#keyAttrStr').val());
			$('#keyAttrStr').val(keyJsonStr);
			return true;
		},
		//将销售属性转换json字符串
		_convertSaleAttr:function(){
			//var saleVal = {};
			var attrValArray = [];
			//获取所有
			$("#saleAttrDiv .word").each(function(i){
				var attrId = $(this).attr('attrId');
				var valWay = $(this).attr('valueType');
				//var attrValArray = [];
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
				//saleVal[attrId] = attrValArray;
			});
			var saleJsonStr = JSON.stringify(attrValArray,null);
			console.log($('#saleAttrStr').val());
			$('#saleAttrStr').val(saleJsonStr);
			return true;
		},
		//商品信息保存检查
		_checkInput:function(){
			//品名称不能为空
			var standedProductName = $('#productName').val();
			if (standedProductName==null || standedProductName==''){
				this._showMsg("商品名称不能为空");
				return false;
			}
			//类型不能为空
			var productType = $('#productType').val();
			if (productType==null || productType==''){
				this._showMsg("商品类型不能为空");
				return false;
			}
			//商品状态不能为空
			var state = $("#state").val().trim();
			if (state==null || state=="") {
				this._showMsg("请选择商品状态");
				return false;
			}
			
			return true;
		},
		
		_showMsg:function(msg){
			var msg = Dialog({
				title: '提示',
				content:msg,
				ok:function(){
					this.close();
				}
			});
			msg.showModal();
		}
		
    });
    module.exports = prodEditPager
});

