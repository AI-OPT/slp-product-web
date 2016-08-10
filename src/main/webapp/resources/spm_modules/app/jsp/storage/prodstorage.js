define('app/jsp/storage/prodstorage', function (require, exports, module) {
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
    var clickId = "";
    //定义页面组件类
    var normproductlistPager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 30
    	},
    	//事件代理
    	events: {
    		//查询在售商品
            "click #selectNormProductList":"_selectNormProductList",
            },
    	//重写父类
    	setup: function () {
    		normproductlistPager.superclass.setup.call(this);
    		this._selectNormProductList();
    	},
    	
    	// 改变商品类目
    	_selectChange:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(10))+1;
    		//获取下拉菜单的总个数
    		var prodCat = document.getElementById("data1ProdCat");
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
				url: _base+"/cat/query/child",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
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
    	},
    	
    	
    	//查询标准品列表
    	_selectNormProductList:function(){
    		var _this = this;
    		var div = document.getElementById("data1ProdCat");
    		var length = document.getElementsByTagName("select").length-2;
    		var productCatId = $("#productCat"+length+" option:selected").val();
    		var productType = $("#productType").val().trim();
    		var productId = $("#standedProdId").val().trim();
    		var productName = $("#standedProductName").val().trim();
    		
    		var state = $("#state").val().trim();
    		var operStartTime = $("#operStartTime").val().trim();
    		var operEndTime = $("#operEndTime").val().trim();
    		
    		$("#pagination-ul").runnerPagination({
    			
	 			/*url: _base+"/normprodquery/getNormProductList",*/
	 			url: _base+"/normprodquery/getNormProductList",
	 			
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchNormProductData",
	 			messageId:"showMessageDiv",
	 			
	           /* data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	            */
	 			data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName,
		 			"operStartTimeStr":operStartTime,"operEndTimeStr":operEndTime,"state":state
		 			},
	 			
	           	pageSize: normproductlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchNormProductTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchNormProductData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	
    });
    
    module.exports = normproductlistPager
});




















/*define('app/jsp/storage/prodstorage', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging-debug'),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("My97DatePicker/WdatePicker");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    //定义页面组件类
    var prodstoragePager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 30
    	},
    	//事件代理
    	events: {
    		//查询在售商品
            "click #selectNormProductList":"_selectNormProductList",
        //   "click #upConfirm":"_prodToInStore"
            },
    	//重写父类
    	setup: function () {
    		prodstoragePager.superclass.setup.call(this);
    		this._selectNormProductList();
    	},
    	
    	// 改变商品类目
    	_selectChange:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(10))+1;
    		//获取下拉菜单的总个数
    		var prodCat = document.getElementById("data1ProdCat");
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
				url: _base+"/normprodquery/getCat",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
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
    	},
    	
    	
    	//查询标准品列表
    	_selectNormProductList:function(){
    		var _this = this;
    		var div = document.getElementById("data1ProdCat");
    		var length = document.getElementsByTagName("select").length-2;
    		
    		var productCatId = $("#productCat"+length+" option:selected").val();
    		
    		var productType = $("#productType").val().trim();
    		var productId = $("#standedProdId").val().trim();
    		var productName = $("#standedProductName").val().trim();
    		
    		$("#pagination-ul").runnerPagination({
    			
	 			url: _base+"/normprodquery/getNormProductList2",
	 			url: _base+"/storage/getNormProductList",
	 			
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchNormProductData",
	 			messageId:"showMessageDiv",
	 			
	            data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	            
	           	pageSize: prodstoragePager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchNormProductTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchNormProductData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	
    });
    
    module.exports = prodstoragePager
});




*/







/*define('app/jsp/storage/prodstorage', function (require, exports, module) {
'use strict';
var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("optDialog/src/dialog"),
    Paging = require('paging/0.0.1/paging-debug'),
    AjaxController = require('opt-ajax/1.0.0/index');
require("jsviews/jsrender.min");
require("jsviews/jsviews.min");
require("My97DatePicker/WdatePicker");
require("bootstrap-paginator/bootstrap-paginator.min");
require("app/util/jsviews-ext");

require("opt-paging/aiopt.pagination");
require("twbs-pagination/jquery.twbsPagination.min");
var SendMessageUtil = require("app/util/sendMessage");

//实例化AJAX控制处理对象
var ajaxController = new AjaxController();
//定义页面组件类
var ProdStoragePager = Widget.extend({
	
	Implements:SendMessageUtil,
	//属性，使用时由类的构造函数传入
	attrs: {
	},
	Statics: {
		DEFAULT_PAGE_SIZE: 20
	},
	//事件代理
	events: {
		//查询标准品
        "click #selectStandProd":"_selectStandProd",
    },
	//重写父类
	setup: function () {
		ProdStoragePager.superclass.setup.call(this);
//		this._selectStandProd();
	},
	// 改变商品类目
	_selectChange:function(osel){
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
            		var d = Dialog({
						content:"获取类目信息出错:"+data.statusInfo,
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
           	pageSize: ProdStoragePager.DEFAULT_PAGE_SIZE,
           	visiblePages:5,
            render: function (data) {
            	if(data != null && data != 'undefined' && data.length>0){
            		var template = $.templates("#searchStanProdTemple");
            	    var htmlOutput = template.render(data);
            	    $("#searchStanProdData").html(htmlOutput);
            	}
            	_this._returnTop();
            }
		});
	},
	//滚动到顶部
	_returnTop:function(){
		var container = $('.wrapper-right');
		container.scrollTop(0);//滚动到div 顶部
	},
	
});

module.exports = ProdStoragePager
});

*/











