<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>套餐规格列表信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
    		var defHtml="";
		   $("#tt").datagrid({//数据表格
				/* title:"套餐规格列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/specification/listSpecification.action",
				queryParams:{pageSize:pageSize},
				idField:"specificationId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"name",title:"规格名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.specificationId+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";  
		         	  }  
					}, 
                 	{field:"productTypeName",title:"套餐分类",width:120},
					/* {field:'type',title:'规格类型',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "文本";} 
	                        if(value=="1"){ return "图片";} 
                            }
                 	}, */
                 	{field:"notes",title:"规格备注",width:120},
					{field:"sort",title:"排序号",width:120}
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
						createWindow(950,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#ggz").css("display","");
						$("#specificationId").val(null);
						var num=$("#tr_model tr").length;
						if(num==2){
							if(defHtml==""){
								defHtml=$("#tr_model").html();
							}
						}else{
							$("#tr_model").html(defHtml);
						}
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
							createWindow(900,'auto',"&nbsp;&nbsp;修改规格","icon-edit",false,"addOrEditWin");
							$("#ggz").css("display","none");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/specification/getSpecificationInfo.action",
							   data: {specificationId:rows[0].specificationId},
							   success: function(data){
								   $("#name").val(data.specification.name);
								   $("#notes").val(data.specification.notes);
								   $("#sort").val(data.specification.sort);
								   $("#productTypeId").val(data.specification.productTypeId);
								   $("#firstListHtml").html("");
								   $("#specificationId").val(data.specification.specificationId);
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
											if(i==rows.length-1)ids+=rows[i].specificationId;
											else ids+=rows[i].specificationId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/specification/deleteSpecification.action",
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
				if("findSpecificationValueList".equals((String)functionsMap.get(purviewId+"_findSpecificationValueList"))){
				%>
				{
					text:"查看规格值", 
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							//表单提交维护广告配置的标签参数
							$("#specificationName").val(rows[0].name);
							$("#specificationId").val(rows[0].specificationId);
							$("#formSpecificationPar").submit();
						}
					}
				},"-",
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
    
    function checkOrder(obj){
		if(!/^\d+$/.test(obj.value)){
			obj.value="0";
		}else if(obj.value.length>5){
			obj.value="0";
		}
	}
    
	function query(){
		 queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,productTypeName:$.trim($("#qproductTypeName").val()),specificationName:$.trim($("#qspecificationName").val())};
		 $("#tt").datagrid("load",queryParams); 
		 pageSplit(pageSize,queryParams);//调用分页函数
	}
	
	function reset(){
		$("#qspecificationName").val("");
       	$("#qproductTypeName").val("");
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
	<jsp:include page="../../util/item.jsp"/>
	<form action="${pageContext.request.contextPath}/back/specification/findSpecificationValueListBySpecificationId.action" method="post" id="formSpecificationPar">
		<input id="specificationId" type="hidden" name="specificationId"/>
		<input id="specificationName" type="hidden" name="name"/>
	</form>
	<div class="main">
		<table class="searchTab">
		<tr>
				<td class="search_toright_td"  style="width:83px;">规格名称：</td>
				<td class="search_toleft_td" style="width: 145px;">
					<input type="text" id="qspecificationName"/>
				</td>
				<td class="search_toright_td" style="width:105px;">套餐分类名称：</td>
				<td class="search_toleft_td" style="width:170px;"><input type="text" id="qproductTypeName"/></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditor.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detail.jsp"/>
		</div>
		</div>
  </body>
</html>
