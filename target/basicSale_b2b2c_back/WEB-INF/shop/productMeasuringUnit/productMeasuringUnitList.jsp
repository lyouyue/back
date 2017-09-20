<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>计量单位信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"商品计量单位列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/productMeasuringUnit/listProductMeasuringUnitByProductTypeId.action?productTypeId=${productTypeId}",
				queryParams:{pageSize:pageSize},
				idField:"measuringUnitId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"name",title:"计量单位名称",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(700,500,"&nbsp;&nbsp;添加计量单位","icon-add",false,"addOrEditWin");
						$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/productMeasuringUnit/findTypeMeasuringUnit.action",
							   data: {productTypeId:'${productTypeId}'},
							   success: function(data){
								   var list = eval(data);
								   var html="<table align='center' class='addOrEditTable' width='100%'>";
								   for(var i=0;i<list.length;i++){
									   if((i+1)%4==1){
											html+="<tr>";
										}
									   html+="<td width='25%'><input type='checkbox' name='measuringUnitIds' value='"+list[i].measuringUnitId+"'\/>&nbsp;&nbsp;&nbsp;&nbsp;"+list[i].name+"</td>";
									   if((i+1)%4==0){
											html+="</tr>";
										}else{
											if((i+1)==list.length){
												html+="</tr>";
											}
										}
								   }
								   html+="</table>";
								   $("#showMeasuringUnitList").html(html);
							   }
							});
					}
				},"-",{
					text:"删除", 
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
								$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var productTypeId = '${productTypeId}';
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/productMeasuringUnit/deleteProductMeasuringUnit.action?productTypeId=${productTypeId}",
										   data: {measuringUnitId:rows[0].measuringUnitId,productTypeId:productTypeId},
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
					text:"返回商品分类",
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
    
    </script>
  </head>
  
  <body>
	<%-- <jsp:include page="../../util/item.jsp"/>
	<div class="main"> --%>
		<!-- <table class="searchTab">
		</table> -->
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<jsp:include page="addProductMeasuringUnit.jsp"/>
		</div>
	<!-- </div> -->
  </body>
</html>
