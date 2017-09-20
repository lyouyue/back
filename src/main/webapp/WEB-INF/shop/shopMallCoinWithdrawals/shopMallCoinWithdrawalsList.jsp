<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>机构金币提现信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"机构金币提现",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopMallCoinWithdrawals/listShopMallCoinWithdrawals.action",
				queryParams:{pageSize:pageSize},
				idField:"detailId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"payeeName",title:"收款人",width:50},
		            {field:"shopName",title:"机构名称",width:100},
					{field:"withdrawBL",title:"提现比例",width:50},
					{field:"serialNumber",title:"流水号",width:100},
					{field:"transactionAmount",title:"交易金额",width:50},
					{field:"state",title:"审核状态",width:70,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value == 1) return "<span class='color_003'>申请提现</span>";
							else if(value==2) return "<span class='color_001'>平台审核通过</span>";
							else if(value==3) return "<span class='color_002'>平台审核未通过</span>";
							else if(value==4) return "<span class='color_001'>平台支付完成</span>";
							else if(value==5) return "<span class='color_002'>平台支付失败</span>";
		         	  	}},
					{field:"reviewer",title:"审核人",width:50},
					{field:"tradeTime",title:"交易时间",width:100},
					{field:"reviewerDate",title:"审核时间",width:100}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[
					<%
					if("check".equals((String)functionsMap.get(purviewId+"_check"))){
					%>
				    {
					text:"审核",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择审核项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够审核一项！</p>", "warning");
						}else if(rows.length==1){
							if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
								var ids="";
								for(var i=0;i<rows.length;i++){
									if(i==rows.length-1)ids+=rows[i].detailId;
									else ids+=rows[i].detailId+",";
								}
								$("input.button_save").removeAttr("disabled");
								$("#passWin").css("display","");
								$.ajax({
									type: "POST",
									dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/shopMallCoinWithdrawals/getShopMallCoinWithdrawalsById.action",
									data: {ids:ids},
									success: function(data){
										createWindow(900,"auto","&nbsp;&nbsp;审核金币提现申请","icon-tip",false,"passWin");
										$("#detailId").val(data.detailId);
										$("#state_"+data.state).attr("checked",true);
										$("#serverMessage").val(data.serverMessage);
										var nowState;
										if(data.state==1) nowState="申请提现";
										if(data.state==2) nowState="审核通过";
										if(data.state==3) nowState="审核未通过";
										if(data.state==4) nowState="支付完成";
										if(data.state==5) nowState="支付失败";
										$("#nowState").html(nowState);
										if(data.state==1){
											document.getElementById("checktype1").style.display="";
											document.getElementById("checktype2").style.display="none";
											document.getElementById("checktype3").style.display="none";
										}else if(data.state==2){
											document.getElementById("checktype1").style.display="none";
											document.getElementById("checktype2").style.display="";
											document.getElementById("checktype3").style.display="none";
										}else{
											document.getElementById("checktype1").style.display="none";
											document.getElementById("checktype2").style.display="none";
											document.getElementById("checktype3").style.display="";
										}
									}
								});
							}
						}
					}
				},"-",
				<%
				 }
				if("export".equals((String)functionsMap.get(purviewId+"_export"))){
				%>
			    {
				text:"导出报表",
				iconCls:"icon-redo",
				handler:function(){
					window.location.href="${pageContext.request.contextPath}/back/shopMallCoinWithdrawals/exportShopMallCoinWithdrawalsExcel.action?supplierLoginName="+$("#supplierLoginName").val()+"&ordersNo="+$("#ordersNo").val()+"&createTime="+$("#qregisterDate").val()+"&endTime="+$("#qregisterDate2").val();
				}
				},"-",
				<%
				 }
				%>
				{text:"刷新",
				iconCls:"icon-reload",
				handler:function(){
					$("#tt").datagrid("reload");
					$("#tt").datagrid("clearSelections");//删除后取消所有选项
				}
			}]
		   });
			pageSplit(pageSize);//调用分页函数
		});

    	function query(){
    		$("#tt").datagrid("clearSelections");//删除后取消所有选项
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,payeeName:$("#qpayeeName").val(),serialNumber:$("#qserialNumber").val(),beginTime:$("#qregisterDate").val(),endTime:$("#qregisterDate2").val()};
			  $("#tt").datagrid("load",queryParams);
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }

		function reset(){
			$("#qpayeeName").val("");
	       	$("#qserialNumber").val("");
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
		<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:75px; ">收款人：</td>
				<td class="search_toleft_td" style="width:170px;"><input type="text" id="qpayeeName" name="qpayeeName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:55px;">流水号：</td>
				<td class="search_toleft_td" style="width:170px;"><input type="text" id="qserialNumber" name="qserialNumber" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:65px;">交易时间：</td>
				<td class="search_toleft_td" style="width: 260px;">
					<input id="qregisterDate" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qregisterDate2\')}'})"/>
					- <input id="qregisterDate2" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qregisterDate\')}'})"/>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 审核页面 -->
			<jsp:include page="isPassShopMallCoinWithdrawals.jsp"/>
		</div>
		</div>
	</body>
</html>
