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
					url : "${pageContext.request.contextPath}/back/topSearch/saveOrUpdateTopSearch.action",  
					type : "post",  
					dataType:"json",
					success : function(data) { 
				   	 closeWin();
				   	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					}
				};
				var flag = false;
				$("[name='topSearch.showClient']:checkbox").each(function(index){
					if($(this).attr("checked")=="checked"){
						flag=true;
					}
				});
				if(flag){
					$("#form1").ajaxSubmit(options); 
					$("input.button_save").attr("disabled","disabled");//防止重复提交
				}else{
					msgShow("系统提示", "<p class='tipInfo'>显示位置，请至少选择一项！</p>", "warning");  
				}
			 });
	   }
	});
  })
</script>
<div id="addOrEditWin">
	<form id="form1"  method="post">
		<input id="topSearchId" type="hidden" name="topSearch.topSearchId" value="">
		<table align="center" style="width: 700px;" class="addOrEditTable">
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>关键词:</td>
				<td class="toleft_td"><input id="keywords" type="text" style="width:150px;" name="topSearch.keywords" class="{validate:{required:true,maxlength:[50]}}"/></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>排序号:</td>
				<td class="toleft_td"><input id="sortCode" type="text" style="width:150px;" name="topSearch.sortCode" class="{validate:{required:true,number:true,maxlength:[2]}}"/></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>是否显示:</td>
				<td class="toleft_td">
					<input id="isShow_0" type="radio" name="topSearch.isShow" checked="checked" value="0"/>不显示&nbsp;
					<input id="isShow_1" type="radio" name="topSearch.isShow" value="1"/>显示
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>显示位置:</td>
				<td class="toleft_td">
					<input type="checkbox" class="showClient" id="showClient_1" name="topSearch.showClient" value="1"/>pc端
					<input type="checkbox" class="showClient" id="showClient_2" name="topSearch.showClient" value="2"/>微信端
					<input type="checkbox" class="showClient" id="showClient_3" name="topSearch.showClient" value="3"/>app端
				</td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
  </form>
</div>
