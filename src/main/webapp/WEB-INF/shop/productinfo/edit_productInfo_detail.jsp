<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//提交修改详情表单
	function updateFunctionDesc(){
		$("#proFunctionDescForm").validate({
			meta: "validate",
			submitHandler: function(form) {
				//控制保存按钮变灰，避免重复提交
				$("#e_btnSaveFunctionDesc").removeAttr("onclick");
				$("#e_functionDescKE").val(editor2.html());
				var ropts ={
					url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductFunctionDesc.action",
					type : "post",
					dataType:"json",
					success : function(data) {
						if(data.isSuccess){
							msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
							$("#tt").datagrid("reload");
						}else{
							msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
						}
						$("#e_btnSaveFunctionDesc").attr("onclick","javascript:updateFunctionDesc();");
					}
				};
				$("#proFunctionDescForm").ajaxSubmit(ropts);
			}
		});
		$("#proFunctionDescForm").submit();
	}
	
</script>
	<form id="proFunctionDescForm" action="" method="post" enctype="multipart/form-data">
		<input type="hidden" id="e_productId_functionDesc" name="productId"/>
		<table style="margin:10px 8px 8px 8px;width:98%;">
			<tr>
				<td class="toleft_td" colspan="3">
					<input type="hidden" name="productInfo.functionDesc" id="e_functionDescKE"/>
					<textarea id="e_functionDesc" rows="5" style="width:972px;height:255px;visibility:hidden;" cols="48" name="" class="{validate:{maxlength:[700]}}"></textarea>
				</td>
			</tr>
		</table>
		<div style="padding:0px;">
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="e_btnSaveFunctionDesc" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateFunctionDesc();" href="javascript:;">保存</a>
				<a id="e_btnCancelFunctionDesc" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
