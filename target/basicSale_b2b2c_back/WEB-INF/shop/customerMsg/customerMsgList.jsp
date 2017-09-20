<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员留言列表页面</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"会员留言列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customerMsg/listCustomerMsg.action",
				queryParams:{pageSize:pageSize},
				idField:"customerMsgId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"留言主题",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.customerMsgId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					}, 
					{field:"type",title:"留言类型",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "留言";} 
	                        if(value=="2"){ return "投诉";} 
	                        if(value=="3"){ return "询问";} 
	                        if(value=="4"){ return "售后";} 
	                        if(value=="5"){ return "求购";} 
                         }
					},
					{field:"state",title:"留言状态",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>未回复</font>";} 
	                        if(value=="1"){ return "<font color='#0033FF'>已回复</font>";} 
                         }
					},
					{field:"createTime",title:"留言时间",width:120},
					{field:"updName,delName",title:"操作",width:120, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.customerMsgId+"' onclick='updOrDelSA(this.id,"+rowData.customerMsgId+",1);'>"+"修改"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.customerMsgId+"' onclick='updOrDelSA(this.id,"+rowData.customerMsgId+",2);'>"+"删除"+"</a>";  
		         	  	}
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(900,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#msg").val("");
						$("#backMsg").val("");
						$("#customerMsgId").val(null);
						//KindEditor添加清空
						KindEditor.instances[0].html('');
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
											if(i==rows.length-1)ids+=rows[i].customerMsgId;
											else ids+=rows[i].customerMsgId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/customerMsg/deleteCustomerMsg.action",
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,customerId:$("#parameCustomerId").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
		 
		 	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,500,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
    			$.ajax({
					   type: "POST", dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/customerMsg/getCustomerMsgObject.action",
					   data: {customerMsgId:id},
					   success: function(data){
						   $("#customerMsgId").val(data.customerMsgId);
						   $("#customerId").val(data.customerId);
						   $("#title").val(data.title);
						   $("#type").val(data.type);
						    if(data.state=="0"){
							   $("#state_0").attr("checked",true);
						   }else{
							   $("#state_1").attr("checked",true);
						   }
						   $("#createTime").val(data.createTime);
						   $("#msg").val(data.msg);
						    $("#backMsg").val(data.backMsg);
					   }
					});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/customerMsg/deleteCustomerMsg.action",
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
    <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  </head>
  
  <body>
  		<span style="font-size: 15px;">会员名称：
  			<select id="parameCustomerId">
	              <option value="-1">--请选择会员--</option>
				  <s:iterator value="customerList">
				  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
				  </s:iterator>
		    </select>
  		</span>
		<span ><a href="javascript:query();" id="btn1" iconCls="icon-search" >查询</a></span>
  		<table id="tt"></table>
  		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
