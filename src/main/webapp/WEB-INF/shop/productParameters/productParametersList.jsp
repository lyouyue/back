<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>套餐详细参数</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
	$(function(){
		$("#tt").datagrid({//数据表格
			/* title:"套餐详细参数列表信息:<font color='blue'>${name}</font>",
			iconCls:"icon-save",  */
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/productParameters/listProductParameters.action?productTypeId=${productTypeId}",
			queryParams:{pageSize:pageSize},
			idField:"paramGroupId",//唯一性标示字段
			frozenColumns:[[//冻结字段
				{field:"ck",checkbox:true}
			]],
			columns:[[//未冻结字段
				{field:"name",title:"参数组名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return "<a style='display:block;cursor: pointer;' id='"+rowData.paramGroupId+"' onclick='showDetailInfo("+rowData.productParametersId+","+rowData.paramGroupId+");'>"+rowData.name+"</a>";  
					}
				}, 
				{field:"prodTypeNames",title:"分类名称",width:120},
				{field:"order",title:"排序号",width:120}
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
					createWindow(900,450,"&nbsp;&nbsp;添加套餐参数","icon-add",false,"addOrEditWin");
					$("#detailWin").css("display","none");
					$("#addOrEditWin").css("display","");
					$("#btnSave").attr("onclick","$('#form1').submit();");//设置保存可用
					$("#productParametersId").val("");
					$("#productTypeId").val('${productTypeId}');
					//看该参数是否已经添加参数
					$.ajax({
						url:"${pageContext.request.contextPath}/back/productParameters/getPorductParameters.action",
						type:"post",
						dataType:"json",
						data:{productTypeId:${productTypeId}},
						success:function(data){
							var index=0;
							var infoIndex=0;
							$(".e_parazv").remove();
							$(".groupInfo").empty();
							if(data!=null){
								$("#productParametersId").val(data.productParametersId);
								$("#productTypeId").val(data.productTypeId);
								$("#sort").val(data.sort);
								var infoObj=eval(data.info);
								if(infoObj!=null&&infoObj!=""){
									var trHtml ='';
									for(var i=0;i<infoObj.length;i++){
										var a =eval(infoObj[i].paramGroupInfo);
										trHtml+= "<tr class='e_parazv' style='display:none;'><td>"
										trHtml+="<input type='hidden' name='listParamGroup[" + index + "].name' value='"+infoObj[i].name+"'/>";
										trHtml+="<input type='hidden'  name='listParamGroup[" + index + "].paramGroupId' value='"+infoObj[i].paramGroupId+"'/>";
										trHtml+="<input type='hidden' name='listParamGroup[" + index + "].order' value='"+infoObj[i].order+"'/>";
										for(var u=0;u<a.length;u++){
											trHtml+="<input type='hidden' name='listParamGroupInfo[" +infoIndex + "].name' value='"+a[u].name+"'/> ";
											trHtml+="<input type='hidden' name='listParamGroupInfo[" +infoIndex+ "].pgiId' value='"+a[u].pgiId+"'/>";
											trHtml+="<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].pgInfoId' value='"+a[u].pgInfoId+"'/>";
											trHtml+="<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].order' value='"+a[u].order+"'/>" ;
											infoIndex++;
										}
										trHtml+= "</td></tr>";
										index++;
									}
									$("#appendTable").append(trHtml);
								}
							}
							/******** 初始化参数组添加  begin ********/
							var paramGroupParamGroupId=RndNum();//参数组随机数
							var pgInfoId = RndNum();//参数id随机数
							var paraGroupNameHtml = "<input type='text' class='{validate:{required:true}}' name='listParamGroup[" + index + "].name' value=''/>";
							paraGroupNameHtml += "<input type='hidden'  name='listParamGroup[" + index + "].paramGroupId' value='"+paramGroupParamGroupId+"'/>";
							var paraGroupSortHtml = "<input type='text' class='{validate:{required:true,digits:true}}' name='listParamGroup[" + index + "].order' value='' style='width: 50px;'/>";
							$("#paraGroupName").append(paraGroupNameHtml);
							$("#paraGroupSort").append(paraGroupSortHtml);
							var trHtml2 = "<tr class='e_parazv parameterInfoTable'>"
								trHtml2 += "<td align='center'><input type='text' name='listParamGroupInfo[" + infoIndex + "].order' value='"+getMaxSortNum('paramSort')+"' style='width: 50px;' class='{validate:{required:true,digits:true,maxlength:[2]}} paramSort'/></td>";
								trHtml2 += "<td colspan='2' align='center'>";
								trHtml2 += "<input type='text' name='listParamGroupInfo[" + infoIndex + "].name' class='{validate:{required:true}}'/> ";
								trHtml2 += "<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].pgiId'  value='"+paramGroupParamGroupId+"'/>";
								trHtml2 += "<input type='hidden'  name='listParamGroupInfo[" + infoIndex + "].pgInfoId' value='"+pgInfoId+"'/>";
								trHtml2 += "</td>";
								trHtml2 +="<td><a href='javascript:;' id='" + infoIndex + "' name='"+paramGroupParamGroupId+"' class='addParamGroupInfo'>[添加参数]</a></td>" ;
								trHtml2 +="</tr>";
							$("#appendTable").append(trHtml2);
							index++;
							infoIndex++;
							$("#parameterIndex").val(index);
							$("#parameterInfoIndex").val(infoIndex);
							/******** 初始化参数组添加   end ********/
						}
					});
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
					var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
					}else if(rows.length==1){
						var paramGroupId = rows[0].paramGroupId;
						createWindow(900,450,"&nbsp;&nbsp;修改套餐参数","icon-edit",false,"addOrEditWin");
						$("#detailWin").css("display","none");
						$("#addOrEditWin").css("display","");
						$("#btnSave").attr("onclick","$('#form1').submit();");//设置保存可用
						$.ajax({
							type: "POST", dataType: "JSON",
							url: "${pageContext.request.contextPath}/back/productParameters/getPorductParametersInfo.action",
							data: {productParametersId:rows[0].productParametersId},
							success: function(data){
								var productParameters = data.productParameters;
								$("#productParametersId").val(productParameters.productParametersId);
								$("#productTypeId").val(productParameters.productTypeId);
								$("#sort").val(productParameters.sort);
								$(".e_parazv").remove();
								$(".groupInfo").empty();
								var infoObj=eval(productParameters.info);
								var index=0;
								var infoIndex=0;
								var flag = false;
								if(infoObj!=null&&infoObj!=""){
									var trHtml ='';
									var trHtml2 ='';
									var listParamGroupName = '';
									var listParamGroupOrder = '';
									var listParamGroupParamGroupId = '';
									var paramGroupInfoList = '';
									for(var i=0;i<infoObj.length;i++){
										if(Number(infoObj[i].paramGroupId)==Number(paramGroupId)){//当前组
											flag = true;
											listParamGroupName = infoObj[i].name;
											listParamGroupOrder = infoObj[i].order;
											listParamGroupParamGroupId = infoObj[i].paramGroupId;
											paramGroupInfoList =eval(infoObj[i].paramGroupInfo);
										}else{
											var a =eval(infoObj[i].paramGroupInfo);
											trHtml2+= "<tr class='e_parazv' style='display:none;'><td>"
											trHtml2+="<input type='hidden' name='listParamGroup[" + index + "].name' value='"+infoObj[i].name+"'/>";
											trHtml2+="<input type='hidden'  name='listParamGroup[" + index + "].paramGroupId' value='"+infoObj[i].paramGroupId+"'/>";
											trHtml2+="<input type='hidden' name='listParamGroup[" + index + "].order' value='"+infoObj[i].order+"'/>";
											for(var u=0;u<a.length;u++){
												trHtml2+="<input type='hidden' name='listParamGroupInfo[" +infoIndex + "].name' value='"+a[u].name+"'/> ";
												trHtml2+="<input type='hidden' name='listParamGroupInfo[" +infoIndex+ "].pgiId' value='"+a[u].pgiId+"'/>";
												trHtml2+="<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].pgInfoId' value='"+a[u].pgInfoId+"'/>";
												trHtml2+="<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].order' value='"+a[u].order+"'/>" ;
												infoIndex++;
											}
											trHtml2+= "</td></tr>";
											index++;
										}
									}
									$("#appendTable").append(trHtml2);
									if(flag){//当前选中的参数组不为空
										var paraGroupNameHtml = "<input type='text' class='{validate:{required:true}}' name='listParamGroup[" + index + "].name' value='"+listParamGroupName+"'/>";
										paraGroupNameHtml += "<input type='hidden'  name='listParamGroup[" + index + "].paramGroupId' value='"+listParamGroupParamGroupId+"'/>";
										var paraGroupSortHtml = "<input type='text' class='{validate:{required:true,digits:true}}' name='listParamGroup[" + index + "].order' value='"+listParamGroupOrder+"' style='width: 50px;'/>";
										$("#paraGroupName").append(paraGroupNameHtml);
										$("#paraGroupSort").append(paraGroupSortHtml);
										if(paramGroupInfoList!=null&&paramGroupInfoList.length>0){
											for(var u=0;u<paramGroupInfoList.length;u++){
												trHtml+= "<tr class='e_parazv parameterInfoTable'>"
												trHtml+="<td align='center'><input type='text' name='listParamGroupInfo[" + infoIndex + "].order' value='"+paramGroupInfoList[u].order+"' style='width: 50px;' class='{validate:{required:true,digits:true,maxlength:[2]}} paramSort'/></td>";
												trHtml+="<td colspan='2' align='center'>";
												trHtml+="<input type='text' class='{validate:{required:true}}' name='listParamGroupInfo[" +infoIndex + "].name' value='"+paramGroupInfoList[u].name+"'/>";
												trHtml+="<input type='hidden' name='listParamGroupInfo[" +infoIndex+ "].pgiId' value='"+paramGroupInfoList[u].pgiId+"'/>";
												trHtml+="<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].pgInfoId' value='"+paramGroupInfoList[u].pgInfoId+"'/>";
												trHtml+="</td>";
												if(u>0){
													trHtml+="<td><a href='javascript:;' class='deteleParamGroupInfo'>[删除]</a></td>" ;
												}else{
													trHtml+="<td><a href='javascript:;' id='" + infoIndex + "' name='"+listParamGroupParamGroupId+"' class='addParamGroupInfo'>[添加参数]</a></td>" ;
												}
												trHtml+= "</tr>";
												infoIndex++;
											}
										}
										index++;
									}
									$("#appendTable").append(trHtml);
								}
								$("#parameterIndex").val(index);
								$("#parameterInfoIndex").val(infoIndex);
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
									$.ajax({
										type: "POST",dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/productParameters/deleteProductParameters.action",
										data: {ids:rows[0].productParametersId,paramGroupId:rows[0].paramGroupId},
										success: function(data){
											$("#tt").datagrid("clearSelections");//删除后取消所有选项
											if(data.isSuccess)$("#tt").datagrid("reload"); //删除后重新加载列表
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
					$("#tt").datagrid("clearSelections");//删除后取消所有选项
					$("#tt").datagrid("reload");
				}
			}
			]
		});
		pageSplit(pageSize);//调用分页函数
	});
	//删除套餐参数
	function deleteProductParameter(productParametersId){
		$.ajax({
			type: "POST",dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/productParameters/deleteProductParameters.action",
			data: {ids:productParametersId},
			success: function(data){
				$("#tt").datagrid("clearSelections");//删除后取消所有选项
				if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
			}
		});
	}
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,paramName:$("#qprodName").val()};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数
	}
	</script>
</head>
  <body >
		<!-- <table class="searchTab">
		</table> -->
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditor.jsp"/>
			<!-- 详情 -->
			<jsp:include page="detail.jsp"/>
		</div>
	</body>
</html>
