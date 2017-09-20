<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	var isPass;
	function showDetailInfo(id){
		createWindow(900,480,"&nbsp;&nbsp;店铺详情","icon-tip",false,"detailWin",10);
		$("#addOrEditWin").css("display","none");
		$("#passWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/shopinfo/getShopInfoById.action",
			   data: {ids:id},
			   dataType: "JSON",
			   success: function(data){
				   var shop = data.shopInfo;
				   $("#dshopInfoId").val(shop.shopInfoId);
				   $("#dshopCategoryId").val(data.categoryName);
				   $("#dcustomerId").val(shop.customerName);
				   $("#dshopName").val(shop.shopName);
				   $("#dcountry").val(data.areaCounty);
				   $("#dregionLocation").val(data.regionLocation);
				   $("#dcity").val(data.city);
				   $("#daddress").val(shop.address);
				   $("#dpostCode").val(shop.postCode);
				   $("#dmainProduct").val(shop.mainProduct);
				   $("#dpostage").html(shop.postage);
				   $("#dminAmount").html(shop.minAmount);
				   $("#dphone").html(shop.phone);
				   $("#daddressForInvoice").html(shop.addressForInvoice);
				   $("#dqrCode").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.qrCode+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				   $("#dlogoUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.logoUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				   $("#dbannerUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.bannerUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				   $("#dcompanyRegistered").val(shop.companyRegistered);
				   $("#ccompanyName").val(shop.companyName);
				   if(shop.phoneShowStatus==0){
					   $("#dphoneShowStatus").html("<font class='color_002'>否");
				   }else{
					   $("#dphoneShowStatus").html("<font class='color_001'>是");
					}
					if(shop.commission != "" || shop.commission != null){
						$("#dcommission").html(shop.commission+"%");
					}else{
					var d_commissionSys = "${application.fileUrlConfig.commissionProportion}";
					$("#dcommission").html(d_commissionSys);
				   }
				   //$("#dmarketBrandUrlPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.marketBrandUrl+"' width='120px' height='120px' />");
				   $("#dbusinessLicense").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.businessLicense+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				   //$("#dIDCardsImage").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.IDCardsImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				   $("#dcompanyDocuments").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.companyDocuments+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				   //$("#dtaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.taxRegistrationDocuments+"' width='120px' height='120px' />");
				   var num = shop.isPass;
				   if(num == 3){
					   isPass = "<font class='color_001'>已通过</font>";
				   }
				   if(num==2){
					   isPass = "<font class='color_002'>未通过</font>";
				   }
				   if(num==1){
					   isPass = "<font class='color_003'>未审核</font>";
				   }
				   $("#isPas").html(isPass);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="850px;">
			<tr><td colspan='8' align='center' class="titlebg">企业信息</td></tr>
			<tr>
				<td class="toright_td" width="150px">执照图片预览 :</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="dbusinessLicense" ></span></td>
				<td class="toright_td" width="150px">身份证照图片预览 :</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="dcompanyDocuments" ></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">店铺账号:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dcustomerId" type="text" size="30" name="shopInfo.customerId"  readonly="readonly" /></td>
				<td class="toright_td" width="150px">公司名称:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="ccompanyName" type="text" size="30" name="shopInfo.companyName"  readonly="readonly" /></td>
			</tr>
			 <tr>
				<td class="toright_td">公司地址:</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="daddressForInvoice" ></span>
				</td>
				<td class="toright_td" width="150px">邮政编码:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dpostCode" type="text" size="30" name="shopInfo.postCode" class="{validate:{required:true,maxlength:[30]}}" readonly="readonly" /></td>
			</tr>
			<tr><td colspan='8' align='center' class="titlebg">店铺信息</td></tr>
			<tr>
				<td class="toright_td" width="150px">店铺Logo :</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="dlogoUrl"></span></td>
				<td class="toright_td" width="150px">店铺首页大图:</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="dbannerUrl" ></span></td>
			</tr>
			<tr >
				<td class="toright_td">店铺二维码</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dqrCode"></span></td>
				<td class="toright_td" width="150px">店铺名称:</td>
				<td class="toleft_td" colspan="8">&nbsp;&nbsp;<input style="border: 0" id="dshopName" type="text" size="30" name="shopInfo.shopName" class="{validate:{required:true,maxlength:[50]}}" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">店铺分类:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dshopCategoryId" type="text" size="30" name="shopInfo.shopCategoryId" class="{validate:{required:true,maxlength:[100]}}" readonly="readonly" /></td>
				<td class="toright_td" width="150px">主要销售产品:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dmainProduct" type="text" size="30" name="shopInfo.mainProduct" class="{validate:{required:true,maxlength:[300]}}" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="toright_td">运费:</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dpostage" ></span>元</td>
				<td class="toright_td" width="150px">订单是否包邮:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;满<span id="dminAmount"></span>元包邮</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">联系电话:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dphone"></span></td>
				<td class="toright_td">是否展示联系电话:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dphoneShowStatus"></span></td>
			</tr>
			<tr>
				<td class="toright_td">设置佣金抽成</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dcommission"></span></td>
				<td class="toright_td">店铺审核状态:</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="isPas" ></span>
				</td>
				
			</tr>
		    <%--<tr>
		      <td class="toright_td" width="150px">售卖品牌图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="dmarketBrandUrlPreview"></span>
		      </td>
		      <td class="toright_td" width="150px">执照图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="dbusinessLicensePreview" ></span>
		      </td>
			</tr>
			<tr>
		      <td class="toright_td" width="150px">公司证件图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="dcompanyDocumentsPreview"></span>
		      </td>
		      <td class="toright_td" width="150px">税务登记证图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="dtaxRegistrationDocumentsPreview" ></span>
		      </td>
			</tr> --%>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>