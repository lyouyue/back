<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>店铺客服信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"店铺客服信息列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customerService/listCustomerService.action",
				queryParams:{pageSize:pageSize},
				idField:"customerServiceId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"trueName",title:"真实姓名",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.customerServiceId+"' onclick='showDetailInfo(this.id);'>"+rowData.trueName+"</a>";  
		         	  }
					},
					{field:"nikeName",title:"昵称",width:120,},
					{field:"qq",title:"qq",width:80,},
					{field:"useState",title:"使用状态",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="0"){ return "<font class='color_002'>废弃</font>";} 
                        if(value=="1"){ return "<font class='color_001'>正常使用</font>";} 
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
						createWindow(900,"auto","&nbsp;&nbsp;添加店铺客服","icon-add",false,"addOrEditWin");
						$("#photo1").html("");
						$("#fileId1").val("");
						$("#imageUrl1").val("");
						$("#mymessage1").html("");
						$("#customerServiceId").val(null);
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
							$("#fileId1").val("");
							createWindow(900,'auto',"&nbsp;&nbsp;修改店铺客服","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/customerService/getCustomerServiceInfo.action",
							   data: {ids:rows[0].customerServiceId},
							   success: function(data){
								   $("#customerServiceId").val(data.customerServiceId);
								   $("#trueName").val(data.trueName);
								   $("#imageUrl1").val(data.photoUrl);
								   $("#photo1").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.photoUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='30px' height='30px' />");
								   $("#nikeName").val(data.nikeName);
								   $("#mobile").val(data.mobile);
								   $("#phone").val(data.phone);
								   $("#workNumber").val(data.workNumber);
								   $("#qq").val(data.qq);
								   $("#useState_"+data.useState).attr("checked",true);
							   }
							});
						};
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
											if(i==rows.length-1)ids+=rows[i].customerServiceId;
											else ids+=rows[i].customerServiceId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/customerService/deleteCustomerServices.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
									};
								};
							});
						};
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
  	  	queryParams={selectFlag:true,pageSize:pageSize,trueName:$("#qtrueName").val(),nikeName:$("#qnikeName").val(),qq:$("#qQQ").val(),useState:$("#quseState").val()};
  	  	$("#tt").datagrid("load",queryParams); 
  	  	pageSplit(pageSize,queryParams);//调用分页函数
  	}
  	function reset(){
		$("#qtrueName").val("");
       	$("#qnikeName").val("");
    	$("#qQQ").val("");
    	$("#quseState").val("");
	}
    </script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:85px;">真实姓名：</td>
				<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qtrueName" name="trueName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width: 55px;">昵称：</td>
				<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qnikeName" name="nikeName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width: 50px;">QQ：</td>
				<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qQQ" name="qq" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:80px;">使用状态：</td>
				<td class="search_toleft_td" style="width: 115px;">
					<select id="quseState" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">废弃</option>
						<option value="1">正常使用</option>
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
			<jsp:include page="addOrEditorCustomerService.jsp"/>
			<jsp:include page="detailCustomerService.jsp"/>
		</div>
	</div>
</body>
</html>
