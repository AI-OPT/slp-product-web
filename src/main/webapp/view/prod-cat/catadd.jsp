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

<body style="min-height: 3000px;">
<div class="content-wrapper-iframe"><!--右侧灰色背景-->
    <!--框架标签结束-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                        <div id="addViewDiv" class="main-box-body clearfix">
                            <input type="hidden" id="parentProductCatId" name="parentCatId" value="${parentCatId}">
                            <!-- 查询条件 -->
                            <div class="form-label bd-bottom">
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word"><span>*</span>类目名称</p>
                                        <p><input name="productCatName" type="text" class="int-text int-medium"></p>
                                    </li>
                                    <li class="col-md-6">
                                        <p class="word">名称首字母(大写)</p>
                                        <p><input name="firstLetter" type="text" class="int-text int-medium"></p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">排序</p>
                                        <p><input name="serialNumber" type="text" class="int-text int-medium"></p>
                                    </li>
                                    <li class="col-md-6">
                                        <p class="word"><span>*</span>是否存在子分类</p>
                                        <p><input name="isChild" type="radio" value="Y"></p>
                                        <p>是</p>
                                        <p><input name="isChild" type="radio" value="N"></p>
                                        <p>否</p>
                                    </li>
                                </ul>

                                <div class="title-right">
                                    <p id="addCatBtn" class="plus-word btn-primary">
                                        <a href="#"><i class="fa fa-plus"></i>新  增</a></p>
                                </div>
                            </div>


                            <div id="subDiv" class="row pt-30"><!--删格化-->
                                <p class="center pr-30 mt-30">
                                    <input type="button" class="biu-btn  btn-primary  btn-small  ml-5" value="提  交">
                                    <input type="button" class="biu-btn  btn-primary  btn-small  ml-5" value="返  回">
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script id="catAddTemplate" type="text/template">
    <!-- 查询条件 -->
    <div class="form-label bd-bottom">
        <div class="title-right">
            <p class="plus-word btn-primary">
                <a href="#" name="delBtn"><i class="fa fa-times"></i>删  除</a></p>
        </div>
        <ul>
            <li class="col-md-6">
                <p class="word"><span>*</span>类目名称</p>
                <p><input name="productCatName" type="text" class="int-text int-medium"></p>
            </li>
            <li class="col-md-6">
                <p class="word">名称首字母(大写)</p>
                <p><input name="firstLetter" type="text" class="int-text int-medium"></p>
            </li>
        </ul>
        <ul>
            <li class="col-md-6">
                <p class="word">排序</p>
                <p><input name="serialNumber" type="text" class="int-text int-medium"></p>
            </li>
            <li class="col-md-6">
                <p class="word"><span>*</span>是否存在子分类</p>
                <p><input name="isChild" type="radio" value="Y"></p>
                <p>是</p>
                <p><input name="isChild" type="radio" value="N"></p>
                <p>否</p>
            </li>
        </ul>
    </div>
</script>
</body>
<script type="text/javascript">
    var pager;
    (function () {
        <%-- 删除按钮 --%>
        $('#addViewDiv').delegate("a[name='delBtn']", 'click', function () {
            console.log("删除");
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