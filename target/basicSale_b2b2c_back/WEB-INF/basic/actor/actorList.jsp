<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>角色信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
			 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/actor/saveOrUpdateActor.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
                         }
                     };  
					var returnVal=checkActor();
					if(returnVal==1){
						$("#form1").ajaxSubmit(options); 
						$("input.button_save").attr("disabled","disabled");//防止重复提交
					}
                   });
 		       }
 		    });
			
		   $("#tt").datagrid({//数据表格
				/* title:"角色列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/actor/listActor.action",
				idField:"actorId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"actorName",title:"角色名称",width:120}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加角色","icon-add",false,"addOrEditWin"); 
						 $("#actorId").val("");
						 $("#na").html("");
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
							createWindow(700,'auto',"&nbsp;&nbsp;修改角色","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/actor/getActorObject.action",
							   data: {actorId:rows[0].actorId},
							   success: function(data){
								   $("#actorId").val(data.actorId);
								   $("#actorName").val(data.actorName);
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
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].actorId;
											else ids+=rows[i].actorId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/actor/deleteActor.action",
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
				if("assign".equals((String)functionsMap.get(purviewId+"_assign"))){
				%>
				{
					text:"分配权限",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
						}else if(rows.length==1){
							/* //window.showModalDialog("${pageContext.request.contextPath}/back/actorPurview/getPurviewListByActorId.action?actorId="+rows[0].actorId,"","dialogWidth=500px;dialogHeight=500px;center=1;");
							var iWidth = 500;
							var iHeight = 500;
							var iTop = (window . screen . availHeight - 30 - iHeight) / 2 ;
							var iLeft = (window . screen . availWidth - 10 - iWidth) / 2 ; */
							window.location.href="${pageContext.request.contextPath}/back/actorPurview/assignPurview.action?actorId="+rows[0].actorId ;
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
			pageSplit();//调用分页函数
		});
    
    	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(700,'auto',"&nbsp;&nbsp;修改角色","icon-edit",false,"addOrEditWin");
				$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/actor/getActorObject.action",
				   data: {actorId:id},
				   success: function(data){
					   $("#actorId").val(data.actorId);
					   $("#actorName").val(data.actorName);
				   }
				});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/actor/deleteActor.action",
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
   		  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,actorName:$("#qactorName").val()};
   		  $("#tt").datagrid("load",queryParams); 
   		  pageSplit(pageSize,queryParams);//调用分页函数
   	    }
		function reset(){
	    	$("#qactorName").val("");
    	}
</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<!-- 查询框  -->
	<div class="main">
		<table  class="searchTab">
			<tr>
				<td class="search_toright_td"   style="width:82px;" >&nbsp;&nbsp;&nbsp;&nbsp;角色名称：</td>
				<td class="search_toleft_td"  style="width:165px;"><input type="text" id="qactorName" name="s_name" class="searchTabinput"/></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditActor.jsp"/>
		</div>
	</div>
</body>
</html>
