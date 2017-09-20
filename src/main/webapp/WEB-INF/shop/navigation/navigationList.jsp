<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>首页导航条信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"前台导航条列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/navigation/listNavigation.action",
				queryParams:{pageSize:pageSize},
				idField:"navigationId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
				   {field:"navigationName",title:"首页导航条名称",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.navigationId+"' onclick='showDetailInfo(this.id);'>"+rowData.navigationName+"</a>";  
		         	  }  
					}, 
				   {field:"navigationUrl",title:"首页导航条链接",width:100,}, 
					{field:"isUser",title:"是否使用",width:50,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>不使用</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>使用</font>";} 
                         }
					},
					{field:"isShowOnBar",title:"是否显示",width:50,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>不显示</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>显示</font>";} 
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
						createWindow(900,'auto',"&nbsp;&nbsp;添加导航条","icon-add",false,"addOrEditWin");
						$("#nameMsg").html("");
						$("#save").css("display","");
						$("#navigationId").val("");
						$("#navigationName").val("");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
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
		    			createWindow(900,'auto',"&nbsp;&nbsp;修改导航条","icon-edit",false,"addOrEditWin");
		    			$("#nameMsg").html("");
						$("#save").css("display","");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
		    			$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/navigation/getNavigationObject.action",
							   data: {navigationId:rows[0].navigationId},
							   success: function(data){
								   $("#navigationId").val(data.navigationId);
								   $("#navigationName").val(data.navigationName);
								   $("#navigationUrl").val(data.navigationUrl);
								   $("#sortCode").val(data.sortCode);
								   $("#isUser_"+data.isUser).attr("checked",true);
								   $("#isShowOnBar_"+data.isShowOnBar).attr("checked",true);
								   $("#seoTitle").val(data.seoTitle);
								   $("#seoKeyWords").val(data.seoKeyWords);
								   $("#seoDescrible").val(data.seoDescrible);
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
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].navigationId;
											else ids+=rows[i].navigationId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/navigation/deleteNavigation.action",
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
						text:"同步首页导航条",
						iconCls:"icon-reload",
						handler:function(){
							$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步导航条到系统内存中吗?</p>",function(data){
								if(data){//判断是否删除
									//获取更新初始化信息url
									var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
									//截取
									var splitUrl=prefixUrl.split("@");
									var url=splitUrl[0]+"/update/updateNavigation.action?callback=?";
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
    
    	function query(){
    		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,navigationName:$("#qnavigationName").val(),isUser:$("#qisUser").val(),isShowOnBar:$("#qisShowOnBare").val()};
    	  	$("#tt").datagrid("load",queryParams); 
    	  	pageSplit(pageSize,queryParams);//调用分页函数 
        }

		function reset(){
			$("#qnavigationName").val("");
	       	$("#qisUser").val("");
	    	$("#qisShowOnBare").val("");
		}
	</script>
	<style type="text/css">
		 .linkbtn{margin-top: 5px;margin-right: 10px;}
		 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
		 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
		 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:123px;">首页导航条名称：</td>
				<td class="search_toleft_td" style="width:165px;"><input type="text" id="qnavigationName" name="navigationName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width: 75px;">是否使用：</td>
				<td class="search_toleft_td" style="width: 85px;">
					<select id="qisUser" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">不使用</option>
						<option value="1">使用</option>
					</select></td>
				<td class="search_toright_td" style="width: 85px;">是否显示：</td>
				<td class="search_toleft_td" style="width: 110px;">
					<select id="qisShowOnBare" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">不显示</option>
						<option value="1">显示</option>
					</select></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
				<td></td>
			</tr>
		</table>
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 添加或者修改 -->
				<jsp:include page="addOrEditor.jsp"/>
				<!-- 详情 -->
				<jsp:include page="detailNavigation.jsp"/>
			</div>
		</div>
	</body>
</html>
