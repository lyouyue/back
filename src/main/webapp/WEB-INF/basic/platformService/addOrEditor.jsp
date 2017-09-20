<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
	$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
			function() {  
				var options = {  
					url : "${pageContext.request.contextPath}/back/homeKeyBook/saveOrUpdateHomeKeyBook.action",  
					type : "post",  
					dataType:"json",
					success : function(data) {
						/**更新内存begin**/
						$.ajax({
							type: "POST",dataType: "JSON",
							url: "${pageContext.request.contextPath}/back/homeKeyBook/updateInServletContextHomeKeyBook.action",
							success: function(data){
								if(data.isSuccess=="true") {
									msgShow("系统提示", "<p class='tipInfo'>同步内存成功！</p>", "warning");
								}else{
									msgShow("系统提示", "<p class='tipInfo'>同步内存失败，请手动重试！</p>", "warning");
								}
							}
						});
						
						//获取前台更新初始化信息url
						var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
						var split = prefixUrl.split("@");
						var url=split[0]+"front/homeKeyBook/updateInServletContextHomeKeyBook.action?callback=?";
						$.getJSON(url);
						/**更新内存begin**/
						closeWin();
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload"); //保存后重新加载列表
					}
				};  
				$("#form1").ajaxSubmit(options); 
				$("input.button_save").attr("disabled","disabled");
			});
		}
	});
})
</script>
<div id="addOrEditWin">
	<form id="form1"  method="post">
		<input id="homeKeyBookId" type="hidden" name="homeKeyBook.homeKeyBookId">
		<table align="center" class="addOrEditTable">
			<tr>
				<td class="toright_td" width="150px">类型:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="type" type="text" style="border: none;" value="qqnumber" name="homeKeyBook.type" class="{validate:{required:true,maxlength:[20]}}" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">类型名称:</td>
				<td  class="toleft_td">&nbsp;&nbsp;<input id="typeName" type="text" name="homeKeyBook.typeName" class="{validate:{required:true,maxlength:[45]}}"></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">值:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="value" type="text" name="homeKeyBook.value" class="{validate:{required:true,maxlength:[20]}}"/></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">名称:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="homeKeyBook.name" class="{validate:{required:true,maxlength:[50]}}"></td>
			</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
  </form>
</div>
