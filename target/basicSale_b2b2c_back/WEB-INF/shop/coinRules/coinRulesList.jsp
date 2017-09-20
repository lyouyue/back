<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>金币策略信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"金币赠送规则列表信息",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/coinRules/listCoinRules.action",
				queryParams:{pageSize:pageSize},
				idField:"coinRulesId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"name",title:"名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.coinRulesId+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";
		         	  }
					},
					{field:"value",title:"值",width:120},
					{field:"typeName",title:"类型名称",width:120},
					{field:"type",title:"类型",width:120},
					{field:"userName",title:"操作人",width:120},
					{field:"updateTime",title:"更新时间",width:120}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加金币策略","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#coinRulesId").val(null);
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
							createWindow(700,'auto',"&nbsp;&nbsp;修改金币策略","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/coinRules/getCoinRulesInfo.action",
							   data: {coinRulesId:rows[0].coinRulesId},
							   success: function(data){
								   $("#coinRulesId").val(data.coinRulesId);
								   $("#createTime").val(data.createTime);
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
											if(i==rows.length-1)ids+=rows[i].coinRulesId;
											else ids+=rows[i].coinRulesId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/coinRules/deleteCoinRules.action",
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
				} ,"-",
				<%
				  }
				if("initCoinRules".equals((String)functionsMap.get(purviewId+"_initCoinRules"))){
				%>
				{
					text:"同步金币策略",
					iconCls:"icon-reload",
					handler:function(){
						$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步金币赠送规则到系统内存中吗?</p>",function(data){
							if(data){//判断是否删除
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/coinRules/updateInServletContextCoinRules.action",
								   success: function(data){
									   if(data.isSuccess=="true") {
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
						var url=splitUrl[0]+"back/coinRules/updateInServletContextCoinRules.action?callback=?";
						$.getJSON(url);
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
				}]
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
				   url: "${pageContext.request.contextPath}/back/coinRules/getCoinRulesInfo.action",
				   data: {coinRulesId:rows[0].coinRulesId},
				   success: function(data){
					   $("#coinRulesId").val(data.coinRulesId);
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
						   url: "${pageContext.request.contextPath}/back/coinRules/deleteCoinRules.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
			});
		}
	}
    function query(){
	  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,name:$("#qname").val(),typeName:$("#qtypeName").val()};
	  $("#tt").datagrid("load",queryParams);
	  pageSplit(pageSize,queryParams);//调用分页函数
    }

	function reset(){
		$("#qname").val("");
       	$("#qtypeName").val("");
	}
</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
			<!-- 查询框  -->
	<div class="main">
		<table   class="searchTab">
			<tr>
				<td class="toright_td" style="width: 60px;">名称：
				</td>
				<td class="toleft_td" style="width:155px;">
					<input type="text" id="qname" name="s_name" class="searchTabinput"/>
				</td>
				<td class="toright_td" style="width:75px;">类型名称：</td>
				<td class="toleft_td" style="width:170px;">
					<input type="text" id="qtypeName" name="s_companyName" class="searchTabinput"/>
				</td>
			 	<td class="toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
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
