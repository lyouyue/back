<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/brandShowcase/getBrandShowcaseInfo.action",
			   data: {brandShowcaseId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dbrandName").html(data[0]);
				   $("#dproductName").html(data[1]);
				   $("#dtitle").html(data[2].title);
				   $("#dsynopsis").html(data[2].synopsis);
				   if(data[2].isShow=="0"){
					   $("#disShow").html("不显示");
				   }else if(data[2].isShow=="1"){
					   $("#disShow").html("显示");
				   }
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="700px;">
    	<tr>
		    <td width="200px;" class="toright_td">品牌:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbrandName"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">套餐:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dproductName"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td">主题:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dtitle"></span></td>
	    </tr>
		    <tr><td class="toright_td">简介:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsynopsis"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>