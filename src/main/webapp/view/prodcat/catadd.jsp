<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>运营管理</title>
    <%@ include file="/inc/inc.jsp" %>
</head>

<body>
<div class="content-wrapper-iframe"><!--右侧灰色背景-->
    <!--框架标签结束-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                    <form id="prodCatForm" action="${_base}/cat/edit/create" method="post">
                        <div id="addViewDiv" class="main-box-body clearfix">
                            <input type="hidden" id="parentProductCatId" name="parentCatId" value="${parentCatId}">
                            <!-- 查询条件 -->
                            <div class="form-label bd-bottom ui-form" data-widget="validator">
                                <ul>
                                    <li class="col-md-12 ui-form-item">
                                        <p class="word"><span>*</span>类目名称</p>
                                        <p><input name="productCatName0" type="text" class="int-text int-medium"
                                                  maxlength="10" required data-msg-required="类目名称不能为空"
                                                  commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
                                                  val-tag="productCatName"
                                                  onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')">
                                        </p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12 ui-form-item">
                                        <p class="word"><span>*</span>名称首字母(大写)</p>
                                        <p><input name="firstLetter0" type="text" class="int-text int-medium" 
                                        			maxlength='1'
                                                  required data-msg-required="名称首字母不能为空" regexp="[A-Z]{1}"
                                                  data-msg-regexp="请输入大写的名称首字母" val-tag="firstLetter"
                                                  onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12 ui-form-item">
                                        <p class="word"><span>*</span>排序</p>
                                        <p><input name="serialNumber0" type="text" class="int-text int-medium"
                                                  required data-msg-required="排序不能为空" range="[1,999]"
                                                  data-msg-range="请输入1至999的数字" maxlength="3" val-tag="serialNumber"
                                                  onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12 ui-form-item">
                                        <p class="word"><span>*</span>是否存在子分类</p>
                                        <p><input name="isChild0" type="radio" value="Y"></p>
                                        <p>是</p>
                                        <p><input name="isChild0" type="radio" value="N" checked="true"></p>
                                        <p>否</p>
                                    </li>
                                </ul>

                            </div>
                            <div id="subDiv" class="form-label">
                            <div class="left row title-right">
                                <p id="addCatBtn" class="plus-word btn-primary">
                                    <a href="javaScript:void(0);"><i class="fa fa-plus"></i>新  增</a></p>
                            </div>
                            </div>
                            <div  class="row pt-30"><!--删格化-->
                                <p class="center pr-30">
                                    <input id="submitAddBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                           value="提  交" />
                                    <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                           value="返  回" onclick="javaScript:window.history.go(-1);">
                                </p>
                            </div>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="catAddTemplate" type="text/template">
    <!-- 查询条件 -->
    <div class="form-label bd-bottom ui-form" data-widget="validator">
        <div class="title-right">
            <p class="plus-word btn-primary">
                <a href="javaScript:void(0);" name="delBtn" num="{{:num}}"><i class="fa fa-times"></i>删  除</a></p>
        </div>
        <ul>
            <li class="col-md-12 ui-form-item">
                <p class="word"><span>*</span>类目名称</p>
                <p><input name="productCatName{{:num}}" type="text" class="int-text int-medium"
						  commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
                          maxlength="10" required data-msg-required="类目名称不能为空" val-tag="productCatName"onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
            </li>
        </ul>
        <ul>
            <li class="col-md-12 ui-form-item">
                <p class="word"><span>*</span>名称首字母(大写)</p>
                <p><input name="firstLetter{{:num}}" type="text" class="int-text int-medium"
                          maxlength="1" required data-msg-required="名称首字母不能为空"
                          regexp="[A-Z]{1}" data-msg-regexp="请输入大写的名称首字母" val-tag="firstLetter"
						  onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
            </li>
        </ul>
        <ul>
            <li class="col-md-12 ui-form-item">
                <p class="word"><span>*</span>排序</p>
                <p><input name="serialNumber{{:num}}" type="text" class="int-text int-medium"
                          required data-msg-required="排序不能为空" range="[1,999]"
                          maxlength="3" data-msg-range="请输入1至999的数字" val-tag="serialNumber"
							onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
            </li>
        </ul>
        <ul>
            <li class="col-md-12 ui-form-item">
                <p class="word"><span>*</span>是否存在子分类</p>
                <p><input name="isChild{{:num}}" type="radio" value="Y"></p>
                <p>是</p>
                <p><input name="isChild{{:num}}" type="radio" value="N" checked="true"></p>
                <p>否</p>
            </li>
        </ul>
    </div>
</script>
</body>
<script type="text/javascript">
    var pager;
    var catNum = {'num':0};
    var delNumArray = [];
    (function () {
        <%-- 删除按钮 --%>
        $('#addViewDiv').delegate("a[name='delBtn']", 'click', function () {
            <%--p  div(.title-right) div(.form-label) --%>
            $(this).parent().parent().parent().remove();
        });

        seajs.use('app/jsp/prodcat/catadd', function (catAddPager) {
            pager = new catAddPager({element: document.body});
            pager.render();

        });
    })();
</script>
</html>