<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>订单统计信息</title>
	<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
		$(function(){
			$("#tt").datagrid({//数据表格
				/* title:"订单统计列表",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: false,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/mallSummary/ListCollectiveOrder.action",
				idField:"ordersId",//唯一性标示字段
				columns:[[//未冻结字段
					{field:"ordersNo",title:"订单编号",width:150},
					{field:"shopName",title:"商户店铺名称",width:150},
					{field:"shopInfoType",title:"店铺类型",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value == 1){
								return "自营店铺";
							}else{
								return "入驻店铺";
							}
						}
	         		},
					{field:"loginName",title:"买家会员名称",width:100},
					{field:"consignee",title:"收货人名称",width:80},
					{field:"totalAmount",title:"商品总金额(元)",width:100},
//					{field:"membersDiscountPrice",title:"会员节省(元)",width:80},
					{field:"discount",title:"折扣",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							var info = "";
							if(value == null){
								info = "无折扣";
							}else{
								info = value;
							}
		                	return info;
						}
		         	},
					{field:"userCoin",title:"使用金币",width:100},
					{field:"changeAmount",title:"金币抵扣金额(元)",width:100},
					{field:"orderCouponAmount",title:"优惠券抵扣(元)",width:100},
					{field:"freight",title:"运费(元)",width:60},
					{field:"taxRate",title:"税率(%)",width:50},
					{field:"taxRateAmount",title:"税金(元)",width:60},
					{field:"finalAmount",title:"订单应付金额(元)",width:100},
					{field:"virtualCoinNumber",title:"赠送金币",width:100},
					{field:"createTime",title:"订单生成时间",width:110},
					{field:"payTime",title:"付款时间",width:110},
					{field:"distributionTime",title:"配货时间",width:110},
					{field:"deliversTime",title:"发货时间",width:110},
					{field:"receivesTime",title:"收货时间",width:110},
				]],
				toolbar:[//工具条
				    <%
					if("export".equals((String)functionsMap.get(purviewId+"_export"))){
					%>
				    {
					text:"导出报表",
					iconCls:"icon-redo",
					handler:function(){
						var shopName = $("#eshopName").val();
						var loginName = $("#eloginName").val();
						var consignee = $("#econsignee").val();
						var ordersState = $("#eordersState").val();
						var beginTime = $("#ebeginTime").val();
						var endTime = $("#eendTime").val();
						var rowNum=$("#tt").datagrid("getRows");
						if(rowNum.length>0){
							$.ajax({
								type: "POST",
								dataType: "JSON",
								url : "${pageContext.request.contextPath}/back/mallSummary/importExcelTJDD.action",
								data: {shopName:shopName,loginName:loginName,consignee:consignee,ordersState:ordersState,beginTime:beginTime,endTime:endTime},
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
				singleSelect:true//true只可以选中一行
			});
			pageSplit();//调用分页函数
		});

		function query(){
			$("#eshopName").val($("#qshopName").val());
			$("#eloginName").val($("#qloginName").val());
			$("#econsignee").val($("#qconsignee").val());
			$("#eordersState").val($("#qordersState").val());
			$("#ebeginTime").val($("#beginTime").val());
			$("#eendTime").val($("#endTime").val());
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopName:$("#qshopName").val(),loginName:$("#qloginName").val(),consignee:$("#qconsignee").val(),ordersState:$("#qordersState").val(),shopInfoType:$("#qshopInfoType").val(),beginTime:$("#beginTime").val(),endTime:$("#endTime").val()};
			$("#tt").datagrid("load",queryParams);
			pageSplit(pageSize,queryParams);//调用分页函数
		}

		function reset(){
			$("#qshopName").val("");
	       	$("#qloginName").val("");
	    	$("#qconsignee").val("");
	    	$("#qordersState").val("");
	    	$("#qshopInfoType").val("");
	    	$("#beginTime").val("");
	    	$("#endTime").val("");
		}
	</script>
</head>

<body>
	<jsp:include page="../../util/item.jsp"/>
	<!-- 查询框  -->
	<div class="main">
		<table   class="searchTab">
			<tr>
				<td class="search_toright_td"  style="width: 80px;">店铺名称：</td>
				<td class="search_toleft_td" style="width: 110px;"><input type="text" style="width: 93px;" id="qshopName" name="shopName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:70px;">订单状态 ：</td>
				<td class="search_toleft_td" style="width: 110px;">
					<select id="qordersState" style="width: 100px;" class="querySelect">
						<option value="-1">--全部--</option>
						<option value="1">生成订单(未付款)</option>
						<option value="2">生成订单(已付款)</option>
						<option value="3">配货</option>
						<option value="4">发货</option>
						<option value="5">已完成</option>
						<option value="6">取消订单</option>
					</select>&nbsp;&nbsp;
				</td>
				<td class="search_toright_td" style="width:60px;;">店铺类型：</td>
				<td class="search_toleft_td" style="width:100px;">
					<select id="qshopInfoType" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">自营店铺</option>
					    <option value="2">入驻店铺</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:65px;">交易日期：</td>
					<td class="toleft_td" style="width: 245px;">
					<input id="beginTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'endTime\')}'})"/>
					-<input id="endTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'beginTime\')}',maxDate:'#F{$dp.$D(\'beginTime\',{d:30})}'})"/>
					</td>
				<td></td>
				<td  class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<!-- 数据表单   -->
		<table id="tt">
			<input type="hidden" name="eshopName" id="eshopName" value="">
			<input type="hidden" name="eloginName" id="eloginName" value="">
			<input type="hidden" name="econsignee" id="econsignee" value="">
			<input type="hidden" name="eordersState" id="eordersState" value="">
			<input type="hidden" name="ebeginTime" id="ebeginTime" value="">
			<input type="hidden" name="eendTime" id="eendTime" value="">
		</table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;"></div>
	</div>
</body>
</html>
