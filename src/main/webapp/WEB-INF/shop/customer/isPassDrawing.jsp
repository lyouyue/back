<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){
		$(".isPass").click(function(){
			$(".isPass").each(function(){ 
				$(this).removeAttr("checked"); 
			});
			$("#saveIsPass").val(this.value);
			$("#isPass_"+this.value).attr("checked","checked");
		});
	});
	
	function tj(){
		$("#isPassForm").validate({
			meta: "validate",
			submitHandler: function(form) {
				$("input.button_save").attr("disabled","disabled");
				var options = {  
					url : "${pageContext.request.contextPath}/back/customer/drawing/saveOrUpdateDrawingState.action",  
					type : "post",
					//data:$("#isPassForm").serialize(),
					success : function(data) {
						var obj = eval('('+data+')');
						if(obj.isSuccess){
							closeWin();
							$("#tt").datagrid("reload");
						}else{
							msgShow("系统提示", "<p class='tipInfo'>审核失败，请重试！</p>", "warning");
							closeWin();
							$("#tt").datagrid("reload");
						}
					}
				};  
				$("#isPassForm").ajaxSubmit(options);  
			}
		});
		//校验基本信息表单
		$("#isPassForm").submit(); 
	}
	
</script>
<div id="passWin">
	<form id="isPassForm" method="post">
	<input id="pdrawingId" type="hidden" name="drawingId" value=""/>
	<table align="center" class="addOrEditTable" width="750px;">
		<tr>
			<td class="toright_td">审核状态:</td>
			<td class="toleft_td" colspan="3">
				<input type="hidden" id="saveIsPass" name="state" value=""/>
				<input id="isPass_1"  type="radio" class="isPass" value="1"/>已提交
				<input id="isPass_2"  type="radio" class="isPass" value="2"/>已审核
				<input id="isPass_3"  type="radio" class="isPass" value="3"/>已发放
			</td>
		</tr>
		<tr>
			<td class="toright_td"><span style="color:red">* </span>备注:</td>
			<td class="toleft_td" colspan="3">
				<input type="text" id="premarks" name="remarks"  class="{validate:{required:true,maxlength:[200]}}" value=""/>
			</td>
		
		</tr>
	</table>
	</form>
	 <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="javascript:tj();" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
