<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){
		$(".isPass").click(function(){
			$("#saveIsPass").val(this.value);
		});
		$(".phoneShowStatus").click(function(){
			$("#savePhoneShowStatus").val(this.value);
		});
		$(".button_save").click(function(){
			//校验输入的佣金抽成数值
			var reg=/^\d+(\.\d+)?$/;
			var s= $.trim($("#pcommission").val());
			if(s!=""){
				if(reg.test(s)){
					if(Number(s)>=Number(1) && Number(s)<=Number(100)){
						$("#csmsg").html("");
						tj();
					}else{
						$("#csmsg").html("数值在1-100之间");
					}
				}else{
					$("#csmsg").html("请输入数字");
				}
			}else{
				$("#csmsg").html("");
				tj();
			}
		});
	})
	
	function tj(){
		$("input.button_save").attr("disabled","disabled");
		var url="${pageContext.request.contextPath}/back/shopinfo/saveOrUpdateShopInfo.action";
		$.post(url,{ids:$("#pshopInfoId").val(),saveIsPass:$("#saveIsPass").val(),savePhoneShowStatus:$("#savePhoneShowStatus").val(),commission:$.trim($("#pcommission").val())},function(data){
			if(data.isSuccess){
				closeWin();
				    $("#tt").datagrid("reload");
			}
		},'json');
	}
</script>
<div id="passWin">
        <input id="pcompanyName" type="hidden" name="shopInfo.companyName" value=""/>
        <input id="pshopInfoId" type="hidden" name="shopInfo.shopInfoId" value=""/>
        <input id="pIDCardsImage" type="hidden" name="shopInfo.IDCardsImage" value=""/>
        <input id="pbusinessLicense" type="hidden" name="shopInfo.businessLicense" value=""/>
        <input id="pcompanyDocuments" type="hidden" name="shopInfo.companyDocuments" value=""/>
        <input id="ptaxRegistrationDocuments" type="hidden" name="shopInfo.taxRegistrationDocuments" value=""/>
        <input id="pmarketBrandUrl" type="hidden" name="shopInfo.marketBrandUrl" value=""/>
        <input id="pcustomerName" type="hidden" name="shopInfo.customerName" value=""/>
        <input id="pisClose" type="hidden" name="shopInfo.isClose" value=""/>
	    <table align="center" class="addOrEditTable" width="850px;">
	    	 <tr>
		      <td class="toright_td" width="150px">店铺Logo :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="plogoUrl"></span>
		      </td>
		      <td class="toright_td" width="150px">店铺首页大图:</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="pbannerUrl" ></span>
		      </td>
			</tr>
	    	<tr>
		      <td class="toright_td" width="150px">店铺账号:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pcustomerId" type="text" size="30" name="shopInfo.customerId" readonly="readonly" /></td>
		      <td class="toright_td" width="150px">公司名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pcustomerName" type="text" size="30" name="shopInfo.customerName" readonly="readonly" /></td>
		    </tr>
		     <tr>
		        <td class="toright_td" width="150px">公司地址:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="paddressForInvoice" type="text" size="30" name="shopInfo.addressForInvoice" readonly="readonly" /></td>
		        <td class="toright_td" width="150px">邮政编码:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="ppostCode" type="text" size="30" name="shopInfo.postCode" readonly="readonly" /></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">店铺分类:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pshopCategoryId" type="text" size="30" name="shopInfo.shopCategoryId" readonly="readonly" /></td>
		      <td class="toright_td" width="150px">店铺名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pshopName" type="text" size="30" name="shopInfo.shopName" readonly="readonly" /></td>
		    </tr>
		    <tr>
				<td class="toright_td" width="150px">联系电话:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pphone" type="text" size="30" name="shopInfo.phone" readonly="readonly" /></td>
				<td class="toright_td" width="150px">主要销售产品:</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pmainProduct" type="text" size="30" name="shopInfo.mainProduct" readonly="readonly" /></td>
			</tr>
		    <!-- <tr>
		        <td class="toright_td" width="150px">省地区:</td>
		    	<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pregionLocation" type="text" size="30" name="shopInfo.regionLocation" readonly="readonly" /></td>
		    	<td class="toright_td" width="150px">城市:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pcity" type="text" size="30" name="shopInfo.city" readonly="readonly" /></td>
		    </tr>
		    <tr>
		        <td class="toright_td" width="150px">区/县:</td>
		      	<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pcountry" type="text" size="30" name="shopInfo.country" readonly="readonly" /></td>
		        <td class="toright_td" width="150px">详细地址(街道):</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="paddress" type="text" size="30" name="shopInfo.address" readonly="readonly" /></td>
		    </tr> -->
		   
		    <tr>
		        <td class="toright_td" width="150px">运费:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="ppostage" type="text" size="30" name="shopInfo.postage" readonly="readonly" /></td>
		        <td class="toright_td" width="150px">订单是否包邮:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pminAmount" type="text" size="30" name="shopInfo.minAmount" readonly="readonly" /></td>
		    </tr>
		    <%-- <tr>
		      <td class="toright_td" width="150px">售卖品牌图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="pmarketBrandUrlPreview"></span>
		      </td>
		      <td class="toright_td" width="150px">执照图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="pbusinessLicensePreview" ></span>
		      </td>
			</tr>
			<tr>
		      <td class="toright_td" width="150px">公司证件图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="pcompanyDocumentsPreview"></span>
		      </td>
		      <td class="toright_td" width="150px">税务登记证图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="ptaxRegistrationDocumentsPreview" ></span>
		      </td>
			</tr> --%>
			<tr>
				<td class="toright_td">是否展示联系电话:</td>
				<td class="toleft_td" colspan="3">
					<input type="hidden" id="savePhoneShowStatus" value=""/>
					<input id="phoneShowStatus_0" type="radio" name="shopInfo.phoneShowStatus" class="phoneShowStatus" value="0"/>否
					<input id="phoneShowStatus_1" type="radio" name="shopInfo.phoneShowStatus" class="phoneShowStatus" value="1"/>是
				</td>
				<td class="toright_td">设置佣金抽成:</td>
				<td class="toleft_td" colspan="3">
					<input type="text" id="pcommission" name="shopInfo.commission" value=""/>&nbsp;%<span id="csmsg" style="color:red;"></span>
				</td>
			</tr>
			<tr>
			<td class="toright_td">店铺审核状态:</td>
				<td class="toleft_td" colspan="7">
					<input type="hidden" id="saveIsPass" value=""/>
					<input id="isPass_1" type="radio" class="isPass" name="shopInfo.isPass"  value="1"/>待审核
					<input id="isPass_2" type="radio" class="isPass" name="shopInfo.isPass"  value="2"/>未通过
					<input id="isPass_3" type="radio" class="isPass" name="shopInfo.isPass"  value="3"/>已通过
				</td>
			</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="tj()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
