<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
	   //表单验证
	    $("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
              function() {  
            	  	var options = {  
                          url : "${pageContext.request.contextPath}/back/productMeasuringUnit/saveMoreProductMeasuringUnit.action",  
                          type : "post",  
                          dataType:"json",
                          success : function(data) { 
                          closeWin();
           				  $("#tt").datagrid("reload"); //保存后重新加载列表
                          }
                      };
                    $("#form1").ajaxSubmit(options);  
                    $("input.button_save").attr("disabled","disabled");//防止重复提交
                 });
	       }
	    });
	  });
</script>
<style type="text/css">
	body{font-family: Arial, Helvetica, sans-serif;font-size:12px}
	li{list-style:none}
	.rowTwo{width:600px;overflow:hidden;margin-left:60px;padding:0}
	.rowTwo li{float:left;width:100px;line-height:26px}
</style>
<div id="addOrEditWin" >
    <form id="form1"  method="post" action="" >
    	<div id="showMeasuringUnitList"></div>
    	<input type="hidden" name="productTypeId" value="${productTypeId}" noclear="true"/>
		<div class="editButton"  data-options="region:'south',border:false" >
	    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    </div>
	</form>
  </div>
