<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	var isPass;
	function showDetailInfo(id,type){
		createWindow(1000,440,"&nbsp;&nbsp;店铺企业详情","icon-tip",false,"detailWin");
		$("#passWin").css("display","none");
		$("#congeal").css("display","none");
		$("#addOrEditWin").css("display","none");
		$("#pass2Win").css("display","none");
		$("#detailWin").css("display","");
		if(type==1){
			$("#qy-info-table").css("display","");
			$("#fp-info-table").css("display","");
		}else if(type==2){
			$("#fp-info-table").css("display","none");
			$("#qy-info-table").css("display","");
		}else if(type==3){
			$("#fp-info-table").css("display","");
			$("#qy-info-table").css("display","none");
		}
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/company/getCompanyManageById.action",
			   data: {ids:id},
			   dataType: "JSON",
			   success: function(data){
				   var shop = data.shopInfo;
				   $("#dcustomerId").html(shop.customerName);
				   $("#dcompanyName").html(shop.companyName);
				   $("#dpostCode").html(shop.postCode);
				   $("#dmainProduct").html(shop.mainProduct);
			   	   $("#dbusinessLicensePreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.businessLicense+"' width='120px' height='120px' />");
			   	   $("#dcompanyDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.companyDocuments+"' width='120px' height='120px' />");
			   	   $("#dtaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shop.taxRegistrationDocuments+"' width='120px' height='120px' />");
				   var num = shop.shopInfoCheckSatus;
				   var shopInfoCheckSatus="";
				   if(num == 3){
					   shopInfoCheckSatus = "<font class='color_002'>未通过</font>";
				   }
				   if(num==2){
					   shopInfoCheckSatus = "<font class='color_001'>通过</font>";
				   }
				   if(num==1){
					   shopInfoCheckSatus = "<font class='color_003'>未审核</font>";
				   }
				   $("#shopInfoCheckSatus").html(shopInfoCheckSatus);
				   $("#dtaxpayerNumber").html(shop.taxpayerNumber);
				   $("#dphoneForInvoice").html(shop.phoneForInvoice);
				   $("#daddressForInvoice").html(shop.addressForInvoice);
				   $("#dopeningBank").html(shop.openingBank);
				   $("#dbankAccountNumber").html(shop.bankAccountNumber);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="950px;">
    	<tr>
    		<td align="center" style="font-weight:bold;" colspan="12">基础信息</td>
    	</tr>
		<tr>
			<td class="toright_td" width="150px">会员名称:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dcustomerId" ></span></td>
			<td class="toright_td" width="150px">企业名称:</td>
			<td class="toleft_td" colspan="5">&nbsp;&nbsp;<span id="dcompanyName" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">邮政编码:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="dpostCode" ></span></td>
		</tr>
    	<!-- </table>
    	<br>
    	
    	
		<table id="qy-info-table" align="center" class="addOrEditTable" width="950px;"> -->
    	<tr>
    		<td align="center" style="font-weight:bold;" colspan="12">企业信息</td>
    	</tr>
		<tr>
			<td class="toright_td" width="160px">营业执照 （三证合一）预览 :</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;<span id="dbusinessLicensePreview" ></span>
			</td>
			<%-- <td class="toright_td" width="230px">税务登记证图片预览 :</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;<span id="dtaxRegistrationDocumentsPreview" ></span>
			</td> --%>
		<!-- </tr>
		<tr> -->
			<td class="toright_td" width="160px">负责人身份证照预览:</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;<span id="dcompanyDocumentsPreview"></span>
			</td>
		</tr>
		<tr>
			<td class="toright_td">审核状态:</td>
			<td  class="toleft_td" colspan="11">&nbsp;&nbsp;
			   	 &nbsp;&nbsp;&nbsp;&nbsp;<span id="shopInfoCheckSatus" ></span>
			</td>
		</tr>
    </table>
    <!-- <br> -->
    
    
     <table id="fp-info-table" align="center" class="addOrEditTable" width="950px;">
    	<tr>
    		<td align="center" colspan="12">发票信息</td>
    	</tr>
		<tr>
			<td class="toright_td" width="150px">纳税人识别号:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dtaxpayerNumber" ></span></td>
			<td class="toright_td" width="150px">电话:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dphoneForInvoice" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">开户行:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dopeningBank" ></span></td>
			<td class="toright_td" width="150px">帐号:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dbankAccountNumber" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">地址:</td>
			<td class="toleft_td" colspan="6">&nbsp;&nbsp;<span id="daddressForInvoice" ></span></td>
		</tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
	    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>