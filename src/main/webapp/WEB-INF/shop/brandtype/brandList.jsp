<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>套餐品牌信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"套餐品牌列表信息",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/brandtype/listBrandByProductTypeId.action?productTypeId=${productTypeId}",
				queryParams:{pageSize:pageSize},
				idField:"brandId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"brandBigImageUrl",title:"品牌图片",width:120,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='25' height='25' />";
						}
					},
					{field:"brandName",title:"品牌名称",width:120},
					{field:"isShow",title:"是否显示",width:100,
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font class='color_001'>是</font>";}
	                        else{ return "<font class='color_002'>否</font>";}
                         }
	              	},
					{field:"isRecommend",title:"是否推荐",width:100,
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font class='color_001'>是</font>";}
	                        else{ return "<font class='color_002'>否</font>";}
                         }
	              	},
					{field:"isHomePage",title:"是否首页显示",width:100,
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font class='color_001'>是</font>";}
	                        else{ return "<font class='color_002'>否</font>";}
                         }
	              	},
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[{
					text:"添加分类品牌",
					iconCls:"icon-add",
					handler:function(){
						$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/brandtype/findTypeBrand.action",
							   data: {productTypeId:'${productTypeId}'},
							   success: function(data){
								   var sb=$("#sb").val("A");
								   $("#firstWord_"+sb).removeAttr("class");
								   $("#firstWord_A").attr("class","onFirstWord");
									var list = data.list;
									var firstWordList = data.firstWordList;
									 var html="";
									   html="<table class='addOrEditTable' width='100%'>";
										for(var i=0;i<list.length;i++){
											if((i+1)%4==1){
												html+="<tr>";
											}
											html+="<td width='25%'><input type='checkbox' name='brandIds' value='"+list[i].brandId+"'\/>&nbsp;&nbsp;&nbsp;&nbsp;"+list[i].brandName+"</td>";
											if((i+1)%4==0){
												html+="</tr>";
											}else{
												if((i+1)==list.length){
													html+="</tr>";
												}
											}
										}
										html+="</table>"; 
									$("#showBrandList").html(html);
									createWindow(910,450,"&nbsp;&nbsp;添加分类品牌","icon-add",false,"addOrEditWin",20);
								}
							});
					}
				},"-",{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够删除一项！</p>", "warning");
						}else if(rows.length==1){
								$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/brandtype/deleteBrandType.action?productTypeId=${productTypeId}",
										   data: {brandId:rows[0].brandId},
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
				},"-",{
					text:"更改显示状态",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择更改项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要更改吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].brandTypeId;
											else ids+=rows[i].brandTypeId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/brandtype/updateIsShowState.action",
										   data: {brandTypeId:ids},
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
				String level = request.getAttribute("level").toString();
				if(Integer.parseInt(level)!=1){
				%>
				{
					text:"复制上级分类品牌",
					iconCls:"icon-save",
					handler:function(){
						$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要复制吗?</p>",function(data){
							$.ajax({
								type: "POST",dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/brandtype/copyParentProductType.action",
								data: {productTypeId:"${productTypeId}"},
								success: function(data){
									if(data.isSuccess)$("#tt").datagrid("reload"); //删除后重新加载列表
								}
							});
						});
					}
				},"-",
				<%
				}
				%>
				{
					text:"返回套餐分类",
					iconCls:"icon-back",
					handler:function(){
						//location.href="${pageContext.request.contextPath}/back/producttype/gotoProductTypePage.action";
						window.location.href = document.referrer;
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});

	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,brandName:$("#qbrandName").val(),isShow:$("#qisShow").val()};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数
	}
	function reset(){
		$("#qbrandName").val("");
		$("#qisShow").val("");
	}
	</script>
  </head>

<body>
	<%-- <jsp:include page="../../util/item.jsp"/> --%>
	<!-- <div class="main"> -->
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width: 80px;">品牌名称：</td>
				<td class="search_toleft_td" style="width:150px;"><input type="text" id="qbrandName" name="s_brandName" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width: 60px;">是否显示</td>
				<td class="search_toleft_td" style="width: 110px;">
					<select id="qisShow" class="querySelect">
						<option value="">--请选择--</option>
						<option value="0">--否--</option>
						<option value="1">--是--</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<jsp:include page="addBrandType.jsp"/>
		</div>
	<!-- </div> -->
</body>
</html>
