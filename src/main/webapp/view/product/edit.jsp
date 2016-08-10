<%@ page import="com.ai.opt.sdk.components.idps.IDPSClientFactory" %>
<%@ page import="com.ai.paas.ipaas.image.IImageClient" %>
<%@ page import="com.ai.slp.product.web.constants.SysCommonConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>商品编辑</title>
	<%@ include file="/inc/inc.jsp" %>
	<link href="${_slpres }/styles/font-awesome.css" rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/global.css" rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/frame.css" rel="stylesheet" type="text/css">
	<link href="${_slpres }/styles/modular.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="" ></script>
</head>

<body>
<!--顶部菜单-->
<%@ include file="/inc/top-menu.jsp" %>
<!--顶部菜单结束-->
<!-- 左侧菜单 -->
<%@ include file="/inc/left-menu.jsp" %>
<!-- 左侧菜单结束 -->
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
<!--弹出选择目标省份弹出框 大-->
<div class="eject-big">
		<div class="eject-large eject-large2">		
			<div class="eject-large-title">
				<p>选择省市</p>
				<p class="img"><A href="#"></A></p>
			</div>
			<div class="eject-large-list">
			<div class="account-title eject-martop"><p>已选中<b><span id="dialogAreaNum">10</span></b>个<a id="finishTarget" href="javascript:void(0);" class="wnc">完成选择</a></p></div>
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
		<div class="eject-mask"></div>	
</div>
<!--弹出选择目标省份弹出框 大结束-->
<!--弹出受众选择弹出框 大-->
<div class="eject-big">
		<div class="eject-large" >		
			<div id="audiSelectTitle" class="eject-large-title">
				<p>选择<span id="audiType"></span>受众用户</p>
				<p class="img"><A href="javascript:void(0);"></A></p>
			</div>
			<div class="eject-large-list">
				<div id="audiSelectFinish" class="account-title eject-martop"><p>已选中<b id="audiNum">10</b>个<a href="javascript:void(0);" class="wnc">完成选择</a></p></div>
				<div id="audiSelectedDiv" class="eject-large-contacts">
				</div>
		    <div class="search-firm">
		    		<p>搜索<span id="selectType"></span>用户</p>
		    		<p><input id="selectName" type="input" class="int-text int-xlarge" /></p>
		    		<p><input id="searchBut" type="button" value="查询" class="biu-btn btn-blue blue-btn"></p>
		    </div>
		    <div class="user-list-title-list">
		     	<ul id="userList">请输入公司名称进行搜索</ul>
		     <div id="showMessageDiv"></div>
		    </div> 	
			</div>	
		 <!--分页-->
	    <div class="paging-large">
	            <ul id="pagination-ul">
	             </ul>
	      </div>     
		
		</div>	
		<div class="eject-mask"></div>	
</div>
<script id="userListTemple" type="text/template">
<li>
	<p><input type="checkbox" class="checkbox-medium" value="{{:userId}}" title="{{:custName}}"></p>
	<p>{{:custName}}</p>
</li>
</script>
<!--弹出受众选择弹出框 大结束-->

