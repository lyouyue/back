<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>已评价订单信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"已评价订单",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersList.action",
				queryParams:{pageSize:pageSize, orderState:9},
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
					{field:"finalAmount",title:"应付金额(元)",width:120},
<%--					{field:"address",title:"收货地址",width:200},--%>
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
					{field:"ordersState",title:"订单状态",width:120,formatter:function(value,rowData,rowIndex){
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
						    return"<font class='color_002'>未付款</font>";
					   }else if(value==9){
						   return"已评价";
					   }
					 }
					},
					{field:"createTime",title:"订单生成时间",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}},
					{field:"updateTime",title:"订单评价时间",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
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
								  var html="<tr class='titlebg'><td align='center' colspan='7'> 订单号："+data.ordersNo+"<\/td><\/tr>";
								  html += "<tr><td align='center' width='150px'>图片<\/td><td align='center' width='150px'>商品名称<\/td><td align='center' width='150px'>销售价<\/td><td align='center' width='150px'>运费<\/td>"+
								  "<td align='center' width='150px'>折扣<\/td><td align='center' width='150px'>赠送金币<\/td><\/tr>";
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
									  if(virtualCoinNumber==null || virtualCoinNumber==""){
										  virtualCoinNumber=0;
									  }
									  if(salesPrice==null || salesPrice==""){
										  salesPrice=0;
									  }
									  if(freightPrice==null || freightPrice==""){
										  freightPrice=0;
									  }
									  html+="<tr><td align='center' width='150px'> <img width='80px' height='50px' src='"+uploadFileVisitRoot+productMap[i].logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'><\/img><\/td><td align='center' width='150px'>"+productMap[i].productFullName+"<\/td><td align='center' width='150px'>"+salesPrice+" 元"+"<\/td><td align='center' width='150px'>"+freightPrice+" 元"+"<\/td>"+
									  "<td align='center' width='150px'>"+zk+"<\/td><td align='center' width='150px'>"+virtualCoinNumber+" 个"+"<\/td><\/tr>";
								  }
								  $("#Order_Products").html(html);
							   }
							});
							 createWindow(800,450,"&nbsp;&nbsp;查看订单商品","icon-search",false,"view_Order_Products");
							 $("#detailWin2").css("display","none");
							 $("#view_Order_Products").css("display","");
							 $("#detailWin").css("display","none");
						}
					}
				}
				,"-",{
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
		    queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,ordersNo:$("#qordersNo").val(),shopInfoType:$("#qshopInfoType").val(),orderSource:$("#qorderSource").val()};
		    $("#tt").datagrid("load",queryParams);
		    pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#qordersNo").val("");
    		$("#qshopInfoType").val("");
    		$("#qorderSource").val("");
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
		<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
		<div class="main">
			<table class="searchTab">
				<tr>
					<td class="search_toright_td" style="width:70px;">订单号：</td>
					<td class="search_toleft_td" style="width:170px;"><input type="text" id="qordersNo" name="s_name"  style="width:160px;" class="searchTabinput"/></td>
					<td class="search_toright_td" style="width:70px;;">店铺类型：</td>
					<td class="search_toleft_td" style="width:120px;">
						<select id="qshopInfoType" class="querySelect">
							<option value="">--请选择--</option>
							<option value="1">自营店铺</option>
							<option value="2">入驻店铺</option>
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
		<div id="win" style="display:none;">
		<form id="form1"></form>
			<jsp:include page="detailOrders.jsp"></jsp:include>
			<jsp:include page="view_Order_Products.jsp"></jsp:include>
			<jsp:include page="detailOrderOPLog.jsp"></jsp:include>
		</div>
	</div>
	</body>
</html>
