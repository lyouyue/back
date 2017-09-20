<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>优惠券信息</title>
    <jsp:include page="../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">

    Date.prototype.format = function(format){
    	var o = {
    	"M+" : this.getMonth()+1, //month
    	"d+" : this.getDate(), //day
    	"h+" : this.getHours(), //hour
    	"m+" : this.getMinutes(), //minute
    	"s+" : this.getSeconds(), //second
    	"q+" : Math.floor((this.getMonth()+3)/3), //quarter
    	"S" : this.getMilliseconds() //millisecond
    }

    	if(/(y+)/.test(format)) {
    	format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    	}

    	for(var k in o) {
    	if(new RegExp("("+ k +")").test(format)) {
    	format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
    	}
    	}
    	return format;
    }
    
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"优惠券列表信息",
				iconCls:"icon-save", */ 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/discountcoupon/listDiscountCouponApply.action",
				queryParams:{pageSize:pageSize},
				idField:"discountCouponID",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"discountCouponName",title:"优惠劵名称",width:80,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.discountCouponID+"' onclick='showDetailInfo(this.id);'>"+rowData.discountCouponName+"</a>";  
		         	}}, 
					{field:"discountCouponCode",title:"优惠券码",width:170}, 
					{field:"discountCouponLowAmount",title:"订单满额(元)",width:80},  
					{field:"discountCouponAmount",title:"抵扣金额(元)",width:80}, 
					{field:"distributionCount",title:"发放个数",width:60}, 
					{field:"surplus",title:"剩余个数",width:60}, 
					{field:"useStatus",title:"状态",width:60,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						if(value==0){
							return "<font class='color_002'>未启用</font>";
						}else if(value==1){
							return "<font class='color_001'>启用</font>";
						}else if(value==2){
							return "<font class='color_003'>已过期</font>";
						}	
		         	}  
					},
					{field:"isPass",title:"审核状态",width:60,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value==2){
								return "<font class='color_001'>审核通过</font>";
							}else if(value==3){
								return "<font class='color_002'>审核未通过</font>";
							}else{
								return "<font class='color_003'>待审核</font>";
							}
	         	  		}  
					},
					{field:"beginTime",title:"开始时间",width:130}, 
					{field:"expirationTime",title:"结束时间",width:130,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						var d2 =new Date().format("yyyy-MM-dd"); 
						if(Date.parse(value)-Date.parse(d2)<0){
							return "<font class='color_002'>"+value+"</font>";
						}else{
							return value;
						}
					}
					}, 
					{field:"createTime",title:"创建时间",width:130}
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
							createWindow(800,"auto","&nbsp;&nbsp;添加优惠券","icon-add",false,"addOrEditWin");
							$("#addOrEditWin").css("display","");
							$("#detailWin").css("display","none");
							$("#useStatusWin").css("display","none");
							$("#passWin").css("display","none");
							$("#congeal").css("display","none");
							$("#manualGive").css("display","none");
							$("#sendTime").html("");
							$("#restrictCount").val("");
							$("#discountImages").html("");
							$("#ediscountCouponID").val(null);
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
												for(var i=0;i<rows.length;i++){
													if(i==rows.length-1)ids+=rows[i].discountCouponID;
													else ids+=rows[i].discountCouponID+",";
												}
												$.ajax({
												   type: "POST",dataType: "JSON",
												   url: "${pageContext.request.contextPath}/back/discountcoupon/deleteDiscountCoupon.action",
												   data: {ids:ids},
												   success: function(data){
													   $("#tt").datagrid("clearSelections");//删除后取消所有选项
													   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
												   }
												});
											}	
										}
									});
								}
							}
						},"-",
					<%
					}
					if("check".equals((String)functionsMap.get(purviewId+"_check"))){
					%>	
				        {
						text:"审核",
						iconCls:"icon-tip",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择审核项！</p>", "warning");
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够审核一项！</p>", "warning");
							}else if(rows.length==1){
								if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
									var ids="";
									for(var i=0;i<rows.length;i++){
										if(i==rows.length-1)ids+=rows[i].discountCouponID;
										else ids+=rows[i].discountCouponID+",";
									}
									createWindow(800,450,"&nbsp;&nbsp;审核优惠券","icon-tip",false,"passWin");
									$("input.button_save").removeAttr("disabled");
									$("#addOrEditWin").css("display","none");
									$("#useStatusWin").css("display","none");
									$("#detailWin").css("display","none");
									$("#passWin").css("display","");
									$("#congeal").css("display","none");
									$("#manualGive").css("display","none");
									$("#csmsg").html("");
									$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/discountcoupon/getDiscountCouponById.action",
										   data: {ids:ids},
										   success: function(data){
										        $("#pdiscountCouponID").val(data.discountCouponID);
										        $("#pdiscountCouponCode").val(data.discountCouponCode);
										        $("#pdiscountCouponName").val(data.discountCouponName);
										        $("#pdiscountCouponAmount").val(data.discountCouponAmount);
										        $("#pdiscountCouponLowAmount").val(data.discountCouponLowAmount);
										        $("#pbeginTime").val(data.beginTime);
										        $("#pexpirationTime").val(data.expirationTime);
										        $("#pdistributionCount").val(data.distributionCount);
										        $("#pcreateTime").val(data.createTime);
											   if(data.isPass==2){
												   $("#isPass_2").attr("checked","checked");
											   }else if(data.isPass==3){
												   $("#isPass_3").attr("checked","checked");
											   }else if(data.isPass==1){
												   $("#isPass_1").attr("checked","checked");
											   }
											   if(data.templatetype==1){
												   $("#ptemplatetype").val("模板一");
											   }else  if(data.templatetype==2){
												   $("#ptemplatetype").val("模板二");
											   }else if(data.templatetype==3){
												   $("#ptemplatetype").val("模板三");
											   }else if(data.templatetype==4){
												   $("#ptemplatetype").val("模板四");
											   }
// 											   $("#pdiscountImage").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.discountImage+"' width='120px' height='120px' />");
										   }
									});
									
								}
							}
						}
					},"-",
				<%
				}
				if("updateuseStatus".equals((String)functionsMap.get(purviewId+"_updateuseStatus"))){
					%>
					{
						text:"启用状态",
						iconCls:"icon-tip",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择操作项！</p>", "warning");
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能选择一项！</p>", "warning");
							}else if(rows.length==1){
								if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
									var ids="";
									for(var i=0;i<rows.length;i++){
										if(i==rows.length-1)ids+=rows[i].discountCouponID;
										else ids+=rows[i].discountCouponID+",";
									}
									var d1 = rows[0].expirationTime;
									var d2 =new Date().format("yyyy-MM-dd"); 
									if(Date.parse(d1)-Date.parse(d2)<0){
									   msgShow("系统提示", "<p class='tipInfo'>已过期！</p>", "warning");  
									}else{
										if(rows[0].isPass==1){
											msgShow("系统提示", "<p class='tipInfo'>尚未审核，不能修改启用状态！</p>", "warning");
										}else if(rows[0].isPass==3){
											msgShow("系统提示", "<p class='tipInfo'>审核未通过，不能修改启用状态！</p>", "warning");
										}else{
											createWindow(800,140,"&nbsp;&nbsp;启用状态信息","icon-tip",false,"useStatusWin");
											$("input.button_save").removeAttr("disabled");
											$("#addOrEditWin").css("display","none");
											$("#detailWin").css("display","none");
											$("#passWin").css("display","none");
											$("#useStatusWin").css("display","");
											$("#congeal").css("display","none");
											$("#manualGive").css("display","none");
											$("#csmsg").html("");
											$.ajax({
												   type: "POST",
												   dataType: "JSON",
												   url: "${pageContext.request.contextPath}/back/discountcoupon/getDiscountCouponById.action",
												   data: {ids:ids},
												   success: function(data){
												        $("#udiscountCouponID").val(data.discountCouponID);
													   if(data.useStatus==1){
														   $("#isPass_5").attr("checked","checked");
													   }else{
														   $("#isPass_6").attr("checked","checked");
													   }
												   }
											});
										}
									}
									
								}
							}
						}
					},"-",
				<%
				}
				%>
				{
				text:"优惠券统计",
				iconCls:"icon-search",
				handler:function(){
					$.ajax({
						   type: "POST",dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/discountcoupon/selectCouponAmount.action",
						   success: function(data){
							  createWindow(800,300,"&nbsp;&nbsp;优惠券统计","icon-tip",false,"congeal");
							  $("input.button_save").removeAttr("disabled");
							  $("#addOrEditWin").css("display","none");
							  $("#detailWin").css("display","none");
							  $("#passWin").css("display","none");
							  $("#useStatusWin").css("display","none");
							  $("#manualGive").css("display","none");
							  $("#congeal").css("display","");
							if(data.useCouponAmount==""||data.useCouponAmount==null){
							   $("#useCouponAmount").html("0");
							}else{
							   $("#useCouponAmount").html(data.useCouponAmount+"（元）");
							}
							if(data.unusedCouponAmount==""||data.unusedCouponAmount==null){
								 $("#unusedCouponAmount").html("0");
							}else{
								$("#unusedCouponAmount").html(data.unusedCouponAmount+"（元）");
							}
						   }
						});
					}
				},"-",
					 {
						 text:"手动赠送优惠券",
						 iconCls:"icon-add",
						 handler:function(){
							 var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							 if(rows.length==0) {//没有选择修改项
								 msgShow("系统提示", "<p class='tipInfo'>请选择需要赠送的优惠券！</p>", "warning");
							 }if(rows.length>1){//超过了一个选择项
								 msgShow("系统提示", "<p class='tipInfo'>每次只能赠送一张优惠券</p>", "warning");
							 }if(rows.length==1){
								 if(rows[0].isPass==2){
									 $("#addOrEditWin").css("display","none");
									 $("#detailWin").css("display","none");
									 $("#passWin").css("display","none");
									 $("#useStatusWin").css("display","none");
									 $("#congeal").css("display","none");
									 $("#manualGiveCoupon").css("display","");
									 $("#manualGive").css("display","");
									 if(rows[0].useStatus==0){
										 msgShow("系统提示", "<p class='tipInfo'>优惠券未启用！</p>", "warning");
									 }else if(rows[0].useStatus==2){
										msgShow("系统提示", "<p class='tipInfo'>该优惠券已过期！</p>", "warning");
									 }else{
										 createWindow(1100,505,"&nbsp;&nbsp;手动赠送优惠券","icon-add",false,"mgc",10);
										 $("#mgc").datagrid({//数据表格
											/*  title:"会员列表信息",
											 iconCls:"icon-save", */
											 width:1025,
											 height:"auto",
											 fitColumns: true,//宽度自适应
											 align:"center",
											 loadMsg:"正在处理，请等待......",
											 striped: true,//true是否把一行条文化
											 queryParams:{typeId:"",currentPage:1},
											 url:"${pageContext.request.contextPath}/back/customer/listCustomer.action",
											 idField:"customerId",//唯一性标示字段
											 frozenColumns:[[//冻结字段
												 {field:"ck",checkbox:true}
											 ]],
											 columns:[[//未冻结字段
												 /* {field:"customerId",title:"会员ID",width:40}, */
												 {field:"loginName",title:"会员名称",width:25 },
												 {field:"sex",title:"性别",width:10,
													 formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
														 <s:iterator value="#application.keybook['sex']" var="kb">
														 if(value==<s:property value="#kb.value"/>){
															 return "<s:property value='#kb.name'/>";
														 }
														 </s:iterator>
														 return "保密";
													 }
												 },
												 {field:"email",title:"电子邮箱",width:25},
												 {field:"phone",title:"手机号",width:20},
												/*  {field:"registerDate",title:"注册日期",width:50}, */
												/*  {field:"registerIp",title:"注册IP",width:60}, */
												 {field:"lockedState",title:"状态",width:10,
													 formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
														 if(value=="0"){ return "<font class='color_001'>未冻结</font>";}
														 if(value=="1"){ return "<font class='color_002'>已冻结</font>";}
													 }
												 },
												/*  {field:"balance",title:"账户余额",width:50}, */
												 {field:"wxUserOpenId",title:"关联微信",width:25,
													 formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
														 if(value=="0"){ return "<font color='#EE0000'>否</font>";}
														 if(value=="1"){ return "<a class='color_001' style='display:block;cursor: pointer' id='"+rowData.customerId+"' onclick='showWxDetailInfo(this.id);'>是</a>";}
													 }
												 }
											 ]],
											 pagination:true,//显示分页栏
											 rownumbers:true,//显示行号
											 singleSelect:true,//true只可以选中一行
										 });
										 pageSplitThis(pageSize,queryParams,"mgc");//调用分页函数
										
									}
								 }else if(rows[0].isPass !=2){
									 msgShow("系统提示", "<p class='tipInfo'>优惠券未审核通过！</p>", "warning");
								 }
							 }
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopInfoId:$("#parameShopInfoId").val(),discountCouponAmount:$("#qdiscountCouponAmount").val(),
					  beginTime:$("#qbeginTime").val(), qdiscountCouponName:$("#qdiscountCouponName").val(),expirationTime:$("#qexpirationTime").val(),createTime:$("#qcreateTime").val(),useStatus:$("#quseStatus").val(),ispass:$("#qisPass").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }

		function reset(){
			$("#qdiscountCouponName").val("");
	       	$("#qbeginTime").val("");
	    	$("#qexpirationTime").val("");
	    	$("#qcreateTime").val("");
	    	$("#quseStatus").val("");
	    	$("#qisPass").val("");
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
	<jsp:include page="../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
	<table class="searchTab">
		<tr>
		<td class="search_toright_td" style="width: 90px;">优惠券名称：</td>
		<td class="search_toleft_td" style="width:110px;">
			<input type="text" id="qdiscountCouponName" name="discountCouponName" style="width:85px" class="searchTabinput"/>
		</td>
		<td class="search_toright_td" style="width:70px;">起止时间：</td>
			<td class="toleft_td" style="width:210px;"><input id="qbeginTime" style="width: 85px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qexpirationTime\')}'})"/>
			- <input id="qexpirationTime" style="width: 85px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qbeginTime\')}'})"/>
		</td>
		<td class="search_toright_td" style="width:70px;">启用状态：</td>
		<td class="search_toleft_td" style="width:100px;">
			<select id="quseStatus" style="width:85px" class="querySelect">
				<option value="">--请选择--</option>
				<option value="0">未启用</option>
				<option value="1">启用</option>
			</select>
		</td>
		<td class="search_toright_td" style="width:70px;">审核状态：</td>
		<td class="search_toleft_td" style="width:110px;">
			<select id="qisPass" style="width:85px" class="querySelect">
				<option value="">--请选择--</option>
				<option value="1">待审核</option>
				<option value="2">审核通过</option>
				<option value="3">审核未通过</option>
			</select>
		</td>
		<td class="search_toleft_td">
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
			<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
		</td><td></td>
		</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEdit.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detail.jsp"/>
			<!-- 审核页面 -->
			<jsp:include page="isPassShopInfo.jsp"/>
			<!-- 修改启用状态 -->
			<jsp:include page="useStatus.jsp"/>
			<jsp:include page="congeal.jsp"/>
			<!--手动赠送会员优惠券页面-->
			<jsp:include page="manualGiveCoupon.jsp"/>
		</div>
	</div>
</body>
</html>
