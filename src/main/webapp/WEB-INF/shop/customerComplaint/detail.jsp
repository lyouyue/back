<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/customerComplaint/getCustomerComplaintObject.action",
			   data: {customerComplaintId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dcustomerId").val(data.customerId);
				   $("#dcomplaintType").val(data.complaintType);
				   $("#dcomplaintOrdersNo").html(data.complaintOrdersNo);
				   $("#dcomplaintContext").val(data.complaintContext);
				   if(data.state=="1"){
					   $("#dstate").html("审核中");
				   }else if(data.state=="2"){
					   $("#dstate").html("处理中");
				   }else if(data.state=="3"){
					   $("#dstate").html("已关闭");
				   }
			   }
		});
	}
</script>
  <div id="detailWin" >
	    <table align="center" class="addOrEditTable" width="800px;">
		    <tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dcustomerId" disabled="disabled">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">投诉类型:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dcomplaintType" disabled="disabled">
		              <option value="-1">--请选择类型--</option>
					  <s:iterator value="#application.keybook['complaintType']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="dcomplaintOrdersNo"></span></td>
		    </tr>
		     <tr>
	   	      <td class="toright_td" width="150px" colspan="1">投诉内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="dcomplaintContext" rows="8" cols="48"  class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">投诉状态:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="dstate"></span></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
  </div>

