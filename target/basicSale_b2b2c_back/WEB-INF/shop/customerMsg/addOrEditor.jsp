<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/customerMsg/saveOrUpdateCustomerMsg.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#customerMsgId").val(null);
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
        <input id="customerMsgId" type="hidden" name="customerMsg.customerMsgId" value="">
<%--        <input id="createTime" type="hidden" name="customerMsg.createTime" value="">--%>
	    <table align="center" class="addOrEditTable">
	    	 <tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="customerMsg.customerId">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">留言主题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="title" type="text" name="customerMsg.title" class="{validate:{required:true,maxlength:[200]}}"/></td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">留言内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="msg" rows="8" cols="48"  name="customerMsg.msg" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">留言状态:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="state_0"  type="radio" name="customerMsg.state" checked="checked" value="0"/>未回复&nbsp;&nbsp;&nbsp;<input id="state_1"  type="radio" name="customerMsg.state" value="1"/>已回复</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">留言类型:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="type" name="customerMsg.type">
		              <option value="-1">--请选择类型--</option>
					  <s:iterator value="#application.keybook['msgType']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">回复内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="backMsg" rows="8" cols="48"  name="customerMsg.backMsg" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
