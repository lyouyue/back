<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员评价列表页面</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"会员评价列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customerReview/listCustomerReview.action",
				queryParams:{pageSize:pageSize},
				idField:"customerReviewId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"评价主题",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.customerReviewId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					}, 
					{field:"level",title:"评价级别",width:120},
					{field:"state",title:"审核状态",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>未审核</font>";} 
	                        if(value=="1"){ return "<font color='#0033FF'>已审核</font>";} 
                         }
					},
					{field:"backState",title:"回复状态",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>未回复</font>";} 
	                        if(value=="1"){ return "<font color='#0033FF'>已回复</font>";} 
                         }
					},
					{field:"createTime",title:"评价时间",width:120}
					/* {field:"updName,delName",title:"操作",width:120, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.customerReviewId+"' onclick='updOrDelSA(this.id,"+rowData.customerReviewId+",1);'>"+updName+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.customerReviewId+"' onclick='updOrDelSA(this.id,"+rowData.customerReviewId+",2);'>"+delName+"</a>";  
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
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#msg").val("");
						$("#backMsg").val("");
						$("#customerReviewId").val(null);
							var ss = "";
							for(var i=1;i<6;i++){
								ss = ss + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
							}
							$("#xingxing").html(ss);
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
											if(i==rows.length-1)ids+=rows[i].customerReviewId;
											else ids+=rows[i].customerReviewId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/customerReview/deleteCustomerReview.action",
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
				}] */
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
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==1){
					createWindow(900,500,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
					$.ajax({
					   type: "POST", dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/customerReview/getCustomerReviewObject.action",
					   data: {customerReviewId:rows[0].customerReviewId},
					   success: function(data){
						   $("#customerReviewId").val(data.customerReviewId);
						   $("#customerId").val(data.customerId);
						   $("#productId").val(data.productId);
						   $("#title").val(data.title);
						   var tt = "";
						   var num = data.level;
							if(num==1){
							 	tt = tt +"<img id='"+num+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
							 	for(var i=2;i<6;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								}
						 	}else if(num==2){
								 for(var i=1;i<3;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
								 for(var i=3;i<6;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
						 	}else if(num==3){
								 for(var i=1;i<4;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
								 for(var i=4;i<6;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
						 	}else if(num==4){
								 for(var i=1;i<5;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
								 for(var i=5;i<6;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
						 	}else if(num==5){
								 for(var i=1;i<6;i++){
									 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
								 }
						 	}
						   $("#xingxing").html(tt);
						   $("#content").val(data.content);
						   $("#advantage").val(data.advantage);
						   $("#shortcoming").val(data.shortcoming);
						    if(data.state=="0"){
							   $("#state_0").attr("checked",true);
						   }else{
							   $("#state_1").attr("checked",true);
						   }
						   $("#backReview").val(data.backReview);
						   if(data.backState=="0"){
							   $("#backState_0").attr("checked",true);
						   }else{
							   $("#backState_1").attr("checked",true);
						   }
						   $("#createTime").val(data.createTime);
						    
					   }
					});
				}
			}else{
				$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
					function(data){
					if(data == true)
						$.ajax({
							   type: "POST",dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/customerReview/deleteCustomerReview.action",
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
