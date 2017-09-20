<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>卖家未结算订单明细列表信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"订单结算明细列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/sellerSettlement/listSellerNoSettlementOrders.action?settlementId=${settlementId}",
				idField:"ordersId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"ordersNo",title:"订单号",width:120},
					{field:"finalAmount",title:"订单营业额",width:100},
					{field:"changeAmount",title:"订单财富券抵扣金额",width:120},
					{field:"rakeAmount",title:"平台抽取营业额让利金额",width:145},
					{field:"rebateAmount",title:"一级返利金额",width:130},
					{field:"secRebateAmount",title:"二级返利金额",width:130},
					{field:"thiRebateAmount",title:"三级返利金额",width:130},
					{field:"ordersState",title:"订单状态",width:150,formatter:function(value,rowData,rowIndex){
						   if(value==0){
							    return"生成订单";
						   }else if(value==3){
							    return"正在配货";
						   }else if(value==4){
							    return"已发货";
						   }else if(value==5){
							    return"完成";
						   }else if(value==6){
							    return"已取消";
						   }else if(value==7){
							    return"异常订单";
						   }else if(value==1){
							    return"<font color='#EE0000'>未付款</font>";
						   }else {
							   return"完成";
						   }
					 }
					},
					{field:"settlementStatus",title:"会员付款状态",width:150,formatter:function(value,rowData,rowIndex){
						if(value==0){
							return"未付款";
						}else if(value==1){
							return"已付款";
						}
					 }
					},
					{field:"changeAmountTotal",title:"退货返还财富券总金额",width:130},
					{field:"returnAmountTotal",title:"退货返还总金额",width:115},
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{
					text:"返回平台与卖家结算列表信息",
					iconCls:"icon-back",
					handler:function(){
						window.location.href="${pageContext.request.contextPath}/back/sellerSettlement/gotoSellerPage.action";
					}
				},"-",{
					text:"导出报表",
					iconCls:"icon-redo",
					handler:function(){
						var startTime = $("#sTime").val();
						var endTime = $("#eTime").val();
						var rowNum=$("#tt").datagrid("getRows");
						if(rowNum.length>0){
							$.ajax({
								type: "POST",
								dataType: "JSON",
								url : "${pageContext.request.contextPath}/back/sellerSettlement/importExcelSellerNoSettlementOrders.action?settlementId=${settlementId}",
								data: {startTime:startTime,endTime:endTime},
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
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit();//调用分页函数
		});
    	function query(){
   		  queryParams={startTime:$("#sTime").val(),endTime:$("#eTime").val()};
   		  $("#tt").datagrid("load",queryParams); 
   		  pageSplit(pageSize,queryParams);//调用分页函数
   	    }
    </script>
  </head>
  <body>
  		<jsp:include page="../../util/item.jsp"/>
  		 <!-- 查询框  -->
  <div class="main">
		<!-- <table class="searchTab"> -->
		<!-- <tr>
	          <td class="search_toright_td">起始日期：</td> 
	          <td class="search_toleft_td">
				<input type="text" id="sTime" onchange="mistiming()" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'eTime\')||\'2050-06-09\'}'});"/>
			  </td>
			  <td class="search_toright_td">结束日期：</td> 
			  <td class="search_toleft_td">
			     <input type="text" id="eTime" onchange="mistiming()" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sTime\')}',maxDate:'2050-06-09'});"/>
			  </td>
		      <td>
	             <a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a>
	          </td>
	       </tr> -->
		<!-- </table> <br/> -->
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			 <!-- 添加或者修改 -->
			<%-- <jsp:include page="addOrEditActor.jsp"/> --%>
		</div>
		</div>
  </body>
</html>
