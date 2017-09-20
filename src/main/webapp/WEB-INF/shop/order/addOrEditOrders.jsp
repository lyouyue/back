<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript">
 $(function(){
   $("#form1").validate({meta: "validate",
       submitHandler:function(form){
       $(document).ready(
            function() {
               var options = {
                     url : "${pageContext.request.contextPath}/back/orders/saveOrUpdateOrders.action",
                     type : "post",
                     dataType:"json",
                     success : function(data) {
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					 	 $("#ordersId").val(null);
	                      }
	                  };
	                  $("#form1").ajaxSubmit(options);
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
 });
</script>
	<div id="addOrEditWin" >
	   <form id="form1"  method="post">
	   	<input type="hidden" id="ordersId" name="orders.ordersId" value="">
	   	<input type="hidden" id="createTime" name="orders.createTime" value="">
	   	<input type="hidden" id="ordersState" name="orders.ordersState" value="">
	   	<input type="hidden" id="isLocked" name="orders.isLocked" value="0">
	   	<input type="hidden" id="ordersRemark" name="orders.ordersRemark" value="">
	  	<table align="center" class="addOrEditTable" width="850px;" >
	  		<tr>
	  			<td colspan="4" style="background-color: #F0F0F0;">
	  				<span><font style="font-size: 15px;">购买人信息：</font></span>
	  			</td>
	  		</tr>
	   		<tr><td class="toright_td" width="100px">会员名称:&nbsp;&nbsp;</td>
		   		<td>&nbsp;&nbsp;
		   			<select name="orders.customerId" id="customerId">
		   				<option>---请选择会员---</option>
		   				<s:iterator value="#session.customerList">
							<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
		   				</s:iterator>
		   			</select>
		   		</td>
		   		<td class="toright_td" width="100px">收货人姓名:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input width="370px;" id="consignee" type="text" name="orders.consignee" value="" class="{validate:{required:true,maxlength:[15]}}"/></td>
		   	</tr>
			<tr>
	  			<td class="toright_td" width="100px">省市区:&nbsp;&nbsp;</td>
	  			<td class="toleft_td">&nbsp;&nbsp;
   				  	 <select name="orders.province" id="s1">
						<option value="">省份</option>
					</select>
					<select name="orders.cityDistrict" id="s2">
						<option value="">地级市</option>
					</select>
					<select name="orders.county" id="s3">
						<option value="">市、县级市、县</option>
					</select>
	  			</td>
		   		<td class="toright_td" width="100px">详细地址:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="address" type="text" name="orders.address" value="" class="{validate:{required:true,maxlength:[50]}}"/></td>
	  		</tr>
	   		<tr>
	  			<td class="toright_td" width="100px">电子邮件:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="email" type="text" name="orders.email" value="" class="{validate:{required:true,email:true}}"/></td>
		   		<td class="toright_td" width="100px">邮政编码:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="postcode" type="text" name="orders.postcode" value="" class="{validate:{required:true,maxlength:[10]}}"/></td>
	   		</tr>
	   		<tr>
		   		<td class="toright_td" width="100px">电话:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="phone" type="text" name="orders.phone" value="" class="{validate:{required:true,maxlength:[15]}}"/></td>
		   		<td class="toright_td" width="100px">手机:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="mobilePhone" type="text" name="orders.mobilePhone" value=""  class="{validate:{required:true,maxlength:[15]}}"/></td>
	   		</tr>
	   		<tr>
	  			<td colspan="4" style="background-color: #F0F0F0;">
	  				<span><font style="font-size: 15px;">订单信息：</font></span>
	  			</td>
	  		</tr>
	   		<tr>
		   		<td class="toright_td" width="100px">标志建筑:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="flagContractor" type="text" name="orders.flagContractor" value=""  class="{validate:{required:true,maxlength:[50]}}"/></td>
		   		<td class="toright_td" width="100px">送货时间:&nbsp;&nbsp;</td>
		   		<td>
			  		   	<input  type="radio" id="bestSendDate_1" name="orders.bestSendDate" value="1" checked="checked"/>只工作日送货(双休日、假日不用送)<br/>
			  		   	<input  type="radio" id="bestSendDate_2" name="orders.bestSendDate" value="2"/>工作日、双休日与假日均可送货<br/>
			  		   	<input  type="radio" id="bestSendDate_3" name="orders.bestSendDate" value="3"/>只双休日、假日送货(工作日不用送)
			  	</td>
		  	</tr>
	   		<tr><td class="toright_td" width="100px">配送方式:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
		  		   	<input  type="radio" id="sendType_1" name="orders.sendType" value="1" checked="checked"/>快递公司
		  		   	<input  type="radio" id="sendType_2" name="orders.sendType" value="2" />同城快递
		  		</td>
		  		<td class="toright_td" width="100px">支付方式:&nbsp;&nbsp;</td>
	   			<td>&nbsp;&nbsp;
		  		   	<input  type="radio" id="payMode_1" name="orders.payMode" value="1" checked="checked"/>货到付款
		  		   	<input  type="radio" id="payMode_2" name="orders.payMode" value="2"/>支付宝
		  		   	<input  type="radio" id="payMode_3" name="orders.payMode" value="3"/>汇款/转账
		  		</td>
		  	</tr>
	   		<tr>
		   		<td class="toright_td" width="100px">套餐总金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="productSumNumber" type="text" name="orders.productSumNumber" value=""  class="{validate:{required:true,maxlength:[10]}}"/></td>
		   		<td class="toright_td" width="100px">应付金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="payNumber" type="text" name="orders.payNumber" value="" class="{validate:{required:true,maxlength:[10]}}"/></td>
	   		</tr>
	   		<tr>
		   		<td class="toright_td" width="100px">运费:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="sendNumber" type="text" name="orders.sendNumber" value="" class="{validate:{required:true,maxlength:[10]}}"/></td>
		   		<td class="toright_td" width="100px">使用金币值:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="useIntegral" type="text" name="orders.useIntegral" value="" class="{validate:{required:true,maxlength:[8]}}"/></td>
	   		</tr>
		  	<tr>
	  			<td colspan="4" style="background-color: #F0F0F0;">
	  				<span><font style="font-size: 15px;">其它信息：</font></span>
	  			</td>
	  		</tr>
	  		<tr>
		   		<td class="toright_td" width="100px">使用金币金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="intergralNumber" type="text" name="orders.intergralNumber" value="" class="{validate:{required:true,maxlength:[8]}}"/></td>
		   		<td class="toright_td" width="100px">使用红包ID:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="useRedbag" type="text" name="orders.useRedbag" value=""  class="{validate:{required:true,maxlength:[8]}}"/></td>
	   		</tr>
	   		<tr>
		   		<td class="toright_td" width="100px">红包金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="redbagNumber" type="text" name="orders.redbagNumber" value="" class="{validate:{required:true,maxlength:[10]}}"/></td>
		   		<td class="toright_td" width="100px">订单附言:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<input id="comments" type="text"  name="orders.comments" value="" class="{validate:{required:true,maxlength:[500]}}"/></td>
	   		</tr>
	   		<tr>
		   		<td class="toright_td" width="100px">缺货处理:&nbsp;&nbsp;</td>
	   			<td colspan="3">&nbsp;&nbsp;
		  		   	<input  type="radio" id="oosOperator_1" name="orders.oosOperator" value="1" checked="checked"/>等待所有套餐备齐再发货
		  		   	<input  type="radio" id="oosOperator_2" name="orders.oosOperator" value="2"/>取消订单
		  		   	<input  type="radio" id="oosOperator_3" name="orders.oosOperator" value="3"/>与店主协商
		  		</td>
		  	</tr>
	   	</table>
   		 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
		 </div>
	</form>
</div>
