<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>前台中间部分分类</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"前台中间部分分类列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/prosceniumCategory/listProsceniumCategory.action",
				queryParams:{pageSize:pageSize},
				idField:"prosceniumCategoryId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"title",title:"标题",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.prosceniumCategoryId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					}, 
					{field:"synopsis",title:"简介",width:120},
					{field:"sortName",title:"套餐分类",width:120},
					{field:'isShow',title:'是否显示',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>否</font>";} 
	                        if(value=="1"){ return "<font color='#0033FF'>是</font>";} 
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
						createWindow(800,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#photo").html("");
						$("#secondListHtml").html("");
						$("#addOrEditWin").css("display","");
						 $("#prosceniumCategoryId").val(null);
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
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>只能修改一项！</p>", "warning");
						}else{
							createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
			    			$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/prosceniumCategory/getProsceniumCategoryInfo.action",
								   data: {prosceniumCategoryId:rows[0].prosceniumCategoryId},
								   success: function(data){
									   var prosceniumCategory=data.prosceniumCategory;
									   $("#productTypeId").css("display","none");
								       $("#firstListHtml").html("");
								       $("#productTypeId").html("");
									   $("#prosceniumCategoryId").val(prosceniumCategory.prosceniumCategoryId);
								       $("#prosceniumCategoryUrl").val(prosceniumCategory.prosceniumCategoryUrl);
								       $("#title").val(prosceniumCategory.title);
								       $("#productTypeName").val(prosceniumCategory.productTypeName);
								       $("#secondProductTypeName").val(prosceniumCategory.secondProductTypeName);
								       $("#synopsis").val(prosceniumCategory.synopsis);
								       $("#interlinkage").val(prosceniumCategory.interlinkage);
								       $("#sortCode").val(prosceniumCategory.sortCode);
								       $("#photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+prosceniumCategory.prosceniumCategoryUrl+"' width='120px' height='120px' />");
								       $("#isShow_"+prosceniumCategory.isShow).attr("checked",true);
								       //拼接二级联动
								       var prodTypeList = eval(data.productTypeList);
								       var patId=data.productType.productTypeId;
								       if(prodTypeList.length>0){
							   				$("#firstListHtml").append("&nbsp;&nbsp;<select id='productTypeId' name='prosceniumCategory.productTypeId'  onchange='getSecondProdType()'>");
							   				$("#firstListHtml").append("</select> ");
							   				$("#productTypeId").append("<option value='-1'>---请选择---</option>");
							   				for(i=0;i<prodTypeList.length;i++){
							   					$("#productTypeId").append("<option <s:if test='"+prodTypeList[i].productTypeId+"=="+patId+"'>selected='selected'</s:if> value='"+prodTypeList[i].productTypeId+"'>"+prodTypeList[i].sortName+"</option>");
							   				}
							   				$("#productTypeId").val(prosceniumCategory.productTypeId);
								         }
										 $("#secondListHtml").html("");
										 //二级
											var prodTypeList2 = eval(data.productTypeList2);
									       var patId2=data.productType2.productTypeId;
											if(prodTypeList2.length>0){
								   				$("#secondListHtml").append("&nbsp;&nbsp;<select id='secondProdType'  name='prosceniumCategory.secondProductTypeId'>");
								   				$("#secondListHtml").append("</select>");
								   				$("#secondProdType").append("<option value='-1'>---请选择---</option>");
								   				for(i=0;i<prodTypeList2.length;i++){
								   					$("#secondProdType").append("<option <s:if test='"+prodTypeList2[i].productTypeId+"=="+patId2+"'>selected='selected'</s:if> value='"+prodTypeList2[i].productTypeId+"'>"+prodTypeList2[i].sortName+"</option>");
								   				}
							 		            $("#secondProdType").val(prosceniumCategory.secondProductTypeId);
									         }
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
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].prosceniumCategoryId;
											else ids+=rows[i].prosceniumCategoryId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/prosceniumCategory/deleteProsceniumCategory.action",
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
    
    
    	function query(){
    		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,brandName:$("#qbrandName").val()};
    	  	$("#tt").datagrid("load",queryParams); 
    	  	pageSplit(pageSize,queryParams);//调用分页函数 
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
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		   <!-- 详情 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
