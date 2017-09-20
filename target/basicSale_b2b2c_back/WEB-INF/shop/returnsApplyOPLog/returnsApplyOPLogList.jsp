<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>退换申请操作日志列表页面</title>
    <jsp:include page="../../util/import.jsp"/>
    
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"退换申请操作日志列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/returnsApplyOPLog/listReturnsApplyOPLog.action?returnsApplyId=<s:property value='returnsApplyId'/>",
				queryParams:{pageSize:pageSize},
				idField:"returnsApplyOPLogId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"returnsApplyOPLogId",title:"退换申请编号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.returnsApplyOPLogId+"' onclick='showDetailInfo(this.id);'>"+rowData.returnsApplyNo+"</a>";  
		         	  }  
					}, 
					{field:"operatorName",title:"操作人",width:80},
					{field:"operatorTime",title:"操作时间",width:80},
					{field:"comments",title:"操作内容",width:200},
					{field:"updateName",title:"修改人",width:80},
					{field:"updateTime",title:"修改时间",width:80}
					/*
					{field:"updName,delName",title:"操作",width:120, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.returnsApplyOPLogId+"' onclick='updOrDelSA(this.id,"+rowData.returnsApplyOPLogId+",1);'>"+updName+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.returnsApplyOPLogId+"' onclick='updOrDelSA(this.id,"+rowData.returnsApplyOPLogId+",2);'>"+delName+"</a>";  
		         	  	}
					}
					*/
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{
					/*
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
											if(i==rows.length-1)ids+=rows[i].returnsApplyOPLogId;
											else ids+=rows[i].returnsApplyOPLogId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/returnsApplyOPLog/deleteReturnsApplyOPLog.action",
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
				*/
					text:"返回退货列表",
					iconCls:"icon-back",
					handler:function(){
						location.href="${pageContext.request.contextPath}/back/returnsApply/gotoReturnsApplyPage.action";
					}
				},"-",{text:"刷新",
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,applyId:$("#parameRturnsApplyId").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
		 
		 function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
				$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/returnsApplyOPLog/getReturnsApplyOPLogObject.action",
				   data: {returnsApplyOPLogId:id},
				   success: function(data){
					   $("#returnsApplyOPLogId").val(data.returnsApplyOPLogId);
					   $("#applyId").val(data.applyId);
					   $("#returnsApplyNo").val(data.returnsApplyNo);
					   $("#operatorLoginName").val(data.operatorLoginName);
					   $("#operatorName").val(data.operatorName);
					   $("#operatorTime").val(data.operatorTime);
					   $("#operatorTime").val(data.operatorTime);
					   $("#comments").val(data.comments);
				   }
				});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/returnsApplyOPLog/deleteReturnsApplyOPLog.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
				});
    		}
    	}
    </script>
  </head>
  
  <body>
  	<!-- 
  		<span style="font-size: 15px;">退换申请单号：
  			<select id="parameRturnsApplyId">
	              <option value="-1">--请选择申请单--</option>
				  <s:iterator value="returnsApplyList">
				  	<option value="<s:property value="returnsApplyId"/>"><s:property value="returnsApplyNo"/></option>
				  </s:iterator>
		     </select>
  		</span>
		<span ><a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a></span>
	 -->	
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
