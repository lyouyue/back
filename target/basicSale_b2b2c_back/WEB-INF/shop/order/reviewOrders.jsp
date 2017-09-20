<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
    	function updateSate(id){
			var h_rordersNo = $("#h_rordersNo").val();
			var ordersRemark = $("#ordersRemark").val();
			$.ajax({
			   type: "POST",
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/orders/updateOrdersState.action",
		       data: {"h_rordersNo":h_rordersNo,"state":id,"ordersRemark":ordersRemark},
			   success: function(data){
				    location.reload();
			     }
				});
		}

    	function relieveLocked(){
    		var h_rordersNo = $("#h_rordersNo").val();
			$.ajax({
			   type: "POST",
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/orders/relieveLockedState.action",
		       data: {"h_rordersNo":h_rordersNo},
			   success: function(data){
				    location.reload();
			     }
				});
		}

    	function updatePrice(){
    		var ordersId = $("#unordersId").val();
    		var disproductSumNumber = $("#disproductSumNumber").val();
    		var dispayNumber = $("#dispayNumber").val();
			$.ajax({
			   type: "POST",
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/orders/updatePrice.action",
		       data: {"ordersId":ordersId,"disproductSumNumber":disproductSumNumber,"dispayNumber":dispayNumber},
			   success: function(data){
		    	   	if(data.isSuccess == "true"){
				    	location.reload();
				    	msgShow("系统提示", "<p class='tipInfo'>修改成功</p>", "warning");
		    	   	}else{
		    	   		msgShow("系统提示", "<p class='tipInfo'>修改失败</p>", "warning");
		    	   	}
			     }
			});
		}
    </script>
	  <div id="reviewWin" style="width:880px;height:500px;overflow-y:scroll;">
	  	<input type="hidden" name="ordersId" id="unordersId" value=""/>
	  	<input type="hidden" name="productSumNumber" id="hisproductSumNumber" value=""/>
	  	<input type="hidden" name="payNumber" id="hispayNumber" value=""/>
	  	<table align="center" class="addOrEditTable" width="800px;" >
	  		<tr>
	  			<td class="toright_td" width="150px">订单操作状态：</td>
	  			<td colspan="3">
	  				<input type="hidden" id="h_rordersNo" name="ordersNo" value=""/>
	  				<input type="button" name="audit" id="btn2" value="审核通过" onclick="updateSate(this.id);"/>&nbsp;&nbsp;
	  				<input type="button" name="payment" id="btn3" value="支付款" onclick="updateSate(this.id);"/>&nbsp;&nbsp;
	  				<input type="button" name="wait" id="btn4" value="配货完毕"  onclick="updateSate(this.id);"/>&nbsp;&nbsp;
	  				<input type="button" name="deliver" id="btn5" value="发货完毕"  onclick="updateSate(this.id);"/>&nbsp;&nbsp;
	  				<input type="button" name="receiving" id="btn6" value="确认收货"  onclick="updateSate(this.id);"/>&nbsp;&nbsp;
	  				<input type="button" name="cancel" id="btn7" value="作废" onclick="updateSate(this.id);"/>&nbsp;&nbsp;
	  				<input type="button" name="cancel" id="btn8" value="解锁退出" onclick="relieveLocked();"/>&nbsp;&nbsp;
	  			</td>
	  		</tr>
	  		<tr>
	  			<td class="toright_td" width="150px">订单备注(客服留言)：</td>
	  			<td colspan="3">
	  				<input id="ordersRemark" name="ordersRemark" type="text" value=""/>
	  			</td>
	  		</tr>
	  		<tr>
	  			<td colspan="4" style="background-color: #F0F0F0;">
	  				<span><font style="font-size: 15px;">购买人信息：</font></span>
	  			</td>
	  		</tr>
	  		<tr>
		  		<td class="toright_td" width="150px">会员名称:&nbsp;&nbsp;</td>
		   		<td>&nbsp;&nbsp;
		   			<select disabled="disabled" >
		   				<s:iterator value="#session.customerList">
							<option id="d_rcus_<s:property value='customerId'/>" ><s:property value="loginName"/></option>
		   				</s:iterator>
		   			</select>
		   		</td>
		   		<td class="toright_td" width="150px">收货人姓名:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rconsignee"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">省市区县:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rprovince"></span><span id="d_rcityDistrict"></span><span id="d_rcounty"></span></td>
	   			<td class="toright_td" width="150px">详细地址:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_raddress"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">电话:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rphone"></span></td>
	   			<td class="toright_td" width="150px">手机:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rmobilePhone"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">电子邮件:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_remail"></span></td>
	   			<td class="toright_td" width="150px">邮政编码:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rpostcode"></span></td>
	   		</tr>
	   		<tr>
	  			<td colspan="4" style="background-color: #F0F0F0;">
	  				<span><font style="font-size: 15px;">订单信息：</font></span>
	  			</td>
	  		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rordersNo"></span></td>
	   			<td class="toright_td" width="150px">订单生成时间:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rcreateTime"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">商品总金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rproductSumNumber"></span></td>
	   			<td class="toright_td" width="150px">应付金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rpayNumber"></span></td>
	   		</tr>
	   		<tr id="distr" style="display: none;">
		   		<td class="toright_td" width="80px" style="padding-left: 60px;"><font style="color: red;">修改总金额</font>:</td><td>&nbsp;&nbsp;<input id="disproductSumNumber" type="text" name="productSumNumber" value="" class="{validate:{required:true,maxlength:[12]}}"/></td>
		   		<td class="toright_td" width="80px" style="padding-left: 60px;"><font style="color: red;">修改应付金额</font>:</td><td>&nbsp;&nbsp;<input id="dispayNumber" type="text" name="payNumber" value="" class="{validate:{required:true,maxlength:[12]}}"/>&nbsp;&nbsp;<input type="button" value="修改价格" onclick="updatePrice();"/></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">标志建筑:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rflagContractor"></span></td>
	   			<td class="toright_td" width="150px">最佳送货时间:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rbestSendDate"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">配送方式:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rsendType"></span></td>
	   			<td class="toright_td" width="150px">支付方式:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rpayMode"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">运费:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rsendNumber"></span></td>
	   			<td class="toright_td" width="150px">使用金币值:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_ruseIntegral"></span></td>
	   		</tr>
	   		<tr>
	  			<td colspan="4" style="background-color: #F0F0F0;">
	  				<span><font style="font-size: 15px;">其它信息：</font></span>
	  			</td>
	  		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">使用金币金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rintergralNumber"></span></td>
	   			<td class="toright_td" width="150px">使用红包ID:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_ruseRedbag"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">红包金额:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rredbagNumber"></span></td>
	   			<td class="toright_td" width="150px">订单附言:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rcomments"></span></td>
	   		</tr>
	   		<tr>
	   			<td class="toright_td" width="150px">缺货处理:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_roosOperator"></span></td>
	   			<td class="toright_td" width="150px">订单状态:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_rordersState"></span></td>
	   		</tr>
	   	</table>
   		 <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
              <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
          </div>
	  </div>