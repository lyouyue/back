<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>后台管理系统首页</title>
    <link rel="shopjsp icon" href="${fileUrlConfig.sysFileVisitRoot_back}common/imgs_init/sj.ico"/>
    <link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/header.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
    <style type="text/css">
        .navPoint {
            color: white;
            cursor: hand;
            font-size: 12px;
            font-family: "微软雅黑", "黑体";
        }
    </style>
    <script type="text/javascript">
  		//顶部导航切换
        $(function () {
            $("ul[class='nav'] li").on("click", function () {
                $(this).siblings().find("a").removeClass("selected");
                $(this).find("a").addClass("selected");
                window.parent.frames["rightFrame"].location.href="${pageContext.request.contextPath}/HYYTBackLogin/welcome.action";
            });
        });
        //退出
        function goToExit() {
            window.open("${pageContext.request.contextPath}/backLogin/goToExit.action", "_parent");
        }
    </script>
</head>

<body style="background:url(${fileUrlConfig.sysFileVisitRoot_back}/basic/images/workspace/topbg.gif) repeat-x;">
	<div class="topleft">
	    <img src="${fileUrlConfig.sysFileVisitRoot_back}common/imgs_init/logo.png" width="180px" height="80px" title="SHOPJSP管理系统"/>
	</div>
	<ul class="nav">
	    <s:iterator value="#session.purviewNameList" id="m" status="count">
	        <li>
	            <a href="${pageContext.request.contextPath}/back/backLogin/selectPurview.action?id=<s:property value='#m.purviewId'/>"  target="leftFrame" class="${count.index==0 ? 'selected' : ''}">
	                <img src="${fileUrlConfig.uploadFileVisitRoot}<s:property value='#m.iconUrl'/>" title="<s:property value='#m.purviewName'/>"/>
	                <h2><s:property value="#m.purviewName"/></h2>
	            </a>
	        </li>
	    </s:iterator>
	</ul>
	<div class="topright">
	    <ul>
	        <li>管理员：<s:property value="#request.session.users.userName"/></li>
	        <li><a href="javascript:goToExit();">退出</a></li>
	    </ul>
	</div>
</body>
</html>
