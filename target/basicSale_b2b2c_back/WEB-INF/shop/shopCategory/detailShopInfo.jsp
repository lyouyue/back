<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	var isPass;
	function showDetailInfo(id){
		createWindow(900,440,"&nbsp;&nbsp;店铺详情","icon-tip",false,"detailWin",10);
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/shopinfo/getShopInfoById.action",
			   data: {ids:id},
			   dataType: "JSON",
			   success: function(data){
				   var shop = data.shopInfo;
				   $("#dshopCategoryId").val(data.categoryName);
				   $("#dcustomerId").val(shop.customerName);
				   $("#dshopName").val(shop.shopName);
				   $("#dcountry").val(data.areaCounty);
				   $("#dregionLocation").val(data.regionLocation);
				   $("#dcity").val(data.city);
				   $("#daddress").val(shop.address);
				   $("#dpostCode").val(shop.postCode);
				   $("#dmainProduct").val(shop.mainProduct);
				   $("#dcompanyRegistered").val(shop.companyRegistered);
				   $("#dphone").val(shop.phone);
				   $("#dmarketBrandUrlPreview").html("<img style='padding-top:10px;' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.marketBrandUrl+"' width='120px' height='120px' />");
			   	   $("#dbusinessLicensePreview").html("<img style='padding-top:10px;' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.businessLicense+"' width='120px' height='120px' />");
			   	   $("#dcompanyDocumentsPreview").html("<img style='padding-top:10px;' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.companyDocuments+"' width='120px' height='120px' />");
			   	   //$("#dtaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.taxRegistrationDocuments+"' width='120px' height='120px' />");
				   var num = shop.isPass;
				   if(num == 3){
					   isPass = "<font class='color_001'>是</font>";
				   }
				   if(num==2){
					   isPass = "<font class='color_002'>否</font>";
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
		<tr>
		      <td class="toright_td" width="150px">店铺分类:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dshopCategoryId" type="text" size="30" name="shopInfo.shopCategoryId" class="{validate:{required:true,maxlength:[100]}}" readonly="readonly" /></td>
		      <td class="toright_td" width="150px">选择会员:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dcustomerId" type="text" size="30" name="shopInfo.customerId" class="{validate:{required:true,maxlength:[100]}}" readonly="readonly" /></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">店铺名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dshopName" type="text" size="30" name="shopInfo.shopName" class="{validate:{required:true,maxlength:[50]}}" readonly="readonly" /></td>
		      <td class="toright_td" width="150px">联系电话:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dphone" type="text" size="30" name="shopInfo.phone" class="{validate:{required:true,maxlength:[30]}}" readonly="readonly" /></td>
		    </tr>
		    <tr>
		        <td class="toright_td" width="150px">详细地址(街道):</td>
		        <td class="toleft_td" colspan="5">&nbsp;&nbsp;<input style="border: 0" id="daddress" type="text" size="30" name="shopInfo.address" class="{validate:{required:true,maxlength:[200]}}" readonly="readonly" /></td>
		    </tr>
		    <tr>
		        <td class="toright_td" width="150px">邮政编码:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dpostCode" type="text" size="30" name="shopInfo.postCode" class="{validate:{required:true,maxlength:[30]}}" readonly="readonly" /></td>
		        <td class="toright_td" width="150px">主要销售产品:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="dmainProduct" type="text" size="30" name="shopInfo.mainProduct" class="{validate:{required:true,maxlength:[300]}}" readonly="readonly" /></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">销售品牌Logo :</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="dmarketBrandUrlPreview"></span>
		      </td>
		      <td class="toright_td" width="150px">营业执照:（三证合一）</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="dbusinessLicensePreview" ></span>
		      </td>
			</tr>
		    <tr>
	    		<td class="toright_td">是否通过:</td>
		    	<td class="toleft_td" colspan="5">&nbsp;&nbsp;
	         	 &nbsp;&nbsp;&nbsp;&nbsp;<span id="isPas" ></span>
	       		</td>
	    	</tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
	<form id="form1"></form>
</div>