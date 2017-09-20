<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript">
function showDetailInfo(id){
	$("#addWin").css("display","none");
	$("#editWin").css("display","none");
	$("#detailWin").css("display","");
	createWindow(700,'auto',"&nbsp;&nbsp;每日推荐套餐详情","icon-tip",false,"detailWin");
	$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/dayRecommend/getDayRecommendInfo.action",
			data: {id:id},
			dataType: "JSON",
			success: function(data){
				$("#d_logoImg").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
				$("#d_productCode").html(data.productCode);
				$("#d_productName").html(data.productName);
				$("#d_sort").html(data.sort);
				if(data.isShow==0){
				$("#d_isShow").html("<font class='color_002'>不显示</font>");
				}else if(data.isShow==1){
				$("#d_isShow").html("<font class='color_001'>显示</font>");
				}
		}
	});
}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
	    <tr>
	      <td class="toright_td" width="150px">套餐图片:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_logoImg"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">套餐名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_productName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">套餐编号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_productCode"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">排序:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_sort"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_isShow"></span></td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>