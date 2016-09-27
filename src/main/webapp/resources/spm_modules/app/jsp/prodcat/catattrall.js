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
        //属性点击事件
        _clickAttr:function(obj){
            var attrId = obj.val();
            if (window.console) {
                console.log("attrId:" + attrId + ",click");
            }
            // 若属性取消选择,则属性值也取消
            var check = true;
            if(!obj.is(':checked')){
                check = false;
            }
            $("input:checkbox[name='valCheck'][attrId='"+attrId+"']").prop("checked",check);
        },
        //属性值点击事件
        _clickAttrVal:function(obj){
            var attrId= obj.attr("attrId");
            var attrVal = obj.val();
            if (window.console) {
                console.log("attrId:" + attrId + ",attrVal:" + attrVal + ",click");
            }
            // 若属性值取消,则属性也取消 --%>
            if(!obj.is(':checked')){
                $("input:checkbox[name='attrCheck'][value='"+attrId+"']").prop("checked",false);
                return;
            }
            // 若属性值选中,则判断属性是否选中 --%>

            //获取属性值数量
            var valNum = $("input:checkbox[name='valCheck'][attrId='" + attrId + "']").size();
            //获取选中属性值数量
            var checkNum = $("input:checkbox:checked[name='valCheck'][attrId='" + attrId + "']").size();
            if (valNum == checkNum) {
                $("input:checkbox[name='attrCheck'][value='" + attrId + "']").prop("checked", true);
            }
        },
        //提交添加
        _submitCatList:function() {
            var attrMap = {};
            //获取所有选中的属性
            $("input:checkbox[name=attrCheck]:checked").each(function (index, form) {
                var attrId = $(this).val();
                var valArr = [];
                if (window.console) {
                    console.log("attrId:" + attrId);
                }
                attrMap[attrId] = valArr;
            });
            //获取选中的属性值
            $("input:checkbox[name=valCheck]:checked").each(function(index,form){
                var attrId = $(this).attr('attrId');
                var valArr = attrMap[attrId];
                if (!valArr || typeof(valArr)==="undefined")
                    valArr = [];
                valArr.push($(this).val());
                attrMap[attrId] = valArr;
                if (window.console) {
                    console.log("attrId:" + attrId + ",attrVal:" + $(this).val());
                }
            });
            if (attrMap.length <1){
                new Dialog({
                    content:"未选择任何属性值",
                    icon:'warning',
                    okValue: '确 定',
                    title:'提示',
                    ok:function(){
                        this.close();
                    }
                }).show();
                return;
            }

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