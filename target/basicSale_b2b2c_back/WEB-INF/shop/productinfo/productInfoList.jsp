<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>入驻店铺商品信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <!-- kindedite -->
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
	<!-- kindedite end-->
	<script type="text/javascript">
	$(function(){
		$("#tt").datagrid({//数据表格
				/* title:"商品列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/productinfo/listProductInfo.action",
				queryParams:{pageSize:pageSize},
				idField:"productId",//唯一性标示字段
				frozenColumns:[[//冻结字段
					{field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"logoImg",title:"商品图片",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return "<a style='display:block;' id='"+rowData.productId+"' onclick='showDetailInfo(this.id);'><img src='<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='30px' height='30px' /></a>";  
						}
					},
					{field:"name",title:"名称",width:220, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return "<a style='display:block;' id='"+rowData.productId+"' onclick='showDetailInfo(this.id);'>"+rowData.productFullName+"</a>";  
					}
					}, 
					{field:"shopName",title:"店铺名称",width:120},
					{field:"sku",title:"SKU号",width:80},
					{field:"productCode",title:"商品编号",width:100},
					{field:"marketPrice",title:"市场价(元)",width:90},
					{field:"salesPrice",title:"销售价(元)",width:90},
					{field:"isPutSale",title:"是否上架",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						if(value=="2"){ return "<font class='color_001'>已上架</font>";} 
							if(value=="1"){ return "<font class='color_002'>未上架</font>";} 
							if(value=="3"){ return "<font class='color_003'>违规下架</font>";} 
						}
					},
					{field:"isRecommend",title:"是否推荐",width:80, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="1"){ return "<font class='color_001'>是</font>";} 
							if(value=="0"){ return "<font class='color_002'>否</font>";} 
						}
					},
					{field:"isPass",title:"审核状态",width:80, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="0"){ 
								return "<font class='color_002'>未通过</font>";
							}else if(value=="1"){
								return "<font class='color_001'>已通过</font>";
							}else if(value=="2"){
								return "<font class='color_003'>待申请</font>";
							}else{
								return "<font class='color_004'>待审核</font>";
							} 
						}
					},
					{field:"isShow",title:"是否显示在列表",width:110,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						if(value=="1"){ return "<font class='color_001'>显示</font>";}
						if(value=="0"){ return "<font class='color_002'>不显示</font>";}
					}
					},
					{field:"createDate",title:"创建时间",width:160},
					{field:"passUserName",title:"审核人名称",width:90}
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
						//window.open("${pageContext.request.contextPath}/back/productinfo/addProduct.action","newwindow","width="+(window.screen.availWidth-10)+",height="+(window.screen.availHeight-30)+ ", top=0,left=0,toolbar=no, menubar=yes, scrollbars=yes,fullscreen=yes, resizable=yes,location=yes, status=no");
						$("#addOrEditWin").css("display","none");
						$("#updateRatioWin").css("display","none");
						$("#detailWin").css("display","none");
						$("#editProductWin").css("display","none");
						$("#merchandise_add").css("display","");
						createWindow(1039,480,"&nbsp;&nbsp;添加入驻店铺商品","icon-edit",false,"merchandise_add",10);
						$("#addProduct").css("display","none");
						$("#selectShop").css("display","");
						//控制保存按钮可用
						$("#add_btnSave").attr("onclick","javascript:saveProduct();");
						resetShopInfo();//重置店铺查询参数
						$("#aShopInfoId").val("");//去掉店铺Id
						$("#aShopInfoName").html("");//去掉店铺名称
						$("#shopInfott").datagrid({//数据表格
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
								{field:"logoUrl",title:"店铺Logo",width:70, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
									return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.logoUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />";  
									}
								},
								{field:"customerName",title:"店铺账号",width:70},
								{field:"shopName",title:"店铺名称",width:70},
								{field:"shopCategoryName",title:"店铺分类",width:70},
								{field:"companyName",title:"公司名称",width:70}
							]],
							pagination:true,//显示分页栏
							rownumbers:true,//显示行号
							singleSelect:true//true只可以选中一行
						});
						pageSplitThis(pageSize,queryParams,"shopInfott");
					}
				},"-",
				<% 
					}
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{//工具条
					text:"修改", 
					iconCls:"icon-edit",
					handler:function(){
						var options = $("#tt").datagrid("getPager").data("pagination").options;
						var currentPage = options.pageNumber;
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}
						if(rows[0].isPutSale==2){
							msgShow("系统提示", "<p class='tipInfo'>上架商品不能修改！</p>", "warning");
						}else if(rows.length==1){
							//window.open("${pageContext.request.contextPath}/back/productinfo/getProductInfoByProductId.action?productId="+rows[0].productId+"&currentPage="+currentPage,"newwindow","width="+(window.screen.availWidth-10)+",height="+(window.screen.availHeight-30)+ ", top=0,left=0,toolbar=no, menubar=yes, scrollbars=yes,fullscreen=yes, resizable=yes,location=yes, status=no");
							showEditWin(rows);
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
							msgShow("系统提示", "<p class='tipInfo'>请选择已下架商品！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(var i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].productId;
											else ids+=rows[i].productId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/productinfo/deleteProductAll.action",
										   data: {productIds:ids},
										   success: function(data){
											   if(data){
												   msgShow("系统提示", "<p class='tipInfo'>删除商品成功！</p>", "warning");
												   $("#tt").datagrid("clearSelections");//删除后取消所有选项
												   $("#tt").datagrid("reload");
											   }else{
												   msgShow("系统提示", "<p class='tipInfo'>删除商品失败！</p>", "warning");
											   }
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
				if("checked".equals((String)functionsMap.get(purviewId+"_checked"))){
				%>
				{//工具条
					text:"审核",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
						}else if(rows.length==1){
							var isPass = rows[0].isPass;
							if(isPass==2){//待申请
								msgShow("系统提示", "<p class='tipInfo'>此商品处于待申请状态，不能审核！</p>", "warning");
								return false;
							}
							$("#addOrEditWin").css("display","");
							$("#detailWin").css("display","none");
							$("#editProductWin").css("display","none");
							$("#merchandise_add").css("display","none");
							$("#updateRatioWin").css("display","none");
							var id = rows[0].productId;
							createWindow(1000,'auto',"&nbsp;&nbsp;审核","icon-tip",false,"addOrEditWin");
							$.ajax({
								type: "POST", dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoObject.action",
								data: {productId:id},
								success: function(data){
									var productInfo = data.productInfo;
									//var typeProduct = data.typeProduct;
									$("#isShow_"+productInfo.isShow).attr("checked",true);
									$("#productId").val(productInfo.productId);
									$("#isPutSale_"+productInfo.isPutSale).attr("checked",true);
									$("#isPass_"+productInfo.isPass).attr("checked",true);
									/*   $("#isTop_"+productInfo.isTop).attr("checked",true); */
									$("#isNew_"+productInfo.isNew).attr("checked",true);
									$("#isHot_"+productInfo.isHot).attr("checked",true);
									$("#isRecommend_"+productInfo.isRecommend).attr("checked",true);
									if(productInfo.isPass==0){
										$("#auditComment").val(productInfo.auditComment);
										$("#btMessage").html("<i class='ColorRed'>*</i>&nbsp;&nbsp;");
									}else{
										$("#btMessage").html("");
									}
									changeIsPass(productInfo.isPass);
									if(Number(productInfo.isPass)<3){//审核过
										document.getElementById("isPass_3").disabled="disabled";
									}else{
										document.getElementById("isPass_3").disabled="";
									}
								}
							});
						}
					}
				},"-",
				<%
				 }
				if("updateRatio".equals((String)functionsMap.get(purviewId+"_updateRatio"))){
				%>
				{text:"修改返利比例",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
						}else if(rows.length==1){
							var isPass = rows[0].isPass;
							if(isPass==2){//待申请
								msgShow("系统提示", "<p class='tipInfo'>此商品处于待申请状态，不能修改返利比例！</p>", "warning");
								return false;
							}
							var id = rows[0].productId;
							createWindow(600,'auto',"&nbsp;&nbsp;修改入驻店铺商品返利比例","icon-tip",false,"updateRatioWin");
							$("#addShopInfo").css("display","none");
							$("#merchandise_add").css("display","none");
							$("#detailWin").css("display","none");
							$("#showInListWin").css("display","none");
							$("#editProductWin").css("display","none");
							$("#addOrEditWin").css("display","none");
							$("#updateRatioWin").css("display","");
							$.ajax({
								type: "POST", dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoObject.action",
								data: {productId:id},
								success: function(data){
									var productInfo = data.productInfo;
									$("#ur_upRatio").val(productInfo.upRatio);
									$("#ur_secRatio").val(productInfo.secRatio);
									$("#ur_thiRatio").val(productInfo.thiRatio);
									$("#ur_productId").val(productInfo.productId);
								}
							});
						}
					}
				},"-",
				<%
				}
				if("pGeneratedQrCode".equals((String)functionsMap.get(purviewId+"_pGeneratedQrCode"))){
				%>
				{text:"批量生成二维码",
					iconCls:"icon-redo",
					handler:function(){
						$.messager.confirm("系统提示", "<p class='tipInfo'>您确定要重新生成二维码吗？</p>",function(data){
							if(data){//判断是否删除
								msgShow("系统提示", "<p class='tipInfo'>二维码生成中,请耐心等待！</p>", "warning");
								$.ajax({
									type: "POST", dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/productinfo/productInfoGeneratedQrCode.action",
									data: {shopInfoProductType:"2"},//1、平台基础商品；2 、平台店铺商品
									success: function(data){
										$(".messager-body").window('close');
										var failureLog2=data.failureLog2;
										var failureLog1=data.failureLog1;
										if(data.isSuccess){
											msgShow("系统提示", "<p class='tipInfo'>二维码已生成！</p>", "warning");
											$("#tt").datagrid("clearSelections");//删除后取消所有选项
										}else{
											if(failureLog1!=null&&failureLog1!=""){
												msgShow("系统提示", "<p class='tipInfo'>"+failureLog1+"</p>", "warning");
											}else if(failureLog2!=null&&failureLog2!=""){
												msgShow("系统提示", "<p class='tipInfo'>"+failureLog2+"</p>", "warning");
											}else{
												msgShow("系统提示", "<p class='tipInfo'>生成二维码失败！</p>", "warning");
											}
										}
									}
								});
							}
						});
					}
				},"-",
				<%
				}
				%>
				{
					text:"查询评价信息",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择商品！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							location.href="${pageContext.request.contextPath}/back/evalGoods/gotoProEvaluateGoods.action?productId="+rows[0].productId;
						}
					}
				},"-",
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
		//查询
		function query(){
			//queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,productCode:$("#qproductCode").val(),isPutSale:$("#qisPutSale").val(),isPass:$("#qisPass").val(),prodName:$("#qprodName").val(),shopName:$("#qshopName").val(),productTypeId:$("#qproductTypeId").val()};
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,sku:$("#qsku").val(),isPutSale:$("#qisPutSale").val(),isPass:$("#qisPass").val(),prodName:$("#qprodName").val(),shopName:$("#qshopName").val()};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		//三秒后刷新页面
		function reloadList(){
			//queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,productCode:$("#qproductCode").val(),isPutSale:$("#qisPutSale").val(),isPass:$("#qisPass").val(),prodName:$("#qprodName").val(),shopName:$("#qshopName").val(),productTypeId:$("#qproductTypeId").val()};
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,sku:$("#qsku").val(),isPutSale:$("#qisPutSale").val(),isPass:$("#qisPass").val(),prodName:$("#qprodName").val(),shopName:$("#qshopName").val()};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		function reset(){
			$("#qprodName").val("");
			//$("#qproductTypeId").val("");
			$("#qsku").val("");
			$("#qshopName").val("");
			$("#qisPutSale").val("");
			$("#qisPass").val("");
		}
		//初始化修改
		function showEditWin(rows){
			$("#addOrEditWin").css("display","none");
			$("#detailWin").css("display","none");
			$("#merchandise_add").css("display","none");
			$("#editProductWin").css("display","");
			$("#updateRatioWin").css("display","none");
			//重置表单 
			document.getElementById("e_photoForm").reset();
			document.getElementById("basicForm").reset();
			document.getElementById("proFunctionDescForm").reset();
			document.getElementById("productAttrForm").reset();
			document.getElementById("productParametersForm").reset();
			document.getElementById("productSourceImgForm").reset();
			document.getElementById("e_specificationsForm").reset();
			//删除分类的二、三级下拉框
			$("#e_productType-span-2").empty();
			$("#e_productType-span-3").empty();
			//删除品牌下拉框
			$("#e_brandTd").empty();
			//删除计量单位下拉框
			$("#e_measuringUnit").empty();
			//删除添加图片==>行
			$(".e_imgs").remove();
			//删除选择规格部分
			$("#e_specificationSelect").empty();
			//删除添加规格表表头部分
			$("#e_specificationProductTable-title").empty();
			//删除添加规格表的每一行
			$(".e_selectedSpecificationValuesTD").remove();
			//默认选中基本信息
			$("#editTab").tabs("select","基本信息");
			createWindow(1039,480,"&nbsp;&nbsp;修改入驻店铺商品","icon-edit",false,"editProductWin",10);
			/** 设置easyuiTabs的样式 begin**/
			$(".tabs-wrap").removeAttr("style");
			$(".tabs-wrap").attr("style","margin-left: 0px; margin-right: 0px; left: 0px; width:100%;");
			$(".setWidth").each(function(i) {
				$(this).removeAttr("style");
				$(this).attr("style","width: 994px; height: auto;");
			});
			/**设置easyuiTabs的样式 end**/
			$("#e_productImageTable .e_imgs").remove();
			$.ajax({
				type: "POST",dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoByProductId.action",
				data:{productId:rows[0].productId},
				async:false,
				success: function(data){
					if(data!=null){
						//商品详情
						/**KE编辑器获得光标 begin**/
						var addAndUpdateProductSum = $("#addAndUpdateProductSum").val();
						if(addAndUpdateProductSum!=null&&Number(addAndUpdateProductSum)==1){
							$(".ke-icon-fullscreen").click();
							$(".ke-icon-fullscreen").click();
							addAndUpdateProductSum = Number(addAndUpdateProductSum)+1;
						}
						$("#addAndUpdateProductSum").val(addAndUpdateProductSum);
						KindEditor.html("#e_functionDesc",data.productInfo.functionDesc);
						editor2.html(data.productInfo.functionDesc);
						/**KE编辑器获得光标 end**/
						//基本信息回显
						initProductBaseInfo(data.productInfo);
						//分类回显
						initProductType(data.productInfo.categoryLevel1,data.productInfo.categoryLevel2,data.productInfo.categoryLevel3,data.productInfo.categoryLevel4)
						//发货地址回显
						initAddressProvince(data.firstAreaList,data.secondAreaList,data.productInfo.deliveryAddressProvince,data.productInfo.deliveryAddressCities);
						//初始化店铺内部分类回显
						initShopProCategory(data.shopProCategoryList,data.selectshopProCategoryId);
						//品牌和计量单位回显
						initBrandAndMeasuringUnit(data.brandList,data.measuringUnitList,data.productInfo.brandId,data.productInfo.measuringUnitName);
						//参数属性初始化
						initProdAttAndProPara(data.listProductAttr,data.jattributeValueList,data.japaiList,data.productPara.info,data.productInfo.productAttributeValue,data.productInfo.productParametersValue);
						//初始化规格
						initSpecification(data.specificationList,data.productInfo.goods,data.productInfo.productId);
						//初始化图片
						initProductImg(data.productImgList);
					}
				}
			});
		}
    </script>

