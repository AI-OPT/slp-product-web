define('app/jsp/product/edit', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
		Events = require('arale-events/1.2.0/events'),
    	Widget = require('arale-widget/1.2.0/widget'),
    	Dialog = require("optDialog/src/dialog"),
    	AjaxController = require('opt-ajax/1.0.0/index');
	require("ckeditor/ckeditor.js");
	require("my97DatePicker/WdatePicker");
    require("bootstrap-paginator/bootstrap-paginator.min");

	require("jquery-validation/1.15.1/jquery.validate");
	require("app/util/aiopt-validate-ext");
	require("webuploader/webuploader.min");
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
	var prodDetail = 'prodDetail';
	var editDom;
	//当前操作受众类型
	var nowAudiType;
	//查询受众用户类型
	var selectUserType;
	var uploader;
	var processingDialog = Dialog({
		title: '提示',
		icon:"loading",
		content: "<div class='word'>图片上传中，请稍候..</div>"
	});
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
			FILE_TYPES:['jpg','jpeg','png'],
			UPSHEL_PRESALE:"4"
    	},
    	//事件代理
    	events: {
			"click input:checkbox[name='targetProv']":"_showTarget",
			"click input:radio[name='isSaleNationwide']":"_showPartTarget",
			"click #changeArea":"_showTargetWindow",
			"click #finishTarget":"_finishTarget",
			"click #searchBut":"_searchBtnClick",
			"change #uploadFile":"_uploadFile",
			//保存数据
			"click #save":"_saveProd",
			//变更上架类型
			"click input:radio[name='upshelfType']":"_changeUpShel"
        },
    	//重写父类
    	setup: function () {
			ProdEditPager.superclass.setup.call(this);
			//自定义toolbar
			//http://www.cnblogs.com/answercard/p/3709463.html
			editDom = CKEDITOR.replace(prodDetail,{
				toolbar: [
					[ 'Cut', 'Copy', 'Paste', 'PasteText','PasteFromWord','-','Image', '-', 'Undo', 'Redo' ],
					['Link','Unlink','Anchor'],
					{ name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
					['Source']
				]
			});
			this._showPartTarget();
			this._showTarget();
			$("#prodForm").validate({
				errorPlacement: function(error, element) {
					if (element.is(":radio"))
						error.appendTo(element.parent().parent());
					else
						error.insertAfter(element);
				},
				messages:{
					isSaleNationwide:"请选择目标地域",
					isInvoice:"请选择是否提供发票",
					upshelfType:"请选择上架类型"
				}
			});
			if ( !WebUploader.Uploader.support() ) {
				this._showWarn( 'Web Uploader 不支持您的浏览器！如果你使用的是IE浏览器，请尝试升级 flash 播放器');
				throw new Error( 'WebUploader does not support the browser you are using.' );
			}else{
				this._initUpLoad();
			}
		},
		//上架类型变更
		_changeUpShel:function(){
			var shelType = $("input[name='upshelfType']:checked").val();
			if (window.console) {
				console.log("the upshel type is " + shelType);
			}
			if (ProdEditPager.UPSHEL_PRESALE == shelType){
				$('#presaleTimeUl').show();
			} else{
				$('#presaleTimeUl').hide();
			}
		},
		//完成目标地域选择
		_finishTarget:function(){
			$('#eject-mask').fadeOut(100);
		//	$('#eject-city').slideUp(150);
			$('#eject-city').slideUp(200);
		},
		//显示目标地域的信息
		_showPartTarget:function(){
			var partTarget = $("input[name='isSaleNationwide']:checked").val();
			if ('N' == partTarget){
				$('#check4').show();
			} else{
				$('#check4').hide();
			}
		},
		//显示目标地域变更窗口
		_showTargetWindow:function(){
			$('#eject-mask').fadeIn(100);
			$('#eject-city').slideDown(200);
		},
		//更改地域
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
				if (window.console) {
					console.log(JSON.stringify(provArry));
				}
				$('#targetProd').val(JSON.stringify(provArry));
			}else
				$('#targetProd').val('');
		},
    	//保存商品信息
      	_saveProd:function() {
			var _this = this;
			//验证通过,则进行保存操作.
			if($("#prodForm").valid() && this._checkInput() && this._convertProdPic() && this._convertNoKeyAttr()  && this._checkAreaNum()){
				//获取editor中内容
				$("#detailConVal").val(editDom.getData());
				if (window.console) {
					console.log($('#detailConVal').val());
				}
				ajaxController.ajax({
					type: "post",
					processing: true,
					message: "保存中，请等待...",
					url: _base+"/prodedit/save",
					data:$('#prodForm').serializeArray(),
					success: function(data){
						if("1"===data.statusCode){
							new Dialog({
								content:"提交成功",
								icon:'success',
								okValue: '确 定',
								title: '提示',
								ok:function(){
									window.history.go(-1);
								}
							}).show();
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
				if (window.console) {
					console.log("已设置图片:" + $(this).attr('attrVal') + ",序号:" + $(this).attr('picInd'));
					console.log("====图片信息:" + $(this).attr('imgId') + ",");
				}
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
				this._showWarn("商品主图不能为空,至少有一张图片.");
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
			$("#noKeyAttrDiv .word3").each(function(i){
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
			var noKeyJsonStr = JSON.stringify(noKeyVal);
			if (window.console) {
				console.log(noKeyJsonStr);
			}
			$('#noKeyAttrStr').val(noKeyJsonStr);
			return true;
		},
		//初始化图片上传
		_initUpLoad:function(){
			var _this = this;
			this._consoleShow("init upLoader");

			uploader = WebUploader.create({
				auto:true,
				swf: _base+"/resources/spm_modules/webuploader/Uploader.swf",
				server:_base+"/home/upImg",
				//pick:'#filePicker',
				pick:{
					id:"#filePicker",
					multiple:false
				},
				resize:false,
				fileVal:"uploadFile",
				formData:{"imgSize":"78x78"},
				accept:{
					title:"Images",
					extensions:"jpg,jpeg,png",
					mimeTypes:"image/jpg,image/jpeg,image/png"
				}
			});
			//文件加入队列前进行验证
			uploader.on("beforeFileQueued",function(file){
				//文件大小
				var checkSize = true;
				//文件类型
				var checkType = true;
				if(file.size > ProdEditPager.FILE_MAX_SIZE){
					_this._showWarn('图片不能超过3M');
					checkSize = false;
				}else if($.inArray(file.ext, ProdEditPager.FILE_TYPES)<0){
					_this._showWarn('请上传jpg/png格式图片');
					checkType = false;
				}
				return checkSize&&checkType;

			});
			//开始上传
			uploader.on("startUpload",function(){
				//显示上传
				processingDialog.show();
			});
			//上传失败
			uploader.on("uploadError",function(file,reason){
				_this._showFail(reason);
				_this._closeDialog();
			});
			//上传成功
			uploader.on("uploadSuccess",function(file,responseData){
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
						//_this._showMsg("上传成功:"+filePosition+","+fileName);
						_this._closeDialog();
						_this._showProdPicPreview(filePosition,fileName,fileUrl);
						return;
					}
				}//上传失败
				else if(responseData.statusCode=="0"){
					_this._showFail(responseData.statusInfo);
					_this._closeDialog();
					return;
				}
			});
			//上传完成,包括成功和失败
			uploader.on("uploadFinished",function(){
				processingDialog.close();
				uploader.reset();
			});
		},
		//启动上传
		_execUpLoader:function(){
			uploader.getRuntime().exec();
		},
		//检查文件
		_checkFileData:function(){
			var fileupload = document.getElementById("uploadFile");
			var fileLocation = fileupload.value;
			if(fileLocation == "" || fileLocation == null || fileLocation == undefined){
				return false;
			}

			var fileType = fileLocation.substring(fileLocation.lastIndexOf(".")+1).toLowerCase();
			var fileName,fileSize;
			if (window.console) {
				console.log("上传图片信息,图片名称:" + fileName + ",图片大小:" + fileSize);
			}
			//文件大小
			var checkSize = true;
			//文件类型
			var checkType = true;
			if($.inArray(fileType, ProdEditPager.FILE_TYPES)<0){
				this._showWarn('请上传jpg/png格式图片');
				checkType = false;
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
				if (window.console) {
					console.log("未设置图片:" + $(this).attr('attrVal') + ",序号:" + $(this).attr('picInd'));
				}
				if (imgObj ==null){
					imgObj = $(this);
				}
			});
			if (window.console) {
				console.log("将要设置属性图片:" + imgObj.attr('attrVal') + ",序号:" + imgObj.attr('picInd'));
			}
			imgObj.attr('imgId',filePosition);
			imgObj.attr('imgType',fileType);
			imgObj.attr('src',imgUrl);
			//添加删除按钮
			imgObj.next().addClass('fa fa-times');
		},
		//检查是否能上传图片
		_checkProdPicUp:function(picAttrVal){
			//确定当前要显示商品属性
			var msgValType = picAttrVal === "0"?"商品主图":"此属性值";
			var nullNum = $("#prod_pic_"+picAttrVal+" img[imgId='']").length;
			var isUp = true;
			if (nullNum < 1){
				this._showWarn(msgValType+"的图片张数已达到上传上限");
				isUp=false;
			}
			return isUp;
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
			imgObj.attr('src',_base+'/resources/local/images/sp-03-a.png');
			imgObj.attr('imgId','');
			imgObj.attr('imgType','');
			imgObj.next().removeClass();//移除删除按钮
		},
		//商品信息保存检查
		_checkInput:function(){
			//商品预售
			var upType = $("input[name='upshelfType']:checked").val();
			var beginTime = $("#presaleBegin").val();
			var endTime = $("#presaleEnd").val();
			
			var sellPoint = $("textarea[name='productSellPoint']").val();
			
			if (ProdEditPager.UPSHEL_PRESALE == upType
				&& (beginTime=="" || typeof beginTime == 'undefined'
				|| endTime == "" || typeof endTime == 'undefined')){
				this._showWarn("预售时间不能为空");
				return false;
			}
			//图文详情不能为空
			var editVal = editDom.getData();
			if (editVal==null || editVal == ''){
				this._showWarn("商品详情图文描述不能为空");
				return false;
			}
			//return true;
			
			//商品卖点
			var re= /select|insert|update|delete|exec|alert|count|'|"|=|!|>|<|%/i;
			if(re.test(sellPoint)){
				/*$("#contractCodeErrMsg").show();
				$("#contractCodeText").show();*/
				//$("#contractCodeText").text('请勿输入非法字符');
	    		//$("#contractCodeFlag").val("0");

				this._showWarn("商品卖点请勿输入非法字符");
				return false;
			}
			
			return true;
		},
		//地域信息保存检查
		_checkAreaNum:function(){
			//商品预售
			var areaNum = $("#areaNum").val();
			
			if (areaNum == '0'){
				this._showWarn("商品的目标地域不能为空");
				return false;
			}
			return true;
		},
		_showMsg:function(msg){
			new Dialog({
				content:msg,
				icon:'success',
				okValue: '确 定',
				title: '提示',
				ok:function(){
					this.close();
				}
			}).show();
		},
		_showWarn:function(msg){
			new Dialog({
				content:msg,
				icon:'warning',
				okValue: '确 定',
				title: '提示',
				ok:function(){
					this.close();
				}
			}).show();
		},
		_showFail:function(msg){
			new Dialog({
				title: '提示',
				content:msg,
				icon:'fail',
				okValue: '确 定',
				ok:function(){
					this.close();
				}
			}).show();
		},
		_consoleShow:function(msg){
			if (window.console) {
				console.log(msg);
			}
		}
    });
    
    module.exports = ProdEditPager
});

