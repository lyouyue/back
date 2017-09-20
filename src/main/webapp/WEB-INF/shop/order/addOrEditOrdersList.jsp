<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//提交
    	function submitForm(){
			$("#form1").submit();
    	}
    </script>
	  <div id="addOrEditWin">
	   <form id="form1"  method="post" action="">
	   	<input type="hidden" id="orderDetailId" name="ordersList.orderDetailId" >
	  	<table align="center" class="addOrEditTable" width="600px;" >
	  		<tr><td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
	   				<select name="ordersList.ordersId">
	   					<option>---请选择订单---</option>
	   					<s:iterator value="#session.ordersLists">
		   					<option id="<s:property value='ordersId'/>" value="<s:property value='ordersId'/>"><s:property value="ordersNo"/></option>
	   					</s:iterator>
	   				</select>
		  		</td>
		  	</tr>
	   		<tr><td class="toright_td" width="150px">套餐:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
	   				<select name="ordersList.productId">
						<option>---请选择套餐---</option>
	   					<s:iterator value="#session.productInfoList">
		   					<option id="p_<s:property value='productId'/>" value="<s:property value='productId'/>"><s:property value="productName"/></option>
	   					</s:iterator>
	   				</select>
	   			</td></tr>
	   		<tr><td class="toright_td" width="150px">数量:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="count" type="text" name="ordersList.count" class="{validate:{required:true,maxlength:[20]}}" /></td></tr>
	   	</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>