<script type="text/javascript">
	var editor1;
	var editor2;
	KindEditor.ready(function(K) {
		//编辑器1开始; 
		editor1 = K.create("#functionDesc", {
			cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
			uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subSys=shop",
			fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subSys=shop",
			allowFileManager : false,
			allowPreviewEmoticons : false,
			height:323,
			//设置编辑器为简单模式
			items : [
				'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'cut', 'copy', 'paste',
				'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
				'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
				'superscript', 'clearhtml', 'selectall', '|', 'fullscreen',
				'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
				'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image',
				'table', 'hr', 'emoticons', 'pagebreak', 'link', 'unlink'
			],
			afterCreate : function() {
				var self = this;
				K.ctrl(document, 13, function() {
					self.sync();
					K('form[name=myform]')[0].submit();
				});
				K.ctrl(self.edit.doc, 13, function() {
					self.sync();
					K('form[name=myform]')[0].submit();
				});
			}, 
			//下面这行代码就是关键的所在,当失去焦点时执行 this.sync();        
			afterBlur:function(){this.sync();},
		});
		//编辑器2开始; 
		editor2 = K.create("#e_functionDesc", {
			cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
			uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subSys=shop",
			fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subSys=shop",
			allowFileManager : false,
			allowPreviewEmoticons : false,
			height:323,
			//设置编辑器为简单模式
			items : [
				'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'cut', 'copy', 'paste',
				'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
				'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
				'superscript', 'clearhtml', 'selectall', '|', 'fullscreen',
				'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
				'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image',
				'table', 'hr', 'emoticons', 'pagebreak', 'link', 'unlink'
			],
			afterCreate : function() {
				var self = this;
				K.ctrl(document, 13, function() {
					self.sync();
					K('form[name=myform]')[0].submit();
				});
				K.ctrl(self.edit.doc, 13, function() {
					self.sync();             
					K('form[name=myform]')[0].submit();
				});
			}, 
			//下面这行代码就是关键的所在,当失去焦点时执行 this.sync();
			afterBlur:function(){this.sync();}
		});
	});
	//上传图片
	function uploadProductPhoto(method,imageInfoPath) {
		//添加上传提示信息，控制按钮不可用
			addProPhotoMessage(method);
			$(document).ready( function() {
				var options = {
					url : "${pageContext.request.contextPath}/back/upload/asyncUploadImage.action?imageInfoPath="+imageInfoPath,
					type : "post",
					dataType : "json",
					success : function(data) {
						//清空上传提示信息，恢复按钮可用
						clearProPhotoMessage(method);
						if (data.photoUrl == "false_error") {//上传文件错误，请重试！
							msgShow("系统提示","上传的图片失败，请重试！","error");
						}else if (data.photoUrl == "false_error1") {//上传文件错误，请重试！
							msgShow("系统提示","请选择要上传的图片！","error");
						}else if (data.photoUrl == "false_error2") {//上传文件错误，请重试！
							msgShow("系统提示","请确认图片类型为：.gif,.jpg,.jpeg,.png,.bmp格式；上传图片大小不超过2M。","error");
						}else if (data.photoUrl == "false_error3") {//上传文件错误，请重试！
							msgShow("系统提示",data.photoUrlErrorMessage,"error");
						}else {
							if(method=="add"){
								$("#logoImg").val(data.photoUrl);
								$("#smallPhoto").html("");
								$("#smallPhoto").html("<img style='padding-top:10px' src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='50px' height='50px' />");
							}else{
								$("#e_logoImg").val(data.photoUrl);
								$("#e_smallPhoto").html("");
								$("#e_smallPhoto").html("<img style='padding-top:10px' src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='50px' height='50px' />");
								
							}
						}
					}
				};
				if(method=="add"){
					$("#photoForm").ajaxSubmit(options);
				}else{
					$("#e_photoForm").ajaxSubmit(options);
				}
			});
	}
	//添加上传提示信息，控制按钮不可用
	function addProPhotoMessage(method){
		if(method=="add"){
			$("#mymessage").html("<font style='color:green'>文件提交中......</font>");//修改提示信息
			$("#buttonId").attr("disabled","true");//提交按钮不可用
		}else{
			$("#e_mymessage").html("<font style='color:green'>文件提交中......</font>");//修改提示信息
			$("#e_buttonId").attr("disabled","true");//提交按钮不可用
		}
	}
	
	//清空上传提示信息，恢复按钮可用
	function clearProPhotoMessage(method){
		if(method=="add"){
			$("#mymessage").html("");//清空提示信息
			$("#buttonId").removeAttr("disabled");//提交按钮恢复可用
		}else{
			$("#e_mymessage").html("");//清空提示信息
			$("#e_buttonId").removeAttr("disabled");//提交按钮恢复可用
		}
	}