<div class="wrapper"><!--外围框架-->
	<input type="file" id="uploadFile" style="display: none;">
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
					<p><a href="#">商城商品管理</a>></p>
					<p>待编辑商品</p>
				</li>
			</ul>
		</div>
		<!--标签结束-->

		<div class="form-wrapper"><!--白底内侧-->
			<div class="nav-tplist-wrapper"><!--白底内侧-->
				<div class="nav-tplist-title nav-tplist-title-border  nav-tplist-title-edit">
					<ul>
						<li><span>*</span>标注为必填项</li>
					</ul>
				</div>
				<form id="prodForm" action="${_base}/prodedit/save" method="post">
					<input type="hidden" name="prodId" value="${productInfo.prodId}">
				<div class="nav-form-title">商品基础信息</div> <!--标题-->
				<div class="nav-form nav-form-border"><!--查询条件-->
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>类目信息</p>
							<p>
							<c:forEach var="catInfo" items="${catLinkList}"
							 varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if></c:forEach>
							</p>
						</li>
					</ul>
					<ul>
						<li>
							<p class="word"><b class="red">*</b>商品类型</p>
							<p>${prodType}</p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>商品名称</p>
							<p><input type="text" id="prodName" name="prodName" class="int-text int-xlarge" value="${productInfo.prodName}" maxlength="60">
							</p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word">商品卖点</p>
							<p><textarea name="productSellPoint" class="int-text textarea-xlarge" maxlength="100">${productInfo.productSellPoint}</textarea></p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>商品有效期</p>
							<%-- 目前指定周期类型为:灵活有效期 --%>
							<input type="hidden" name="activeType" value="2">
							<p><input type="text" id="activeCycle" name="activeCycle" class="int-text int-small" value="${productInfo.activeCycle}" maxlength="5"></p>
							<p><select class="select select-small" name="unit">
								<c:forEach var="unit" items="${prodUnits}">
									<option value="${unit.columnValue}">${unit.columnDesc}</option>
								</c:forEach>
							</select></p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>是否快充商品</p>
							<p><input type="radio" name="rechargeType" class="checkbox-small" value="D"
									  <c:if test="${productInfo.rechargeType == 'D'}">checked</c:if>>是</p>
							<p><input type="radio" name="rechargeType" class="checkbox-small" value="C"
									  <c:if test="${productInfo.rechargeType == 'C'}">checked</c:if>>否</p>
							<%--<p><img src="${_slpres}/images/icon-a.png"/>请完善此必填项信息</p>--%>
						</li>
					</ul>
				</div>
				<div class="nav-form-title">商品关键属性</div> <!--标题-->
				<div class="nav-form nav-form-border"><!--关键属性显示-->
					<c:forEach var="aav" items="${attrAndVal}">
						<ul>
							<li>
								<p class="word">${aav.key.attrName}</p>
								<c:choose>
									<%--多选--%>
									<c:when test="${aav.key.attrType == '2'}">
										<div class="cit-width">
											<c:forEach var="attrVal" items="${aav.value}">
												<p>${attrVal.attrVal}</p></c:forEach>
										</div>
									</c:when>
									<c:otherwise>
										<p>${aav.value.get(0).attrVal}</p>
									</c:otherwise>
								</c:choose>
							</li>
						</ul>
					</c:forEach>
				</div>
				<div class="nav-form-title">商品非关键属性</div> <!--标题-->
				<div class="nav-form nav-form-border" id="noKeyAttrDiv"><!--非关键属性条件-->
					<input type="hidden" id="noKeyAttrStr" name="noKeyAttrStr">
					<c:forEach var="attr" items="${noKeyAttr}">
						<ul>
							<li class="width-xlag">
						<p class="word" attrId="${attr.attrId}" valueType="${attr.valueWay}">${attr.attrName}</p>
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
								<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
								<p><input type="text" class="int-text int-xlarge" attrId="noKeyAttr${attr.attrId}" maxlength="100"
										  <c:if test="${valInfo!=null}">value="${valInfo.attrVal}"</c:if> ></p>
							</c:when>
							<%--多行输入--%>
							<c:when test="${attr.valueWay == '4'}">
								<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
								<p><textarea class="textarea-xlarge" maxlength="100"
											 attrId="noKeyAttr${attr.attrId}"><c:if test="${valInfo!=null}">${valInfo.attrVal}</c:if></textarea></p>
							</c:when>
						</c:choose>
							</li>
						</ul>
					</c:forEach>
				</div>
				<div class="nav-form-title">其他设置</div> <!--标题-->
				<div class="nav-form nav-form-border"><!--查询条件-->
					<ul>
						<li class="width-xlag">
							<p class="word">话费/流量适用号段</p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>运营商</p>
							<c:forEach var="orgId" items="${orgIds}">
								<p><input type="radio" name="basicOrgId"
										  <c:if test="${productInfo.basicOrgId == orgId.columnValue}">checked</c:if>
										  class="checkbox-small" value="${orgId.columnValue}">${orgId.columnDesc}</p>
							</c:forEach>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word">选择商品目标受众类型</p>
						</li>
					</ul>
					<%-- 个人用户 --%>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>个人用户</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiPerson == '-1'}">checked</c:if>
									  name="audiencesPerson" value="-1">全部可见</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiPerson != '-1'}">checked</c:if>
									  name="audiencesPerson" value="0">全部不可见</p>
							<%--<p><img src="${_slpres}/images/icon-a.png">请完善此必填项信息</p>--%>
						</li>
					</ul>
					<%-- 企业用户 --%>
					<input id="audiEntIds" name="audiEntIds" type="hidden">
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>企业用户</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiEnt == '-1'}">checked</c:if>
									  name="audiencesEnterprise" value="-1">全部可见</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiEnt == '1'}">checked</c:if>
									  name="audiencesEnterprise" value="1">部分可见</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiEnt != '1' && audiEnt != '-1'}">checked</c:if>
									  name="audiencesEnterprise" value="0">全部不可见</p>
							<%--<p><img src="${_slpres}/images/icon-a.png">请完善此必填项信息</p>--%>
							<div id="entAudiDiv" class="cit-width cit-width-list2" <c:if test="${audiEnt != '1'}">style="display:none;"</c:if>>

							</div>
							<div id="entAudiDivMore" class="cit-width open" style="display:none;">

							</div>
						</li>
					</ul>
					<script id="cartProdTemple" type="text/template">

					</script>
					<%-- 代理商用户 --%>
					<input id="audiAgentIds" name="audiAgentIds" type="hidden">
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>代理商用户</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiAgent == '-1'}">checked</c:if>
									  name="audiencesAgents" value="-1">全部可见</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiAgent == '1'}">checked</c:if>
									  name="audiencesAgents" value="1">部分可见</p>
							<p><input type="radio" class="checkbox-small" <c:if test="${audiAgent != '1' && audiAgent != '-1'}">checked</c:if>
									  name="audiencesAgents" value="0">全部不可见</p>
							<div id="agentAudiDiv" class="cit-width cit-width-list2" <c:if test="${audiAgent != '1'}">style="display:none;"</c:if>>

							</div>
							<div id="agentAudiDivMore" class="cit-width open" style="display:none;">

							</div>
						</li>
					</ul>
					<%-- 亚信平台代销 --%>
					<ul>
						<li class="width-xlag">
							<p class="word">亚信平台代销</p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>是否允许</p>
							<p><input type="radio" class="checkbox-small" name="isReplaceSell" value="Y"
									  <c:if test="${productInfo.isReplaceSell == 'Y'}">checked</c:if>>允许亚信代销</p>
							<p><input type="radio" class="checkbox-small" name="isReplaceSell" value="N"
									  <c:if test="${productInfo.isReplaceSell == 'N'}">checked</c:if>>不允许亚信代销</p>
						</li>
					</ul>
					<%-- 目标地域 --%>
					<ul>
						<li class="width-xlag">
							<p class="word">商品目标地域</p>
						</li>
					</ul>
					<input type="hidden" id="targetProd" name="targetProd">
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>选择商品目标地域</p>
							<p><input type="radio" name="isSaleNationwide" class="checkbox-small radioc " value="Y"
									  <c:if test="${productInfo.isSaleNationwide == 'Y'}">checked</c:if> >全国</p>
							<p><input type="radio" name="isSaleNationwide"class="checkbox-small radiod city" value="N"
									  <c:if test="${productInfo.isSaleNationwide == 'N'}">checked</c:if> >部分</p>
							<div id="check3"></div>
							<div id="check4" style="display:none;">
								<div class="cit-width cit-width-list2">
									<p class="width-xlag"><span id="areaNum">已选中省份${areaNum}个</span><a href="javascript:void(0);" class="city">修改</a></p>
									<span id="areaName"></span>
								</div>
							</div>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word">商品上架时间</p>
						</li>
					</ul>
					<ul>
						<li class="width-xlag">
							<p class="word"><b class="red">*</b>选择商品上架时间</p>
							<p><input type="radio" name="upshelfType" value="1"
									  class="checkbox-small" <c:if test="${productInfo.upshelfType != '2'}">checked</c:if>>立即上架</p>
							<p><input type="radio" name="upshelfType" value="2"
									  class="checkbox-small" <c:if test="${productInfo.upshelfType == '2'}">checked</c:if>>放入仓库</p>
							<%--<p><input type="radio" class="checkbox-small">定时上架</p>--%>
							<%--<p><input type="text" class="int-small"><a href="#" class="ccc"><i class="icon-calendar"></i></a></p>--%>
						</li>
					</ul>
				</div>
				<div class="nav-form-title">商品图片</div> <!--标题-->
				<div class="nav-form nav-form-border"><!--查询条件-->
					<%
						String picSize = "78x78";
						IImageClient imageClient = IDPSClientFactory.getImageClient(SysCommonConstants.ProductImage.IDPSNS);
						request.setAttribute("imgClient",imageClient);
						request.setAttribute("picSize",picSize);
					%>
					<ul>
						<li class="width-xlag">
							提示：请上传商品主体正面照片jpg/png格式，不小于700x700px的方形图片，单张不能超过3M，最多6张。
						</li>
					</ul>
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
												<i class="icon-remove-sign"></i>
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
							<p ><input type="button" class="biu-btn btn-blue file-btn btn-large mt-10" value="上传图片" attrVal = "0"/>
								<!--<input type="file" class="file">--></p>
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
													 imgType="${valInfo.picType}" attrVal="${attrValPicEnt.key.attrValId}" picInd="${valInd}"
													 id="prodPicId${attrValPicEnt.key.attrValId}ind${valInd}" /><i class="icon-remove-sign"></i>
											</c:when>
											<c:otherwise>
												<img src="${_slpres}/images/sp-03-a.png" id="prodPicId${attrValPicEnt.key.attrValId}ind${valInd}" imgId="" imgType=""
													 attrVal="${attrValPicEnt.key.attrValId}" picInd="${valInd}"/><i></i>
											</c:otherwise>
										</c:choose>

									</p>
								</c:forEach>
							</div>
							<p ><input type="button" class="biu-btn btn-blue file-btn btn-large mt-10" value="上传图片" attrVal = "${attrValPicEnt.key.attrValId}"/>
								<!--<input type="file" class="file">--></p>
						</li>
					</ul>
					</c:forEach>
				</div>
				<div class="nav-form-title">商品详情图文描述</div> <!--标题-->
				<div class="nav-form" id="detailDiv"><!--查询条件-->
					<ul>
						<li class="width-xlag">
							<p><div id="prodDetail">${prodDetail}</div></p>
						</li>
					</ul>
					<input type="hidden" name="proDetailContent" value="${productInfo.proDetailContent}">
					<textarea style="display: none;" name="detailConVal" id="detailConVal"></textarea>
					<ul>
						<li>
							<%--<p><input id="submitAudit" type="button" class="blling-btn width-btn" value="提交审核"></p>--%>
							<p><input id="save" type="button" class="biu-btn btn-blue btn-large mr-10" value="保存"></p>
							<%--<p><input type="button" class="blling-btn width-btn" value="预览"></p>--%>
						</li>
					</ul>
				</div>
				</form>
			</div>
		</div>
	</div>
