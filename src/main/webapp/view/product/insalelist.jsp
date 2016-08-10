<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
    <title>运营管理</title>
    <%@ include file="/inc/inc.jsp" %>
    <link href="${_slpres }/styles/bootstrap.css"rel="stylesheet" type="text/css">
    <link href="${_slpres }/styles/font-awesome.css" rel="stylesheet" type="text/css">
    <link href="${_slpres }/styles/global.css" rel="stylesheet" type="text/css">
    <link href="${_slpres }/styles/frame.css" rel="stylesheet" type="text/css">
    <link href="${_slpres }/styles/modular.css" rel="stylesheet" type="text/css">
</head>

<body>
	<!--确认是否下架弹出框 -->
	<div class="eject-big">
	<div class="eject-samll">
		<div class="eject-samll-title">
			<p>下架操作确认</p>
			<p class="img"><A href="#"></A></p>
		</div>
		<!--确认上架-->
		<div class="eject-samll-confirm">
			<ul>
			<li class="word">确定要将商品手动下架吗?</li>
			<li><input id="upConfirm" type="button"  class="slp-btn eject-small-btn" value="确认"><input type="button"  class="slp-btn eject-small-btn close-btn" value="取消"></li>		
			</ul>
		</div>
	</div>	
	<div class="eject-mask"></div>	
	</div>
	<!--确认是否上架弹出框 结束-->
	<!--顶部菜单-->
	<%@ include file="/inc/top-menu.jsp" %>
	<!--顶部菜单结束-->
	<!-- 左侧菜单 -->
	<%@ include file="/inc/left-menu.jsp" %>
	<!-- 左侧菜单结束 -->

	<div class="wrapper"><!--外围框架-->
    <!--右侧框架-->
    <div class="wrapper-right">
        <!--公告位置-->
        	<%@ include file="/inc/public-msg.jsp" %>
        <!--公告位置结束-->
        <!--标签-->
        <div class="right-tags">
            <ul>
                <li>
                    <p class="none">您现在的位置：</p>
                    <p><a href="#">商城商品管理</a></p>
                    <p></p>
                    <p></p>
                </li>
            </ul>
        </div>

        <!--标签结束-->
        <!--查询结果-->
        <div class="form-wrapper"><!--白底内侧-->

            <div class="nav-tplist-wrapper"><!--白底内侧-->
                <div class="order-list-table">
                    <ul>
                        <li><a href="#" class="current">销售中商品</a></li>
                        <!-- <li><a href="#">被拒绝</a></li>
                        <li><a href="#">审核中</a></li> -->
                    </ul>
                </div>
                <!--结果标题-->
                <div id="date1">
                    <div class="form-label">
                        <ul id="date1ProdCat">
                            <li class="width-xlag">
                                <p class="word">商品类目</p>
                                <c:forEach var="map" items="${catInfoMap}" varStatus="status">
	                                <p id="productCat${status.index}">
	                                    <select class="select select-small" onChange="pager._selectChange(this);">
	                                    <c:forEach var="info" items="${map.value}">
	                                        <option value="${info.productCatId}">${info.productCatName}</option>
	                                    </c:forEach>
	                                    </select>
	                                </p>
                                </c:forEach>
                                <script id="prodCatTemple" type="text/template">
                                	 <p id="productCat{{:level}}">
										<select class="select select-small" onChange="pager._selectChange(this);">
											{{for prodCatList}}
                                   			 	<option value="{{:productCatId}}">{{:productCatName}}</option>
											{{/for}}
                               			</select>
									</p>
								</script>
                            </li>
                        </ul>
                        <ul>
                        	<li>
                                <p class="word">商品类型</p>
                                <p>
	                                <select id="productType" class="select select-medium">
	                                	<option value="">全部</option>
	                                	<option value="1">实物</option>
	                                	<option value="2">虚拟</option>
	                                </select>
                                </p>
                            </li>
                            <li>
                                <p class="word">商品ID</p>
                                <p><input id="productId" type="text" class="int-text int-medium"></p>
                            </li>
                        </ul>
                        <ul>
                            <li class="width-xlag">
                                <p class="word">商品名称</p>
                                <p><input id="productName" type="text" class="int-text int-medium"></p>
                                <p><input id="selectProductInSale" type="button" value="查询" class="biu-btn btn-blue btn-mini"></p>
                            </li>
						</ul>
                    </div>
                    <!--结果表格-->
                    <div class="table table-border table-bordered table-bg table-hover mt-10 commodity-tplist-table">
                        <table width="100%" border="0">
                            <tr class="bj">
				                <td width="10%">商品ID</td>                                                                                                      
				                <td width="10%">所属类目</td>
				                <td>类型</td>
				                <td>预览图</td>
				                <td width="30%">商品名称</td>
				                <!-- <td>总库存</td> -->
				                <td>状态</td>
				                <td>生成时间</td>    
				                <td>操作</td>                                                                                
				             </tr>
                            <tbody id="searchProductData"></tbody>
                        </table>
                        	<div id="showMessageDiv"></div>
                            <script id="searchProductTemple" type="text/template">
                            <tr>
                                <td>{{:prodId}}</td>
                                <td>{{:productCatName}}</td>
                                <td>{{:productTypeName}}</td>
								{{if picUrl==null || picUrl==""}}
                            	    <td><img src="${_slpres}/images/sp-03-a.png"></td>
								{{else}}
									<td><img src="{{:picUrl}}"></td>
								{{/if}}
                                <td>{{:prodName}}</td>
                                <!--<td>{{:totalNum}}</td>--!>
                                <td>{{:stateName}}</td>
                                <td>{{:~timesToFmatter(createTime)}}</td>
                                <td>
                                    <div>
                                        <p><a href="${_base}/prodedit/{{:prodId}}" class="blue">编辑商品</a></p>
										<p><a id="{{:prodId}}" href="#" class="blue-border">下架</a></p> 
                                    </div>
                                </td>
                            </tr>
							</script>
                    </div>
                    <!--分页-->
					 <div>
		 				 <nav style="text-align: right">
							<ul id="pagination-ul">
							</ul>
						</nav>
					  </div>
					 <!--分页-->
                    <!--结果表格结束-->
                    
                    <!--结果表格-->
                   
               	 </div> 
            </div>
        </div>
        <!--查询结果结束-->

    </div>
