<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>首页热搜关键字信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"热门搜索列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/topSearch/listTopSearch.action",
				queryParams:{pageSize:pageSize},
				idField:"topSearchId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"keywords",title:"关键词",width:160},
					{field:"showClient",title:"显示位置",width:160, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							var returnStr = "";
							var valueStr = value+"";
							if(valueStr.indexOf("1")>=0){
								returnStr+="pc端";
							}
							if(valueStr.indexOf("2")>=0){
								if(returnStr!=""){
									returnStr+=",微信端";
								}else{
									returnStr+="微信端";
								}
							}
							if(valueStr.indexOf("3")>=0){
								if(returnStr!=""){
									returnStr+=",app端";
								}else{
									returnStr+="app端";
								}
							}
							return returnStr;
						}
					},
					{field:"sortCode",title:"排序号",width:50},
					{field:"isShow",title:"是否显示",width:70, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value == 1){
								return "<font class='color_001'>显示</font>";
							}else{
								return "<font class='color_002'>不显示</font>";
							}
		         	  	}
					}
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
						$("#topSearchId").val("");
						$(".showClient").attr("checked",false);
						$("#isShow_0").attr("checked",true);
						$("#isShow_1").attr("checked",false);
						createWindow(800,"auto","&nbsp;&nbsp;添加热搜关键字","icon-add",false,"addOrEditWin");
					}
				}
				,"-",
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
							createWindow(800,"auto","&nbsp;&nbsp;修改热搜关键字","icon-edit",false,"addOrEditWin");
							$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/topSearch/getTopSearchObject.action",
								   data: {id:rows[0].topSearchId},
								   success: function(data){
									   $("#topSearchId").val(data.topSearchId);
									   var showClient = data.showClient;
									   var showClientArray = new Array();
									   showClientArray= showClient.split(",");
									   $("[name='topSearch.showClient']:checkbox").each(function(index){
									        $(this).removeAttr("checked");
									    });
										for (var i=0; i<showClientArray.length; i++) {
											$("#showClient_"+showClientArray[i]).attr("checked","checked");
										}
									   $("#keywords").val(data.keywords);
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
											if(i==rows.length-1)ids+=rows[i].topSearchId;
											else ids+=rows[i].topSearchId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/topSearch/deleteTopSearch.action",
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
				if("init".equals((String)functionsMap.get(purviewId+"_init"))){
					%>
					{
						text:"同步热搜关键字",
						iconCls:"icon-reload",
						handler:function(){
							$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步热搜关键字到系统内存中吗?</p>",function(data){
								if(data){//判断是否删除
									//获取更新初始化信息url
									var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
									//截取
									var splitUrl=prefixUrl.split("@");
									var url=splitUrl[0]+"front/topSearch/updateInServletContextTopSearch.action?callback=?";
									$.getJSON(url);
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
</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<!-- <table class="searchTab">
		</table><br/> -->
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<!-- 添加或者修改 -->
		<jsp:include page="addOrEditor.jsp"/>
		</div>
	</div>	
</body>
</html>
