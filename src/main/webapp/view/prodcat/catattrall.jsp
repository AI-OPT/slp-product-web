<%--
  Created by IntelliJ IDEA.
  User: jackieliu
  Date: 16/8/16
  Time: 下午6:42
  To change this template use File | Settings | File Templates.
  显示所有的属性及属性值信息
--%>
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
    <style>
        <%-- 原css文件样式不正常,所以在这里自定义 --%>
        .relation-table-div ul li{float:left;text-align:left;padding-left: 85px;}
    </style>
</head>
<body style="min-height: 2000px;">
<div class="content-wrapper-iframe">
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div id="attrDivView" class="main-box clearfix"><!--白色背景-->
                        <!--标题-->
                        <header class="main-box-header clearfix">
                            <h5 class="pull-left">所属类目：<c:forEach var="catInfo" items="${catLink}"
                                                                  varStatus="stat">${catInfo.productCatName}<c:if
                                    test="${!stat.last}">&gt;</c:if></c:forEach></h5>
                        </header>
                        <c:set var="letter" value="-1"/>
                        <!--标题结束-->
                        <c:forEach var="attr" items="${attrList}">
                            <%-- 如果属性未被其他使用,则显示 --%>
                            <c:if test="${otherSet.contains(attr.attrId) == false}">
                            <c:set var="isCheck" value="${nowMap.containsKey(attr.attrId)}"/>
                            <c:if test="${attr.firstLetter != letter}">
                                <c:if test="${letter!='-1'}">
                                    </table>
                                    </div>
                                    <!--/table表格结束-->
                                </div>
                                </c:if>
                                <c:set var="letter" value="${attr.firstLetter}"/>
                                <div class="main-box-body clearfix">
                        <div class="table-responsive clearfix relation-special">
                            <table width="100%" border="0"  class="table table-hover  table-bordered table-special">
                                <thead>
                                <tr class="bj">
                                    <th colspan="2" style="text-align:left; padding-left:10px;">${attr.firstLetter}</th>
                                </tr>
                                </thead>
                            </c:if>
                                <tbody>
                                <!--点击展开-->
                                <tr>
                                    <td colspan="2" class="click">
                                        <!--点击行为层-->
                                        <table width="100%" border="0">
                                            <tr class="click">
                                                <td width="2%" class="ahref border-bot-none">
                                                    <A href="javaScript:void(0);"><i class="fa fa-plus"></i></A></td>
                                                <td width="1%" class="ctr1 text-c border-bot-none">
                                                    <input name="attrCheck" type="checkbox" class="margin-checkbox"
                                                    <c:if test="${isCheck}">checked="true"</c:if> value="${attr.attrId}">
                                                </td>
                                                <td width="20%" class="ctr text-l border-bot-none">${attr.attrName}</td>
                                            </tr>
                                        </table>
                                    </td>
                                    <!--点击行为层结束-->
                                </tr>
                                <!--点击行为表现层-->
                                <c:if test="${attr.valDefList!=null && attr.valDefList.size()>0}">
                                    <c:set var="valList" value="${nowMap.get(attr.attrId)}"/>
                                <tr class="zhank"  style=" display:none;">
                                    <td colspan="1" >
                                        <table width="100%" border="0">
                                            <tr >
                                                <td colspan="2"  class="border-bot-none">
                                                    <div class="relation-table-div">
                                                        <c:set var="valLetter" value="-1"/>
                                                        <c:forEach var="attrVal" items="${attr.valDefList}" >
                                                            <c:if test="${attrVal.firstLetter != valLetter}">
                                                                <c:if test="${valLetter!='-1'}">
                                                                    </li>
                                                                    </ul>
                                                                </c:if>
                                                                <c:set var="valLetter" value="${attrVal.firstLetter}"/>
                                                                <c:set var="ind" value="1"/>
                                                                <ul>
                                                                    <li>${attrVal.firstLetter}</li>
                                                                </ul>
                                                                <ul>
                                                                <li>
                                                            </c:if>
                                                            <p><input name="valCheck" type="checkbox" class="margin-checkbox m-left"
                                                                <c:if test="${isCheck && valList.contains(attrVal.attrvalueDefId)}">checked="true"</c:if>
                                                                attrId="${attr.attrId}" value="${attrVal.attrvalueDefId}">${attrVal.attrValueName}</p>
                                                        </c:forEach>
                                                                </li>
                                                                </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                </c:if>
                                <!--点击行为表现层结束-->
                                </tbody>
                                </td>
                                </c:if>
                        </c:forEach>
                                <c:if test="${letter != '-1'}">
                            </table>
                        </div>
                                    </c:if>
                                    <!--/table表格结束-->
                                </div>
                        <!--按钮-->
                        <div class="row"><!--删格化-->
                            <p class="center pr-30">
                                <input id="sumBtn" type="button"
                                       class="biu-btn  btn-primary btn-blue btn-auto  ml-5" value="保  存">
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
<script type="text/javascript" src="${uedroot}/scripts/modular/fold.js"></script>
<script>
    var catId = '${catId}';
    var attrType = '${attrType}';
    var pager;
    var catNum = {'num':0};
    (function () {
        <%-- 属性值点击 --%>
        $('#attrDivView').delegate("input:checkbox[name='valCheck']", 'click', function () {
            pager._clickAttrVal($(this));
        });
        <%-- 属性点击 --%>
        $('#attrDivView').delegate("input:checkbox[name='attrCheck']",'click',function(){
            pager._clickAttr($(this));
        });

        seajs.use('app/jsp/prodcat/catattrall', function (catattrallPage) {
            pager = new catattrallPage({element: document.body});
            pager.render();
        });
    })();
</script>
</html>
