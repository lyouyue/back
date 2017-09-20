<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(850,'auto',"&nbsp;&nbsp;线下商城详情","icon-tip",false,"detailWin");
		$("#parentIdList1").css("display","none");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/shops/getShopsObject.action",
			data: {shopsId:id},
			dataType: "JSON",
			success: function(data){
				$("#dshopsName").html(data.shopsName);
				$("#dshopsCode").html(data.shopsCode);
				$("#daddress").html(data.address);
				$("#dnote").html(data.note);
				$("#dcreateTime").html(data.createTime);
				$("#dmodifyTime").html(data.modifyTime);
			}
		});
	}
	
	
</script>
<div id="detailWin">
	<table align="center" class="addOrEditTable" width="850px;">
		<tr>
			<td class="toright_td" width="150px">商城名称:</td>
			<td class="toleft_td" width="800px">&nbsp;&nbsp;<span id="dshopsName"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">商城编码:</td>
			<td class="toleft_td" width="800px">&nbsp;&nbsp;<span id="dshopsCode"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">地址:</td>
			<td class="toleft_td" width="800px">&nbsp;&nbsp;<span id="daddress"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">备注:</td>
			<td class="toleft_td" width="800px">&nbsp;&nbsp;<span id="dnote"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">创建时间:</td>
			<td class="toleft_td" width="800px">&nbsp;&nbsp;<span id="dcreateTime"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">修改时间:</td>
			<td class="toleft_td" width="800px">&nbsp;&nbsp;<span id="dmodifyTime"></span></td>
		</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>