</div>
<!-- footer -->
	<div class="footer">版权所有 © SLP版权归运营家所有</div>
</body>
	<script src="${_slpres }/scripts/frame.js" type="text/javascript"></script>
	<script src="${_slpres }/scripts/metismenu.js"></script>
	<script type="text/javascript">
	    window.onload = function () {
	        var timer;
	        var elem = document.getElementById('elem');
	        var elem1 = document.getElementById('elem1');
	        var elem2 = document.getElementById('elem2');
	        elem2.innerHTML = elem1.innerHTML;
	        timer = setInterval(Scroll, 40);
	        function Scroll() {
	            if (elem.scrollTop >= elem1.offsetHeight) {
	                elem.scrollTop -= elem1.offsetHeight;
	            } else {
	                elem.scrollTop += 1;
	            }
	        }
	
	        elem.onmouseover = function () {
	            clearInterval(timer);
	        }
	        elem.onmouseout = function () {
	            timer = setInterval(Scroll, 40);
	        }
	    }
	</script>
	<script type="text/javascript">
		var pager;
		var count = '${count}';
		var prodInfoList = '${prodInfoList}';
		var productEditInfo = '${productEditInfo}';
		(function () {
			$('#searchProductData').delegate("a[class='blue-border']",'click',function(){
				console.log('prodId:'+$(this).attr('id'));
				clickId = $(this).attr('id');
				
				pager._showUpConfirm($(this).attr('id'));
				//pager._prodToInSale($(this).attr('id'));
			});
			seajs.use('app/jsp/product/insalelist', function (InsalelistPager) {
				pager = new InsalelistPager({element: document.body});
				pager.render();
			});
		})();
	</script>
</html>
