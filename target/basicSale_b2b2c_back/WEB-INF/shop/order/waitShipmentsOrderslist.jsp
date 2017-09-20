<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <title>已经配货订单信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"已经配货订单",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/orders/ordersList.action",
				queryParams:{pageSize:pageSize, orderState:3},
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
					{field:"shopName",title:"店铺名称",width:100},
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
					{field:"ordersState",title:"订单状态",width:100,formatter:function(value,rowData,rowIndex){
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
					{field:"createTime",title:"订单生成时间",width:140, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}},
					{field:"updateTime",title:"订单配货时间",width:140, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
					}},
					{field:"shopInfoType",title:"操作",width:80,
						formatter:function(value,rowData,rowIndex){
							if(rowData.sendType!=3){//不是线下自取
								$("#ordersId").val(rowData.ordersId);//给隐藏域赋值
								if(value==1){
									return "<a id='"+rowData.ordersId+"' onclick='changeSend(this.id,"+rowData.sendType+");'>发货</a>";
								}else{
									return "--";
								}
							}else{
								return "--";
							}
						}
					}
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
							$("#sendGoodsWin").css("display","none");
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
							$("#sendGoodsWin").css("display","none");
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
	<body>
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
			<jsp:include page="sendGoods.jsp"></jsp:include>
			<jsp:include page="view_Order_Products.jsp"></jsp:include>
			<jsp:include page="detailOrderOPLog.jsp"></jsp:include>
		</div>
	</div>
	<%-- <div id="deliver-goods-overlay" style="width:560px;height: 250px; background-color: #fff;border: 2px solid #facbd6; border-radius: 5px; padding: 15px; position: absolute;top:150px; left:15%; z-index:9; display:none;">
		<form onsubmit="return removeAttrRadioDisplay();" method="post" id="deliver-goods-form" action="${pageContext.request.contextPath}/back/orders/changeShipments.action">
			<h2 class="modal-title" style="text-align:center;height:30px; font-size:13px;">
				<input id="logisticsType_1"  type="radio" name="logisticsType" value="1" onclick="choice(this.value)"/>物流公司信息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="logisticsType_2"  type="radio" name="logisticsType" value="2" onclick="choice(this.value)"/>同城配送信息
			</h2>
			<input type="hidden" id="ordersId" name="orders.ordersId" value=""/>
			<table id="type1">
				<tr>
					<td class="toright_td">物流单号:</td>
					<td><input style="height:13px;"  type="text" name="shipping.deliverySn" value="" class="{validate:{required:true,onlyCharAndNumber:true,maxlength:[20]}} us_input"/></td>
				</tr>

				<tr>
					<td class="toright_td">物流公司名称:</td>
					<td colspan="3" >
					<select id="code" name="shipping.code" class="{validate:{required:true}} select_zx" ></select>
					<span id="codeError" style=""></span>
					</td>
				</tr>
			</table>
			<table id="type2">
				<tr>
					<td class="toright_td">区域:</td>
					<td>
						<select id="province" onchange="chengeArea(this.value,'1')">
							<option value="">省</option>
							<s:iterator value="provinceList" var="first">
								<option  value="<s:property value="#first.areaId"/>"><s:property value="#first.name"/></option>
							</s:iterator>
						</select>
						<select id="cities" onchange="chengeArea(this.value,'2')">
							<option value="">地级市</option>
						</select>
						<select id="district" onchange="chengeArea(this.value,'3')">
							<option value="">区(县)</option>
						</select>
					</td>
				</tr>
				<tr id="type2_1">
					<td class="toright_td">快递信息:</td>
					<td colspan="3">
					<select id="cityCourier" name="cityCourier.cityCourierId" class="{validate:{required:true}}"></select><span id="cityCourierError"></span>
					</td>
				</tr>
			</table>
			 <div style="width:auto; height:auto; margin-top:25px; padding-left:56px;">
				<p class="modal-buttons">
					<button class="us_submit" type="submit"  id="shipmentsButton" onfocus="javascript:changeShipments();">提交</button>
					<button class="us_submit" onclick="close_div()" type="button">关闭</button>
				</p>
			</div>
		</form>
	</div> --%>
	</body>
</html>
