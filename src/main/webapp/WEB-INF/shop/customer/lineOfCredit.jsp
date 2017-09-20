<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script>
$(function(){
	  //表单校验
	  $("#lineOfCreditForm").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                   var options = {  
                       url : "${pageContext.request.contextPath}/back/customer/levelAndLineOfCredit.action",  
                       queryParams:{pageSize:pageSize},
                       type : "post",  
                       dataType:"json",
                       success : function(data) { 
                    	   if(data&&data.isSuccess=="true"){
	                      	 closeWin();
	                      	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
                    	   }
                       }
                   };  
                   $("#lineOfCreditForm").ajaxSubmit(options);  
                });
		       }
		    });
});
</script>
  <div id="lineOfCreditWin" >
  	<form id="lineOfCreditForm">
  		<input id="customerId-line" name="customerId" type="hidden" value="" />
		<table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">会员等级:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;
					<s:iterator value="#application.keybook['customerLevel']" var="kb">
							<input id="customerLevel_<s:property value="#kb.value"/>"  type="radio" name="customerLevel" value="<s:property value='#kb.value'/>" /><s:property value="#kb.name"/>&nbsp;&nbsp;
					</s:iterator>
			  </td>
		    </tr>
		    
		      <tr>
		      <td class="toright_td" width="150px">授信额度:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;
		      			<input id="lineOfCredit" name="lineOfCredit" type="text" value="" class="{validate:{digits:true,maxlength:[10]}}" placeholder="此处以元为单位"/>
			  </td>
		    </tr>
		    
		     <tr>
		      <td class="toright_td" width="150px">授信期限:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;
		      			<input id="creditDate" name="creditDate" type="text" value="" class="{validate:{digits:true,maxlength:[3]}}" placeholder="此处请填写天数"/>
			  </td>
		    </tr>
		</table>
		<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
		</div>
  	</form>
  </div>

