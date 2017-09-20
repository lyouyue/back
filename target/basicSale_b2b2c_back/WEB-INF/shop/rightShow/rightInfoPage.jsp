<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>首页右面模块信息</title>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}shop/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}shop/css/workspace.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
	<!--IE6png图片透明-->
	<!--[if IE 6]> 
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/ie6.js"></script>
		<script type="text/javascript">
			DD_belatedPNG.fix("img,.codeTop,.codeBottom,.codeCenter"); 
		</script>
	<![endif]-->

	<style type="text/css">
	<!--
	body {
		margin:0;
		overflow:hidden;
		}
	-->
	</style>
	<style> 
	.navPoint { 
		color:white;
		cursor:hand;
		font-size:12px;
		font-family:"微软雅黑", "黑体";
		} 
	</style> 
	<script>
	var flag=true;
	function switchSysBar(){ 
		if (flag){ 
			document.all("img1").src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/workspace/main_18_1.gif";
			document.all("frmTitle").style.display="none" ;
			flag=false;
		} else { 
			document.all("img1").src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/workspace/main_18.gif";
			document.all("frmTitle").style.display="" ;
			flag=true;
		} 
	} 
	
	function changeMenu(id,url){
		$("li").each(function(i){
		   if(id=="menu"+(i+1)){
			  $(this).attr("class","fl on");
			   window.leftFrame.location.href=url;
		   }else{
			  $(this).attr("class","fl");
		   }
		});
	}
	</script>
</head>

<body>
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" style="table-layout:fixed;">
	  <tr>
	    <td width="172" id=frmTitle noWrap name="fmTitle" align="center" valign="top">
			<iframe name="leftFrame" height="100%" width="172" src="${pageContext.request.contextPath}/back/rightShow/leftShowTypeList.action" border="0" frameborder="0" scrolling="no"></iframe>
	    </td>
	    <td width="8" valign="middle" background="${fileUrlConfig.sysFileVisitRoot_back}basic/images/workspace/main_12.gif" onclick="switchSysBar()">
	    	<span class="navPoint"><img src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/workspace/main_18.gif" name="img1" width=8 height=52 id=img1></span>
	    </td>
	    <td valign="top"><iframe name="proInfo" height="100%" width="100%" src="" border="0" frameborder="0" scrolling="no"></iframe></td>
	    <td width="4" align="center" valign="top"></td>
	  </tr>
	</table>
</body>
</html>
