<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>退货申请信息</title>
    <jsp:include page="../../util/import.jsp"/>
     <!-- kindEdite -->
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
	<!-- kindEdite end-->
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"退换申请列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/returnsApply/listReturnsApply.action",
				queryParams:{pageSize:pageSize},
				idField:"returnsApplyId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"returnsApplyNo",title:"退货申请编号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.returnsApplyNo+"' onclick='showDetailInfo(this.id);'>"+rowData.returnsApplyNo+"</a>";  
		         	  }  
					}, 
					{field:"productName",title:"套餐名称",width:120},
					{field:"loginName",title:"会员名称",width:120},
					{field:"shopName",title:"机构名称",width:120},
					{field:"shopInfoType",title:"机构类型",width:80,formatter:function(value,rowData,rowIndex){
						   if(value==1){
							    return"自营店铺";
						   }else if(value==2){
							    return"入驻店铺";
						   }
					 }
					},
					{field:"applyState",title:"审核状态",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font class='color_003'>处理中</font>";} 
	                        if(value=="2"){ return "<font class='color_001'>同意</font>";} 
	                        if(value=="3"){ return "<font class='color_002'>不同意</font>";} 
                            }
                 	},
					{field:"returnsState",title:"退货状态",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "退货中";} 
	                        if(value=="2"){ return "退货完成";} 
	                        if(value=="3"){ return "退款中";} 
	                        if(value=="4"){ return "退款完成";} 
	                        if(value=="5"){ return "订单处理完成";} 
                        }
                 	},
                 	{field:"applyTime",title:"申请时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
				if("lookLog".equals((String)functionsMap.get(purviewId+"_lookLog"))){
				%>         
	            {//工具条
				//查看退货明细
				text:"查看退货申请明细", 
				iconCls:"icon-search",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能选择一项！</p>", "warning");
					}else if(rows.length==1){
						createWindow(750,300,"&nbsp;&nbsp;退货明细","icon-tip",false,"detailOPLogWin");
						$("#addOrEditorWin").css("display","none");
						$("#reviewWin").css("display","none");
						$("#detailWin").css("display","none");
						$("#detailOPLogWin").css("display","");
						$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/returnsApply/getReturnsApplyOPLogList.action",
						   data: {returnsApplyId:rows[0].returnsApplyNo},
						   success: function(data){
							   if(data != null){
								var strHtml = "<tr><td align='center' style='font-weight:bold'>操作时间</td><td align='center' style='font-weight:bold'>操作人</td><td align='center' style='font-weight:bold'>内容</td></tr>";
							   	$(data).each(function(i){
							   	   strHtml+="<tr><td align='center' >"+this.operatorTime+"</td><td align='center'>"+this.operatorName+"</td><td align='center'>"+this.comments+"</td></tr>";
								});
							   	$("#detailOPLogWinHtml").html(strHtml);
							   }
						   }
						});
					}
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
		 function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,500,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditorWin");
				$("#addOrEditorWin").css("display","");
				$("#reviewWin").css("display","none");
				$("#detailWin").css("display","none");
				$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/returnsApply/getReturnsApplyObject.action",
				   data: {returnsApplyId:id},
				   success: function(data){
					   $("#returnsApplyId").val(data.returnsApplyId);
					   $("#ereturnsApplyNo").val(data.returnsApplyNo);
					   $("#ecustomerId").val(data.customerId);
					   $("#customerId").val(data.customerId);
					   $("#customerId").attr("disabled","disabled");
					   $("#eordersId").val(data.ordersId);
					   $("#eordersNo").val(data.ordersNo);
					   $("#ordersListHtml").html(data.ordersNo);
					   $("#eproductId").val(data.productId);
					   $("#eproductName").val(data.productFullName);
					   $("#ordersListListHtml").html(data.productFullName);
					   $("#disposeMode_"+data.disposeMode).attr("checked",true);
					   if(data.disposeMode=="2"){
						   $("#div1").css("display","none");
					   }else{
						   $("#div1").css("display","");
					   }
					   $("#problemDescription").val(data.problemDescription);
					   //KindEditor修改赋值
					   KindEditor.instance[0].html(data.problemDescription);  
					   $("#tradeDress").val(data.tradeDress);
					   $("#commodityPackaging").val(data.commodityPackaging);
					   if(data.repairCredentials=="0"){
						   $("#repairCredentials").attr("checked",true);
					   }
					   $("#edproductAccessories").val(data.productAccessories);
					   $("#ddproductAccessories").html(data.productAccessories);
					   $("#returnsMode_"+data.returnsMode).attr("checked",true);
					   $("#edshippingAddress").val(data.shippingAddress);
					   $("#linkman").val(data.linkman);
					   $("#mobilePhone").val(data.mobilePhone);
					   $("#applyTime").val(data.applyTime);
				   }
				});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/returnsApply/deleteReturnsApply.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
				});
    		}
    	}
		 
		 function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,thno:$("#thno").val(),sqStatus:$("#sqStatus").val(),thStatus:$("#thStatus").val(),shopInfoType:$("#qshopInfoType").val()};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
		}

		function reset(){
			$("#thno").val("");
	       	$("#sqStatus").val("");
	    	$("#thStatus").val("");
	    	$("#qshopInfoType").val("");
		}
    </script>
  </head>
  
	<body>
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:120px;">退货申请编号：</td>
				<td class="search_toleft_td" style="width: 140px;">
					<input id="thno" type="text" style="width:120px"class="searchTabinput"/>
				</td>
					<td  align="right" style="width:70px;;">机构类型：</td>
				<td  align="left" style="width:80px;">
					<select id="qshopInfoType" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">自营店铺</option>
						<option value="2">入驻店铺</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:75px;">审核状态：</td>
				<td class="search_toleft_td" style="width:130px;">
					<select id="sqStatus" style="width:120px" class="querySelect">
							<option value="-1">--请选择--</option>
							<option value="1">处理中</option>
							<option value="2">同意</option>
							<option value="3">不同意</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:80px;">退货状态：</td>
				<td class="search_toleft_td" style="width:150px;">
					<select id="thStatus" style="width:120px" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="1">退货中</option>
						<option value="2">退货完成</option>
						<option value="3">退款中</option>
						<option value="4">退款完成</option>
						<option value="5">订单处理完成</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
		<!-- 添加或者修改 -->
		<jsp:include page="addOrEditor.jsp"/>
		<!-- 审核 -->
		<jsp:include page="review.jsp"/>
		<!-- 详情页 -->
		<jsp:include page="detail.jsp"/>
		<!-- 退货操作明细 -->
		<div id="detailOPLogWin">
			<table id="detailOPLogWinHtml" align="center" class="addOrEditTable" style="width:700px;"></table>
		</div>
		</div>
		</div>
	</body>
</html>
