define('app/jsp/prodcat/catadd', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
		Validate = require("arale-validator/0.10.2/index"),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging'),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");

	require("arale-validator/0.10.2/alice.components.ui-button-orange-1.3-full.css");
	require("arale-validator/0.10.2/alice.components.ui-form-1.0-src.css");

    var SendMessageUtil = require("app/util/sendMessage");

    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
	var validate = new Validate();
    //定义页面组件类
    var catAddPager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 10
    	},
    	//事件代理
    	events: {
			"click #addCatBtn":"_addCatTemp",
			"click #submitAddBtn":"_submitCatList"
            },
    	//重写父类
    	setup: function () {
			catAddPager.superclass.setup.call(this);
			catAddPager.superclass.autoRenderAll();
    	},
		//增加类目
		_addCatTemp:function(){
			catNum['num']=catNum['num']+1;
			var template = $.templates("#catAddTemplate");
			var htmlOutput = template.render(catNum);
			$("#subDiv").before(htmlOutput);
		},
		//删除类目
		_delCatTemp:function(){
			console.log("")
		},
		//提交添加
		_submitCatList:function(){
			validate.execute(function(error, results, element) {
				console.log("form validator:");
				console.log(arguments);
			});
			//父类目
			var parentCatId = $('#parentProductCatId').val();
			var catArr = [];
			//获取所有的form-label下的input
			$("#addViewDiv > .form-label ").each(function(index,form){
				var catObj = {};
				console.log(index+" form-label");
				if (parentCatId!=null & parentCatId!='')
					catObj['parentProductCatId'] = parentCatId;
				//类目名
				var catName = $(this).find("input[name='productCatName']")[0];
				catObj['productCatName'] = catName.value;
				//首字母
				var fLetter = $(this).find("input[name='firstLetter']")[0];
				catObj['firstLetter'] = fLetter.value;
				//排序
				var sn = $(this).find("input[name='serialNumber']")[0];
				catObj['serialNumber'] = sn.value;
				//是否有子分类
				var isChild = $(this).find("input[type='radio']:checked")[0];
				catObj['isChild'] = isChild.value;
				catArr.push(catObj);
			});
			console.log("cat arr lengeth "+catArr.length);
			ajaxController.ajax({
				type: "post",
				processing: true,
				message: "保存中，请等待...",
				url: _base+"/cat/edit/create",
				data:{'catListStr':JSON.stringify(catArr)},
				success: function(data){
					if("1"===data.statusCode){
						alert("保存成功");
						//保存成功,回退到进入的列表页
						//window.history.go(-1);
					}
				}
			});
		}
    });
    
    module.exports = catAddPager
});

