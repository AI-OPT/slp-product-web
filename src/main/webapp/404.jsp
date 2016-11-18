
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<title>404</title>
<%@include file="/inc/inc.jsp" %>

</head>
	<body>
		
		<div class="four404">  
				<img src="${uedroot}/images/404.png" />   
		       <div class="four404-text">  
			     <p>对不起，出错啦！我们暂时无法处理您的访问请求！</p>
			     <!-- <a href="系统欢迎界面.html"><input type="button" class="biu-btn  btn-primary  btn-medium ml-10 " value="返回首页"></a> -->
		    </div>
		</div>
	</body>
</html>
