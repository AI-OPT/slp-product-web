<%@ page import="com.ai.opt.sdk.components.idps.IDPSClientFactory" %>
<%@ page import="com.ai.paas.ipaas.image.IImageClient" %>
<%@ page import="com.ai.slp.product.web.constants.SysCommonConstants" %>
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
<!-- 确认提示框 -->
<%-- <div class="eject-big">
    <div class="eject-samll" id="audit-small">
        <div class="eject-medium-title">
            <p>审核通过操作确认！</p>
            <p id="auditCloseImg" class="img"><i class="fa fa-times"></i></p>
        </div>

        <div class="eject-medium-complete">
            <p><img src="${uedroot}/images/eject-icon-prompt.png"></p>
            <p class="word">确定此商品通过您的审核？</p>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="submitBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
                <input id="auditBtn-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div> --%>
<!-- 确认提示框结束 -->

<!-- 拒绝提示框 -->
<div class="eject-big">
    <div class="eject-medium" id="refuse-small">
       <!--  <div class="eject-medium-title">
            <p id="refuseCloseImg" class="img"><i class="fa fa-times"></i></p>
        </div> -->

        <div class="eject-medium-complete">
             <div class="form-label">
			<form id="prodAttrForm">
              <ul> 
                <li>
                   <p class="word"><span>*</span>拒绝原因</p>
                   <p>
                   	<select id="refuseReason" class="select select-medium">
	                   	<option value="10">信息有误</option>
	                   	<option value="11">信息未完善</option>
	                   	<option value="99">其他</option>
                   	</select>
                   </p>
              	 </li>
          	 </ul>
	           <ul>	
	               <li>
	                   <p class="word"><span>*</span>问题描述</p>
	                   <p><textarea id="refuseDes" name="refuseDes" class="int-text textarea-xlarge"
												  maxlength="100" style="width:190px;height:80px;" 
												  required data-msg-required="问题描述不能为空"
												  commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"
												  onblur="this.value=this.value.replace(/^\s+|\s+$/g,'')"></textarea>
	                   </p>
	                   
	               </li>
	           </ul>
         </form> 	 
		</div>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="refuseBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确定拒绝">
                <input id="refuseBtn-close" type="button" class="biu-btn  btn-primary  btn-auto  ml-5 " value="取  消">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div>
<!-- 拒绝提示框结束 -->

<!-- 拒绝成功提示框 -->
<%-- <div class="eject-big">
    <div class="eject-samll" id="successRefuse-small">

        <div class="eject-medium-complete">
            <p><img src="${uedroot}/images/eject-icon-success.png"></p>
            <p class="word">商品审核拒绝成功</p>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="successRefuseBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div> --%>
<!-- 拒绝成功提示框结束 -->

<!-- 审核通过成功提示框 -->
<%-- <div class="eject-big">
    <div class="eject-samll" id="successPass-small">

        <div class="eject-medium-complete">
            <p><img src="${uedroot}/images/eject-icon-success.png"></p>
            <p class="word">商品审核通过成功</p>
        </div>
        <!--按钮-->
        <div class="row mt-15"><!--删格化-->
            <p class="center pr-30 mt-30">
                <input id="successPassBtn" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="确  认">
            </p>
        </div>
    </div>
    <div class="mask" id="eject-mask"></div>
</div> --%>
<!-- 审核通过成功提示框结束 -->


