<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>全部订单信息</title>
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
				url:"${pageContext.request.contextPath}/back/orders/ordersList.action",
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
					{field:"shopInfoType",title:"店铺类型",width:80,formatter:function(value,rowData,rowIndex){
						   if(value==1){
							    return"自营店铺";
						   }else if(value==2){
							    return"入驻店铺";
						   }
					 }
					},
					{field:"consignee",title:"收货人姓名",width:120},
					{field:"finalAmount",title:"应付金额(元)",width:100},
<%--					{field:"address",title:"收货地址",width:200},--%>
					{field:"settlementStatus",title:"付款状态",width:80,formatter:function(value,rowData,rowIndex){
					   if(value==0){
						    return"<font class='color_002'>未付款</font>";
					   }else if(value==1){
						    return"<font class='color_001'>已付款</font>";
					   }
					 }
					},
					{field:"orderSource",title:"订单来源",width:100,formatter:function(value,rowData,rowIndex){
							if(value==1){
								return"正常购物pc下单";
							}else if(value==2){
								return"pc团购下单";
							}else if(value==3){
								return"手机web下单";
							}else if(value==4){
								return"手机团购下单";
							}else if(value==5){
								return"微信下单";
							}else if(value==6){
								return"微信团购下单";
							}else if(value==7){
								return"APP IOS下单";
							}else if(value==8){
								return"APP ANDROID下单";
							}else if(value==9){
								return"抢购PC下单";
							}else if(value==10){
								return"抢购PHONE下单";
							}else if(value==11){
								return"抢购微信下单";
							}else if(value==12){
								return"抢购APP下单";
							}else if(value==13){
								return"组合购PC下单";
							}else if(value==14){
								return"组合购PHONE下单";
							}else if(value==15){
								return"组合购微信下单";
							}else if(value==16){
								return"组合购APP下单";
							}else if(value==17){
								return"积分商城PC下单";
							}else if(value==18){
								return"积分商城PHONE下单";
							}else if(value==19){
								return"积分商城微信下单";
							}else if(value==20){
								return"积分商城APP下单";
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
							    return"待评价";
						   }else if(value==6){
							    return"已取消";
						   }else if(value==7){
							    return"异常订单";
						   }else if(value==1){
							    return"<font class='color_002'>未付款</font>";
						   }else if(value==9){
							    return"已评价";
						   }
					 }
					},
					{field:"createTime",title:"订单生成时间",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}},
					{field:"updateTime",title:"订单修改时间",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[//工具条
				    <%
					if("orderProduct".equals((String)functionsMap.get(purviewId+"_orderProduct"))){
					%>
				    {
					text:"查看订单商品",
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
								  var html="<tr class='titlebg'>" +
										  "<td align='center' colspan='13'> 订单号："+data.ordersNo+"</td>" +
										  "</tr>";
								  html += "<tr>" +
										  "<td align='center' width='150px'>图片</td>" +
										  "<td align='center' width='150px'>商品名称</td>" +
										  "<td align='center' width='150px'>销售价</td>" +
										  "<td align='center' width='150px'>数量</td>" +
										  "<td align='center' width='150px'>运费</td>"+
										  "<td align='center' width='150px'>折扣</td>" +
										  "<td align='center' width='150px'>赠送金币</td>" +
										  "<td align='center' width='150px'>返利比例(一级)</td>" +
										  "<td align='center' width='150px'>返利比例(二级)</td>" +
										  "<td align='center' width='150px'>返利比例(三级)</td>" +
										  "<td align='center' width='150px'>返利金额(一级)</td>" +
										  "<td align='center' width='150px'>返利金额(二级)</td>" +
										  "<td align='center' width='150px'>返利金额(三级)</td>" +
										  "</tr>";
								  for(var i=0;i<productMap.length;i++){
									  var zk = productMap[i].discount;
									  if(zk == null){
										  zk = "无折扣";
									  }else{
										  zk += "折";
									  }
									  var virtualCoinNumber=productMap[i].virtualCoinNumber;
									  var salesPrice=productMap[i].salesPrice;
									  var freightPrice=productMap[i].freightPrice;
									  //返利信息
									  var upRatio=productMap[i].upRatio;
									  var secRatio=productMap[i].secRatio;
									  var thiRatio=productMap[i].thiRatio;
									  var upRatioAmount=productMap[i].upRatioAmount;
									  var secRatioAmount=productMap[i].secRatioAmount;
									  var thiRatioAmount=productMap[i].thiRatioAmount;
									  if(virtualCoinNumber==null || virtualCoinNumber==""){
										  virtualCoinNumber=0;
									  }
									  if(salesPrice==null || salesPrice==""){
										  salesPrice=0;
									  }
									  if(freightPrice==null || freightPrice==""){
										  freightPrice=0;
									  }
									  html+="<tr>" +
											  "<td align='center' width='85px'><img width='80px' height='50px' src='"+uploadFileVisitRoot+productMap[i].logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'/></td>" +
									  "<td align='center' width='120px'>"+productMap[i].productFullName+"</td>" +
											  "<td align='center' width='50px'>"+salesPrice+" 元"+"</td>" +
									  "<td align='center' width='150px'>"+productMap[i].count+"</td>" +
									  "<td align='center' width='50px'>"+freightPrice+" 元"+"</td>" +
											  "<td align='center' width='50px'>"+zk+"</td><td align='center' width='50px'>"+virtualCoinNumber+" 个"+"</td><td align='center' width='50px'>"+upRatio+"%"+"</td><td align='center' width='50px'>"+secRatio+"%"+"</td><td align='center' width='50px'>"+thiRatio+"%"+"</td><td align='center' width='50px'>"+upRatioAmount+"元"+"</td><td align='center' width='50px'>"+secRatioAmount+" 元"+"</td><td align='center' width='50px'>"+upRatioAmount+" 元"+"</td></tr>";
								  }
								  $("#Order_Products").html(html);
							   }
							});
							createWindow(1000,450,"&nbsp;&nbsp;查看订单商品","icon-search",false,"view_Order_Products");
							$("#view_Order_Products").css("display","");
							$("#detailWin").css("display","none");
							$("#detailWin2").css("display","none");
						}
					}
				}
				,"-",
				<%
				}
				if("oplog".equals((String)functionsMap.get(purviewId+"_oplog"))){
				%>
				{
					text:"查看订单日志",
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
				},"-",
				<%
				}
				%>
				{text:"刷新",
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,ordersNo:$("#qordersNo").val(),shopInfoType:$("#qshopInfoType").val(),orderState:$("#qordersState").val(),orderSource:$("#qorderSource").val()};
			  $("#tt").datagrid("load",queryParams);
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#qordersNo").val("");
    		$("#qshopInfoType").val("");
    		$("#qordersState").val("");
    		$("#qorderSource").val("");
    	}
 </script>
