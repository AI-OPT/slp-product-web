define('app/jsp/comment/commentlist', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("my97DatePicker/WdatePicker");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    require("opt-paging/aiopt.pagination");

    require("app/jsp/comment/loopedSlider.js");
   
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    //定义页面组件类
    var commentListPage = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 10
    	},
    	//事件代理
    	events: {
    		//查询在售商品
            "click #selectCommentList":"_selectCommentList",
            "click #discardMoreBtn":"_discardMoreComment",
            "click #imageCloseBtn":"_closeImageDialog",
            "click #previousBtn":"_previousImage",
            "click #nextBtn":"_nextImage"
            },
    	//重写父类
    	setup: function () {
    		commentListPage.superclass.setup.call(this);
    		this._clearQueryParams();
    		this._selectCommentList();
    	},
    	//清空查询条件
    	_clearQueryParams:function(){
    		$("#shopScoreMs option:selected").val("");
    		$("#commentTimeBegin").val("");
    		$("#commentTimeEnd").val("");
    		$("#shopScoreWl option:selected").val("");
    		$("#shopScoreFw option:selected").val("");
    		$("#standedProdId").val("");
    		$("#orderId").val("");
    	},
    	//全选
		_clickAll: function (obj) {
			var check = true;
			if (!obj.is(':checked')) {
				check = false;
			}
			$("input:checkbox[name='box']").prop("checked", check);
		},
		//如果列表子项都选中  全选按钮则选中
		_clicksingle: function (obj) {
			var commentId = obj.attr("commentId");
			var attrVal = obj.val();
			// 若子项没有都选中,则全选也取消 --%>
			if (!obj.is(':checked')) {
				$("input:checkbox[name='checkall']").prop("checked", false);
				return;
			}

			//获取列表中数据数量
			var valNum = $("input:checkbox[name='box']").size();
			//获取选中的数据数量
			var checkNum = $("input:checkbox:checked[name='box']").size();
			if (valNum == checkNum) {
				$("input:checkbox[name='checkall']").prop("checked", true);
			} else {
				$("input:checkbox[name='checkall']").prop("checked", false);
			}
		},
    	//查询评论列表
    	_selectCommentList:function(){
    		var _this = this;
    		var shopScoreMsStr = $("#shopScoreMs").val();
    		var shopScoreMs = shopScoreMsStr?parseInt(shopScoreMsStr):null;
    		var commentTimeBegin = $("#commentTimeBegin").val();
    		var commentTimeEnd = $("#commentTimeEnd").val();
    		var shopScoreWlStr = $("#shopScoreWl").val();
    		var shopScoreWl = shopScoreWlStr?parseInt(shopScoreWlStr):null;
    		var shopScoreFwStr = $("#shopScoreFw").val();
    		var shopScoreFw = shopScoreFwStr?parseInt(shopScoreFwStr):null;
    		var standedProdId = $("#standedProdId").val()?$("#standedProdId").val().trim():"";
    		var orderId = $("#orderId").val()?$("#orderId").val().trim():"";
    		
    		$("#pagination-ul").runnerPagination({
    			
	 			url: _base+"/productcomment/getCommentList",
	 			
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchCommentData",
	 			messageId:"showMessageDiv",
	 			
	 			data: {
	 				"shopScoreMs":shopScoreMs,
	 				"commentTimeBeginStr":commentTimeBegin,
	 				"commentTimeEndStr":commentTimeEnd,
	 				"shopScoreWl":shopScoreWl,
	 				"shopScoreFw":shopScoreFw,
	 				"standedProdId":standedProdId,
	 				"orderId":orderId
		 		},
	 			
	           	pageSize: commentListPage.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchCommentTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchCommentData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//批量审核通过弹框
		_discardMoreComment: function () {
			var _this = this;
			var checkNum = $("input:checkbox:checked[name='box']").size();
			if (checkNum == 0) {
				var d = Dialog({
					title:"提示",
					content: "请选择要屏蔽的数据!",
					icon: 'warning',
					okValue: '确 定',
					ok: function () {
						this.close();
					}
				});
				d.show();
			} else {
				Dialog({
					title:"提示",
					content: "确定屏蔽这些评论吗？",
					icon: 'help',
					cancelValue:'取 消',
					okValue: '确 定',
					ok: function () {
						var commentIds = '';
						//获取列表中的选中项
						$("[name='box']:checked").each(function (index, element) {
							commentIds += $(this).val() + ",";
						});
						_this._discardComment(commentIds);
						this.close();
					},
					cancel:function(){
						this.close();
					}
				}).show();
			}
		},
    	//废弃评论
    	_discardComment:function(commentIds){
    		var _this = this;
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "处理中，请等待...",
				url: _base+"/productcomment/discardComment",
				data:{"commentIds":commentIds},
				success: function(data){
					_this._selectCommentList();
				}
			});
    	},
    	/**
    	 * 显示图片
    	 */
    	_showImages:function(commentId){
    		var innerHtml = "<div class='roll-scroll'>"
			 +"<div id='loopedSlider'>"
			 +"   <div class='slidepic' id='imageData'>"
			 +"   </div>"
			 +"   <ul class='nav-buttons'>"
			 +"      <li class='p'><a href='javascript:void(0);' onclick='pager._previousImage()' class='previous'><i class=' icon-chevron-left'></i></a></li>"
			 +"      <li class='n'><a href='javascript:void(0);' onclick='pager._nextImage()' class='next'><i class='icon-chevron-right'></i></a></li>"
			 +"   </ul>"
			 +"</div>"
			 +"</div>"
			 +"<div class='prompt-samll-confirm'>"
			 +"	<ul>"
			 +"		<li id='imageCount' class='word'></li>"
			 +"	</ul>"
			 +"</div>";
    		var d = Dialog({
    			title:"查看图片",
    			width:"600px",
    			closeIconShow:true,
    			innerHtml:innerHtml
    		});
    		d.show();
    			
    		imageCount = 0;
    		ajaxController.ajax({
				type: "post",
				processing: true,
				message: "处理中，请等待...",
				url: _base+"/productcomment/selectCommentImages",
				data:{"commentId":commentId},
				success: function(data){
					if(data != null && data.data != null && data.data.length>0){
	            		var template = $.templates("#imageTemple");
	            	    var htmlOutput = template.render(data.data);
	            	    $("#imageData").html(htmlOutput);
	            	    $('#loopedSlider').loopedSlider({
	    					container : 'slidepic',
	    					slideClass: 'photo',
	    					autoHeight: false,
	    					fadeSpeed: 250,
	    					slideSpeed: 150,
	    					containerClick: true,
	    				});
	            	    imageCount = data.data.length;
	            	    $("#imageCount").html("1/"+imageCount);
	            	}
				}
			});
    	},
    	/**
    	 * 关闭图片弹出框
    	 */
    	_closeImageDialog:function(){
    		$('#eject-mask').fadeOut(100);
    		$('#look').slideUp(150);
    	},
    	/**
    	 * 上张图片
    	 */
    	_previousImage:function(){
    		var parentId = $("#imageData").find(".current")[0].id;
			var parentSplit = parentId.split('-');
			var x = ((parentSplit[1]*1)-1);
			if(x == 0){
				x=imageCount;
			}
			$("#imageCount").html(x+"/"+imageCount);
    	},
    	/**
    	 * 下张图片
    	 */
    	_nextImage:function(){
    		var parentId = $("#imageData").find(".current")[0].id;
			var parentSplit = parentId.split('-');
			var x = ((parentSplit[1]*1)+1);
			if(x > imageCount){
				x=1;
			}
			$("#imageCount").html(x+"/"+imageCount);
    	},
    	/**
    	 * 屏蔽评论
    	 */
    	_discardCommentById:function(commentId){
    		var _this = this;
    		Dialog({
				title:"提示",
				content: "确定屏蔽该评论吗？",
				icon: 'help',
				cancelValue:'取 消',
				okValue: '确 定',
				ok: function () {
					_this._discardComment(commentId);
					this.close();
				},
				cancel:function(){
					this.close();
				}
			}).show();
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	}
    	
    });
    
    module.exports = commentListPage;
});

