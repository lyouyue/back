<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
	 <script type="text/javascript">
	 //详情
		function showDetailInfo(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/rightShow/getRightShowBrandObject.action",
				  data: {showThingId:id},
				   success: function(data){
						//显示 
						createWindow(700,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
						$("#form1").css("display","none");
						$("#d_brandName").html(data.brandName);
						$("#d_photoUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.brandImage+"' width='120px' height='120px' />");
					}
				});
		}
	 </script>
<div id="detailWin">
	<table align="center" class="addOrEditTable" width="600px">
		<tr>
			<td class="toright_td" width="150px">品牌名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_brandName"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">品牌标志:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_photoUrl"></span></td>
		</tr>
	</table>
			<!-- <div style="text-align:center;padding:5px 0;">
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div> -->
		<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
</div>
