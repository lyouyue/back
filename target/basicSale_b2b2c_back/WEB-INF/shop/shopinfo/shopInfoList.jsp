<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>入驻店铺信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"店铺基本信息",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopinfo/listShopInfo.action",
				queryParams:{pageSize:pageSize},
				idField:"shopInfoId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerName",title:"店铺账号",width:70,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.shopInfoId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerName+"</a>";
		         	  	}
					},
					/* {field:"shopInfoId",title:"店铺ID",width:60},  */
					{field:"shopName",title:"店铺名称",width:70},
					{field:"shopCategoryName",title:"店铺分类名称",width:70},
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
								    return"<font class='color_002'>是</font>";
							   }
						}
					}/*,
					{field:"isVip",title:"VIP是否开启",width:40,
						formatter:function(value,rowData,rowIndex){
							   if(value==0){
								    return"否";
							   }else if(value==1){
								    return"是";
							   }
						}
					}*/,
					{field:"verifier",title:"店铺审核人",width:70}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:false,//true只可以选中一行
				toolbar:[
					<%
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
								createWindow(900,500,"&nbsp;&nbsp;审核入驻店铺","icon-tip",false,"passWin");
								$("input.button_save").removeAttr("disabled");
								$("#addOrEditWin").css("display","none");
								$("#detailWin").css("display","none");
								$("#passWin").css("display","");
								$("#csmsg").html("");
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
										   $("#pbusinessLicensePreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.businessLicense+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										   //$("#pIDCardsImagePreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.IDCardsImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										   $("#pcompanyDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.companyDocuments+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										  // $("#ptaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.taxRegistrationDocuments+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
										   $("#pbusinessLicense").val(shopInfo.businessLicense);
										   $("#pcompanyDocuments").val(shopInfo.companyDocuments);
										   $("#ptaxRegistrationDocuments").val(shopInfo.taxRegistrationDocuments);
										   $("#pmarketBrandUrl").val(shopInfo.marketBrandUrl);
										   $("#pcustomerName").val(shopInfo.customerName);
										   $("#pisClose").val(shopInfo.isClose);
										   $("#dpcompanyName").val(shopInfo.companyName);
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
				},"-",
				<%
				 }
				if("checkShopAndCompany".equals((String)functionsMap.get(purviewId+"_checkShopAndCompany"))){
				%>
				{
				text:"审核店铺及企业信息",
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
							createWindow(900,500,"&nbsp;&nbsp;审核店铺及企业信息","icon-tip",false,"passWin");
							$("input.button_save").removeAttr("disabled");
							$("#addOrEditWin").css("display","none");
							$("#detailWin").css("display","none");
							$("#passWin").css("display","");
							$("#csmsg").html("");
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
									$("#plogoUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.logoUrl+"' width='120px' height='120px' />");
									$("#pbannerUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.bannerUrl+"' width='120px' height='120px' />");
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
									$("#savePhoneShowStatus").val(shopInfo.phoneShowStatus);
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
									//企业审核
									$("#pbusinessLicensePreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.businessLicense+"' width='120px' height='120px' />");
									$("#pcompanyDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.companyDocuments+"' width='150px' height='150px' />");
									$("#ptaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.taxRegistrationDocuments+"' width='120px' height='120px' />");
									$("#psaveShopInfoCheckSatus").html(shopInfo.shopInfoCheckSatus);
									if(shopInfo.shopInfoCheckSatus==2){
										$("#shopInfoCheckSatus_2").attr("checked","checked");
									}else if(shopInfo.shopInfoCheckSatus==3){
										$("#shopInfoCheckSatus_3").attr("checked","checked");
									}
								}
							});
						}
					}
				}
			},"-",
			<%
			 }
			if("sGeneratedQrCode".equals((String)functionsMap.get(purviewId+"_sGeneratedQrCode"))){
			%>
				{text:"批量生成二维码",
					iconCls:"icon-redo",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择店铺！</p>", "warning");
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
				if("showProduct".equals((String)functionsMap.get(purviewId+"_showProduct"))){
				%>
				{
						text:"查看店铺商品",
						iconCls:"icon-search",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								location.href="${pageContext.request.contextPath}/back/shopProduct/gotoProductListByShopInfoPage.action?shopInfoId="+rows[0].shopInfoId;
							}

						}
				},"-",
				<%
				 }
				if("batchOpen".equals((String)functionsMap.get(purviewId+"_batchOpen"))){
				%>
				{
					text:"批量开启",
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
				<%
				 }
				if("batchClose".equals((String)functionsMap.get(purviewId+"_batchClose"))){
				%>
				{
					text:"批量关闭",
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
				},"-",
				<%
				 }
				if("maintainShopProCategery".equals((String)functionsMap.get(purviewId+"_maintainShopProCategery"))){
				%>
				{
					text:"维护入驻店铺内部分类",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择入驻店铺店铺！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							location.href="${pageContext.request.contextPath}/back/shopProCategory/gotoShopProCategory.action?shopInfoId="+rows[0].shopInfoId;
						}
					}
				},"-",
				<%
				 }
				%>
				/*,"-",
				{
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
				}*/
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
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  <body>
  <jsp:include page="../../util/item.jsp"/>
  		 <!-- 查询框  -->
  <div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:80px;'">店铺账号：</td>
				<td class="search_toleft_td" style="width:110px;"><input type="text" style="width: 93px;" id="qcustName" name="custName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:65px;">店铺名称：</td>
				<td class="search_toleft_td" style="width:110px;"><input type="text" style="width: 93px;" id="qshopName" name="shopName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:85px;">平台店铺分类：</td>
				<td class="search_toleft_td" style="width:110px;">
					<select id="parentIdList"  style="width:100px" name="shopInfo.shopCategoryId" class="{validate:{required:true}} Registration ;querySelect">
						<option value="-1">--请选择--</option>
						<s:iterator  value="shopCategoryList">
							<option  value="<s:property value="shopCategoryId" />">
								<s:if test="level==1">&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
								<s:if test="level==2">&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
								<s:if test="level==3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
							</option>
						</s:iterator>
					</select>
				</td>
				<td class="search_toright_td" style="width:65px;">审核状态：</td>
				<td class="search_toleft_td" style="width:110px;">
					<select id="qisPass" style="width:100px" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="1">待审核</option>
						<option value="2">未通过</option>
						<option value="3">已通过</option>
					</select>&nbsp;&nbsp;
				</td>
				<td class="search_toright_td" style="width:65px;">是否关闭 ：</td>
				<td class="search_toleft_td" style="width:120px;">
					<select id="qisClose" style="width:100px" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">否</option>
						<option value="1">是</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditShopInfo.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detailShopInfo.jsp"/>
			<!-- 审核页面 -->
			<jsp:include page="isPassShopInfo.jsp"/>
		</div>
		</div>
</body>
</html>
