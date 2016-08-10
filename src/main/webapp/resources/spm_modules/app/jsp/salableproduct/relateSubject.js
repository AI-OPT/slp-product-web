define('app/jsp/salableproduct/relateSubject', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("artDialog/src/dialog"),
    AjaxController=require('opt-ajax/1.0.0/index');
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    
    //定义页面组件类
    var RelateSubjectPager = Widget.extend({
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	//事件代理
    	events: {
    		//key的格式: 事件+空格+对象选择器;value:事件方法
    		"click #saveForm":"saveForm"
        },
    	//重写父类
    	setup: function () {
			RelateSubjectPager.superclass.setup.call(this);
			this._setMenu();
    		this._getRelateSubject();
    	},
		_setMenu:function () {
			setBreadCrumb("可销售产品管理","关联详单科目");
			$("#mnu_bmc_config").addClass("current");
		},
    	_getRelateSubject: function() {
    		var json = this.getSelectValue(_base + '/standardFee/getConnectList');
    		var selectedValue = $('#subjectCode').attr('oldValue');
    		$.each(json,function(index, item) {
						// 循环获取数据
						var paramCode = json[index].subjectId;
						var paramName = json[index].subjectName;
						var addHtml = "" ;
						if(selectedValue == paramCode){
							addHtml = 'selected="selected"';
						}
						$('#subjectCode').append('<option value="'+paramCode+'" '+addHtml+'>'+paramName+'</option>');
					});
    	},
    	getSelectValue: function(url){
    		var json;
    		$.ajax({
				url : url,
				type : "post",
				dataType : "html",
				timeout : "10000",
				showWait : true,
				async : false,
				error : function() {
					alert("服务加载出错");
				},
				success : function(data) {
					json = eval(data);
				}
			});
    		return json;
    	},
    	saveForm:function(){
    		if($('#subjectCode').val()==''){
    			var d = Dialog({
                    content:"请选择关联费用科目",
                    ok:function(){
                        this.close();
                    }
                });
                d.show();
                return;
    		}
            ajaxController.ajax({
                type: "post",
                dataType : "json",
                url: _base+"/salableProduct/saveRelateSubject",
                processing: true,
                message: "正在加载，请等待...",
                data:$('#addForm').find("input,select").serializeArray(),
                success: function(data){
                    if(data){
                        var d = Dialog({
                            content:"添加成功",
                            ok:function(){
                                this.close();
                                history.go(-1);
                            }
                        });
                        d.showModal();
                    }
                }
            });
            
        }

    });
    
    module.exports = RelateSubjectPager;
});