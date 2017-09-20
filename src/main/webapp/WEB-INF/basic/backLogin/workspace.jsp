<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>祺云管理系统</title>
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/jqueryeasyui/themes/metro/easyui.css">
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/jqueryeasyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/left.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/easyui-lang-zh_CN.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/workspace.js"></script>
		<style type="text/css">
			body { margin:0; padding:0;border:0}
			<%--标签标题左右间距--%>
			.tabs > li > a[class='tabs-inner']{
				padding: 0px 16px;
			}
			<%--刷新小图标--%>
			.tabs-p-tool{
				left: 4px;
			}
			<%--标签选中背景色--%>
			.tabs li.tabs-selected a.tabs-inner{
				background-color: #f2f2f2;
				border-bottom: #f2f2f2 1px solid;
				color: #00a4ac;
			}
		</style>
		<script type="text/javascript"> /*允许开启窗口的数量*/ var allowOpenWindowsNum = ${fileUrlConfig.allowOpenWindowsNum};  </script>
	</head>
	<%--<frameset rows="88,*,10" cols="*" frameborder="no" border="0" framespacing="0" >
	  <frame src="${pageContext.request.contextPath}/back/backLogin/header.action"  name="headerFrame"  scrolling="no"  noresize="noresize"  id="headerFrame"  title="headerFrame" />
	  <frameset  cols="187,*"  frameborder="no"  border="0"  framespacing="0">
	    <frame  src="${pageContext.request.contextPath}/back/backLogin/selectPurview.action?id=${purviewId}"  name="leftFrame"  scrolling="no"  noresize="noresize"  id="leftFrame"  title="leftFrame" />
	    <frame  src="${pageContext.request.contextPath}/HYYTBackLogin/welcome.action"  name="rightFrame" scrolling="no"  noresize="noresize"   id="rightFrame"  title="rightFrame" />
	  </frameset>
	  <frame  src="${pageContext.request.contextPath}/back/backLogin/footer.action"  name="footerFrame"  scrolling="no"  noresize="noresize"  id="footerFrame"  title="footerFrame" />
	</frameset>--%>
	<body id="cc" class="easyui-layout">
	<%--头部内容 开始--%>
	<div region="north" split="false" style="min-width: 1366px; width:1920px; height: 88px; overflow: hidden;" border="false">
		<iframe src="${pageContext.request.contextPath}/back/backLogin/header.action" id="headerFrame" name="headerFrame"
				width="100%" height="88px" scrolling="no" frameborder="0" marginheight="0" marginwidth="0">
			网站使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。
		</iframe>
	</div>
	<%--头部内容 结束--%>

	<%--左侧导航 开始--%>
	<div region="west" split="false" style="width:187px; overflow: hidden;" border="false">
		<iframe src="${pageContext.request.contextPath}/back/backLogin/selectPurview.action?id=${purviewId}" id="leftFrame" name="leftFrame"
				width="187" height="100%" scrolling="no" frameborder="0" marginheight="0" marginwidth="0">
			网站使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。
		</iframe>
	</div>
	<%--左侧导航 结束--%>
	<%--主体内容 开始--%>
	<div data-options="region:'center'" style="overflow:hidden;">
		<div id="tt" class="easyui-tabs" data-options="fit:true,border:false,tools:'#tab-tools'">
			<div title="首页" style="padding:0px; overflow: hidden;">
				<iframe src="${pageContext.request.contextPath}/HYYTBackLogin/welcome.action" id="rightFrame"  name="rightFrame"
						width="100%" height="100%" scrolling="no" frameborder="0" marginheight="0" marginwidth="0">
					网站使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。
				</iframe>
			</div>
		</div>
		<div id="tab-tools">
			<a href="javascript:;" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-clear'" onclick="closeAll()">全部关闭</a>
		</div>
	</div>
	<%--主体内容 结束--%>

	<%--底部内容 开始--%>
	<div region="south" split="false" style="width:100%; height: 10px; padding: 0px; background-color: #297bba; overflow: hidden;" border="false"></div>
	<%--底部内容 结束--%>
	</body>
</html>

