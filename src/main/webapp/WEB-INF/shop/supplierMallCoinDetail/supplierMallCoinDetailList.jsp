<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>机构金币明细信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"机构金币收支明细列表信息",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/supplierMallCoinDetail/listSupplierMallCoinDetail.action",
				queryParams:{pageSize:pageSize},
				idField:"supplierMallCoinDetailId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"supplierLoginName",title:"机构账号",width:120},
					{field:"shopName",title:"机构名称",width:120},
					{field:"loginName",title:"购买会员名称",width:120},
					{field:"ordersNo",title:"订单号",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                if(value!=null&&value!="") return value;
		                else return "无";
		         	  }
					},
					{field:"type",title:"交易类型",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                if(value==1) return "收入";
		                if(value==2) return "支出";
		                if(value==3) return "提现";
		                if(value==4) return "提现失败";
		         	  }  },
					{field:"tradMallCoin",title:"交易金币",width:80},
					{field:"totalInPut",title:"总收入",width:80},
					{field:"totalOutPut",title:"总支出",width:80},
					{field:"tradingTime",title:"交易时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[//工具条
				    <%
					if("export".equals((String)functionsMap.get(purviewId+"_export"))){
					%>      
					{
						text:"导出报表",
			 			iconCls:"icon-redo",
						handler:function(){
							window.location.href="${pageContext.request.contextPath}/back/supplierMallCoinDetail/exportSupplierMallCoinExcel.action?loginName="+$("#supplierLoginName").val()+"&ordersNo="+$("#ordersNo").val()+"&createTime="+$("#qregisterDate").val()+"&endTime="+$("#qregisterDate2").val();
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
    		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,supplierLoginName:$("#supplierLoginName").val(),ordersNo:$("#ordersNo").val(),registerDate:$("#qregisterDate").val(),registerDate2:$("#qregisterDate2").val(),shopName:$("#qshopName").val()};
    	  	$("#tt").datagrid("load",queryParams);
    	  	pageSplit(pageSize,queryParams);//调用分页函数
        }

		function reset(){
			$("#supplierLoginName").val("");
	       	$("#ordersNo").val("");
	    	$("#qregisterDate").val("");
	    	$("#qregisterDate2").val("");
	    	$("#qshopName").val("");
		};
    </script>
    <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  </head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
		<div class="main">
			<table class="searchTab">
				<tr>
					<td class="search_toright_td"  style="width:70px;">机构账号：</td>
					<td class="search_toleft_td"  style="width:140px;"><input type="text" id="supplierLoginName" name="supplierLoginName" style="width:120px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
					<td class="search_toright_td" style="width:70px;">机构名称：</td>
					<td class="search_toleft_td" style="width:140px;"><input type="text" id="qshopName" name="shopName" style="width:120px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
					<td class="search_toright_td" style="width:60px;">订单号：</td>
					<td class="search_toleft_td" style="width:140px;"><input type="text" id="ordersNo" name="ordersNo" style="width:120px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
					<td class="search_toright_td" style="width:70px;">交易时间：</td>
					<td class="search_toleft_td" style="width:245px;">
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
			</div>
		</div>
	</body>
</html>
