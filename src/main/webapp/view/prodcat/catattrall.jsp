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
</head>
<body>
<div class="content-wrapper-iframe">
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
                        <c:set var="letter" value="-1"/>
                        <!--标题结束-->
                        <c:forEach var="attr" items="${attrList}">
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
                                        <table width="20%" border="0">
                                            <tr class="click">
                                                <td width="2%" class="ahref border-bot-none"><A href="#"><i class="fa fa-plus"></i></A></td>
                                                <td width="1%" class="ctr1 border-bot-none"><input type="checkbox" class="margin-checkbox"></td>
                                                <td width="1%" class="ctr border-bot-none">${attr.attrName}</td>
                                            </tr>
                                        </table>
                                    </td>
                                    <!--点击行为层结束-->
                                </tr>
                                <!--点击行为表现层-->
                                <c:if test="${attr.valDefList!=null && attr.valDefList.size()>0}">
                                <tr class="zhank"  style=" display:none;">
                                    <td colspan="1" >
                                        <table width="100%" border="0">
                                            <tr >
                                                <td colspan="2"  class="border-bot-none">
                                                    <div class="relation-table-div">
                                                        <c:set var="valLetter" value="-1"/>
                                                        <c:set var="ind" value="1"/>
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
                                                                <c:set var="ind" value="${ind+1}"/>
                                                            <p><input type="checkbox" class="margin-checkbox m-left">${attrVal.attrValueName}</p>
                                                            <c:if test="${ind%10 == 0}">
                                                                </li>
                                                                </ul>
                                                                <ul><li>
                                                            </c:if>
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

                        </c:forEach>
                            </table>
                        </div>
                                    <!--/table表格结束-->
                                </div>
                        <!--按钮-->
                        <div class="row"><!--删格化-->
                            <p class="right pr-30">
                                <input type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5" value="保  存">
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
</html>
