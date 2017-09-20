<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin" >
<table align="center" class="addOrEditTable" width="600px;">
			<tr>
				<td class="toright_td" width="175px">会员名称:&nbsp;&nbsp;</td>
				<td  class="toleft_td">&nbsp;&nbsp;<span id="d_customerName"></span></td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="175px">真实姓名:&nbsp;&nbsp;</td>
				<td  class="toleft_td" width="300px">&nbsp;&nbsp;
				<span id="d_realName"></span>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="175px">提现编号:&nbsp;&nbsp;</td>
				<td  class="toleft_td" width="300px">&nbsp;&nbsp;
				<span id="d_drawingCode"></span>
				</td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="175px">联系电话:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_phone"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="175px">银行名称:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
				<span id="d_bankName"></span>
				</td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="175px">银行地址:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_bankAddre"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="175px">卡号:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_cardNum"></span></td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="175px">申请时间:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_createTime"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="175px">发放时间:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_updateTime"></span></td>
			<!-- </tr>
						<tr> -->
				<td class="toright_td" width="175px">发放人:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_userName"></span></td>
			</tr>
			
			<tr>
				<td class="toright_td" width="175px">状态:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_state"></span></td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="175px">提现金额:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<span id="d_drawingAmount"></span>元</td>
			</tr>
			<tr>
				<td class="toright_td" width="175px">备注:&nbsp;&nbsp;</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="d_remarks"></span></td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
</div>

