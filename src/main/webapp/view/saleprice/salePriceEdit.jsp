<%@ page import="com.ai.slp.product.web.constants.StorageConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("stoActive",StorageConstants.STATUS_ACTIVE);
    request.setAttribute("stoStop",StorageConstants.STATUS_STOP);
    request.setAttribute("stoDiscard",StorageConstants.STATUS_DISCARD);
%>
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
<!--增加库存 弹出框  小-->
<!--编辑名称弹出框-->
<div class="eject-big">
    <div class="eject-medium" id="edit-medium">
        <div class="eject-medium-title">
            <p>编辑库存</p>
            <p class="img" onclick="pager._closeAddStoView();"><i class="fa fa-times"></i></p>
        </div>
        <div class="form-label">
            <input type="hidden" id="storageId">
            <input type="hidden" id="stoAddGroupId">
            <input type="hidden" id="stoAddGroupPn">
            <ul>
                <li>
                    <p class="word"><span>*</span>库存名称:</p>
                    <p><input type="text" id="newStorageName" class="int-text int-small" maxlength="60"></p>
                </li>
            </ul>
            <ul>
                <li>
                    <p class="word">库存量:</p>
                    <p><input type="text" id="newTotalNum" class="int-text int-small" value="0"
                              <c:if test="${!saleAttr.isEmpty()}">readonly</c:if> maxlength="10"></p>
                </li>
            </ul>
        </div>
        <c:set var="isSale" value="false"/>
    <c:if test="${!saleAttr.isEmpty()}">
        <c:set var="isSale" value="true"/>
        <!--table表格-->
        <div class="table-responsive clearfix">
            <table class="table table-hover table-border table-bordered">
                <thead>
                <tr id="attrValTr">
                </tr>
                </thead>
                <tbody id="skuInfo">
                </tbody>
            </table>
        </div>
    </c:if>
        <!--/table表格结束-->
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input type="button" id="addStorage" class="biu-btn  btn-primary  btn-auto  ml-5"
                       onclick="pager._addStorage();" value="确  认">
                <input id="edit-close" type="button" onclick="pager._closeAddStoView();"
                       class="biu-btn  btn-primary  btn-auto  ml-5" value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<script id="skuStoTemp" type="text/template">
    <tr>
        {{for valForSkuList}}
        <td>{{:valName}}</td>
        {{/for}}
        <td >{{:totalNum}}</td>
    </tr>
</script>
<script id="skuInfoTemp" type="text/template">
    <tr>
        {{for valForSkuList}}
        <td>{{:valName}}</td>
        {{/for}}
        <td ><input type="text" name="skuNum" skuId="{{:skuId}}" onchange="pager._changeStorageNum(this)"
                    class="int-text int-mini"  value="0" maxlength="10"/></td>
    </tr>
</script>
<div class="eject-big">
    <div class="eject-medium" id="info-medium">
        <div class="eject-medium-title">
            <p>库存信息</p>
            <p class="img" onclick="pager._closeStorageInfo();"><i class="fa fa-times"></i></p>
        </div>
        <div class="form-label center">
            <ul>
                <li>
                    <p class="word">库存名称:</p>
                    <p id="stoInfoName"></p>
                </li>
            </ul>
            <ul>
                <li>
                    <p class="word">库存量:</p>
                    <p id="stoInfoNum"></p>
                </li>
            </ul>
        </div>
        <c:set var="isSale" value="false"/>
        <c:if test="${!saleAttr.isEmpty()}">
            <c:set var="isSale" value="true"/>
            <!--table表格-->
            <div class="table-responsive clearfix">
                <table class="table table-hover table-border table-bordered">
                    <thead>
                    <tr id="attrValTr4Sto">
                    </tr>
                    </thead>
                    <tbody id="skuStoInfo">
                    </tbody>
                </table>
            </div>
        </c:if>
        <!--/table表格结束-->
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input type="button" onclick="pager._closeStorageInfo();"
                       class="biu-btn  btn-primary  btn-auto  ml-5" value="关  闭">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<!--编辑名称弹出框  中结束-->
