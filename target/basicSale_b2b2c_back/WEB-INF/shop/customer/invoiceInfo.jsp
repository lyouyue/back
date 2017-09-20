<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="invoiceInfolWin">
    <table align="center" class="addOrEditTable" width="950px;">
    	<tr class="titlebg"><td align="center" colspan="2">个人普通发票</td></tr>
		<tr>
			<td class="toright_td" width="150px">发票抬头:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_invoiceTitle" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">发票内容:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_invoiceInfo" ></span></td>
		</tr>
		<tr class="titlebg"><td align="center" colspan="2">增值税发票</td></tr>
		<tr>
			<td class="toright_td" width="150px">单位名称:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_companyName" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">纳税人识别编号:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_taxpayerIdentificationCode" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">注册地址:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_registeredAddress" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">注册电话:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_registerePhone" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">开户行:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_depositBank" ></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">账号:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<span id="d_bankAccount" ></span></td>
		</tr>
    	</table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
</div>