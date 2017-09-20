<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){
		$(".isPass").click(function(){
			
		})
		$("#button_save1").click(function(){
			var selected = $("input[name='shopInfo.shopInfoCheckSatus'][type='radio']:checked").val();
			$("#psaveShopInfoCheckSatus").val(selected);
			$("#button_save1").attr("disabled","disabled");
			var url="${pageContext.request.contextPath}/back/company/saveOrUpdateCompanyManage.action";
    		$.post(url,{ids:$("#pshopInfoId").val(),saveShopInfoCheckSatus:$("#psaveShopInfoCheckSatus").val()},function(data){
    			if(data.isSuccess){
    				closeWin();
   				    $("#tt").datagrid("reload");
    			}
    		},'json');
		})
	})
	function shopInfoCheck(id){
		createWindow(1000,460,"&nbsp;&nbsp;企业审核信息","icon-tip",false,"passWin");
		$("input.button_save").removeAttr("disabled");
		$("#detailWin").css("display","none");
		$("#addOrEditWin").css("display","none");
		$("#pass2Win").css("display","none");
		$("#passWin").css("display","");
		$.ajax({
			type: "POST",
			dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/company/getCompanyManageById.action",
			data: {ids:id},
			success: function(data){
				if(data.shopInfoCheckSatus!=""){
					var shopInfo = data.shopInfo;
					$("#pshopInfoId").val(shopInfo.shopInfoId);
					$("#pcustomerId").html(shopInfo.customerName);
					$("#pcompanyName").html(shopInfo.companyName);
					$("#ppostCode").html(shopInfo.postCode);
					$("#pbusinessLicensePreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.businessLicense+"' width='120px' height='120px' />");
					$("#pcompanyDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.companyDocuments+"' width='150px' height='150px' />");
					$("#ptaxRegistrationDocumentsPreview").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+shopInfo.taxRegistrationDocuments+"' width='120px' height='120px' />");
					$("#psaveShopInfoCheckSatus").html(shopInfo.shopInfoCheckSatus);
					if(shopInfo.shopInfoCheckSatus==2){
						$("#shopInfoCheckSatus_2").attr("checked","checked");
					}else if(shopInfo.shopInfoCheckSatus==3){
						$("#shopInfoCheckSatus_3").attr("checked","checked");
					}
				}else{
					closeWin();
   				    $("#tt").datagrid("reload");
				}
			}
		});
	}
</script>
<div id="passWin">
        <input id="pshopInfoId" type="hidden" name="shopInfo.shopInfoId" value=""/>
         <table align="center" class="addOrEditTable" width="950px;">
    	<tr>
    		<td align="center" style="font-weight:bold;" colspan="12">基础信息</td>
    	</tr>
		<tr>
			<td class="toright_td" width="150px">会员名称:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="pcustomerId" ></span></td>
			<td class="toright_td" width="150px">企业名称:</td>
			<td class="toleft_td" colspan="5">&nbsp;&nbsp;<span id="pcompanyName" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">邮政编码:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="ppostCode" ></span></td>
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
				&nbsp;&nbsp;&nbsp;&nbsp;<span id="pbusinessLicensePreview" ></span>
			</td>
			<td class="toright_td" width="160px">负责人身份证照预览 :</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;<span id="pcompanyDocumentsPreview"></span>
			</td>
			<%-- <td class="toright_td" width="230px">税务登记证图片预览 :</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
			    &nbsp;&nbsp;&nbsp;&nbsp;<span id="ptaxRegistrationDocumentsPreview" ></span>
			</td> --%>
		</tr>
		    <tr>
		    	<td class="toright_td" >审核状态:</td>
			    <td  class="toleft_td" colspan="11">
			    	<input type="hidden" id="psaveShopInfoCheckSatus" name="saveShopInfoCheckSatus" value=""/>
			    	<input id="shopInfoCheckSatus_2"  type="radio" class="isPass" name="shopInfo.shopInfoCheckSatus" value="2"/>通过
			    	<input id="shopInfoCheckSatus_3"  type="radio" class="isPass" name="shopInfo.shopInfoCheckSatus" value="3"/>未通过
			    </td>
	    	</tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="button_save1" class="easyui-linkbutton" icon="icon-save"  href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
