<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
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
						 $("#returnsApplyOPLogId").val(null);
		                      }
		                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
  
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="returnsApplyOPLogId" type="hidden" name="returnsApplyOPLog.returnsApplyOPLogId" value="">
        <input id="applyId" type="hidden" name="returnsApplyOPLog.applyId" value="">
        <input id="returnsApplyNo" type="hidden" name="returnsApplyOPLog.returnsApplyNo" value="">
        <input id="operatorLoginName" type="hidden" name="returnsApplyOPLog.operatorLoginName" value="">
        <input id="operatorName" type="hidden" name="returnsApplyOPLog.operatorName" value="">
        <input id="operatorTime" type="hidden" name="returnsApplyOPLog.operatorTime" value="">
	    <table align="center" class="addOrEditTable">
		   <tr>
	   	      <td class="toright_td" width="150px" colspan="1">处理信息:</td>
			      <td  class="toleft_td">
			       <textarea id="comments" rows="8" cols="48" name="returnsApplyOPLog.comments" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		   </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