</head>
<body >
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:70px;">订单号：</td>
				<td class="search_toleft_td" style="width:170px;"><input type="text" id="qordersNo" name="s_name"  style="width:160px;" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:70px;;">店铺类型：</td>
				<td class="search_toleft_td" style="width:100px;">
					<select id="qshopInfoType" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">自营店铺</option>
						<option value="2">入驻店铺</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:70px;">订单状态：</td>
				<td class="search_toleft_td" style="width:120px;">
					<select id="qordersState" class="querySelect">
						<option value="">--请选择--</option>
						<option value="0">生成订单</option>
						<option value="3">正在配货</option>
						<option value="4">已发货</option>
						<option value="5">待评价</option>
						<option value="6">已取消</option>
						<option value="7">异常订单</option>
						<option value="9">已评价</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:70px;">订单来源：</td>
				<td class="search_toleft_td" style="width:120px;">
					<select id="qorderSource" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">正常购物pc下单</option>
						<option value="2">pc团购下单</option>
						<option value="3">手机web下单</option>
						<option value="4">手机团购下单</option>
						<option value="5">微信下单</option>
						<option value="6">微信团购下单</option>
						<option value="7">APP IOS下单</option>
						<option value="8">APP ANDROID下单</option>
						<option value="9">抢购PC下单</option>
						<option value="10">抢购PHONE下单</option>
						<option value="11">抢购微信下单</option>
						<option value="12">抢购APP下单</option>
						<option value="13">组合购PC下单</option>
						<option value="14">组合购PHONE下单</option>
						<option value="15">组合购微信下单</option>
						<option value="16">组合购APP下单</option>
						<option value="17">积分商城PC下单</option>
						<option value="18">积分商城PHONE下单</option>
						<option value="19">积分商城微信下单</option>
						<option value="20">积分商城APP下单</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
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
