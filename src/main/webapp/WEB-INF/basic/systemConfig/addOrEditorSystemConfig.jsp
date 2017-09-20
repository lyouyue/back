<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/systemConfig/saveOrUpdateSystemConfig.action",  
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
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="id" type="hidden" name="systemConfig.id" />
	    <table style="text-align: center;width: 95%;margin-left:25px;margin-right:25px;" class="addOrEditTable">
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>名称:</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="name" type="text" name="systemConfig.name" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>类型:</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="type" type="text" name="systemConfig.type" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>值:</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="value" type="text" name="systemConfig.value" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>分组:</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="groupColumn" type="text" name="systemConfig.groupColumn" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
    	</table>
        <div class="editButton"  data-options="region:'south',border:false" >
	    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
        </div>
  </form>
</div>
