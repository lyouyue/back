<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/rechargeSheet/saveOrUpdateRechargeSheet.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#rechargeSheetId").val(null);
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
        <input id="rechargeSheetId" type="hidden" name="rechargeSheet.rechargeSheetId" value="">
        <input id="rechargeOrderNum" type="hidden" name="rechargeSheet.rechargeOrderNum" value="">
        <input id="rechargeTime" type="hidden" name="rechargeSheet.rechargeTime" value="">
	    <table align="center" class="addOrEditTable">
	    	 <tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="rechargeSheet.customerId">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">充值金额:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="rechargeAmount" type="text" name="rechargeSheet.rechargeAmount" class="{validate:{required:true,maxlength:[12]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">备注:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="remark" type="text" name="rechargeSheet.remark" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">状态:</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="state_0" type="radio" name="rechargeSheet.state" checked="checked" value="0"/>未支付&nbsp;&nbsp;&nbsp;<input id="state_1" type="radio" name="rechargeSheet.state" value="1"/>已支付</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
