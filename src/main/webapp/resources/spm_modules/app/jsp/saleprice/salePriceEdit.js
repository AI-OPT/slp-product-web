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
            "click #goBack":"_goBack"
        },
    	//重写父类
    	setup: function () {
			salePriceEditPage.superclass.setup.call(this);
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
		//更改库存组状态
		_changeGroupStatus:function(statusBtn){
			var statusBtnJ = $(statusBtn);
			var groupId = statusBtnJ.attr("groupId");
			var status = statusBtnJ.attr("groupStatus");
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "状态变更中，请等待...",
				url: _base+"/storage/edit/upGroupStatus/"+groupId,
				data:{"status":status},
				success: function(data){
					//变更成功
					if("1"!= data.statusCode){
						return;
					}
					var btnVal = '';
					var statusVal = '';
					//若变更为启用
					if(status==='1'){
						status = '2';
						btnVal = '停用';//与
						statusVal = '启用';
					}else if(status==='2'){
						status = '1';
						btnVal = '启用';
						statusVal = '停用';
					}
					statusBtnJ.attr('groupStatus',status);
					statusBtnJ.val(btnVal);
					statusBtnJ.parent().next().text("状态:"+statusVal);
				}
			});
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
		//添加库存
    	_addStorage:function(){
    		var _this = this;
    		var storGroupId = $("#stoAddGroupId").val();
        	var priorityNumber = $("#stoAddGroupPn").val();
        	//number用于判断当前库存组下库存数量
    		var storageName = $("#newStorageName").val();
    		var totalNum = $("#newTotalNum").val();
    		var length = _this._getLen(storageName);
    		//判断库存名称
    		if(storageName==null || storageName=='undefined' || length==0){
    			_this._showMsg("库存名称不能为空");
    			return;
    		}
    		if(length>30){
    			_this._showMsg("库存名称最大长度为15个字（30个字符）");
    			return;
    		}

			var skuMapStr = "";
			//若有销售属性,则添加SKU库存数量
			if (hasSale){
				var stoNum = 0;
				var skuMap = {};
				$("#skuInfo input[name='skuNum']").each(function(index,item){
					var skuId = $(this).attr('skuId');
					var skuNum = $(this).val();
					//判断是否为负数
					if (!_this._isNum(skuNum)){
						_this._showMsg("SKU库存数量不能小于0");
						stoNum = null;
						return;
					}
					skuMap[skuId] = skuNum;
					stoNum = stoNum+parseInt($(item).val());
				});
				skuMapStr = JSON.stringify(skuMap);
				console.log("SKU num string:"+skuMapStr);
				totalNum = stoNum;
			}

			//判断库存量
			if(totalNum==null || totalNum==undefined || totalNum.length==0 ){
    			_this._showMsg("库存量不能为空");
    			return;
    		}//判断库存量和预警库存量是否为正整数
    		else if(!_this._isNum(totalNum)){
    			_this._showMsg("库存必须为正整数");
    			return;
    		}
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "添加中，请等待...",
				url: _base+"/storage/edit/addStorage",
				data:{"storageGroupId":storGroupId,"priorityNumber":priorityNumber,"storageName":storageName,
					"totalNum":stoNum,"skuNumMap":skuMapStr},
				success: function(data){
					if("1"===data.statusCode){
						window.location.reload();
					}
				}
			});
    	},
    	//增加优先级
    	_addPriorityNumber:function(groupId){
			var number = $("#groupSn"+groupId).val();
			var name = 'stopn_'+groupId+"_"+number;
			console.log("Tr name:"+name);
			var stoNum = $("tr[name="+name+"]").size();
			console.log("GroupId:"+groupId+",Number:"+number+",stoNum:"+stoNum);
    		if(stoNum<1){
    			alert("最高优先级下没有库存,不允许添加新的优先级");
    			return;
    		}
			number = parseInt(number)+1;
			$("#groupSn"+groupId).val(number);
    		var data = {"groupId":groupId,"priNum":number};
    		var template = $.templates("#priorityNumTemple");
    	    var htmlOutput = template.render(data);
    	    $("#groupSn"+groupId).before(htmlOutput);
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
		//库存废弃
		_changeStoStatus:function(obj){
			var _this =this;
			var status = $(obj).attr('statue');
			var stoId = $(obj).attr('storageId');
			console.log("storageId:"+stoId+",status:"+status);
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "操作中，请等待...",
				url: _base+"/storage/edit/status/"+stoId,
				data:{"status":status},
				success: function(data) {
					//若不成功,直接返回
					if ("1" != data.statusCode) {
						return;
					}//废弃
					else if (status === stoDiscard) {
						window.location.reload();
					}//启用
					else if (status === stoActive) {
						$(obj).html("停用");
						$(obj).attr("statue", stoStop);
						$(obj).parent().prev().html("启用");
						_this._showSuccessMsg("库存启用成功");
					}//停用
					else if (status === stoStop) {
						$(obj).text("启用");
						$(obj).attr("statue", stoActive);
						$(obj).parent().prev().text("停用");
						_this._showSuccessMsg("库存停用成功");
					}
				}
			});
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
