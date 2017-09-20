<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>商城首页信息同步操作</title>
    <jsp:include page="../../util/import.jsp"/>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style type="text/css">
    	a{font-weight: bolder;color:#003D79;height:20px; font-size:14px; margin-top: 5px;}
    	.querybtn{padding:5px 15px;border: 1px #4F9D9D solid;display: inline-block;height: 16px;line-height: 16px;}
	</style>
	<script type="text/javascript">
	    var contextPath = '${fileUrlConfig.contextPath}';
		function homePage(){
			window.open(contextPath+"shopHome/gotoHomePage.action");
		}
		function homeUpdate(){
			$.messager.confirm("系统提示", "<p class='tipInfo'>确定要同步【商城首页】初始化信息吗？</p>",function(data){
				if(data){
					//获取更新初始化信息url
					var url=contextPath+"shopHome/build.action?callback=?";
					$.getJSON(url);
				}
			});
		}
	</script>
</head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<span class="querybtn"><a href="javascript:homePage();" style="width: 300px;" >首页动态页预览</a></span>
		<!--<br/><br/><br/> -->
		<!--<span class="querybtn" ><a href="javascript:homeBuild();" style="width: 300px;" >首页静态页手动生成</a></span> -->
		<br/><br/><br/>
		<span class="querybtn"><a href="javascript:homeUpdate();" style="width: 300px;" >同步【商城首页】初始化信息</a></span>
	</div>
	</body>
</html>
