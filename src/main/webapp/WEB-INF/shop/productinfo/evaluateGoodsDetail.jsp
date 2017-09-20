<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,"440","&nbsp;&nbsp;评价详情","icon-tip",false,"detailWin",10);
		$("#detailWin").css("display","");
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/evalGoods/getEvaluateGoods.action",
			data: {evaluateId:id},
			dataType: "JSON",
			success: function(data){
				$("#dappraiserName").html(data.appraiserName);
				var level;
				if(data.level==1){
					level="<span class='color_001'>好评</span>";
				}else if(data.level==0){
					level="<span class='color_003'>中评</span>";
				}else if(data.level==-1){
					level="<span class='color_002'>差评</span>";
				}
				$("#dlevel").html(level);
				$("#dshopName").html(data.shopName);
				$("#dcreateTime").html(data.createTime);
				$("#dordersNo").html(data.ordersNo);
				$("#dproductFullName").html(data.productFullName);
				if(data.remark!=""){
					$("#dLogoImg").html("<img align='center' src='"+data.remark+"' width='120px' height='120px' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' />");
				}else{
					$("#dLogoImg").html("图片不存在！");
				}
				$("#dsalesPrice").html(data.salesPrice.toFixed(2));
				$("#dcontent").html(data.content);
				var evaluateState;
				if(data.evaluateState==0){
					evaluateState = "<span class='color_001'>正常显示</span>";
				}else{
					evaluateState = "<span class='color_002'>禁止显示</span>";
				}
				$("#devaluateState").html(evaluateState);
			}
		});
	}
</script>
<div id="detailWin">
	<table align="center" class="addOrEditTable">
		<tr><td class="toright_td" width="150px">套餐图片:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dLogoImg"></span></td></tr>
		<tr><td class="toright_td" width="150px">订单号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dordersNo"></span></td>
			<td class="toright_td" width="150px">店铺名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dshopName"></span></td></tr>
		<tr><td class="toright_td" width="150px">套餐名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dproductFullName"></span></td>
			<td class="toright_td" width="150px">销售价格:</td><td class="toleft_td">&nbsp;&nbsp;￥<span id="dsalesPrice"></span></td></tr>
		<tr><td class="toright_td" width="150px">评价等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dlevel"></span></td>
			<td class="toright_td" width="150px">评价状态:</td><td class="toleft_td">&nbsp;&nbsp;<span id="devaluateState"></span></td></tr>
		<tr><td class="toright_td" width="150px">评价人:</td><td class="toleft_td" width="250px">&nbsp;&nbsp;<span id="dappraiserName"></span></td>
			<td class="toright_td" width="150px">评价时间:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td></tr>
		<tr>
			<td class="toright_td" width="150px" >评价内容:</td>
			<td  class="toleft_td" colspan="3"  id="dcontent" rows="8" cols="48" style="width: 611px; height: 44px;">
			  </td>
		</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
	 	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>