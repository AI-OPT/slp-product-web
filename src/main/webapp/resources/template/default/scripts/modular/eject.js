//提示弹出框 
jQuery(document).ready(function($) {
	$('#operation').click(function(){
	$('#eject-mask').fadeIn(100);
	$('#prompt').slideDown(200);
	})
	$('#prompt-close').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#prompt').slideUp(150);
	})
	$('.eject-medium-title .img').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#prompt').slideUp(150);
	})
})

//提示操作弹出框 
jQuery(document).ready(function($) {
	$('#choice-btn').click(function(){
	$('#eject-mask').fadeIn(100);
	$('#p-operation').slideDown(200);
	})
	$('#p-op-close').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#p-operation').slideUp(150);
	})
	$('.eject-medium-title .img').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#p-operation').slideUp(150);
	})
})

//提示操作弹出框 
jQuery(document).ready(function($) {
	$('#tree-btn').click(function(){
	$('#eject-mask').fadeIn(100);
	$('#tree').slideDown(200);
	})
	$('#tree-close').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#tree').slideUp(150);
	})
	$('.eject-medium-title .img').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#tree').slideUp(150);
	})
})


//生成虚拟库 编辑名称弹出
jQuery(document).ready(function($) {
	$('#edit').click(function(){
	$('#eject-mask').fadeIn(100);
	$('#edit-medium').slideDown(200);
	})
	$('#edit-close').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#edit-medium').slideUp(150);
	})
	$('.eject-medium-title .img').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#edit-medium').slideUp(150);
	})
})
//生成虚拟库 添加弹出
jQuery(document).ready(function($) {
	$('#add-k').click(function(){
	$('#eject-mask').fadeIn(100);
	$('#add-samll').slideDown(200);
	})
	$('#add-close').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#add-samll').slideUp(150);
	})
	$('.eject-medium-title .img').click(function(){
	$('#eject-mask').fadeOut(100);
	$('#add-samll').slideUp(150);
	})
})