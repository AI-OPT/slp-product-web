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
<!-- 确认保存提示框 -->
<div class="eject-big">
    <div class="eject-samll" id="aband-small">
        <input type="hidden" id="delAttrId">
        <div class="eject-medium-title">
            <p>成功提示</p>
        </div>

        <div class="eject-medium-complete">
            <p class="word">市场价更改成功</p>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="successBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>

<!-- 确认保存提示框 -->

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
                                        <p>${normProd.productName}</p>
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
                            <!-- 市场价 -->
                            <div class="form-label  bd-bottom">
                            	<input type="hidden" id="productId" value="${normProd.productId}">
                            	<ul class="big-word">
                                    <li class="col-md-6">
                                        <p class="word">市场价：</p>
                                        <p><input id="marketPrice" type="text" value="${normProd.marketPrice}" class="int-text int-medium"></p>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div id="subDiv" class="row pt-30">
                        	<p class="center pr-30 mt-30">
                        		<input id="submitSaveBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                       value="保  存">
                                <input id="goBackBtn" type="button" class="biu-btn  btn-primary  btn-small  ml-5"
                                       value="返  回" onclick="javaScript:window.history.go(-1);">
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
    var pager;
    var count = '${count}';
    var standedProdId = "${standedProdId}";
    var productCatId = "${productCatId}";
    (function () {
        seajs.use('app/jsp/marketprice/addMarketPrice', function (addMarketPricePager) {
            pager = new addMarketPricePager({element: document.body});
            pager.render();
        });
    })();
</script>