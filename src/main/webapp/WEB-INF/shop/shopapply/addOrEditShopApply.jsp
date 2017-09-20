<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var obj = document.getElementById("customerId");
               var txts = obj.options[obj.selectedIndex].text;
               var options = {  
                     url : "${pageContext.request.contextPath}/shopapply/saveOrUpdateShopApply.action?parems="+encodeURIComponent(encodeURIComponent(txts))+"",
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
  function uploadIDCardsImage() {
			$(document).ready(  
               function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/shopapply/uploadImage.action",
                        type : "post",  
                        dataType:"json",
                        success : function(data) {
	                        if(data.IDCardsImage=="false1"){
	                          $("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
	                        }else if(data.photoUrl=="false2"){
	                          $("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
	                        }else{
	                         $("#TIDCardsImage").val(data.photoUrl);
	                         $("#IDCardsImages").html("");
	                       	 $("#IDCardsImages").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
	                        } 
                        }
                    };
                   $("#iDCardsImageForm").ajaxSubmit(options);
            });  
		}
  function uploadPermitImage() {
		$(document).ready(  
         function() {  
              var options = {  
                  url : "${pageContext.request.contextPath}/shopapply/uploadImage.action",
                  type : "post",  
                  dataType:"json",
                  success : function(data) {
                      if(data.photoUrl=="false1"){
                        $("#mysmallmessage").html(" <font style='color:red'>请选择上传图片</font>");
                      }else if(data.photoUrl=="false2"){
                        $("#mysmallmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
                      }else{
                       $("#TpermitImage").val(data.photoUrl);
                       $("#permitImages").html("");
                     	 $("#permitImages").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='120px' height='120px' />");
                      } 
                  }
              };
             $("#permitImageForm").ajaxSubmit(options);
      });  
	}
</script>
<div id="addOrEditWin">
	<form id="iDCardsImageForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">身份证照片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="sfileId" type="file" size="24" name="imagePath" />
			            <span id="msfzzp"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadIDCardsImage()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
   	<form id="permitImageForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">执照照片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="zfileId" type="file" size="24" name="imagePath"/>
			            <span id="mzzzp"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPermitImage()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="shopApplyId" type="hidden" name="shopApply.shopApplyId" value=""/>
        <input id="TIDCardsImage" type="hidden" name="shopApply.IDCardsImage" value=""/>
        <input id="TpermitImage" type="hidden" name="shopApply.permitImage" value=""/>
	    <table align="center" class="addOrEditTable" width="850px;">
	    	<tr>
		      <td class="toright_td" width="150px">店铺分类:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="shopCategoryId" name="shopApply.shopCategoryId">
		              <option value="-1">--请选择店铺分类--</option>
					  <s:iterator value="shopCategoryList">
					  	<option value="<s:property value="shopCategoryId"/>"><s:property value="shopCategoryName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">选择会员:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="shopApply.customerId">
		              <option value="-1">--请选择选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">店铺名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="shopName" type="text" size="24" name="shopApply.shopName" class="{validate:{required:true,maxlength:[50]}}"/><font color="red">&nbsp;*</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">所在地区:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="region" type="text" size="24" name="shopApply.region" class="{validate:{required:true,maxlength:[50]}}"/><font color="red">&nbsp;*</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">详细地址:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="address" type="text" size="24" name="shopApply.address" class="{validate:{required:true,maxlength:[200]}}"/><font color="red">&nbsp;*</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">邮政编码:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="postCode" type="text" size="24" name="shopApply.postCode" class="{validate:{required:true,maxlength:[30]}}"/><font color="red">&nbsp;*</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">联系电话:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="phone" type="text" size="24" name="shopApply.phone" class="{validate:{required:true,maxlength:[30]}}"/><font color="red">&nbsp;*</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">身份证:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="IDCards" type="text" size="24" name="shopApply.IDCards" class="{validate:{required:true,maxlength:[30]}}"/><font color="red">&nbsp;*</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">身份证图片预览 :</td>
		      <td  class="toleft_td">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="IDCardsImages"></span>
		      </td>
			</tr>
		    <tr>
		      <td class="toright_td" width="150px">执照图片预览 :</td>
		      <td  class="toleft_td">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="permitImages" ></span>
		      </td>
			</tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
