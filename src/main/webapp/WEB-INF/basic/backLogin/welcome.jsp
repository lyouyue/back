<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="s" uri="/struts-tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>系统欢迎页</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="shopjsp icon" href="${fileUrlConfig.sysFileVisitRoot_back}common/imgs_init/sj.ico"/>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/main.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/echarts/echarts.min.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/echarts/welcome.js"></script>
</head>
<body>
<div class="welcome">
	<!-- <h1 class="title_t">系统欢迎页</h1> -->
	<div class="show">
		<p>
			您本次登录的时间：<span class="span_grey"><s:property value="#session.time"/></span>，本次登录IP：<span
				class="span_grey"><s:property value="#session.userIp"/></span>
			&nbsp;&nbsp;[本次统计：<span class="span_yellow"><s:property value="#application.time2"/></span>，下次统计：<span
				class="span_yellow"><s:property value="#application.time3"/></span>]
			<%--<span>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:;"onclick="change();">切换</a></span>--%>
			<span onclick="show('pie');" style="background-color:#2e9bf2; width: 191px;cursor:hand; height:16px;font-size:12px; padding:2px 0; vertical-align:middle; color:#fff; border-radius:3px;">&nbsp;&nbsp;饼状图&nbsp;&nbsp;</span>
			<span onclick="show('bar');" style="background-color:#2e9bf2; width: 191px;cursor:hand; height:16px;font-size:12px; padding:2px 0; vertical-align:middle; color:#fff; border-radius:3px;">&nbsp;&nbsp;柱状图&nbsp;&nbsp;</span>
		</p>
		<%-- <p class="sec">
        </p> --%>
	</div>
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
	<div id="main" style="display:none;margin: 20px auto auto auto;width: 1050px;height:480px;background-color: #99BBE8">
	</div>
	<div id="double" style="display:none;margin: 20px auto auto auto;width: 1050px;height:480px;background-color: #ffffff">
		<div id="mainleft" style="margin-right: 0px;width: 520px;height:460px;float: left">
		</div>
		<div id="mainright" style="margin-right: 10px;width: 520px;height:460px;float: left">
		</div>
	</div>
	<!--底部-->
	<div class="system_info">
		<h3>系统信息</h3>
		<div class="system_info_box" style="text-align: center;">
			<span><strong>服务器操作系统：Linux</strong></span>
			<span><strong>Web服务器：Tomcat </strong></span>
			<span><strong>JAVA版本：1.7.0_65</strong></span>
			<span><strong>数据库版本：MySQL 5.5</strong></span>
			<span><strong>版本号：20160810</strong></span>
			<span><strong>安装日期：2016-08-10 10:18:56</strong></span>
		</div>

	</div>
</div>
<script type="text/javascript">
	var type = 'bar';//默认饼状图
	var myChart;
	var myChartLeft;
	var myChartRight;
	var statisticsList;
	var statisticsType;
	window.onload = function () {
		myChart = echarts.init(document.getElementById('main'));
		myChartLeft = echarts.init(document.getElementById('mainleft'));
		myChartRight = echarts.init(document.getElementById('mainright'));
		statisticsList = '${application.statisticsList}';//统计项（json串格式）
		statisticsType = '${statisticsType}';//统计分类（json串格式）
		statisticsList = eval('('+statisticsList+')');//解析
		statisticsType = eval('('+statisticsType+')');//解析
		show('pie');//默认饼状图
	};
	function show(param){
		if('pie'==param&&'bar'==type){
			myChartLeft.clear();
			myChartRight.clear();
			$("#double").hide();
			$("#main").show();
			pie(statisticsList,statisticsType,myChart);
			type = param;
		}else if('bar'==param&&'pie'==type){
			myChart.clear();
			$("#main").hide();
			$("#double").show();
			bar(statisticsList,statisticsType,myChartLeft,myChartRight);
			type = param;
		}
	}
</script>
</body>
</html>

