<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form3").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {
                     url : "${pageContext.request.contextPath}/back/promotion/checkPromotion.action",  
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
          			$("#form3").ajaxSubmit(options); 
          			$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="checkPromotionWin">
	<form id="form3"  method="post">
		<input type="hidden" id="check_promotionId" name="promotionId" noclear="true"/>
		<table align="center" class="addOrEditTable">
		    <tr>
			    <td class="toright_td">是否通过审核:</td>
			    <td class="toleft_td" colspan="3"><input id="isPass_1"  type="radio" name="isPass" checked="checked" value="1"/>待审核&nbsp;&nbsp;<input id="isPass_2"  type="radio" name="isPass" checked="checked" value="2"/>审核通过&nbsp;&nbsp;<input id="isPass_3"  type="radio" name="isPass" value="3"/>审核不通过</td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form3').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>