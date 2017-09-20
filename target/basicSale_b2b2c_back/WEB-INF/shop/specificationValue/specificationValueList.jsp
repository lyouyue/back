<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>商品规格值</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"商品规格值列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/specificationValue/listSpecificationValue.action",
				queryParams:{pageSize:pageSize},
				idField:"specificationValueId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"specificationId",title:"规格名称",width:150}, 
					{field:"valueName",title:"规格值",width:150},
					{field:"categoryName",title:"分类名称",width:150},
					{field:"sort",title:"排序号",width:150}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加商品规格值","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						//$("#photo").html("");
						 $("#specificationValueId").val(null);
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
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>只能修改一项！</p>", "warning");
						}else{
							createWindow(700,'auto',"&nbsp;&nbsp;修改商品规格值","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/specificationValue/getSpecificationValueInfo.action",
							   data: {specificationValueId:rows[0].specificationValueId},
							   success: function(data){
								   $("#specificationValueId").val(data.specificationValueId);
								   $("#specificationId").val(data.specificationId);
								   $("#name").val(data.name);
								   //$("#image").val(data.image);
								   $("#sort").val(data.sort);
								   //$("#photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.image+"' width='120px' height='120px' />");
							   }
							});
						}
					}
				},"-",
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
											if(i==rows.length-1)ids+=rows[i].specificationValueId;
											else ids+=rows[i].specificationValueId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/specificationValue/deleteSpecificationValue.action",
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
				}
				,"-", 
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
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,specificationValueName:$.trim($("#qspecificationValueName").val())};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#qspecificationValueName").val("");
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
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td"   style="width:86px;">规格名称：</td>
				<td class="search_toleft_td">
					<input type="text" id="qspecificationValueName"/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditor.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detail.jsp"/>
		</div>
		</div>
</body>
</html>
