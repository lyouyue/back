<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>发货详情信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"发货详情列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shipping/listShipping.action",
				queryParams:{pageSize:pageSize},
				idField:"shippingId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"shippingSn",title:"发货单号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.shippingId+"' onclick='showDetailInfo(this.id);'>"+rowData.shippingSn+"</a>";  
		         	  }  
					}, 
					{field:"ordersNo",title:"订单编号",width:120},  
					{field:"shopName",title:"店铺名称",width:120},
					{field:"shopInfoType",title:"店铺类型",width:80,formatter:function(value,rowData,rowIndex){
						   if(value==1){
							    return"自营店铺";
						   }else if(value==2){
							    return"入驻店铺";
						   }
					 }
					},
					{field:"loginName",title:"会员名称",width:120},  
					{field:"deliveryCorpName",title:"物流公司名称",width:120},  
					{field:"deliverySn",title:"物流单号",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
				if("add".equals((String)functionsMap.get(purviewId+"_addxxx"))){
				%>          
			    {//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(900,300,"&nbsp;&nbsp;添加发货详情","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#shippingId").val(null);
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
							createWindow(900,'auto',"&nbsp;&nbsp;修改发货详情","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/shipping/getShippingObject.action",
							   data: {shippingId:rows[0].shippingId},
							   success: function(data){
								   $("#shippingId").val(data.shippingId);
								   $("#ordersId").val(data.ordersId);
								   $("#shippingSn").val(data.shippingSn);
								   $("#deliveryCorpName").val(data.deliveryCorpName);
								   $("#deliverySn").val(data.deliverySn);
								   $("#dcode").val(data.code);
								   $("#ordersId").attr("disabled","disabled");
								   $("#deliveryCorpName").attr("disabled","disabled");
							   }
							});
						}
					}
				},"-",
				<%
				 }
				if("delete".equals((String)functionsMap.get(purviewId+"_deletexxx"))){
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
											if(i==rows.length-1)ids+=rows[i].shippingId;
											else ids+=rows[i].shippingId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/shipping/deleteShipping.action",
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,title:$("#title").val(),ordersNo:$("#qordersNo").val(),shopInfoType:$("#qshopInfoType").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#title").val("");
    		$("#quserName").val("");
    	}
    </script>
  </head>
  <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
	<body>
		<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
		<div class="main">
			<table class="searchTab">
				<tr>
					<td class="search_toright_td" style=" width: 85px; ">发货单号：</td>
					<td class="search_toleft_td" style="width: 165px;">
						<input type="text" style="width: 160px;" id="title" name="title"/>
					</td>
					<td class="search_toright_td" style="width:70px;">订单号：</td>
					<td class="search_toleft_td" style="width:170px;"><input type="text" id="qordersNo" name="s_name"  style="width:160px;" class="searchTabinput"/></td>
					<td class="search_toright_td" style="width:70px;;">店铺类型：</td>
					<td class="search_toleft_td" style="width:120px;">
						<select id="qshopInfoType" class="querySelect">
							<option value="">--请选择--</option>
							<option value="1">自营店铺</option>
						    <option value="2">入驻店铺</option>
						</select>
					</td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
						<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
			</table>
			<table id="tt"></table>
				<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
					<!-- 添加或者修改 -->
					<jsp:include page="addOrEditShipping.jsp"/>
					<!-- 详情页 -->
					<jsp:include page="detailShipping.jsp"/>
				</div>
			</div>
	</body>
</html>
