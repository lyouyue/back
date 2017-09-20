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
                         url : "${pageContext.request.contextPath}/back/measuringUnit/saveOrUpdateMeasuringUnit.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 $("#measuringUnitId").val(null);
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     $("input.button_save").attr("disabled","disabled");//防止重复提交

                  });
		       }
		    });
	});
	//查询计量单位是否已存在
	function checkMeasuringUnit(id){
		var value = $("#name").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/measuringUnit/checkMeasuringUnit.action",
				data:{name:value},
				success:function(data){
					var unitValue=$("#name").val();
					if(unitValue.length<=20){
						if(data == "ok"){
							$("#nameMsg").html("<em style='color:green'>可用</em>");
							$("#save").css("display","");
						}else{
							$("#nameMsg").html("<em style='color:red'>已存在</em>");
							$("#name").focus();
							$("#save").css("display","none");
						}
					}else{
						$("#nameMsg").html("");
						$("#name").focus();
					}
				}
			});
		}else{
			$("#nameMsg").html("");
		}
	}
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="measuringUnitId" type="hidden" name="measuringUnit.measuringUnitId" value="">
	    <table style="margin:10px auto;width:500px" class="addOrEditTable" >
		    <tr>
		      <td class="toright_td" style="width:150px"><span style="color:red">* </span>计量单位名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="measuringUnit.name" onchange="checkMeasuringUnit(this.id)" class="{validate:{required:true,maxlength:[20]}}"/>
		    	<span id="nameMsg"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" style="width:150px">是否启用:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;<input id="useState_1"  type="radio" name="measuringUnit.useState" checked="checked" value="1"/>启用&nbsp;&nbsp;<input id="useState_0"  type="radio" name="measuringUnit.useState" value="0"/>不启用</td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
