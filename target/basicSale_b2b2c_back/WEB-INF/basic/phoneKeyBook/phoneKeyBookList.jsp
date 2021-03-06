<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>手机数据字典信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
			/* 	title:"手机端数据字典列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/phoneKeyBook/listPhoneKeyBook.action",
				idField:"homeKeyBookId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"name",title:"名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.homeKeyBookId+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";  
		         	  }  
					}, 
					{field:"typeName",title:"类型名称",width:120},
					{field:"type",title:"类型",width:120},  
					{field:"value",title:"值",width:120}
					/* {field:"",title:"操作",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.homeKeyBookId+"' onclick='showDetailInfo(this.id);'>"+rowData.name+"</a>";  
		         	  }  } */
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[//工具条
				<% 
				if("add".equals((String)functionsMap.get(purviewId+"_add"))){
				%>   
				{
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(700,'auto',"&nbsp;&nbsp;添加手机数据字典","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#homeKeyBookId").val("");
					}
				}
				,"-",
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
							createWindow(700,'auto',"&nbsp;&nbsp;修改手机数据字典","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/phoneKeyBook/getPhoneKeyBookInfo.action",
							   data: {homeKeyBookId:rows[0].homeKeyBookId},
							   success: function(data){
								   $("#homeKeyBookId").val(data.homeKeyBookId);
								   $("#name").val(data.name);$("#value").val(data.value);
								   $("#type").val(data.type);$("#typeName").val(data.typeName);
							   }
							});
						}
					}
				}
				,"-",
				<% 
				 }
				if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
				%>
				{text:"删除",
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
											if(i==rows.length-1)ids+=rows[i].homeKeyBookId;
											else ids+=rows[i].homeKeyBookId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/phoneKeyBook/deletePhoneKeyBook.action",
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
				{text:"同步首页数据字典",
					iconCls:"icon-reload",
					handler:function(){
						$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步首页数据字典到系统内存中吗?</p>",function(data){
							if(data){//判断是否删除
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/phoneKeyBook/updateInServletContextPhoneKeyBook.action",
								   success: function(data){
									   if(data.isSuccess=="true") {
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
								//更新手机端数据字典
								var phoneUrl=splitUrl[1]+"phone/phoneKeyBook/updateInServletContextPhoneKeyBook.action?callback=?";
								$.getJSON(phoneUrl);
							}
						});
					}
				}
				,"-", 
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
    
</script>
</head>
<body>
<jsp:include page="../../util/item.jsp"/>
	<div class="main">
	<!-- <table class="searchTab">
	<tr></tr>
	</table><br /> -->
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
