<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form2").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {
                     url : "${pageContext.request.contextPath}/back/promotion/saveOrUpdateSalesPromotionDiscount.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	$("#tt").datagrid("reload"); //保存后重新加载列表
					 	$("#sales_disproductId").val(null);
					 	$("input.button_save").removeAttr("disabled");//解除提交锁定
	                      }
	                  };  
          			$("#form2").ajaxSubmit(options); 
          			$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="promotionDiscountWin">
	<form id="form2"  method="post">
		<input type="hidden" id="sales_disproductId" name="salesPromotionDiscount.disproductId"/>
		<input type="hidden" id="sales_promotionId" name="salesPromotionDiscount.promotionId" noclear="true"/>
		<input type="hidden" id="sales_promotionIdNumber" name="salesPromotionDiscount.promotionIdNumber"/>
		<table align="center" class="addOrEditTable">
		    <tr>
			    <td class="toright_td">折扣率:</td>
			    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="sales_discount" type="text" name="salesPromotionDiscount.discount" class="{validate:{required:true,max:9.9,min:0}}">折</td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form2').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>