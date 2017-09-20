<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(600,'auto',"&nbsp;&nbsp;金币策略详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/coinRules/getCoinRulesInfo.action",
			   data: {coinRulesId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dvalue").html(data.value);
				   $("#dname").html(data.name);
				   $("#dtype").html(data.type);
				   $("#dtypeName").html(data.typeName);
				   $("#duserName").html(data.userName);
				   $("#dcreateTime").html(data.createTime);
				   $("#dupdateTime").html(data.updateTime);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
	    <tr><td class="toright_td" width="200px">值:</td><td class="toleft_td" width="500px">&nbsp;&nbsp;<span id="dvalue"></span></td></tr>
	    <tr><td class="toright_td" width="200px">名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dname"></span></td></tr>
	    <tr><td class="toright_td" width="200px">类型:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dtype"></span></td></tr>
	    <tr><td class="toright_td" width="200px">类型名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dtypeName"></span></td></tr>
	    <tr><td class="toright_td" width="200px">操作人:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="duserName"></span></td></tr>
	    <tr><td class="toright_td" width="200px">创建时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td></tr>
	    <tr><td class="toright_td" width="200px">修改时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dupdateTime"></span></td></tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>