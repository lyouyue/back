<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>交易汇总信息（日期）</title>
	<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
		$(function(){
			$("#tt").datagrid({//数据表格
				/* title:"交易汇总列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/transactionsByDate/ListTransactionsByDate.action",
				idField:"shopInfoId",//唯一性标示字段
				columns:[[//未冻结字段
					{field:"companyName",title:"公司名称",width:200},
					{field:"shopName",title:"店铺名称",width:150},
					{field:"transactionAmount",title:"交易金额 (元)",width:150},
					{field:"commissionProportion",title:"佣金百分比(%) ",width:100},
					{field:"commissionAmount",title:"佣金(元) ",width:80},
					{field:"payableAmount",title:"平台给店铺结算的应付金额(元)",width:150},
					{field:"createTime",title:"统计日期",width:110},
				]],
				toolbar:[//工具条
				    <%
					if("export".equals((String)functionsMap.get(purviewId+"_export"))){
					%>     
				    {
					text:"导出报表",
					iconCls:"icon-redo",
					handler:function(){
						var state = $("#estate").val();
						var beginTime = $("#ebeginTime").val();
						var endTime = $("#eendTime").val();
						var shopName = $("#eshopName").val();
						var rowNum=$("#tt").datagrid("getRows");
						if(rowNum.length>0){
							$.ajax({
								type: "POST",
								dataType: "JSON",
								url : "${pageContext.request.contextPath}/back/transactionsByDate/importExcelJYHZBD.action",
								data: {state:state,beginTime:beginTime,endTime:endTime,shopName:shopName},
								success:function(data){
									if(data.isSuccess=="true"){
										var url=data.filePathXLS;
										window.location.href="${pageContext.request.contextPath}/downloadFile.action?downloadFileUrl="+url+"&downloadFileName="+data.downloadFileName;
									}else{
										msgShow("系统提示", "导出失败点击确定关闭", "warning");
									}
								}
							});
						}else{
							msgShow("系统提示", "没有数据，不能导出", "warning");
						}
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
				}],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
			});
			pageSplit();//调用分页函数
		});

		function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,state:$("#qstate").val(),beginTime:$("#beginTime").val(),endTime:$("#endTime").val(),shopName:$("#qshopName").val(),shopInfoType:$("#qshopInfoType").val()};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		function reset(){
			$("#qshopName").val("");
	       	$("#beginTime").val("");
	    	$("#endTime").val("");
	    	$("#qstate").val("");
	    	$("#qshopInfoType").val("");
		}
	</script>
</head>

<body>
	<!-- 查询框  -->
	<jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
	<div class="main">
		<!-- <div style="width: 99%"> -->
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:85px;">店铺名称：</td>
				<td class="search_toleft_td" style="width:165px;">
					<input id="qshopName" type="text" name="qshopName" class="searchTabinput"></input>
				</td>
				<td class="search_toright_td" style="width: 65px;">统计日期：</td>
				<td class="search_toleft_td" style="width:255px;">
					<input id="beginTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'endTime\')}'})"/>
					- <input id="endTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'beginTime\')}'})"/>     
				</td>
				<td class="search_toright_td" style="width: 65px;">订单状态：</td>
				<td class="search_toleft_td" style="width: 125px;">
					<select id="qstate" class="querySelect">
						<option value="-1">--全部--</option>
						<option value="1">生成订单(未付款)</option>
						<option value="2">生成订单(已付款)</option>
						<option value="3">配货</option>
						<option value="4">发货</option>
						<option value="5">已完成</option>
						<option value="6">订单取消</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:60px;;">店铺类型：</td>
				<td class="search_toleft_td" style="width:100px;">
					<select id="qshopInfoType" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">自营店铺</option>
					    <option value="2">入驻店铺</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<!-- 数据表单  -->
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		</div>
	</div>
</body>
</html>
