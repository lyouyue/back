<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){
		$(".isPass2").click(function(){
			$("#fsaveInvoiceCheckStatus").val(this.value);
		})
		$("#button_save2").click(function(){
			$("#button_save2").attr("disabled","disabled");
			var url="${pageContext.request.contextPath}/back/company/saveOrUpdateCompanyManageInvoice.action";
    		$.post(url,{ids:$("#fshopInfoId2").val(),saveInvoiceCheckStatus:$("#fsaveInvoiceCheckStatus").val()},function(data){
    			if(data.isSuccess){
    				closeWin();
   				    $("#tt").datagrid("reload");
    			}
    		},'json');
		})
	})
	function invoiceCheck(id){
		createWindow(1000,500,"&nbsp;&nbsp;发票审核信息","icon-tip",false,"pass2Win");
		$("input.button_save").removeAttr("disabled");
		$("#detailWin").css("display","none");
		$("#addOrEditWin").css("display","none");
		$("#passWin").css("display","none");
		$("#pass2Win").css("display","");
		$.ajax({
			type: "POST",
			dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/company/getCompanyManageById.action",
			data: {ids:id},
			success: function(data){
				if(data.invoiceCheckStatus!=""){
					var shopInfo = data.shopInfo;
					$("#fshopInfoId2").val(shopInfo.shopInfoId);
					$("#pcustomerId2").html(shopInfo.customerName);
					$("#pcompanyName2").html(shopInfo.companyName);
					$("#ppostCode2").html(shopInfo.postCode);
					$("#ftaxpayerNumber").html(shopInfo.taxpayerNumber);
					$("#fphoneForInvoice").html(shopInfo.phoneForInvoice);
					$("#fopeningBank").html(shopInfo.openingBank);
					$("#fbankAccountNumber").html(shopInfo.bankAccountNumber);
					$("#faddressForInvoice").html(shopInfo.addressForInvoice);
					$("#fsaveInvoiceCheckStatus").val(shopInfo.invoiceCheckStatus);
					if(shopInfo.invoiceCheckStatus==2){
						$("#invoiceCheckStatus_2").attr("checked","checked");
					}else if(shopInfo.invoiceCheckStatus==3){
						$("#invoiceCheckStatus_3").attr("checked","checked");
					}
				}else{
					closeWin();
   				    $("#tt").datagrid("reload");
				}
			}
		});
	}
</script>
<div id="pass2Win">
        <input id="fshopInfoId2" type="hidden" name="shopInfo.shopInfoId" value=""/>
        
        <table align="center" class="addOrEditTable" width="950px;">
    	<tr>
    		<th colspan="12">基础信息</th>
    	</tr>
		<tr>
			<td class="toright_td" width="150px">会员名称:</td>
			<td class="toleft_td" colspan="5">&nbsp;&nbsp;<span id="pcustomerId2" ></span></td>
			<td class="toright_td" width="150px">企业名称:</td>
			<td class="toleft_td" colspan="5">&nbsp;&nbsp;<span id="pcompanyName2" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">邮政编码:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="ppostCode2" ></span></td>
		</tr>
    	</table>
    	<br>
        
        <table id="fp-info-table" align="center" class="addOrEditTable" width="950px;">
    	<tr>
    		<th colspan="12">发票信息</th>
    	</tr>
		<tr>
			<td class="toright_td" width="150px">纳税人识别号:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="ftaxpayerNumber" ></span></td>
			<td class="toright_td" width="150px">电话:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="fphoneForInvoice" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">开户行:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="fopeningBank" ></span></td>
			<td class="toright_td" width="150px">帐号:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="fbankAccountNumber" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">地址:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="faddressForInvoice" ></span></td>
			<td class="toright_td" width="150px">审核状态:</td>
			<td  class="toleft_td" colspan="3">
				<input type="hidden" id="fsaveInvoiceCheckStatus" name="saveInvoiceCheckStatus" value=""/>
				<input id="invoiceCheckStatus_2"  type="radio" name="shopInfo.invoiceCheckStatus" class="isPass2" value="2"/>通过
				<input id="invoiceCheckStatus_3"  type="radio" name="shopInfo.invoiceCheckStatus" class="isPass2" value="3"/>未通过
			</td>
		</tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="button_save2" class="easyui-linkbutton" icon="icon-save"  href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
