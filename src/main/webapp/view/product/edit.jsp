<%@ page import="com.ai.opt.sdk.components.idps.IDPSClientFactory" %>
<%@ page import="com.ai.paas.ipaas.image.IImageClient" %>
<%@ page import="com.ai.slp.product.web.constants.SysCommonConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>商品编辑</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<title>运营管理</title>
	<%@ include file="/inc/inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="${spmRes}/webuploader/webuploader.css"/>
	<style type="text/css">
		.form-label span {
			color: rgb(0, 0, 0);
		}
		.eject-large {
   			 top: 70%;
		}	
	</style>
</head>
<body>
<!--弹出上传图片  中-->
<div class="eject-big">
		<div class="eject-medium">
			<div class="eject-medium-title">
				<p>上传图片</p>
				<p class="img"><A href="#"></A></p>
			</div>
			<div class="eject-medium-list">
				<div class="account-title eject-martop ejetct-border"><p>本地上传</p></div>
				<%--<div class="default-text">
					<p>上传至:</p>
					<p class="int-zk"><input type="text" class="int-medium int-deault" /><i class="icon-angle-down"></i></p>
				<div class="mouse-open" style="display: none;;">
					<ul>
						<li>默认文件夹</li>
						<li><a href="#">流量商品图片</a></li>
						<li><a href="#">话费商品图片</a></li>
						<li><a href="#">装修图片</a></li>
						<li class="newly-build-onclick" style="display:none;"><input type="text" class="int-small int-deault" /><a href="#">创建</a></li>
						<li class="newly-build"><a href="#"><i class="icon-plus"></i>新建文件夹</a></li>
					</ul>
				</div>
				</div>--%>
				<div class="medium-list-form medium-list-form-center">
					<ul>
						<li class="img"><img src="${_slpres}/images/sp-04.png" /></li>
						<li><input id="" type="button" class="biu-btn btn-blue qu-btn" value="上传图片"></li>
					</ul>
				</div>
				<div class="medium-list-word">
					<ul>
				    <li>提示：</li>
					<li>一次可上传最多6张图片，JPG/PNG/GIF格式，每张图片大小不超过3M；</li>
					<li>建议上传详情图片宽度750px或以上；</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="eject-mask"></div>
</div>
<!--弹出上传图片  中结束-->

<!--选择省份弹出框 大-->
<div class="eject-big" >
	<div class="eject-large" id="eject-city">
		<div class="eject-medium-title">
			<p>选择省市</p>
			<%--<p class="img"><i class="fa fa-times"></i></p>--%>
		</div>
		<div class="eject-large-list">
			<div class="account-title eject-martop"><p>已选中<b><span id="dialogAreaNum">10</span>个</b>
				<input type="button" class="biu-btn  btn-primary btn-small right" id="finishTarget" value="确认"></p>
			</div>
			<div id="provAreaDiv" class="user-list-title-list">
				<c:set value="0" var="areaNum"></c:set>
				<ul>
					<c:forEach var="areaInfo" items="${otherSet.areaInfos}">
						<li>
							<p><input type="checkbox" name="targetProv" class="checkbox-medium" value="${areaInfo.areaCode}"
									  title="${areaInfo.areaName}" <c:if test="${areaInfo.own}">checked</c:if>></p>
							<p>${areaInfo.areaName}</p>
							<c:if test="${areaInfo.own}"><c:set var="areaNum" value="${areaNum+1}"></c:set></c:if>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
	</div>
	<div class="mask" id="eject-mask"></div>
</div>
<!--选择省份 大结束-->
<input type="file" id="uploadFile" name="uploadFile" style="display: none;" accept="image/jpeg,image/png">

