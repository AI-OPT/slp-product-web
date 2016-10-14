<%@ page import="com.ai.slp.product.web.constants.ProductCatConstants" %>
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
<!--提示弹出框-->
<div class="eject-big" id="choice">
    <div class="prompt-samll" id="p-operation">
        <div class="eject-medium-title">
            <p>提示操作</p>
            <p class="img"><i class="fa fa-times"></i></p>
        </div>
        <!--确认删除-->
        <div class="prompt-samll-confirm">
            <ul>
                <li><img src="${uedroot}/images/warning.png"></li>
                <li class="word">至少选择一个部门进行操作！</li>
                <li>
                    <input id="p-op-close" type="button"  class="biu-btn btn-primary btn-small ml-15 mt-20 radius" value="确认">
            </ul>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<div class="content-wrapper-iframe"><!--右侧灰色背景-->
    <!--框架标签结束-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div id="mainBoxDiv" class="main-box clearfix"><!--白色背景-->
                        <!--标题-->
                        <c:set var="parnetCat" value=""/>
                        <header class="main-box-header clearfix">
                            <h5 class="pull-left">所属类目：<c:forEach var="catInfo" items="${catLink}"
                                                                  varStatus="stat">${catInfo.productCatName}<c:if
                                    test="${!stat.last}">&gt;<c:set var="parnetCat" value="${catInfo.productCatId}"></c:set> </c:if></c:forEach></h5>
                        </header>
                        <form id="catAttrEditForm">
                        <input type="hidden" name="catId" id="catId" value="${catId}">
                        <!--标题结束-->
                        <div class="relation-title main-box-header">关键属性(添加保存标准品后，关键属性不可修改，请认真选择）
                            <a href="${_base}/cat/query/attr/view/${catId}?attrType=<%=ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY%>">选择属性</a></div>
                        <div class="main-box-body clearfix">
                            <!--table表格-->
                            <div class="table-responsive clearfix relation-special">
                                <table width="100%" border="0" class="table table-hover  table-bordered table-special">
                                    <tr class="bj">
                                        <thead>
                                        <th width="60%" class="right-none text-c"  align="center">属性</th>
                                        <th width="40%" class="left-none text-c"  align="center">排序(只限填大于0小于1000的整数，值越小，排序越靠前)</th>
                                        </thead>
                                    </tr>

                                    <c:forEach var="attr" items="${keyAttr}">
                                        <tbody id="attrTbody1_${attr.catAttrId}">
                                    <!--点击展开-->
                                    <tr>
                                        <td colspan="1" class="click right-none">
                                            <!--点击行为层-->
                                            <table width="60%" border="0"  class="table-border">
                                                <tr class="click">
                                                    <td style="min-width:2%;"  class="ctr border-bot-none text-l pl-20">
                                                        <A href="javascript:"><i class="fa fa-plus"></i></A>${attr.attrName}<i class="fa fa-times i-close" catAttrId="${attr.catAttrId}"></i>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="left-none text-l pl-40">
                                            <input type="text" class="int-text int-mini" min="1" max="999" maxlength="3"
                                                   catAttrId="${attr.catAttrId}" name="keyAttrSn_${attr.catAttrId}"
                                                   placeholder="属性排序" value="${attr.serialNumber}" snType="attrSn"
                                                   digits="true" required data-msg="请输入1至999的整数"
                                            >
                                        </td>
                                        <!--点击行为层结束-->
                                    </tr>
                                    <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                    <tr class="zhank"  style=" display:none;">
                                        <td colspan="2" class="text-l pl-40">
                                            <table width="100%" border="0" >
                                                <c:forEach items="${attr.attrValList}" var="attrVal">
                                                <tr id="attrValTr2_${attrVal.catAttrValId}" class="border-bot-none">
                                                    <td  width="65%" class="text-l pl-40">${attrVal.attrValueName}
                                                        <i class="fa fa-times i-close1" catAttrValId="${attrVal.catAttrValId}"></i></td>
                                                    <td  width="35%" class="text-l pl-15">
                                                        <input type="text" class="int-text int-mini" placeholder="属性值排序"
                                                               catAttrValId="${attrVal.catAttrValId}" snType="attrValSn"
                                                               name="keyValSn_${attr.catAttrId}_${attrVal.catAttrValId}"
                                                               value="${attrVal.serialNumber}" min="1" max="999" maxlength="3"
                                                               digits="true" required data-msg="请输入1至999的整数"
                                                        >
                                                    </td>
                                                </tr>
                                                </c:forEach>
                                            </table>
                                        </td>
                                    </tr>
                                        </c:if>
                                    </tbody>
                                    </c:forEach>
                                    <!--点击行为表现层结束-->
                                </table>
                            </div>
                            <!--/table表格结束-->
                        </div>
                        <div class="relation-title main-box-header">非关键属性
                            <a href="${_base}/cat/query/attr/view/${catId}?attrType=<%=ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_NONKEY%>">选择属性</a></div>
                        <div class="main-box-body clearfix">
                            <!--table表格-->
                            <div class="table-responsive clearfix relation-special">
                                <table width="100%" border="0" class="table table-hover  table-bordered table-special">
                                    <tr class="bj">
                                        <thead>
                                        <th width="60%" class="right-none text-c"  align="center">属性</th>
                                        <th width="40%" class="left-none text-c"  align="center">排序(只限填大于0小于1000的整数，值越小，排序越靠前)</th>
                                        </thead>
                                    </tr>
                                    <c:forEach var="attr" items="${noKeyAttr}">
                                        <tbody id="attrTbody1_${attr.catAttrId}">
                                        <!--点击展开-->
                                        <tr>
                                            <td colspan="1" class="click right-none">
                                                <!--点击行为层-->
                                                <table width="60%" border="0"  class="table-border">
                                                    <tr class="click">
                                                        <td style="min-width:2%;"  class="ctr border-bot-none text-l pl-20">
                                                            <A href="javascript:"><i class="fa fa-plus"></i></A>${attr.attrName}<i class="fa fa-times i-close" catAttrId="${attr.catAttrId}"></i>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="left-none text-l pl-40">
                                                <input type="text" class="int-text int-mini" min="1" max="999" maxlength="3"
                                                       catAttrId="${attr.catAttrId}" name="noKeyAttrSn_${attr.catAttrId}"
                                                       placeholder="属性排序" value="${attr.serialNumber}" snType="attrSn"
                                                       digits="true" required data-msg="请输入1至999的整数"
                                                >
                                            </td>
                                            <!--点击行为层结束-->
                                        </tr>
                                        <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                            <tr class="zhank"  style=" display:none;">
                                                <td colspan="2" class="text-l pl-40" >
                                                    <table width="100%" border="0" >
                                                        <c:forEach items="${attr.attrValList}" var="attrVal">
                                                            <tr id="attrValTr2_${attrVal.catAttrValId}" class="border-bot-none">
                                                                <td  width="65%" class="text-l pl-40">${attrVal.attrValueName}
                                                                    <i class="fa fa-times i-close1" catAttrValId="${attrVal.catAttrValId}"></i></td>
                                                                <td  width="35%" class="text-l pl-15">
                                                                    <input type="text" class="int-text int-mini" placeholder="属性值排序"
                                                                           catAttrValId="${attrVal.catAttrValId}"  snType="attrValSn"
                                                                           name="noKeyValSn_${attr.catAttrId}_${attrVal.catAttrValId}"
                                                                           value="${attrVal.serialNumber}" min="1" max="999" maxlength="3"
                                                                           digits="true" required data-msg="请输入1至999的整数"
                                                                    >
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </table>
                                                </td>
                                            </tr>
                                        </c:if>
                                        </tbody>
                                    </c:forEach>
                                    <!--点击行为表现层结束-->
                                </table>

                            </div>
                            <!--/table表格结束-->
                        </div>
                        </form>
                        <div class="row"><!--删格化-->
                            <p class="center pr-30">
                                <input id="sumBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="保  存"/>
                                <input type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="返  回"
                                       onclick="pager._backList();">
                            </p>
                        </div>
                    </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript" src="${uedroot}/scripts/modular/fold.js"></script>
<script>
    var pager;
    var catId = "${catId}";
    var parnetCat = "${parnetCat}";
    var catNum = {'num':0};
    (function () {
        <%-- 属性删除按钮 --%>
        $('#mainBoxDiv').delegate(".i-close", 'click', function () {
            var id= $(this).attr('catAttrId');
            var objType = "1";
            if (window.console) {
                console.log("删除属性,id=" + id);
            }
            pager._delAttrOfVal(id,objType);
        });

        $('#mainBoxDiv').delegate(".i-close1", 'click', function () {
            var id=$(this).attr('catAttrValId');
            var objType = "2";
            if (window.console) {
                console.log("删除属性值,id=" + id);
            }
            pager._delAttrOfVal(id,objType);
        });
        seajs.use('app/jsp/prodcat/catattredit', function (catattredit) {
            pager = new catattredit({element: document.body});
            pager.render();

        });
    })();
</script>
</html>
