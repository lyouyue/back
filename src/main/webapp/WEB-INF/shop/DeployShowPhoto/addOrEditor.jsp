<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/deployShowPhoto/saveOrUpdateDeployShowPhoto.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#deployShowPhotoId").val(null);
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
        <input id="deployShowPhotoId" type="hidden" name="deployShowPhoto.deployShowPhotoId" >
	    <table align="center" class="addOrEditTable">
		    <tr>
		      <td class="toright_td" width="150px">值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="value" type="text" name="deployShowPhoto.value" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="deployShowPhoto.name" class="{validate:{required:true,maxlength:[100]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">类型:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="type" type="text" name="deployShowPhoto.type" class="{validate:{required:true,maxlength:[50]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">类型名称:</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="typeName" type="text" name="deployShowPhoto.typeName" class="{validate:{required:true,maxlength:[25]}}"></td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
