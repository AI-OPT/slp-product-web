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
<div class="eject-big">
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
</div>
<!-- 确认提示框结束 -->

<!-- 拒绝提示框 -->
<div class="eject-big">
    <div class="eject-samll" id="refuse-small">
        <div class="eject-medium-title">
            <p>审核拒接操作确认！</p>
            <p id="refuseCloseImg" class="img"><i class="fa fa-times"></i></p>
        </div>

        <div class="eject-medium-complete">
             <div class="form-label">
			<form id="prodAttrForm">
              <ul> 
                <li>
                   <p class="word"><span>*</span>拒绝上架原因</p>
                   <p>
                   	<select id="refuseReason" class="select select-medium">
	                   	<option value="1">信息有误</option>
	                   	<option value="2">信息为完善</option>
	                   	<option value="3">其他</option>
                   	</select>
                   </p>
              	 </li>
          	 </ul>
	           <ul>	
	               <li>
	                   <p class="word"><span>*</span>问题描述</p>
	                   <p><textarea id="refuseDes" type="text" class="int-text int-medium"  style="width:190px;height:80px;"></textarea></p>
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
                                    <li class="col-md-6">
                                        <p class="word">类目信息：</p>
                                        <p>
                                        <c:forEach var="catInfo" items="${catLinkList}"
                                               varStatus="stat">${catInfo.productCatName}<c:if test="${!stat.last}">&gt;</c:if>
	                                    </c:forEach>
	                                    </p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">商品类型：</p>
                                        <p>${prodType}</p>
                                    </li>
                                </ul>
                                <ul class="big-word">
                                    <li class="col-md-6">
                                        <p class="word">商品名称：</p>
                                        <p>${productInfo.prodName}</p>
                                    </li>
                                </ul>
                                <ul>
                                    <li class="col-md-6">
                                        <p class="word">商品卖点：</p>
                                        <p>${productInfo.productSellPoint}</p>
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
                                            <p class="word">${aav.key.attrName}：</p>
                                            <c:forEach var="attrVal" items="${aav.value}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach>
                            </div>
                            <!-- 非关键属性 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品非关键属性</h5>
                            </header>
                             <div class="form-label  bd-bottom">
                           		<%-- <c:forEach var="attr" items="${noKeyAttr}">
                                    <ul>
                                        <li class="col-md-6">
                                            <p class="word">${attr.attrName}：</p>
                                            <c:forEach var="attrVal" items="${noKeyAttrValMap.get(attr.attrId)}">
                                                <p>${attrVal.attrVal}</p>
                                            </c:forEach>
                                        </li>
                                    </ul>
                                </c:forEach> --%>
                            
                            	<c:forEach var="attr" items="${noKeyAttr}">
									<ul>
										<li class="width-xlag">
										<p class="word" attrId="${attr.attrId}" valueType="${attr.valueWay}">${attr.attrName}:</p>
										<c:choose>
											<%-- 下拉选择 --%>
											<c:when test="${attr.valueWay == '1'}">
												
												<select class="select select-medium" disabled="disabled" attrId="noKeyAttr${attr.attrId}">
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
														<p><input type="checkbox" disabled=“disabled” class="checkbox-small" attrId="noKeyAttr${attr.attrId}" value="${valInfo.attrValId}"
																  <c:if test="${valInfo.productAttrValId != null}">checked</c:if> >${valInfo.attrVal}</p>
													</c:forEach>
												</div>
											</c:when>
											<%--单行输入--%>
											<c:when test="${attr.valueWay == '3'}">
												<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
												<p><input type="text" readOnly="true"  class="int-text int-xlarge" attrId="noKeyAttr${attr.attrId}" maxlength="100"
														  <c:if test="${valInfo!=null}">value="${valInfo.attrVal}"</c:if> ></p>
											</c:when>
											<%--多行输入--%>
											<c:when test="${attr.valueWay == '4'}">
												<c:set var="valInfo" value="${noKeyAttrValMap.get(attr.attrId).get(0)}"></c:set>
												<p><textarea class="textarea-xlarge" readOnly="true"  maxlength="100"
															 attrId="noKeyAttr${attr.attrId}"><c:if test="${valInfo!=null}">${valInfo.attrVal}</c:if></textarea></p>
											</c:when>
										</c:choose>
										</li>
									</ul>
								</c:forEach>
                            </div>
                            <!-- 选择商品目标地域 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">选择商品目标地域</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<c:forEach var="targetArea" items="${prodTargetArea}">
                            		<c:forEach var="targetAreaValue" items="${targetArea.targetArea}">
                            			<p>${targetAreaValue}</p>
                            		</c:forEach>
                            	</c:forEach>
                            </div>
                            <!-- 预售设置 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">预售设置</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                                <ul>
                           		   <li class="col-md-6">
		                            	<p class="word">
			                            <c:if test="${upType == '4'}">预售</c:if>
			                            <c:if test="${upType != '4'}">非预售商品</c:if>
		                            	</p>
                                    </li>
                            	</ul>
                            </div>
                            <!-- 发票信息 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">发票信息</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<ul>
                           		   <li class="col-md-6">
		                            	<p class="word">是否提供发票:</P>
		                            	<p>
		                            	<c:if test="${invoice == 'Y'}">提供发票</c:if>
			                            <c:if test="${invoice == 'N'}">不提供发票</c:if>
		                            	</p>
                                    </li>
                            	</ul>
                            </div>
                            <!-- 商品上架时间 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品上架时间</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<ul>
                           		   <li class="col-md-6">
		                            	<p class="word">
		                            	<c:if test="${upType == '1'}">立即上架</c:if>
			                            <c:if test="${upType == '2'}">放入仓库</c:if>
		                            	</p>
                                    </li>
                            	</ul>
                            </div>
                            <!-- 商品预览图 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品预览图</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<div class="width-img" id="prod_pic_0">
									<c:set var="prodPicNum" value="${prodPic.size()}"></c:set>
									<c:forEach var="valInd" begin="0" end="5">
										<p class="col-md-2">
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
                            </div>
                            <!-- 商品预览图 -->
                            <header class="main-box-header clearfix">
                                <h5 class="pull-left">商品图文描述</h5>
                            </header>
                            <div class="form-label  bd-bottom">
                            	<ul>
                           		   <li class="col-md-12">
		                            	<p class="word">
		                            		${prodDetail}
		                            	</p>
                                    </li>
                            	</ul>
                            </div>
                            
	                        <div class="row pt-30">
	                            <p class="center pr-30 mt-30">
	                                <input id="auditMoreBtn" type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
	                                       value="审核通过">
	                                <input id="refuseMoreBtn" type="button" class="biu-btn  btn-primary btn-blue btn-auto  ml-5"
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