<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<title>套餐扩展属性</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
	$(function(){
			$("#tt").datagrid({//数据表格
				/* title:"套餐扩展属性列表信息:<font color='blue'>${name}</font>",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/productAttribute/findAllProductAttribute.action?productTypeId="+${productTypeId},
				queryParams:{pageSize:pageSize},
				idField:"productAttrId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"name",title:"属性名称",width:120, formatter:function(value,rowData,rowIndex){//function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.productAttrId+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";  
						}
					},
					{field:"sortName",title:"分类名称",width:120},
					{field:"sort",title:"排序",width:80},
					{field:"isListShow",title:"是否列表显示",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
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
						createWindow(900,430,"&nbsp;&nbsp;添加套餐属性","icon-add",false,"addOrEditWin",10);
						$("#nameMsg").html("");
						$("#save").css("display","");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#productAttrId").val(null);
						$("#info").val(null);
						$("#nameValue0").val(null);
						$("#attrValueId0").val(null);
						$("#sortValue0").val(1);//默认是1
						$(".addAttrValue").remove();
						$("#eproductTypeId").val(${productTypeId});
						$("#productTypeId").val(${productTypeId});
						$("#productTypeId").attr("disabled","disabled");
						$("#isListShow_1").attr("disabled","disabled");
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
							createWindow(900,430,"&nbsp;&nbsp;修改套餐属性","icon-edit",false,"addOrEditWin",10);
							$("#isListShow_1").removeAttr("disabled");
							$("#isListShow_0").removeAttr("checked");
							$.ajax({
								type: "POST", dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/productAttribute/getProductAttributeById.action",
								data: {ids:rows[0].productAttrId},
								success: function(data){
									$("#attributeValueCount").val(data.attributeValueCount);
									$("#nameMsg").html("");
									$("#save").css("display","");
									var productAttr =data.productAttr;
									$("#name").val(productAttr.name);
									$("#productAttributeName").val(productAttr.name);
									$("#sort").val(productAttr.sort);
									$("#eproductTypeId").val(productAttr.productTypeId);
									$("#productTypeId").val(productAttr.productTypeId);
									$("#productTypeId").attr("disabled","disabled");
									$("#productAttrId").val(productAttr.productAttrId);
									$("#isListShow").val(productAttr.isListShow);
									$("#isListShow_"+productAttr.isListShow).attr("checked",true);
									initAttributeValue(data.attributeValueList);
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
											if(i==rows.length-1)ids+=rows[i].productAttrId;
											else ids+=rows[i].productAttrId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/productAttribute/deleteProductAttribute.action",
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
				} ,"-",
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
		queryParams={selectFlag:true,pageSize:pageSize,attributeName:$("#qattributeName").val()};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数
	}
	function reset(){
		$("#qattributeName").val("");
	}
	</script>
</head>
<body >
	<table class="searchTab">
		<tr>
			<td class="search_toright_td"  style="width:83px;">&nbsp;&nbsp;&nbsp;&nbsp;属性名称：</td>
			<td class="search_toleft_td">
				<input type="text" id="qattributeName"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
				<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
			</td>
			<td></td>
		</tr>
	</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditorProductAttribute.jsp"/>
			<jsp:include page="detailProdAttr.jsp"/>
		</div>
		<!-- </div> -->
  </body>
</html>
