<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
	                url : "${pageContext.request.contextPath}/back/homeKeyBook/saveOrUpdateHomeKeyBook.action",  
	                type : "post",  
	                dataType:"json",
	                success : function(data) { 
		               	 closeWin();
		               	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
		 	 			 $("#tt").datagrid("reload"); //保存后重新加载列表
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
        <input id="homeKeyBookId" type="hidden" name="homeKeyBook.homeKeyBookId">
	    <table align="center" class="addOrEditTable">
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="value" type="text" name="homeKeyBook.value" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="homeKeyBook.name" class="{validate:{required:true,maxlength:[50]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>类型:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="type" type="text" name="homeKeyBook.type" class="{validate:{required:true,maxlength:[20]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>类型名称:</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="typeName" type="text" name="homeKeyBook.typeName" class="{validate:{required:true,maxlength:[45]}}"></td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
  </form>
</div>