<div class="content-wrapper-iframe"><!--外围框架-->
    <div class="row"><!--外围框架-->
        <div class="col-lg-12"><!--删格化-->
            <div class="row"><!--内侧框架-->
                <div class="col-lg-12"><!--删格化-->
                    <div class="main-box clearfix"><!--白色背景-->
                        <div id="subDiv" class="main-box-body clearfix">
							<header class="main-box-header clearfix">
								<h5 class="pull-left">商品基础信息
								</h5>
							</header>
							<div class="form-label  bd-bottom">
								<ul>
									<input type="hidden" id="prodId" value="${productInfo.prodId}">
									<input type="hidden" id="state" value="${productInfo.state}">
									<li class="col-md-12">
										<p class="word3">类目信息：</p>
										<p>
											<c:forEach var="catInfo" items="${catLinkList}"
													   varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
											</c:forEach>
										</p>
									</li>
								</ul>
								<ul>
									<li class="col-md-12">
										<p class="word3">商品类型：</p>
										<p>${prodType}</p>
									</li>
								</ul>
								<ul class="big-word">
									<li class="col-md-12">
										<p class="word3">商品名称：</p>
										<p class="wide-field" style="word-break:break-all;">${productInfo.prodName}</p>
									</li>
								</ul>
								<ul>
									<li class="col-md-12">
										<p class="word3">商品卖点：</p>
										<p class="wide-field" style="word-break:break-all;">${productInfo.productSellPoint}</p>
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
											<c:choose>
												<%--多选--%>
												<c:when test="${aav.key.attrType == '2'}">
													<div class="wide-width">
														<c:forEach var="attrVal" items="${aav.value}" varStatus="stat">
															<p>${attrVal.attrVal}<c:if test="${!stat.last}">、</c:if></p>
														</c:forEach>
													</div>
												</c:when>
												<c:when test="${!aav.value.isEmpty()}">
													<p>${aav.value.get(0).attrVal}</p>
												</c:when>
												<c:otherwise>
													<p></p>
												</c:otherwise>
											</c:choose>
										</li>
									</ul>
								</c:forEach>
							</div>
							<!-- 非关键属性 -->
							<header class="main-box-header clearfix">
								<h5 class="pull-left">商品非关键属性</h5>
							</header>
							<div class="form-label  bd-bottom">
								<c:forEach var="attr" items="${noKeyAttr}">
									<ul>
										<li class="col-md-12">
											<p class="word3">${attr.attrName}：</p>
											<c:set var="noKeyAttrVals" value="${noKeyAttrValMap.get(attr.attrId)}"/>
											<c:choose>
												<%--多选--%>
												<c:when test="${attr.valueWay == '2'}">
													<div class="wide-width">
														<c:set var="choseInt" value="0"></c:set>
														<c:forEach var="attrVal" items="${noKeyAttrVals}" varStatus="stat">
															<c:if test="${attrVal.productAttrValId != null}">
																<c:if test="${choseInt>0}">、</c:if>${attrVal.attrVal}
																<c:set var="choseInt" value="${choseInt+1 }"></c:set>
															</c:if>
															<%-- ${attrVal.attrVal}<c:if test="${!stat.last}">、</c:if> --%>
														</c:forEach>
													</div>
												</c:when>
												<c:when test="${!noKeyAttrVals.isEmpty()}">
													<p>${noKeyAttrVals.get(0).attrVal}</p>
												</c:when>
												<c:otherwise>
													<p></p>
												</c:otherwise>
											</c:choose>
										</li>
									</ul>
								</c:forEach>
							</div>
							<!-- 选择商品目标地域 -->
							<header class="main-box-header clearfix">
								<h5 class="pull-left">商品目标地域</h5>
							</header>
							<div class="form-label  bd-bottom">
								<ul>
									<li class="width-xlag">
										<p class="word3">目标地域：</p>
										<c:choose>
											<c:when test="${productInfo.isSaleNationwide == 'Y'}">
												<p>全部地域</p>
											</c:when>
											<c:when test="${productInfo.isSaleNationwide == 'N'}">
												<p class="wide-field" style="word-break:break-all;">${areaInfoStr}</p>
											</c:when>
										</c:choose>
									</li>
								</ul>
							</div>
							<!-- 发票信息 -->
							<header class="main-box-header clearfix">
								<h5 class="pull-left">发票信息</h5>
							</header>
							<div class="form-label  bd-bottom">
								<ul>
									<li class="col-md-12">
										<p class="word3">是否提供发票：</P>
										<p>
											<c:if test="${productInfo.isInvoice == 'Y'}">提供发票</c:if>
											<c:if test="${productInfo.isInvoice == 'N'}">不提供发票</c:if>
										</p>
									</li>
								</ul>
							</div>
							<!-- 商品上架时间 -->
							<header class="main-box-header clearfix">
								<h5 class="pull-left">商品上架类型</h5>
							</header>
							<div class="form-label  bd-bottom">
								<ul>
									<li class="col-md-12">
										<p class="word3">
											<c:if test="${productInfo.upshelfType == '1'}">立即上架</c:if>
											<c:if test="${productInfo.upshelfType == '2'}">放入仓库</c:if>
											<c:if test="${productInfo.upshelfType == '4'}">预售上架：</c:if>
										</p>
										<p class="wide-field" style="word-break:break-all;">
											<c:if test="${productInfo.upshelfType == '4'}">
												预售时间&emsp;<fmt:formatDate value="${productInfo.presaleBeginTime}" type="both"></fmt:formatDate>
												至
												<fmt:formatDate value="${productInfo.presaleEndTime}" type="both"></fmt:formatDate></c:if>
										</p>
									</li>
								</ul>
							</div>
							<!-- 商品预览图 -->
							<header class="main-box-header clearfix">
                                <h5 class="pull-left">商品预览图</h5>
                            </header>
							<div class="form-label bd-bottom"><!--查询条件-->
								<%
									String picSize = "78x78";
									IImageClient imageClient = IDPSClientFactory.getImageClient(SysCommonConstants.ProductImage.IDPSNS);
									request.setAttribute("imgClient",imageClient);
									request.setAttribute("picSize",picSize);
								%>
								<ul>
									<li class="width-xlag">
										<p class="word"><b class="red">*</b>商品主图</p>
										<div>
											<c:set var="prodPicNum" value="${prodPic.size()}"></c:set>
											<c:forEach var="valInd" begin="0" end="5">
												<p class="img">
													<c:choose>
														<c:when test="${valInd<prodPicNum && prodPic.get(valInd)!=null}">
															<c:set var="valInfo" value="${prodPic.get(valInd)}"/>
															<img src="<c:out value="${imgClient.getImageUrl(valInfo.vfsId,valInfo.picType,picSize)}"/>"/>
														</c:when>
														<c:otherwise>
															<img src="${_slpres}/images/sp-03-a.png"/>
														</c:otherwise>
													</c:choose>
												</p>
											</c:forEach>
										</div>
									</li>
								</ul>
								<%-- 属性值图片 --%>
								<c:forEach var="attrValInfo" items="${attrValList}">
									<ul>
										<li class="width-xlag">
											<p class="word"><b class="red">*</b>${attrValInfo.attrVal}</p>
											<div class="width-img" id="prod_pic_${attrValInfo.attrValId}">
												<c:set var="attrValPic" value="${valPicMap.get(attrValInfo.attrValId)}"></c:set>
												<c:set var="attrValSize" value="${attrValPic.size()}"></c:set>
												<c:forEach var="valInd" begin="0" end="5">
													<p class="img">
														<c:choose>
															<c:when test="${valInd<attrValSize && attrValPic.get(valInd)!=null}">
																<c:set var="valInfo" value="${attrValPic.get(valInd)}"></c:set>
																<img src="<c:out value='${imgClient.getImageUrl(valInfo.vfsId,valInfo.picType,picSize)}'/>"/>
															</c:when>
															<c:otherwise>
																<img src="${_slpres}/images/sp-03-a.png"/>
															</c:otherwise>
														</c:choose>
													</p>
												</c:forEach>
											</div>
										</li>
									</ul>
								</c:forEach>
							</div>
							<!-- 商品图文描述 -->
							<header class="main-box-header clearfix">
								<h5 class="pull-left">商品图文描述</h5>
							</header>
							<div class="form-label" style="width: 100%;word-wrap:break-word; "><!--查询条件-->
								${prodDetail}
							</div>
                            
	                        <div class="row pt-30">
	                            <p class="center pr-30 mt-30">
	                                <input id="auditMoreBtn" type="button" 
	                                class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
	                                       value="审核通过">
	                                <input id="refuseMoreBtn" type="button" 
	                                class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
	                                       value="审核拒绝">
	                            </p>
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
	var count = '${count}';
	var prodInfoList = '${prodInfoList}';
	var productEditInfo = '${productEditInfo}';
	(function () {		
		seajs.use('app/jsp/prodaudit/auditproduct', function(auditproductPager) {
			pager = new auditproductPager({element : document.body});
			pager.render();
		});
	})();
</script>
</html>