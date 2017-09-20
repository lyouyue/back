<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>套餐属性值信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
    	var productAttrId = '${productAttrId}';
		   $("#tt").datagrid({//数据表格
				/* title:"套餐扩展属性值列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/attributeValue/listAttributeValue.action?productAttrId="+${productAttrId},
				queryParams:{pageSize:pageSize},
				idField:"attrValueId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"attrValueName",title:"属性值名称",width:120 },
					{field:"sort",title:"排序",width:80}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加属性值","icon-add",false,"addOrEditWin");
						$("#nameMsg").html("");
						$("#save").css("display","");
						$("#addOrEditWin").css("display","");
						$("#attrValueId").val(null);
						$("#productAttrId").val(${productAttrId});
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
							createWindow(700,'auto',"&nbsp;&nbsp;修改属性值","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/attributeValue/getAttributeValueInfo.action",
							   data: {ids:rows[0].attrValueId},
							   success: function(data){
								   $("#nameMsg").html("");
								   $("#save").css("display","");
								   $("#attrValueId").val(data.attrValueId);
								   $("#productAttrId").val(data.productAttrId);
								   $("#attrValueName").val(data.attrValueName);
								   $("#sort").val(data.sort);
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
											if(i==rows.length-1)ids+=rows[i].attrValueId;
											else ids+=rows[i].attrValueId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/attributeValue/deleteAttributeValues.action",
										   data: {ids:ids,productAttrId:productAttrId},
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
				} ,"-",
				<%
				}
				%>
				{
					text:"返回套餐属性列表",
					iconCls:"icon-back",
					handler:function(){
						window.location.href="${pageContext.request.contextPath}/back/productAttribute/gotoProductAttributeList.action?productTypeId="+${productTypeId};
					}
				},"-",{text:"刷新",
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
  	  	queryParams={selectFlag:true,pageSize:pageSize,name:$("#qname").val()};
  	  	$("#tt").datagrid("load",queryParams); 
  	  	pageSplit(pageSize,queryParams);//调用分页函数
  	}
    function reset1(){
		$("#qname").val("");
	}
</script>
	</head>
	<body>
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width: 95px;">属性值名称：</td>
				<td class="search_toleft_td"><input type="text" id="qname" name="name" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset1()">重置</a>
				</td>
				<td></td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
		  <jsp:include page="addOrEditorAttributeValue.jsp"/>
		</div>
</body>
</html>
