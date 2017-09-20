<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>首页特别套餐信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"首页特别套餐列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/homeParticularlyTab/listHomeParticularlyTab.action",
				queryParams:{pageSize:pageSize},
				idField:"tabProductId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"主题",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.tabProductId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					}, 
					{field:"imageUrl",title:"图片",width:60, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='25px' />";  
		         	  }  
					},
					{field:"link",title:"链接",width:140},
					{field:"sortCode",title:"排序",width:25},
                 	{field:"price",title:"价格",width:40},
					{field:"showLocation",title:"显示位置",width:40, 
				    	formatter:function(value,rowData,rowIndex){
				    		<s:iterator value="#application.homekeybook['countDownLocation']" var="hkb">
				    			if(value==<s:property value="#hkb.value" />){
				    				return "<s:property value='#hkb.name' />";
				    			}
				    		</s:iterator>
				    	}
                 	},
					{field:"isShow",title:"是否显示",width:40, 
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
						createWindow(900,490,"&nbsp;&nbsp;添加首页特别套餐","icon-add",false,"addOrEditWin",10);
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#photo1").html("");
						$("#tabProductId").val(null);
						$("#fileId1").val(null);
						$("#imageUrl1").val("");
						$("#tishi").html("");
						$("#mymessage1").html("");
						$("#localError").html("");
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
							$("#fileId1").val(null);
							createWindow(900,500,"&nbsp;&nbsp;修改首页特别套餐","icon-edit",false,"addOrEditWin");
			    			$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/homeParticularlyTab/getHomeParticularlyTabObject.action",
							   data: {tabProductId:rows[0].tabProductId},
							   success: function(data){
							       $("#tabProductId").val(data.tabProductId);
								   $("#title").val(data.title);
								   $("#synopsis").val(data.synopsis);
								   $("#link").val(data.link);
								   $("#price").val(data.price);
//		 						   $("#stopTime").val(data.stopTime);
								   $("#sortCode").val(data.sortCode);
								   $("#showLocation").val(data.showLocation);
								   $("#isShow_"+data.isShow).attr("checked",true);
								   $("#imageUrl1").val(data.imageUrl);
								   $("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.imageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='200px' height='200px' />");
								   $("#createTime").val(data.createTime);
								   $("#publishUser").val(data.publishUser);
								  if(data.showLocation==1){
									  $("#tishi").html("提示：请上传160*160像素的图片");
								  }
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
											if(i==rows.length-1)ids+=rows[i].tabProductId;
											else ids+=rows[i].tabProductId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/homeParticularlyTab/deleteHomeParticularlyTab.action",
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
 	function query(){
 		queryParams={pageSize:pageSize,currentPage:currentPage,title:$("#title1").val(),isShow:$("#isShow1").val(),showLocation:$("#showLocation1").val()};
	  	  	$("#tt").datagrid("load",queryParams); 
	  	  	pageSplit(pageSize,queryParams);//调用分页函数
   	}

	function reset(){
		$("#title1").val("");
       	$("#showLocation1").val("");
    	$("#isShow1").val("");
	}
    </script>
  <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
</head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:60px;">主题：</td>
				<td class="search_toleft_td" style="width: 155px;">
					<input type="text"  id="title1" class="searchTabinput"/>
				</td>
				<td class="search_toright_td" style="width:70px;">显示位置：</td>
				<td class="search_toleft_td" style="width: 105px;">
					<select id="showLocation1" name="homeParticularlyTab.showLocation"  class="querySelect">
						<option value="">--请选择--</option>
					<s:iterator value="#application.homekeybook['countDownLocation']" var="hbk">
						<option value="<s:property value='#hbk.value' />"><s:property value='#hbk.name' /></option>
					</s:iterator>
					</select>
				</td>
				<td class="search_toright_td" style="width:70px;">是否显示：</td>
				<td class="search_toleft_td" style="width:115px;">
					<select id="isShow1" class="querySelect">
						<option value="">--请选择--</option>
						<option value="0" >不显示</option>
						<option value="1" >显示</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				 </td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditHomeParticularlyTab.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detailHomeParticularlyTab.jsp"/>
		</div>
	</div>
</body>
</html>
