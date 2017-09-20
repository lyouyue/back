<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>本网站功能清单</title>
</head>

<body>
************把历史所有功能列出清单出来，放在本页面中**********<br>
<a href="/">首页</a><br>
<a href="${pageContext.request.contextPath}/back/browseRecord/gotoProBrRecordPage.action" target="_black">会员浏览商品历史记录</a><br>
<a href="${pageContext.request.contextPath}/back/orders/gotoReceivingOrdersPage.action" target="_black">归档订单</a><br>
<a href="${pageContext.request.contextPath}/back/orders/gotoCompelLockedPage.action" target="_black">已锁定订单</a><br>
<a href="${pageContext.request.contextPath}/back/rightShow/gotoRightShowInfoPage.action" target="_black">首页模块展示信息后台初始化页面(数据库不存在)</a><br>
</body>
</html>
