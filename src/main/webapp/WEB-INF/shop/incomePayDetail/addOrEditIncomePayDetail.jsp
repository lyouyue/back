<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/incomePayDetail/saveOrUpdateIncomePayDetail.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 if(data.isSuccess=="true"){
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 	 $("#tt").datagrid("reload"); //保存后重新加载列表
                    	 }
                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");//防止重复提交
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
    	<input id="optId" name="optId" value="" type="hidden"/>
	    <table align="center" class="addOrEditTable" width="400px;">
	    	<tr>
		      <td class="toright_td" width="100px">交易状态:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	<input id="state_1"  type="radio" name="optState" value="1"/>申请提现
		      	<input id="state_2"  type="radio" name="optState" value="2"/>平台支付完成
		      	<input id="state_3"  type="radio" name="optState" value="3"/>平台支付失败
		      </td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
  </form>
</div>
