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
    
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
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
    	},
    	//事件代理
    	events: {
            "click #goBack":"_goBack",
			"click #submitAddBtn":"_upNoSkuPrice"
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
				var priceVal = $(item).val();
				if (priceVal == null || priceVal.trim().length === 0)
					return true;
				if (priceVal!=null && isNaN(priceVal)){
					_this._showMsg("价格必须为数字,如:123,12.45");
					hasError = true;
					return false;
				}
				var salePrice = {};
				salePrice['groupId']=$(item).attr('groupId');
				salePrice['PriorityNumber']=$(item).attr('stoSn');
				salePrice['salePrice']=priceVal*1000;
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
							content:data.statusInfo,
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
		//显示添加库存
		_showAddStoView:function(groupId,pNum){
			$("#addStorage").attr("onclick","pager._addStorage();");
			$("#stoAddGroupId").val(groupId);
			$("#stoAddGroupPn").val(pNum);
			//若不包含销售属性,则直接返回
			if (!hasSale){
				//取消只读
				$('#newTotalNum').removeAttr("readonly");
				$('#eject-mask').fadeIn(100);
				$('#edit-medium').slideDown(200);
				console.log("The hasSale is "+hasSale);
				return;
			}

			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "获取数据中，请等待...",
				url: _base+"/storage/sku/"+groupId,
				data:{"status":status},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						//属性标题信息
						var attrValTr = "";
						var attrVal = data.data.attrInfoList;
						$.each( attrVal, function(index,item){
							attrValTr = attrValTr+"<th>"+item.attrName+"</th>";
						});
						attrValTr = attrValTr+"<th>sku库存量</th>";
						$("#attrValTr").html(attrValTr);
						//SKU信息
						var template = $.templates("#skuInfoTemp");
	            	    var htmlOutput = template.render(data.data.skuInfoList);
	            	    $("#skuInfo").html(htmlOutput);
						$('#eject-mask').fadeIn(100);
						$('#edit-medium').slideDown(200);
					}
				}
			});
		},
		//关闭添加库存弹出框
		_closeAddStoView:function(){
			$("#newTotalNum").val("");
			$("#stoAddGroupId").val("");
			$("#stoAddGroupPn").val("");
			$("#newStorageName").val("");
			$('#eject-mask').fadeOut(100);
			$('#edit-medium').slideUp(150);
		},

    	//sku数量变更,相应变化库存总数量
		_changeStorageNum:function(obj){
			var skuNum = $(obj).val();
			if(!this._isNum(skuNum)){
				this._showMsg("SKU库存数量不能小于0");
				return;
			}
			var stoNum = 0;
			$("#skuInfo input[name='skuNum']").each(function(index,item){
				stoNum = stoNum+parseInt($(item).val());
			});
			$("#newTotalNum").val(stoNum);
		},

		//显示详情页面
		_showStorageInfo:function(obj){
			var storageId = $(obj).attr("storageId");
			var groupId = $(obj).attr("groupId");
			//数量
			var nameTd = $(obj).parent().prev().prev();
			$("#stoInfoNum").text(nameTd.html());
			//名称
			$("#stoInfoName").text(nameTd.prev().html());
			//若不包含销售属性,则直接返回
			if (!hasSale){
				$('#eject-mask').fadeIn(100);
				$('#info-medium').slideDown(200);
				console.log("The hasSale is "+hasSale);
				return;
			}

			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "获取数据中，请等待...",
				url: _base+"/storage/skuSto/"+storageId,
				data:{"groupId":groupId},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						//属性标题信息
						var attrValTr = "";
						var attrVal = data.data.attrInfoList;
						$.each( attrVal, function(index,item){
							attrValTr = attrValTr+"<th>"+item.attrName+"</th>";
						});
						attrValTr = attrValTr+"<th>sku库存量</th>";
						$("#attrValTr4Sto").html(attrValTr);
						//SKU信息
						var template = $.templates("#skuStoTemp");
						var htmlOutput = template.render(data.data.skuInfoList);
						$("#skuStoInfo").html(htmlOutput);
						$('#eject-mask').fadeIn(100);
						$('#info-medium').slideDown(200);
					}
				}
			});
		},
		//关闭详情页
		_closeStorageInfo:function(){
			$('#eject-mask').fadeOut(100);
			$('#info-medium').slideUp(150);
		},
		//显示编辑页面
		_showStorageEdit:function(obj){
			$("#addStorage").attr("onclick","pager._saveStoName();");
			var storageId = $(obj).attr("storageId");
			var groupId = $(obj).attr("groupId");
			//库存组
			$("#stoAddGroupId").val(groupId);
			//数量
			var nameTd = $(obj).parent().prev().prev();
			$("#newTotalNum").val(nameTd.html());
			$('#newTotalNum').attr("readonly","readonly");
			//名称
			$("#newStorageName").val(nameTd.prev().html());
			$("#storageId").val(storageId);

			//若不包含销售属性,则直接返回
			if (!hasSale){
				$('#eject-mask').fadeIn(100);
				$('#edit-medium').slideDown(200);
				console.log("The hasSale is "+hasSale);
				return;
			}

			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "获取数据中，请等待...",
				url: _base+"/storage/skuSto/"+storageId,
				data:{"groupId":groupId},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						//属性标题信息
						var attrValTr = "";
						var attrVal = data.data.attrInfoList;
						$.each( attrVal, function(index,item){
							attrValTr = attrValTr+"<th>"+item.attrName+"</th>";
						});
						attrValTr = attrValTr+"<th>sku库存量</th>";
						$("#attrValTr").html(attrValTr);
						//SKU信息
						var template = $.templates("#skuStoTemp");
						var htmlOutput = template.render(data.data.skuInfoList);
						$("#skuInfo").html(htmlOutput);
						$('#eject-mask').fadeIn(100);
						$('#edit-medium').slideDown(200);
					}
				}
			});
		},
		//变更库存名称
		_saveStoName:function(){
			var _this = this;
			var stoName = $("#newStorageName").val();
			var storageId = $("#storageId").val();
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "更新中，请等待...",
				url: _base+"/storage/edit/stoName/"+storageId,
				data:{"stoName":stoName},
				success: function(data){
					//变更成功
					if("1"=== data.statusCode){
						_this._closeAddStoView();
						//属性标题信息
						_this._showSuccessMsg("库存更新成功");
						//变更名称
						$("#stoName"+storageId).text(stoName);
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

