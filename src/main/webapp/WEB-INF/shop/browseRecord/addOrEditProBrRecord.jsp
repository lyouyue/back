<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//提交
    	function submitForm(){
			$("#form1").submit();
			$("#proBrRecordId").val(null);
    	}
    </script>
	  <div id="addOrEditWin">
	   <form id="form1"  method="post" action="">
	   	<input type="hidden" id="proBrRecordId" name="proBrRecord.proBrRecordId" >
	  	<table align="center" class="addOrEditTable" width="600px;" >
	  		<tr><td class="toright_td" width="150px">会员名称:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
	   				<select name="proBrRecord.customerId">
<%--	   					<option>请选择会员...</option>--%>
	   					<s:iterator value="#request.customerList">
		   					<option id="mem_<s:property value='customerId'/>" value="<s:property value='customerId'/>"><s:property value="loginName"/></option>
	   					</s:iterator>
	   				</select>
		  		</td>
		  	</tr>
	   		<tr><td class="toright_td" width="150px">套餐:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
	   				<select name="proBrRecord.productId">
<%--	   					<option>请选择套餐...</option>--%>
	   					<s:iterator value="#request.productInfoList">
		   					<option id="p_<s:property value='productId'/>" value="<s:property value='productId'/>"><s:property value="productName"/></option>
	   					</s:iterator>
	   				</select>
	   			</td></tr>
	   		<tr><td class="toright_td" width="150px">浏览时间:&nbsp;&nbsp;</td><td>&nbsp;
	   				<input type="text" name="proBrRecord.lastBrTime" id="lastBrTime"  readonly="readonly" class="{validate:{required:true}}"/>&nbsp;
					<img onClick="WdatePicker({el:'lastBrTime',dateFmt:'yyyy-MM-dd HH:mm:ss'})" src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="15" height="20" align="middle" />
					<span id="ag"></span>
	   		</td></tr>
	   	</table>
   		 <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
              <a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" href="javascript:submitForm()">保存</a> 
              <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
          </div>
		</form>
	  </div>
