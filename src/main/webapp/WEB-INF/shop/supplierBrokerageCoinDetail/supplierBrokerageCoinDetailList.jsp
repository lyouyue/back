<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>机构金币信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"机构金币收支明细列表信息",
				iconCls:"icon-save",
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/supplierBrokerageCoinDetail/listSupplierBrokerageCoinDetail.action",
				queryParams:{pageSize:pageSize},
				idField:"supplierBrokerageCoinDetailId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"supplierLoginName",title:"机构登录名",width:80},
					{field:"ordersNo",title:"订单号",width:120},
					{field:"giveBrokerageCoin",title:"赠送金币",width:120},
					{field:"totalOutPut",title:"总支出",width:120},
					{field:"tradingTime",title:"交易时间",width:120}


				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[
					{//工具条
						text:"导出报表",
						iconCls:"icon-redo",
						handler:function(){
							window.location.href="${pageContext.request.contextPath}/back/supplierBrokerageCoinDetail/exportSupplierBrokerageCoinExcel.action?supplierLoginName="+$("#supplierLoginName").val()+"&ordersNo="+$("#ordersNo").val()+"&createTime="+$("#qregisterDate").val()+"&endTime="+$("#qregisterDate2").val();
						}
					},"-",{text:"刷新",
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
    		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,supplierLoginName:$("#supplierLoginName").val(),ordersNo:$("#ordersNo").val(),registerDate:$("#qregisterDate").val(),registerDate2:$("#qregisterDate2").val()};
    	  	$("#tt").datagrid("load",queryParams);
    	  	pageSplit(pageSize,queryParams);//调用分页函数
        }
    </script>
    <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  </head>
  <body>
		<table style="border:1px solid #99BBE8;text-align: center;" width="100%">
	  		<tr>
	    		<td class="toright_td">机构登录名 ：</td>
	    		<td class="toleft_td"><input type="text" id="supplierLoginName" name="supplierLoginName" />&nbsp;&nbsp;</td>
	    		<td class="toright_td">订单号 ：</td>
	    		<td class="toleft_td"><input type="text" id="ordersNo" name="ordersNo" />&nbsp;&nbsp;</td>
	    		<td>交易时间：<input type="text" id="qregisterDate" name="registerDate" readonly="readonly" onclick="WdatePicker({el:'qregisterDate',dateFmt:'yyyy-MM-dd'})" />
				   - <input type="text" id="qregisterDate2" name="registerDate2" readonly="readonly" onclick="WdatePicker({el:'qregisterDate2',dateFmt:'yyyy-MM-dd'})" />
				  </td>
	    		<td><a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a></td>

	    	</tr>

	    </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		</div>
  </body>
</html>
