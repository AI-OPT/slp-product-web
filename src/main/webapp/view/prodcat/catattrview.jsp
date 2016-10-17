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
    <script type="text/javascript" src="${uedroot}/scripts/modular/fold.js"></script>
</head>
<body>
<div class="content-wrapper-iframe"><!--右侧灰色背景-->
    <!--框架标签结束-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                        <!--标题-->
                        <header class="main-box-header clearfix">
                            <h5 class="pull-left">所属类目：<c:forEach var="catInfo" items="${catLink}"
                                                                  varStatus="stat">${catInfo.productCatName}<c:if
                                    test="${!stat.last}">&gt;</c:if></c:forEach></h5>
                        </header>
                        <!--标题结束-->
                        <div class="relation-title main-box-header">关键属性</div>
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
                                        <tbody>
                                    <!--点击展开-->
                                    <tr>
                                        <td colspan="1" class="click right-none">
                                            <!--点击行为层-->
                                            <table width="40%" border="0"  class="table-border">
                                                <tr class="click">
                                                    <td style="min-width:2%;"  class="ctr border-bot-none text-l pl-20">
                                                        <A href="javascript:"><i class="fa fa-plus"></i></A>${attr.attrName}</td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="left-none text-l pl-40">${attr.serialNumber}</td>
                                        <!--点击行为层结束-->
                                    </tr>
                                    <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                    <tr class="zhank"  style=" display:none;">
                                        <td colspan="2" class="text-l pl-40">
                                            <table width="100%" border="0" >
                                                <c:forEach items="${attr.attrValList}" var="attrVal">
                                                <tr class="border-bot-none">
                                                    <td  width="65%" class="text-l pl-40">${attrVal.attrValueName}</td>
                                                    <td  width="35%" class="text-l pl-15">${attrVal.serialNumber}</td>
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
                        <div class="relation-title main-box-header">非关键属性</div>
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
                                        <tbody>
                                        <!--点击展开-->
                                        <tr>
                                            <td colspan="1" class="click right-none">
                                                <!--点击行为层-->
                                                <table width="40%" border="0"  class="table-border">
                                                    <tr class="click">
                                                        <td style="min-width:2%;"  class="ctr border-bot-none text-l pl-20">
                                                            <A href="javascript:"><i class="fa fa-plus"></i></A>${attr.attrName}
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="left-none text-l pl-40">${attr.serialNumber}</td>
                                            <!--点击行为层结束-->
                                        </tr>
                                        <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                            <tr class="zhank"  style=" display:none;">
                                                <td colspan="2" class="text-l pl-40">
                                                    <table width="100%" border="0" >
                                                        <c:forEach items="${attr.attrValList}" var="attrVal">
                                                            <tr class="border-bot-none">
                                                                <td  width="65%" class="text-l pl-40">${attrVal.attrValueName}</td>
                                                                <td  width="35%" class="text-l pl-15">${attrVal.serialNumber}</td>
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
</body>
</html>
