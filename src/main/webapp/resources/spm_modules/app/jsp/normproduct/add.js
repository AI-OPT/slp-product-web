define('app/jsp/normproduct/add', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging-debug'),
	    AjaxController = require('opt-ajax/1.0.0/index');
	    require("jsviews/jsrender.min");
	    require("jsviews/jsviews.min");                                        
	    require("bootstrap-paginator/bootstrap-paginator.min");
	    require("app/util/jsviews-ext");
	    require("opt-paging/aiopt.pagination");
	    require("twbs-pagination/jquery.twbsPagination.min");
   
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
/*定义三级分类数据*/
//一级分类
var province = ["教育", "文艺", "青春", "生活", "人文社科", "经管", "科技", "电子书"];
//二级分类
var city = [
	["教材", "外语", "考试"],
	["文学", "传记", "艺术", "摄影"],
	["青春文学", "动漫", "幽默"],
	["休闲/爱好", "孕产/胎教", "烹饪/美食", "时尚/美妆", "旅游/地图", "家庭/家居", "亲子/家教", "两性关系", "育儿/早教", "保健/养生"],
	["历史", "文化", "古籍", "心理学", "哲学/宗教"],
	["管理", "投资理财", "经济"],
	["科普读物", "建筑", "医学", "计算机/网络", "农业/林业", "自然科学", "工业技术"],
	["新华出品", "文艺", "网络文学", "人文社科", "经管励志", "生活", "童书", "科技", "教育", "期刊杂志"]
];
//三级分类
var district = [
	/*教育*/
	[
		["研究生/本科", "高职高专", "中职中专"],
		["英语综合教程", "英语专项训练", "英语读物"],
		["学历考试", "公职", "财税外贸保险", "建筑工程", "计算机", "医药卫生", "艺术/体育", "考研", "公务员"]
	],
	/*文艺*/
	[
		["文集", "纪实文学", "文学理论"],
		["财经人物", "历代帝王", "领袖首脑", "军事人物", "政治人物", "历史人物", "女性人物", "法律人物", "宗教人物", "哲学家"],
		["艺术理论", "世界各国艺术", "绘画"],
		["摄影理论", "摄影入门"]
	],
	/*青春*/
	[
		["校园", "爱情/情感", "叛逆/成长"],
		["大陆漫画", "港台漫画", "日韩漫画", "欧美漫画", "其他国外漫画", "世界经典漫画", "动漫同人作品", "动漫学堂", "画集"],
		["幽默/笑话集", "轻小说", "游戏同人作品", ""]
	],
	/*生活*/
	[
		["游戏", "宠物杂事", "车载户外"],
		["孕前准备", "胎教", "孕期", "孕产妇健康", "孕期饮食指导", "产后管理"],
		["家常菜谱", "烘焙甜点", "药膳食疗", "西餐料理", "茶酒饮料"],
		["瑜伽", "时尚", "奢侈品", "瘦身美体"],
		["国内自助游", "国外自助游", "城市自助游", "户外探险", "旅游随笔", "旅游攻略"],
		["家庭园艺", "家装效果实例", "家装方法指导", "家装策略秘籍", "家事窍门"],
		["家教理论", "家教方法", "成功案例"],
		["两性关系", "恋爱", "婚姻", "性"],
		["育儿百科", "早教/亲子互动", "婴幼儿饮食营养", "婴幼儿护理健康"],
		["中医养生", "饮食健康", "药膳食疗", "运动养生", "中老年养生", "男性养生", "女性养生", "性保健"]
	],
	/*人文社科*/
	[
		["历史普及读物", "中国史", "世界史", "史家名著"],
		["中国文化", "世界文化", "文化评述", "文化随笔"],
		["经部", "史类", "子部", "集部"],
		["心理百科", "心理学著作", "心理咨询治疗"],
		["古代哲学", "哲学知识读物", "世界哲学", "周易", "伦理学", "哲学与人生", "美学", "哲学史"]
	],
	/*经管*/
	[
		["一般管理学", "会计", "市场营销"],
		["证券/股票", "基金", "期货"],
		["经济学理论", "各流派经济学", "经济数学"]
	],
	/*科技*/
	[
		["宇宙知识", "人类故事", "生物世界", "科学世界", "生态环境", "百科知识"],
		["建筑史与建筑", "建筑学", "建筑外观设计", "室内设计/装潢", "建筑施工与监理"],
		["预防医学/卫生", "临床医学理论", "内科学", "外科学", "妇产科学"],
		["计算机理论", "硬件外部设施", "操作系统", "数据库", "程序设计"],
		["农业基础科学", "农业工程", "农学(农艺学)", "植物保护", "农作物", "园艺", "林业", "畜牧/狩猎/养蚕", "水产/渔业", "动物医学"],
		["总论", "数学", "力学", "物理学", "化学", "天文学", "地球科学", "生物学"],
		["一般工业技术", "机械/仪表工", "电工技术", "电子通信", "化学工业", "冶金工业", "矿业工程", "石油/天然气"]
	],
	/*电子书*/
	[
		["小说", "文学", "艺术"],
		["小说", "文学", "传记"],
		["幻想", "漫画", "社会", "言情"],
		["文化", "历史", "政治/军事"],
		["成功/励志", "管理", "经济"],
		["保健", "亲子家教", "旅游"],
		["中国儿童文学", "外国儿童文学", "科普/百科"],
		["科普读物", "计算机/网络", "医学", "工业技术", "建筑", "自然科学", "农业/林业", "社会科学", "人文科学"],
		["中小学教辅", "考试", "教材"],
		["财经", "外文杂志", "生活"]
	]
];
var expressP, expressC, expressD, expressArea, areaCont;
var arrow = " <font>&gt;</font> ";


//定义页面组件类
var addPager = Widget.extend({
	
	Implements:SendMessageUtil,
	//属性，使用时由类的构造函数传入
	attrs: {
		clickId:""
	},
	Statics: {
		DEFAULT_PAGE_SIZE: 30
	},
	//事件代理
	events: {
		//查询
        //"click #selectNormProductList":"_selectNormProductList",
		
		
        },
	//重写父类
	setup: function () {
		addPager.superclass.setup.call(this);
		//初始化第一级类目
		this._selecFirst();
	},
	
	//初始化第一级类目
	_selecFirst:function(){
		
		var areaCont = "";
		for (var i=0; i<province.length; i++) {
			areaCont += '<li onClick="selectP(' + i + ');"><a href="javascript:void(0)">' + province[i] + '</a></li>';
		}
		
		$("#sort1").html(areaCont);
	
	},
	
	
	
	



});

module.exports = addPager
});














