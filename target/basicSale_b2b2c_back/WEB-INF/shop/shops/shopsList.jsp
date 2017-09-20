	<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
	<%@ include file="../../util/doFunction.jsp"%>
	<%@ taglib prefix="s" uri="/struts-tags" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
	<html xmlns="http://www.w3.org/1999/xhtml">
	  <head>
	    <title>线下商城信息</title>
	    <jsp:include page="../../util/import.jsp"/>
		<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
		<script type="text/javascript">
		$(function(){
			$("#tt").datagrid({//数据表格
				/* title:"线下商城信息列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shops/findShopsList.action",
				queryParams:{pageSize:pageSize},
				idField:"shopsId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"shopsCode",title:"商城编号",width:150, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return "<a style='display:block;cursor: pointer;' id='"+rowData.shopsId+"' onclick='showDetailInfo(this.id);'>"+rowData.shopsCode+"</a>";  
					}
					}, 
					{field:"shopsName",title:"商城名称",width:150},
					{field:"address",title:"地址",width:120},
					{field:"createTime",title:"加入时间",width:200}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
					<%
					//if("add".equals((String)functionsMap.get(purviewId+"_add"))){
					%>
					{//工具条
						text:"添加",
						iconCls:"icon-add",
						handler:function(){
							$("#fullId").val("");
							$("#shopsId").val("");
							$("#addOrEditWin").css("display","");
							$("#detailWin").css("display","none");
							$("select").attr("disabled",false);
							createWindow(850,'auto',"&nbsp;&nbsp;添加线下商城","icon-add",false,"addOrEditWin");
						}
					},"-",
					<%
					//}
					//if("update".equals((String)functionsMap.get(purviewId+"_update"))){
					%>
					{
						text:"修改", 
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
							}else if(rows.length==1){
								$("select").attr("disabled",true);
								createWindow(850,'auto',"&nbsp;&nbsp;修改线下商城","icon-edit",false,"addOrEditWin");
								   $.ajax({
									   type: "POST", dataType: "JSON",
									   url: "${pageContext.request.contextPath}/back/shops/getShopsObject.action",
									   data: {shopsId:rows[0].shopsId},
									   success: function(data){
										   $("#firstArea").val(data.regionLocation);
									   	   chengeArea(data.regionLocation,1,data.city);
									   	   chengeArea(data.city,2,data.areaCounty);	
											$("#shopsId").val(data.shopsId);
											$("#shopsCode").val(data.shopsCode);
											$("#shopsName").val(data.shopsName);
											$("#address").val(data.address);
											$("#note").html(data.note);
											$("#createTime").val(data.createTime);
									}
									});
							}
						}
					},"-",
					<%
					//}
					//if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
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
												if(i==rows.length-1)ids+=rows[i].shopsId;
												else ids+=rows[i].shopsId+",";
											}
											$.ajax({
											   type: "POST",dataType: "JSON",
											   url: "${pageContext.request.contextPath}/back/shops/deleteShops.action",
											   data: {ids:ids},
											   success: function(data){
													$("#tt").datagrid("clearSelections");//删除后取消所有选项
													$("#tt").datagrid("reload"); //删除后重新加载列表
											   }
											});
										}
									}
								});
							}
						}
					},"-",
					<%
					//}
					//if("connectShop".equals((String)functionsMap.get(purviewId+"_connectShop"))){
					%>
					{
						text:"查看线下商城店铺",
						iconCls:"icon-search",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择一个活动主题！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								location.href="${pageContext.request.contextPath}/back/shopsShopinfo/gotoShopsShopinfoPage.action?shopsId="+rows[0].shopsId;
							}
						}
					},"-",
					<%
					// }
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
			queryParams={shopsCode:$.trim($("#s_shopsCode").val()),shopsName:$.trim($("#s_shopsName").val()),startTime:$.trim($("#s_startTime").val()),endTime:$.trim($("#s_endTime").val())};
			$("#tt").datagrid("load",queryParams);
			pageSplit(pageSize,queryParams);//调用分页函数
		}

		function reset(){
			$("#s_shopsCode").val("");
	       	$("#s_shopsName").val("");
	    	$("#s_startTime").val("");
	    	$("#s_endTime").val("");
		}
		
		function doSelect(){
			$("#tt").datagrid("clearSelections"); //取消所有选项
			queryParams={shopsCode:$.trim($("#s_shopsCode").val()),shopsName:$.trim($("#s_shopsName").val()),startTime:$.trim($("#s_startTime").val()),endTime:$.trim($("#s_endTime").val())};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
	 	 }
	</script>
</head>
	<body>
		<jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
		<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style=" width:80px; ">商城编号：</td>
				<td class="search_toleft_td" style="width:180px;"><input type="text" id="s_shopsCode" style="width: 160px;" name="s_shopsCode" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:70px;">商城名称：</td>
				<td class="search_toleft_td" style="width:180px;"><input type="text" id="s_shopsName"  style="width: 160px;" name="s_shopsName" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:70px;">加入时间：</td>
				<td class="search_toleft_td"  style="width: 280px;">
					<input id="s_startTime" class="Wdate"  type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'s_endTime\')||\'2050-10-01\'}'})"/> -
					<input id="s_endTime" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'s_startTime\')}',maxDate:'2050-10-01'})"/>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td> 
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;">
			<jsp:include page="addOrEditor.jsp"></jsp:include>
			<jsp:include page="detail.jsp"></jsp:include>
		</div>
	</div>
  </body>
</html>
