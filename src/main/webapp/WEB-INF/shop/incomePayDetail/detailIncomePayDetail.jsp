<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/incomePayDetail/getIncomePayDetailObject.action",
			   data: {detailId:id},
			   dataType: "JSON",
			   success: function(data){
				   var incomePayDetail = data.incomePayDetail;
				   var cust = data.customer;
				   $("#dcustomerId").html(cust.loginName);
				   $("#dserialNumber").html(incomePayDetail.serialNumber);
				   $("#dincomeExpensesType").val(incomePayDetail.incomeExpensesType);
				   $("#dtradeTime").html(incomePayDetail.tradeTime);
// 				   $("#dincome").html(incomePayDetail.income);
// 				   $("#doutlay").html(incomePayDetail.outlay);
				   $("#dbalance").html(incomePayDetail.transactionAmount);
				   $("#dremarks").val(incomePayDetail.customerMessage);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="850px;">
    	<tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           &nbsp;&nbsp;<span id="dcustomerId"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">收支类型:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dincomeExpensesType" disabled="disabled">
		              <option value="-1">--请选择类型--</option>
					  <s:iterator value="#application.keybook['incomeExpensesType']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		<tr>
		    <td class="toright_td">流水号:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dserialNumber"></span></td>
	    </tr>
	     <tr>
		    <td class="toright_td">交易金额:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dbalance"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">交易时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dtradeTime"></span></td>
	    </tr>
<!-- 	    <tr> -->
<!-- 		    <td class="toright_td">收入金额:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dincome"></span></td> -->
<!-- 	    </tr> -->
<!-- 	    <tr> -->
<!-- 		    <td class="toright_td">支出金额:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="doutlay"></span></td> -->
<!-- 	    </tr> -->
	     <tr>
	   	      <td class="toright_td" width="150px" colspan="1">备注:&nbsp;&nbsp;</td>
			      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
			       <textarea disabled="disabled" id="dremarks" rows="8" cols="48" class="{validate:{required:true,maxlength:[700]}}"></textarea>
			  </td>
		    </tr>
    </table>
   <!--  <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>