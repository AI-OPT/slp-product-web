define('app/jsp/product/edit', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
		Events = require('arale-events/1.2.0/events'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("artDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
	require("ckeditor/ckeditor.js")
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
	var prodDetail = 'prodDetail';
	var editDom;
	//当前操作受众类型
	var nowAudiType;
	//查询受众用户类型
	var selectUserType;

    //定义页面组件类
    var ProdEditPager = Widget.extend({
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
			DEFAULT_PAGE_SIZE: 30,
			AUDI_ENT_TYPE: "ent",
			AUDI_AGENT_TYPE: "agent",
			USER_ENT_TYPE: "11",
			USER_AGENT_TYPE: "12",
			FILE_MAX_SIZE:3145728,//大小为3*1024*1024的值
			FILE_TYPES:['.jpg','.png']
    	},
    	//事件代理
    	events: {
			"click input:checkbox[name='targetProv']":"_showTarget",
			"click input:radio[name='audiencesEnterprise']":"_showAudi",
			"click input:radio[name='audiencesAgents']":"_showAudi",
			"click #finishTarget":"_finishTarget",
			"click #searchBut":"_searchBtnClick",
			"change #uploadFile":"_uploadFile",
			//保存数据
			"click #save":"_saveProd"
        },
    	//重写父类
    	setup: function () {
			ProdEditPager.superclass.setup.call(this);
			editDom = CKEDITOR.replace(prodDetail);
			this._showPartTarget();
			this._showTarget();
			this._changeAudiEnt();
			this._changeAudiAgent();
		},
		//刷新受众信息
		_flushAudiInfo:function(){
			//企业
			if (ProdEditPager.AUDI_ENT_TYPE==nowAudiType){
				this._changeAudiEnt();
			}//代理商
			else if(ProdEditPager.AUDI_AGENT_TYPE==nowAudiType){
				this._changeAudiAgent();
			}
			//清除已有搜索
			$('#userList').text("请输入公司名称进行搜索");
			$('#selectName').val('');
			$('#pagination-ul').empty();
			$('.eject-mask').fadeOut(100);
			$('.eject-large').slideUp(150);
		},
		//显示受众用户选择窗口
		_showAudiSelect:function(audiType){
			nowAudiType = audiType;
			console.log("show audi type:"+nowAudiType);
			var audiMap;
			var typeName;
			//企业
			if (ProdEditPager.AUDI_ENT_TYPE==nowAudiType){
				audiMap = audiEntObjs;
				typeName = "企业";
				selectUserType = ProdEditPager.USER_ENT_TYPE;
			}//代理商
			else if(ProdEditPager.AUDI_AGENT_TYPE==nowAudiType){
				audiMap = audiAgentObjs;
				typeName = "代理商";
				selectUserType = ProdEditPager.USER_AGENT_TYPE;
			}else
				return;
			this._showCheckAudi(audiMap);
			$("#audiType").text(typeName);
			$("#selectType").text(typeName);
			$('.eject-mask').fadeIn(100);
			$('.eject-large').slideDown(200);
		},
		//删除受众用户
		_delAudi:function (userId){
			console.log("del audi userId:"+userId);
			var audiMap;
			//企业
			if (ProdEditPager.AUDI_ENT_TYPE==nowAudiType){
				delete(audiEntObjs[userId]);
				audiMap = audiEntObjs;
			}//代理商
			else if(ProdEditPager.AUDI_AGENT_TYPE==nowAudiType){
				delete(audiAgentObjs[userId]);
				audiMap = audiAgentObjs;
			}else {
				return;
			}
			this._showCheckAudi(audiMap);
		},
		//添加受众用户
		_addAudi:function(userId,userName){
			console.log("add user audi,id:"+userId+",userName:"+userName);
			var audiMap;
			//企业
			if (ProdEditPager.AUDI_ENT_TYPE==nowAudiType){
				audiEntObjs[userId] = userName;
				audiMap = audiEntObjs;
			}//代理商
			else if(ProdEditPager.AUDI_AGENT_TYPE==nowAudiType){
				audiAgentObjs[userId]=userName;
				audiMap = audiAgentObjs;
			}else{
				return;
			}
			this._showCheckAudi(audiMap);
		},
		//显示选中受众
		_showCheckAudi:function(audiMap){
			var audNum = Object.keys(audiMap).length;
			$('#audiNum').text(audNum);
			//删除原来受众信息
			$('#audiSelectedDiv').html("");
			for (var key in audiMap) {
				$('#audiSelectedDiv').append("<p>"+audiMap[key]+"<a href=\"javascript:void(0);\"><i class=\"icon-remove-sign\" userId='"+key+"'></i></a></p>");
			}
		},
		_showAudi:function(){
			var partTarget = $("input:radio[name='audiencesEnterprise']:checked").val();
			if ('1' == partTarget){
				$('#entAudiDiv').show();
			}else {
				$('#entAudiDiv').hide();
				$('#entAudiDivMore').hide();
			}
			var audiAgent = $("input:radio[name='audiencesAgents']:checked").val();
			if ('1' == audiAgent){
				$('#agentAudiDiv').show();
			}else {
				$('#agentAudiDiv').hide();
				$('#agentAudiDivMore').hide();
			}
		},
		//对企业受众进行处理
		_changeAudiEnt:function(){
			//获取audiEntObjs
			var ind = 0;
			var audiId = [];
			$('#entAudiDiv').empty();
			$('#entAudiDivMore').empty();
			for (var key in audiEntObjs) {
				audiId.push(key);
				if (ind < 20)
					$('#entAudiDiv').append("<p>"+audiEntObjs[key]+"、</p>");
				else
					$('#entAudiDivMore').append("<p>"+audiEntObjs[key]+"、</p>");
				ind ++;
			}
			$('#entAudiDiv').prepend("<p class=\"width-xlag\">已选中"+audiId.length+"个<a href=\"javascript:void(0);\" class=\"modify\" audi=\""+ProdEditPager.AUDI_ENT_TYPE+"\" >修改</a></p>");
			$('#audiEntIds').val(JSON.stringify(audiId));
			if(audiId.length>20){
				$('#entAudiDiv').append("<p><a href=\"javascript:void(0);\" class=\"zk\">显示更多<i class=\"icon-angle-down\"></i></a></p>");
			}
		},
		//对代理商受众进行处理
		_changeAudiAgent:function(){
			//获取audiEntObjs
			var ind = 0;
			var audiId = [];
			$('#agentAudiDiv').empty();
			$('#agentAudiDivMore').empty();
			for (var key in audiAgentObjs) {
				audiId.push(key);
				if (ind < 20)
					$('#agentAudiDiv').append("<p>"+audiAgentObjs[key]+"、</p>");
				else
					$('#agentAudiDivMore').append("<p>"+audiAgentObjs[key]+"、</p>");
				ind ++;
			}
			$('#agentAudiDiv').prepend("<p class=\"width-xlag\">已选中"+audiId.length+"个<a href=\"javascript:void(0);\" class=\"modify\" audi=\""+ProdEditPager.AUDI_AGENT_TYPE+"\">修改</a></p>");
			$('#audiAgentIds').val(JSON.stringify(audiId));
			if(audiId.length>20){
				$('#agentAudiDiv').append("<p><a href=\"javascript:void(0);\" class=\"zk\">显示更多<i class=\"icon-angle-down\"></i></a></p>");
			}
		},
		//完成目标地域选择
		_finishTarget:function(){
			$('.eject-mask').fadeOut(100);
			$('.eject-large2').slideUp(150);
		},
		//显示目标地域的信息
		_showPartTarget:function(){
			var partTarget = $("input[name='isSaleNationwide']:checked").val();
			if ('N' == partTarget){
				$('#check4').show();
			}
		},
		//改变目标地域
		_showTarget:function(){
			//选中省份的名称字符串
			var checkProvStr = new Array();
			var checkNum = 0;
			var provArry = [];
			//获取所有已选中省份
			$('input:checkbox[name=targetProv]:checked').each(function(i){
				checkNum ++;
				provArry.push(Number($(this).val()));
				checkProvStr.push($(this).attr("title"));
			});
			$('#dialogAreaNum').html(checkNum);
			$('#areaNum').text('已选中省份'+checkNum+'个');
			$('#areaName').text(checkProvStr.join("、"));
			if (provArry.length>0){
				console.log(JSON.stringify(provArry));
				$('#targetProd').val(JSON.stringify(provArry));
			}else
				$('#targetProd').val('');
		},
    	//保存商品信息
      	_saveProd:function() {
			var _this = this;
			//验证通过,则进行保存操作.
			if(this._checkInput() && this._convertProdPic() && this._convertNoKeyAttr()){
				//获取editor中内容
				$("#detailConVal").val(editDom.getData());
				console.log($('#detailConVal').val());
				ajaxController.ajax({
					type: "post",
					processing: true,
					message: "保存中，请等待...",
					url: _base+"/prodedit/save",
					data:$('#prodForm').serializeArray(),
					success: function(data){
						if("1"===data.statusCode){
							//_this._showMsg("保存成功");
							//保存成功,回退到进入的列表页
							window.history.go(-1);
							//window.location.href = _base+"/prodquery/add";
						}
					}
				});
			}

		},
		//将图片信息转换为json字符串
		_convertProdPic:function(){
			var prodPic = [];
			var prodAttrPic = [];
			//获取属性值图
			$(".width-img img[imgId!='']").each(function(i){
				var attrVal = $(this).attr('attrVal');
				//设置该图片的信息
				console.log("已设置图片:"+$(this).attr('attrVal')+",序号:"+$(this).attr('picInd'));
				console.log("====图片信息:"+$(this).attr('imgId')+",");
				//主图图片
				if (attrVal=='0'){
					var pic = {'attrvalueDefId':'0','vfsId':$(this).attr('imgId'),'picType':$(this).attr('imgType'),'serialNumber':$(this).attr('picInd')};
					prodPic.push(pic);
				}else {
					var pic = {'attrvalueDefId':$(this).attr('attrVal'),'vfsId':$(this).attr('imgId'),'picType':$(this).attr('imgType'),'serialNumber':$(this).attr('picInd')};
					prodAttrPic.push(pic);
				}
			});
			if (prodPic.length <1){
				this._showMsg("商品主图不能为空,至少有一张图片.");
				return false;
			}
			$('#prodPicStr').val(JSON.stringify(prodPic));
			$('#prodAttrValPicStr').val(JSON.stringify(prodAttrPic));
			return true;
		},
		//将非关键属性转换json字符串
		_convertNoKeyAttr:function(){
			var noKeyVal = {};
			//获取所有
			$("#noKeyAttrDiv .word").each(function(i){
				var attrId = $(this).attr('attrId');
				var valWay = $(this).attr('valueType');
				var attrValArray = [];
				switch (valWay){
					case '1'://下拉
						var obj = $("#noKeyAttrDiv select[attrId='noKeyAttr"+attrId+"']")[0];
						var val = obj.value;
						attrValArray.push({'attrValId':val,'attrVal':'','attrVal2':''});
						break;
					case '2'://多选
						$("#noKeyAttrDiv input:checkbox[attrId='noKeyAttr"+attrId+"']:checked").each(function(i){
							attrValArray.push({'attrValId':$(this).val(),'attrVal':'','attrVal2':''});
						});
						break;
					case '3'://单行输入
						var val = $("#noKeyAttrDiv input[attrId='noKeyAttr"+attrId+"'")[0].value;
						attrValArray.push({'attrValId':'','attrVal':val,'attrVal2':''});
						break;
					case '4'://多行输入
						var val = $("#noKeyAttrDiv textarea[attrId='noKeyAttr"+attrId+"'")[0].value;
						attrValArray.push({'attrValId':'','attrVal':val,'attrVal2':''});
						break;

				};
				noKeyVal[attrId] = attrValArray;
			});
			var noKeyJsonStr = JSON.stringify(noKeyVal,null);
			console.log($('#noKeyAttrStr').val());
			$('#noKeyAttrStr').val(noKeyJsonStr);
			return true;
		},
		//查询用户
		_searchBtnClick: function() {
			var _this = this;
			var selectName = $("#selectName").val();
			if (selectName == null || '' == selectName) {
				this._showMsg("请输入要查询公司名称");
				return;
			}
			$("#pagination-ul").runnerPagination({
				url: _base + "/home/queryuser",
				method: "POST",
				dataType: "json",
				renderId:"userList",
				messageId:"showMessageDiv",
				processing: true,
				data: {"userName":selectName,"userType":selectUserType},
				pageSize: ProdEditPager.DEFAULT_PAGE_SIZE,
				visiblePages: 5,
				message: "正在为您查询数据..",
				render: function (data) {
					if (data != null && data != 'undefined' && data.length > 0) {
						var template = $.templates("#userListTemple");
						var htmlOutput = template.render(data);
						$("#userList").html(htmlOutput);
					} else {
						$("#userList").html("没有搜索到相关信息");
					}
				}
			});
		},
		//上传文件
		_uploadFile:function(){
			var _this = this;
			var checkFileData = this._checkFileData();
			if(!checkFileData){
				this._closeDialog();
				return false;
			}
			var form = new FormData();
			form.append("uploadFile", document.getElementById("uploadFile").files[0]);
			form.append("imgSize","78x78");

			// XMLHttpRequest 对象
			var xhr = new XMLHttpRequest();
			var uploadURL = _base+"/home/upImg";
			xhr.open("post", uploadURL, true);

			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {// 4 = "loaded"
					if (xhr.status == 200) {
						var responseData = $.parseJSON(xhr.response);
						if(responseData.statusCode=="1"){
							var fileData = responseData.data;
							//文件上传成功
							if(fileData){
								//文件标识
								var filePosition = fileData.vfsId;
								//文件类型
								var fileName = fileData.fileType;
								//文件地址
								var fileUrl = fileData.imgUrl;
								_this._showMsg("上传成功:"+filePosition+","+fileName);
								_this._closeDialog();
								_this._showProdPicPreview(filePosition,fileName,fileUrl);
								return;
							}
						}//上传失败
						else if(responseData.statusCode=="0"){
							var msgDialog = Dialog({
								title: '提示',
								content: responseData.statusInfo,
								ok: function () {
									this.close();
								}
							});
							_this._closeDialog();
							msgDialog.showModal();
							return;
						}
					}
					var msgDialog = Dialog({
						title: '提示',
						content: "文件上失败,状态:"+xhr.status,
						ok: function () {
							this.close();
						}
					});
					_this._closeDialog();
					msgDialog.showModal();
				}
			};
			xhr.send(form);
		},
		//检查文件
		_checkFileData:function(){
			var img = new Image();
			var fileupload = document.getElementById("uploadFile");
			var fileLocation = fileupload.value;
			if(fileLocation == "" || fileLocation == null || fileLocation == undefined){
				return false;
			}

			var fileType = fileLocation.substring(fileLocation.lastIndexOf("."));
			var fileName,fileSize;
			if (fileupload.files && fileupload.files[0]) {
				fileName = fileupload.files[0].name;
				var size = fileupload.files[0].size;
				fileSize = size/(1024 * 1024);
				var fileSize = fileupload.files[0].size;
			} else {
				fileupload.select();
				fileupload.blur();
				var filepath = document.selection.createRange().text;
				try {
					var fso, f, fsize;
					fso = new ActiveXObject("Scripting.FileSystemObject");
					f = fso.GetFile(filepath); //文件的物理路径
					fileName = fso.GetFileName(filepath); //文件名（包括扩展名）
					fileSize = f.Size; //文件大小（bit）
				} catch (e) {
					var msgDialog = Dialog({
						title: '提示',
						content: e + "\n 跳出此消息框，是由于你的activex控件没有设置好,\n" +
						"你可以在浏览器菜单栏上依次选择\n" +
						"工具->internet选项->\"安全\"选项卡->自定义级别,\n" +
						"打开\"安全设置\"对话框，把\"对没有标记为安全的\n" +
						"ActiveX控件进行初始化和脚本运行\"，改为\"启动\"即可",
						ok: function () {
							this.close();
						}
					});
					msgDialog.showModal();
					return false;
				}
			}
			fileType = fileType.toLowerCase();
			console.log("上传图片信息,图片名称:"+fileName+",图片大小:"+fileSize);
			//文件大小
			var checkSize = true;
			//文件类型
			var checkType = true;
			if(fileSize > ProdEditPager.FILE_MAX_SIZE){
				this._showMsg('图片不能超过3M');
				checkSize = false;
			}else if($.inArray(fileType, ProdEditPager.FILE_TYPES)<0){
				this._showMsg('请上传jpg/png格式图片');
				checkType = false;
			}else {
				img.src = "file:///"+fileLocation;
				img.onload=function() {
					alert(img.width);
					alert(img.height);
					console.log("图片宽:" + img.width + ",高:" + img.height);
				}
			}
			return checkSize&&checkType;
		},
		_closeDialog:function(){
			$("#uploadFile").val("");
			//document.getElementById("uploadFileMsg").setAttribute("style","display:none")
		},
		//预览图片信息
		_showProdPicPreview:function(filePosition,fileType,imgUrl){
			//确定当前要显示商品属性
			var divId = "prod_pic_"+picAttrVal;
			var imgObj;
			//查询该商品下未有图片的位置
			$("#"+divId+" img[imgId='']").each(function(i){
				//设置该图片的信息
				console.log("未设置图片:"+$(this).attr('attrVal')+",序号:"+$(this).attr('picInd'));
				if (imgObj ==null){
					imgObj = $(this);
				}
			});
			console.log("将要设置属性图片:"+imgObj.attr('attrVal')+",序号:"+imgObj.attr('picInd'));
			imgObj.attr('imgId',filePosition);
			imgObj.attr('imgType',fileType);
			imgObj.attr('src',imgUrl);
			//添加删除按钮
			imgObj.next().attr('class','icon-remove-sign');
		},
		//删除图片
		_delProdPic:function(attrValId,picInd){
			//获取当前对象
			var imgObj = $('#prodPicId'+attrValId+'ind'+picInd);
			//下一个图片对象
			var imgNextObj = $('#prodPicId'+attrValId+'ind'+(picInd+1));
			if (imgNextObj!=null && imgNextObj!=undefined){
				var imgId = imgNextObj.attr('imgId');
				var imgType = imgNextObj.attr('imgType');
				if (imgId!=null && imgId!=undefined && imgId!=''
					&&imgType!=null && imgType!=undefined && imgType!='' ){
					//替换当前
					imgObj.attr('src',imgNextObj.attr('src'));
					imgObj.attr('imgId',imgNextObj.attr('imgId'));
					imgObj.attr('imgType',imgNextObj.attr('imgType'));
					this._delProdPic(attrValId,(picInd+1));
					return;
				}
			}
			//若都不符合则设置当前为删除
			imgObj.attr('src',_base+'/resources/slpoperate/images/sp-03-a.png');
			imgObj.attr('imgId','');
			imgObj.attr('imgType','');
			imgObj.next().removeClass();//移除删除按钮
		},
		//商品信息保存检查
		_checkInput:function(){
			//商品名称不能为空
			var prodName = $('#prodName').val();
			if (prodName==null || prodName==''){
				this._showMsg("商品名称不能为空");
				return false;
			}
			//有效期不能为空
			var activeCycle = $('#activeCycle').val();
			if (activeCycle==null || activeCycle==''||isNaN(activeCycle)){
				this._showMsg("商品有效期不能为空,且必须是数字");
				return false;
			}
			//是否快充不能为空
			var partTarget = $("input:radio[name='rechargeType']:checked").val();
			if (partTarget==null || partTarget == ''){
				this._showMsg("请选择是否为快充商品");
				return false;
			}
			//运营商不能为空
			var basicOrgId = $("input:radio[name='basicOrgId']:checked").val();
			if (basicOrgId==null || basicOrgId == ''){
				this._showMsg("请选择运营商");
				return false;
			}
			//检查企业受众类型
			var entAudi = $("input:radio[name='audiencesEnterprise']:checked").val();
			if (entAudi == "1" && this._noHasAudi("audiEntIds")){
				this._showMsg("请选择受众的企业用户");
				return false;
			}
			//检查代理商受众类型
			var agentAudi = $("input:radio[name='audiencesAgents']:checked").val();
			if (agentAudi == "1" && this._noHasAudi("audiAgentIds")){
				this._showMsg("请选择受众的代理商用户");
				return false;
			}

			//是否允许平台代销不能为空
			var isReplaceSell = $("input:radio[name='isReplaceSell']:checked").val();
			if (isReplaceSell==null || isReplaceSell == ''){
				this._showMsg("请选择是否允许平台代销");
				return false;
			}
			//目标地域不能为空
			var isSaleNationwide = $("input:radio[name='isSaleNationwide']:checked").val();
			if (isSaleNationwide==null || isSaleNationwide == ''){
				this._showMsg("请选择商品目标地域");
				return false;
			}
			//图文详情不能为空
			var editVal = editDom.getData();
			if (editVal==null || editVal == ''){
				this._showMsg("商品详情图文描述不能为空");
				return false;
			}
			return true;
		},
		//检查受众为部分时,是否选择用户,若选择用户为false,否则为true
		_noHasAudi:function(audiId){
			//获取受众信息
			var audiJson = $('#'+audiId).val();
			var audiArry = eval(audiJson);
			return audiArry.length > 0?false:true;
		},
		_showMsg:function(msg){
			var msg = Dialog({
				title: '提示',
				content:msg,
				ok:function(){
					this.close();
				}
			});
			msg.showModal();
		}
    });
    
    module.exports = ProdEditPager
});

