<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>数据字典</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"支付方式管理列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/keybook/listPayManagement.action",
				queryParams:{pageSize:pageSize},
				idField:"keyBookId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"name",title:"名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.keyBookId+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";  
		         	  }  
					}, 
					{field:"value",title:"值",width:120},
					{field:"typeName",title:"类型名称",width:120},
					{field:"type",title:"类型",width:120}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#keyBookId").val(null);
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
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(700,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/keybook/getKeyBookInfo.action",
							   data: {keyBookId:rows[0].keyBookId},
							   success: function(data){
								   $("#keyBookId").val(data.keyBookId);
								   $("#name").val(data.name);$("#value").val(data.value);
								   $("#type").val(data.type);$("#typeName").val(data.typeName);
							   }
							});
						}
					}
				} ,"-", 
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
											if(i==rows.length-1)ids+=rows[i].keyBookId;
											else ids+=rows[i].keyBookId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/keybook/deleteKeyBook.action",
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
				} 
				,"-",
				<% 
				 }
				if("init".equals((String)functionsMap.get(purviewId+"_init"))){
				%>
				{
					text:"同步数据字典",
					iconCls:"icon-reload",
					handler:function(){
						$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步数据字典到系统内存中吗?</p>",function(data){
							if(data){//判断是否删除
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/keybook/updateInServletContextKeyBook.action",
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
						var url=splitUrl[0]+"front/basicKeyBook/updateInServletContextKeyBook.action?callback=?";
						$.getJSON(url);
					}
				}
				,"-", 
				<% 
				  }
				%>
				{text:"开启",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							$.messager.confirm("系统提示", "<p class='tipInfo'>确定开启该支付方式吗？</p>",function(data){
								if(data){
									$.ajax({
										type: "POST", dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/keybook/updatePayMethodById.action",
										data: {keyBookId:rows[0].keyBookId,onOrOff:"true"},
										success: function(data){
											if(data.isSuccess) {
												reloadInit();//更新初始化数据
												//msgShow("系统提示", "<p class='tipInfo'>开启成功！</p>", "warning");
											}else{
												msgShow("系统提示", "<p class='tipInfo'>开启失败，请重试！</p>", "warning");
											}
										}
									});
								}
							});
						}
					}
				},"-", 
				{text:"关闭",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							$.messager.confirm("系统提示", "<p class='tipInfo'>确定关闭该支付方式吗？</p>",function(data){
								if(data){//判断是否删除
									$.ajax({
										type: "POST", dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/keybook/updatePayMethodById.action",
										data: {keyBookId:rows[0].keyBookId,onOrOff:"false"},
										success: function(data){
											if(data.isSuccess) {
												reloadInit();//更新初始化数据
												//msgShow("系统提示", "<p class='tipInfo'>关闭成功！</p>", "warning");
											}else{
												msgShow("系统提示", "<p class='tipInfo'>关闭失败，请重试！</p>", "warning");
											}
										}
									});
								}
							});
						}
					}
				},"-", 
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
	
	function updOrDelSA(id,rowid,flag){
		if(flag == 1){
			var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
			if(rows.length==1){
				createWindow(700,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
				$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/keybook/getKeyBookInfo.action",
				   data: {keyBookId:rows[0].keyBookId},
				   success: function(data){
					   $("#keyBookId").val(data.keyBookId);
					   $("#name").val(data.name);$("#value").val(data.value);
					   $("#type").val(data.type);$("#typeName").val(data.typeName);
				   }
				});
			}
		}else{
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
				function(data){
				if(data == true)
					$.ajax({
						   type: "POST",dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/keybook/deleteKeyBook.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
			});
		}
	}
	//查询
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,name:$("#qname").val(),typeName:$("#qtypeName").val()};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数
	}
	//重置
	function reset(){
		$("#qname").val("");
		$("#qtypeName").val("");
	}
	//更新初始化
	function reloadInit(){
		$.ajax({
			type: "POST",dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/keybook/updateInServletContextKeyBook.action",
			success: function(data){
				if(data.isSuccess) {
					msgShow("系统提示", "<p class='tipInfo'>同步成功！</p>", "warning");
				}else{
					msgShow("系统提示", "<p class='tipInfo'>同步失败，请重试！</p>", "warning");
				}
			}
		});
		//获取更新初始化信息url
		var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
		//截取
		var splitUrl=prefixUrl.split("@");
		var url=splitUrl[0]+"front/basicKeyBook/updateInServletContextKeyBook.action?callback=?";
		$.getJSON(url);
		$("#tt").datagrid("clearSelections");//取消所有选项
		$("#tt").datagrid("reload"); //重新加载列表
	}
	</script>
  </head>
  <body>
 		 <!-- 查询框  -->
  <div style="width: 99%">
	   <table   style="border:1px solid #99BBE8;text-align: center;" width="100%">
	       	  <tr>
		          <td class="toright_td"  style="width:60px;">
		          	&nbsp;&nbsp;&nbsp;&nbsp;名称：
	          </td>
	          <td class="toleft_td">
					<input type="text" id="qname" name="s_name"/> 
			</td>
				<td class="toright_td">
					&nbsp;&nbsp;&nbsp;&nbsp;类型名称：
				</td>
				<td class="toleft_td">
					<input type="text" id="qtypeName" name="s_companyName"/>
				</td>
	          <td align="center">
	             	<a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a>
	           		<a href="javascript:reset();" id="btn2" iconCls="icon-undo">重置</a>
	          </td>
	       </tr>
	   </table> 
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div></div>
  </body>
</html>
