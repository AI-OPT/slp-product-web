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
                                <h5 class="pull-left">商品基础信息</h5>
                            </header>
                            <!--标题结束-->
                            <div class="form-label  bd-bottom">
                                <!-- 类目链 -->
                                <ul>
                                    <li class="col-md-12">
                                        <p class="word3">类目信息：</p>
                                        <p><c:forEach var="catInfo" items="${catLinkList}"
                                                      varStatus="stat">${catInfo.productCatName}
                                            <c:if test="${!stat.last}">&gt;</c:if></c:forEach>
                                        </p>
                                    </li>
                                </ul>
                                <ul class="big-word">
                                    <li class="col-md-12">
                                        <p class="word3">商品名称：</p>
                                        <p class="wide-field">${normProdResponse.productName}</p>
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
                            <!-- 市场价 -->
                            <div class="form-label bd-bottom ui-form" data-widget="validator">
                            	<form id="prodForm" action="${_base}/marketpricequery/updateMarketPrice" method="post">
	                            	<input type="hidden" name="productId" id="productId" value="${standedProdId}">
	                            	<ul class="big-word">
	                                    <li class="col-md-12">
	                                        <p class="word3">市场价：</p>
	                                        <p><input name="marketPrice" id="marketPrice"  type="text" value="${price}" class="int-text int-medium"
	                                        	 regexp="^(([1-9]\d{0,6})|0)(\.\d{1,2})?$" data-msg-regexp="请输入0到9999999.99的数字" required data-msg-required="市场价不能为空"> (元)</p>
	                                        <p id="marketPriceValidate"></p>
	                                    </li>
	                                </ul>
                                </form>
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
        seajs.use('app/jsp/marketprice/marketPriceEdit', function (addMarketPricePager) {
            pager = new addMarketPricePager({element: document.body});
            pager.render();
        });
    })();
</script>
