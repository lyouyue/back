<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/customerAcceptAddress/getCustomerAcceptAddressObject.action",
			   data: {customerAcceptAddressId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dconsignee").html(data.customerAcceptAddress.consignee);
				   $("#dlastName").html(data.customerAcceptAddress.lastName);
				   $("#dprovincecitycountry").html(data.regionLocation+data.city+data.areaCounty);
				   $("#daddress").html(data.customerAcceptAddress.address);
				   $("#demail").html(data.customerAcceptAddress.email);
				   $("#dpostcode").html(data.customerAcceptAddress.postcode);
				   $("#dmobilePhone").html(data.customerAcceptAddress.mobilePhone);
				   if(data.customerAcceptAddress.bestSendDate=="1"){
					   $("#dbestSendDate").html("只工作日送货(双休日、假日不用送)");
				   }else if(data.customerAcceptAddress.bestSendDate=="2"){
					   $("#dbestSendDate").html("工作日、双休日与假日均可送货");
				   }else{
					   $("#dbestSendDate").html("只双休日、假日送货(工作日不用送)");
				   }
				   if(data.customerAcceptAddress.isSendAddress=="0"){
					   $("#disSendAddress").html("否");
				   }else{
					   $("#disSendAddress").html("是");
				   }
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
	    <tr><td class="toright_td" width="150px">收货人姓名:</td><td class="toleft_td" width="500px">&nbsp;&nbsp;<span id="dconsignee"></span></td></tr>
	    <tr><td class="toright_td" width="150px">省市区:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dprovincecitycountry"></span></td></tr>
	    <tr><td class="toright_td" width="150px">详细地址:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="daddress"></span></td></tr>
	    <tr><td class="toright_td" width="150px">邮箱地址:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="demail"></span></td></tr>
	    <tr><td class="toright_td" width="150px">邮政编码:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dpostcode"></span></td></tr>
	    <tr><td class="toright_td" width="150px">手机号:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dmobilePhone"></span></td></tr>
<!-- 	    <tr><td class="toright_td" width="200px">最佳送货时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbestSendDate"></span></td></tr> -->
	    <tr><td class="toright_td" width="150px">是否为默认地址:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disSendAddress"></span></td></tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>