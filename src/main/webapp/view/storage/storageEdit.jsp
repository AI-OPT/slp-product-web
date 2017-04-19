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
<form id="storageForm"  method="post">
    <div class="eject-medium" id="edit-medium">
        <div class="eject-medium-title">
            <p id="editTitle">编辑库存</p>
           <!--  <p class="img" onclick="pager._closeAddStoView();"><i class="fa fa-times"></i></p> -->
        </div>
        <div class="form-label">
            <input type="hidden" id="storageId">
            <input type="hidden" id="stoAddGroupId">
            <input type="hidden" id="stoAddGroupPn">
            <ul>
                <li>
                    <p class="word"><span>*</span>库存名称</p>
                    <p><input type="text" id="newStorageName" class="int-text int-small" maxlength="15"
                    required data-msg-required="库存名称不能为空"  commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
                    onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"
                    ></p>
                </li>
            </ul>
            <ul>
                <li>
                    <p class="word"><span>*</span>库存量</p>
                    <p><input type="text" id="newTotalNum" class="int-text int-small" value="0"
                              <c:if test="${!saleAttr.isEmpty()}">readonly</c:if> maxlength="10"  
                              onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
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
    </form>
    <div class="mask" id="eject-mask"></div>
</div>


<!--查看信息弹出框-->
<div class="eject-big">
<form id="storageForm"  method="post">
    <div class="eject-medium" id="showss-medium">
        <div class="eject-medium-title">
            <p id="editTitle">查看库存</p>
           <!--  <p class="img" onclick="pager._closeAddStoView();"><i class="fa fa-times"></i></p> -->
        </div>
        <div class="form-label">
            <input type="hidden" id="storageId">
            <input type="hidden" id="stoAddGroupId">
            <input type="hidden" id="stoAddGroupPn">
            <ul>
                <li>
                    <p class="word"><span>*</span>库存名称</p>
                    <p><input type="text" id="StorageName" class="int-text int-small" maxlength="15"
                    required data-msg-required="库存名称不能为空"  commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
                    onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"
                    ></p>
                </li>
            </ul>
            <ul>
                <li>
                    <p class="word"><span>*</span>库存量</p>
                    <p><input type="text" id="TotalNum" class="int-text int-small" value="0"
                              <c:if test="${!saleAttr.isEmpty()}">readonly</c:if> maxlength="10"  
                              onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></p>
                </li>
            </ul>
        </div>
        <c:set var="isSale" value="false"/>
 <%--    <c:if test="${!saleAttr.isEmpty()}">
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
    </c:if> --%>
        <!--/table表格结束-->
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <!-- <input type="button" id="addStorage" class="biu-btn  btn-primary  btn-auto  ml-5"
                       onclick="pager._addStorage();" value="确  认"> -->
                <input id="edit-close" type="button" onclick="pager._closeAddStoViewss();"
                       class="biu-btn  btn-primary  btn-auto  ml-5" value="返 回">
            </p>
        </div>
    </div>
    </form>
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
                    class="int-text int-mini"  value="0" maxlength="8"/></td>
    </tr>