<div class="content-wrapper-iframe"><!--外围框架-->
	<div class="row"><!--外围框架-->
		<div class="col-lg-12"><!--删格化-->
			<div class="row"><!--内侧框架-->
				<div class="col-lg-12"><!--删格化-->
					<div class="main-box clearfix"><!--白色背景-->
						<form id="prodForm" method="post">
							<input type="hidden" name="prodId" value="${productInfo.prodId}">
							<input type="hidden" name="audiencesPerson" value="-1">
							<input type="hidden" name="audiencesEnterprise" value="-1">
							<input type="hidden" name="audiencesAgents" value="-1">
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">*标注为必填项</h5>
						</header>
						<div class="main-box-body clearfix">
							<header class="main-box-header clearfix ">
								<h5 class="pull-left">商品基础信息</h5>
							</header>
							<div class="form-label bd-bottom"><!--查询条件-->
							<ul>
								<li class="width-xlag">
									<p class="word3"><b class="red">*</b>类目信息</p>
									<p><c:forEach var="catInfo" items="${catLinkList}"
												   varStatus="stat">${catInfo.productCatName}
										<c:if test="${!stat.last}">&gt;</c:if></c:forEach>
									</p>
								</li>
							</ul>
							<ul>
								<li>
									<p class="word3"><b class="red">*</b>商品类型</p>
									<p>${prodType}</p>
								</li>
							</ul>
							<ul>
								<li class="width-xlag">
									<p class="word3"><b class="red">*</b>商品名称</p>
									<p class="wide-field" style="word-break:break-all;">${productInfo.prodName}</p>
									<input type="hidden" name="prodName" value="${productInfo.prodName}"  commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/">
								</li>
							</ul>
							<ul>
								<li class="width-xlag">
									<p class="word3">商品卖点</p>
									<p>
										<textarea name="productSellPoint" class="int-text textarea-xlarge"
													
												  maxlength="100">${productInfo.productSellPoint}</textarea>
									</p>
								</li>
							</ul>
						</div>
						<!--标题-->
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">商品关键属性</h5>
						</header>
						<div class="form-label  bd-bottom">
                                <c:forEach var="aav" items="${attrAndVal}">
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
						
						
						
						<%-- <div class="form-label  bd-bottom"><!--查询条件-->
							<c:forEach var="aav" items="${attrAndVal}">
								<ul>
									<li>
										<p class="word3">${aav.key.attrName}</p>
										<c:choose>
											多选
											<c:when test="${aav.key.attrType == '2'}">
												<p class="wide-field">
													<c:forEach var="attrVal" items="${aav.value}" varStatus="stat">
														${attrVal.attrVal}<c:if test="${!stat.last}">、</c:if>
													</c:forEach>
												</p>
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
						</div> --%>
						<!--标题-->
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">商品非关键属性</h5>
						</header>
						<div class="form-label bd-bottom" id="noKeyAttrDiv"><!--查询条件-->
							<input type="hidden" id="noKeyAttrStr" name="noKeyAttrStr">
							<c:forEach var="attr" items="${noKeyAttr}">
								<ul>
									<li class="width-xlag">
										<p class="word3" attrId="${attr.attrId}" valueType="${attr.valueWay}">${attr.attrName}</p>
										<c:choose>
											<%-- 下拉选择 --%>
											<c:when test="${attr.valueWay == '1'}">
												<select class="select select-medium" attrId="noKeyAttr${attr.attrId}">
													<c:forEach var="valInfo" items="${noKeyAttrValMap.get(attr.attrId)}">
														<option value="${valInfo.attrValId}" id="${valInfo.productAttrValId}"
																<c:if test="${valInfo.productAttrValId != null}">selected</c:if>>${valInfo.attrVal}</option>
													</c:forEach>
												</select>
											</c:when>
											<%--多选--%>
											<c:when test="${attr.valueWay == '2'}">
												<div class="width-xlag">
													<c:forEach var="valInfo" items="${noKeyAttrValMap.get(attr.attrId)}">
														<p><input type="checkbox" class="checkbox-small" attrId="noKeyAttr${attr.attrId}" value="${valInfo.attrValId}"
																  <c:if test="${valInfo.productAttrValId != null}">checked</c:if> >${valInfo.attrVal}</p>
													</c:forEach>
												</div>
											</c:when>
											<%--单行输入--%>
											<c:when test="${attr.valueWay == '3'}">
												<c:set var="valInfo" value=""></c:set>
												<c:if test="${!noKeyAttrValMap.get(attr.attrId).isEmpty()}">
													<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
												</c:if>
												<p><input type="text" class="int-text int-xlarge" attrId="noKeyAttr${attr.attrId}" maxlength="20"
														  <c:if test="${valInfo!=''}">value="${valInfo.attrVal}"</c:if> ></p>
											</c:when>
											<%--多行输入--%>
											<c:when test="${attr.valueWay == '4'}">
												<c:set var="valInfo" value=""></c:set>
												<c:if test="${!noKeyAttrValMap.get(attr.attrId).isEmpty()}">
													<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
												</c:if>
												<p><textarea class="textarea-xlarge" maxlength="100"
															 attrId="noKeyAttr${attr.attrId}"><c:if test="${valInfo!=''}">${valInfo.attrVal}</c:if></textarea></p>
											</c:when>
										</c:choose>
									</li>
								</ul>
							</c:forEach>
						</div>
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">目标地域</h5>
						</header>
						<div class="form-label bd-bottom"><!--查询条件-->
							<input type="hidden" id="targetProd" name="targetProd">
							<ul>
								<li class="width-xlag">
									<p class="word3"><b class="red">*</b>选择商品目标地域</p>
									<p><input type="radio" name="isSaleNationwide" class="checkbox-small radioc " value="Y"
											  <c:if test="${productInfo.isSaleNationwide == 'Y'}">checked</c:if> required>全部地域</p>
									<p><input type="radio" name="isSaleNationwide" class="checkbox-small radiod" value="N"
											  <c:if test="${productInfo.isSaleNationwide == 'N'}">checked</c:if> >部分地域</p>
									<div id="check3"></div>
									<div id="check4" style="display:none;">
										<div class="cit-width cit-width-list2">
											<p class="width-xlag">
												<span id="areaNum">已选中省份${areaNum}个</span>
												<a href="javascript:void(0);" class="city" id="changeArea">修改</a></p>
											<span id="areaName"></span>
										</div>
									</div>
								</li>
							</ul>
						</div>
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">发票信息</h5>
						</header>
						<div class="form-label bd-bottom"><!--查询条件-->
							<ul>
								<li class="width-xlag">
									<p class="word3"><b class="red">*</b>是否提供发票</p>
									<p><input type="radio" name="isInvoice" class="checkbox-small radioc " value="Y"
											  <c:if test="${productInfo.isInvoice == 'Y'}">checked</c:if> required>提供</p>
									<p><input type="radio" name="isInvoice"class="checkbox-small radiod" value="N"
											  <c:if test="${productInfo.isInvoice == 'N'}">checked</c:if> >不提供</p>
								</li>
							</ul>
						</div>
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">上架类型</h5>
						</header>
						<div class="form-label bd-bottom"><!--查询条件-->
							<ul>
								<li class="width-xlag">
									<p class="word3"><b class="red">*</b>选择上架类型</p>
									<p><input type="radio" name="upshelfType" value="1" required
											  class="checkbox-small" <c:if test="${productInfo.upshelfType == '1'}">checked</c:if>>立即上架</p>
									<p><input type="radio" name="upshelfType" value="2"
											  class="checkbox-small" <c:if test="${productInfo.upshelfType == '2'}">checked</c:if>>放入仓库</p>
									<p><input type="radio" name="upshelfType" value="4"
											  class="checkbox-small" <c:if test="${productInfo.upshelfType == '4'}">checked</c:if>>预售上架</p>
							</ul>
							<ul id="presaleTimeUl" <c:if test="${productInfo.upshelfType != '4'}">style="display: none;" </c:if>>
								<li id="choseDate" class="width-xlag">
									<p class="word3"><b class="red">*</b>预售时间</p>
									<p><input id="presaleBegin" name="presaleBeginTimeStr" class="int-text int-medium "
											  type="text" readonly value="<fmt:formatDate value="${productInfo.presaleBeginTime}" type="both"/>"
											  onfocus="WdatePicker({el:id,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'presaleEnd\');}'})"/>
										<span class="time"> <i class="fa  fa-calendar" ></i></span>
									</p>
									<p>至</p>
									<p><input id="presaleEnd" name="presaleEndTimeStr" class="int-text int-medium "
											  type="text" readonly value="<fmt:formatDate value="${productInfo.presaleEndTime}" type="both"/>"
											  onfocus="WdatePicker({el:id,readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'presaleBegin\');}'})"/>
										<span class="time"> <i class="fa  fa-calendar" ></i></span>
									</p>
								</li>
							</ul>
						</div>
						<!--标题-->
						<header class="main-box-header clearfix ">
							<h5 class="pull-left">商品预览图</h5>
						</header>
						<!--标题结束-->
						<div id="imgDiv" class="form-label bd-bottom"><!--查询条件-->
							<div id="filePicker" attrVal="0" style="display: none;">选择图片</div>
							<ul>
								<li class="width-xlag pl-40">
									提示：请上传商品主体正面照片jpg/png格式，不小于700x700px的方形图片，单张不能超过3M，最多6张。
								</li>
							</ul>
							<%
								String picSize = "78x78";
								IImageClient imageClient = IDPSClientFactory.getImageClient(SysCommonConstants.ProductImage.IDPSNS);
								request.setAttribute("imgClient",imageClient);
								request.setAttribute("picSize",picSize);
							%>
							<input id="prodPicStr" name="prodPicStr" type="hidden">
							<ul>
								<li class="width-xlag">
									<p class="word"><b class="red">*</b>商品主图</p>
									<div class="width-img" id="prod_pic_0">
										<c:set var="prodPicNum" value="${prodPic.size()}"></c:set>
										<c:forEach var="valInd" begin="0" end="5">
											<p class="img">
												<c:choose>
													<c:when test="${valInd<prodPicNum && prodPic.get(valInd)!=null}">
														<c:set var="valInfo" value="${prodPic.get(valInd)}"/>
														<img src="<c:out value="${imgClient.getImageUrl(valInfo.vfsId,valInfo.picType,picSize)}"/>"
															 imgId="${valInfo.vfsId}" imgType="${valInfo.picType}"
															 attrVal="0" picInd="${valInd}" id="prodPicId0ind${valInd}"/>
														<i class="fa fa-times"></i>
													</c:when>
													<c:otherwise>
														<img src="${_slpres}/images/sp-03-a.png" imgId="" imgType=""
															 attrVal="0" picInd="${valInd}" id="prodPicId0ind${valInd}"/>
														<i></i>
													</c:otherwise>
												</c:choose>

											</p>
										</c:forEach>
									</div>
									<p>
										<input type="button" class="biu-btn btn-primary btn-large mt-25" value="上传图片" attrVal = "0"/>
									</p>
								</li>
							</ul>
							<%-- 属性值图片 --%>
							<input id="prodAttrValPicStr" name="prodAttrValPicStr" type="hidden">
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
															<img src="<c:out value='${imgClient.getImageUrl(valInfo.vfsId,valInfo.picType,picSize)}'/>" imgId="${valInfo.vfsId}"
																 imgType="${valInfo.picType}" attrVal="${attrValInfo.attrValId}" picInd="${valInd}"
																 id="prodPicId${attrValInfo.attrValId}ind${valInd}" /><i class="fa fa-times"></i>
														</c:when>
														<c:otherwise>
															<img src="${_slpres}/images/sp-03-a.png" id="prodPicId${attrValInfo.attrValId}ind${valInd}" imgId="" imgType=""
																 attrVal="${attrValInfo.attrValId}" picInd="${valInd}"/><i></i>
														</c:otherwise>
													</c:choose>
												</p>
											</c:forEach>
										</div>
										<p>
											<input type="button" class="biu-btn btn-primary btn-large mt-25" value="上传图片" attrVal = "${attrValInfo.attrValId}"/>
										</p>
									</li>
								</ul>
							</c:forEach>
						</div>
						<!--标题-->
						<header class="main-box-header clearfix ">
							<h5 class="pull-left"><b class="red">*</b>商品详情图文描述</h5>
						</header>
						<!--标题结束-->
						<div class="form-label"><!--查询条件-->
							<ul>
								<li class="width-xlag">
									<p><div id="prodDetail">${prodDetail}</div></p>
								</li>
							</ul>
							<input type="hidden" name="proDetailContent" value="${productInfo.proDetailContent}">
							<textarea style="display: none;" name="detailConVal" id="detailConVal" commonText="/^[a-zA-Z_()0-9\u4e00-\u9fa5\-]+$/"></textarea>
							<!-- <ul>
								<li>
									<p>
									<input id="save" type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="保存">
									<input type="button" class="biu-btn  btn-primary  btn-auto  ml-5" value="返  回" onclick="window.history.go(-1);">
									</p>
								</li>
							</ul> -->
						</div>
						<div>
							<p class="center pr-30">
							<input id="save" type="button" class="biu-btn  btn-primary  btn-small  ml-5" value="保 存">
							<input type="button" class="biu-btn  btn-primary  btn-small  ml-5" value="返  回" onclick="javaScript:window.history.go(-1);">
							</p>
						</div>
						</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
