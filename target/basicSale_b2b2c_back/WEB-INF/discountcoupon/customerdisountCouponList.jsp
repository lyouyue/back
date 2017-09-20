<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员优惠券信息</title>
    <jsp:include page="../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"会员优惠券列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化 
				url:"${pageContext.request.contextPath}/back/discountcoupon/selcetCustomerdiscount.action",
				queryParams:{pageSize:pageSize},
				idField:"customerDiscountCouponID",//唯一性标示字段
				/* frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]], */
				columns:[[//未冻结字段
					{field:"discountCouponName",title:"劵名称",width:80}, 
					{field:"discountCouponCode",title:"券码",width:150}, 
					{field:"loginName",title:"会员名称",width:100}, 
					{field:"discountCouponLowAmount",title:"订单满额（元）",width:80},  
					{field:"discountCouponAmount",title:"抵扣金额（元）",width:80}, 
					{field:"useStatus",title:"使用状态",width:60,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						if(value==0){
							return "<font class='color_002'>未使用</font>";
						}else if(value==1){
							return "<font class='color_001'>已使用</font>";
						}else if(value==2){
							return "<font class='color_003'>已过期</font>";
						}		
		         	  }  
					},
					{field:"beginTime",title:"开始时间",width:120}, 
					{field:"expirationTime",title:"结束时间",width:120}, 
					{field:"createTime",title:"创建时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
				/*  toolbar:[
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
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].discountCouponID;
											else ids+=rows[i].discountCouponID+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/discountcoupon/deleteDiscountCoupon.action",
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
				}
				,"-",{
				text:"优惠券统计",
					iconCls:"icon-search",
					handler:function(){
						$.ajax({
							   type: "POST",dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/discountcoupon/selectCouponAmount.action",
							   success: function(data){
								   alert(data.unusedCouponAmount+"  |||  "+ data.useCouponAmount);
								   createWindow(null,null,"&nbsp;&nbsp;优惠券统计","icon-tip",false,"congeal");
								   $("#useCouponAmount").html(data.useCouponAmount);
								   $("#unusedCouponAmount").html(data.unusedCouponAmount);
							   }
							});
						}
					}
				]  */
			});
			pageSplit(pageSize);//调用分页函数
		});
    
     	
    	function query(){
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,ordersId:$("#parameOrdersId").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	
		function query(){
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopInfoId:$("#parameShopInfoId").val(),discountCouponAmount:$("#qdiscountCouponAmount").val(),
					  beginTime:$("#qbeginTime").val(),qloginName:$("#qloginName").val(),qdiscountCouponCode:$("#qdiscountCouponCode").val(),qdiscountCouponName:$("#qdiscountCouponName").val(),expirationTime:$("#qexpirationTime").val(),createTime:$("#qcreateTime").val(),useStatus:$("#quseStatus").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }

		function reset(){
			$("#qdiscountCouponName").val("");
	       	$("#qbeginTime").val("");
	    	$("#qexpirationTime").val("");
	    	$("#qcreateTime").val("");
	    	$("#quseStatus").val("");
	    	$("#qdiscountCouponCode").val("");
	    	$("#qloginName").val("");
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
	<jsp:include page="../util/item.jsp"/>
	<form id="form1"></form>
	<div class="main">
		<table  class="searchTab">
				<tr>
					<td  class="search_toright_td" style="width:60px;">劵名称 ：</td>
					<td class="search_toleft_td" style="width: 100px;">
						<input type="text"  id="qdiscountCouponName" name="qdiscountCouponName" style="width:90px;" class="searchTabinput"/>
					</td>
					<td class="search_toright_td" style="width: 38px;">劵码：</td>
					<td class="search_toleft_td" style="width:100px;"><input type="text"  id="qdiscountCouponCode" name="qdiscountCouponCode" style="width:90px;" class="searchTabinput"/>
					</td>
					<td class="search_toright_td" style="width:65px;">会员名称 ：</td>
					<td class="search_toleft_td" style="width: 100px;">
						<input type="text"  id="qloginName" name="qloginName" style="width:90px;" class="searchTabinput"/>
					</td>
					<td class="search_toright_td" style="width: 63px;">使用状态：</td>
					<td class="search_toleft_td" style="width: 100px;">
						<select id="quseStatus" class="querySelect">
							<option value="">--请选择--</option>
							<option value="0">未使用</option>
							<option value="1">已使用</option>
							<option value="2">已过期</option>
						</select>
					</td>
					<td  class="search_toright_td" style="width:60px;">活动时间：</td>
					<td class="search_toleft_td" style="width:240px;">
						<input id="qbeginTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qexpirationTime\')}'})"/>
						- <input id="qexpirationTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qbeginTime\')}'})"/>
					</td>
					<td  class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
			</table>
			<table id="tt"></table>
			<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
			<jsp:include page="congeal.jsp"/>
			</div>
	</div>
</body>
</html>
