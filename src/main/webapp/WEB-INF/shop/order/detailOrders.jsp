<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
	//提交
	function showDetailInfo(id){
		createWindow(1100,485,"&nbsp;&nbsp;订单详情","icon-tip",false,"detailWin",10);
		$("#detailWin").css("display","");
		$("#view_Order_Products").css("display","none");
		$("#detailWin2").css("display","none");
		$("#sendGoodsWin").css("display","none");
		$.ajax({
			type: "POST",
			dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/orders/getOrdersObject.action",
			data: {ordersId:id},
			success: function(data){
				var orders = data.orders;
				var customer = data.customer;
				var shopInfo = data.shopInfo;
				var egList = data.egList;
				if(customer!=null&&customer!=""){
					$("#customerName").html(customer.loginName);
				}
				/**发票信息*/
				if(orders.invoiceType=="3"){
					$(".zengZhi").removeAttr("style");
					$(".puTong").attr("style","display:none;");
					$("#d_invoiceType").html("增值税发票");
					$("#d_cNFInvoice").html(orders.companyNameForInvoice);
					$("#d_taxpayerNumber").html(orders.taxpayerNumber);
					$("#d_addressForInvoice").html(orders.addressForInvoice);
					$("#d_phoneForInvoice").html(orders.phoneForInvoice);
					$("#d_openingBank").html(orders.openingBank);
					$("#d_bankAccountNumber").html(orders.bankAccountNumber);
				}else if(orders.invoiceType=="2"){
					$(".puTong").removeAttr("style");
					$(".zengZhi").attr("style","display:none;");
					$("#d_invoiceType").html("普通发票");
					$("#d_cNFInvoice").html(orders.companyNameForInvoice);
					$("#d_invoiceInfo").html(orders.invoiceInfo);
				}else{
					$(".zengZhi").attr("style","display:none;");
					$(".puTong").attr("style","display:none;");
					$("#d_invoiceType").html("默认");
				}
				/**发票信息*/
				$("#d_shopName").html(shopInfo.shopName);
				$("#d_shopAddress").html(shopInfo.address);
				$("#d_postCode").html(shopInfo.postCode);
				$("#d_createTime").html(orders.createTime);
				$("#d_ordersNo").html(orders.ordersNo);
				$("#d_consignee").html(orders.consignee);
				$("#d_email").html(orders.email);
				$("#d_address").html(orders.address);
				$("#d_phone").html(orders.phone);
				$("#d_mobilePhone").html(orders.mobilePhone);
				//三级返利金额
				$("#d_upRatioAmount").html(orders.rebateAmount);
				$("#d_secRatioAmount").html(orders.secRebateAmount);
				$("#d_thiRatioAmount").html(orders.thiRebateAmount);
				if(orders.payMode=="2"){
					$("#d_payMode").html("支付宝");
				}else if(orders.payMode=="1"){
					$("#d_payMode").html("微信支付");
				}else if(orders.payMode=="4"){
					$("#d_payMode").html("网银支付");
				}
				if(orders.sendType=="1"){//配送方式
					$("#d_sendType").html("快递公司");
				}else if(orders.sendType=="2"){
					$("#d_sendType").html("同城快递");
				}else{
					$("#d_sendType").html("线下自取");
				}
				$("#d_productSumNumber").html(orders.totalAmount);
				$("#dchangeAmount").html(orders.changeAmount);
				$("#dorderCouponAmount").html(orders.orderCouponAmount);
				$("#duserCoin").html(orders.userCoin);
				$("#dvirtualCoinNumber").html(orders.virtualCoinNumber);
				if(orders.orderSource=="1"){
					$("#d_orderSource").html("正常购物pc下单");
				}else if(orders.orderSource=="2"){
					$("#d_orderSource").html("pc团购下单");
				}else if(orders.orderSource=="3"){
					$("#d_orderSource").html("手机web下单");
				}else if(orders.orderSource=="4"){
					$("#d_orderSource").html("手机团购下单");
				}else if(orders.orderSource=="5"){
					$("#d_orderSource").html("微信下单");
				}else if(orders.orderSource=="6"){
					$("#d_orderSource").html("微信团购下单");
				}else if(orders.orderSource=="7"){
					$("#d_orderSource").html("APP IOS下单");
				}else if(orders.orderSource=="8"){
					$("#d_orderSource").html("APP ANDROID下单");
				}else if(orders.orderSource=="9"){
					$("#d_orderSource").html("抢购PC下单");
				}else if(orders.orderSource=="10"){
					$("#d_orderSource").html("抢购PHONE下单");
				}else if(orders.orderSource=="11"){
					$("#d_orderSource").html("抢购微信下单");
				}else if(orders.orderSource=="12"){
					$("#d_orderSource").html("抢购APP下单");
				}else if(orders.orderSource=="13"){
					$("#d_orderSource").html("组合购PC下单");
				}else if(orders.orderSource=="14"){
					$("#d_orderSource").html("组合购PHONE下单");
				}else if(orders.orderSource=="15"){
					$("#d_orderSource").html("组合购微信下单");
				}else if(orders.orderSource=="16"){
					$("#d_orderSource").html("组合购APP下单");
				}else if(orders.orderSource=="17"){
					$("#d_orderSource").html("积分商城PC下单");
				}else if(orders.orderSource=="18"){
					$("#d_orderSource").html("积分商城PHONE下单");
				}else if(orders.orderSource=="19"){
					$("#d_orderSource").html("积分商城微信下单");
				}else if(orders.orderSource=="20"){
					$("#d_orderSource").html("积分商城APP下单");
				}
				var zk = data.zk;
				if(zk == null){
					zk = "无折扣";
				}else{
					zk += "折";
				}
				$("#dzk").html(zk);
				$("#d_payNumber").html(orders.finalAmount);
				$("#membersDiscountPrice").html(orders.membersDiscountPrice);
				$("#d_sendNumber").html(orders.freight);
				if(orders.settlementStatus=="0"){
					$("#d_settlementStatus").html("<font class='color_002'>未付款</font>");
				}else if(orders.settlementStatus=="1"){
					$("#d_settlementStatus").html("<font class='color_001'>已付款</font>");
				}
				if(orders.ordersState=="0"){
					$("#d_ordersState").html("生成订单");
				}else if(orders.ordersState=="3"){
					$("#d_ordersState").html("正在配货");
				}else if(orders.ordersState=="4"){
					$("#d_ordersState").html("已经发货");
				}else if(orders.ordersState=="5"){
					$("#d_ordersState").html("待评价");
				}else if(orders.ordersState=="6"){
					$("#d_ordersState").html("已取消");
				}else if(orders.ordersState=="7"){
					$("#d_ordersState").html("异常订单");
				}else if(orders.ordersState=="9"){
					$("#d_ordersState").html("已评价");
				}
				//物流信息
				var content =  data.data;
				var shipping = data.shipping;
				var status = data.status;
				$("#express").html("");
				var expressHtml='<tr><td>时间</td><td>动态信息</td></tr>';
				if(shipping!=null&&content!=null){
					$(".wuLiu").removeAttr("style");
					//$("#expressDiv").css("display","display");
					$("#expressDiv").attr("style","");
					$("#expressTable").attr("style","");
					//物流过程信息
					var expressData =  content;
					//当前物流状态
					var state = data.state;
					//物流公司简称
					var com = data.com;
					//物流单号
					var nu = data.nu;
					for(var i=0;i<expressData.length;i++){
						//时间
						var time = expressData[i].time;
						var location = expressData[i].location;
						//内容
						var context = expressData[i].context;
						expressHtml+='<tr><td>'+time+'<\/td><td>'+context+'<\/td><\/tr>';
					}
					if(state==0){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>卖家已发货</font>");
					}else if(state==1){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>快递公司已接收</font>");
					}else if(state==2){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>寄送过程中</font>");
					}else if(state==3){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>已签收</font>");
					}else if(state==4){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>已退签</font>");
					}else if(state==5){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>同城派件中</font>");
					}else if(state==6){
						$("#expressTitle").html("<font color='green'style='font-weight: bold; size: 12px;'>退回中</font>");
					}else{
						$("#expressTitle").html("");
					}
					$("#expressMessager").html("<font color='green' style='size: 12px;'>"+shipping.deliveryCorpName+"</font>");
					$("#expressInternet").html("<font color='green' style='size: 12px;'>"+shipping.deliveryUrl+"</font>");
					$("#expressNo").html("<font color='green' style='size: 12px;'>"+shipping.deliverySn+"</font>");
					$("#express").html(expressHtml);
				}else if(shipping!=null){
					$(".wuLiu").removeAttr("style");
					$("#expressDiv").attr("style","");
					$("#express").html("");
					$("#expressTable").attr("style","display: none;");
					$("#expressMessager").html("");
					$("#expressTitle").html("");
					$("#expressMessager").html("<font color='green' style='size: 12px;'>"+shipping.deliveryCorpName+"</font>");
					$("#expressInternet").html("<font color='green' style='size: 12px;'>"+shipping.deliveryUrl+"</font>");
					$("#expressNo").html("<font color='green' style='size: 12px;'>"+shipping.deliverySn+"</font>");
					$("#expressTitle").html("<font color='red' style='font-weight: bold; size: 12px;'>暂无</font>");
				}else{
					$(".wuLiu").attr("style","display:none;");
					$("#express").html("");
					$("#expressMessager").html("");
					$("#expressTitle").html("");
					//$("#expressDiv").css("display","display");
					$("#expressDiv").attr("style","display: none;");
				}
				if(egList!=null&&egList!=""){
					  var html="<tr class='titlebg'><td align='center' colspan='8'> 订单评价<\/td><\/tr>";
					  html += "<tr><td align='center' width='150px'>套餐名称<\/td><td align='center' width='150px'>评价内容<\/td><\/tr>";
					  for(var i=0;i<egList.length;i++){
						  html+="<tr><td align='center' width='150px'>"+egList[i].productFullName+"<\/td><td align='center' width='150px'>"+egList[i].content+"<\/td><\/tr>";
					  }
					  $("#order_evaluate").html(html);
				}
			}
		});
	}
	</script>
	<div id="detailWin" style="width:100%;">
		<table align="center" class="addOrEditTable" width="100%;" >
			<tr class="titlebg"><td colspan='8' align='center' style="font-weight: bolder;">订单信息</td></tr>
			<tr>
				<td class="toright_td" >会员名称:&nbsp;&nbsp;</td><td id="customerName" ></td>
				<td class="toright_td" >订单号:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_ordersNo"></span></td>
				<td class="toright_td" >订单来源:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_orderSource"></span></td>
				<td class="toright_td" >下单时间:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_createTime"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="80px">付款状态:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_settlementStatus"></span></td>
				<td class="toright_td" width="80px">支付方式:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_payMode"></span></td>
				<td class="toright_td" width="80px">订单状态:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_ordersState"></span></td>
				<td class="toright_td" width="80px">配送方式:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_sendType"></span></td>
			</tr>

			<tr class="titlebg"><td colspan='8' align='center' style="font-weight: bolder;">结算信息</td></tr>
			<tr>
				<td class="toright_td" >套餐总金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_productSumNumber"></span>&nbsp;元</td>
				<td class="toright_td" >会员节省:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="membersDiscountPrice"></span>&nbsp;元</td>
				<td class="toright_td" >使用金币:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="duserCoin"></span>&nbsp;个</td>
				<td class="toright_td" >金币抵扣:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="dchangeAmount"></span>&nbsp;元</td>
			</tr>
			<tr>
				<td class="toright_td" >优惠券抵扣:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="dorderCouponAmount"></span>&nbsp;元</td>
				<td class="toright_td" >赠送金币:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="dvirtualCoinNumber"></span>&nbsp;个</td>
				<td class="toright_td" >折扣:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="dzk"></span></td>
				<td class="toright_td" >运费:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_sendNumber"></span>&nbsp;元</td>
			</tr>
			<tr>
				<td class="toright_td" >应付金额:&nbsp;&nbsp;</td><td colspan='7'>&nbsp;&nbsp;<span id="d_payNumber"></span>&nbsp;元</td>
			</tr>
			<tr>
				<td class="toright_td" >一级返利:&nbsp;&nbsp;</td><td >&nbsp;&nbsp;<span id="d_upRatioAmount"></span>&nbsp;元</td>
				<td class="toright_td" >二级返利:&nbsp;&nbsp;</td><td >&nbsp;&nbsp;<span id="d_secRatioAmount"></span>&nbsp;元</td>
				<td class="toright_td" >三级返利:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_thiRatioAmount"></span>&nbsp;元</td>
			</tr>
			<tr class="titlebg"><td colspan='8' align='center' style="font-weight: bolder;">收货人信息</td></tr>
			<tr>
				<td class="toright_td" >收货人姓名:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_consignee"></span></td>
				<td class="toright_td" >手机:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_mobilePhone"></span></td>
				<td class="toright_td" >详细地址:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_address"></span></td>
			</tr>
			<tr class="titlebg"><td colspan='8' align='center' style="font-weight: bolder;">机构信息</td></tr>
			<tr>
				<td class="toright_td" >机构名称:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_shopName"></span></td>
				<td class="toright_td" >机构邮编:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_postCode"></span></td>
				<td class="toright_td" >机构地址:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_shopAddress"></span></td>
			</tr>

			<tr class="titlebg"><td colspan='8' align='center' style="font-weight: bolder;">发票信息&nbsp;&nbsp;(<span id="d_invoiceType"></span>)</td></tr>
			<tr>
				<td class="toright_td" >发票抬头:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_cNFInvoice"></span></td>
				<td class="toright_td" >发票内容:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_invoiceInfo"></span></td>
			</tr>
			<tr class="zengZhi">
				<td class="toright_td" >纳税人识别号:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_taxpayerNumber"></span></td>
				<td class="toright_td" >地址:&nbsp;&nbsp;</td><td colspan='3'>&nbsp;&nbsp;<span id="d_addressForInvoice"></span></td>
			</tr>
			<tr class="zengZhi">
				<td class="toright_td" >账号:&nbsp;&nbsp;</td><td colspan='2'>&nbsp;&nbsp;<span id="d_bankAccountNumber"></span></td>
				<td class="toright_td" >开户行:&nbsp;&nbsp;</td><td colspan='2'>&nbsp;&nbsp;<span id="d_openingBank"></span></td>
				<td class="toright_td" >电话:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_phoneForInvoice"></span></td>
			</tr>
			<tr class="wuLiu titlebg"><td colspan='8' align='center' style="font-weight: bolder;">物流信息</td></tr>
			<tr class="wuLiu">
				<td class="toright_td">物流单号:&nbsp;&nbsp;</td><td class="toleft_td" colspan='3'>&nbsp;&nbsp;<span id="expressNo"></span></td>
				<td class="toright_td">物流公司:&nbsp;&nbsp;</td><td class="toleft_td" colspan='3'>&nbsp;&nbsp;<span id="expressMessager"></span></td>
			</tr>
			<tr class="wuLiu"><td class="toright_td">物流公司网址:&nbsp;&nbsp;</td><td class="toleft_td" colspan="7">&nbsp;&nbsp;<span id="expressInternet"></span></td></tr>
			<tr class="wuLiu"><td class="toright_td">物流动态:&nbsp;&nbsp;</td><td class="toleft_td" colspan="7">&nbsp;&nbsp;<span id="expressTitle"></span></td></tr>
		</table>
		<table id="order_evaluate" align="center" class="addOrEditTable" width="100%;"></table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
	</div>
