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
<title>flush</title>
<%@include file="/inc/inc.jsp" %>

</head>
	<body>
		<div class="flushdata">  
		       <div >  
			     <a href="${_base }/productcomment/flushproductdata"><input type="button" class="biu-btn  btn-primary  btn-medium ml-10 " value="刷新商品"></a>
			     <a href="/productcomment/flushcommentdata"><input type="button" class="biu-btn  btn-primary  btn-medium ml-10 " value="刷新评论"></a>
		    </div>
		</div>
	</body>
</html>
