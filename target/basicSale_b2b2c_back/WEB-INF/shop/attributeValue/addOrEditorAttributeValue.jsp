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
                         url : "${pageContext.request.contextPath}/back/attributeValue/saveOrUpdateAttributeValue.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 $("#productAttrId").val(null);
                         }
                     };  
                 $("#form1").ajaxSubmit(options);  
                 $("input.button_save").attr("disabled","disabled");//防止重复提交
               });
       }
    });
  })
//查询属性值名称是否已存在
	function checkName(id){
		var value = $("#attrValueName").val();
		var productAttrId = $("#productAttrId").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/attributeValue/checkAttrValueName.action",
				data:{name:value,productAttrId:productAttrId},
				success:function(data){
					if(data == "ok"){
						$("#nameMsg").html("<em style='color:green'>可用</em>");
						$("#save").css("display","");
					}else{
						$("#nameMsg").html("<em style='color:red'>已存在</em>");
						$("#attrValueName").focus();
						$("#save").css("display","none");
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
    	<input id="attrValueId" type="hidden" name="attributeValue.attrValueId" value="" noclear="true"/>
    	<input id="productAttrId" type="hidden" name="attributeValue.productAttrId" value="${productAttrId}" noclear="true"/>
		<table style="margin:10px auto;width:600px" class="addOrEditTable" id="addOrEditTable">
			<tr>
				<td class="toright_td" style="width:150px"><span style="color:red">* </span>属性值名称:</td>
				<td class="toleft_td">
					<input id="attrValueName" type="text" name="attributeValue.attrValueName" class="{validate:{required:true,maxlength:[150]}}" onchange="checkName(this.id)"/>
					<span id="nameMsg"></span>
				</td>
			</tr>
			<tr>
				<td class="toright_td" style="width:150px"><span style="color:red">* </span>排序:</td>
				<td class="toleft_td"><input id="sort" type="text" name="attributeValue.sort" class="{validate:{required:true,maxlength:[5]}}"/></td>
			</tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
  </form>
</div>
