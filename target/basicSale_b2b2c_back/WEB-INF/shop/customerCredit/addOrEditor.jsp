<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   $("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/customerCredit/saveOrUpdateCustomerCredit.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#customerCreditId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
   //上传买家图标 
		function uploadBigPhoto() {
			$(document).ready(  
               function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/back/customerCredit/uploadImage.action",
                        type : "post",  
                        dataType:"json",
                        success : function(data) {
	                        if(data.photoUrl=="false1"){
	                          $("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
	                        }else if(data.photoUrl=="false2"){
	                          $("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
	                        }else{
	                         $("#buyerIcon").val(data.photoUrl);
	                         $("#buyerPhoto").html("");
	                       	 $("#buyerPhoto").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='40px' height='20px' />");
	                        } 
                        }
                    };
                   $("#bigPhotoForm").ajaxSubmit(options);
            });  
		}
</script>
<div id="addOrEditWin">
	<form id="bigPhotoForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="800px;">
	          <tr>
			      <td class="toright_td" width="150px">买家图标:&nbsp;&nbsp; </td>
			      <td class="toleft_td" >
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file" name="imagePath"/>
			            <span id="mybigmessage"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadBigPhoto()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="customerCreditId" type="hidden" name="customerCredit.customerCreditId" value="">
        <input id="buyerIcon" type="hidden" name="customerCredit.buyerIcon" value=""/>
	    <table align="center" class="addOrEditTable" width="800px;">
	    	<tr>
			      <td class="toright_td" width="150px">买家图标预览 :</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			          &nbsp;&nbsp;&nbsp;&nbsp;<span id="buyerPhoto"></span>
			      </td>
			</tr>
		    <tr>
		      <td class="toright_td" width="150px">能力值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="capacityValue" type="text" name="customerCredit.capacityValue" class="{validate:{required:true,maxlength:[8]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">买家头衔:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="buyerRank" type="text" name="customerCredit.buyerRank" class="{validate:{required:true,maxlength:[50]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">最小值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="minRefValue" type="text" name="customerCredit.minRefValue" class="{validate:{required:true,maxlength:[4]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">最大值:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="maxRefValue" type="text" name="customerCredit.maxRefValue" class="{validate:{required:true,maxlength:[4]}}"></td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
