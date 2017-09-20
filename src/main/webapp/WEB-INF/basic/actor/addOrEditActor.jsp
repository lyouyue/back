<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function checkActor(){
		var actorName =$("#actorName").val();
		var actorId = $("#actorId").val();
		var returnVal=false;
		if(actorName != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/actor/checkActor.action",
				data:{actorName:actorName,actorId:actorId},
				async:false,
				success:function(data){
					if(data == "ok"){
						$("#na").html("<em style='color:green'>可用</em>");
						returnVal=  1;
					}else{
						$("#na").html("<em style='color:red'>已存在</em>");
					}
				}
			});
		}else{
			$("#na").html("");
		}
		return returnVal;
	}
</script>
<div id="addOrEditWin">
	<form id="form1"  method="post" action="">
		<input id="actorId" type="hidden" name="actor.actorId" value="" noclear="true"/>
		<table align="center" class="addOrEditTable" width="600px;">
			<tr>
				<td class="toright_td" width="150px"><font style="color: Red">* </font>角色名称:&nbsp;&nbsp;</td>
				<td  class="toleft_td" width="440px">&nbsp;&nbsp;<input id="actorName" type="text" name="actor.actorName" class="{validate:{required:true,maxlength:[25]}}" onblur="checkActor();"/><span id="na"></td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>
