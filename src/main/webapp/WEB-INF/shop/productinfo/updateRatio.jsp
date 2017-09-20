<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
	$("#updateRatioForm").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
			function() {
					var options = {  
						url : "${pageContext.request.contextPath}/back/productinfo/updateRatio.action",  
						type : "post",  
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){//审核成功
								closeWin();
								$("#tt").datagrid("clearSelections");//删除后取消所有选项
								$("#tt").datagrid("reload"); //保存后重新加载列表
								$("#productId").val(null);
							}else{
								msgShow("系统提示", "<p class='tipInfo'>审核失败，请重试！</p>", "warning");  
							}
						}
					};
					$("#updateRatioForm").ajaxSubmit(options); 
					$("input.button_save").attr("disabled","disabled");//防止重复提交
			});
		}
	});
});

</script>
<div id="updateRatioWin">
	
	<form id="updateRatioForm"  method="post" enctype="multipart/form-data">
		<input id="ur_productId" type="hidden" name="productId" value="">
		<table align="center" class="addOrEditTable" width="900px;" style="margin-left:50px;">
			<tr>
				<td class="toright_td" width="150px"><font color="Red"> *</font>上一级返利比例:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="ur_upRatio" type="text" name="productInfo.upRatio" />%</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><font color="Red"> *</font>上一级返利比例:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="ur_secRatio" type="text" name="productInfo.secRatio"  />%</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><font color="Red"> *</font>上一级返利比例:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="ur_thiRatio" type="text" name="productInfo.thiRatio" />%</td>
			</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#updateRatioForm').submit()" href="javascript:;">保存</a>
	    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
