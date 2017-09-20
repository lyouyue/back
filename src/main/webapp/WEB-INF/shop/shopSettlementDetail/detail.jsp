<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
<div id="detailWin">
		<form id="form1"></form>
		<input type="hidden" id="settlementId" value="" name="settlementId"/>
	    <table align="center" class="addOrEditTable" width="750px">
		    <tr>
		      <td class="toright_td" width="150px">店铺名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
			      <span id="view_shopName"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">会员帐号:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
			      <span id="view_loginName"></span>
		      </td>
		    </tr>
		    <tr>
   				<td class="toright_td" width="150px">会员真实名称:&nbsp;&nbsp;</td>
   				<td class="toleft_td">&nbsp;&nbsp;<span id="view_trueName"></span></td>
   			</tr>
		    <tr>
		      <td class="toright_td" width="150px">申请月份:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
			      <span id="view_settlementMonth"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">申请周期:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
		           <span id="view_cycle"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">申请周期内销售套餐总成本:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
		       <span id="view_totalCost"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">申请周期内总销售额:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
		       <span id="view_totalSales"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">申请时间:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
		       <span id="view_createDate"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">审核状态:&nbsp;&nbsp;</td>
		      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
		       	<input type="radio" name="shopSettlementDetail.reviewStatus" value="0"/>未审核
		       	<input type="radio" name="shopSettlementDetail.reviewStatus" value="1"/>已审核
		      </td>
		    </tr>
	    </table>
	    <div style="text-align:center;padding:5px 0;">
	    	<input type="button" id="updateReview"  class="button_save" value="" style="cursor:pointer;"/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" style="cursor:pointer;"/>&nbsp;
		</div>
</div>
</html>