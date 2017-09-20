<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){
   //表单验证
   $("#form1").validate({meta: "validate", 
      submitHandler:function(form){
      var imageUrl=$("#imageUrl1").val();
      if(imageUrl!=null && imageUrl!=''){
      $(document).ready(
            function() {  
                  var options = {  
                      url : "${pageContext.request.contextPath}/back/customerService/saveOrUpdateCustomerService.action",  
                      type : "post",  
                      dataType:"json",
                      success : function(data) { 
                     	 closeWin();
                     	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
				 $("#tt").datagrid("reload"); //保存后重新加载列表
				 $("#customerServiceId").val(null);
                      }
                  };  
              $("#form1").ajaxSubmit(options);  
              $("input.button_save").attr("disabled","disabled");//防止重复提交
            });
      	}else{
      		$("#mymessage1").html(" <font style='color:red'>请上传员工照片</font>");
      	}
       }
    });
  })
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" style="width:800px;">
          <tr>
		      <td class="toright_td" width="41px"><span style="color:red">* </span>员工照片:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="190px">
		      &nbsp;&nbsp;<input id="fileId1" type="file"  style="width:165px;" name="imagePath"/>
		            <span id="mymessage1"></span>
		  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_customerService','30px','30px','1')"/> 
		  	        <div class="imgMessage">提示：请上传规格宽36px，高36px的图片</div>
		  	        <!-- <font color="red">推荐尺寸153*50</font> -->
		      </td>
		      <td class="toright_td" width="44px">图片预览:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="78px">&nbsp;&nbsp;<span id="photo1"></span></td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post">
    	<input id="imageUrl1" type="hidden" name="customerService.photoUrl" value="">
    	<input id="workNumber" type="hidden" name="customerService.workNumber" value="">
		<table align="center" style=" width:800px" class="addOrEditTable" id="addOrEditTable">
			<tr>
				<td class="toright_td" width="175px"><span style="color:red">* </span>真实姓名:&nbsp;&nbsp;</td>
				<td class="toleft_td" width="440px">
					&nbsp;&nbsp;&nbsp;<input id="trueName" type="text" name="customerService.trueName" style="margin-top:5px;" class="{validate:{required:true,maxlength:[15]}}"/>
					<input id="customerServiceId" type="hidden" name="customerService.customerServiceId" />
				</td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="200px"><span style="color:red">* </span>昵称:&nbsp;&nbsp;</td>
				<td class="toleft_td" width="440px">
					&nbsp;&nbsp;&nbsp;<input id="nikeName" type="text" name="customerService.nikeName" style="margin-top:5px;" class="{validate:{required:true,maxlength:[15]}}"/>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>QQ号码:&nbsp;&nbsp;</td>
				<td class="toleft_td" width="440px">
					&nbsp;&nbsp;&nbsp;<input id="qq" type="text" name="customerService.qq" style="margin-top:5px;" class="{validate:{required:true,digits:true,maxlength:[15]}}"/>
				</td>
				<td class="toright_td" width="150px"><span style="color:red">* </span>手机号:&nbsp;&nbsp;</td>
				<td class="toleft_td" width="440px">
					&nbsp;&nbsp;&nbsp;<input id="mobile" type="text" name="customerService.mobile"  style="margin-top:5px;" class="{validate:{required:true,mobile:true}}"/>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>电话号码:&nbsp;&nbsp;</td>
				<td class="toleft_td" width="440px">
					&nbsp;&nbsp;&nbsp;<input id="phone" type="text" name="customerService.phone"  style="margin-top:5px;" class="{validate:{required:true,phone:true}}"/>
				</td>
		        <td class="toright_td" width="150px">是否废弃:</td>
		        <td class="toleft_td" width="440px">&nbsp;&nbsp;<input id="useState_1"  type="radio" checked="checked" name="customerService.useState" value="1"/>正常使用&nbsp;&nbsp;&nbsp;<input id="useState_0"  type="radio" name="customerService.useState" value="0"/>废弃</td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
  </form>
</div>
