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
                        <!-- 查询条件 -->
                        <div class="form-label">
                            <input type="hidden" id="parentProductCatId" name="parentProductCatId" value="${parentProductCatId}">
                            <ul>
                                <li class="width-xlag">
                                    <p class="word">类目名称</p>
                                    <p><input id="productCatName" type="text" class="int-text int-medium"></p>
                                </li>
                                <li>
                                    <p class="sos"><a href="javascript:void(0);">高级搜索<i class="fa fa-caret-down"></i></a>
                                    </p>
                                </li>
                            </ul>
                            <div class="open" style="display:none;">
                                <ul>
                                    <li>
                                        <p class="word">类目ID</p>
                                        <p><input id="productCatId" name="productCatId" type="text" class="int-text int-medium"></p>
                                    </li>
                                    <li>
                                        <p class="word">是否有子分类</p>
                                        <p>
                                            <select id="isChild" class="select select-medium">
                                                <option value="">全部</option>
                                                <option value="Y">是</option>
                                                <option value="N">否</option>
                                            </select>
                                        </p>
                                    </li>
                                </ul>
                            </div>
                            <ul>
                                <li class="width-xlag">
                                    <p class="word">&nbsp;</p>
                                    <p><input type="button" class="biu-btn  btn-primary btn-blue btn-medium ml-10"
                                              id="selectList" value="查  询"></p>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row"><!--外围框架-->
            <div class="col-lg-12"><!--删格化-->
                <div class="row"><!--内侧框架-->
                    <div class="col-lg-12"><!--删格化-->
                        <div class="main-box clearfix"><!--白色背景-->
                            <!--标题-->
                            <header class="main-box-header clearfix">
                                <h2 class="pull-left">查询结果&emsp;</h2>

                            </header>
                            <div class="row"><!--删格化-->
                                <p class="left pl-40">
                                    上级类目:<c:forEach var="catInfo" items="${catLink}"
                                               varStatus="stat">${catInfo.productCatName}<c:if
                                            test="${!stat.last}">&gt;</c:if></c:forEach>
                                </p>
                                <p class="right pr-30">
                                    <a href="${_base}/cat/edit/addview" class="btn btn-primary btn-blue btn-auto active" role="button">新  增</a>
                                </p>
                            </div>
                            <!--标题结束-->
                            <div class="main-box-body clearfix">
                                <!--table表格-->
                                <div class="table-responsive clearfix">
                                    <table class="table table-hover table-border table-bordered">
                                        <thead>
                                        <tr>
                                            <th>序号</th>
                                            <th>类目ID</th>
                                            <th>类目名称</th>
                                            <th>是否有子分类</th>
                                            <th>排序</th>
                                            <th>操作</th>
                                        </tr>
                                        </thead>
                                        <tbody id="listData">
                                        </tbody>
                                    </table>
                                    <div id="showMessageDiv"></div>
                                    <script id="searchTemple" type="text/template">
                                        <tr>
                                            <td>{{:#index+1}}</td>
                                            <td>{{:productCatId}}</td>
                                            <td>{{:productCatName}}</td>
                                            <td>{{if isChild=='Y'}}是{{else}}否{{/if}}</td>
                                            <td>{{:serialNumber}}</td>
                                            <td>
                                                <a href="${_base}/prodedit/{{:productCatId}}">编辑</a>
                                                <a href="${_base}/prodedit/{{:productCatId}}">删除</a>
                                                <%-- 判断有子分类 --%>
                                                {{if isChild=='Y'}}
                                                <a href="${_base}/cat/query?parentProductCatId={{:productCatId}}">&nbsp;管理子分类&nbsp;</a>
                                                {{else }}
                                                <a href="${_base}/prodedit/{{:productCatId}}">关联类目属性</a>
                                                <a href="${_base}/prodedit/{{:productCatId}}">查看类目属性</a>
                                                {{/if}}
                                            </td>
                                        </tr>
                                    </script>
                                </div>
                                <!--分页-->
                                <div class="paging">
                                    <ul id="pagination-ul">
                                    </ul>
                                </div>
                                <!--分页结束-->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
    var pager;
    (function () {
        seajs.use('app/jsp/prodcat/catlist', function (catListPager) {
            pager = new catListPager({element: document.body});
            pager.render();
        });
    })();
</script>
<script src="${uedroot}/scripts/modular/frame.js"></script>
</html>