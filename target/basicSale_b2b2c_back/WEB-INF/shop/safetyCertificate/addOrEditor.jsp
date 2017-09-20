<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/safetyCertificate/saveOrUpdateSafetyCertificate.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#safetyCertificateId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="safetyCertificateId" type="hidden" name="safetyCertificate.safetyCertificateId" value="">
        <input id="securityQuestion" type="hidden" name="safetyCertificate.securityQuestion" value="">
	    <table align="center" class="addOrEditTable">
	    	 <tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="safetyCertificate.customerId">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px">密保问题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="question">
		              <option value="-1">--请选择问题--</option>
					  <s:iterator value="#application.keybook['securityQuestion']" var="kb">
					  	<option value="<s:property value="#kb.name"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">密保答案:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="answer" type="text" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">邮箱验证:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="checkingEmail_0" type="radio" name="safetyCertificate.checkingEmail" checked="checked" value="0"/>未验证&nbsp;&nbsp;&nbsp;<input id="checkingEmail_1" type="radio" name="safetyCertificate.checkingEmail" value="1"/>已验证</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">手机验证:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="checkingPhone_0" type="radio" name="safetyCertificate.checkingPhone" checked="checked" value="0"/>未验证&nbsp;&nbsp;&nbsp;<input id="checkingPhone_1" type="radio" name="safetyCertificate.checkingPhone" value="1"/>已验证</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
