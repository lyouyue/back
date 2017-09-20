<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>促销活动申请</title>
    <jsp:include page="../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"促销活动申请",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/promotionapply/listPromotionApply.action",
				queryParams:{pageSize:pageSize},
				idField:"promotionApplyId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerName",title:"会员名称",width:120, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.promotionApplyId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerName+"</a>";  
		         	  	}  
					}, 
					{field:"shopName",title:"店铺名称",width:120}, 
					{field:"beginTime",title:"活动开始时间",width:120}, 
					{field:"endTime",title:"活动结束时间",width:120},  
					{field:"applyTime",title:"申请时间",width:120}, 
					{field:"isPass",title:"是否通过",width:120,
						formatter:function(value,rowData,rowIndex){
							   if(value==0){
								    return"否";
							   }else{
								    return"是";
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
						createWindow(900,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#passWin").css("display","none");
						$("#hshopName").html("");
						$("#promotionApplyId").val(null);
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
							createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
			    			$("#addOrEditWin").css("display","");
							$("#detailWin").css("display","none");
							$("#passWin").css("display","none");
			    			$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/promotionapply/getPromotionApplyById.action",
								   data: {ids:rows[0].promotionApplyId},
								   success: function(data){
									   $("#promotionApplyId").val(data.promotionApplyId);
									   $("#shopInfoId").val(data.shopName);
									   $("#customerId").val(data.customerName);
									   $("#shopInfoId").val(data.shopInfoId);
									   $("#customerId").val(data.customerId);
									   $("#hshopName").html(data.shopName);
									   $("#beginTime").val(data.beginTime);
									   $("#endTime").val(data.endTime);
									   $("#applyTime").val(data.applyTime);
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
											if(i==rows.length-1)ids+=rows[i].promotionApplyId;
											else ids+=rows[i].promotionApplyId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/promotionapply/deletePromotionApply.action",
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
				if("check".equals((String)functionsMap.get(purviewId+"_check"))){
				%>
				{
					text:"审核",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择审核项！</p>", "warning");
						}else{
							if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
								var ids="";
								for(i=0;i<rows.length;i++){
									if(i==rows.length-1)ids+=rows[i].promotionApplyId;
									else ids+=rows[i].promotionApplyId+",";
								}
								createWindow(900,500,"&nbsp;&nbsp;审核信息","icon-tip",false,"passWin");
								$("#addOrEditWin").css("display","none");
								$("#detailWin").css("display","none");
								$("#passWin").css("display","");
								$.ajax({
									   type: "POST",
									   url: "${pageContext.request.contextPath}/back/promotionapply/getPromotionApplyById.action",
									   data: {ids:ids},
									   dataType: "JSON",
									   success: function(data){
										   $("#sromotionApplyId").val(data.promotionApplyId);
										   $("#scustomerId").val(data.customerId);
										   $("#sshopInfoId").val(data.shopInfoId);
										   $("#pcustomerId").val(data.customerName);
										   $("#phopInfoId").val(data.shopName);
										   $("#pbeginTime").val(data.beginTime);
										   $("#pendTime").val(data.endTime);
										   $("#papplyTime").val(data.applyTime);
									   }
								});
								
							}
						}
					}
				},"-",
				<%
				 }
				%>
				{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});
    
     	
    	function query(){
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,ordersId:$("#parameOrdersId").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	
    	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
    			$("#addOrEditWin").css("display","");
				$("#detailWin").css("display","none");
				$("#passWin").css("display","none");
    			$.ajax({
					   type: "POST", dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/promotionapply/getPromotionApplyById.action",
					   data: {ids:id},
					   success: function(data){
						   $("#promotionApplyId").val(data.promotionApplyId);
						   $("#shopInfoId").val(data.shopName);
						   $("#customerId").val(data.customerName);
						   $("#shopInfoId").val(data.shopInfoId);
						   $("#customerId").val(data.customerId);
						   $("#hshopName").html(data.shopName);
						   $("#beginTime").val(data.beginTime);
						   $("#endTime").val(data.endTime);
						   $("#applyTime").val(data.applyTime);
					   }
					});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/promotionapply/deletePromotionApply.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
				});
    		}
    	}
    </script>
  </head>
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
		  <!-- 添加或者修改 -->
		  <jsp:include page="addOrEdit.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		  <!-- 审核页面 -->
		  <jsp:include page="isPass.jsp"/>
		</div>
  </body>
</html>
