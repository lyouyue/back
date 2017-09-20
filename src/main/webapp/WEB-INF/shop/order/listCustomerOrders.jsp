<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员订单信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"订单信息列表",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersList.action?customerId=${customerId}",
				queryParams:{pageSize:pageSize},
				idField:"ordersId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"订单号",width:160, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.ordersId+"' onclick='showDetailInfo(this.id);'>"+rowData.ordersNo+"</a>";
		         	  }
					},
					{field:"loginName",title:"会员名称",width:120},
					{field:"shopName",title:"店铺名称",width:120},
					{field:"consignee",title:"收货人姓名",width:120},
					{field:"finalAmount",title:"应付金额(元)",width:100},
<%--					{field:"address",title:"收货地址",width:200},--%>
					{field:"settlementStatus",title:"付款状态",width:80,formatter:function(value,rowData,rowIndex){
					   if(value==0){
						    return"未付款";
					   }else if(value==1){
						    return"已付款";
					   }
					 }
					},
					{field:"ordersState",title:"订单状态",width:80,formatter:function(value,rowData,rowIndex){
						   if(value==0){
							    return"生成订单";
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
					},
					{field:"createTime",title:"订单生成时间",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"查看订单套餐",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择订单号！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							createWindow(700,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"view_Order_Products");
							$.ajax({
							   type: "POST",
							   dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/orders/findOrdersProduct.action",
							   data: {ordersNo:rows[0].ordersNo},
							   success: function(data){
								  var uploadFileVisitRoot = data.uploadFileVisitRoot;
								  var productMap = eval(data.productMap);
								  var html="<tr><th colspan='7'> 订单号："+data.ordersNo+"<\/th><\/tr>";
								  html += "<tr><td align='center' width='150px'>套餐图片<\/td><td align='center' width='150px'>套餐名称<\/td><td align='center' width='150px'>销售价<\/td><td align='center' width='150px'>运费<\/td>"+
								  "<td align='center' width='150px'>折扣<\/td><td align='center' width='150px'>赠送金币<\/td>";
								  for(var i=0;i<productMap.length;i++){
									  var zk = productMap[i].discount;
									  if(zk == null){
										  zk = "无折扣";
									  }else{
										  zk += "折";
									  }
									  html+="<tr><td align='center' width='150px'> <img width='80px' height='50px' src='"+uploadFileVisitRoot+productMap[i].logoImg+"'><\/img><\/td><td align='center' width='150px'>"+productMap[i].productFullName+"<\/td><td align='center' width='150px'>"+productMap[i].salesPrice+"<\/td><td align='center' width='150px'>"+productMap[i].freightPrice+"<\/td>"+
									  "<td align='center' width='150px'>"+zk+"<\/td><td align='center' width='150px'>"+productMap[i].virtualCoinNumber+"<\/td>";
								  }
								  $("#Order_Products").html(html);
							   }
							});
							createWindow(800,'auto',"&nbsp;&nbsp;查看订单套餐","icon-search",false,"view_Order_Products");
							$("#view_Order_Products").css("display","");
							$("#detailWin").css("display","none");
							$("#detailWin2").css("display","none");
						}
					}
				}
				,"-",{
					text:"查看日志",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择订单号！</p>", "warning");  
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
						}else if(rows.length==1){
							showDetailInfo2(rows[0].ordersNo);
							$("#detailWin2").css("display","");
							$("#view_Order_Products").css("display","none");
							$("#detailWin").css("display","none");
						}
					}
				},"-",{
					text:"返回会员列表",
					iconCls:"icon-back",
					handler:function(){
						//返回上一页
						window.location.href = document.referrer;
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});

    	function query(){
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,title:$("#title").val()};
			  $("#tt").datagrid("load",queryParams);
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#title").val("");
    	}
 </script>
</head>
<body >
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:70px;">&nbsp;&nbsp;&nbsp;&nbsp;订单号：</td>
				<td class="search_toleft_td">
					<input type="text" style="width: 160px;" id="title" name="title"/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;"">
			<form id="form1"></form>
			<jsp:include page="view_Order_Products.jsp"></jsp:include>
			<jsp:include page="detailOrders.jsp"></jsp:include>
			<jsp:include page="detailOrderOPLog.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>
