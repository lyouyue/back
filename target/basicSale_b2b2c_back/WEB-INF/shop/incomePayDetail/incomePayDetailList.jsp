<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>金币提现信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"金币提现列表信息",
				iconCls:"icon-save",
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/incomePayDetail/listIncomePayDetail.action",
				queryParams:{pageSize:pageSize},
				idField:"detailId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"serialNumber",title:"流水号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.detailId+"' onclick='showDetailInfo(this.id);'>"+rowData.serialNumber+"</a>";
		         	  }
					},
					{field:"cardHolder",title:"持卡人",width:50},
					{field:"cardNumber",title:"银行卡号",width:80},
					{field:"phone",title:"预留手机号",width:80},
		            {field:"state",title:"交易状态",width:50, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		            	if(value==1) return "提现申请";
		            	if(value==2) return "平台支付完成";
		            	if(value==3) return "平台支付失败";
		         	  }
					},
					{field:"transactionAmount",title:"交易金额",width:50},
					{field:"operatorName",title:"操作人",width:50},
					{field:"operatorTime",title:"操作时间",width:80},
					{field:"createTime",title:"创建时间",width:80}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<%
				if("saveChange".equals((String)functionsMap.get(purviewId+"_saveChange"))){
				%>
				{//工具条
					text:"操作",
					iconCls:"icon-search",
					handler:function(){
						$("#form1").css("display","");
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择操作项！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>只能够操作一项！</p>", "warning");
						}else if(rows.length==1){
							//判断当前记录是否已经审核过了
							var state=rows[0].state;
							if(state==1){
								createWindow(600,'auto',"&nbsp;&nbsp;操作","icon-search",false,"addOrEditWin");
								$("#optId").val(rows[0].detailId);
								$("#state_"+rows[0].state).attr("checked","checked");
							}else{
								msgShow("系统提示", "<p class='tipInfo'>该条记录已经操作,无法修改！</p>", "warning");
							}
						}
					}
				},"-",
				<%
				  };
				if("export".equals((String)functionsMap.get(purviewId+"_export"))){
				%>
				{//工具条
					text:"导出",
					iconCls:"icon-search",
					handler:function(){
						window.location.href="${pageContext.request.contextPath}/back/incomePayDetail/exportXNBTXExcel.action?cardHolder="+$("#ccardHolder").val()+"&cardNumber="+$("#ccardNumber").val()+"&phone="+$("#cphone").val()+"&state="+$("#cstate").val();
					}
				},"-",
				<%
				  }
				%>
				{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});


    	 function query(){
			  queryParams={pageSize:pageSize,currentPage:currentPage,cardHolder:$.trim($("#ccardHolder").val()),cardNumber:$.trim($("#ccardNumber").val()),phone:$.trim($("#cphone").val()),state:$("#cstate").val()};
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
		          <td class="toleft_td">
		          	&nbsp;&nbsp;&nbsp;&nbsp;持卡人：<input id="ccardHolder" type="text"/>
		          	&nbsp;&nbsp;&nbsp;&nbsp;卡号：<input id="ccardNumber" type="text"/>
		          	&nbsp;&nbsp;&nbsp;&nbsp;预留手机：<input id="cphone" type="text"/>
		          	&nbsp;&nbsp;&nbsp;&nbsp;交易状态：
		          	<select id="cstate">
			          	<option value="">请选择</option>
			          	<option value="1">提现申请</option>
			          	<option value="2">平台支付完成</option>
			          	<option value="3">平台支付失败</option>
		          	</select>

	             	<a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a>
	          </td>
	       </tr>
	   </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditIncomePayDetail.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detailIncomePayDetail.jsp"/>
		</div></div>
  </body>
</html>
