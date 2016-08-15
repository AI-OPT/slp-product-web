define('app/jsp/prodAttr/addAttr', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging-debug'),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    //定义页面组件类
    var addAttrPager = Widget.extend({
    	
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
    		//保存
            "click #saveAttr":"_saveAttr",
            },
    	//重写父类
    	setup: function () {
    		addAttrPager.superclass.setup.call(this);
    	},
    	
    	_saveAttr:function(){
    		var _this = this;
    		
    		var msg = $("#submitForm").serialize();
    		
    		alert(msg); 
    		
    		/*var json = "[{";
    		var msg2 = msg.split("&");   //先以“&”符号进行分割，得到一个key=value形式的数组
    		var t = false;
    		for(var i = 0; i<msg2.length; i++){
    		  var msg3 = msg2[i].split("=");  //再以“=”进行分割，得到key，value形式的数组
    		  for(var j = 0; j<msg3.length; j++){
    		    json+="\""+msg3[j]+"\"";
    		    if(j+1 != msg3.length){
    		      json+=":";
    		    }
    		    if(t){
    		      json+="}";
    		      if(i+1 != msg2.length){  //表示是否到了当前行的最后一列
    		        json+=",{";
    		      }
    		      t=false;
    		    }
    		    if(msg3[j] == "valueWay"){  //这里的“canshu5”是你的表格的最后一列的input标签的name值，表示是否到了当前行的最后一个input
    		      t = true;
    		    }
    		  }
    		  if(!msg2[i].match("valueWay")){  //同上
    		    json+=";";
    		  }
    		           
    		}
    		json+="]";*/
    		
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "保存中，请等待...",
				url: _base+"/attr/saveAttr",
				
				data:json,
				
				success: function(data){
					if("1"===data.statusCode){
						
						//保存成功,回退到进入的列表页
						window.history.go(-1);
					}
				}
			});
    		
    	},
    	
    	
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	
    });
    
    module.exports = addAttrPager
});

