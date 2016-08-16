

function getcookie(name){  
	
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));  
    if(arr != null){  
        return (arr[2]);  
    }else{  
        return "";  
    }  
}
$(document).ready(function(){

	  $("body").attr("id",getcookie('theme_index'));
	});
