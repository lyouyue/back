<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){//表单验证
		$("#form2").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
	            function() {  
	               var options = {  
	                     url : "${pageContext.request.contextPath}/back/returnsApplyOPLog/saveOrUpdateReturnsApplyOPLog.action",  
	                     type : "post",  
	                     dataType:"json",
	                     success : function(data) { 
		                    	 closeWin();
		                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
								 $("#tt").datagrid("reload"); //保存后重新加载列表
								 $("#rreturnsApplyId").val(null);
			                  $("input.button_save").attr("disabled",false);
		                      }
		                  };  
		                  $("#form2").ajaxSubmit(options);  
		                  //$("input.button_save").attr("disabled","disabled");
	               });
	       }
	    });
  })
</script>
<div id="reviewWin" style="width:880px;height:550px;overflow-y:scroll;">
 <form id="form2" method="post">
   <input type="hidden" id="rreturnsApplyId" name="returnsApplyOPLog.applyId" />
   <input type="hidden" id="rdreturnsApplyNo" name="returnsApplyOPLog.returnsApplyNo" />
   <input id="operatorLoginName" type="hidden" name="returnsApplyOPLog.operatorLoginName"  value="">
   <input id="operatorName" type="hidden" name="returnsApplyOPLog.operatorName"  value="">
   <input id="operatorTime" type="hidden" name="returnsApplyOPLog.operatorTime"  value="">
    <table align="center" class="addOrEditTable">
    	<tr><td class="toright_td" width="200px">退货申请编号:</td><td class="toleft_td"><span id="rreturnsApplyNo"></span></td></tr>
    	 <tr>
	      <td class="toright_td" width="200px">会员名称:</td>
	      <td class="toleft_td">
	           <select id="rcustomerId" disabled="disabled">
	              <option value="-1">--请选择会员--</option>
				  <s:iterator value="customerList">
				  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
				  </s:iterator>
	           </select>
	      </td>
		</tr>
    	<tr><td class="toright_td" width="200px">订单号:</td><td class="toleft_td"><span id="rordersNo"></span></td></tr>
	    <tr><td class="toright_td" width="200px">套餐名称:</td><td class="toleft_td"><span id="rproductName"></span></td></tr>
	    <tr><td class="toright_td" width="200px">期望处理方式:</td><td class="toleft_td"><span id="rdisposeMode"></span></td></tr>
    	<tr>
   	      <td class="toright_td" width="200px" colspan="1">问题描述:</td>
		      <td  class="toleft_td">
		       <textarea id="rproblemDescription" rows="8" cols="48"></textarea>
		  </td>
		</tr>
		 <tr>
		      <td class="toright_td" width="200px">套餐外观:</td>
		      <td class="toleft_td">
		           <select id="rtradeDress" disabled="disabled">
		              <option value="-1">--请选择外观--</option>
					  <s:iterator value="#application.keybook['tradeDress']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		  </tr>
		  <tr>
		      <td class="toright_td" width="200px">套餐包装:</td>
		      <td class="toleft_td">
		           <select id="rcommodityPackaging" disabled="disabled">
		              <option value="-1">--请选择包装--</option>
					  <s:iterator value="#application.keybook['commodityPackaging']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr><td class="toright_td" width="200px">有无凭证:</td><td class="toleft_td"><span id="rrepairCredentials"></span></td></tr>
		    <tr><td class="toright_td" width="200px">套餐附件:</td><td class="toleft_td"><span id="rproductAccessories"></span></td></tr>
		    <tr><td class="toright_td" width="200px">期望返回方式:</td><td class="toleft_td"><span id="rreturnsMode"></span></td></tr>
		    <tr><td class="toright_td" width="200px">收获地址:</td><td class="toleft_td"><span id="rshippingAddress"></span></td></tr>
		    <tr><td class="toright_td" width="200px">联系人:</td><td class="toleft_td"><span id="rlinkman"></span></td></tr>
		    <tr><td class="toright_td" width="200px">手机号码:</td><td class="toleft_td"><span id="rmobilePhone"></span></td></tr>
		    <tr><td class="toright_td" width="200px">申请时间:</td><td class="toleft_td"><span id="rapplyTime"></span></td></tr>
		    <tr><td class="toright_td" width="200px">修改人:</td><td class="toleft_td"><span id="rupdateMember"></span></td></tr>
		    <tr><td class="toright_td" width="200px">修改时间:</td><td class="toleft_td"><span id="rupdateTime"></span></td></tr>
    		<tr>
		      <td class="toright_td" width="200px">审核状态:</td>
		      <td class="toleft_td">
		           <select id="applyState" name="applyState">
		              <option value="-1">--请选择状态--</option>
					  <s:iterator value="#application.keybook['applyState']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		  </tr>
		  <tr>
   	      <td class="toright_td" width="200px" colspan="1">处理信息:</td>
		      <td  class="toleft_td">
		       <textarea id="comments" rows="8" cols="48" class="{validate:{required:true,maxlength:[500]}}"></textarea>
		  </td>
		</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form2').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
	</form>
</div>