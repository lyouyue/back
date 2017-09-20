<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
 	 $(function(){//表单验证
	  	$("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
	            function() {  
	               var options = {  
	                     url : "${pageContext.request.contextPath}/back/customerComplaint/saveOrUpdateCustomerComplaint.action",  
	                     type : "post",  
	                     dataType:"json",
	                     success : function(data) { 
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 $("#tt").datagrid("reload"); //保存后重新加载列表
						 $("#customerComplaintId").val(null);
		                      }
		                  };  
		                  $("#form1").ajaxSubmit(options);  
		                  //$("input.button_save").attr("disabled","disabled");
	               });
	       }
	    });
  })
</script>
<div id="addOrEditWin" >
  	<form id="photoForm" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="800px;">
          <tr>
		      <td class="toright_td" width="150px">问题图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="440px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
		            <span id="mymessage"></span>
		  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto('image_customerComplaint')"/>
		      </td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post" action="" >
        <input id="customerComplaintId" type="hidden" name="customerComplaint.customerComplaintId" value="">
        <input id="imageUrl" type="hidden" name="customer.complaintImageUrl" value="">
        <input id="createTime" type="hidden" name="customerComplaint.createTime" value="">
	    <table align="center" class="addOrEditTable" width="800px;">
		    <tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="customerComplaint.customerId">
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
		           <select id="complaintType" name="customerComplaint.complaintType">
		              <option value="-1">--请选择类型--</option>
					  <s:iterator value="#application.keybook['complaintType']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="complaintOrdersNo" type="text" name="customerComplaint.complaintOrdersNo" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">投诉内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="complaintContext" rows="8" cols="48"  name="customerComplaint.complaintContext" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">投诉状态:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      <input id="state_1"  type="radio" name="customerComplaint.state" checked="checked" value="1"/>审核中&nbsp;&nbsp;&nbsp;
		      <input id="state_2"  type="radio" name="customerComplaint.state" value="2"/>处理中&nbsp;&nbsp;&nbsp;
		      <input id="state_3"  type="radio" name="customerComplaint.state" value="3"/>已关闭</td>
		    </tr>
		      <tr>
		      <td class="toright_td" width="150px">问题图片预览:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="photo"></span></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
		</div>
	</form>
  </div>
