<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>归档订单</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"归档订单",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersList.action",
				queryParams:{pageSize:pageSize, orderState: 5},
				idField:"ordersId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"订单号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.ordersId+"' onclick='showDetailInfo(this.id);'>"+rowData.ordersNo+"</a>";  
		         	  }  
					},
					{field:"createTime",title:"订单生成时间",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}},
					{field:"consignee",title:"收货人姓名",width:120},
					{field:"finalAmount",title:"应付金额(元)",width:200}, 
<%--					{field:"address",title:"收货地址",width:200},--%>
					{field:"ordersState",title:"订单状态",width:200,formatter:function(value,rowData,rowIndex){
						if(value==2){
						    return"已付款";
					   }else if(value==3){
						    return"正在配货";
					   }else if(value==4){
						    return"已发货";
					   }else if(value==5){
						    return"完成";
					   }else if(value==6){
						    return"已取消";
					   }else if(value==7){
						    return"异常订单";
					   }else if(value==1){
						    return"<font color='#EE0000'>未付款</font>";
					   }else if(value==9){
						    return"已评价";
					   }
					 }
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
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
  		<span class="querybtn" style="font-size: 15px;">订单号：<input type="text" style="width: 160px;" id="qordersNo" name="title"/></span>
	    <span ><a href="javascript:query();" id="btn1" iconCls="icon-search"  >查询</a></span>  
  		<table id="tt"></table>
  		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
  		<jsp:include page="addOrEditOrders.jsp"></jsp:include>
  		<jsp:include page="detailOrders.jsp"></jsp:include>
		</div>
  </body>
</html>
