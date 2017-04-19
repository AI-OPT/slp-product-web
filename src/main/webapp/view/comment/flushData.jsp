<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title>flush</title>
<%@include file="/inc/inc.jsp"%>

<script type="text/javascript">
	function flushproduct() {
		var no = $("#productNo").val();
		var size = $("#productSize").val();
		if (no == "" || no == null) {
			no = 1;
		}
		if (size == "" || size == null) {
			size = 100;
		}
		var prodName = $("#prodName").val();
		if (prodName == "" || prodName == null) {
			window.location.href = _base
			+ "/productcomment/flushproductdata?pageNo=" + no
			+ "&pageSize=" + size;
		} else {
			window.location.href = _base
			+ "/productcomment/flushproductdata?pageNo=" + no
			+ "&pageSize=" + size + "&prodName=" + encodeURI(prodName);
		}
	}

	function flushcomment() {
		var no = $("#commentNo").val();
		var size = $("#commentSize").val();
		if (no == "" || no == null) {
			no = 1;
		}
		if (size == "" || size == null) {
			size = 100;
		}
		window.location.href = _base
				+ "/productcomment/flushcommentdata?pageNo=" + no
				+ "&pageSize=" + size;
	}
</script>
</head>
<body>
	<div class="flushdata" style="margin: 10px 20px 30px 40px">
		<div>
			<ul style="margin: 10px 20px 30px 40px">
				<li style="margin: 10px 20px 30px 40px">商品名称:<input id="prodName" style="border: 1px solid #CCCCCC;"
					name="prodName" type="text"></li>
				<li style="margin: 10px 20px 30px 40px"><input id="productNo"
					style="border: 1px solid #CCCCCC;" name="productNo" type="text">--<input
					id="productSize" style="border: 1px solid #CCCCCC;"
					name="productSize" type="text"></li>
				<li style="margin: 10px 20px 30px 40px"><a href="#"><input
						type="button" class="biu-btn  btn-primary  btn-medium ml-10 "
						value="刷新商品" onclick="flushproduct()"></a></li>
			</ul>
		</div>
		<div>
			<ul style="margin: 10px 20px 30px 40px">
				<li style="margin: 10px 20px 30px 40px"><input id="commentNo"
					name="commentNo" style="border: 1px solid #CCCCCC;" type="text">--<input
					id="commentSize" name="commentSize"
					style="border: 1px solid #CCCCCC;" type="text"></li>
				<li style="margin: 10px 20px 30px 40px"><a href="#"><input
						type="button" class="biu-btn  btn-primary  btn-medium ml-10 "
						value="刷新商品评论" onclick="flushcomment()"></a></li>
			</ul>
		</div>
	</div>
</body>
</html>