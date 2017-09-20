<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>自营机构信息</title>
<jsp:include page="../../util/import.jsp" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		 $("#tt").datagrid({//数据表格
			/* 	title:"自营机构基本信息",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/selfSupportShopInfo/listShopInfo.action",
				queryParams:{pageSize:pageSize},
				idField:"shopInfoId",//唯一性标示字段
				frozenColumns:[[//冻结字段
					 {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"customerName",title:"机构账号",width:70,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.shopInfoId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerName+"</a>";
						}
					},
					/* {field:"shopInfoId",title:"机构ID",width:60},
					{field:"customerId",title:"会员ID",width:60},  */
					{field:"shopName",title:"机构名称",width:70},
					{field:"shopCategoryName",title:"机构分类名称",width:70},
					{field:"mainProduct",title:"主要销售产品",width:70},
					{field:"isPass",title:"审核状态",width:30,
						formatter:function(value,rowData,rowIndex){
								if(value==3){
									 return"<font class='color_001'>已通过</font>";
								}
								if(value==2){
									 return"<font class='color_002'>未通过</font>";
								}
								if(value==1){
									return "<font class='color_003'>待审核</font>";
								}
						 }
					},
					{field:"isClose",title:"是否关闭",width:30,
						formatter:function(value,rowData,rowIndex){
								if(value==0){
									 return"<font class='color_001'>否</font>";
								}else{
									 return"<font class='colot_002'>是</font>";
								}
						}
					},
					/*{field:"isVip",title:"VIP是否开启",width:40,
						formatter:function(value,rowData,rowIndex){
								if(value==0){
									 return"否";
								}else if(value==1){
									 return"是";
								}
						}
					},*/
					{field:"verifier",title:"机构审核人",width:70}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[
					<%-- <%
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
									if(i==rows.length-1)ids+=rows[i].shopInfoId;
									else ids+=rows[i].shopInfoId+",";
								}
								$("#addOrEditWin").css("display","none");
								$("#detailWin").css("display","none");
								$("#addOrEditWin2").css("display","none");
								$("#passWin").css("display","");

								$("#csmsg").html("");
								$("input.button_save").removeAttr("disabled");
								createWindow(900,470,"&nbsp;&nbsp;审核信息","icon-tip",false,"passWin");
								$.ajax({
										type: "POST",
										dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/shopinfo/getShopInfoById.action",
										data: {ids:ids},
										success: function(data){
											var shopInfo = data.shopInfo;
											$("#pshopInfoId").val(shopInfo.shopInfoId);
											$("#pshopCategoryId").val(data.categoryName);
											$("#pcustomerId").val(shopInfo.customerName);
											$("#pcountry").val(data.areaCounty);
											$("#pshopName").val(shopInfo.shopName);
											$("#pregionLocation").val(data.regionLocation);
											$("#pcity").val(data.city);
											$("#paddress").val(shopInfo.address);
											$("#ppostCode").val(shopInfo.postCode);
											$("#pmainProduct").val(shopInfo.mainProduct);
											$("#pcompanyRegistered").val(shopInfo.companyRegistered);
											$("#pphone").val(shopInfo.phone);
											$("#ppostage").val(shopInfo.postage+"元");
											$("#pminAmount").val("满"+shopInfo.minAmount+"元包邮");
											$("#paddressForInvoice").val(shopInfo.addressForInvoice);
											$("#pmainProduct").val(shopInfo.mainProduct);
											$("#pcompanyRegistered").val(shopInfo.companyRegistered);
											$("#plogoUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.logoUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
											$("#pbannerUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.bannerUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
											//$("#pmarketBrandUrlPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.marketBrandUrl+"' width='120px' height='120px' />");
											//$("#pbusinessLicensePreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.businessLicense+"' width='120px' height='120px' />");
											//$("#pcompanyDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.companyDocuments+"' width='150px' height='150px' />");
											//$("#ptaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.taxRegistrationDocuments+"' width='120px' height='120px' />");
											$("#pbusinessLicense").val(shopInfo.businessLicense);
											$("#pcompanyDocuments").val(shopInfo.companyDocuments);
											$("#ptaxRegistrationDocuments").val(shopInfo.taxRegistrationDocuments);
											$("#pmarketBrandUrl").val(shopInfo.marketBrandUrl);
											$("#pcustomerName").val(shopInfo.customerName);
											$("#pisClose").val(shopInfo.isClose);
											$("#pcompanyName").val(shopInfo.companyName);
											$("#savePhoneShowStatus").val(data.phoneShowStatus);
											$("#phoneShowStatus_"+shopInfo.phoneShowStatus).attr("checked","checked");
											$("#saveIsPass").val(shopInfo.isPass);
											var ecommission = shopInfo.commission;
											if(ecommission != ""){
												$("#pcommission").val(ecommission);
											}else{
												var ecommissionSys = "${application.fileUrlConfig.commissionProportion}";
												$("#pcommission").val(ecommissionSys);
											}
											if(shopInfo.isPass==1){
												$("#isPass_1").attr("checked","checked");
											}else if(shopInfo.isPass==2){
												$("#isPass_2").attr("checked","checked");
											}else if(shopInfo.isPass==3){
												$("#isPass_3").attr("checked","checked");
											}
										}
								});

							}
						}
					}
				},"-", --%>
					<%
					if("sGeneratedQrcode".equals((String)functionsMap.get(purviewId+"_sGeneratedQrcode"))){
					%>
					{
						text:"批量生成二维码",
						iconCls:"icon-redo",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择机构！</p>", "warning");
							}else{
								var ids="";
								for(var i=0;i<rows.length;i++){
									if(i==rows.length-1)ids+=rows[i].shopInfoId;
									else ids+=rows[i].shopInfoId+",";
								}
								$.ajax({
									type: "POST", dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/shopinfo/shopInfoGeneratedQrCode.action",
									data: {ids:ids},
									success: function(data){
										var failureLog2=data.failureLog2;
										var failureLog1=data.failureLog1;
										if(data.isSuccess){
											msgShow("系统提示", "<p class='tipInfo'>生成成功</p>", "warning");
											$("#tt").datagrid("clearSelections");//删除后取消所有选项
										}else{
											if(failureLog1!=null&&failureLog1!=""){
												msgShow("系统提示", "<p class='tipInfo'>"+failureLog1+"</p>", "warning");
											}else if(failureLog2!=null&&failureLog2!=""){
												msgShow("系统提示", "<p class='tipInfo'>"+failureLog2+"</p>", "warning");
											}else{
												msgShow("系统提示", "<p class='tipInfo'>生成失败！</p>", "warning");
											}
										}
									}
								});
							}
						}
					},"-",
					<%
					 }
					if("update2".equals((String)functionsMap.get(purviewId+"_update2"))){
					%>
					{
						text:"修改自营机构信息",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length<=0){
								msgShow("系统提示", "<p class='tipInfo'>请选择自营机构！</p>", "warning");
							}else if(rows.length>1){
								msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
							}else if(rows.length==1){
								$("#fileId1").val("");
								$("#fileId2").val("");
								$("#mymessage1").html("");
								$("#mymessage2").html("");
								$("#addOrEditWin").css("display","");
								$("#detailWin").css("display","none");
								$("#addOrEditWin2").css("display","none");
								$("#passWin").css("display","none");
								createWindow(1020,480,"&nbsp;&nbsp;修改自营机构信息","icon-edit",false,"addOrEditWin",10);
								$("#wshopInfoId").val(rows[0].shopInfoId);
								$("#wids").val(rows[0].shopInfoId);
								$.ajax({
									type: "POST", dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/selfSupportShopInfo/getShopInfoById.action",
									data: {shopInfoId:rows[0].shopInfoId},
									success: function(data){
										$("#wshopInfoId").val(data.shopInfoId);
										$("#wshopCategoryId").val(data.shopCategoryId);
										$("#wshopInfoType").val(data.shopInfoType);
										$("#wtemplateSet").val(data.templateSet);
										$("#wcustomerId").val(data.customerId);
										$("#wshopName").val(data.shopName);
										$("#wbusinessType").val(data.businessType);
										$("#wpostCode").val(data.postCode);
										$("#wmainProduct").val(data.mainProduct);
										$("#wemail").val(data.email);
										$("#wphone").val(data.phone);
										$("#wsynopsis").val(data.synopsis);
										$("#wpostage").val(data.postage);
										$("#wminAmount").val(data.minAmount);
										$("#wbusinessHoursStart").val(data.businessHoursStart);
										$("#wbusinessHoursEnd").val(data.businessHoursEnd);
										$("#wmarketBrand").val(data.marketBrand);
										$("#waddressForInvoice").val(data.addressForInvoice);
										$("#wisClose_"+data.isClose).attr("checked",true);
										$("#imageUrl1").val(data.logoUrl);
										$("#imageUrl2").val(data.bannerUrl);
										$("#photo1").html(" <img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.logoUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										$("#photo2").html(" <img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.bannerUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										$("#save").css("display","");
										$("#emarketBrandUrl").val(data.marketBrandUrl);
									}
								});
							}
						}
					},"-",
					<%
					}
					if("update".equals((String)functionsMap.get(purviewId+"_update"))){
					%>
						{
						text:"修改企业信息",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length<=0){
								msgShow("系统提示", "<p class='tipInfo'>请选择自营机构！</p>", "warning");
							}else if(rows.length>1){
								msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
							}else if(rows.length==1){
								$("#fileId3").val("");
								$("#fileId4").val("");
								$("#mymessage3").html("");
								$("#mymessage4").html("");
								$("#addOrEditWin").css("display","none");
								$("#detailWin").css("display","none");
								$("#addOrEditWin2").css("display","");
								$("#passWin").css("display","none");
								createWindow(1000,"auto","&nbsp;&nbsp;修改企业信息","icon-edit",false,"addOrEditWin2");
								$.ajax({
									type: "POST", dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/selfSupportShopInfo/getShopInfoById.action",
									data: {shopInfoId:rows[0].shopInfoId},
									success: function(data){
										$("#ashopInfoId").val(data.shopInfoId);
										$("#acompanyRegistered").val(data.companyRegistered);
										$("#alegalOwner").val(data.legalOwner);
										$("#aIDCards").val(data.IDCards);
										$("#acompanyName").val(data.companyName);
										$("#aaddress").val(data.address);
										$("#apostCode").val(data.postCode);
										$("#acompanyCertification").val(data.companyCertification);
										$("#aIDCardsImage").val(data.IDCardsImage);
										$("#imageUrl3").val(data.businessLicense);
										$("#imageUrl4").val(data.companyDocuments);
										$("#ataxRegistrationDocuments").val(data.taxRegistrationDocuments);
										//$("#aphoto3").html(" <img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.IDCardsImage+"' width='120px' height='120px' />");
										$("#photo3").html(" <img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.businessLicense+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										$("#photo4").html(" <img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.companyDocuments+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										//$("#aphoto6").html(" <img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.taxRegistrationDocuments+"' width='120px' height='120px' />");
									}
								});
							}
						}
					},"-",
					<%
					 }
					if("maintainShopProCategery".equals((String)functionsMap.get(purviewId+"_maintainShopProCategery"))){
					%>
					{
						text:"维护自营机构内部分类",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择自营机构！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								location.href="${pageContext.request.contextPath}/back/selfSupportShopProCategory/gotoSelfSupportShopProCategory.action?shopInfoId="+rows[0].shopInfoId;
							}
						}
					},"-",
					<%
					 }
					if("showProduct".equals((String)functionsMap.get(purviewId+"_showProduct"))){
					%>
					{
						text:"查看机构套餐",
						iconCls:"icon-search",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择机构！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								location.href="${pageContext.request.contextPath}/back/shopProduct/gotoSelfSupportProductListByShopInfoPage.action?shopInfoId="+rows[0].shopInfoId;
							}
	
						}
					},"-",
					<%
					}
					if("maintainShopCustomerService".equals((String)functionsMap.get(purviewId+"_maintainShopCustomerService"))){
					%>
					{
						text:"维护机构客服信息",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择自营机构！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								location.href="${pageContext.request.contextPath}/back/selfSupportShopInfo/gotoSelfSupportCustomerService.action?ids="+rows[0].customerId;
							}
						}
					},"-",
					<% 
					}
					%>
				/* {
					text:"批量开启",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>0){
							var ids="";
							for(var i=0;i<rows.length;i++){
								if(i==rows.length-1)ids+=rows[i].shopInfoId;
								else ids+=rows[i].shopInfoId+",";
							}
							$.ajax({
								type: "POST",dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/shopinfo/saveOrUpdateIsCloss.action",
								data: {ids:ids,saveIsPass:0},
								success: function(data){
									$("#tt").datagrid("clearSelections");//删除后取消所有选项
									if(data.isSuccess==true)$("#tt").datagrid("reload"); //删除后重新加载列表
									$('input[type="checkbox"]').removeAttr("checked");
								}
							});
						}
					}
				},"-",
				{
					text:"批量关闭",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>0){
							var ids="";
							for(var i=0;i<rows.length;i++){
								if(i==rows.length-1)ids+=rows[i].shopInfoId;
								else ids+=rows[i].shopInfoId+",";
							}
							$.ajax({
								type: "POST",dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/shopinfo/saveOrUpdateIsCloss.action",
								data: {ids:ids,saveIsPass:1},
								success: function(data){
									$("#tt").datagrid("clearSelections");//删除后取消所有选项
									if(data.isSuccess==true)$("#tt").datagrid("reload"); //删除后重新加载列表
									$('input[type="checkbox"]').removeAttr("checked");
								}
							});
						}
					}
				} 
				,"-", */
				/*{
					text:"VIP开启",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>0){
							var ids="";
							for(var i=0;i<rows.length;i++){
								if(i==rows.length-1)ids+=rows[i].shopInfoId;
								else ids+=rows[i].shopInfoId+",";
							}
							$.ajax({
								type: "POST",dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/shopinfo/saveOrUpdateIsVip.action",
								data: {ids:ids,saveIsPass:1},
								success: function(data){
									if(data.isSuccess==true){
										alert("设置成功！");
										$("#tt").datagrid("clearSelections");//删除后取消所有选项
										$("#tt").datagrid("load"); //删除后重新加载列表
										$('input[type="checkbox"]').removeAttr("checked");
									}else{
										alert("设置失败！");
									}
								}
							});
						}
					}
				},"-",
				{
					text:"VIP关闭",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>0){
							var ids="";
							for(var i=0;i<rows.length;i++){
								if(i==rows.length-1)ids+=rows[i].shopInfoId;
								else ids+=rows[i].shopInfoId+",";
							}
							$.ajax({
								type: "POST",dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/shopinfo/saveOrUpdateIsVip.action",
								data: {ids:ids,saveIsPass:0},
								success: function(data){
									if(data.isSuccess==true){
										alert("设置成功！");
										$("#tt").datagrid("clearSelections");//删除后取消所有选项
										$("#tt").datagrid("load"); //删除后重新加载列表
										$('input[type="checkbox"]').removeAttr("checked");
									}else{
										alert("设置失败！");
									}
								}
							});
						}
					}
				},"-",*/
				{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});


		function query(){
			$("#tt").datagrid("clearSelections");//删除后取消所有选项
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopName:$("#qshopName").val(),isClose:$("#qisClose").val(),custName:$("#qcustName").val(),shopCategoryId:$("#parentIdList").val(),isPass:$("#qisPass").val()/*,isVip:$("#qisVip").val()*/,registerDate2:$("#qregisterDate2").val(),registerDate:$("#qregisterDate").val()};
			$("#tt").datagrid("load",queryParams);
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		function reset(){
			$("#qcustName").val("");
			$("#qshopName").val("");
			$("#parentIdList").val("");
			$("#qisClose").val("");
			$("#qisPass").val("");
			/*$("#qisVip").val("");*/
			$("#qregisterDate").val("");
			$("#qregisterDate2").val("");
		}
