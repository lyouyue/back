<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/point/getPointObject.action",
			   data: {pointId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dpromotionId").val(data.promotionId);
				   $("#dminNumber").html(data.minNumber);
				   $("#dmaxNumber").html(data.maxNumber);
				   $("#dreturnPoint").html(data.returnPoint);
				   $("#dendTimestamp").html(data.endTimestamp);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	<tr>
	      <td class="toright_td" width="150px">促销活动:</td>
	      <td class="toleft_td">&nbsp;&nbsp;
	           <select id="dpromotionId" disabled="disabled">
	              <option value="-1">--请选择活动--</option>
				  <s:iterator value="promotionList">
				  	<option value="<s:property value="promotionId"/>"><s:property value="subject"/></option>
				  </s:iterator>
	           </select>
	      </td>
	     </tr>
	    <tr>
	    	<td class="toright_td">最小订单金额:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dminNumber"></span></td>
	    </tr>
		<tr>
		    <td class="toright_td">最大订单金额:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dmaxNumber"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">给予金币值:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dreturnPoint"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">使用结束时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dendTimestamp"></span></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>