/*define('app/jsp/product/addlist', function (require, exports, module) {
    'use strict';
    var $=require('jquery'),
	    Widget = require('arale-widget/1.2.0/widget'),
	    Dialog = require("optDialog/src/dialog"),
	    Paging = require('paging/0.0.1/paging-debug'),
	    AjaxController = require('opt-ajax/1.0.0/index');
    require("jsviews/jsrender.min");
    require("jsviews/jsviews.min");
    require("bootstrap-paginator/bootstrap-paginator.min");
    require("app/util/jsviews-ext");
    require("opt-paging/aiopt.pagination");
    require("twbs-pagination/jquery.twbsPagination.min");
   
    
    var SendMessageUtil = require("app/util/sendMessage");
    
    //实例化AJAX控制处理对象
    var ajaxController = new AjaxController();
    var clickId = "";
    //定义页面组件类
    var AddlistPager = Widget.extend({
    	
    	Implements:SendMessageUtil,
    	//属性，使用时由类的构造函数传入
    	attrs: {
    		clickId:""
    	},
    	Statics: {
    		DEFAULT_PAGE_SIZE: 30
    	},
    	//事件代理
    	events: {
    		//跳转下一步
    		"click #next":"_next",
            },
    	//重写父类
    	setup: function () {
    		AddlistPager.superclass.setup.call(this);

    	},
    	
    	// 改变商品类目
    	_selectChange:function(osel){
    		var prodCatId = osel.options[osel.selectedIndex].value;
    		var clickId = $(osel).parent().attr('id');
    		//获取当前ID的最后数字
    		var index = Number(clickId.substring(10))+1;
    		//获取下拉菜单的总个数
    		var prodCat = document.getElementById("data1ProdCat");
    		var length = prodCat.getElementsByTagName("select").length;
    		if(index==length){
    			return;
    		}
    		//从当前元素开始移除后面的下拉菜单
    		for(var i=index;i<length;i++){
    			$("#productCat"+i).remove();
    		}
    		ajaxController.ajax({
				type: "post",
				processing: false,
				// message: "加载中，请等待...",
				url: _base+"/cat/query/child",
				data:{"prodCatId":prodCatId},
				success: function(data){
					if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#prodCatTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#"+clickId).after(htmlOutput);
	            	}else{
	            		var d = Dialog({
							content:"获取类目信息出错:"+data.statusInfo,
							icon:'fail',
							okValue: '确 定',
							ok:function(){
								this.close();
							}
						});
						d.show();
	            	}
				}
			});
    	},
    	
    	
    	//跳转下一步
    	_next:function(){
    		var _this = this;
    		var div = document.getElementById("data1ProdCat");
    		var length = document.getElementsByTagName("select").length-3;
    	//	var productCatId = $("#productCat"+length+" option:selected").val();
    		var productCatId = $("#productCat").val();
    		var productType = $("#productType").val().trim();
    		var productId = $("#standedProdId").val().trim();
    		var productName = $("#standedProductName").val().trim();
    		var state = $("#state").val().trim();
    		$("#pagination-ul").runnerPagination({
    			
	 			url: _base+"/normprodedit/addinfo",
	 			
	 			method: "POST",
	 			dataType: "json",
	 			renderId:"searchNormProductData",
	 			messageId:"showMessageDiv",
	 			
	            data: {"productCatId":productCatId,"productType":productType,"productId":productId,"productName":productName},
	 			
	           	pageSize: AddlistPager.DEFAULT_PAGE_SIZE,
	           	visiblePages:5,
	            render: function (data) {
	            	if(data != null && data != 'undefined' && data.length>0){
	            		var template = $.templates("#searchNormProductTemple");
	            	    var htmlOutput = template.render(data);
	            	    $("#searchNormProductData").html(htmlOutput);
	            	}
	            	_this._returnTop();
	            }
    		});
    	},
    	//滚动到顶部
    	_returnTop:function(){
    		var container = $('.wrapper-right');
    		container.scrollTop(0);//滚动到div 顶部
    	},
    	
    });
    
    module.exports = AddlistPager
});

*/