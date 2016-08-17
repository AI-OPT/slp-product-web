/**
 * Created by jackieliu on 16/8/17.
 */
define('app/jsp/prodcat/catattrall', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
        SendMessageUtil = require("app/util/sendMessage"),
        Widget = require('arale-widget/1.2.0/widget'),
        Dialog = require("optDialog/src/dialog"),
        AjaxController = require('opt-ajax/1.0.0/index');

    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    //定义页面组件类
    var catattrallPage = Widget.extend({

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
            "click #sumBtn":"_submitCatList"
        },
        //重写父类
        setup: function () {
            catattrallPage.superclass.setup.call(this);
        },
        //提交添加
        _submitCatList:function() {
            var attrMap = {};
            //获取所有选中的属性
            $("input:checkbox[name=attrCheck]:checked").each(function (index, form) {
                var attrId = $(this).val();
                var valArr = [];
                //获取选中的属性值
                $("input:checkbox[name=valCheck][attrId="+attrId+"]:checked").each(function(index,form){
                    valArr.push($(this).val());
                });
                console.log("attrId:"+attrId);
                console.log("attrVal:"+valArr.toString());
                attrMap[attrId] = valArr;
            });
            ajaxController.ajax({
                type: "post",
                processing: true,
                message: "保存中，请等待...",
                url: _base + "/cat/edit/attr/type/"+catId,
                data: {'attrType':attrType,'attrMap': JSON.stringify(attrMap)},
                success: function (data) {
                    if ("1" === data.statusCode) {
                        //保存成功,回退到进入的列表页
                        window.location.href = _base+"/cat/query/attr/edit/"+catId;
                    }
                }
            });
        }
    });

    module.exports = catattrallPage;
});