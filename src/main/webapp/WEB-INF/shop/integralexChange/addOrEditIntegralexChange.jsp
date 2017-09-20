<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate",
       submitHandler:function(form){
       $(document).ready(
            function() {
               var options = {
                     url : "${pageContext.request.contextPath}/back/integralexChange/saveOrUpdateIntegralexChange.action",
                     type : "post",
                     dataType:"json",
                     success : function(data) {
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					  	$("#integralId").val(null);
	                      }
	                  };
	                  $("#form1").ajaxSubmit(options);
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="integralId" type="hidden" name="integralexChange.integralId" value=""/>
	    <table align="center" class="addOrEditTable" width="600px;">
	    	<tr>
		      <td class="toright_td" width="150px">套餐名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="productId" name="integralexChange.productId">
		              <option value="-1">--请选择套餐--</option>
					  <s:iterator value="productInfoList">
					  	<option value="<s:property value="productId"/>"><s:property value="productName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">金币兑换:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="pointExchange" type="text" name="integralexChange.pointExchange" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">兑换人数上限:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="maxUsers" type="text" name="integralexChange.maxUsers" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">可兑换套餐数量:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="maxProducts" type="text" name="integralexChange.maxProducts" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">允许兑换的会员等级:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="chooseVIP" type="text" name="integralexChange.chooseVIP" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">开启时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="integralexChange.beginTime" id="beginTime" class="{validate:{required:true}}"/>&nbsp;
				<img onclick="WdatePicker({el:'beginTime',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">结束时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="integralexChange.endTime" id="endTime" class="{validate:{required:true}}"/>&nbsp;
				<img onclick="WdatePicker({el:'endTime',dateFmt:'yyyy-MM-dd HH:mm:ss'})"
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">状态:&nbsp;&nbsp;</td>
			  <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="state_0"  type="radio" name="integralexChange.state" checked="checked" value="0"/>未开启&nbsp;&nbsp;<input id="state_1"  type="radio" name="integralexChange.state" value="1"/>已开启</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
