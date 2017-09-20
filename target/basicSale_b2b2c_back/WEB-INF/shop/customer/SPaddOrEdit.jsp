<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
  <div id="SPaddOrEditWinSp">
    <form id="form2"  method="post" action="">
        <input id="shopCustomerInfoId" type="hidden" name="shopCustomerInfo.shopCustomerInfoId" value="">
        <input id="dcustomerId" type="hidden" name="shopCustomerInfo.customerId" value="">
        <input id="crruentIntegral" type="hidden" name="shopCustomerInfo.crruentIntegral" value="">
        <input id="preDeposit" type="hidden" name="shopCustomerInfo.preDeposit" value="">
        <input id="loginIp" type="hidden" name="shopCustomerInfo.loginIp" value="">
        <input id="loginDate" type="hidden" name="shopCustomerInfo.loginDate" value="">
        <input id="loginFailureCount" type="hidden" name="shopCustomerInfo.loginFailureCount" value="">
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">MSN:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<input id="msn" type="text" name="shopCustomerInfo.msn" class="{validate:{required:true,maxlength:[60]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">办公电话:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="workPhone" type="text" name="shopCustomerInfo.workPhone" class="{validate:{required:true,maxlength:[60]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">住宅电话:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="homePhone" type="text" name="shopCustomerInfo.homePhone" class="{validate:{required:true,maxlength:[60]}}"></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
		</div>
	</form>
  </div>

