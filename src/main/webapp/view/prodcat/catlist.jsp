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
                    <div class="main-box clearfix"><!--白色背景-->
                        <!-- 查询条件 -->
                        <div class="form-label">
                            <input type="hidden" id="pageSize" name="pageSize" value="10">
                            <input type="hidden" id="pageNo" name="pageNo">
                            <input type="hidden" id="parentProductCatId" name="parentProductCatId" value="${parentProductCatId}">
                            <ul>
                                <li class="col-md-6">
                                    <p class="word">类目名称</p>
                                    <p><input id="productCatName" type="text" class="int-text int-medium"></p>
                                </li>
                                <li class="col-md-6">
                                    <p class="word">类目ID</p>
                                    <p><input id="productCatId" name="productCatId" type="text" class="int-text int-medium"></p>
                                </li>
                            </ul>
                            <ul>
                                <li class="col-md-6">
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
                                <h2 class="pull-left">类目列表</h2>

                            </header>
                            <div class="row"><!--删格化-->
                                <c:set var="secondParentCat" value=""/>
                                <p class="left pl-40">上级类目:<c:forEach var="catInfo" items="${catLink}"
                                       varStatus="stat"> ${catInfo.productCatName}<c:if test="${!stat.last}">&gt;
                                    <c:set var="secondParentCat" value="${catInfo.productCatId}"/></c:if></c:forEach>
                                </p>
                                <p class="right pr-30">
                                    <input type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
                                           value="新  增" onclick="javaScript:window.location.href = '${_base}/cat/edit/addview?parentId=${parentProductCatId}';">
                                </p>
                            </div>
                            <!--标题结束-->
                            <div class="main-box-body clearfix">
                                <!--table表格-->
                                <div class="table-responsive clearfix">
                                    <table class="table table-hover table-border table-bordered">
                                        <thead>
                                        <tr>
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
                                            <td>{{:productCatId}}</td>
                                            <td>
                                                <div class="hind1 text-l pl-15">
                                                <div class="center-hind" >{{:productCatName}}</div>
                                                <div class="showbj"><i class="fa fa-posi fa-caret-up"></i>{{:productCatName}}</div>
                                                </div>
                                            </td>
                                            <td>{{if isChild=='Y'}}是{{else}}否{{/if}}</td>
                                            <td>{{:serialNumber}}</td>
                                            <td>
                                                <a href="javaScript:void(0);" name="editViewBtn" catId="{{:productCatId}}">编辑</a>
                                                <a href="javaScript:void(0);" name="delViewBtn" catId="{{:productCatId}}">删除</a>
                                                <%-- 判断有子分类 --%>
                                                {{if isChild=='Y'}}
                                                <a href="${_base}/cat/query?parentProductCatId={{:productCatId}}">&nbsp;管理子分类&nbsp;</a>
                                                {{else }}
                                                <a href="${_base}/cat/query/attr/edit/{{:productCatId}}">关联类目属性</a>
                                                <a href="${_base}/cat/query/attr/{{:productCatId}}">查看类目属性</a>
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
                            <c:if test="${parentProductCatId!=null && parentProductCatId!='' && parentProductCatId!='0'}">
                            <div  class="row pt-30"><!--删格化-->
                                <p class="center pr-30">
                                    <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                           value="返  回" onclick="goSecondParent();">
                                </p>
                            </div>
                            </c:if>
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
        <%-- 编辑按钮 --%>
        $('#listData').delegate("a[name='editViewBtn']", 'click', function () {
            var catId = $(this).attr('catId');
            if (window.console) {
                console.log("编辑链接:" + catId);
            }
            pager._showCat(catId);
        });
        <%-- 删除按钮 --%>
        $('#listData').delegate("a[name='delViewBtn']", 'click', function () {
            var catId = $(this).attr('catId');
            if (window.console) {
                console.log("删除链接:" + catId);
            }
            pager._showDelConf(catId);
        });
        <%-- 高级区域 --%>
        $(".form-label ul li .sos a").click(function () {
            $(".open ").slideToggle(100);
            $(".nav-form ").toggleClass("reorder remove");
        });
        seajs.use(['app/jsp/prodcat/catlist','app/util/center-hind'], function (catListPager,centerHind) {
            pager = new catListPager({element: document.body});
            pager.render();
            new centerHind({element : document.body}).render();
        });
    })();
    function goSecondParent(){
        self.location="${_base}/cat/query?parentProductCatId=${secondParentCat}";
    };
</script>
</html>