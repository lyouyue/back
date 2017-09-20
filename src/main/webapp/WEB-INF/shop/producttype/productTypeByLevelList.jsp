<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
	<title>套餐分类列表信息</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
	function refreshIframe(){
		window.parent.location.reload();
	}
	
	$(function(){
		//表单验证
	$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
		var imageUrl1=$("#imageUrl1").val();
		var imageUrl2=$("#imageUrl2").val();
		var imageUrl3=$("#imageUrl3").val();
		if(imageUrl1 != null && imageUrl1 !='' || imageUrl2 != null && imageUrl2 !='' || imageUrl3!=null & imageUrl3!=''){
			if(imageUrl1 != null && imageUrl1 !=''){
				if(imageUrl2 != null && imageUrl2 !=''){
					if(imageUrl3 != null && imageUrl3 !=''){
						$(document).ready(
								function() {  
									var options = {  
										url : "${pageContext.request.contextPath}/back/productTypeTable/saveOrEditProductType.action",  
										type : "post",  
										dataType:"json",
										success : function(data) { 
											if(data.strFlag==true){
												closeWin();
												location.reload();
												refreshIframe();
												//$("#corp-tree").tree('reload');
												//window.location.href = "${pageContext.request.contextPath}/back/producttype/gotoProductTypePage.action?purviewId="+${purviewId}+"&productTypeId=${productTypeId}";
											}else{
												msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");  
												$("input.button_save").attr("disabled",false);//防止重复提交
											}
										}
									};
									$("#form1").ajaxSubmit(options); 
									$("input.button_save").attr("disabled","disabled");//防止重复提交
								});
					}else{
						$("#mymessage3").html("<font color='Red'>请上传APP图片!");
						if(imageUrl1 !=null && imageUrl1 !=''){}else{
							$("#mymessage1").html("<font color='Red'>请上传PC图片!</font>");
						}
						if(imageUrl2!=null && imageUrl2!=''){}else{
							$("#mymessage2").html("<font color='Red'>请上传微信图片!</font>");
						}
					}
				}else{
					$("#mymessage2").html("<font color='Red'>请上传微信图片!");
					if(imageUrl3 !=null && imageUrl3 !=''){}else{
						$("#mymessage3").html("<font color='Red'>请上传APP图片!</font>");
					}
				}
			}else{
				$("#mymessage1").html("<font color='Red'>请上传PC图片!</font>");
				if(imageUrl2 !=null && imageUrl2!=''){}else{
					$("#mymessage2").html("<font color='Red'>请上传微信图片!</font>");
				}
				if(imageUrl3 !=null && imageUrl3!=''){}else{
					$("#mymessage3").html("<font color='Red'>请上传APP图片!</font>");
				}
			}
		}else{
			$("#mymessage1").html("<font color='Red'>请上传PC图片!</font>");
			$("#mymessage2").html("<font color='Red'>请上传微信图片!</font>");
			$("#mymessage3").html("<font color='Red'>请上传APP图片!</font>");
		}
	}
});
		
	$("#tt").datagrid({//数据表格
		width:"auto",
		height:"auto",
		fitColumns: true,//宽度自适应
		align:"center",
		loadMsg:"正在处理，请等待......",
		//nowrap: false,//true是否将数据显示在一行
		striped: true,//true是否把一行条文化
		url:"${pageContext.request.contextPath}/back/productTypeTable/listProductType.action?productTypeId=${productTypeId}",
		idField:"productTypeId",//唯一性标识字段
		frozenColumns:[[//冻结字段
			{field:"ck",checkbox:true}
		]],
		columns:[[//未冻结字段
			{field:"sortName",title:"分类名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
				return "<a style='display:block;' id='"+rowData.productTypeId+"' onclick='showDetailInfo(this.id);'>"+rowData.sortName+"</a>";  
			}
			},
			{field:"categoryImage",title:"分类图片",width:65,formatter:function(value,rowData,rowIndex){
				return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='60px' height='30px' />";
			}
			},
			{field:"prodTypeNames",title:"所属分类",width:140},
			{field:"level",title:"当前分类级别",width:60,formatter:function(value,rowData,rowIndex){ 
				if(value==1) {
					return "一级分类";
				}else if(value==2) {
					return "二级分类";
				}else if(value==3) {
					return "三级分类";
				}
			}
			},
			{field:"isShow",title:"是否显示",width:60,formatter:function(value,rowData,rowIndex){ 
				if(value==0){
					return "<font class='color_002'>不显示</font>";
				}else if(value==1){
					return "<font class='color_001'>显示</font>";
				}
			}
			}, 
			{field:"isRecommend",title:"是否推荐",width:60,formatter:function(value,rowData,rowIndex){ 
				if(value==0) {
					return "<font class='color_002'>不推荐</font>";
				}else if(value==1) {
					return "<font class='color_001'>推荐</font>";
				}
			}
			}
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
					createWindow(900,430,"&nbsp;&nbsp;添加套餐分类","icon-add",false,"addOrEditWin"); 
					$("#detailWin").css("display","none");
					$("#addOrEditWin").css("display","");
					$("#form1")[0].reset();  //恢复初始化设置
					$("#parentId").val('${productTypeId}');
					$("#productTypeId").val("");
					$("#sortCode").val("");
					$("#sortName").val("");
					$("#sortAppName").val("");
					$("#categoryDescription").val("");
					$("#imageUrl1").val("");
					$("#imageUrl2").val("");
					$("#imageUrl3").val("");
					$("#fileId1").val("");
					$("#fileId2").val("");
					$("#fileId3").val("");
					$("#photo1").html("");
					$("#photo2").html("");
					$("#photo3").html("");
					$("#mymessage1").html("");
					$("#mymessage2").html("");
					$("#mymessage3").html("");
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
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
					}else if(rows.length==1){
						$.ajax({
							type: "POST", dataType: "JSON",
							url: "${pageContext.request.contextPath}/back/productTypeTable/getProductTypeObject.action",
							data: {productTypeId:rows[0].productTypeId},
							success: function(data){
								createWindow(900,430,"&nbsp;&nbsp;修改套餐分类","icon-edit",false,"addOrEditWin",10);
								$("#detailWin").css("display","none");//隐藏修改窗口
								$("#addOrEditWin").css("display","");
								$("#productTypeId").val(data.productTypeId);
								$("#parentId").val(data.parentId);
								$("#sortName").val(data.sortName);
								$("#sortAppName").val(data.sortAppName);
								$("#sortCode").val(data.sortCode);
								//$("#floor").val(data.floor);
								$("#level").val(data.level);
								$("#loadType").val(data.loadType);
								$("#categoryDescription").val(data.categoryDescription);
								$("#imageUrl1").val(data.categoryImage);
								$("#photo1").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
								$("#imageUrl2").val(data.categoryImageWx);
								$("#photo2").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageWx+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
								$("#imageUrl3").val(data.categoryImageApp);
								$("#photo3").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageApp+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
								$("#isShow_"+data.isShow).attr("checked",true);
								$("#isRecommend_"+data.isRecommend).attr("checked",true);
							}
						});
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
				if(rows.length==0){
					msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
				}else if(rows.length>1){//超过了一个选择项
					msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
				}else if(rows.length==1){
					$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
						if(data){//判断是否删除
							if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
								$.ajax({
									type: "POST",dataType: "JSON",
									url: "${pageContext.request.contextPath}/back/productTypeTable/delProductType.action",
									data: {productTypeId:rows[0].productTypeId},
									success: function(data){
										$("#tt").datagrid("clearSelections");//删除后取消所有选项
										if(data.isSuccess=="true"){
											msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
											location.reload();
										}else{
											msgShow("系统提示", "<p class='tipInfo'>此分类下面还有子分类，请先删除子分类！</p>", "warning");  
										}
										refreshIframe();
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
		if("queryBrand".equals((String)functionsMap.get(purviewId+"_queryBrand"))){
		%>
		{
			text:"查询机构",
			iconCls:"icon-search",
			handler:function(){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==0){//没有选择修改项
					msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
				}if(rows.length>1){//超过了一个选择项
					msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
				}else if(rows.length==1){
					window.location.href="${pageContext.request.contextPath}/back/brandtype/gotoBrandListByProductTypeId.action?productTypeId="+rows[0].productTypeId+"&level="+rows[0].level;
				}
			}
		},"-",
		<%
		}
		String type_level= request.getAttribute("type_level").toString();
		String level = request.getAttribute("level").toString();
		if(Integer.parseInt(type_level)==(Integer.parseInt(level)+1)){
			if("queryProduct".equals((String)functionsMap.get(purviewId+"_queryProduct"))){
			%>
			{
				text:"查询套餐",
				iconCls:"icon-search",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
					}else if(rows.length==1){
						location.href="${pageContext.request.contextPath}/back/producttype/gotoProductInfoListByProductTypeId.action?productTypeId="+rows[0].productTypeId;
					}
				}
			},"-",
			<%
			}
			if("queryMeasuringUnit".equals((String)functionsMap.get(purviewId+"_queryMeasuringUnit"))){
			%>
			{
				text:"查询计量单位",
				iconCls:"icon-search",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
					}else if(rows.length==1){
						location.href="${pageContext.request.contextPath}/back/productMeasuringUnit/gotoProductMeasuringUnitListByProductTypeId.action?productTypeId="+rows[0].productTypeId;
					}
				}
			},"-",
			<%
			}
		}
		if("init".equals((String)functionsMap.get(purviewId+"_init"))){
			%>
			{
				text:"同步套餐分类",
				iconCls:"icon-reload",
				handler:function(){
					$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步套餐分类到系统内存中吗?</p>",function(data){
						if(data){//判断是否删除
							$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
							$("<div class=\"datagrid-mask-msg\"></div>").html("正在同步，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
							$.ajax({
								type: "POST",dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/producttype/initProdutTypeInfo.action",
								async:false,//false同步;true异步
								success: function(data){
									$("body").children("div.datagrid-mask-msg").remove();
									$("body").children("div.datagrid-mask").remove();
									if(data.isSuccess=="true") {
										msgShow("系统提示", "<p class='tipInfo'>同步成功！</p>", "warning");
									}else{
										msgShow("系统提示", "<p class='tipInfo'>同步失败，请重试！</p>", "warning");
									}
								}
							});
						}
					});
					//获取前台更新初始化信息url
					var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
					var split=prefixUrl.split("@");
					//更新前台套餐分类信息
					var url=split[0]+"back/producttype/initProdutTypeInfo.action?callback=?";
					//获取手机更新初始化信息url
					var prefixUrl_phone='${fileUrlConfig.phoneBasePath}';
					var split_phone=prefixUrl_phone.split("@");
					//更新前台套餐分类信息
					var url_phone=split_phone[0]+"back/producttype/initProdutTypeInfo.action?callback=?";
					//更新前台套餐分类信息
					$.getJSON(url);
					//更新手机套餐分类信息
					$.getJSON(url_phone);
					//msgShow("系统提示", "<p class='tipInfo'>分类初始化信息更新成功！</p>", "warning");
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
		pageSplit();//调用分页函数
	});

	function showDetailInfo(id){
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/productTypeTable/getProductTypeObject.action",
			data: {productTypeId:id},
			dataType: "JSON",
			success: function(data){
				createWindow(800,420,"&nbsp;&nbsp;套餐分类详情","icon-add",false,"detailWin",10);
				$("#addOrEditWin").css("display","none");
				$("#detailWin").css("display","");
				$("#dproductTypeId").html(data.productTypeId);
				$("#dsortName").html(data.sortName);
				$("#dsortAppName").html(data.sortAppName);
				$("#dlevel").html(data.level);
				$("#dsortCode").html(data.sortCode);
				$("#dcategoryDescription").html(data.categoryDescription);
				if(data.isShow==0){
					$("#disShow").html("<font class='color_002'>不显示</font>");
				}else if(data.isShow==1){
					$("#disShow").html("<font class='color_001'>显示</font>");
				}
				if(data.isRecommend==0){
					$("#disRecommend").html("<font class='color_002'>不推荐</font>");
				}else if(data.isRecommend==1){
					$("#disRecommend").html("<font class='color_001'>推荐</font>");
				}
				$("#dcategoryImage").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
				$("#dcategoryImageWx").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageWx+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
				$("#dcategoryImageApp").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageApp+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
			}
		});
	}
	
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,productTypeName:$.trim($("#qproductTypeName").val())};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数
	}
	
	function reset(){
		$("#qproductTypeName").val("");
	}
	
</script>
</head>
<body>
	<table class="searchTab">
		<tr>
			<td class="search_toright_td"  style="width:83px;">&nbsp;&nbsp;&nbsp;&nbsp;分类名称：</td>
			<td class="search_toleft_td">
				<input type="text" id="qproductTypeName"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
				<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
			</td>
			<td></td>
		</tr>
	</table>
	<table id="tt"></table>
	<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<!-- 添加或者修改 -->
		<jsp:include page="addOrEditor.jsp"/>
		<!-- 详情页 -->
		<jsp:include page="detail.jsp"/>
	</div>
</body>
</html>
