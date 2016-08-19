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
        
        <!--查询结果-->
        <div class="form-wrapper"><!--白底内侧-->

            <div class="nav-tplist-wrapper"><!--白底内侧-->
            <div class="nav-form-title">选择类目</div>
           	<div class="add-commodity-title">
           		<ul>
           			<li>您当前选择的是：<a href="#">登山野营/旅行装备</a>><a href="#">户外露营/野炊装备</a>><a href="#">帐篷/天幕/帐篷配件</a></li>
           			<li class="color-word">（标准品一旦生成，类目信息不可更改，请谨慎选择类目信息）</li>
           		</ul>
           	</div>
            
                <!--结果标题-->
                <div id="date1">
                    <div class="form-label">
                        <ul id="data1ProdCat">
                            <li class="width-xlag">
                            
                                <c:forEach var="map" items="${catInfoMap}" varStatus="status">
									<p id="productCat${status.index}">
										<div class="add-ctn-list">
											<div class="add-ctn-list-title"><input type="text" class="int-large" placeholder="输入名称/拼音首字母"><a href="#"><i class="icon-search"></i></a></div>
							           			<div class="add-ctn-list-table">
							           				<ul>
							           					<c:forEach var="info" items="${map.value}">
							           						<li><a href="#" value="${info.productCatId}">${info.productCatName}</a></li>
															<%-- <option value="${info.productCatId}">${info.productCatName}</option>  --%>  	
														</c:forEach>
							           				</ul>
							           			</div>
						           		</div>
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
                    </div>
                    
                </div>
            </div>
            <div class="nav-form">
            <ul>
                <li class="width-xlag">
                <%-- <p><input type="button" class="blling-btn add-btn" value="下一步，填写详细信息"></p>
                 --%>
                 
                 <p class="blling-btn add-btn"><a href="${_base}/normprodedit/addinfo">下一步，填写详细信息</a></p>
            </ul>   
        </div>
        </div>
        <!--查询结果结束-->

    </div>
</div>
</body>
<script type="text/javascript"> 
window.onload = function(){	
	var timer;
	var elem = document.getElementById('elem');
	var elem1 = document.getElementById('elem1');
	var elem2 = document.getElementById('elem2');
	elem2.innerHTML = elem1.innerHTML;
	timer = setInterval(Scroll,40);
	function Scroll(){
		if(elem.scrollTop>=elem1.offsetHeight){
			elem.scrollTop -= elem1.offsetHeight;
		}else{
			elem.scrollTop += 1;
		}
	}	
	elem.onmouseover = function(){
		clearInterval(timer);
	}	
	elem.onmouseout = function(){
		timer = setInterval(Scroll,40);
	}
}
</script>
<script type="text/javascript">
	(function () {
		seajs.use('app/jsp/product/addlist', function (AddlistPager) {
			pager = new AddlistPager({element: document.body});
		});
	})();
</script>
</html>