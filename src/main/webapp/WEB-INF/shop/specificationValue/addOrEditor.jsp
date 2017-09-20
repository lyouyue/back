<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/specificationValue/saveOrUpdateSpecificationValue.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#specificationValueId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");//防止重复提交
               });
       }
    });
  })
  //上传图片 
		function uploadPhoto() {
			$(document).ready(  
               function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/back/specificationValue/uploadImage.action",
                        type : "post",  
                        dataType:"json",
                        success : function(data) {
	                        if(data.photoUrl=="false1"){
	                          $("#mymessage").html(" <font style='color:red'>请选择上传图片</font>");
	                        }else if(data.photoUrl=="false2"){
	                          $("#mymessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
	                        }else{
	                         $("#image").val(data.photoUrl);
	                         $("#photo").html("");
	                       	 $("#photo").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='120px' height='120px' />");
	                        } 
                        }
                    };
                   $("#photoForm").ajaxSubmit(options);
            });  
		}
</script>
<div id="addOrEditWin">
	<%--<form id="photoForm" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="150px">头像上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="440px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
		            <span id="mymessage"></span>
		  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto()"/>
		      </td>
		  </tr> 
	 </table>
   	</form> --%>
    <form id="form1"  method="post">
        <input id="specificationValueId" type="hidden" name="specificationValue.specificationValueId" value=""/>
        <input id="specificationId" type="hidden" name="specificationValue.specificationId" value="${specificationId }" noclear="true"/>
        <input id="image" type="hidden" name="specificationValue.image" value=""/>
	    <table align="center" class="addOrEditTable" width="600px;">
		  <%--  <tr>
		      <td class="toright_td" width="150px">套餐规格:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	<span>
		      		<s:property value='#request.name'/>
		      	</span>
		      </td>
		    </tr> --%>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>规格值名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="specificationValue.name" class="{validate:{required:true,maxlength:[150]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>排序号:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sort" type="text" name="specificationValue.sort" class="{validate:{required:true,maxlength:[5]}}"></td>
		    </tr>
		    <%--
		     <tr>
		      <td class="toright_td" width="150px">图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photo"></span></td>
		    </tr> --%>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
