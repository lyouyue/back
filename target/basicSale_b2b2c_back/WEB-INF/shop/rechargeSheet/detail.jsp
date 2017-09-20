<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/rechargeSheet/getRechargeSheetObject.action",
			   data: {rechargeSheetId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dcustomerId").val(data.customerId);
				   $("#drechargeOrderNum").html(data.rechargeOrderNum);
				   $("#drechargeAmount").html(data.rechargeAmount+"元");
				   $("#dremark").html(data.remark);
				   if(data.state=="0"){
					   $("#dstate").html("未支付");
				   }else{
					   $("#dstate").html("已支付");
				   }
				   $("#drechargeTime").html(data.rechargeTime);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	 <tr>
	      <td class="toright_td" width="200px">会员名称:</td>
	      <td class="toleft_td">
	           <select id="dcustomerId" disabled="disabled">
	              <option value="-1">--请选择会员--</option>
				  <s:iterator value="customerList">
				  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
				  </s:iterator>
	           </select>
	      </td>
		</tr>
	    <tr><td class="toright_td" width="200px">充值单号:</td><td class="toleft_td" width="500px"><span id="drechargeOrderNum"></span></td></tr>
	    <tr><td class="toright_td" width="200px">充值金额:</td><td class="toleft_td"><span id="drechargeAmount"></span></td></tr>
	    <tr><td class="toright_td" width="200px">备注:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dremark"></span></td></tr>
	    <tr><td class="toright_td" width="200px">状态:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dstate"></span></td></tr>
	    <tr><td class="toright_td" width="200px">充值时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="drechargeTime"></span></td></tr>
    </table>
   <!--  <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>