</script>
  </head>
  
  <body>
  <jsp:include page="../../util/item.jsp"/>
  <div class="main">
	   <table class="searchTab">
			<tr>
				<%-- <td class="search_toright_td" style="width:65px;">商品分类：</td>
					<td class="search_toleft_td" style="width:80px;">
					<select id="qproductTypeId" style="width:100px;" class="querySelect">
						<option value="">--请选择分类--</option>
						<s:iterator value="#application.categoryMap" var="type1">
							<option value="<s:property value="#type1.key.productTypeId"/>" disabled="disabled" >
							<s:property value="#type1.key.sortName"/>
							<s:iterator value="#type1.value" var="type2">
								<option value="<s:property value="#type2.key.productTypeId"/>" disabled="disabled" >
									&nbsp;&nbsp;<s:property value="#type2.key.sortName"/>
									<s:iterator value="#type2.value" var="type3">
									<option value="<s:property value="#type3.key.productTypeId"/>" >
										&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type3.key.sortName"/>
										<s:iterator value="#type3.value" var="type4">
											<option value="<s:property value="#type4.productTypeId"/>" >
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type4.sortName"/>
										</s:iterator>
									</option>
									</s:iterator>	
								</option>
							</s:iterator>
							</option>
						</s:iterator>
					</select>
				</td> --%>
				<td class="search_toright_td"  style="width:75px;">商品名称：</td>
				<td class="search_toleft_td" style="width:80px;"><input type="text" style="width:90px;" id="qprodName" name="qprodName" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:60px;">店铺名称：</td>
				<td class="search_toleft_td" style="width:80px;"><input type="text" style="width:90px;" id="qshopName" name="qshopName" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:60px;">SKU号：</td>
				<td class="search_toleft_td" style="width:80px;"><input type="text" style="width:90px;" id="qsku" name="sku" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:60px;">是否上架：</td>
				<td class="search_toleft_td" style="width:80px;">
					<select id="qisPutSale" style="width:80px;" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="1">未上架</option>
						<option value="2">已上架</option>
						<option value="3">违规下架</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:60px;">审核状态：</td>
				<td class="search_toleft_td" style="width:80px;">
					<select id="qisPass" style="width:80px;" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">未通过</option>
						<option value="1">已通过</option>
						<option value="2">待申请</option>
						<option value="3">待审核</option>
					</select></td>
					
				<td class="search_toleft_td">&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
			<!-- 进入当前页面点击“添加和修改”按钮次数 -->
			<input type="hidden" id="addAndUpdateProductSum" value="1"/>
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditor.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detail.jsp"/>
			<!-- 添加商品 -->
			<jsp:include page="merchandise_add.jsp"/>
			<!-- 修改商品 -->
			<jsp:include page="edit_productInfo_main.jsp"/>
			<!-- 修改返利比例 -->
			<jsp:include page="updateRatio.jsp"></jsp:include>
		</div>
		</div>
	</body>
</html>
