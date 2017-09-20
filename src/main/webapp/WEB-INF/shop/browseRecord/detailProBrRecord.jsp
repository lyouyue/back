<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//提交
    	function showDetailInfo(id){
			createWindow(700,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
			$.ajax({
			   type: "POST", 
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/browseRecord/getProBrRecordObject.action",
			   data: {proBrRecordId:id}, 
			   success: function(data){
				   $("#d_mem_"+data.customerId).attr("selected",true); 
				   $("#d_p_"+data.productId).attr("selected",true);
				   $("#d_lastBrTime").html(data.lastBrTime);
			   }
			});
    	}
    </script>
	  <div id="detailWin">
	  	<table align="center" class="addOrEditTable" width="600px;" >
	  		<tr><td class="toright_td" width="150px">会员名称:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
	   				<select disabled="disabled">
	   					<s:iterator value="#session.customerList">
		   					<option id="d_mem_<s:property value='customerId'/>" ><s:property value="loginName"/></option>
	   					</s:iterator>
	   				</select>
		  		</td>
		  	</tr>
	   		<tr><td class="toright_td" width="150px">套餐:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
	   				<select disabled="disabled">
	   					<s:iterator value="#session.productInfoList">
		   					<option id="d_p_<s:property value='productId'/>"><s:property value="productName"/></option>
	   					</s:iterator>
	   				</select>
	   			</td></tr>
	   		<tr><td class="toright_td" width="150px">浏览时间:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_lastBrTime"></span>	</td></tr>
	   	</table>
   		 <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
              <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
          </div>
	  </div>
