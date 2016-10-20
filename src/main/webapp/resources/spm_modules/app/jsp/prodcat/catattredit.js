/**
 * Created by jackieliu on 16/8/18.
 */
define('app/jsp/prodcat/catattredit', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
        SendMessageUtil = require("app/util/sendMessage"),
        Widget = require('arale-widget/1.2.0/widget'),
        Dialog = require("optDialog/src/dialog"),
        AjaxController = require('opt-ajax/1.0.0/index');

    //require("jquery-validation/1.15.1/jquery.validate");
    require("app/util/aiopt-validate-ext");

    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    //定义页面组件类
    var catattredit = Widget.extend({

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
            catattredit.superclass.setup.call(this);
        },
        //删除属性或属性值
        _delAttrOfVal:function(id,objType){
            var _this = this;
            ajaxController.ajax({
                type: "post",
                processing: true,
                message: "删除中，请等待...",
                url: _base + "/cat/edit/attr/del",
                data: {'id':id,'productCatId': catId,'objType':objType},
                success: function (data) {
                    if ("1" === data.statusCode) {
                        _this._showSuccessMsg("删除成功");
                        if (objType === '1'){
                            $("#attrTbody1_"+id).remove();
                        }else if(objType === '2'){
                            $("#attrValTr2_"+id).remove();
                        }
                    }
                }
            });
        },
        //提交添加
        _submitCatList:function() {
            //验证输入是否正确
            var validateForm = $("#catAttrEditForm").validate();
            if(!validateForm.form()){
                return;
            }
            var _this=this;
            var attrMap = {};
            var catUpParams = [];
            //获取所有是否上传图片
            $("input:radio:checked").each(function (index, form) {
                var attrId = $(this).attr('catAttrId');
                if (window.console) {
                    console.log("attrId:" + attrId);
                }
                attrMap[attrId] = $(this).val();
            });
            //获取属性顺序
            $("input[type=text][snType=attrSn]").each(function(index,form){
                var catAttrId = $(this).attr('catAttrId');
                var catUp = {};
                catUp['updateObjId'] = catAttrId;
                catUp['objType'] = '1';
                catUp['serialNumber'] = $(this).val();
                var isPic = attrMap[catAttrId];
                if (isPic == null || isPic== undefined )
                    isPic = 'N';
                catUp['isPicture'] = isPic;
                catUpParams.push(catUp);
            });
            //获取属性值顺序
            $("input[type=text][snType=attrValSn]").each(function(index,form){
                var catAttrId = $(this).attr('catAttrValId');
                var catUp = {};
                catUp['updateObjId'] = catAttrId;
                catUp['objType'] = '2';
                catUp['serialNumber'] = $(this).val();
                catUp['isPicture'] = 'N';
                catUpParams.push(catUp);
            });

            ajaxController.ajax({
                type: "post",
                processing: true,
                message: "保存中，请等待...",
                url: _base + "/cat/edit/attr/update",
                data: {'catUpParamStr': JSON.stringify(catUpParams)},
                success: function (data) {
                    if ("1" === data.statusCode) {
                        _this._backList();
                    }
                }
            });
        },
        //回退到列表页面
        _backList:function(){
            window.location.href=_base+"/cat/query?parentProductCatId="+parnetCat;
        },
        //显示成功信息
        _showSuccessMsg:function(msg){
            var d = Dialog({
                content:msg,
                icon:'success',
                okValue: '确 定',
                title:'提示',
                ok:function(){
                    this.close();
                }
            });
            d.show();
        }
    });

    module.exports = catattredit;
});