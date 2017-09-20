<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<title>入驻店铺内部分类信息</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
	$(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"自营店铺内部分类列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/selfSupportShopProCategory/getSelfSupportShopProCategoryList.action?shopInfoId=${shopInfoId}",
				queryParams:{pageSize:pageSize},
				idField:"shopProCategoryId",//唯一性标示字段
				frozenColumns:[[//冻结字段
					 {field:"ck",checkbox:true}
							]],
				columns:[[//未冻结字段
					{field:"shopProCategoryName",title:"分类名称",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.shopProCategoryId+"' onclick='showDetailInfo(this.id);'>"+rowData.shopProCategoryName+"</a>";  
		         	  	}
					}, 
					{field:"sortCode",title:"排序号",width:100},
					{field:"isShow",title:"是否显示",width:30,
						formatter:function(value,rowData,rowIndex){
							   if(value==0){
								    return"<font class='color_002'>否</font>";
							   }else{
								    return"<font class='color_001'>是</font>";
							   }
						}
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						$("#photo1").html("");
						createWindow(1000,"auto","&nbsp;&nbsp;添加入驻店铺内部分类","icon-add",false,"addOrEditWin");
						$("#ushopInfoId").val(${shopInfoId});
						$("#ushopProCategoryId").val("");
					}
				},"-",
				{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							$("#fileId1").val("");
							createWindow(1000,"auto","&nbsp;&nbsp;修改入驻店铺内部分类","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/selfSupportShopProCategory/getObjectById.action",
							   data: {shopProCategoryId:rows[0].shopProCategoryId},
							   success: function(data){
								   $("#ushopInfoId").val(data.shopProCategory.shopInfoId);
								   $("#ushopProCategoryId").val(data.shopProCategory.shopProCategoryId);
							   	   $("#ushopProCategoryName").val(data.shopProCategory.shopProCategoryName);
							   	   $("#usortCode").val(data.shopProCategory.sortCode);
							   	   $("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.shopProCategory.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='129px' height='50px' />");
							   	   $("#ucategoryDescription").val(data.shopProCategory.categoryDescription);
							   	   $("#imageUrl1").val(data.shopProCategory.categoryImage);
							   	   $("#uisShow_"+data.shopProCategory.isShow).attr("checked",true);
							   }
							});	   
						}
					}
				} ,"-",
				{//工具条
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
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].shopProCategoryId;
											else ids+=rows[i].shopProCategoryId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/selfSupportShopProCategory/deleteSelfSupportShopProCategpry.action",
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
				{
					text:"返回入驻店铺列表",
					iconCls:"icon-back",
					handler:function(){//回调函数  
						location.href="${pageContext.request.contextPath}/back/shopinfo/gotoShopInfoPage.action";
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
	
	//详情
	function showDetailInfo(id){
		createWindow(700,"auto","&nbsp;&nbsp;自营入驻内部分类详情","icon-tip",false,"detailWin");
		$.ajax({
		  	   type: "POST",
			   url: "${pageContext.request.contextPath}/back/selfSupportShopProCategory/getObjectById.action",
			   data: {shopProCategoryId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dshopProCategoryName").html(data.shopProCategory.shopProCategoryName);
				   $("#dsortCode").html(data.shopProCategory.sortCode);
				   if(data.shopProCategory.isShow=="0"){
					   $("#disShow").html("<font class='color_002'>否</font>");
				   }else if(data.shopProCategory.isShow=="1"){
					   $("#disShow").html("<font class='color_001'>是</font>");
				   };
				   $("#dcategoryImage").html("<img style='padding-top:10px'  src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.shopProCategory.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='153px' height='50px' />");
				   $("#dcategoryDescription").html(data.shopProCategory.categoryDescription);
				   //处理附件 的显示 end 
				    $("#tt").datagrid("reload");//查看详情后，重新加载列表
			   }
			});
		}
	
		function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,groupName:$("#groupName").val(),isDefaultGroup:$("#isDefaultGroup").val()};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		
		function reset(){
		   	$("#groupName").val("");
		   	$("#isDefaultGroup").val("");
		 }
	</script>
	</head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<!-- <table class="searchTab">
		</table><br/> -->
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
		<!-- 详情页 -->
			<jsp:include page="detailContract.jsp"/>
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditContract.jsp"/>
		</div>
		<!--  -->	
		</div>
	</body>
</html>
