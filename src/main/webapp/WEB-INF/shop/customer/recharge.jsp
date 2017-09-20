<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
	$("#form_recharge").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
			function() {  
				var options = {  
					url : "${pageContext.request.contextPath}/back/customer/gotoRechargeMoney.action",  
					type : "post",  
					dataType:"json",
					success : function(data) { 
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						if(data.isSuccess==true){
							msgShow("系统提示", "<p class='tipInfo'>充值成功！</p>", "warning");  
							closeWin();
							$("#tt").datagrid("reload"); //删除后重新加载列表
							$('input[type="checkbox"]').removeAttr("checked");
						}else{
							msgShow("系统提示", "<p class='tipInfo'>充值失败，请重试！</p>", "warning");  
							closeWin();
						}
					}
				};  
				$("#form_recharge").ajaxSubmit(options);  
			});
		}
	});
})
//验证金额   xxx.xx
jQuery.validator.addMethod("amount", function(value, element) {
var length = value.length;
var amount =/^\d+(\.\d\d?)?$/
 return this.optional(element) || (length <= 10 && amount.test(value));
}, "金额格式错误");
</script>
<div id="rechargeWin">
<form id="form_recharge"  method="post">
	<input id="pcustomerId" type="hidden" name="customerId" value=""/>
	<table align="center" class="addOrEditTable" width="700px;">
		<tr id="c_taxpayerNumber">
			<td class="toright_td" width="150px">充值金额:</td>
			<td class="toleft_td" colspan="11">&nbsp;&nbsp;<input id="rechargeAmount" type="text" name="rechargeAmount" class="{validate:{required:true,amount:true}}"/></td>
		</tr>
	</table>
	<br>
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<!-- <input type="submit"  class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp; -->
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form_recharge').submit()" href="javascript:;">确定</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
	</form>
</div>