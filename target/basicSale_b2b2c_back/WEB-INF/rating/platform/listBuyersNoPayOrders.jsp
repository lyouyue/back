<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>买家未结算订单明细列表信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"买家未结算订单信息列表:<font color='red'><s:property value='shopInfo.companyName'/></font>,未结算总金额:<font color='red'><s:property value='sum'/></font>元",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/buyersSettlement/listBuyersNoPayOrders.action?customerId=${customerId}",
				idField:"ordersId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"ordersNo",title:"订单号",width:120},
					{field:"finalAmount",title:"未结算金额",width:120},
					{field:"createTime",title:"订单生成时间",width:120},
					{field:"settlementStatus",title:"订单状态",width:120,formatter:function(value,rowData,rowIndex){
						if(value=="0"){
							return "未付款";
						}
					}
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{
					text:"返回平台与买家结算列表信息",
					iconCls:"icon-back",
					handler:function(){
						window.location.href="${pageContext.request.contextPath}/back/buyersSettlement/gotoBuyersPage.action";
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
  		<!-- 查询框  -->
  <div style="width: 99%">
	   <table   style="border:1px solid #99BBE8;text-align: center;" width="100%">
	       <tr>
	          <td class="toright_td">起始日期：</td> 
	          <td class="toleft_td">
				<input type="text" id="sTime" onchange="mistiming()" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'eTime\')||\'2050-06-09\'}'});"/>
			  </td>
			  <td class="toright_td">结束日期：</td> 
			  <td class="toleft_td">
			     <input type="text" id="eTime" onchange="mistiming()" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'sTime\')}',maxDate:'2050-06-09'});"/>
			  </td>
		      <td>
	             <a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a>
	          </td>
	       </tr>
	   </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			 <!-- 添加或者修改 -->
		  <%-- <jsp:include page="addOrEditActor.jsp"/> --%>
		</div>
		</div>
  </body>
</html>
