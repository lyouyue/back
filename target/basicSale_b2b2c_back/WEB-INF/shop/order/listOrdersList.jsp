<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>订单明细信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
    	    //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/orders/saveOrUpdateOrdersList.action",  
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
				/* title:"订单明细列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersListList.action",
				queryParams:{pageSize:pageSize},
				idField:"orderDetailId",//唯一性标示字段
				/* frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]], */
				columns:[[//未冻结字段
		          {field:"title",title:"订单号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.ordersNo+"' onclick='showDetailInfo(this.id);'>"+rowData.ordersNo+"</a>";  
		         	  }  
					}, 
					{field:"logoImg",title:"商品图片",width:120,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='60px' height='30px'/>";
						}
					},
					{field:"shopName",title:"店铺名称",width:120},
					{field:"shopInfoType",title:"店铺类型",width:80,formatter:function(value,rowData,rowIndex){
						   if(value==1){
							    return"自营店铺";
						   }else if(value==2){
							    return"入驻店铺";
						   }
					 }
					},
					{field:"loginName",title:"下单人",width:120},
					{field:"ordersState",title:"订单状态",width:120,formatter:function(value,rowData,rowIndex){
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
						   }else if(value==9){
							    return"已评价";
						   }else if(value==0){
							   return "生成订单";
						   }
						}
					},
					{field:"createTime",title:"下单时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
			});
			pageSplit(pageSize);//调用分页函数
		});
    
    	function query(){
		  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,title:$("#quserName").val(),shopInfoType:$("#qshopInfoType").val()};
		  $("#tt").datagrid("load",queryParams); 
		  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	
    	function updOrDelSA(id,rowid,flag){
			if(flag == 1){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==1){
					createWindow(700,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
					$.ajax({
					   type: "POST", 
					   dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/orders/getOrderListObject.action",
					   data: {orderDetailId:rows[0].orderDetailId},
					   success: function(data){
						   $("#orderDetailId").val(data.orderDetailId);
						   $("#"+data.ordersId).attr("selected",true);
						   $("#p_"+data.productId).attr("selected",true);
						   $("#count").val(data.count);
					   }
					});
				}
			}else{
				$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
					function(data){
					if(data == true)
						$.ajax({
							   type: "POST",
							   dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/orders/deleteOrdersList.action",
							   data: {ids:id},
							   success: function(data){
								   $("#tt").datagrid("clearSelections");//删除后取消所有选项
								   $("#tt").datagrid("reload"); //删除后重新加载列表
							   }
							});
				});
			}
		}
    	function reset(){
    		$("#quserName").val("");
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
				<td class="search_toright_td" style="width:70px;">订单号：</td>
				<td class="search_toleft_td" style="width:170px;"><input type="text" id="quserName" name="s_name"  style="width:160px;" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:70px;;">店铺类型：</td>
				<td class="search_toleft_td" style="width:120px;">
					<select id="qshopInfoType" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">自营店铺</option>
						<option value="2">入驻店铺</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<jsp:include page="addOrEditOrdersList.jsp"></jsp:include>
				<jsp:include page="detailOrderList.jsp"></jsp:include>
			</div>
		</div>
	</body>
</html>
