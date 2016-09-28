<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<c:set var="isSale" value="false"/>
<c:set var="setPrice" value="false"/>
<div class="eject-big">
    <div class="eject-medium" id="edit-medium">
        <div class="eject-medium-title">
            <p>商品销售价</p>
        </div>
        <div class="form-label">
        </div>
        <input type="hidden" id="upGroupId">
        <input type="hidden" id="upGroupPn">
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
                <input type="button" id="saveInfo" class="biu-btn  btn-primary  btn-auto  ml-5"
                       value="确  认">
                <input id="edit-close" type="button" onclick="pager._closeSkuPriceView();"
                       class="biu-btn  btn-primary  btn-auto  ml-5" value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<script id="skuInfoTemp" type="text/template">
    <tr>
        {{for valForSkuList}}
        <td>{{:valName}}</td>
        {{/for}}
        <td >
            {{if salePrice}}
                {{:~liToYuan(salePrice)}}
            {{else}}
            <input type="text" name="skuNum" skuId="{{:skuId}}"
                   class="int-text int-mini" maxlength="10"/>
            {{/if}}
        </td>
    </tr>
</script>

<div class="content-wrapper-iframe"><!--外围框架-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                        <div class="main-box-body clearfix">
                            <header class="main-box-header clearfix ">
                                <h5 class="pull-left">商品基础信息</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <!-- 类目链 -->
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">类目信息：</p>
                                        <p><c:forEach var="catInfo" items="${catLinkList}"
                                                      varStatus="stat">${catInfo.productCatName}
                                            <c:if test="${!stat.last}">&gt;</c:if></c:forEach>
                                        </p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">商品名称：</p>
                                        <p class="wide-field">${normProdInfo.productName}</p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">商品类型：</p>
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
                                        <li class="col-md-12">
                                            <p class="word3">${aav.key.attrName}：</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            <c:if test="${!saleAttr.isEmpty()}">
                                <c:set var="isSale" value="true"/>
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品销售属性</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${saleAttr}">
                                    <ul>
                                        <li class="col-md-12">
                                            <p class="word3">${aav.key.attrName}：</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            </c:if>
                            <%-- 遍历库存组 --%>
                            <div class="form-label table-responsive clearfix">
                                <table class="table table-border table-bordered">
                                    <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>库存组ID</th>
                                        <th>库存组名称</th>
                                        <th>总库存量</th>
                                        <th>库存ID</th>
                                        <th>库存名称</th>
                                        <th>状态</th>
                                        <th>优先级</th>
                                        <th>销售价(元)</th>
                                    </tr>
                                    </thead>
                                    <tbody id="searchNormProductData">
                                    <c:set var="itemGroup" value=""/>
                                    <c:forEach var="groupInfo" items="${groupList}" varStatus="status">
                                        <c:forEach var="storageSn" items="${groupInfo.storageList}">
                                            <c:set var="snNum" value="${storageSn.value.size()}"/>
                                            <c:forEach var="storage" items="${storageSn.value}" varStatus="status">
                                        <tr>
                                            <c:if test="${itemGroup != groupInfo.storageGroupId}">
                                                <c:set var="itemGroup" value="${groupInfo.storageGroupId}"/>
                                            <td rowspan="${groupInfo.storageNum}">${status.index+1}</td>
                                            <td rowspan="${groupInfo.storageNum}">${groupInfo.storageGroupId}</td>
                                            <td rowspan="${groupInfo.storageNum}">${groupInfo.storageGroupName}</td>
                                            <td rowspan="${groupInfo.storageNum}">${groupInfo.storageTotal}</td>
                                            </c:if>
                                            <td>${storage.storageId}</td>
                                            <td>${storage.storageName}</td>
                                            <td>${stoStatusMap.get(storage.state).columnDesc}</td>
                                            <c:if test="${status.index == 0}">
                                            <td rowspan="${snNum}">${storageSn.key}</td>
                                            <td rowspan="${snNum}">
                                                <c:choose>
                                                    <c:when test="${isSale==true}">
                                                        <a href="javaScript:void(0);" class="blue-border"
                                                           onclick="pager._showSkuPriceView('${groupInfo.storageGroupId}',${storageSn.key})">设置</a>
                                                    </c:when>
                                                    <%-- 无销售属性 --%>
                                                    <c:when test="${storage.salePrice!=null}">
                                                        <fmt:formatNumber value="${storage.salePrice/1000}" pattern="#,##0.00#"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="setPrice" value="true"/>
                                                        <input name="salePrice" type="text"  class="int-text int-mini" maxlength="10"
                                                               groupId="${groupInfo.storageGroupId}" stoSn="${storageSn.key}">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            </c:if>
                                        </tr>
                                            </c:forEach>
                                        </c:forEach>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                <div id="showMessageDiv"></div>
                            </div>
                        </div>
                        <div class="row"><!--删格化-->
                            <p class="center pr-30">
                                <c:if test="${setPrice==true}">
                                    <input id="submitAddBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5"
                                           value="提  交" />
                                </c:if>
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
            if (window.console) {
                console.log("storGroupId" + storGroupId + ",priorityNum" + priorityNum + ",storageNum:" + storageNum);
            }
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
