define('app/demo/commlabel',function(require,exports,module){
	'use strict';
	var $ = require('jquery'),
	Widget = require('arale-widget/1.2.0/widget'),
    Calendar = require('arale-calendar/1.1.2/index'),
    Tip = require('arale-tip/1.4.1/tip'),
	Dialog = require('arale-dialog/1.5.3/dialog'),
	Select = require('arale-select/0.11.1/index'),
	AutoComplete = require('arale-autocomplete/1.4.1/autocomplete'),
	Tabs = require('arale-switchable/1.1.1/switchable').Tabs,
	Paging = require('paging/0.0.1/paging'),
	Qrcode = require('arale-qrcode/3.0.5/index'),
	Validator = require('arale-validator/0.10.2/index-debug'),
	Slide = require('arale-switchable/1.1.1/switchable').Slide;
	
	  //定义页面组件类
    var DemoPager = Widget.extend({
    	//属性，使用时由类的构造函数传入
    	attrs: {
    	},
    	//事件代理
    	events: {
    		//key的格式: 事件+空格+对象选择器;value:事件方法
        },
    	//重写父类
    	setup: function () {
    		DemoPager.superclass.setup.call(this);
    		this._bindCalendar();
    		this._bindDialog();
    		this._bindTip();
    		this._bindSelect();
    		this._bindAutocomplete();
    		this._bindTabs();
    		this._bindPaging();
    		this._bindSlide();
    		this._bindQrcode();
    		this._sumbitValidate();
    	},
    	
    	//当name属性的值发生变化时候触发
    	_onRenderName: function(val) {
    	 },
    	
    	 
    	
    	_bindCalendar: function(){
    		//日期
    		new Calendar({trigger: '#date-nothing'});
    	},
    	_bindDialog:function(){
    		//对话框
    		new Dialog({
    		    trigger: '#baseDialog',
    		    height: '100px',
    		    effect: 'fade',
//    		    hasMask: false,  没有遮罩
    		    content: '传入了字符串'
    		});
    		
    		var ConfirmBox = Dialog.ConfirmBox;
    		var cb = new ConfirmBox({
    		    trigger: '#standDialog',
    		    title: '我真是标题啊',
    		    message: '我是内容 我是内容',
    		    confirmTpl: '<button>确定</button>',
    		    cancelTpl: '<button>取消</button>'
    		});
    	},
    	_bindTip:function(){
    		//提示
    		new Tip({
    			trigger:"#tip1",
    			content: '<div style="padding:10px">我是内容 我是内容</div>',
    		    arrowPosition: 10
    		})
    	},
    	_bindSelect:function(){
    		//下拉
    		new Select({
    		    trigger: '#example2',
    		    model: [
    		        {value:'option1', text:'option1'},
    		        {value:'option2', text:'option2', selected: true},
    		        {value:'option3', text:'option3', disabled: true}
    		    ]
    		}).render();
    		
    		var a1 = new Select({
    		    trigger: '#exampel6-1',
    		    triggerTpl: '<a href="#"><span data-role="trigger-content"></span><i class="iconfont" title="下三角形">&#xF03C;</i></a>',
    		    width: 100
    		}).on('change', function(target) {
    		    var type = target.attr('data-value');
    		    var model = parseProv(type);
    		    console.log(model);
    		    a2.syncModel(model);
    		});

    		var a2 = new Select({
    		    trigger: '#exampel6-2',
    		    model: parseProv('WATER'),
    		    width: 100,
    		    maxHeight: 300
    		}).on('change', function(target) {
    		    var prov = target.attr('data-value');
    		    var model = parseCity(a1.get('value'), prov);
    		    a3.syncModel(model);
    		});

    		var a3 = new Select({
    		    trigger: '#exampel6-3',
    		    model: parseCity('WATER'),
    		    width: 100,
    		    maxHeight: 300
    		});

    		a1.render();
    		a2.render();
    		a3.render();
    		
    	},
    	_bindAutocomplete:function(){
    		//自动填充
    		new AutoComplete({
    			trigger:"#acTrigger1",
        		dataSource:['abc','abd','abe','acd'],
        		width:150
    		}).render();
    		
    	},
    	_bindTabs:function(){
    		//引入样式
    		seajs.use(["app/demo/tab-demo.css"]);
    		//Tab
    		new Tabs({
    			elements:"#tab-demo-1",
    			triggers:'.ui-switchable-nav li',
    			panels:'.ui-switchable-content div',
    			activeIndex:2,
    			effect:'fade'
    		});
    	},
    	_bindSlide:function(){
    		//引入样式
    		seajs.use(["app/demo/slide-demo.css"]);
    		new Slide({
    		    element: '#slide-demo-1',
    		    effect: 'scrolly',
    		    interval: 3000
    		});
    	},
    	_bindPaging:function(){
    		//引入样式
    		seajs.use(["app/demo/slide-demo.css"]);
    		var html=Paging.render(
    				{
    			        currentPage: 1,
    			        // 总页数
    			        pageCount: 10,
    			        // 链接前缀
    			        link: ''
    			    }		
    		);
    		document.getElementById('paging-demo').innerHTML = html;
    	},
    	_bindQrcode:function(){
    		 var qrnode = new Qrcode({
    			    text: 'http://www.alipay.com/'
    			});
    		 
    		 document.getElementById('qrcodeDefault').appendChild(qrnode);
    	},
    	_sumbitValidate: function(){
    		$(function() {
    	        var validator = new Validator({
    	            element: 'form'
    	        });

    	        validator.addItem({
    	            element: '[name=username]',
    	            required: true,
    	            rule: 'email minlength{min:1} maxlength{max:20}'
    	        })

    	        .addItem({
    	            element: '[name=password]',
    	            required: true,
    	            rule: 'minlength{min:5}'
    	        })

    	        .addItem({
    	            element: '[name=password-confirmation]',
    	            required: true,
    	            rule: 'confirmation{target: "#password"}'
    	        });
    	    });
    	}
    });
    
    module.exports = DemoPager;
})