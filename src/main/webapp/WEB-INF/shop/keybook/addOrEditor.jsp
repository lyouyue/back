<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/keybook/saveOrUpdateKeyBook.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#keyBookId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");//防止重复提交
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="keyBookId" type="hidden" name="keyBook.keyBookId" >
	    <table align="center" class="addOrEditTable">
		    <tr>
		      <td class="toright_td" width="150px">值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="value" type="text" name="keyBook.value" class="{validate:{required:true,maxlength:[500]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="keyBook.name" class="{validate:{required:true,maxlength:[200]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">类型:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="type" type="text" name="keyBook.type" class="{validate:{required:true,maxlength:[200]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">类型名称:</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="typeName" type="text" name="keyBook.typeName" class="{validate:{required:true,maxlength:[200]}}"></td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
  </form>
</div>
