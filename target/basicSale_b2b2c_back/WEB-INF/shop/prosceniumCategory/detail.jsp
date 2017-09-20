<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/prosceniumCategory/getProsceniumCategoryInfo.action",
			   data: {prosceniumCategoryId:id},
			   dataType: "JSON",
			   success: function(data){
				   var prosceniumCategory=data.prosceniumCategory;
			       $("#dproductTypeName").html(prosceniumCategory.productTypeName+"&nbsp;&gt;&nbsp;"+prosceniumCategory.secondProductTypeName);
			       $("#dtitle").html(prosceniumCategory.title);
			       $("#dsynopsis").html(prosceniumCategory.synopsis);
			       $("#dinterlinkage").html(prosceniumCategory.interlinkage);
			       $("#dsortCode").html(prosceniumCategory.sortCode);
			       $("#dprosceniumCategoryUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+prosceniumCategory.prosceniumCategoryUrl+"' width='120px' height='120px' />");
			       if(prosceniumCategory.isShow=="0"){
			       	$("#disShow").html("不显示");
			       }else{
			       	$("#disShow").html("显示");
			       }
			       
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="600px;">
	    <tr>
	      <td class="toright_td" width="150px">分类名称:</td>
	      <td class="toleft_td">&nbsp;&nbsp;<spand id="dproductTypeName"></spand></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">简介:</td>
	      <td class="toleft_td">&nbsp;&nbsp;<spand id="dsynopsis"></spand></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">图片:</td>
	      <td class="toleft_td">&nbsp;&nbsp;<spand id="dprosceniumCategoryUrl"></spand></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">连接:</td>
	      <td class="toleft_td">&nbsp;&nbsp;<spand id="dinterlinkage"></spand></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">排序号:</td>
	      <td class="toleft_td">&nbsp;&nbsp;<spand id="dsortCode"></spand></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">是否显示:&nbsp;&nbsp;</td>
		  <td class="toleft_td">&nbsp;&nbsp;<spand id="disShow"></spand></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>