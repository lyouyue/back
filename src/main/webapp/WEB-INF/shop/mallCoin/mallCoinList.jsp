<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员金币信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"会员金币明细列表信息",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/mallCoin/mallCoinList.action",
				queryParams:{pageSize:pageSize},
				idField:"mallCoinId",//唯一性标示字段
				columns:[[//未冻结字段
		            {field:"serialNumber",title:"流水号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.mallCoinId+"' onclick='showDetailInfo(this.id);'>"+rowData.serialNumber+"</a>";
		         	  }
					},
					{field:"loginName",title:"会员名称",width:120},
					{field:"ordersNo",title:"订单号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value!=null&&value!=""&&value!="null"){
								return value;
							}else{
								return "无";
							}
						}
					},
					{field:"transactionNumber",title:"交易数量(个)",width:120},
					/* {field:"remainingNumber",title:"剩余数量",width:120}, */
					
// 					{field:"proportion",title:"分享比例",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
// 							if(value!=null&&value!=""&&value!="null"){
// 								return value;
// 							}else{
// 								return "无";
// 							}
// 						}
// 					},
					{field:"type",title:"类型",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="1"){
								return "<font class='color_001'>收入</font>";
							}else if(value="2"){
								return "<font class='color_002'>支出</font>";
							}else if(value="3"){
								return "<font class='color_003'>取消订单</font>";
							}else if(value="4"){
								return "<font class='color_004'>交易作废</font>";
			         	  	}
						}
					},
					{field:"tradeTime",title:"交易时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<%
				if("export".equals((String)functionsMap.get(purviewId+"_export"))){
				%>
					{//工具条
					text:"导出报表",
					iconCls:"icon-redo",
					handler:function(){
						window.location.href="${pageContext.request.contextPath}/back/statisticAnalysisExcel/exportStatisticOrders.action?loginName="+$("#loginName").val()+"&ordersNo="+$("#ordersNo").val()+"&createTime="+$("#qregisterDate").val()+"&endTime="+$("#qregisterDate2").val();
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,loginName:$("#loginName").val(),ordersNo:$("#ordersNo").val(),balanceType:$("#qbalanceType").val(),registerDate:$("#qregisterDate").val(),registerDate2:$("#qregisterDate2").val()};
			  $("#tt").datagrid("load",queryParams);
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#loginName").val("");
           	$("#ordersNo").val("");
           	$("#qbalanceType").val("");
        	$("#qregisterDate").val("");
        	$("#qregisterDate2").val("");
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
	<div class="main">
		 <table class="searchTab">
			<tr>
				<td class="search_toright_td"  style="width: 80px;">会员名称：</td>
				<td class="search_toleft_td" style="width: 160px;">
					<input type="text" id="loginName" name="loginName"/>
				</td>
				<td class="search_toright_td" style="width: 50px;">订单号：</td>
				<td class="search_toleft_td" style="width: 166px;"><input type="text" id="ordersNo" name="ordersNo" class="searchTabinput"/>&nbsp;&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:40px;">类型：</td>
				<td class="search_toleft_td" style="width:90px;">
				<select id="qbalanceType" style="width:85px" class="querySelect">
					<option value="">--请选择--</option>
					<option value="1">收入</option>
					<option value="2">支出</option>
				</select></td>
				<td class="search_toright_td" style="width:70px;">交易时间：</td>
				<td class="search_toleft_td" style="width:275px;">
					<input id="qregisterDate" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qregisterDate2\')}'})"/>
					-<input id="qregisterDate2" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qregisterDate\')}'})"/>
				</td>
				<td class="search_toleft_td">
			 		<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<form id="form1"  method="post"></form>
			<!-- 详情页 -->
			<jsp:include page="mallCoinDetail.jsp"/>
		</div>
	</div>
</body>
</html>