</div>	
<!-- footer -->
<%@ include file="/inc/foot.jsp" %>
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
		<%-- 显示受众更多部分 --%>
		$(".cit-width").delegate('.zk','click',function () {
			$(this).children('i').toggleClass("icon-angle-down  icon-angle-up");
			$(this).parents().children('.open').slideToggle(100);
		});
		<%-- 显示受众选择页面 --%>
		$('.cit-width-list2').delegate('.modify','click',function(){
			console.log("client:"+$(this).attr('audi'));
			pager._showAudiSelect($(this).attr('audi'));
		});
		<%-- 删除受众用户 --%>
		$('#audiSelectedDiv').delegate('.icon-remove-sign','click',function(){
			console.log('the remode audi userId:'+$(this).attr('userId'));
			pager._delAudi($(this).attr('userId'));
			$(this).parent().parent().remove();
		});
		<%-- 关闭受众选择窗口 --%>
		$('#audiSelectTitle').delegate('.img','click',function(){
			pager._flushAudiInfo();
		});
		<%-- 完成受众选择 --%>
		$('#audiSelectFinish').delegate('.wnc','click',function(){
			pager._flushAudiInfo();
		});
		<%-- 选择受众 --%>
		$('#userList').delegate('.checkbox-medium','click',function(){
			var userId = $(this).val(),userName = $(this).attr('title');
			console.log("The user:"+userId+","+userName+","+$(this).is(':checked'));
			//若是选中,则添加,否则为删除
			if($(this).is(':checked')){
				pager._addAudi(userId,userName);
			}else{
				pager._delAudi(userId);
			}
		});
		<%-- 上传图片 --%>
		$('.nav-form-border').delegate('.file-btn','click',function(){
			picAttrVal = $(this).attr('attrVal');
			console.log("图片上传属性值:"+picAttrVal);
			return $("#uploadFile").click();
		});
		<%-- 图片删除 --%>
		$(".img").delegate("i[class='icon-remove-sign']","click",function(){
			//获得当前删除图标的上一个图片对象
			var imgObj = $(this).prev();
			var imgP = $(this).parent();
			imgP.removeAttr("style");
			var valDefId = imgObj.attr('attrVal');
			var attrInd = Number(imgObj.attr('picInd'));
			console.log("attrValDefId:"+imgObj.attr('attrVal')+"index:"+attrInd);
			pager._delProdPic(valDefId,attrInd);
		});
		seajs.use('app/jsp/product/edit', function (ProdEditPager) {
			pager = new ProdEditPager({element: document.body});
			pager.render();
		});
	})();
</script>
</html>
