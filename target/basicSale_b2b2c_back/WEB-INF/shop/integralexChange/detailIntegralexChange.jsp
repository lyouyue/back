<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(800,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/integralexChange/getIntegralexChangeInfo.action",
			   data: {integralId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dproductId").val(data.productId);
				   $("#dpointExchange").html(data.pointExchange);
				   $("#dmaxUsers").html(data.maxUsers);
				   $("#dmaxProducts").html(data.maxProducts);
				   $("#dchooseVIP").html(data.chooseVIP);
				   $("#dbeginTime").html(data.beginTime);
				   $("#dendTime").html(data.endTime);
				   if(data.state=="0"){
					   $("#dstate").html("未启用");
				   }else{
					   $("#dstate").html("已启用");
				   }
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="500px;">
    	<tr>
		      <td class="toright_td" width="150px">商品名称:</td>
		      <td class="toleft_td">
		           <select id="dproductId" disabled="disabled">
		              <option value="-1">--请选择商品--</option>
					  <s:iterator value="productInfoList">
					  	<option value="<s:property value="productId"/>"><s:property value="productName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
	    <tr>
	    	<td class="toright_td">金币兑换:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dpointExchange"></span></td>
	    </tr>
		<tr>
		    <td class="toright_td">兑换人数上限:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dmaxUsers"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">可兑换商品数量:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dmaxProducts"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">允许兑换的会员等级:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dchooseVIP"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">开启时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dbeginTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">结束时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dendTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">状态:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dstate"></span></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>