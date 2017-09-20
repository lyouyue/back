<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/customerMsg/getCustomerMsgObject.action",
			   data: {customerMsgId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dcustomerId").val(data.customerId);
				   $("#dtitle").html(data.title);
				   if(data.state=="0"){
					   $("#dstate").html("未回复");
				   }else{
					   $("#dstate").html("已回复");
				   }
				   $("#dtype").val(data.type);
				   $("#dcreateTime").html(data.createTime);
				   $("#dmsg").val(data.msg);
				   $("#dbackMsg").val(data.backMsg);
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
	    <tr><td class="toright_td" width="200px">留言标题:</td><td class="toleft_td" width="500px"><span id="dtitle"></span></td></tr>
	    <tr><td class="toright_td" width="200px">留言状态:</td><td class="toleft_td"><span id="dstate"></span></td></tr>
	    <tr>
	      <td class="toright_td" width="200px">留言类型:</td>
	      <td class="toleft_td">
	           <select id="dtype" disabled="disabled">
	              <option value="-1">--请选择类型--</option>
				  <s:iterator value="#application.keybook['msgType']" var="kb">
				  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
				  </s:iterator>
	           </select>
	      </td>
		</tr>
	    <tr><td class="toright_td" width="200px">留言时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td></tr>
    	<tr>
	   	      <td class="toright_td" width="200px" colspan="1">留言内容:</td>
			      <td  class="toleft_td">
			       <textarea id="dmsg" rows="8" cols="48" ></textarea>
			  </td>
		</tr>
		<tr>
	   	      <td class="toright_td" width="200px" colspan="1">回复内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="dbackMsg" rows="8" cols="48" ></textarea>
			  </td>
		    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>