<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>促销活动信息</title>
    <jsp:include page="../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
     	<!-- kindEdite -->
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
		<!-- kindEdite end-->
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"平台管理促销活动列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/promotion/listPromotion.action",
				queryParams:{pageSize:pageSize},
				idField:"promotionId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"subject",title:"活动主题",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.promotionId+"' onclick='showDetailInfo(this.id);'>"+rowData.promotionName+"</a>";  
		         	  }
					}, 
					{field:"promotionNumber",title:"促销活动编号",width:90},
					{field:"useStatus",title:"启用状态",width:50, 
				    	formatter:function(value,rowData,rowIndex){//function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_003'>未开启</font>";}
	                        if(value=="1"){ return "<font class='color_001'>已开启</font>";}
	                        if(value=="2"){ return "<font class='color_002'>已结束</font>";}
                            }
                 	},
					{field:"isPass",title:"审核状态",width:50,
				    	formatter:function(value,rowData,rowIndex){//function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font class='color_003'>待审核</font>";}
	                        if(value=="2"){ return "<font class='color_001'>审核通过</font>";}
	                        if(value=="3"){ return "<font class='color_002'>审核不通过</font>";}
                            }
                 	},
                 	{field:"beginTime",title:"开始时间",width:90},
					{field:"endTime",title:"结束时间",width:90}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
		         <% 
				if("add".equals((String)functionsMap.get(purviewId+"_add"))){
				%> 
				{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(1000,450,"&nbsp;&nbsp;添加促销活动","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#checkPromotionWin").css("display","none");
						$("#promotionDiscountWin").css("display","none");
						$("#bigCard").html("");
						$("#smallCard").html("");
						$("#content").html("");
						$("#promotionId").val(null);
						$("#fileId1").val("");
						$("#fileId2").val("");
						$("#photo1").html("");
						$("#photo2").html("");
						$("#imageUrl1").val("");
						$("#imageUrl2").val("");
						$("#mymessage1").html("");
						$("#mymessage2").html("");
					    $("#beginTime").val(null);
					    $("#endTime").val(null);
					    $("#sendTime").html("");
					    $(".ke-icon-fullscreen").click();
						$(".ke-icon-fullscreen").click();
					    //KindEditor添加清空
						//KindEditor.instances[0].html('');
						editor.html("");
					}
				},"-",
				<%
				 }
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var myDate = CurentTime();
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>只能修改一项！</p>", "warning");
						}else{
						if(rows[0].beginTime>myDate){
								$("#fileId1").val("");
								$("#fileId2").val("");	
								createWindow(1000,450,"&nbsp;&nbsp;修改促销活动","icon-edit",false,"addOrEditWin");
								$("#addOrEditWin").css("display","");
								$("#detailWin").css("display","none");
								$("#checkPromotionWin").css("display","none");
								$("#promotionDiscountWin").css("display","none");
								$(".ke-icon-fullscreen").click();
								$(".ke-icon-fullscreen").click();
								$.ajax({
									type: "POST", dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/promotion/getPromotionObject.action",
									data: {promotionId:rows[0].promotionId},
									success: function(data){
										$("#promotionId").val(data.promotionId);
										$("#promotionName").val(data.promotionName);
										$("#shopPromotionInfo").val(data.shopPromotionInfo);
										$("#promotionNumber").val(data.promotionNumber);
										$("#isPass").val(data.isPass);
										$("#createTime").val(data.createTime);
										$("#shopPromotionInfo").val(data.shopPromotionInfo);
										$("#beginTime").val(data.beginTime);
										$("#endTime").val(data.endTime);
										$("#useStatus").val(data.useStatus);
										$("#imageUrl2").val(data.smallPoster);
										$("#photo2").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.smallPoster+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
										$("#imageUrl1").val(data.largePoster);
										$("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.largePoster+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='50px' height='50px' />");
										//KindEditor修改赋值
										//KindEditor.instances[0].html(data.shopPromotionInfo);
										//KindEditor.html("#shopPromotionInfo",data.shopPromotionInfo);
										editor.html(data.shopPromotionInfo);
									}
								});
							}else{
								msgShow("系统提示", "<p class='tipInfo'>活动已过开始时间，不能修改！</p>", "warning");
							}
						}
					}
				},"-",
				<%
				 }
				if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
				%>
				{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
									    var status="";
										for(var i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].promotionId;
											else ids+=rows[i].promotionId+",";
										}
											for(var j=0;j<rows.length;j++){
												if(j==rows.length-1)status+=rows[j].isPass;
												else status+=rows[j].isPass+",";
											}
											if(status.indexOf("2")!=-1){
												msgShow("系统提示", "<p class='tipInfo'>审核通过的记录，不能删除！</p>", "warning");
											}else{
										 		$.ajax({
												   type: "POST",dataType: "JSON",
												   url: "${pageContext.request.contextPath}/back/promotion/deletePromotion.action",
												   data: {ids:ids},
												   success: function(data){
													   if(data.isSuccess=="false")msgShow("系统提示", "<p class='tipInfo'>审核通过的记录，不能删除！</p>", "warning");
													   $("#tt").datagrid("clearSelections");//删除后取消所有选项
													   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
												   }
												});
										}
									}
								}
							});
						}
					}
				},"-",
				<%
				 }
				if("checkPromotion".equals((String)functionsMap.get(purviewId+"_checkPromotion"))){
				%>
				{
					text:"审核促销活动",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择促销活动！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							if(rows[0].useStatus==1){
								msgShow("系统提示", "<p class='tipInfo'>已开启的活动不能再次审核！</p>", "warning");  
							}else{
								createWindow("auto","auto","&nbsp;&nbsp;审核促销活动","icon-tip",false,"addOrEditWin");
								$("#addOrEditWin").css("display","none");
								$("#detailWin").css("display","none");
								$("#checkPromotionWin").css("display","");
								$("#promotionDiscountWin").css("display","none");
								$.ajax({
									type: "POST", dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/promotion/getPromotionObject.action",
									data: {promotionId:rows[0].promotionId},
									success: function(data){
										$("#check_promotionId").val(data.promotionId);
										$("#isPass_"+data.isPass).attr("checked",true);
									}
								});
							}
						}
					}
				},"-",
				<%
				 }
				if("checkProduct".equals((String)functionsMap.get(purviewId+"_checkProduct"))){
				%>
				{
					text:"审核申请套餐",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择促销活动！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							location.href="${pageContext.request.contextPath}/back/disproduct/gotoProductListByPromotionIdPage.action?promotionId="+rows[0].promotionId;
						}
					}
				},"-",
		  <%--  <%
		   }
		   if("showProduct".equals((String)functionsMap.get(purviewId+"_showProduct"))){
		   %>
		   {
					text:"查看促销套餐",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							$.messager.alert("提示","请选择促销活动"); 
						}if(rows.length>1){//超过了一个选择项
							$.messager.alert("提示","只能够选择一项");
						}else if(rows.length==1){
							window.open("${pageContext.request.contextPath}/front/store/salesPromotionCenter/gotoSalesPromotionCenter.action?promotionId="+rows[0].promotionId);
// 							location.href="${pageContext.request.contextPath}/front/store/salesPromotionCenter/gotoSalesPromotionCenter.action?promotionId="+rows[0].promotionId;
						}
					}
				}
			   ,"-", --%>
				<%
				 }
				if("promotionDiscount".equals((String)functionsMap.get(purviewId+"_promotionDiscount"))){
				%>
				{
					text:"维护活动折扣",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择促销活动！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							if(rows[0].isPass==2){
								msgShow("系统提示", "<p class='tipInfo'>已通过审核的活动不能维护折扣！</p>", "warning");  
							}else{
								createWindow(450,150,"&nbsp;&nbsp;维护活动折扣","icon-edit",false,"promotionDiscountWin");
								$("#addOrEditWin").css("display","none");
								$("#detailWin").css("display","none");
								$("#checkPromotionWin").css("display","none");
								$("#promotionDiscountWin").css("display","");
								$.ajax({
									type: "POST",dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/promotion/getSalesPromotionDiscountObject.action",
									data: {promotionId:rows[0].promotionId},
									success: function(data){
										if(data!=null){
											$("#sales_disproductId").val(data.disproductId);
											$("#sales_promotionId").val(data.promotionId);
											$("#sales_promotionIdNumber").val(data.promotionIdNumber);
											$("#sales_discount").val(data.discount);
										}else{
											$("#sales_disproductId").val("");
											$("#sales_promotionId").val(rows[0].promotionId);
										}
									}
								});
							}
						}
					}
				},"-",
			   <%
				 }
				if("openPromotion".equals((String)functionsMap.get(purviewId+"_openPromotion"))){
				%>
				{
					text:"开启活动",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择促销活动！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							 if(rows[0].isPass==2){//审核通过 
								$.ajax({
									type: "POST",dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/promotion/openPlatformPromotion.action",
									data: {promotionId:rows[0].promotionId},
									success: function(data){
										if(data.isSuccess=="true"){
											msgShow("系统提示", "<p class='tipInfo'>成功开启！</p>", "warning");  
											$("#tt").datagrid("clearSelections");//删除后取消所有选项
											$("#tt").datagrid("reload"); //删除后重新加载列表
										}else if(data.isSuccess=="early"){
											msgShow("系统提示", "<p class='tipInfo'>未到活动时间！</p>", "warning");  
										}else if(data.isSuccess=="hasOpen"){
											msgShow("系统提示", "<p class='tipInfo'>活动已开启！</p>", "warning");  
										}else{
											msgShow("系统提示", "<p class='tipInfo'>开启失败！</p>", "warning");  
										}
									}
								});
							 }else if(rows[0].isPass==3){//审核不通过
								msgShow("系统提示", "<p class='tipInfo'>该活动未通过审核！</p>", "warning");  
							}else if(rows[0].isPass==1){//待审核状态
								msgShow("系统提示", "<p class='tipInfo'>该活动处于待审核状态！</p>", "warning");  
							} 
						}
					}
				}
			   ,"-",
			   <%
				 }
				if("closePromotion".equals((String)functionsMap.get(purviewId+"_closePromotion"))){
				%>
				{
					text:"关闭活动",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择促销活动！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							if(rows[0].useStatus==1){
								$.ajax({
									type: "POST",dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/promotion/closePlatformPromotion.action",
									data: {promotionId:rows[0].promotionId},
									success: function(data){
										if(data.isSuccess=="true"){
											msgShow("系统提示", "<p class='tipInfo'>成功关闭！</p>", "warning");  
											$("#tt").datagrid("clearSelections");//删除后取消所有选项
											$("#tt").datagrid("reload"); //删除后重新加载列表
										}/* else if(data.isSuccess=="early"){
										} */else{
											msgShow("系统提示", "<p class='tipInfo'>关闭失败！</p>", "warning");  
										}
									}
								});
							}else if(rows[0].useStatus==0){
								msgShow("系统提示", "<p class='tipInfo'>该活动未开启！</p>", "warning");  
							}else if(rows[0].useStatus==2){
								msgShow("系统提示", "<p class='tipInfo'>该活动已结束！</p>", "warning");  
							}
						}
					}
				}
			   ,"-",
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
	function updOrDelSA(id,rowid,flag){
		if(flag == 1){
			createWindow(800,450,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
			$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/promotion/getPromotionObject.action",
				   data: {promotionId:id},
				   success: function(data){
					     $("#promotionId").val(data.promotionId);
						   $("#promotionName").val(data.promotionName);
						   $("#shopPromotionInfo").val(data.shopPromotionInfo);
						   //KindEditor修改赋值
						   KindEditor.instance[0].html(data.shopPromotionInfo);
						   $("#beginTime").val(data.beginTime);
						   $("#endTime").val(data.endTime);
						   if(data.isPass=="0"){
							   $("#isPass_0").attr("checked",true);
						   }else if(data.isPass=="1"){
							   $("#isPass_1").attr("checked",true);
						   }								   
						   $("#smallCard").val(data.smallPoster);
						   $("#smallPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.smallPoster+"' width='120px' height='120px' />");
						   $("#bigCard").val(data.largePoster);
						   $("#bigPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.largePoster+"' width='150px' height='150px' />");
				   }
				});
		}else{
			$.messager.confirm("系统提示", "<p class='tipInfo'>正在活动的无法删除!你确定要删除吗?</p>",
					function(data){
					if(data == true)
					$.ajax({
					type: "POST", dataType: "JSON",
					url: "${pageContext.request.contextPath}/back/promotion/deletePromotion.action",
					data: {ids:id},
					success: function(data){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
					}
				});
				}
			);
		}
	}
	function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,beginTime:$("#qbeginTime").val(),endTime:$("#qendTime").val(),isPass:$("#qisPass").val(),useStatus:$("#quseStatus").val()};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
	}

	function reset(){
		$("#qbeginTime").val("");
       	$("#qendTime").val("");
    	$("#qisPass").val("");
    	$("#quseStatus").val("");
	}
	function CurentTime(){
        var now = new Date();
        var year = now.getFullYear();       //年
        var month = now.getMonth() + 1;     //月
        var day = now.getDate();            //日
        var clock = year + "-";
       
        if(month < 10)
            clock += "0";
        clock += month + "-";
        if(day < 10)
            clock += "0";
        clock += day + " ";
        return(clock); 
    } 
    </script>
  </head>
  <body>
 <jsp:include page="../util/item.jsp"/>
  		 <!-- 查询框  -->
  <div class="main">
		 <table  class="searchTab">
			<tr>
				<td class="toright_td" style="width:85px;">活动时间：</td>
				<td class="toleft_td" style="width:285px;">
					<input id="qbeginTime" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qendTime\')}'})"/>
					- <input id="qendTime" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qbeginTime\')}'})"/> </td>
				<td class="toright_td" style="width:70px;"> 审核状态：</td>
				<td class="toleft_td" style="width:105px;">
					<select id="qisPass" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="1">待审核</option>
						<option value="2">审核通过</option>
						<option value="3">审核不通过</option>
					</select></td>
				<td class="toright_td" style="width: 75px;"> 启用状态：</td>
				<td class="toleft_td" style="width:115px;">
					<select id="quseStatus" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">未开启</option>
						<option value="1">已开启</option>
						<option value="2">已结束</option>
					</select></td>
				<td class="toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
		</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditPromotion.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detailPromotion.jsp"/>
			<!-- 维护活动折扣页 -->
			<jsp:include page="promotionDiscount.jsp"/>
			<!-- 审核活动页 -->
			<jsp:include page="checkPromotion.jsp"/>
		</div>
	</div>
</body>
</html>
