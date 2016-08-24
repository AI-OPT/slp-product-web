define('app/jsp/normproduct/add', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    require("twbs-pagination/jquery.twbsPagination.min");
   
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    //定义页面组件类
    var addPager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	//事件代理
    	events: {
    		//跳转下一步
    		"click #next":"_next",
        },
    	//重写父类
    	setup: function () {
    		addPager.superclass.setup.call(this);

    	},
    	
    	// 改变商品类目
    	_selectChange:function(osel){
			var prodCatId = osel.options[osel.selectedIndex].value;
			var clickId = $(osel).parent().attr('id');
			//获取当前ID的最后数字
			var index = Number(clickId.substring(10))+1;
			//获取下拉菜单的总个数
			var prodCat = document.getElementById("dataProdCat");
			var length = prodCat.getElementsByTagName("select").length;
			//if(index==length){
			//	return;
			//}
			//从当前元素开始移除后面的下拉菜单
			for(var i=index;i<length;i++){
				$("#productCat"+i).remove();
			}
			var productCatValues = "您当前选择的商品类别是：";
			for(var i=0;i<index;i++){
				var prodCat = document.getElementById("selectCat"+i);
				var valueName = prodCat.options[prodCat.selectedIndex].text;
				if(i==0){
					productCatValues = productCatValues + valueName;
				}else{
					productCatValues = productCatValues + "&gt;" + valueName;
				}
			}
			$("#productCatValues").html(productCatValues);
			ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/cat/query/child",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.data.length>0){
						var template = $.templates("#prodCatTemple");
						var htmlOutput = template.render(data.data);
						$("#"+clickId).after(htmlOutput);
						var productCatValues = $("#productCatValues").html();
						var productCatList = data.data;
						if(productCatList && productCatList.length>0){
							for(var i in productCatList){
								var productCatName = productCatList[i].prodCatList[0].productCatName;
								productCatValues = productCatValues +"&gt;"+productCatName;
							}
							$("#productCatValues").html(productCatValues);
						}
					}else if(data.statusCode === AjaxController.AJAX_STATUS_FAILURE){
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
    	//跳转下一步
    	_next:function(){
    		var length = document.getElementsByName("selectProductCat").length-1;
    		var productCatId = $("#selectCat"+length+" option:selected").val();
    		window.location.href = _base+'/normprodedit/addProduct?productCatId='+productCatId
    	}
    });
    
    module.exports = addPager
});

