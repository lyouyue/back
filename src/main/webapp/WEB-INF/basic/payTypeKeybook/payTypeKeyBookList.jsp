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
				title:"数据字典列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/keybook/listPayType.action",
				queryParams:{pageSize:pageSize},
				idField:"keyBookId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"name",title:"名称",width:80}, 
					{field:"typeName",title:"类型名称",width:80},
					{field:"value",title:"开启状态",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                if(value==1){
		                	return "开启";
		                }else{
		                	return "关闭";
		                }
		         	  }  },
		         	 {field:"value2",title:"操作",width:80, 
							formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
								if(rowData.value==0){
				               		return "<a id='"+rowData.keyBookId+"' onclick='updateState(this.id);'>"+"开启"+"</a>";  
								}else if(rowData.value==1){
									return "<a id='"+rowData.keyBookId+"' onclick='updateState(this.id);'>"+"关闭"+"</a>";
								}
			         	  	}
						}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
					<% 
					if("open".equals((String)functionsMap.get(purviewId+"_open"))){
					%>
					{
						text:"开启",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if (rows){
								var ids="";
								for(i=0;i<rows.length;i++){
									if(i==rows.length-1)ids+=rows[i].keyBookId;
									else ids+=rows[i].keyBookId+",";
								}
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/keybook/updatePayType.action",
								   data: {ids:ids,value:1},
								   success: function(data){
									   $("#tt").datagrid("clearSelections");//删除后取消所有选项
									   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
								   }
								});
							}
						}
					}
					,"-", 
					<% 
					}
					if("close".equals((String)functionsMap.get(purviewId+"_close"))){
					%>
					{
						text:"关闭",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if (rows){
								var ids="";
								for(i=0;i<rows.length;i++){
									if(i==rows.length-1)ids+=rows[i].keyBookId;
									else ids+=rows[i].keyBookId+",";
								}
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/keybook/updatePayType.action",
								   data: {ids:ids,value:0},
								   success: function(data){
									   $("#tt").datagrid("clearSelections");//删除后取消所有选项
									   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
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
					text:"同步初始化数据字典",
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
    function updateState(id){
    	$.ajax({
			   type: "POST", dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/keybook/updatePayType.action",
			   data: {ids:id},
			   success: function(data){
				   $("#tt").datagrid("reload");
			   }
			});
    }
    </script>
  </head>
  <body>
	<div style="width: 99%">
  		<table id="tt"></table>
  		<%-- <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div> --%>
	</div>
  </body>
</html>
