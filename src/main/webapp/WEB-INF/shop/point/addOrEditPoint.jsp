<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate",
       submitHandler:function(form){
       $(document).ready(
            function() {
               var options = {
                     url : "${pageContext.request.contextPath}/back/point/saveOrUpdatePoint.action",
                     type : "post",
                     dataType:"json",
                     success : function(data) {
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					 	$("#pointId").val(null);
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
        <input id="pointId" type="hidden" name="point.pointId" value=""/>
	    <table align="center" class="addOrEditTable" width="800px;">
	    	<tr>
		      <td class="toright_td" width="150px">促销活动:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="promotionId" name="point.promotionId">
		              <option value="-1">--请选择活动--</option>
					  <s:iterator value="promotionList">
					  	<option value="<s:property value="promotionId"/>"><s:property value="subject"/></option>
					  </s:iterator>
		           </select>
		      </td>
		     </tr>
		    <tr>
		      <td class="toright_td" width="150px">最小订单金额:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="minNumber" type="text" name="point.minNumber" class="{validate:{required:true,maxlength:[12]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">最大订单金额:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="maxNumber" type="text" name="point.maxNumber" class="{validate:{required:true,maxlength:[12]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">给予金币值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="returnPoint" type="text" name="point.returnPoint" class="{validate:{required:true,maxlength:[8]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">使用结束时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="point.endTimestamp" id="endTimestamp" class="{validate:{required:true}}"/>&nbsp;
				<img onclick="WdatePicker({el:'endTimestamp',dateFmt:'yyyy-MM-dd'})"
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      </td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
