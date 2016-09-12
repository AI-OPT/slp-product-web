define('app/jsp/product/edit', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
		Events = require('arale-events/1.2.0/events'),
    Widget = require('arale-widget/1.2.0/widget'),
    Dialog = require("optDialog/src/dialog"),
    AjaxController = require('opt-ajax/1.0.0/index');
	require("ckeditor/ckeditor.js")
	require("my97DatePicker/WdatePicker");
    require("bootstrap-paginator/bootstrap-paginator.min");

	require("jquery-validation/1.15.1/jquery.validate");
	require("app/util/aiopt-validate-ext");
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
			FILE_TYPES:['.jpg','.png'],
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
			this._changeUpShel();
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
		},
		//上架类型变更
		_changeUpShel:function(){
			var shelType = $("input[name='upshelfType']:checked").val();
			console.log("the upshel type is "+shelType);
			if (ProdEditPager.UPSHEL_PRESALE == shelType){
				$('#presaleTimeUl').show();
			} else{
				$('#presaleTimeUl').hide();
			}
		},
		//完成目标地域选择
		_finishTarget:function(){
			$('#eject-mask').fadeOut(100);
			$('#eject-city').slideUp(150);
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
				console.log(JSON.stringify(provArry));
				$('#targetProd').val(JSON.stringify(provArry));
			}else
				$('#targetProd').val('');
		},
    	//保存商品信息
      	_saveProd:function() {
			var _this = this;
			//验证通过,则进行保存操作.
			if($("#prodForm").valid() && this._checkInput() && this._convertProdPic() && this._convertNoKeyAttr()){
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
							new Dialog({
								content:"提交成功",
								icon:'success',
								okValue: '确 定',
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
			var processingDialog = Dialog({
				icon:"loading",
				content: "<div class='word'>图片上传中，请稍候..</div>"
			});
			// XMLHttpRequest 对象
			var xhr = new XMLHttpRequest();
			var uploadURL = _base+"/home/upImg";
			xhr.open("post", uploadURL, true);
			processingDialog.showModal();
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {// 4 = "loaded"
					processingDialog.close();
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
					}
					_this._showFail("文件上失败,状态:"+xhr.status);
					_this._closeDialog();
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
				this._showWarn('图片不能超过3M');
				checkSize = false;
			}else if($.inArray(fileType, ProdEditPager.FILE_TYPES)<0){
				this._showWarn('请上传jpg/png格式图片');
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
			imgObj.next().addClass('fa fa-times');
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
			return true;
		},
		_showMsg:function(msg){
			new Dialog({
				content:msg,
				icon:'success',
				okValue: '确 定',
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
		}
    });
    
    module.exports = ProdEditPager
});

