<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员等级信息</title>
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="-1"/>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
	 <link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script> 
	<script type="text/javascript">
    $(function(){
    	$("#tt").datagrid({//数据表格
				/* title:"买家会员列表信息",
				iconCls:"icon-save",  */
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/buyersRecord/listBRCustomer.action", 
			idField:"customerId",//唯一性标示字段
			frozenColumns:[[//冻结字段
			    {field:"ck",checkbox:true}
			]],
			columns:[[//未冻结字段
				{field:"loginName",title:"名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return "<a style='display:block;' id='"+rowData.ratingRecordId+"' onclick='showDetailInfo(this.id);'>"+rowData.loginName+"</a>";  
					}
				}, 
				{field:"phone",title:"电话",width:100},
				{field:"buyersLevel",title:"买家等级",width:80}, 
				{field:"buyerRank",title:"买家头衔",width:120},
				
				{field:"levelIcon",title:"等级图标",width:120,
					formatter:function(value,rowData,rowIndex){
						return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'/>";
					}
				},
				 {field:"minRefValue",title:"最小参考值",width:100},
					{field:"maxRefValue",title:"最大参考值",width:100},
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号   
			singleSelect:true,//true只可以选中一行
			toolbar:[
				<%
				if("uplevel".equals((String)functionsMap.get(purviewId+"_uplevel"))){
				%>
				{
					text:"等级升迁",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
						createWindow(800,430,"&nbsp;&nbsp;会员等级升迁","icon-add",false,"addOrEditWin");
						$("#id1").val("");
						$(".ke-icon-fullscreen").click();
						$(".ke-icon-fullscreen").click();
						$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/buyersRecord/getByersRecord.action",
							   data: {customerId:rows[0].customerId},
							   success: function(data){
								   $("#customerId").val(data.buyersRecord.customerId);
								   $("#dbuyersLevel").val(data.buyersRecord.buyersLevel);
								   $("#remark").val(data.buyersRecord.remark);
								   $("#level_"+data.buyersRecord.buyersLevel).attr("checked",true);
							   }
							});
						}
					}
				},"-",
			<% 
			}
			if("maintain".equals((String)functionsMap.get(purviewId+"_maintain"))){
			%>
				{//工具条
				text:"查看升迁记录",
				iconCls:"icon-search",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
					}else if(rows.length==1){
						location.href="${pageContext.request.contextPath}/back/buyersRecord/gotoBuyersRecordId.action?customerId="+rows[0].customerId;
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
			pageSplit(pageSize);//调用分页函数
        });  
    
 	 	function query(){
 	  	  	queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,loginName:$("#qloginName").val(),phone:$("#qphone").val(),email:$("#qemail").val(),type:$("#qtype").val()};
 	  	  	$("#tt").datagrid("load",queryParams); 
 	  	  	pageSplit(pageSize,queryParams);//调用分页函数
       	}
 	 	function reset(){
 	 		$("#qloginName").val("");
			$("#qemail").val("");
			$("#qphone").val("");
			$("#qtype").val("");
 	 	}
 	 	/**
 	 	 * 将数值四舍五入(保留2位小数)后格式化成金额形式
 	 	 *
 	 	 * @param num 数值(Number或者String)
 	 	 * @return 金额格式的字符串,如'1,234,567.45'
 	 	 * @type String
 	 	 */
 	 	function formatCurrency(num) {
 	 	    num = num.toString().replace(/\$|\,/g,'');
 	 	    if(isNaN(num))
 	 	    num = "0";
 	 	    sign = (num == (num = Math.abs(num)));
 	 	    num = Math.floor(num*100+0.50000000001);
 	 	    cents = num%100;
 	 	    num = Math.floor(num/100).toString();
 	 	    if(cents<10)
 	 	    cents = "0" + cents;
 	 	    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
 	 	    num = num.substring(0,num.length-(4*i+3))+','+
 	 	    num.substring(num.length-(4*i+3));
 	 	    return (((sign)?'':'-') + num + '.' + cents);
 	 	}
 	 //详情
		function showDetailInfo(id){
			createWindow(700,'370',"&nbsp;&nbsp;会员等级详情","icon-tip",false,"detailWin");
			$("#detailWin").css("display","");
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/back/buyersRecord/getBuyersRecordObject.action",
				data: {ratingRecordId:id},
				dataType: "JSON",
				success: function(data){
					var buyersRecord=data.buyersRecord;
					var customer=data.customer;
					$("#dloginName").html(customer.loginName);
					$("#dphone").html(customer.phone);
					$("#ddbuyersLevel").html(buyersRecord.buyersLevel);
					$("#dbuyerRank").html(buyersRecord.buyerRank);
					$("#dlevelIcon").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+buyersRecord.levelIcon+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'/>");
					$("#dremark").html(buyersRecord.remark);
					$("#doptionDate").html(buyersRecord.optionDate);
					$("#dminRefValue").html(buyersRecord.minRefValue);
					$("#dmaxRefValue").html(buyersRecord.maxRefValue);
					$("#doperator").html(buyersRecord.operator);
					$("#dlineOfCredit").html(buyersRecord.lineOfCredit);
					$("#dcreditDate").html(buyersRecord.creditDate);
				}
			});
    	}
    </script>
  </head>
  <body>
  <jsp:include page="../../util/item.jsp"/>
  <div class="main">
  		<table class="searchTab">
			<tr>
				<td class="search_toright_td"   style="width:80px;">登录名称：</td>
				<td class="search_toleft_td" style="width:155px;"><input type="text" id="qloginName" name="loginName" /></td>
				<td class="search_toright_td" style="width: 55px;">手机号：</td>
				<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qphone" name="phone" /></td>
				<td class="search_toleft_td">
				  <a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
	           		<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
  		 <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditBuyersRecord.jsp"/>
  		 <!-- 详情页 -->
		  <jsp:include page="detailBuyersRecord.jsp"/>
		</div>
		</div>
  </body>
</html>
