<%
response.setStatus(403);



//输出异常信息页面

%>

<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<title>403 - 操作权限不足</title>
	
</head>
<%@include file="/inc/inc.jsp" %>
<style>
h1, h2, h3, h4, h5, h6 {
    margin: 0;
    padding-left: 0px;
    color: #317eac !important;
    font-family: 'Telex',sans-serif !important;
    font-weight: bold !important;
}
h1 {
    font-size: 30px !important;
}
h1, h2, h3 {
    line-height: 40px !important;
}
.btn:hover {
    background-position: 0 0;
}
.btn:hover, .btn:focus {
    color: #333;
    text-decoration: none;
    transition: background-position .1s linear;
}
.btn:first-child {
}
.btn:hover, .btn:focus, .btn:active, .btn.active, .btn.disabled, .btn[disabled] {
    color: #333;
    background-color: #e6e6e6;
}
.btn {
	color: #555 !important;
    display: inline-block;
    padding: 4px 12px;
    margin-bottom: 0;
    font-size: 14px;
    line-height: 20px;
    text-align: center;
    text-shadow: 0 1px 1px rgba(255,255,255,0.75);
    vertical-align: middle;
    cursor: pointer;
    border: 1px solid #ccc;
    border-color: rgba(0,0,0,0.1) rgba(0,0,0,0.1) rgba(0,0,0,0.25);
    border-bottom-color: #b3b3b3;
    border-radius: 4px;
}
.page-header {
    padding-bottom: 9px;
    margin: 20px 0 30px;
    border-bottom: 1px solid #f5f5f5;
}
</style>
<body>
	<div class="container-fluid">
		<div class="page-header"><h1>操作权限不足.</h1></div>
<%-- 		<%
			if (ex!=null && StringUtils.startsWith(ex.getMessage(), "msg:")){
				out.print("<div>"+StringUtils.replace(ex.getMessage(), "msg:", "")+" <br/> <br/></div>");
			}
		%> --%>
		<div><a href="javascript:" onclick="history.go(-1);" class="btn">返回上一页</a></div>
		
	</div>
</body>
</html>