</script>
<!-- 查看库存信息 -->
<div class="eject-big">
    <div class="eject-medium" id="info-medium">
        <div class="eject-medium-title">
            <p>库存信息</p>
            <!-- <p class="img" onclick="pager._closeStorageInfo();"><i class="fa fa-times"></i></p> -->
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
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">库存设置</h5>
                                <%--<div class="title-right">--%>
                                    <%--<p id="add-k" class="plus-word btn-primary"><a href="#"><i class="fa fa-plus"></i>添加库存组</a></p>--%>
                                <%--</div>--%>
                            </header>
                            <%-- 遍历库存组 --%>
                            <c:forEach var="stoGroup" items="${storGroupList}">
                                <c:set var="noDicard" value="true"/>
                                <%-- 库存组已废弃 --%>
                                <c:if test="${stoGroup.state=='3' || stoGroup.state=='31'}">
                                    <c:set var="noDicard" value="false"/>
                                </c:if>
                            <div class="table-responsive clearfix">
                                <table width="100%" border="0" class="table table-hover table-border table-bordered">
                                    <tbody id="tbGroupSn${stoGroup.storageGroupId}">
                                    <tr>
                                        <td colspan="9">
                                            <div class="setup-sku sku-bot-none">
                                                <ul>
                                                    <li>
                                                        <p>库存组</p>
                                                        <p>总库存量：${stoGroup.storageTotal}</p>
                                                        <c:if test="${noDicard}">
                                                        <p><input type="button" onclick="pager._addPriorityNumber('${stoGroup.storageGroupId}')"
                                                                  class="biu-btn  btn-primary  btn-auto" value="增加优先级 ">
                                                        </p>
                                                        <p>
                                                            <%-- 若为启用或自动启用,则显示停用 --%>
                                                            <c:set var="statusBtn" value="启用"/>
                                                            <c:set var="statusVal" value="1"/>
                                                            <c:if test="${stoGroup.state == '1' || stoGroup.state == '11'}">
                                                                <c:set var="statusBtn" value="停用"/>
                                                                <c:set var="statusVal" value="2"/>
                                                            </c:if>
                                                            <input type="button" groupId="${stoGroup.storageGroupId}"
                                                                       groupStatus = "${statusVal}" onclick="pager._changeGroupStatus(this);"
                                                                       class="biu-btn  btn-primary  btn-auto" value="${statusBtn}">
                                                        </p>
                                                        </c:if>
                                                        <p>状态：${stoGroup.stateName}</p>
                                                    </li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <%-- 优先级 --%>
                                    <c:set value="0" var="groupSn"/>
                                    <c:forEach var="storageMap" items="${stoGroup.storageList}">
                                        <c:if test="${groupSn < storageMap.key}">
                                            <c:set value="${storageMap.key}" var="groupSn"/>
                                        </c:if>
                                        <tr>
                                            <td colspan="9">
                                                <div class="setup-sku sku-bot-none">
                                                    <ul>
                                                        <li>
                                                            <p>优先级${storageMap.key}</p>
                                                            <c:if test="${noDicard}">
                                                            <p>
                                                                <input type="button" name="groupSn${stoGroup.storageGroupId}"
                                                                      class="biu-btn  btn-primary  btn-auto" pn="${storageMap.key}"
                                                                      value="增加库存" onclick="pager._showAddStoView('${stoGroup.storageGroupId}',${storageMap.key});">
                                                            </p>
                                                            </c:if>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr class="bj">
                                            <td>序号</td>
                                            <td>库存ID</td>
                                            <td>库存名称</td>
                                            <td>库存量</td>
                                            <td>库存可用量</td>
                                            <td>状态</td>
                                            <td>操作</td>
                                        </tr>
                                        <c:forEach var="storage" items="${storageMap.value}" varStatus="status">
                                            <tr name="stopn_${stoGroup.storageGroupId}_${storageMap.key}">
                                                <td>${status.index + 1}</td>
                                                <td>${storage.storageId}</td>
                                                <td id="stoName${storage.storageId}">${storage.storageName}</td>
                                                <td>${storage.totalNum}</td>
                                                <td>${storage.usableNum}</td>
                                                <td>${storage.stateName}</td>
                                                <td>
                                                    <c:choose>
                                                        <%-- 废弃\自动废弃状态 --%>
                                                        <c:when test="${storage.state == '3' || storage.state == '31'}">
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               storageId="${storage.storageId}" groupId="${stoGroup.storageGroupId}"
                                                               onclick="pager._showStorageInfoss(this)">查看</a>
                                                        </c:when>
                                                        <%-- 启用\自动启用状态 --%>
                                                        <c:when test="${storage.state == '1' || storage.state == '11'}">
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               storageId="${storage.storageId}" groupId="${stoGroup.storageGroupId}"
                                                               onclick="pager._showStorageEdit(this);">编辑</a>
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               statue="${stoStop}" storageId="${storage.storageId}"
                                                               onclick="pager._changeStoStatus(this)">停用</a>
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               statue="${stoDiscard}" storageId="${storage.storageId}"
                                                               onclick="pager._changeStoStatus(this)">废弃</a>
                                                        </c:when>
                                                        <%-- 停用状态 --%>
                                                        <c:when test="${storage.state == '2'}">
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               storageId="${storage.storageId}" groupId="${stoGroup.storageGroupId}"
                                                               onclick="pager._showStorageEdit(this);">编辑</a>
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               statue="${stoActive}" storageId="${storage.storageId}"
                                                               onclick="pager._changeStoStatus(this)">启用</a>
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               statue="${stoDiscard}" storageId="${storage.storageId}"
                                                               onclick="pager._changeStoStatus(this)">废弃</a>
                                                        </c:when>
                                                        <%-- 自动停用状态 --%>
                                                        <c:when test="${storage.state == '21'}">
                                                            <a href="javaScript:void(0);"  class="blue"
                                                               storageId="${storage.storageId}" groupId="${stoGroup.storageGroupId}"
                                                               onclick="pager._showStorageEdit(this);">编辑</a>
                                                            <a href="#"  class="blue"
                                                               statue="${stoDiscard}" storageId="${storage.storageId}"
                                                               onclick="pager._changeStoStatus(this)">废弃</a>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:forEach>
                                    <input type="hidden" id="groupSn${stoGroup.storageGroupId}" value="${groupSn}">
                                    </tbody>
                                </table>
                                <%-- 库存最高优先级 --%>

                            </div>
                                <br/>
                            </c:forEach>
                        </div>
                        <div class="row"><!--删格化-->
                            <p class="center pr-30">
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
<script id="storageTemple" type="text/template">
            <tr id="{{:storageGroupId }}{{:priorityNumber }}{{:number }}">
                <td>{{:number }}</td>
                <td>{{:storageId }}</td>
                <td>{{:storageName }}</td>
                <td>{{:totalNum }}</td>
                <td>{{:activeTime }}</td>
                <td>{{:inactiveTime }}</td>
                <td>{{:warnNum }}</td>
                <td>{{:stateName }}</td>
                {{if state == '3' || state=='31'}}
                <td><a href="javascript:void(0);" class="blue">查看</a></td>
                {{else}}
                <td><a href="javascript:void(0);" class="blue">编辑</a>
                    <a href="javascript:void(0);" class="blue">启用</a>
                    <a href="javascript:void(0);" class="blue">废弃</a>
                    <a href="javascript:void(0);" class="blue">管理预警接收人</a>
                </td>
                {{/if}}
            </tr>
        </script>
        <script id="storGroupTemple" type="text/template">
            <tbody id="{{:storageGroupId }}">
            <tr>
                <td colspan="9">
                    <div class="setup-sku mg-0">
                        <ul>
                            <li>
                                <p>库存组名称:{{:storageGroupName }}</p>
                                <p id="small-eject2">
                                    <input type="button" class="biu-btn btn-blue stock-btn" value="编辑名称 "></p>
                                <p>总库存量:{{:storageTotal }}</p>
                                <p><input name="addPriorityNumber" type="button" class="biu-btn btn-blue stock-btn"
                                          value="增加优先级 " storGroupId="{{:storageGroupId }}" priorityNum="0"></p>
                                <p><input type="button" class="biu-btn btn-blue stock-btn" value="启动 "></p>
                                <p id="small-eject4">
                                    <input type="button" class="biu-btn btn-blue stock-btn" value="废弃 "></p>
                                <p>状态:{{:stateName }}</p>
                            </li>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr id="{{:storageGroupId }}priorityDemo"></tr>
            </tbody>
        </script>
        <script id="priorityNumTemple" type="text/template">
            <tr>
                <td colspan="9">
                    <div class="setup-sku sku-bot-none">
                        <ul>
                            <li>
                                <p>优先级{{:priNum}}</p>
                                    <p><input type="button" groupId="{{:groupId}}"
                                              class="biu-btn  btn-primary  btn-auto" pn="{{:priNum}}"
                                               value="增加库存" onclick="pager._showAddStoView('{{:groupId}}',{{:priNum}});"></p>
                            </li>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr class="bj">
                <td>序号</td>
                <td>库存ID</td>
                <td>库存名称</td>
                <td>库存量</td>
                <td>库存可用量</td>
                <td>状态</td>
                <td>操作</td>
            </tr>
        </script>
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
        //编辑库存组名称
        $('.setup-sku').delegate('input[name="upGroupName"]', 'click', function () {
//            pager._showUpGroupView($(this));
            var groupId=$(this).attr("groupId");
            $("upGroupId").val(groupId);
            var name = $(this).parent().prev().text();
            name = name.substring(6);
            $("#upGroupName").val(name);
            $('#eject-mask').fadeIn(100);
            $('#up-group-name').slideDown(200);
        });
        //增加优先级
        $('.setup-sku').delegate('input[name="addPriorityNumber"]', 'click', function () {
            var groupId = $(this).attr('storGroupId');
            var priorityNum = $(this).attr('priorityNum');
            if (window.console) {
                console.log("groupId: " + groupId + ",priorityNum:" + priorityNum);
            }
            pager._addPriorityNumber(groupId, priorityNum);
        });

        seajs.use('app/jsp/storage/storageEdit', function (StorageEditPager) {
            pager = new StorageEditPager({element: document.body});
            pager.render();
        });
    })();
</script>
