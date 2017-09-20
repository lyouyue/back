<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <title>订单日志信息</title>
    <jsp:include page="../../util/import.jsp"/>
    
    <script type="text/javascript">
    $(function(){
    	    //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/orders/saveOrUpdateOrdersOPLog.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                  });
		       }
		    });
		   $("#tt").datagrid({//数据表格
				/* title:"订单操作日志列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true, //true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersOPLogList.action",
				queryParams:{pageSize:pageSize},
				idField:"ordersOPLogId", //唯一性标示字段
				frozenColumns:[[//冻结字段 
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"ordersNo",title:"订单号",width:120},
					{field:"shopName",title:"店铺名称",width:120},
					{field:"shopInfoType",title:"店铺类型",width:80,formatter:function(value,rowData,rowIndex){
						   if(value==1){
							    return"自营店铺";
						   }else if(value==2){
							    return"入驻店铺";
						   }
					 }
					},
					/* {field:"ordersState",title:"订单状态",width:150,formatter:function(value,rowData,rowIndex){
							if(value==3){
							    return"正在配货";
						   }else if(value==4){
							    return"已发货";
						   }else if(value==5){
							    return"完成";
						   }else if(value==6){
							    return"已取消";
						   }else if(value==7){
							    return"异常订单";
						   }else {
							   return"生成订单";
						   }
						}
					}, */
					{field:"ordersOperateState",title:"订单操作",width:120,formatter:function(value,rowData,rowIndex){
						 var state;
						 if(value==0||value==1){
							   state="生成订单";
						   }else if(value==2){
							   state="已付款";
						   }else if(value==3){
							   state="已配货";
						   }else if(value==4){
							   state="已发货";
						   }else if(value==5){
							   state="完成";
						   }else if(value==6){
							   state="取消订单";
						   }else if(value==7){
							   state="异常订单";
						   }else if(value==8){
							   state="修改订单";
						   }else if(value==9){
							   state="已评价";
						   }
						 return state;
						}
					},
					{field:"operatorName",title:"操作人",width:120},
					{field:"operatorTime",title:"操作时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
			});
			pageSplit(pageSize);//调用分页函数
		});
    
    	function query(){
		  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,title:$("#title").val(),shopInfoType:$("#qshopInfoType").val()};
		  $("#tt").datagrid("load",queryParams); 
		  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	
    	function updOrDelSA(id,rowid){
				$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
					function(data){
					if(data == true)
						$.ajax({
							   type: "POST",
							   dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/orders/deleteOrdersOPLog.action",
							   data: {ids:id},
							   success: function(data){
								   $("#tt").datagrid("clearSelections");//删除后取消所有选项
								   $("#tt").datagrid("reload"); //删除后重新加载列表
							   }
							});
				});
		}
    	function reset(){
    		$("#title").val("");
    		$("#qshopInfoType").val("");
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
		<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
		<div class="main">
			<table class="searchTab">
					<tr>
				<td class="search_toright_td" style=" width: 70px;">&nbsp;&nbsp;&nbsp;&nbsp;订单号：</td>
				<td align="left" style="width:170px;"><input type="text" id="title" name="title"  style="width:160px;" class="searchTabinput"/></td>
				<td align="right" style="width:70px;;">店铺类型：</td>
				<td align="left" style="width:120px;">
					<select id="qshopInfoType" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">自营店铺</option>
						<option value="2">入驻店铺</option>
					</select>
				</td>
				<td align="left">
<!-- 				<tr>
				<td class="search_toright_td" style=" width: 70px;">&nbsp;&nbsp;&nbsp;&nbsp;订单号：</td> -->
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
 			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!--<jsp:include page="addOrEditOrdersOPLog.jsp"></jsp:include> -->
				<jsp:include page="detailOrderOPLog.jsp"></jsp:include>
			</div>
			<form id="form1"></form>
		</div>
</body>
</html>