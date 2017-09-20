<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title>自营店铺客服信息</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
		$(function(){
			$("#tt").datagrid({//数据表格
				/* title:"客服维护列表信息:<font color='blue'>${shopName}</font>",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/selfSupportCustomerService/listShopCustomerService.action?ids=${ids}",
				idField:"ccsId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
				          
				          {field:"trueName",title:"真实姓名",width:120,},
							{field:"nikeName",title:"昵称",width:120,},
							{field:"qq",title:"qq",width:80,},
							{field:"useState",title:"使用状态",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                        if(value=="0"){ return "<font class='color_002'>废弃</font>";} 
		                        if(value=="1"){ return "<font class='color_001'>正常使用</font>";} 
		                     }
						}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(700,'auto',"&nbsp;&nbsp;添加自营店铺客服","icon-add",false,"addOrEditWin");
						showShopSituationTagList("${ids}");
						$("#qtageName2").val("");
						$("#quseState2").val("-1");
					}
				} ,"-",{
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
										for(var i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].ccsId;
											else ids+=rows[i].ccsId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/selfSupportCustomerService/deleteShopCustomerService.action",
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
				} ,"-",{
					text:"返回自营店铺列表",
					iconCls:"icon-back",
					handler:function(){
						history.go(-1);
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplitThis(pageSize,queryParams,"tt");//调用分页函数
	});
		
	function queryTT(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,trueName:$.trim($("#qtrueName").val()),nikeName:$.trim($("#qnikeName").val())};
	  	$("#tt").datagrid("load",queryParams); 
	  	pageSplitThis(pageSize,queryParams,"tt");//调用分页函数
    }
	function resetTT(){
		$("#qtrueName").val("");
       	$("#qnikeName").val("");
    }
    </script>
	</head>
	<body>
		<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:85px;" >真实姓名：</td>
				<td class="search_toleft_td" style="width:160px;"><input type="text" id="qtrueName" name="trueName"  style="height:20px;width:143px;"/>&nbsp;&nbsp;</td>
				<td  class="search_toright_td" style="width:45px;">昵称：</td>
				<td class="search_toleft_td" style="width:160px;">
				<input type="text" id="qnikeName" name="nikeName"  style="height:20px;width:143px;"/>&nbsp;&nbsp;</td>
				<td class="search_toleft_td" >
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:queryTT()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:resetTT()">重置</a>
				</td>
			</tr>
		</table>
			<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 添加 -->
				<jsp:include page="addOrEditShopCustomerService.jsp"/>
			</div>
		</div>
	</body>
</html>
