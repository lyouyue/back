<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;首页导航条详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/navigation/getNavigationObject.action",
			   data: {navigationId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dnavigationName").html(data.navigationName);
				   $("#dnavigationUrl").html(data.navigationUrl);
				   $("#dsortCode").html(data.sortCode);
				   if(data.isUser==1){
					   $("#disUser").html("<font class='color_001'>使用</font>");
				   }else{
					   $("#disUser").html("<font class='color_002'>不使用</font>");
				   }
				   if(data.isShowOnBar==1){
					   $("#disShowOnBar").html("<font class='color_001'>显示</font>");
				   }else{
					   $("#disShowOnBar").html("<font class='color_002'>不显示</font>");
				   }
				   $("#dseoTitle").html(data.seoTitle);
				   $("#dseoKeyWords").html(data.seoKeyWords);
				   $("#dseoDescrible").html(data.seoDescrible);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
	    <tr><td class="toright_td" width="150px">首页导航条名称:</td><td class="toleft_td" width="500px">&nbsp;&nbsp;<span id="dnavigationName"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条链接:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dnavigationUrl"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条排序号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条是否使用:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disUser"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disShowOnBar"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条SEO标题:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dseoTitle"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条SEO关键字:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dseoKeyWords"></span></td></tr>
	    <tr><td class="toright_td" width="150px">首页导航条SEO简介:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dseoDescrible"></span></td></tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>