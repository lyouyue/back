<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/shipping/saveOrUpdateShipping.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					 	 $("#shippingId").val(null);
	                      }
	                  };  
             		  $("#ordersId").removeAttr("disabled");
             		  $("#deliveryCorpName").removeAttr("disabled");
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");//防止重复提交
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="shippingId" type="hidden" name="shipping.shippingId" value=""/>
        <input id="dcode" type="hidden" name="shipping.code" value=""/>
        <input id="shippingSn" type="hidden" name="shipping.shippingSn" value=""/>
	    <table align="center" class="addOrEditTable" width="850px;">
	    	<tr>
		      <td class="toright_td" width="150px">订单号:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="ordersId" name="shipping.ordersId" disabled="disabled">
		              <option value="-1">--请选择订单号--</option>
					  <s:iterator value="ordersList">
					  	<option value="<s:property value="ordersId"/>"><s:property value="ordersNo"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">物流公司名称:</td>
		      <td class="toleft_td" colspan="3" >&nbsp;&nbsp;<input id="deliveryCorpName" style="width: 165px;" disabled="disabled"  type="text" name="shipping.deliveryCorpName" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>物流编号:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="deliverySn"  style="width: 165px;" type="text" name="shipping.deliverySn" class="{validate:{required:true,maxlength:[32]}}"/></td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