</script>
</head>
<style type="text/css">
.linkbtn {
	margin-top: 5px;
	margin-right: 10px;
}

.linkbtn a {
	height: 10px;
	font-size: 14px;
	margin-top: 5px;
	width: 70px;
	border: 1px #4F9D9D solid;
	background: #ECF5FF;
	font-weight: bolder;
	color: #003D79;
}

.querybtn {
	margin-top: 5px;
	margin-right: 10px;
	height: 20px;
}

.querybtn a {
	height: 8px;
	font-size: 14px;
	margin-top: 5px;
	width: 70px;
	border: 1px #4F9D9D solid;
	background: #ECF5FF;
	font-weight: bolder;
	color: #003D79;
}
</style>
<body>
	  <jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
		<div class="main">
		<table class="searchTab">
		<tr>
			<td class="search_toright_td" style="width:75px;">机构账号：</td>
			<td class="search_toleft_td" style="width:115px;"><input type="text" style="width: 93px;" id="qcustName" name="custName" class="searchTabinput"/>&nbsp;&nbsp;</td>
			<td class="search_toright_td" style="width:60px;">机构名称：</td>
			<td class="search_toleft_td" style="width:115px;"><input type="text" style="width: 93px;" id="qshopName" name="shopName" class="searchTabinput"/>&nbsp;&nbsp;</td>
			<td class="search_toright_td" style="width:85px;">平台机构分类：</td>
			<td class="search_toleft_td" style="width:115px;">
				<select id="parentIdList" style="width:100px" name="shopInfo.shopCategoryId" class="{validate:{required:true}} Registration;querySelect">
					<option value="-1">--请选择--</option>
					<s:iterator value="shopCategoryList">
						<option value="<s:property value="shopCategoryId" />">
							<s:if test="level==1">&nbsp;&nbsp;<s:property
									value="shopCategoryName" />
							</s:if>
							<s:if test="level==2">&nbsp;&nbsp;&nbsp;&nbsp;<s:property
									value="shopCategoryName" />
							</s:if>
							<s:if test="level==3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property
									value="shopCategoryName" />
							</s:if>
						</option>
					</s:iterator>
				</select>
			</td>
			<td class="search_toright_td" style="width:65px;">是否关闭：</td>
			<td class="search_toleft_td" style="width:115px;">
				<select id="qisClose" style="width:100px" class="querySelect">
					<option value="-1">--请选择--</option>
					<option value="0">否</option>
					<option value="1">是</option>
				</select>&nbsp;&nbsp;
			</td>
			<td class="search_toright_td" style="width: 65px;">审核状态：</td>
			<td class="search_toleft_td" style="width:120px;">
				<select id="qisPass" style="width:100px" class="querySelect">
					<option value="-1">--请选择--</option>
					<option value="1">待审核</option>
					<option value="2">未通过</option>
					<option value="3">已通过</option>
				</select>&nbsp;&nbsp;
			</td>
			<td class="search_toleft_td"	>
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
				<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
			</td>
		</tr>
	</table>
	<table id="tt"></table>
	<div id="win"
		style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<!-- 添加或者修改 -->
		<jsp:include page="addOrEditShopInfo.jsp" />
		<jsp:include page="addOrEditShopInfo2.jsp" />
		<!-- 详情页 -->
		<jsp:include page="detailShopInfo.jsp" />
		<!-- 审核页面 -->
		<jsp:include page="isPassShopInfo.jsp" />
	</div>
	</div>
</body>
</html>
