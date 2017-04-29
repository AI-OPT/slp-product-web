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

function comment() {
	var productIdStartNum = $("#productIdStartNum").val();
	var productIdEndNum = $("#productIdEndNum").val();
	var number = $("#contentnumber").val();
	var commentContent = $("#commentContent").val();
	var commentIdStartNum = $("#commentIdStartNum").val();
	window.location.href = _base + "/productcomment/createComment?productIdStartNum=" + productIdStartNum +"&productIdEndNum=" + productIdEndNum+"&number="+number+"&commentContent="+commentContent+"&commentIdStartNum="+commentIdStartNum;
}

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
	
	function createProduct() {
		var productCatIdStartNum = $("#productCatIdStartNum").val();
		var productCatIdEndNum = $("#productCatIdEndNum").val();
		var number = $("#number").val();
		var productName = $("#productName").val();
		var productIdStart = $("#productIdStart").val();
		window.location.href = _base
				+ "/productcomment/createProduct?productCatIdStartNum=" + productCatIdStartNum
				+ "&productCatIdEndNum=" + productCatIdEndNum+"&number="+number+"&productName="+productName+"&productIdStart="+productIdStart;
	}
</script>
</head>
<body>
	<div class="flushdata" style="margin: 10px 20px 30px 40px">
		<div>
			<ul style="margin: 10px 20px 30px 40px">
				<li style="margin: 10px 20px 30px 40px">商品名称:<input
					id="prodName" style="border: 1px solid #CCCCCC;" name="prodName"
					type="text"></li>
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

		<div>
			<ul style="margin: 10px 20px 30px 40px">
				<li style="margin: 10px 20px 30px 40px">商品类目ID<input id="productCatIdStartNum"
					name="productCatIdStartNum" style="border: 1px solid #CCCCCC;" type="text">--<input
					id="productCatIdEndNum" name="productCatIdEndNum"
					style="border: 1px solid #CCCCCC;" type="text"></li>
					<li style="margin: 10px 20px 30px 40px">商品数量<input id="number"
					name="number" style="border: 1px solid #CCCCCC;" type="text"/></li>
					<li style="margin: 10px 20px 30px 40px">商品名称<input id="productName"
					name="productName" style="border: 1px solid #CCCCCC;" type="text"/></li>
					<li style="margin: 10px 20px 30px 40px">商品ID起始值<input id="productIdStart"
					name="productIdStart" style="border: 1px solid #CCCCCC;" type="text"/></li>
				<li style="margin: 10px 20px 30px 40px"><a href="#"><input
						type="button" class="biu-btn  btn-primary  btn-medium ml-10 "
						value="批量制造商品" onclick="createProduct()"></a></li>
			</ul>
		</div>
		
		<div>
			<ul style="margin: 10px 20px 30px 40px">
				<li style="margin: 10px 20px 30px 40px">商品ID<input id="productIdStartNum"
					name="productIdStartNum" style="border: 1px solid #CCCCCC;" type="text">--<input
					id="productIdEndNum" name="productIdEndNum"
					style="border: 1px solid #CCCCCC;" type="text"></li>
					<li style="margin: 10px 20px 30px 40px">评论数量<input id="contentnumber"
					name="contentnumber" style="border: 1px solid #CCCCCC;" type="text"/></li>
					<li style="margin: 10px 20px 30px 40px">评论内容<input id="commentContent"
					name="commentContent" style="border: 1px solid #CCCCCC;" type="text"/></li>
					<li style="margin: 10px 20px 30px 40px">评论ID起始值<input id="commentIdStartNum"
					name="commentIdStartNum" style="border: 1px solid #CCCCCC;" type="text"/></li>
				<li style="margin: 10px 20px 30px 40px"><a href="#"><input
						type="button" class="biu-btn  btn-primary  btn-medium ml-10 "
						value="批量制造商品评论" onclick="comment()"></a></li>
			</ul>
		</div>
	</div>
</body>
</html>
