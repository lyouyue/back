<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,"auto","&nbsp;&nbsp;发货详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/shipping/getShippingObject.action",
			   data: {shippingId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dordersId").val(data.ordersId);
				   $("#dshippingSn").html(data.shippingSn);
				   $("#ddeliveryCorpName").html(data.deliveryCorpName);
				   $("#ddeliverySn").html(data.deliverySn);
				   $("#dordersNo").html(data.orders.ordersNo);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="850px;">
    	<tr>
		      <td class="toright_td" width="150px">订单号:</td>
		      <%--<td class="toleft_td">&nbsp;&nbsp;
		            <select id="dordersId" disabled="disabled">
		              <option value="-1">--请选择订单号--</option>
					  <s:iterator value="ordersList">
					  	<option value="<s:property value="ordersId"/>"><s:property value="ordersNo"/></option>
					  </s:iterator>
		           </select> 
		      </td>--%>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dordersNo"></span></td>
		    </tr>
		<tr>
		    <td class="toright_td">发货编号:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dshippingSn"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">物流公司名称:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="ddeliveryCorpName"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">物流编号:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="ddeliverySn"></span></td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>