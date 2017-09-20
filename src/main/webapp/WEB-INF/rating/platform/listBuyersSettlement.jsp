<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>平台与买家结算列表信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"平台与买家结算列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/buyersSettlement/listBuyersSettlement.action",
				idField:"customerId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"companyName",title:"公司名称",width:120},
					{field:"openingBank",title:"开户行",width:120},
					{field:"bankAccountNumber",title:"帐号",width:120},
					{field:"phoneForInvoice",title:"电话",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{
					text:"查看未结算订单",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							window.location.href="${pageContext.request.contextPath}/back/buyersSettlement/gotoBuyersOrders.action?customerId="+rows[0].customerId;
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
   		  queryParams={companyName:$("#qcompanyName").val()};
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
		      <td class="toleft_td">&nbsp;&nbsp;&nbsp;&nbsp;公司名称：
		      	 <input type="text" id="qcompanyName"/>
	             <a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a>
	          </td>
	           
	       </tr>
	   </table>
  		<table id="tt"></table>
		</div>
  </body>
</html>
