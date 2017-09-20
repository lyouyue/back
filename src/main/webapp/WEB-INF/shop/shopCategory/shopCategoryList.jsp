<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>机构分类信息</title>
		<jsp:include page="../../util/import.jsp"/>
		 <script type="text/javascript">
	$(function(){
		//表单验证
	    $("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
              function() {  
                 var options = {  
                     url : "${pageContext.request.contextPath}/back/shopCategory/saveOrEditShopCategory.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	location.reload();
                     }
                 };  
                 $("#form1").ajaxSubmit(options);  
                 $("input.button_save").attr("disabled","disabled");//防止重复提交
              });
	       }
	    });
		   $("#tt").datagrid({//数据表格
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}}/back/shopCategory/findShopCategoryList.action",
				idField:"shopCategoryId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"shopCategoryName",title:"分类名称",width:80}, 
					{field:"sortCode",title:"排序号",width:80},
					{field:"createTime",title:"创建时间",width:50},
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
							createWindow(700,'auto',"&nbsp;&nbsp;添加机构分类","icon-add",false,"addOrEditWin");
							$("input.button_save").removeAttr("disabled");//防止重复提交
							$("#addOrEditWin").css("display","");
							$("#detailWin").css("display","none");//隐藏修改窗口
							$("#shopCategoryId").val("");
							$("#sortCode").val("");
							$("#shopCategoryName").val("");
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
								$("#addOrEditWin").css("display","");
								$("#detailWin").css("display","none");//隐藏修改窗口
								createWindow(700,'auto',"&nbsp;&nbsp;修改机构分类","icon-edit",false,"addOrEditWin");
								$.ajax({
									   type: "POST",
									   dataType: "JSON",
									   url: "${pageContext.request.contextPath}/back/shopCategory/getShopCategoryObject.action",
								       data: {shopCategoryId:rows[0].shopCategoryId},
									   success: function(data){
										   $("#shopCategoryId").val(data.shopCategoryId);
								    	    //$("#parentId").val(data.parentId);
								    	    $("#u_shopCategoryName").val(data.shopCategoryName);
								    	    $("#u_sortCode").val(data.sortCode);
								    	    //$("#level").val(data.level);
								    	    //$("#loadType").val(data.loadType);
								    	    $("#createTime").val(data.createTime);
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
												if(i==rows.length-1)ids+=rows[i].shopCategoryId;
												else ids+=rows[i].shopCategoryId+",";
											}
											$.ajax({
												   type: "POST",
												   dataType: "JSON",
												   url: "${pageContext.request.contextPath}/back/shopCategory/delShopCategory.action",
											       data: {shopCategoryId:ids},
												   success: function(data){
											    	     if(data.isSuccess=="true"){
											    	    	 msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
											    	    	 location.reload();
											    	     }else{
											    	    	 msgShow("系统提示", "<p class='tipInfo'>此分类下面还有子分类，请先删除子分类！</p>", "warning");  
											    	     }
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
					if("gotoShopInfo".equals((String)functionsMap.get(purviewId+"_gotoShopInfo"))){
					%>
						{
						text:"查看机构",
						iconCls:"icon-edit",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择用户！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								location.href="${pageContext.request.contextPath}/back/shopCategory/gotoShopInfoPageByShopCategoryId.action?shopCategoryId="+rows[0].shopCategoryId;
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
    </script>
  </head>
  
  <body>
    <jsp:include page="../../util/item.jsp"/>
  		 <!-- 查询框  -->
  <div  class="main">
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  	  <!-- 添加或者修改 -->
			  <jsp:include page="addOrEditor.jsp"/>
			  <%-- <!-- 详情页 -->
			  <jsp:include page="detail.jsp"/> --%>
		  </div>
		</div>
  </body>
</html>
