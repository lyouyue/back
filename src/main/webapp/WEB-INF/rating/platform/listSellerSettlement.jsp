<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>平台与店铺结算信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"卖家申请结算列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/sellerSettlement/listSellerSettlement.action",
				idField:"settlementId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段createDate
					{field:"companyName",title:"公司名称",width:120},
					{field:"shopName",title:"店铺名称",width:110},
					{field:"totalCost",title:"申请结算总额(元)",width:100},
					{field:"rakeCost",title:"平台抽佣总额(元)",width:100},
					{field:"commissionProportion",title:"平台抽佣比例",width:100},
					{field:"finaltTotalCost",title:"实际结算总额(元)",width:100},
					{field:"rebateAmount",title:"抽佣返利金额(元)",width:100},
					{field:"status",title:"结算状态",width:60,formatter:function(value,rowData,rowIndex){  
					   if(value=="1"){
						   return "<font class='color_003'>待审核</font>";
					   }else if(value=="2"){
						   return "<font class='color_001'>审核通过</font>";
					   }else if(value=="3"){
						   return "<font class='color_002'>审核未通过</font>";
					   }else{
						   return "<font class='color_004'>已结算</font>";
					   }
				   }
				   },
		           {field:"createDate",title:"申请日期",width:100},
			       {field:"toPay",title:"操作",width:50,formatter:function(value,rowData,rowIndex){  
			    	   if(rowData.status=="4"){//已结算
				    	   return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font class='color_004'>-&nbsp;-</font>";
					   }else if(rowData.status=="2"){//审核通过
				    	   return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:paymentInfo("+rowData.settlementId+","+rowData.status+");'>付款</a>";
					   }else{
				    	   return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a  href='javascript:check("+rowData.settlementId+","+rowData.status+");'>审核</a>";
					   }
				   }
			       }
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<%
				if("settleDetail".equals((String)functionsMap.get(purviewId+"_settleDetail"))){
				%>     
				    {
					text:"查看结算明细",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							window.location.href="${pageContext.request.contextPath}/back/sellerSettlement/gotoSellerOrders.action?settlementId="+rows[0].settlementId;
						}
					}
				},"-",
				<%
				}
				if("settlement".equals((String)functionsMap.get(purviewId+"_settlement"))){
				%>
				{
					text:"查看结算说明",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							$("#paymentInfoWin").attr("style","display: none;");
				    		$("#checkWin").attr("style","display: none;");
				    		$("#paymentInfoWin2").attr("style","display: display;");
							createWindow(600,'auto',"&nbsp;&nbsp;备注信息","icon-tip",false,"paymentInfoWin2");
							$.post("${pageContext.request.contextPath}/back/sellerSettlement/getOneObject.action",{settlementId:rows[0].settlementId},function(data){
								if(data){
									$("#paymentInfo2").val(data.paymentInfo);
								}
							},'json');
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
						var startTime = $("#sTime").val();
						var endTime = $("#eTime").val();
						var status = $("#qstatus").val();
						var rowNum=$("#tt").datagrid("getRows");
						if(rowNum.length>0){
							$.ajax({
								type: "POST",
								dataType: "JSON",
								url : "${pageContext.request.contextPath}/back/sellerSettlement/importExcelSellerSettlement.action",
								data: {startTime:startTime,endTime:endTime,status:status},
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
				}
				]
			});
			pageSplit();//调用分页函数
		});
    	function query(){
   		 // queryParams={companyName:$("#qcompanyName").val()};
   		  queryParams={startTime:$("#sTime").val(),endTime:$("#eTime").val(),status:$("#qstatus").val(),shopName:$("#qshopName").val()};
   		  $("#tt").datagrid("load",queryParams); 
   		  pageSplit(pageSize,queryParams);//调用分页函数
   	    }

		function reset(){
			$("#sTime").val("");
	       	$("#eTime").val("");
	    	$("#qstatus").val("");
	    	$("#qshopName").val("");
		}
    	//审核操作
    	function check(settlementId,status){
    		if(status!=1&&status!=3){
    			msgShow("系统提示", "<p class='tipInfo'>该记录已完成不能操作！</p>", "warning");  
    		}else{
	    		$("#paymentInfoWin").attr("style","display: none;");
	    		$("#paymentInfoWin2").attr("style","display: none;");
	    		$("#checkWin").attr("style","display: display;");
	    		createWindow(700,'auto',"&nbsp;&nbsp;审核","icon-tip",false,"checkWin");
	    		$("#status_"+status).attr("checked","checked");
	    		$("#settlementIdHid").val(settlementId);
	    		if(status!=1){
	    			//$('input[name="check"]').attr("disabled","disabled");
	    			$('#status_1').attr("disabled","disabled");
	    		}else{
	    			//$('input[name="check"]').removeAttr("disabled","disabled");
	    			$('#status_1').removeAttr("disabled","disabled");
	    		}
    		}
    	}
    	//付款操作
    	function paymentInfo(settlementId,status){
    		$("#paymentInfoError").html("");
    		if(status!=2){
    			if(status==4){
	    			msgShow("系统提示", "<p class='tipInfo'>该记录已结算，无法操作！</p>", "warning");  
    			}else{
	    			msgShow("系统提示", "<p class='tipInfo'>该记录尚未通过审核！</p>", "warning");  
    			}
    		}else{
	    		$("#checkWin").attr("style","display: none;");
	    		$("#paymentInfoWin").attr("style","display: display;");
	    		$("#paymentInfoWin2").attr("style","display: none;");
	    		$("#status_"+status).attr("checked","checked");
	    		createWindow(600,250,"&nbsp;&nbsp;付款信息","icon-tip",false,"paymentInfoWin");
	    		$("#settlementIdHid").val(settlementId);
    		}
    	}
    	
    	//提交审核结果或付款结果，flag值：0审核，1付款
    	function tijiao(flag){
    		if(flag==1){
    			var paymentInfo = $("#paymentInfo").val();
    			if($.trim(paymentInfo)==""||$.trim(paymentInfo)==null){
    				$("#paymentInfoError").html("<font color='red'>不可为空</font>");
    				 return false;	
    			}else if(paymentInfo.length>2000){
    				$("#paymentInfoError").html("<font color='red'>支付信息不能超过2000个字符！</font>");
    				 return false;	
    			}
    		}
    		$("#paymentInfoError").html("");
    		var v=$('input[name="check"]:checked').val();
    		var settlementId=$("#settlementIdHid").val();
    		$.post("${pageContext.request.contextPath}/back/sellerSettlement/check.action",{checkParams:v,settlementId:settlementId,paymentInfo:$("#paymentInfo").val()},function(data){
    			if(data.isSuccess){
    				 closeWin();
                	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
    			}
    		},'json');
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
				<td class="search_toleft_td" style="width: 135px;">
					<input type="text" id="qshopName"  name="shopName" class="searchTabinput" style="width: 120px"/>
				</td>
				<td class="search_toright_td" style="width: 80px;">申请日期：</td> 
				<td class="search_toleft_td" style="width: 280px;">
					<input id="sTime" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'eTime\')}'})"/>
					- <input id="eTime" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'sTime\')}'})"/>
				</td> 
				<td class="search_toright_td" style="width: 75px;">审核状态：</td>
				<td class="search_toleft_td" style="width: 120px;">
					<select id="qstatus" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="1">待审核</option>
						<option value="2">已通过</option>
						<option value="3">未通过</option>
						<option value="4">已结算</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 添加或者修改 -->
				<jsp:include page="check.jsp"/>
			</div>
		</div>
	</body>
</html>
