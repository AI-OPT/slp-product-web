//类目属性 table 点击展开
$(function () {
    $(".relation-special table tr .click a").click(function () {
		$(this).children('i').toggleClass("fa-minus fa-plus");
		$(this).parent().parent().parent().parent().parent().parent().parent().children('.zhank').slideToggle(100);
    });
});	

/**去掉最后的线条**/
$(function () {
$(".order-list-table  li:last").css("border-right","none");
});



//搜索区高级搜索 点击展开
$(document).ready(function(){
  $(".form-label ul li .sos a").click(function () {
	  $(".open ").slideToggle(100);
	  $(".nav-form ").toggleClass("reorder remove");
	  });
});
//点击结束

//商品管理table切换
$(function(){
$(".order-list-table ul li a").click(function () {
                $(".order-list-table ul li a").each(function () {
                    $(this).removeClass("current");
                });
                $(this).addClass("current");
            });
$('.order-list-table ul li a').click(function(){
  var index=$('.order-list-table ul li a').index(this);
      if(index==0){
     $('#date1').show();
  	$('#date2').hide();
  	$('#date3').hide();
  	$('#date4').hide();
  	$('#date5').hide();
  	$('#date6').hide();
  	
   }
   if(index==1){
     $('#date2').show();
  	 $('#date1').hide();
  	 $('#date3').hide();
  	 $('#date4').hide();
  	 $('#date5').hide();
  	 $('#date6').hide();
   }
   if(index==2){
     $('#date3').show();
  	 $('#date2').hide();
  	 $('#date1').hide();
  	 $('#date4').hide();
  	 $('#date5').hide();
  	 $('#date6').hide();   	
   }
   if(index==3){
     $('#date4').show();
  	 $('#date1').hide();
  	 $('#date2').hide();
  	 $('#date3').hide();
  	 $('#date5').hide();
  	 $('#date6').hide();   	
   }
    if(index==4){
     $('#date5').show();
  	 $('#date1').hide();
  	 $('#date2').hide();
  	 $('#date3').hide();
  	 $('#date4').hide();
  	 $('#date6').hide();   	
   }
    if(index==5){
     $('#date6').show();
  	 $('#date1').hide();
  	 $('#date2').hide();
  	 $('#date3').hide();
  	 $('#date4').hide();
  	 $('#date5').hide();   	
   }
  }); 
});
//table切换结束


