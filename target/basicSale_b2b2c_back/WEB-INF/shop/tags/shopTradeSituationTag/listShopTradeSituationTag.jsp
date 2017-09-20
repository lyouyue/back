<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title>使用行业维护列表信息</title>
	<jsp:include page="../../../util/import.jsp"/>
	<script type="text/javascript">
	//全局的标签名称 用来存储当前操作的标签信息  判断是否对其进行了修改操作 是否需要做唯一性校验
	var tagsName="";
		$(function(){
		//表单验证
			$("#form1").validate({meta: "validate", 
				submitHandler:function(form){
					$(document).ready(
						function() {  
							var options = {  
								url : "${pageContext.request.contextPath}/back/shopTradeTag/savaOrUpdateShopTradeTag.action",  
								type : "post",  
								dataType:"json",
								success : function(data) { 
									closeWin();
									$("#tt").datagrid("clearSelections");//删除后取消所有选项
									$("#tt").datagrid("reload"); //保存后重新加载列表
									$("input.button_save").removeAttr("disabled");//取消防止重复提交
								}
							};  
							$("#form1").ajaxSubmit(options); 
							$("input.button_save").attr("disabled","disabled");//防止重复提交
					});
				}
			});
			$("#tt").datagrid({//数据表格
				/* title:"使用行业维护列表信息:<font color='blue'>${tageName}</font>",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopTradeSituationTag/listShopTradeSituationTag.action?ids=${ids}",
				idField:"tstId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"tageName",title:"标签名称",width:120}, 
					{field:"useState",title:"使用状态",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="0"){ 
								return "<font color='red'>废弃</font>";
							}else if(value=="1"){
								return "<font color='blue'>正常使用</font>";
							} 
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
						showShopSituationTagList("${ids}",10);
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
											if(i==rows.length-1)ids+=rows[i].tstId;
											else ids+=rows[i].tstId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/shopTradeSituationTag/deleteShopTradeSituationTag.action",
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
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,tageName:$.trim($("#qtageName").val()),useState:$("#quseState").val()};
	  	$("#tt").datagrid("load",queryParams); 
	  	pageSplitThis(pageSize,queryParams,"tt");//调用分页函数
    }
	function resetTT(){
		$("#qtageName").val("");
       	$("#quseState").val("");
	}
	</script>
	</head>
	<body>
	<jsp:include page="../../../util/item.jsp"/>
		<!-- 查询框  -->
		<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width: 85px;">标签名称：</td>
				<td class="search_toleft_td" style="width: 155px;"><input type="text" id="qtageName" /></td>
				<td class="search_toright_td" style="width: 75px;">使用状态：</td>
				<td class="search_toleft_td" style="width: 105px;">
				    <select id="quseState">
						<option value="-1">--请选择--</option>
						<option value="0">废弃</option>
						<option value="1">正常使用</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:queryTT()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:resetTT()">重置</a>
				</td>
			</tr>
		</table>
			<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 添加 -->
				<jsp:include page="addOrEditShopSituationTag.jsp"/>
			</div>
		</div>
	</body>
</html>
