<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/safetyCertificate/getSafetyCertificateObject.action",
			   data: {safetyCertificateId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dcustomerId").val(data.customerId);
				   var securityQuestion = data.securityQuestion;
				   var question = securityQuestion.split(":");
				   $("#dquestion").html(question[0]);
				   if(data.checkingEmail=="0"){
					   $("#dcheckingEmail").html("未验证");
				   }else{
					   $("#dcheckingEmail").html("已验证");
				   }
				   if(data.checkingPhone=="0"){
					   $("#dcheckingPhone").html("未验证");
				   }else{
					   $("#dcheckingPhone").html("已验证");
				   }
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	 <tr>
	      <td class="toright_td" width="200px">会员名称:</td>
	      <td class="toleft_td">
	           <select id="dcustomerId" disabled="disabled">
	              <option value="-1">--请选择类型--</option>
				  <s:iterator value="customerList">
				  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
				  </s:iterator>
	           </select>
	      </td>
		</tr>
	    <tr><td class="toright_td" width="200px">密保问题:</td><td class="toleft_td" width="500px"><span id="dquestion"></span></td></tr>
	    <tr><td class="toright_td" width="200px">邮箱验证:</td><td class="toleft_td" width="500px"><span id="dcheckingEmail"></span></td></tr>
	    <tr><td class="toright_td" width="200px">手机验证:</td><td class="toleft_td" width="500px"><span id="dcheckingPhone"></span></td></tr>
    </table>
   <!--  <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>