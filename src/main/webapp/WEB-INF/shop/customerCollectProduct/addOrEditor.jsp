<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
    $("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/customerCollectProduct/saveOrUpdateCustomerCollectProduct.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#customerCollectProductId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="customerCollectProductId" type="hidden" name="customerCollectProduct.customerCollectProductId" value="">
        <input id="customerId" type="hidden" name="customerCollectProduct.customerId" value="${customerId}">
	    <table align="center" class="addOrEditTable">
	    	<tr>
		      <td class="toright_td" width="150px">套餐信息:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="productId" name="customerCollectProduct.productId">
		              <option value="-1">--请选择套餐--</option>
					  <s:iterator value="productInfoList">
					  	<option value="<s:property value="productId"/>"><s:property value="productName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<!-- <input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp; -->
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
