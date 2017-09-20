<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title>客服维护列表信息</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
		$(function(){
			$("#tt").datagrid({//数据表格
				title:"客服维护列表信息:<font color='blue'>${shopName}</font>",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopCustomerService/listShopCustomerService.action?ids=${ids}",
				idField:"ccsId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
				          {field:"trueName",title:"真实姓名",width:120,},
							{field:"nikeName",title:"昵称",width:120,},
							{field:"qq",title:"qq",width:80,},
							{field:"useState",title:"使用状态",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                        if(value=="0"){ return "<font color='#EE0000'>废弃</font>";} 
		                        if(value=="1"){ return "<font color='#0033FF'>正常使用</font>";} 
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
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
										   url: "${pageContext.request.contextPath}/back/shopCustomerService/deleteShopCustomerService.action",
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
					text:"返回",
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
    </script>
	</head>
	<body>
		<!-- 查询框  -->
		<div style="width: 99%">
		  	<table style="border:1px solid #99BBE8;text-align: center;" width="100%">
	    	<tr>
	    		<td style="align:right">真实姓名 ：</td>
	    		<td class="toleft_td"><input type="text" id="qtrueName" name="trueName" />&nbsp;&nbsp;</td>
	    		<td style="align:right">昵称 ：</td>
	    		<td class="toleft_td"><input type="text" id="qnikeName" name="nikeName" />&nbsp;&nbsp;</td>
	    		<td><a href="javascript:queryTT();" id="btn1" iconCls="icon-search" >查询</a></td>
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
