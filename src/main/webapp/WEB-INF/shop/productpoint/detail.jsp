<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#form1").css("display","none");
		$("#form2").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/productpoint/getProductPointInfo.action",
			   data: {productPointId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dproductName").html(data.proName);
				   $("#dIntegral").html(data.integral);
				   $("#dendTimeText").html(data.endTime);
			   }
		});
	}
</script>
<div id="detailWin" style="display: none;">
    <table align="center" class="addOrEditTable" width="500px;">
	    <tr>
	    	<td class="toright_td">套餐名称:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dproductName"></span></td>
	    </tr>
		<tr>
		    <td class="toright_td">金币值:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dIntegral"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">截止日期:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dendTimeText"></span></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>