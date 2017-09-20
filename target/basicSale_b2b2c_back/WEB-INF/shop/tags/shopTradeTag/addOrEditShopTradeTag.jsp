<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<script type="text/javascript">
	//标签名称唯一性校验
	 jQuery.validator.addMethod("checkTageName",function(value, element) {
	    	var flag=true;
	    	if(tagsName!=value){
 				$.ajax({
 				   type: "POST",dataType: "JSON",
 				   url:"${pageContext.request.contextPath}/back/shopTradeTag/checkTageName.action",
 				   data: {tageName:value},
 				   async : false,
 				   success: function(data){
	 				   if(data.isHas=="true"){
	 					   flag=false;
	 				   }
 				   }
 				});
	    	}
 			return flag;
		},"标签名称已存在！" );
</script>
  <div id="addOrEditWin">
  		<!--//right-->
		<form id="form1"  method="post" action="">
			<input id="ttId" type="hidden" name="shopTradeTag.ttId" value=""/>
				<table align="center" class="addOrEditTable" width="600px;">
					<tr>
						<td class="toright_td" width="150px">标签名称:&nbsp;&nbsp;</td>
						<td class="toleft_td">&nbsp;&nbsp;
							<input id="tageNametwo" type="text" name="shopTradeTag.tageName" class="{validate:{required:true,maxlength:15,checkTageName:true}}"/>
						</td>
					</tr>
					<tr>
						<td class="toright_td" width="150px">使用状态:&nbsp;&nbsp;</td>
						<td class="toleft_td">&nbsp;&nbsp;
							<input id="useState_0" type="radio" name="shopTradeTag.useState" value="0" class="{validate:{required:true}}"/>废弃
							<input id="useState_1" type="radio" name="shopTradeTag.useState" value="1" class="{validate:{required:true}}"/>正常使用
						</td>
					</tr>
				</table>
				<div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
				</div>
	</form>
</div>
