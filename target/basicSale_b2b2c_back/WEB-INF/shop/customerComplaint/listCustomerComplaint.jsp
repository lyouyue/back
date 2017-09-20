<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员投诉信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"会员投诉列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customerComplaint/listCustomerComplaint.action", 
				idField:"customerComplaintId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerName",title:"会员名称",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.customerComplaintId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerId+"</a>";  
		         	  }  
					},
					{field:"complaintType",title:"投诉类型",width:50,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "产品相关";} 
	                        if(value=="2"){ return "价格相关";} 
	                        if(value=="3"){ return "服务相关";} 
	                        if(value=="4"){ return "物流相关";} 
	                        if(value=="5"){ return "售后相关";} 
	                        if(value=="6"){ return "财务相关";} 
	                        if(value=="7"){ return "活动相关";} 
	                        if(value=="8"){ return "网站相关";} 
	                        if(value=="9"){ return "其它方面";} 
                         }
					},
					{field:"complaintOrdersNo",title:"订单号",width:80},
					{field:"state",title:"状态",width:50,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "审核中";} 
	                        if(value=="2"){ return "处理中";} 
	                        if(value=="3"){ return "已关闭";} 
                         }
					},
					{field:"createTime",title:"投诉时间",width:80}
					/* {field:"updName,delName",title:"操作",width:30, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.customerComplaintId+"' onclick='updOrDelSA(this.id,"+rowData.customerComplaintId+",1);'>"+"修改"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.customerComplaintId+"' onclick='updOrDelSA(this.id,"+rowData.customerComplaintId+",2);'>"+"删除"+"</a>";  
		         	  	}
					} */
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
				/* toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(900,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin"); 
						   $("#photo").html("");
						   $("#form1").css("display","");
						   $("#photoForm").css("display","");
						   $("#customerComplaintId").val(null);
					}
				},"-",{
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
											if(i==rows.length-1)ids+=rows[i].customerComplaintId;
											else ids+=rows[i].customerComplaintId+",";
										}
										$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/customerComplaint/deleteCustomerComplaint.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   $("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
									}	
								}
							});
						}
					}
				}] */
			});
			pageSplit(pageSize);//调用分页函数
		});
    	
    	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,500,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
			    $("#form1").css("display","");
			    $("#photoForm").css("display","");
    			$.ajax({
					   type: "POST", dataType: "JSON",
					  url: "${pageContext.request.contextPath}/back/customerComplaint/getCustomerComplaintObject.action",
					   data: {customerComplaintId:id},
					   success: function(data){
						   $("#customerComplaintId").val(data.customerComplaintId);
						   $("#customerId").val(data.customerId);
						   $("#complaintType").val(data.complaintType);
						   $("#complaintOrdersNo").val(data.complaintOrdersNo);
						   $("#complaintImageUrl").val(data.complaintImageUrl);
						   $("#photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.complaintImageUrl+"' width='120px' height='120px' />");
						   $("#complaintContext").val(data.complaintContext);
						   $("#state_"+data.state).attr("checked",true);
					   }
					});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/customer/deleteCustomerComplaint.action",
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
 	  	  	queryParams={complaintType:$("#qcomplaintType").val(),state:$("#qstate").val(),createTime:$("#qcreateTime").val()};
 	  	  	$("#tt").datagrid("load",queryParams); 
 	  	  	pageSplit(pageSize,queryParams);//调用分页函数
       	}
    </script>
  </head>
  <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  <body>
  		<span class="querybtn" style="font-size: 15px;">
  			投诉类型：<select id="qcomplaintType">
  					<option value="-1">--请选择--</option>
  					<s:iterator value="keyBookList">
  						<option value="<s:property value="value"/>"><s:property value="name"/></option>
  					</s:iterator>
  				   </select>&nbsp;&nbsp;
	                       状态 ：           <select id="qstate">
		              <option value="-1">--请选择--</option>
		              <option value="1">审核中</option>
		              <option value="2">处理中</option>
		              <option value="3">已关闭</option>
		            </select>&nbsp;&nbsp;
  			投诉时间：<input type="text" style="height: 23px;width: 160px;" id="qcreateTime" name="createTime" readonly="readonly"/>
  				  <img onclick="WdatePicker({el:'qcreateTime',dateFmt:'yyyy-MM-dd'})" 
				  src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>&nbsp;&nbsp;
  		</span>
	    <span >
	    	<a href="javascript:query();" id="btn1" iconCls="icon-search">查询</a>
	    </span>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
  		  <!-- 会员页面 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页面 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
