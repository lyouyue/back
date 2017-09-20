<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(600,'auto',"&nbsp;&nbsp;系统配置详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/systemConfig/getSystemConfigObject.action",
			   data: {id:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dname").html(data.name);
				   $("#dtype").html(data.type);
				   $("#dvalue").html(data.value);
				   $("#dgroupColumn").html(data.groupColumn);
			   }
		});
	}
</script>
<div id="detailWin">
    <table style="text-align: center;" class="addOrEditTable">
	    <tr><td style="text-align: right;width: 200px;">名称:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dname"></span></td></tr>
	    <tr><td style="text-align: right;width: 200px;">类型:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dtype"></span></td></tr>
	    <tr><td style="text-align: right;width: 200px;">值:</td><td style="text-align: left;width: 500px;">&nbsp;&nbsp;<span id="dvalue"></span></td></tr>
	    <tr><td style="text-align: right;width: 200px;">分组:</td><td style="text-align: left;width: 500px;">&nbsp;&nbsp;<span id="dgroupColumn"></span></td></tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>