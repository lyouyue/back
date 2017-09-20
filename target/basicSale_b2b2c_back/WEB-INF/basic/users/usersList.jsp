<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>管理员信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    	$(function(){
		 //表单验证
			 $("#form1").validate({meta: "validate", 
			    submitHandler:function(form){
			    $(document).ready(
		           function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/users/saveOrUpdateUsers.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
                         }
                     };  
					var returnVal=checkUsers1();
					if(returnVal==1){
						$("#form1").ajaxSubmit(options); 
						$("input.button_save").attr("disabled","disabled");//防止重复提交
					}else{
						msgShow("系统提示", "<p class='tipInfo'>用户名称已存在，请重新填写！</p>", "warning");
					}
					});
				}
			});
			
			$("#tt").datagrid({//数据表格
				/* title:"管理员列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/users/listUsers.action",
				idField:"usersId",//唯一性标示字段
				frozenColumns:[[//冻结字段
					 {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
			         {field:"userName",title:"管理员名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
			             return "<a style='display:block;' id='"+rowData.usersId+"' onclick='showDetailInfo(this.id);'>"+rowData.userName+"</a>";  
			      	  }  
					}, 
					{field:"email",title:"邮箱",width:120},
					{field:"phone",title:"电话",width:120},
					{field:"trueName",title:"真实姓名",width:120},
					/* {field:"registerDate",title:"注册日期",width:120}, */
					{field:"lockState",title:"状态",width:50,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                     if(value=="0"){ return "<font class='color_001'>未冻结</font>";} 
		                     if(value=="1"){ return "<font class='color_002'>已冻结</font>";} 
                         }
					}
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
						createWindow(700,'auto',"&nbsp;&nbsp;添加管理员","icon-add",false,"addOrEditWin");
						$("#usersId").val("");
						$("#userMsg").html("");
						$("#save").css("display","");
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
							createWindow(700,'auto',"&nbsp;&nbsp;修改管理员","icon-edit",false,"addOrEditWin");
							$.ajax({
								type: "POST", dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/users/getUsersObject.action",
								data: {usersId:rows[0].usersId},
								success: function(data){
									$("#usersId").val(data.usersId);
									$("#uuserName").val(data.userName);
									$("#password").val(data.password);
									$("#trueName").val(data.trueName);
									$("#email").val(data.email);
									$("#phone").val(data.phone);
									$("#comments").val(data.comments);
									$("#registerDate").val(data.registerDate);
									$("#lockState_"+data.lockState).attr("checked",true);
									$("#userMsg").html("");
									$("#save").css("display","");
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
											if(i==rows.length-1)ids+=rows[i].usersId;
											else ids+=rows[i].usersId+",";
										}
										$.ajax({
											type: "POST",dataType: "JSON",
											url: "${pageContext.request.contextPath}/back/users/deleteUsers.action",
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
				if("maintain".equals((String)functionsMap.get(purviewId+"_maintain"))){
				%>
					{
					text:"指定角色",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择用户！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							//表单提交用户参数userName  usersId
							$("#userName").val(rows[0].userName);
							$("#qusersId").val(rows[0].usersId);
							$("#formUserPar").submit();
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
		function showDetailInfo(id){
			createWindow(700,'auto',"&nbsp;&nbsp;管理员详情","icon-tip",false,"detailWin");
			$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/back/users/getUsersObject.action",
					data: {usersId:id},
					dataType: "JSON",
					success: function(data){
						$("#duserName").html(data.userName);
						var l=data.password.length;
						var str="";
						if(l>0){
							for(var i=0;i<l;i++){
								str+="*";
							}
					 	  $("#dpassword").html(str);
						}
						$("#dtrueName").html(data.trueName);
						$("#demail").html(data.email);
						$("#dphone").html(data.phone);
						$("#dcomments").html(data.comments);
						$("#dregisterDate").html(data.registerDate);
						if(data.lockState=="0"){
							$("#dlockState").html("<font class='color_001'>未冻结</font>");
						}else{
							$("#dlockState").html("<font class='color_002'>已冻结</font>");
						}
					}
			});
		}
		
		
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,userName:$("#quserName").val(),registerDate:$("#qregisterDate").val(),lockState:$("#qlockState").val()};
	  	$("#tt").datagrid("load",queryParams); 
	  	pageSplit(pageSize,queryParams);//调用分页函数
    }
	function reset(){
		$("#quserName").val("");
       	$("#qregisterDate").val("");
    	$("#qlockState").val("");
	}
    </script>
  </head>
  
<body>
	<form action="${pageContext.request.contextPath}/back/usersActor/findActorListByUsersId.action" method="post" id="formUserPar">
		<input id="qusersId" type="hidden" name="usersId"/>
		<input id="userName" type="hidden" name="userName"/>
	</form>
	<jsp:include page="../../util/item.jsp"/>
	 <!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			 <tr>
				<td class="search_toright_td"  style="width:95px;"> 管理员名称：</td>
				<td class=search_toleft_td  style="width:150px;"><input type="text" id="quserName" name="s_name"  style="width:130px;" class="searchTabinput"/></td>
				<td class="search_toright_td"  style="width:50px;;"> 状态：</td>
				<td class="search_toleft_td"  style="width:120px;">
					<select id="qlockState" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="0">未冻结</option>
						<option value="1">已冻结</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditUsers.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detailUsers.jsp"/>
		</div>
	</div>
  </body>
</html>
