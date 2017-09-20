<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,320,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#detailWin").css("display","");
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/mallCoin/getMallCoinObjectById.action",
			data: {mallCoinId:id},
			dataType: "JSON",
			success: function(data){
				$("#d_serialNumber").html(data.serialNumber);
				$("#d_ordersNo").html(data.ordersNo);
				if(data.type==1){
					$("#d_type").html("收入");
				}else if(data.type==2){
					$("#d_type").html("支出");
				}else if(data.type==3){
					$("#d_type").html("取消订单");
				}else if(data.type==4){
					$("#d_type").html("交易作废");
				}
				$("#d_transactionNumber").html(data.transactionNumber);
				$("#d_remainingNumber").html(data.remainingNumber);
				$("#d_tradeTime").html(data.tradeTime);
				$("#d_operatorTime").html(data.operatorTime);
				$("#d_remarks").html(data.remarks);
				$("#d_frozenNumber").html(data.frozenNumber);
				if(data.proportion>0){
					$("#d_proportion").html(data.proportion+"%");
				}else{
					$("#d_proportion").html(0);
				}
			}
		});
	}
</script>
<div id="detailWin" >
	<table align="center" class="addOrEditTable" width="600px;">
		<tr>
			<td class="toright_td" width="150px">流水号:&nbsp;&nbsp;</td>
			<td  class="toleft_td" width="440px" >&nbsp;&nbsp;<span id="d_serialNumber"></span></td>
		<!-- </tr>
		<tr> -->
			<td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_ordersNo"></span></td>
		<tr>
			<td class="toright_td" width="150px">类型:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_type"></span></td>
		<!-- </tr>
		<tr> -->
			<td class="toright_td" width="150px">交易数量:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_transactionNumber"></span></td>
			<%-- <td class="toright_td" width="150px">剩余数量:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_remainingNumber"></span></td> --%>
		</tr>
		<tr>
			<td class="toright_td" width="150px">冻结数量:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_frozenNumber"></span></td>
			<td class="toright_td" width="150px">当时分享比例:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_proportion"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">交易时间:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_tradeTime"></span></td>
			<td class="toright_td" width="150px">操作时间:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_operatorTime"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">备注:&nbsp;&nbsp;</td>
			<td class="toleft_td" width="440px" colspan="3">&nbsp;&nbsp;<span id="d_remarks"></span></td>
		</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
	</div>
</div>