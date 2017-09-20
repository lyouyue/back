<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>每日推荐轮播图信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"热销轮播图列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/dayRecommend/listDayRecommendLBT.action",
				queryParams:{pageSize:pageSize},
				idField:"broadcastingId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"主题",width:150, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.broadcastingId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					}, 
					{field:"broadcastingIamgeUrl",title:"图片",width:160, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"'onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='240px' height='25px' />";  
		         	  }  
					},
					{field:"interlinkage",title:"链接",width:150},
					{field:"sortCode",title:"排序",width:40},
					{field:"isShow",title:"是否显示",width:50, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>不显示</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>显示</font>";} 
                            }
                 	}
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
						createWindow(800,"auto","&nbsp;&nbsp;添加每日推荐轮播图","icon-add",false,"addOrEditWin");
						//$("fileId1").val("");
						$("#photoForm1")[0].reset();
						$("#photo1").html("");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#broadcastingId").val(null);
						$("#tishi").html("");
						$("#mymessage1").html("");
						$("#imageUrl1").val("");
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
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							//$("fileId1").val("");
							$("#photoForm1")[0].reset();
							createWindow(800,"auto","&nbsp;&nbsp;修改每日推荐轮播图","icon-edit",false,"addOrEditWin");
							$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/dayRecommend/getDayRecommendLBTInfo.action",
								   data: {broadcastingId:rows[0].broadcastingId},
								   success: function(data){
									       $("#broadcastingId").val(data.broadcastingId);
										   $("#title").val(data.title);
										   $("#synopsis").val(data.synopsis);
										   $("#interlinkage").val(data.interlinkage);
										   $("#sortCode").val(data.sortCode);
										   $("#showLocation").val(data.showLocation);
										   $("#isShow_"+data.isShow).attr("checked",true);
										   $("#imageUrl1").val(data.broadcastingIamgeUrl);
										   $("#photo1").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.broadcastingIamgeUrl+"' width='480px' height='99px' />");
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
											if(i==rows.length-1)ids+=rows[i].broadcastingId;
											else ids+=rows[i].broadcastingId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/dayRecommend/deleteDayRecommendLBT.action",
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
    
    //详情
    function showDetailInfo(id){
		createWindow(800,"auto","&nbsp;&nbsp;每日推荐轮播图详情 ","icon-tip",false,"detailWin");
		$.ajax({
			   type: "POST", dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/dayRecommend/getDayRecommendLBTInfo.action",
			   data: {broadcastingId:id},
			   success: function(data){
					   $("#d_title").html(data.title);
					   $("#d_synopsis").html(data.synopsis);
					   $("#d_interlinkage").html(data.interlinkage);
					   $("#d_sortCode").html(data.sortCode);
					   if(data.isShow == 0){
						   $("#d_isShow").html("<font class='color_002'>不显示</font>");
					   }else if(data.isShow == 1){
						   $("#d_isShow").html("<font class='color_001'>显示</font>");
					   }
					   $("#d_photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.broadcastingIamgeUrl+"' width='480px' height='99px' />");
			   }
			});
			
	}
    </script>
  </head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
	<div class="main">
		<!-- <table class="searchTab">
		</table><br/> -->
		<table id="tt"></table>
			<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
				<!-- 添加或者修改 -->
				<jsp:include page="addOrEditDayRecommendLBT.jsp"/>
				<!-- 详细  查看 -->
				<jsp:include page="detailDayRecommendLBT.jsp"/>
			</div>
	</div>
	</body>
</html>
