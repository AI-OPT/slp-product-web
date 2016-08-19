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
<div class="content-wrapper-iframe"><!--右侧灰色背景-->
    <!--框架标签结束-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div id="mainBoxDiv" class="main-box clearfix"><!--白色背景-->
                        <!--标题-->
                        <header class="main-box-header clearfix">
                            <h5 class="pull-left">所属类目：<c:forEach var="catInfo" items="${catLink}"
                                                                  varStatus="stat">${catInfo.productCatName}<c:if
                                    test="${!stat.last}">&gt;</c:if></c:forEach></h5>
                        </header>
                        <input type="hidden" name="catId" id="catId" value="${catId}">
                        <!--标题结束-->
                        <div class="relation-title main-box-header">1、关键属性(添加保存标准品后，关键属性不可修改，请认真选择）
                            <a href="${_base}/cat/query/attr/view/${catId}?attrType=<%=ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_KEY%>">选择属性</a></div>
                        <div class="main-box-body clearfix">
                            <!--table表格-->
                            <div class="table-responsive clearfix relation-special">
                                <table width="100%" border="0" class="table table-hover  table-bordered table-special">
                                    <tr class="bj">
                                        <thead>
                                        <th width="40%" class="right-none text-c"  align="center">属性</th>
                                        <th width="60%" class="left-none text-c"  align="center">排序(只限填大于0小于1000的整数，值越小，排序越靠前)</th>
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
                                                    <td width="2%" class="ahref border-bot-none"><A href="#"><i class="fa fa-plus"></i></A></td>
                                                    <td width="2%" class="ctr border-bot-none">${attr.attrName}</td>
                                                    <td width="1%" ><i class="fa fa-times i-close" catAttrId="${attr.catAttrId}"></i></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="left-none">
                                            <input type="number" class="int-text int-mini" min="0" max="1000"
                                                   catAttrId="${attr.catAttrId}" name="attrSn"
                                                   placeholder="属性排序" value="${attr.serialNumber}">
                                        </td>
                                        <!--点击行为层结束-->
                                    </tr>
                                    <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                    <tr class="zhank"  style=" display:none;">
                                        <td colspan="2" >
                                            <table width="100%" border="0" >
                                                <c:forEach items="${attr.attrValList}" var="attrVal">
                                                <tr class="border-bot-none">
                                                    <td  width="45%" class="right-text">${attrVal.attrValueName}
                                                        <i class="fa fa-times i-close1" catAttrValId="${attrVal.catAttrValId}"></i></td>
                                                    <td  width="55%">
                                                        <input type="number" class="int-text int-mini" placeholder="属性值排序"
                                                               catAttrValId="${attrVal.catAttrValId}" name="attrValSn"
                                                               value="${attrVal.serialNumber}" min="0" max="1000">
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
                        <div class="relation-title main-box-header">2、销售属性（添加保存标准品后，关键属性不可修改，请认真选择）
                            <a href="${_base}/cat/query/attr/view/${catId}?attrType=<%=ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_SALE%>">选择属性</a></div>
                        <div class="main-box-body clearfix">
                            <!--table表格-->
                            <div class="table-responsive clearfix relation-special">
                                <table width="100%" border="0" class="table table-hover  table-bordered table-special">
                                    <tr class="bj">
                                        <thead>
                                        <th width="30%" class="right-none text-c"  align="center">属性</th>
                                        <th width="40%" class="left-none right-none text-c" align="center">排序(只限填大于0小于1000的整数，值越小，排序越靠前)</th>
                                        <th width="30%" class="left-none right-none text-c" >是否需要上传图片</th>
                                        </thead>
                                    </tr>

                                    <!--点击展开-->
                                    <c:forEach var="attr" items="${saleAttr}">
                                    <tbody>
                                        <!--点击展开-->
                                        <tr>
                                            <td colspan="1" class="click right-none">
                                                <!--点击行为层-->
                                                <table width="40%" border="0"  class="table-border">
                                                    <tr class="click">
                                                        <td width="2%" class="ahref border-bot-none"><A href="#"><i class="fa fa-plus"></i></A></td>
                                                        <td width="2%" class="ctr border-bot-none">${attr.attrName}</td>
                                                        <td width="1%" ><i class="fa fa-times i-close" catAttrId="${attr.catAttrId}"></i></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="left-none right-none">
                                                <input type="number" class="int-text int-mini" catAttrId="${attr.catAttrId}"
                                                       catAttrId="${attr.catAttrId}" name="attrSn" min="0" max="1000"
                                                       placeholder="属性排序" value="${attr.serialNumber}">
                                            </td>
                                            <td class="left-none ">
                                                <span class="radio-sp">
                                                    <input type="radio" name="isPic${attr.catAttrId}" catAttrId="${attr.catAttrId}" value="Y"
                                                           <c:if test="${attr.isPicture == 'Y'}">checked="checked"</c:if>>是</span>
                                                <span class="radio-sp">
                                                    <input type="radio" name="isPic${attr.catAttrId}" catAttrId="${attr.catAttrId}" value="N"
                                                           <c:if test="${attr.isPicture != 'Y'}">checked="checked"</c:if>>否</span>
                                            </td>
                                            <!--点击行为层结束-->
                                        </tr>
                                        <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                            <tr class="zhank"  style=" display:none;">
                                                <td colspan="3" >
                                                    <table width="100%" border="0" >
                                                        <c:forEach items="${attr.attrValList}" var="attrVal">
                                                            <tr class="border-bot-none">
                                                                <td  width="45%" class="right-text">${attrVal.attrValueName}
                                                                    <i class="fa fa-times i-close1" catAttrValId="${attrVal.catAttrValId}"></i></td>
                                                                <td  width="55%">
                                                                    <input type="number" class="int-text int-mini" placeholder="属性值排序"
                                                                           catAttrValId="${attrVal.catAttrValId}" name="attrValSn"
                                                                           value="${attrVal.serialNumber}" min="0" max="1000">
                                                                </td>
                                                                <td></td>
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
                        <div class="relation-title main-box-header">3、非关键属性
                            <a href="${_base}/cat/query/attr/view/${catId}?attrType=<%=ProductCatConstants.ProductCatAttr.AttrType.ATTR_TYPE_NONKEY%>">选择属性</a></div>
                        <div class="main-box-body clearfix">
                            <!--table表格-->
                            <div class="table-responsive clearfix relation-special">
                                <table width="100%" border="0" class="table table-hover  table-bordered table-special">
                                    <tr class="bj">
                                        <thead>
                                        <th width="40%" class="right-none text-c"  align="center">属性</th>
                                        <th width="60%" class="left-none text-c"  align="center">排序(只限填大于0小于1000的整数，值越小，排序越靠前)</th>
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
                                                        <td width="2%" class="ahref border-bot-none"><A href="#"><i class="fa fa-plus"></i></A></td>
                                                        <td width="2%" class="ctr border-bot-none">${attr.attrName}</td>
                                                        <%-- 1:属性  2:属性值 --%>
                                                        <td width="1%" ><i class="fa fa-times i-close" catAttrId="${attr.catAttrId}"></i></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="left-none">
                                                <input type="number" class="int-text int-mini" min="0" max="1000"
                                                       catAttrId="${attr.catAttrId}" name="attrSn"
                                                       placeholder="属性排序" value="${attr.serialNumber}">
                                            </td>
                                            <!--点击行为层结束-->
                                        </tr>
                                        <!--点击行为表现层-->
                                        <c:if test="${attr.attrValList!=null && attr.attrValList.size()>0}">
                                            <tr class="zhank"  style=" display:none;">
                                                <td colspan="2" >
                                                    <table width="100%" border="0" >
                                                        <c:forEach items="${attr.attrValList}" var="attrVal">
                                                            <tr class="border-bot-none">
                                                                <td  width="45%" class="right-text">${attrVal.attrValueName}
                                                                    <i class="fa fa-times i-close1" catAttrValId="${attrVal.catAttrValId}"></i></td>
                                                                <td  width="55%">
                                                                    <input type="number" class="int-text int-mini" placeholder="属性值排序"
                                                                           catAttrValId="${attrVal.catAttrValId}" name="attrValSn"
                                                                           value="${attrVal.serialNumber}" min="0" max="1000">
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
                        <div class="row"><!--删格化-->
                            <p class="right pr-30">
                                <input id="sumBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="保  存"/>
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
    var pager;
    var catId = "${catId}";
    var catNum = {'num':0};
    (function () {
        <%-- 属性删除按钮 --%>
        $('#mainBoxDiv').delegate(".i-close", 'click', function () {
            var id= $(this).attr('catAttrId');
            var objType = "1";
            console.log("删除属性,id="+id);
            pager._delAttrOfVal(id,objType);
        });

        $('#mainBoxDiv').delegate(".i-close1", 'click', function () {
            var id=$(this).attr('catAttrValId');
            var objType = "2";
            console.log("删除属性值,id="+id);
            pager._delAttrOfVal(id,objType);
        });
        seajs.use('app/jsp/prodcat/catattredit', function (catattredit) {
            pager = new catattredit({element: document.body});
            pager.render();

        });
    })();
</script>
</html>
