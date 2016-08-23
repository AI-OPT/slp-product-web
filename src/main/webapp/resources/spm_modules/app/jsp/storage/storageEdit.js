define('app/jsp/storage/storageEdit', function (require, exports, module) {
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
    var StorageEditPager = Widget.extend({
    	
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
    		StorageEditPager.superclass.setup.call(this);
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
		//关闭商品编辑页面
		_closeUpGroupView:function(){
			$('#eject-mask').fadeOut(100);
			$('#up-group-name').slideUp(150);
		},
    	//判断是否是正整数
    	_isNum : function(str){
    		if(/^\d+$/.test(str)){    
    			return true;   
    		}
    		return false;
    	},
		//显示添加库存
		_showAddStoView:function(groupId,pNum){
			$('#eject-mask').fadeIn(100);
			$('#edit-medium').slideDown(200);
		},
		//关闭添加库存弹出框
		_closeAddStoView:function(){
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
    	//添加库存
    	_addStorage:function(){
    		var _this = this;
    		var storGroupId = $("#saveCache").attr('storGroupId');
        	var priorityNumber = $("#saveCache").attr('priorityNum');
        	//number用于判断当前库存组下库存数量
        	var number = $("#saveCache").attr('number');
    		var storageName = $("#newStorageName").val();
    		var totalNum = $("#newTotalNum").val();
    		var warnNum = $("#newWarnNum").val();
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
    		//判断库存量
    		if(totalNum==null || totalNum=='undefined' || totalNum.length==0 ){
    			_this._showMsg("库存量不能为空");
    			return;
    		}
    		//判断预警库存值
    		if(warnNum==null || warnNum=='undefined' || warnNum.length==0){
    			_this._showMsg("预警库存量为不为空");
    			return;
    		}
    		//判断库存量和预警库存量是否为正整数
    		if(!_this._isNum(totalNum) || !_this._isNum(warnNum)){
    			_this._showMsg("库存必须为正整数");
    			return;
    		}
    		if(Number(totalNum) <= Number(warnNum)){
    			_this._showMsg("预警库存量必须小于库存量");
    			return;
    		}
    		//隐藏添加库存窗口
    		$(".eject-big").hide();
    		$("#eject-samll-2").hide();
    		$(".eject-mask").hide();
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "添加中，请等待...",
				url: _base+"/storage/addStorage",
				data:{"storGroupId":storGroupId,"priorityNumber":priorityNumber,"storageName":storageName,
					"productCatId":productCatId,"totalNum":totalNum,"warnNum":warnNum},
				success: function(data){
					if("1"===data.statusCode){
//						var template = $.templates("#storageTemple");
//	            	    var htmlOutput = template.render(data.data);
//	            	    $("#"+storGroupId+priorityNumber+number).after(htmlOutput);
						window.location.reload();
//						window.history.go(0);
					}else{
						_this._showMsg("添加库存失败:"+data.statusInfo);
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
    	//判断字符串的长度-中文2哥,英文1个
    	_getLen:function(str) {  
    	    if (str == null) return 0;  
    	    if (typeof str != "string"){  
    	        str += "";  
    	    }  
    	    return str.replace(/[^\x00-\xff]/g,"01").length;  
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
    
    module.exports = StorageEditPager
});

