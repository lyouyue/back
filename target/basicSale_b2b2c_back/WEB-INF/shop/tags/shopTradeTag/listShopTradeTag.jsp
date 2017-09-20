<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title>适合行业标签</title>
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
				/* title:"适合行业标签列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopTradeTag/listShopTradeTag.action",
				idField:"ttId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"tageName",title:"标签名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.ttId+"' onclick='showDetailInfo(this.id);'>"+value+"</a>";  
		         	  }  
					}, 
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
						//清空id信息
						$("#ttId").val("");
						//使用状态默认选中“正常使用”
						$("#useState_1").attr("checked",true);
						//存储全局的标签名称
						tagsName="";
					}
				},"-",{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(700,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/shopTradeTag/getShopTradeTagObject.action",
							   data: {ttId:rows[0].ttId},
								success: function(data){
									//ID赋值
									$("#ttId").val(data.ttId);
									//标签名称赋值
									$("#tageNametwo").val(data.tageName);
									//存储全局的标签名称
									tagsName=data.tageName;
									//使用状态赋值
									$("#useState_"+data.useState).attr("checked",true);
							   }
							});	   
						}
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
											if(i==rows.length-1)ids+=rows[i].ttId;
											else ids+=rows[i].ttId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/shopTradeTag/deleteShopTradeTag.action",
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
				},"-",{
					text:"维护使用场合",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择标签！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							//表单提交标签参数
							$("#tageName").val(rows[0].tageName);
							$("#ids").val(rows[0].ttId);
							$("#formTagPar").submit();
						}
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit();//调用分页函数
		});
		function showDetailInfo(id){
			createWindow(700,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/back/shopTradeTag/getShopTradeTagObject.action",
				data: {ttId:id},
				dataType: "JSON",
				success: function(data){
					//标签名称
					$("#dtageName").html(data.tageName);
					//使用状态
					if(data.useState==0){
						$("#duseState").html("<font color='red'>废弃</font>");	
					}else if(data.useState==1){
						$("#duseState").html("<font color='blue'>正常使用</font>");
					}
				}
			});
		}
		
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,tageName:$.trim($("#qtageName").val()),useState:$("#quseState").val()};
	  	$("#tt").datagrid("load",queryParams); 
	  	pageSplit(pageSize,queryParams);//调用分页函数
    }
	function reset(){
		$("#qtageName").val("");
       	$("#quseState").val("");
	}
    </script>
	</head>
	<body>
	<jsp:include page="../../../util/item.jsp"/>
	<form action="${pageContext.request.contextPath}/back/shopTradeSituationTag/gotoShopTradeSituationTagPage.action" method="post" id="formTagPar">
	<input id="ids" type="hidden" name="ids"/>
	<input id="tageName" type="hidden" name="tageName"/>
	</form>
		<!-- 查询框  -->
		<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td"   style="width:88px;">标签名称：</td>
				<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qtageName"  style="height:20px;"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:75px;">使用状态：</td>
				<td class="search_toleft_td" style="width: 110px;"><select id="quseState" class="querySelect">
					<option value="-1">--请选择--</option>
					<option value="0">废弃</option>
					<option value="1">正常使用</option>
				</select></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
			<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 添加或者修改 -->
				<jsp:include page="addOrEditShopTradeTag.jsp"/>
				<!-- 详情页 -->
				<jsp:include page="detailShopTradeTag.jsp"/>
			</div>
		</div>
	</body>
</html>
