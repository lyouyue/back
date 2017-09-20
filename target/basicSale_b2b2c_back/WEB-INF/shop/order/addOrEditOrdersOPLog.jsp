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
	  	<table align="center" class="addOrEditTable" width="900px;" height="700px;">
	  		<tr><td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td>
	   			<td>&nbsp;
	   				<select name="ordersOPLog.ordersId" id="ordersId">
	   					<option>---请选择订单---</option>
	   					<s:iterator value="#session.ordersList">
		   					<option value="<s:property value="ordersId"/>"><s:property value="ordersNo"/></option>
	   					</s:iterator>
	   				</select>
		  		</td>
		  	</tr>
	   		<tr><td class="toright_td" width="150px">操作类型:&nbsp;&nbsp;</td>
	   			<td>&nbsp;
	   				<select name="ordersOPLog.ordersOperateState" id="ordersOperateState">
	   					<option>---请选择类型---</option>
	   					<s:iterator value="#session.opLogTypeList" var="opLTL">
		   					<option value="<s:property value="#opLTL.value"/>"><s:property value="#opLTL.name"/></option>
	   					</s:iterator>
	   				</select>
		  		</td>
		  	</tr>
	   		<tr><td class="toright_td" width="150px">备注:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="comments" type="text" name="ordersOPLog.comments" class="{validate:{required:true,maxlength:[50]}}"/></td></tr>
	   		<tr>
	   	      <td class="toright_td" width="150px" colspan="1">订单留言:&nbsp;&nbsp;</td>
			      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
			       <textarea id="ordersMsg" rows="8" cols="48" name="ordersOPLog.ordersMsg" class="{validate:{required:true,maxlength:[700]}}"></textarea>
			  </td>
		    </tr>
	   	</table>
   		 <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
              <a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" href="javascript:submitForm()">保存</a> 
              <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
          </div>
		</form>
	  </div>
