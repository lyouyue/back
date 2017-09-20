<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>系统欢迎页信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"后台首页维护",
				iconCls:"icon-save", */ 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/statistics/ListStatistics.action",
				queryParams:{pageSize:pageSize},
				idField:"statisticsId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"statisticsType",title:"模块类型",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		            	 if(value!=null&&value!=""){
		            	<s:iterator value="#application.keybook['statisticsType']" var="kb">
						if(value=="<s:property value='#kb.value'/>"){
							return "<s:property value='#kb.name'/>";
						}
					   </s:iterator>
		            	}  
		            }  
					}, 
					{field:"statisticsName",title:"名称",width:80},
					{field:"statisticsCode",title:"编码",width:60},
					{field:"statisticsNum",title:"展示内容",width:60},
					{field:"statisticColor",title:"背景颜色",width:60},
					{field:"updateTime",title:"更新时间",width:100},
					{field:"sortCode",title:"排序",width:60},
					{field:"isShow",title:"是否显示",width:60,formatter:function(value,rowData,rowIndex){
						 if(value==1){
			         		 return"<font class='color_001'>显示</font>";
			         	  }else if(value==0){
			         		 return"<font class='color_002'>不显示</font>";
			         	  }
					}},
					{field:"statisticsUrl",title:"链接",width:300}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
				if("add".equals((String)functionsMap.get(purviewId+"_add"))){
				%> 
				   {//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(800,'auto',"&nbsp;&nbsp;添加系统欢迎页信息","icon-add",false,"addOrEditWin");
						document.getElementById("statisticsCode").readOnly=false;
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#statisticsId").val(null);
					}
				},"-",
				<%
				 }
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(800,'auto',"&nbsp;&nbsp;修改系统欢迎页信息","icon-edit",false,"addOrEditWin");
							document.getElementById("statisticsCode").readOnly=true;
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/statistics/getStatisticsInfo.action",
							   data: {statisticsId:rows[0].statisticsId},
							   success: function(data){
								   $("#statisticsId").val(data.statisticsId);
								   $("#statisticsType").val(data.statisticsType);
								   $("#statisticsName").val(data.statisticsName);
								   $("#statisticsCode").val(data.statisticsCode);
								   $("#statisticsNum").val(data.statisticsNum);
								   $("#statisticsUrl").val(data.statisticsUrl);
								   $("#statisticColor").val(data.statisticColor);
								   $("#updateTime").val(data.updateTime);
								   $("#sortCode").val(data.sortCode);
								   $("#isShow_"+data.isShow).attr("checked",true);
							   }
							});
						}
					}
				} ,"-", 
				<%
				 }
				if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
					%>
					{
						text:"删除",
						iconCls:"icon-remove",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length<=0){
								msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
							}else{
								$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
									if(data){//判断是否删除
										if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
											var ids="";
											for(var i=0;i<rows.length;i++){
												if(i==rows.length-1)ids+=rows[i].statisticsId;
												else ids+=rows[i].statisticsId+",";
											}
											$.ajax({
											   type: "POST",dataType: "JSON",
											   url: "${pageContext.request.contextPath}/back/statistics/deleteStatistics.action",
											   data: {ids:ids},
											   success: function(data){
												   $("#tt").datagrid("clearSelections");//删除后取消所有选项
												   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
											   }
											});
										}	
									}
								});
							}
						}
					},"-", 
					<%
					 }
				if("initData".equals((String)functionsMap.get(purviewId+"_initData"))){
				%>
				{
					text:"同步数据",
					iconCls:"icon-reload",
					handler:function(){
						$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
						$("<div class=\"datagrid-mask-msg\"></div>").html("正在同步，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
						$.ajax({
							type: "POST",dataType: "JSON",
							url: "${pageContext.request.contextPath}/back/statistics/updateData.action",
							async:false,//false同步;true异步
							success: function(data){
								$("body").children("div.datagrid-mask-msg").remove();
								$("body").children("div.datagrid-mask").remove();
								if(data.isSuccess=="true") {
									msgShow("系统提示", "<p class='tipInfo'>同步成功！</p>", "warning");
									$("#tt").datagrid("reload"); //删除后重新加载列表
								}else{
									msgShow("系统提示", "<p class='tipInfo'>同步失败，请重试！</p>", "warning");
									$("#tt").datagrid("reload"); //删除后重新加载列表
								}
							}
						});
						
					}
				} 
				,"-", 
				<% 
				  }
				if("init".equals((String)functionsMap.get(purviewId+"_init"))){
				%>
				{
					text:"同步数据到内存",
					iconCls:"icon-reload",
					handler:function(){
						$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
						$("<div class=\"datagrid-mask-msg\"></div>").html("正在同步，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
						$.ajax({
							type: "POST",dataType: "JSON",
							url: "${pageContext.request.contextPath}/back/statistics/initStatisticsHome.action",
							async:false,//false同步;true异步
							success: function(data){
								$("body").children("div.datagrid-mask-msg").remove();
								$("body").children("div.datagrid-mask").remove();
								if(data.isSuccess=="true") {
									msgShow("系统提示", "<p class='tipInfo'>同步成功！</p>", "warning");
									$("#tt").datagrid("reload"); //删除后重新加载列表
								}else{
									msgShow("系统提示", "<p class='tipInfo'>同步失败，请重试！</p>", "warning");
									$("#tt").datagrid("reload"); //删除后重新加载列表
								}
							}
						});
						
					}
				},"-",
				<% 
				  }
				%>
				{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
	});
    
    function query(){
	  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,statisticsCode:$("#qstatisticsCode").val(),statisticsName:$("#qstatisticsName").val()};
	  $("#tt").datagrid("load",queryParams); 
	  pageSplit(pageSize,queryParams);//调用分页函数
    }
    
    function reset(){
		$("#qstatisticsCode").val("");
		$("#qstatisticsName").val("");
	}
    </script>
  </head>
  <body>
   <jsp:include page="../../util/item.jsp"/>
 		 <!-- 查询框  -->
  <div class="main">
	 <table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width: 60px;">名称：</td>
				<td class="search_toleft_td" style="width:150px;"><input type="text" id="qstatisticsName" name="s_statisticsName"/> </td>
				<td class="search_toright_td" style="width:50px;">编码：</td>
				<td class="search_toleft_td" style="width:165px;"><input type="text" id="qstatisticsCode" name="s_statisticsCode"/></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		 <jsp:include page="addOrEditor.jsp"/> 
		</div></div>
  </body>
</html>
