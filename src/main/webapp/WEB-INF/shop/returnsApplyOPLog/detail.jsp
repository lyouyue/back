<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#reviewWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/returnsApplyOPLog/getReturnsApplyOPLogObject.action",
			   data: {returnsApplyOPLogId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dreturnsApplyNo").html(data.returnsApplyNo);
				   $("#doperatorName").html(data.operatorName);
				   $("#dcomments").val(data.comments);
				   $("#doperatorTime").html(data.operatorTime);
				   $("#dupdateName").html(data.updateName);
				   $("#dupdateTime").html(data.updateTime);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	<tr><td class="toright_td" width="200px">退货申请编号:</td><td class="toleft_td"><span id="dreturnsApplyNo"></span></td></tr>
    	<tr><td class="toright_td" width="200px">操作人:</td><td class="toleft_td"><span id="doperatorName"></span></td></tr>
    	<tr>
   	      <td class="toright_td" width="200px" colspan="1">处理信息:</td>
		      <td  class="toleft_td">
		       <textarea id="dcomments" rows="8" cols="48" disabled="disabled"></textarea>
		  </td>
		</tr>
	    <tr><td class="toright_td" width="200px">操作时间:</td><td class="toleft_td"><span id="doperatorTime"></span></td></tr>
	    <tr><td class="toright_td" width="200px">修改人:</td><td class="toleft_td"><span id="dupdateName"></span></td></tr>
		<tr><td class="toright_td" width="200px">修改时间:</td><td class="toleft_td"><span id="dupdateTime"></span></td></tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>