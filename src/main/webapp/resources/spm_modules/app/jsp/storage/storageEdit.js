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
            "click #goBack":"_goBack",
            "click #addStorage":"_addStorage",
        },
    	//重写父类
    	setup: function () {
    		StorageEditPager.superclass.setup.call(this);
//    		this._selectStandProd();
    	},
    	//判断是否是正整数
    	_isNum : function(str){
    		if(/^\d+$/.test(str)){    
    			return true;   
    		}
    		return false;
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
    	_addPriorityNumber:function(groupId,number){
    		number = parseInt(number)+1;
    		if(priorityString == groupId+number){
    			this._showMsg("请不要重复添加优先级");
    			return;
    		}
    		var data = {"storageGroupId":groupId,"number":number};
    		var template = $.templates("#priorityNumTemple");
    	    var htmlOutput = template.render(data);
    	    $("#"+groupId+"priorityDemo").before(htmlOutput);
    	    priorityString = groupId+number;
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
//    	//显示库存组的库存信息
//		_showCheckAudi:function(audiMap){
//			var audNum = Object.keys(audiMap).length;
//			$('#audiNum').text(audNum);
//			//删除原来受众信息
//			$('#audiSelectedDiv').html("");
//			for (var key in audiMap) {
//				$('#audiSelectedDiv').append("<p>"+audiMap[key]+"<a href=\"javascript:void(0);\"><i class=\"icon-remove-sign\" userId='"+key+"'></i></a></p>");
//			}
//		},
    	// 改变商品类目
    	_selectChange:function(osel){
    		var _this = this;
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(10))+1;
    		//获取下拉菜单的总个数
    		var prodCat = document.getElementById("productCat");
    		var length = prodCat.getElementsByTagName("select").length;
    		if(index==length){
    			return;
    		}
    		//从当前元素开始移除后面的下拉菜单
    		for(var i=index;i<length;i++){
    			$("#productCat"+i).remove();
    		}
    		ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/prodquery/getCat",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		_this._showMsg("获取类目信息出错:"+data.statusInfo);
	            	}
				}
			});
    	},
    	//查询标准品
    	_selectStandProd:function(){
    		var _this = this;
    		//获取下拉菜单的总个数-2即为ID后的数值
    		var length = document.getElementsByTagName("select").length-2;
    		var productCatId = $("#productCat"+length+" option:selected").val();
    		var productType = $("#stanProdType").val().trim();
    		var standedProdId = $("#stanProdId").val().trim();
    		var standedProductName = $("#stanProdName").val().trim();
    		var operStartTime = $("#operStartTime").val();
    		var operEndTime = $("#operEndTime").val();
    		$("#pagination-ul").runnerPagination({
	 			url: _base+"/storage/normProdList",
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchStanProdData",
	 			messageId:"showMessageDiv",
	            data: {"productCatId":productCatId,"productType":productType,"standedProdId":standedProdId,
	            	"standedProductName":standedProductName,"startTime":operStartTime,"endTime":operEndTime},
	           	pageSize: StorageEditPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchStanProdTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchStanProdData").html(htmlOutput);
	            	}
	            }
    		});
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

