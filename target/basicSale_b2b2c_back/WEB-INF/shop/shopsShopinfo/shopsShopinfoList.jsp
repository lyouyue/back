	<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
	<%@ include file="../../util/doFunction.jsp"%>
	<%@ taglib prefix="s" uri="/struts-tags" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
	<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>线下商城店铺信息</title>
	<jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
	$(function(){
		$("#form1").validate({meta: "validate", 
			submitHandler:function(form){
				$(document).ready(function() {
					//判断是否有选中的商品
					var rows = $("#shopInfoList").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择商品！</p>", "warning");
						}else{
							if(rows){
								var shopInfoIds="";
								for(var i=0;i<rows.length;i++){
									if(i==rows.length-1)shopInfoIds+=rows[i].shopInfoId+",";
									else shopInfoIds+=rows[i].shopInfoId+",";
								}
								$("#shopInfoIds").val(shopInfoIds);//数据放入表单
								 var options = {
									url:"${pageContext.request.contextPath}/back/shopsShopinfo/saveOrUpdateShopsShopinfo.action",
									type:"post",
									dataType:"json",
									success:function(data){
										$("#shopInfoIds").val("");
										closeWin();
										$("#tt").datagrid("clearSelections");//删除后取消所有选项
										$("#tt").datagrid("reload"); //保存后重新加载列表
										$("#shopInfoList").datagrid("clearSelections");//删除后取消所有选项
										$("#shopInfoList").datagrid("reload"); //保存后重新加载列表
									}
								};
								$("#form1").ajaxSubmit(options);
							}
						}
					});
					}
				});
		   $("#tt").datagrid({//数据表格
				/* title:"${shops.shopsName}>>商城下店铺列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopsShopinfo/findShopsShopinfoList.action?shopsId=${shopsId}",
				idField:"shopsShopinfoId",//唯一性标示字段
				frozenColumns:[[//冻结字段
					{field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"shopName",title:"店铺名称",width:150},
					{field:"shopCategoryName",title:"店铺分类名称",width:100},
					{field:"customerName",title:"店铺管理员",width:100},
					{field:"shopsName",title:"商城名称",width:150}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号 
				singleSelect:true,//true只可以选中一行
				toolbar:[
				{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(900,480,"&nbsp;&nbsp;添加线下店铺","icon-add",false,"addOrEditWin",10);
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#shopInfoList").datagrid({//数据表格
							width:"auto",
							height:"auto",
							fitColumns: true,//宽度自适应
							align:"center",
							loadMsg:"正在处理，请等待......",
							striped: true,//true是否把一行条文化
							url:"${pageContext.request.contextPath}/back/shopsShopinfo/findShopInfoList.action?shopsId=${shopsId}",
							idField:"shopInfoId",//唯一性标示字段
							frozenColumns:[[//冻结字段
							    {field:"ck",checkbox:true}
							]],
							columns:[[//未冻结字段
								{field:"shopName",title:"店铺名称",width:150},
								{field:"customerName",title:"店铺管理员",width:80},
								{field:"companyName",title:"所属公司",width:80},
								{field:"isPass",title:"审核是否通过",width:60, formatter:function(value,rowData,rowIndex){
									if(value==1){
										return "待审核";
									}else if(value==3){
										return "通过";
									}else{
										return "不通过";
									}
								  }
							   }
							]],
							pagination:true,//显示分页栏
							rownumbers:true,//显示行号   
							singleSelect:true//true只可以选中一行
						});
						pageSplitThis(pageSize,null,"shopInfoList");//调用分页函数
					//	pageSplitThis(pageSize,queryParams,"shopInfoList");//调用分页函数
					}
				},"-",
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
											if(i==rows.length-1)ids+=rows[i].shopsShopinfoId;
											else ids+=rows[i].shopsShopinfoId+",";
										}
										$.ajax({
											type: "POST",dataType: "JSON",
											url: "${pageContext.request.contextPath}/back/shopsShopinfo/deleteShopsShopinfo.action",
											data: {ids:ids},
											success: function(data){
												ids="";
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
				{
					 text:"返回线下商城列表",
					 iconCls:"icon-back",
					 handler:function(){
						location.href="${pageContext.request.contextPath}/back/shops/gotoShopsPage.action";
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
		   pageSplitThis(pageSize,queryParams,"tt");//调用分页函数
		});
	 //条件查询
    function query(){
		$("#tt").datagrid("clearSelections"); //取消所有选项
		queryParams={selectFlag:true,shopName:$.trim($("#qshopName").val())};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);
 	 }
    function reset(){
    	$("#qshopName").val("");
 	 }
    </script>
	</head>
	<body>		
		<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:100px;">店铺名称：</td>
				<td class="search_toleft_td" style="width:240px;"><input type="text" id="qshopName" style="width:210px;"/></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加 -->
			<jsp:include page="addShopsShopinfo.jsp"/>
		</div>
	</div>
	</body>
</html>