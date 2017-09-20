<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/customerCredit/getCustomerCreditObject.action",
			   data: {customerCreditId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dcapacityValue").html(data.capacityValue);
				   $("#dbuyerRank").html(data.buyerRank);
				   $("#dbuyerIcon").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.buyerIcon+"' width='40px' height='20px' />");
			   	   $("#dminRefValue").html(data.minRefValue);
			   	   $("#dmaxRefValue").html(data.maxRefValue);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
	    <tr>
	    	<td class="toright_td">能力值:</td><td  class="toleft_td" width="150px;">&nbsp;&nbsp;<span id="dcapacityValue"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">买家头衔:</td><td  class="toleft_td" width="150px;">&nbsp;&nbsp;<span id="dbuyerRank"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">买家图标:</td><td  class="toleft_td" width="150px;">&nbsp;&nbsp;<span id="dbuyerIcon"></span></td>
	    </tr>
	     <tr>
	    	<td class="toright_td">最小值:</td><td  class="toleft_td" width="150px;">&nbsp;&nbsp;<span id="dminRefValue"></span></td>
	    </tr>
	     <tr>
	    	<td class="toright_td">最大值:</td><td  class="toleft_td" width="150px;">&nbsp;&nbsp;<span id="dmaxRefValue"></span></td>
	    </tr>
    </table>
   <!--  <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>