<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {
                var options = {  
                     url : "${pageContext.request.contextPath}/back/productInfoQuestion/saveOrUpdateProductInfoQuestion.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
	                      }
	                  };  
                $("#form1").ajaxSubmit(options); 
                $("input.button_save").attr("disabled","disabled");//防止重复提交
               });
       }
    });
  });
  function changeIsPass(id){
	  if(id==1){//上架
		 
	  }else{//不上架
		 
	  }
  }
</script>
<div id="addOrEditWin">
	
    <form id="form1"  method="post" enctype="multipart/form-data">
        <input id="productInfoQuestionId" type="hidden" name="productInfoQuestion.productInfoQuestionId" value="">
        <input id="productId" type="hidden" name="productInfoQuestion.productId" value="">
        <input id="productName" type="hidden" name="productInfoQuestion.productName" value="">
        <input id="customerId" type="hidden" name="productInfoQuestion.customerId" value="">
        <input id="customerName" type="hidden" name="productInfoQuestion.customerName" value="">
        <input id="askType" type="hidden" name="productInfoQuestion.askType" value="">
        <input id="askTime" type="hidden" name="productInfoQuestion.askTime" value="">
        <input id="answer" type="hidden" name="productInfoQuestion.answer" value="">
        <input id="askQuestion" type="hidden" name="productInfoQuestion.askQuestion" value="">
        <input id="checkTime" type="hidden" name="productInfoQuestion.checkTime" value="">
        <input id="updateTime" type="hidden" name="productInfoQuestion.updateTime" value="">
        <input id="shopStatus" type="hidden" name="productInfoQuestion.shopStatus" value="">
	    <table align="center" class="addOrEditTable" width="900px;">
	    	<tr>
	    		<td class="toright_td" width="150px">套餐名称:&nbsp;&nbsp;</td>
	    		<td class="toleft_td"><span id="aproductName"></span>&nbsp;&nbsp;</td>
	    	</tr>
	    	<tr>
	    		<td class="toright_td" width="150px">会员名称:&nbsp;&nbsp;</td>
	    		<td class="toleft_td"><span id="acustomerName"></span>&nbsp;&nbsp;</td>
	    	</tr>
	    	<tr>
	    		<td class="toright_td" width="150px">咨询类型:&nbsp;&nbsp;</td>
	    		<td class="toleft_td"><span id="aaskType"></span>&nbsp;&nbsp;</td>
	    	</tr>
	    	<tr>
	    		<td class="toright_td" width="150px">咨询内容:&nbsp;&nbsp;</td>
	    		<td class="toleft_td"><span id="aaskQuestion"></span>&nbsp;&nbsp;</td>
	    	</tr>
	    	<tr>
	    		<td class="toright_td" width="150px">机构审核:&nbsp;&nbsp;</td>
	    		<td class="toleft_td"><span id="ashopStatus"></span>&nbsp;&nbsp;</td>
	    	</tr>
		    <tr>
		      <td class="toright_td" width="150px">审核状态:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;
			  	<input id="status_1" type="radio" name="productInfoQuestion.status" value="1" onclick="changeIsPass(this.value)"/>未通过
			  &nbsp;&nbsp;&nbsp;<input id="status_2" type="radio" name="productInfoQuestion.status" value="2" onclick="changeIsPass(this.value)"/>已通过
<!-- 			  &nbsp;&nbsp;&nbsp;<input id="status_3" type="radio" name="productInfoQuestion.status" value="3" onclick="changeIsPass(this.value)"/>待审核 -->
		    </tr>
		    <%-- <tr>
		      <td class="toright_td" width="150px">平台答复:&nbsp;&nbsp;</td>
			  <td class="toleft_td" colspan="3">&nbsp;&nbsp;<textarea rows="3" cols="50" id="answer" name="productInfoQuestion.answer" class="{validate:{required:true,maxlength:[450]}}"></textarea>
			  <span style="color:red">句尾要加句号哦！</span></td>
		    </tr> --%>
    </table>
     <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
