<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>系统配置信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"基础配置列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/systemConfig/listSystemConfig.action",
				idField:"id",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		           /*  {field:"name",title:"名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.id+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";  
		         	  }  
					},  */
					{field:"name",title:"名称",width:120},  
					{field:"type",title:"类型",width:120},  
					{field:"value",title:"值",width:120},
					{field:"groupColumn",title:"分组",width:120}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加系统配置","icon-add",false,"addOrEditWin");
						$("input.button_save").removeAttr("disabled");
						$("#addOrEditWin").css("display","");
						$("#type").removeAttr("readonly");
						$("#detailWin").css("display","none");
						$("#id").val("");
					}
				},"-",
				<%
				 }
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{text:"修改", 
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(700,'auto',"&nbsp;&nbsp;修改系统配置","icon-edit",false,"addOrEditWin");
							$("input.button_save").removeAttr("disabled");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/systemConfig/getSystemConfigObject.action",
							   data: {id:rows[0].id},
							   success: function(data){
								   $("#id").val(data.id);
								   $("#name").val(data.name);
								   $("#type").val(data.type);
								   $("#type").attr("readonly","readonly");
								   $("#value").val(data.value);
								   $("#groupColumn").val(data.groupColumn);
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
										for(var i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].id;
											else ids+=rows[i].id+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/systemConfig/deleteSystemConfig.action",
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
				if("sysinit".equals((String)functionsMap.get(purviewId+"_sysinit"))){
				%>
				{text:"同步基础设置",
					iconCls:"icon-reload",
					handler:function(){
						$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步基础设置到系统内存中吗？</p>",function(data){
							if(data){//判断是否删除
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/systemConfig/updateSystemConfig.action",
								   success: function(data){
									   if(data.isSuccess) {
										   msgShow("系统提示", "<p class='tipInfo'>同步成功！</p>", "warning");
									   }else{
										   msgShow("系统提示", "<p class='tipInfo'>同步失败，请重试！</p>", "warning");
									   }
								   }
								});
							}
						});
						//获取更新初始化信息url
						var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
						//截取
						var splitUrl=prefixUrl.split("@");
						var url=splitUrl[0]+"front/frontSystemConfig/updateSystemConfig.action?callback=?";
						$.getJSON(url);
						var url1=splitUrl[1]+"phone/phoneSystemConfig/updateSystemConfig.action?callback=?";
						$.getJSON(url1);
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
			pageSplit();//调用分页函数
	});
    
	function query(){
		queryParams={pageSize:pageSize,currentPage:currentPage,name:$("#s_name").val(),type:$("#s_type").val()};
  	  	$("#tt").datagrid("load",queryParams); 
  	  	pageSplit(pageSize,queryParams);//调用分页函数   
	}
	function reset(){
		$("#s_name").val("");
		$("#s_type").val("");
	}
    </script>
  </head>
  
<body>
<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:60px;">
					<span class="querybtn" style="font-size: 12px;">名称：</span>
				</td>
				<td class="search_toleft_td"  style="width:155px;">
					<input type="text" id="s_name" class="searchTabinput"/>
				</td>
				<td class="search_toright_td" style="width:50px;">
					<span class="querybtn" style="font-size: 12px;">类型：</span>
				</td>
				<td class="search_toleft_td" style="width: 170px;">
					<input type="text" id="s_type" class="searchTabinput"/>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>	
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditorSystemConfig.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detail.jsp"/>
		</div>
	</div>
</body>
</html>
