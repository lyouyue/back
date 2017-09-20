<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>已锁定订单信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"已锁定订单信息列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersList.action?isLocked=1",
				queryParams:{pageSize:pageSize},                                                                
				idField:"ordersId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"订单号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.ordersId+"' onclick='showDetailInfo(this.id);'>"+rowData.ordersNo+"</a>";  
		         	  }  
					}, 
					{field:"createTime",title:"订单生成时间",width:120},
					{field:"consignee",title:"收货人姓名",width:120},
					{field:"lastName",title:"最后姓名",width:120},
					{field:"finalAmount",title:"应付金额(元)",width:200}, 
<%--					{field:"address",title:"收货地址",width:200},--%>
					{field:"ordersState",title:"订单状态",width:200,formatter:function(value,rowData,rowIndex){
						   if(value==2){
							    return"订单确认";
						   }else if(value==3){
							    return"收款确认";
						   }else if(value==4){
							    return"正在配货";
						   }else if(value==5){
							    return"已经发货";
						   }else if(value==6){
							    return"收货确认";
						   }else if(value==7){
							    return"确认作废";
						   }else if(value==1){
							    return"<font color='#EE0000'>未处理</font>";
						   }else if(value==9){
							    return"已评价";
						   }
					 }
					},
					{field:"isLocked",title:"锁定状态",width:200,formatter:function(value,rowData,rowIndex){
						   if(value==0){
							    return"<font color='#EE0000'>未锁定</font>";
						   }else{
							    return"<font color='#0033FF'>已锁定</font>";
						   }
					 }
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
				/* toolbar:[{
					text:"订单解锁", 
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择解锁项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够解锁一项！</p>", "warning");
						}else if(rows.length==1){
							$.ajax({
							   type: "POST", 
							   dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/orders/relieveLockedState.action",
							   data: {h_rordersNo:rows[0].ordersNo},
							   success: function(data){
								   if(data.isSuccess=="true")$("#tt").datagrid("reload");
							   }
							});
						}
					}
				}] */
			});
			pageSplit(pageSize);//调用分页函数
		});
    
    	function query(){
		  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,ordersNo:$("#qordersNo").val()};
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
  <body onload="setup('省份','地级市','市、县级市、县')">
  		<span class="querybtn" style="font-size: 15px;">订单号：<input type="text" style="height: 23px;width: 160px;" id="qordersNo" name="title"/></span>
	    <span ><a href="javascript:query();" id="btn1" iconCls="icon-search"  >查询</a></span>  
  		<table id="tt"></table>
  		<div id="win" style="display:none;">
  		<jsp:include page="addOrEditOrders.jsp"></jsp:include>
  		<jsp:include page="detailOrders.jsp"></jsp:include>
  		<jsp:include page="reviewOrders.jsp"></jsp:include>
		</div>
  </body>
</html>
