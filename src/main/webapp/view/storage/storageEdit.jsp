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
<!--添加库存分组 弹出框  小-->
<div class="eject-big">
    <div class="eject-samll" id="eject-samll">
        <div class="eject-samll-title">
            <p>添加库存分组</p>
            <p class="img"><A href="javascript:void(0);"></A></p>
        </div>
        <div class="medium-list-form">
            <ul>
                <li>
                    <p>库存组名称</p>
                    <p><input id="storageGroupName" type="text" class="int-text int-medium"></p>
                </li>

            </ul>
        </div>
        <div class="eject-samll-confirm mt-0">
            <ul>
                <li><input id="addStorGroup" type="button" class="slp-btn eject-small-btn" value="确认">
                    <input type="button" class="slp-btn eject-small-btn close-btn" value="取消">
                </li>
            </ul>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<!--/结束-->
<!--编辑库存分组 弹出框  小-->
<div class="eject-big">
    <div class="eject-samll" id="up-group-name">
        <div class="eject-medium-title">
            <p>编辑名称</p>
            <p class="img"><i class="fa fa-times" onclick="pager._closeUpGroupView();"></i></p>
        </div>
        <input type="hidden" id="upGroupId">
        <div class="form-label mt-10">
            <ul>
                <li>
                    <p class="word"><span>*</span>库存组名称:</p>
                    <p><input id="upGroupName" type="text" class="int-text int-small"></p>
                </li>
            </ul>
        </div>
        <div class="row mt-15">
            <p class="center pr-30 mt-30">
                <input type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
                <input id="add-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 edit-close" value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<!--增加库存 弹出框  小-->
<div class="eject-big">
    <div class="eject-samll" id="eject-samll-2">
        <div class="eject-samll-title">
            <p>增加库存</p>
            <p class="img"><A href="javascript:void(0);"></A></p>
        </div>
        <div class="eject-form">
            <ul>
                <li class="width-xlag">
                    <p class="word"><span>*</span>库存名称:</p>
                    <p><input id="newStorageName" type="text" class="int-text int-medium"></p>
                </li>
                <li class="width-xlag">
                    <p class="word"><span>*</span>虚拟库存量:</p>
                    <p><input id="newTotalNum" type="text" class="int-text int-medium"></p>
                </li>
                <li class="width-xlag">
                    <p class="word"><span>*</span>最低预警库存值:</p>
                    <p><input id="newWarnNum" type="text" class="int-text int-medium"></p>
                </li>
                <li class="width-xlag">
                    <p class="word">有效期:</p>
                    <p><input type="text" class="int-text int-mini"><i class="icon-calendar"></i></p>
                    <p><input type="text" class="int-text int-mini"><i class="icon-calendar"></i></p>
                </li>
            </ul>
        </div>
        <div class="eject-samll-confirm mt-0">
            <ul>
                <li><input id="addStorage" type="button" class="slp-btn eject-small-btn mt-10" value="确认">
                    <input type="button" class="slp-btn eject-small-btn close-btn mt-10" value="取消">
                </li>
            </ul>
        </div>
    </div>
    <div class="mask"></div>
</div>
<!--/结束-->
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
                            <c:forEach var="stoGroup" items="${storGroupList}">
                                <div class="setup-sku">
                                    <ul>
                                        <li>
                                            <p>库存组名称:${stoGroup.storageGroupName}</p>
                                            <p><input type="button" class="biu-btn  btn-primary  btn-auto " groupId="${stoGroup.storageGroupId}"
                                                      name="upGroupName" value="编辑名称 " /></p>
                                            <p>总库存量:${stoGroup.storageTotal}</p>
                                            <%--<p><input type="button" class="biu-btn  btn-primary  btn-auto " value="设置sku " /></p>--%>
                                            <p><input type="button" class="biu-btn  btn-primary  btn-auto " value="增加优先级 " /></p>
                                            <p>状态:${stoGroup.stateName}</p>
                                        </li>
                                    </ul>
                                </div>
                            </c:forEach>
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
            <tr id="{{:storageGroupId }}_{{:number }}">
                <td colspan="9">
                    <div class="setup-sku mg-0">
                        <ul>
                            <li>
                                <p>优先级 {{:number }}</p>
                                <p><a href="javascript:void(0);"><img src="${_slpres }/images/down.png"/></a></p>
                                <p><a href="javascript:void(0);"><img src="${_slpres }/images/up.png"/></a></p>
                                <p><input name="addStorageShow" type="button" class="biu-btn btn-blue stock-btn"
                                          id="small-eject3" value="增加库存" storGroupId="{{:storageGroupId }}"
                                          priorityNum="{{:number }}" storageNum="0"></p>
                                <p>
                                    <span><input type="checkbox" class="checkbox-medium"/></span>
                                    <span>促销活动</span>
                                </p>
                                <p class="eject-int">
                                    <input type="input" class="int-text int-mini">
                                    <a href="javascript:void(0);"><i class="icon-calendar"></i></a></p>
                                <p class="eject-int">~</p>
                                <p class="eject-int">
                                    <input type="input" class="int-text int-mini">
                                    <a href="javascript:void(0);"><i class="icon-calendar"></i></a></p>
                                <p class="word">(没有结束时间可不填)</p>
                            </li>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr class="bj">
                <td>序号</td>
                <td>库存ID</td>
                <td>库存名称</td>
                <td><span>*</span>虚拟库存量</td>
                <td>生效时间</td>
                <td>失效时间</td>
                <td><span>*</span>最低预警库存量</td>
                <td>状态</td>
                <td>操作</td>
            </tr>
        </script>
</html>
<script type="text/javascript">
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
            console.log("groupId: " + groupId + ",priorityNum:" + priorityNum);
            pager._addPriorityNumber(groupId, priorityNum);
        });
        seajs.use('app/jsp/storage/storageEdit', function (StorageEditPager) {
            pager = new StorageEditPager({element: document.body});
            pager.render();
        });
    })();
</script>
