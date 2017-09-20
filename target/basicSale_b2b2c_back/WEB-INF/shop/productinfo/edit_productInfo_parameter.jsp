<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//提交修改商品参数表单
	function updateProductParameters(){
		$("#productParametersForm").validate({
			meta: "validate",
			submitHandler: function(form) {
				//控制保存按钮变灰，避免重复提交
				$("#e_btnSaveProductParameters").removeAttr("onclick");
				var ropts ={
					url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductParameters.action",
					type : "post",
					dataType:"json",
					success : function(data) {
						if(data.isSuccess){
							msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
							$("#tt").datagrid("reload");
						}else{
							msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
						}
						$("#e_btnSaveProductParameters").attr("onclick","javascript:updateProductParameters();");
					}
				};
				$("#productParametersForm").ajaxSubmit(ropts);
			}
		});
		$("#productParametersForm").submit();
	}
</script>
	<form id="productParametersForm" action="" method="post">
		<input type="hidden" id="e_productId_parameters" name="productId"/>
		<table id="e_totalProdPara" style="margin:10px;width:959px;"></table>
		<div style="padding:10px 0;">
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="e_btnSaveProductParameters" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductParameters();" href="javascript:;">保存</a>
				<a id="e_btnCancelProductParameters" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