<script type="text/javascript">
	var pager;
	var picAttrVal;
	var audiEntObjs = $.parseJSON('${audiEnts}');
	var audiAgentObjs = $.parseJSON('${audiAgents}');
	(function () {
		var timer;
		var elem = $('#elem');
		var elem1 = $('#elem1');
		var elem2 = $('#elem2');
		elem2.innerHTML = elem1.innerHTML;
		timer = setInterval(Scroll,40);
		function Scroll(){
			if(elem.scrollTop>=elem1.offsetHeight){
				elem.scrollTop -= elem1.offsetHeight;
			}else{
				elem.scrollTop += 1;
			}
		};
		elem.onmouseover = function(){
			clearInterval(timer);
		};
		elem.onmouseout = function(){
			timer = setInterval(Scroll,40);
		};
		<%-- 展示日历 --%>
		$('#choseDate').delegate('.fa.fa-calendar','click',function(){
			$(this).parent().prev().focus();
		});
		<%-- 上传图片 --%>
		$('.width-xlag').delegate('input[attrVal]','click',function(){
			var attrValTemp = $(this).attr('attrVal');
			if(!pager._checkProdPicUp(attrValTemp)){
				return;
			}
			picAttrVal = attrValTemp;
			var inputFiles = $("#filePicker input:file");
			if (window.console) {
				console.log("img up attrValId:" + picAttrVal);
				console.log(inputFiles.length);
			}
			if (inputFiles.length >0){
				inputFiles[0].click();
			}
		});
		<%-- 图片删除 --%>
		$(".img").delegate(".fa.fa-times","click",function(){
			//获得当前删除图标的上一个图片对象
			var imgObj = $(this).prev();
			var imgP = $(this).parent();
			imgP.removeAttr("style");
			var valDefId = imgObj.attr('attrVal');
			var attrInd = Number(imgObj.attr('picInd'));
			if (window.console) {
				console.log("attrValDefId:" + imgObj.attr('attrVal') + "index:" + attrInd);
			}
			pager._delProdPic(valDefId,attrInd);
		});

		seajs.use('app/jsp/product/edit', function (ProdEditPager) {
			pager = new ProdEditPager({element: document.body});
			pager.render();
		});
	})();
</script>
</html>