<!--废弃 弹出框  小-->
<div class="eject-big">
    <div class="eject-samll" id="eject-samll-3">
        <div class="eject-samll-title">
            <p>废弃组</p>
            <p class="img"><A href="javascript:void(0);"></A></p>
        </div>
        <div class="eject-medium-complete">
            <p><img src="${_slpres }/images/eject-icon-prompt.png"></p>
            <p class="word">库存组废弃后不可再启用，确定废弃该库存组吗？</p>
        </div>
        <div class="eject-samll-confirm mt-0">
            <ul>
                <li><input type="button" class="slp-btn eject-small-btn mt-10" value="确认">
                    <input type="button" class="slp-btn eject-small-btn close-btn mt-10" value="取消">
                </li>
            </ul>
        </div>
    </div>
    <div class="eject-mask"></div>
</div>
<!--/结束-->


<div class="content-wrapper-iframe"><!--外围框架-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                        <div class="main-box-body clearfix">
                            <!-- 类目链 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">所属类目：
                                    <c:forEach var="catInfo" items="${catLinkList}"
                                               varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
                                    </c:forEach>
                                </h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <ul class="big-word">
                                    <li class="col-md-6">
                                        <p class="word">商品名称：</p>
                                        <p>${normProdInfo.productName}</p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">商品类型：</p>
                                        <p>${prodType}</p>
                                    </li>
                                </ul>
                            </div>
                            <!-- 关键属性 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品关键属性</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${keyAttr}">
                                    <ul>
                                        <li class="col-md-6">
                                            <p class="word">${aav.key.attrName}:</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            <c:if test="${!saleAttr.isEmpty()}">
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品销售属性</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${saleAttr}">
                                    <ul>
                                        <li class="col-md-6">
                                            <p class="word">${aav.key.attrName}:</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            </c:if>
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">库存设置</h5>
                                <%--<div class="title-right">--%>
                                    <%--<p id="add-k" class="plus-word btn-primary"><a href="#"><i class="fa fa-plus"></i>添加库存组</a></p>--%>
                                <%--</div>--%>
                            </header>
                            <%-- 遍历库存组 --%>

                        </div>
                        <div class="row"><!--删格化-->
                            <p class="right pr-30">
                                <input type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="返  回"
                                       onclick="javaScript:window.history.go(-1);">
                            </p>
                        </div>
                    </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</div>
<!-- footer -->
</body>
</html>
<script type="text/javascript">
    //是否有销售属性
    var hasSale = ${isSale};
    var stoActive = '${stoActive}';
    var stoStop = '${stoStop}';
    var stoDiscard = '${stoDiscard}';
    var pager;
    var count = '${count}';
    var standedProdId = "${standedProdId}";
    var productCatId = "${productCatId}";
    (function () {
        //弹出添加库存窗口储存数据
        $('#storAndStorGroup').delegate('input[name="addStorageShow"]', 'click', function () {
            var storGroupId = $(this).attr('storGroupId');
            var priorityNum = $(this).attr('priorityNum');
            var storageNum = $(this).attr('storageNum');
            console.log("storGroupId" + storGroupId + ",priorityNum" + priorityNum + ",storageNum:" + storageNum);
            //把当前点击对象数据储存到隐藏域
            $('#saveCache').attr("storGroupId", storGroupId);
            $('#saveCache').attr("priorityNum", priorityNum);
            $('#saveCache').attr("number", storageNum);
            //打开添加库存窗口
            $(".eject-big").show();
            $("#eject-samll-2").show();
            $(".eject-mask").show();
        });

        seajs.use('app/jsp/saleprice/salePriceEdit', function (salePriceEditPage) {
            pager = new salePriceEditPage({element: document.body});
            pager.render();
        });
    })();
</script>
