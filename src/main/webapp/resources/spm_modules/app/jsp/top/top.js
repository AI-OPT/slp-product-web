define('app/jsp/top/top', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("artDialog/src/dialog"),
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
    //定义页面组件类
    var TopPager = Widget.extend({
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	//事件代理
    	events: {
    		//查询
    		   //"click #BTN_SEARCH":"_searchBtnClick"
        },
    	//重写父类
    	setup: function () {
    		TopPager.superclass.setup.call(this);
    		this._getCity();
    	},
    	_changeCity : function() {
			$(".ATTs_BTN").bind(
				"click",
				function() {
					var _this = this;
					var cityCode = $(_this).attr('areaCodeId');
					var cityName = $(_this).attr('areaNameId');
					$("#currentCity").attr("currentCityCode",cityCode);
					$("#currentCity").attr("currentCityName",cityName);
		    		document.getElementById("currentCity").innerHTML=cityName;
				})
		},

    	_getCity: function(){
    		var _this = this;
      		ajaxController.ajax({
				type: "post",
				dataType: "json",
				processing: true,
				message: "查询中，请等待...",
				url: _base+"/head/getArea",
				data:'',
				success: function(data){
					if(data.data){
						var template = $.templates("#cityTmpl");
						var htmlOut = template.render(data.data);
						$("#cityShowData").html(htmlOut);
						_this._changeCity();
					}
				}
			}
		);
      }
    	
    });
    
    module.exports = TopPager
});

