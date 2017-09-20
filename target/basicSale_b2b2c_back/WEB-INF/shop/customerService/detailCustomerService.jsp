<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;店铺客服详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
		   type: "POST", dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/customerService/getCustomerServiceInfo.action",
		   data: {ids:id},
		   success: function(data){
			   $("#dphotoUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.photoUrl+"' width='80px' height='100px' />");
			   $("#dtrueName").html(data.trueName);
			   $("#dnikeName").html(data.nikeName);
			   $("#dqq").html(data.qq);
			   $("#dmobile").html(data.mobile);
			   $("#dphone").html(data.phone);
			   //$("#dworkNumber").html(data.workNumber);
			   if(data.useState=="0"){
 				    $("#duseState").html("<font class='color_002'>废弃</font> ");
 			   }else{
 				    $("#duseState").html("<font class='color_001'>正常使用</font>");
 			   }
		   }
		});
	}
</script>
<div id="detailWin">
    <table style="margin:20px auto;width:800px" class="addOrEditTable">
			<tr>
				<td class="toright_td">员工照片:</td>
				<td class="toleft_td" colspan="3"><span id="dphotoUrl"></span></td>
			</tr>
			<tr>
				<td class="toright_td">真实姓名:</td>
				<td class="toleft_td"><span id="dtrueName"></span></td>
				<td class="toright_td">昵称:</td>
				<td class="toleft_td"><span id="dnikeName"></span></td>
			</tr>
			<tr>
				<td class="toright_td">QQ:</td>
				<td class="toleft_td"><span id="dqq"></span></td>
				<td class="toright_td">手机号:</td>
				<td class="toleft_td"><span id="dmobile"></span></td>
			</tr>
			<tr>
				<td class="toright_td">电话号码:</td>
				<td class="toleft_td"><span id="dphone"></span></td>
	      		<td class="toright_td">使用状态:</td>
	      		<td class="toleft_td"><span id="duseState"></span></td>
	    	</tr>
			<%-- <tr>
				<td>工号:</td>
				<td><span id="dworkNumber"></span></td>
			</tr> --%>
	 </table>
	 <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	 </div>
</div>