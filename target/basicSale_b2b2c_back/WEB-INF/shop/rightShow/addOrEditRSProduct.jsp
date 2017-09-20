<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>选择商品</title>
	
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script></head>

<frameset cols="25%,*" frameborder="0" framespacing="0" style="border: 1px;overflow: scroll"  >
		<frame src="${pageContext.request.contextPath}/shop/back/back/rightShow/proTypePage.jsp">
		<frame src="${pageContext.request.contextPath}/shop/back/back/rightShow/productList.jsp" name="proInfo">
</frameset>	
</html>
