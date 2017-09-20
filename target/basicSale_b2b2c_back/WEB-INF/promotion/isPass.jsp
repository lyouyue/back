<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
  	$("#nextform").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/promotionapply/saveOrNextPromotionApply.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
	                      }
	                  };  
	                  $("#nextform").ajaxSubmit(options);  
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="passWin">
  <form id="nextform" method="post" >
  <input id="sromotionApplyId" type="hidden" name="promotionApply.promotionApplyId" noclear="true"/>
  <input id="scustomerId" type="hidden" name="promotionApply.customerId" noclear="true"/>
  <input id="sshopInfoId" type="hidden" name="promotionApply.shopInfoId" noclear="true"/>
  
    <table align="center" class="addOrEditTable" width="850px;">
		<tr>
		    <td class="toright_td">会员名称:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="pcustomerId" type="text" size="75" name="promotionApply.customerName" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">店铺名称:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="phopInfoId" type="text" size="75" name="promotionApply.shopName" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">活动开始时间:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="pbeginTime" type="text" size="75" name="promotionApply.beginTime" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">活动结束时间:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="pendTime" type="text" size="75" name="promotionApply.endTime" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">申请时间:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="papplyTime" type="text" size="75" name="promotionApply.applyTime" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
   	      <td class="toright_td" width="150px" colspan="1">促销活动详情:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		       <textarea id="pshopPromotionInfo" rows="8" cols="48" name="promotionApply.shopPromotionInfo" class="{validate:{required:true,maxlength:[2000]}}"></textarea>
		  </td>
	    </tr>
	    <tr>
		    <td class="toright_td">审核是否通过:</td>
		    <td  class="toleft_td" colspan="3">
		    	<input  type="radio" name="promotionApply.isPass" value="1" checked="checked"/>是
		    	<input  type="radio" name="promotionApply.isPass" value="0"  />否
		    </td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#nextform').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>