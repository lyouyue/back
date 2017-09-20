<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/customerAcceptAddress/saveOrUpdateCustomerAcceptAddress.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 $("#customerAcceptAddressId").val(null);
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
        <input id="customerAcceptAddressId" type="hidden" name="customerAcceptAddress.customerAcceptAddressId" value="">
        <input id="customerId" type="hidden" name="customerAcceptAddress.customerId" value="${customerId}">
	    <table align="center" class="addOrEditTable">
	    	<tr>
	  			<td class="toright_td" width="150px">省市区：</td>
	  			<td class="toleft_td">&nbsp;&nbsp;
   				  	 <select name="customerAcceptAddress.province" id="s1" class="{validate:{required:true}}">
						<option>省份</option>
					</select>
					<select name="customerAcceptAddress.city" id="s2" class="{validate:{required:true}}">
						<option>地级市</option>
					</select>
					<select name="customerAcceptAddress.country" id="s3" class="{validate:{required:true}}">
						<option>市、县级市、县</option>
					</select>
	  			</td>
	  		</tr>
		    <tr>
		      <td class="toright_td" width="150px">详细地址：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="address" type="text" name="customerAcceptAddress.address" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">收货人姓名：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="consignee" type="text" name="customerAcceptAddress.consignee" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">最后姓名：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="lastName" type="text" name="customerAcceptAddress.lastName" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">邮箱地址：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="email" type="text" name="customerAcceptAddress.email" class="{validate:{required:true,email:true}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">邮政编码：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="postcode" type="text" name="customerAcceptAddress.postcode" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">手机号：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="mobilePhone" type="text" name="customerAcceptAddress.mobilePhone" class="{validate:{required:true,mobile:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">住宅电话：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="phone" type="text" name="customerAcceptAddress.phone" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">标志建筑物：</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="flagContractor" type="text" name="customerAcceptAddress.flagContractor" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		   <tr>
		     <td class="toright_td" width="100px">送货时间:</td>
	   		<td>
  				<s:iterator value="#application.keybook['bestSendDate']" var="kb">
		  		   	<input  type="radio" id="bestSendDate_<s:property value="#kb.value"/>" name="customerAcceptAddress.bestSendDate" value="<s:property value="#kb.value"/>" checked="checked"/><s:property value="#kb.name"/><br/>
			    </s:iterator>
		  	</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否为确定地址:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="isSendAddress_0"  type="radio" name="customerAcceptAddress.isSendAddress" checked="checked" value="0"/>未确认&nbsp;&nbsp;&nbsp;<input id="isSendAddress_1"  type="radio" name="customerAcceptAddress.isSendAddress" value="1"/>已确认</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<!-- <input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp; -->
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
