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
                         url : "${pageContext.request.contextPath}/back/shopMallCoinWithdrawals/saveOrUpdateShopMallCoinWithdrawalsObject.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							  $("input.button_save").removeAttr("disabled");//解除提交锁定
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     $("input.button_save").attr("disabled","disabled");//防止重复提交
                  });
		       }
		    });
  });
</script>

<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="detailId" type="hidden" name="shopMallCoinWithdrawals.detailId" value="">
	    <table class="addOrEditTable" align="center" >
		    <tr>
		      <td class="toright_td" width="150px">当前状态:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="450px">&nbsp;&nbsp;<span id="nowState"></span>&nbsp;&nbsp;&nbsp;</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">审核操作:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="450px" id="checktype1">&nbsp;&nbsp;
		      <input id="state_2" type="radio" name="shopMallCoinWithdrawals.state" value="2" checked="checked"/>审核通过&nbsp;&nbsp;&nbsp;
		      <input id="state_3" type="radio" name="shopMallCoinWithdrawals.state" value="3"/>审核未通过&nbsp;&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="450px" id="checktype2">&nbsp;&nbsp;
		      <input id="state_4" type="radio" name="shopMallCoinWithdrawals.state" value="4" checked="checked"/>支付完成&nbsp;&nbsp;&nbsp;
		      <input id="state_5" type="radio" name="shopMallCoinWithdrawals.state" value="5"/>支付失败&nbsp;&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="450px" id="checktype3">&nbsp;&nbsp;不可操作&nbsp;&nbsp;&nbsp;</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">客服留言:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="450px">&nbsp;&nbsp;<textarea rows="3" cols="50" id="serverMessage" name="shopMallCoinWithdrawals.serverMessage"></textarea>
		    </tr>
    </table>
     <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
     </div>
  </form>
</div>
