<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
	       $(document).ready(
	            function() {
	               var obj1 = document.getElementById("customerId");
	               var txts1 = obj1.options[obj1.selectedIndex].text;
	               var obj2 = document.getElementById("regionLocation");
	               var txts2 = obj2.options[obj2.selectedIndex].text;
	               var options = {
	                     url : "${pageContext.request.contextPath}/back/shopinfo/saveOrUpdateShopInfo.action?isFalg=se&customerName="+encodeURIComponent(encodeURIComponent(txts1))+"&regionLocation="+encodeURIComponent(encodeURIComponent(txts2))+"",
	                     type : "post",  
	                     dataType:"json",
	                     success : function(data) { 
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 	 $("#tt").datagrid("reload"); //保存后重新加载列表
						 	 $("#shopInfoId").val(null);
		                 }
                  };  
	              $("#form1").ajaxSubmit(options);  
	              $("input.button_save").attr("disabled","disabled");//防止重复提交
            });
       }
    });
  })
 
   function uploadIDCardsImage() {
		$(document).ready(
			function(){  
	        	var options = {
	            	url : "${pageContext.request.contextPath}/back/shopinfo/uploadImage.action",
                    type : "post",  
                    dataType:"json",
                    success : function(data) {
                    	if(data.IDCardsImage=="false1"){
                       		$("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
                     	}else if(data.photoUrl=="false2"){
                       		$("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
                     	}else{
                      		$("#eIDCardsImage").val(data.photoUrl);
                      		$("#IDCardsImagePreview").html("");
                    	 	$("#IDCardsImagePreview").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
                     	} 
                    }
                };
             $("#IDCardsImageForm").ajaxSubmit(options);
         });  
	}

  function uploadBusinessLicense() {
		$(document).ready(
			function(){  
	        	var options = {
	            	url : "${pageContext.request.contextPath}/back/shopinfo/uploadImage.action",
                  type : "post",  
                  dataType:"json",
                  success : function(data) {
                  	if(data.IDCardsImage=="false1"){
                   		$("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
                   	}else if(data.photoUrl=="false2"){
                   		$("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
                   	}else{
                   		$("#ebusinessLicense").val(data.photoUrl);
                   		$("#businessLicensePreview").html("");
               	 		$("#businessLicensePreview").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
                   	} 
                  }
              };
           $("#businessLicenseForm").ajaxSubmit(options);
       });  
	}
  function uploadCompanyDocuments() {
		$(document).ready(
			function(){  
	        	var options = {
	            	url : "${pageContext.request.contextPath}/back/shopinfo/uploadImage.action",
            type : "post",  
            dataType:"json",
            success : function(data) {
            	if(data.IDCardsImage=="false1"){
             		$("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
             	}else if(data.photoUrl=="false2"){
             		$("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
             	}else{
             		$("#ecompanyDocuments").val(data.photoUrl);
             		$("#companyDocumentsPreview").html("");
         	 		$("#companyDocumentsPreview").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
             	} 
            }
        };
     $("#companyDocumentsForm").ajaxSubmit(options);
	 });  
	}
  
  function uploadTaxRegistrationDocuments() {
		$(document).ready(
			function(){  
	        	var options = {
	            	url : "${pageContext.request.contextPath}/back/shopinfo/uploadImage.action",
            type : "post",  
            dataType:"json",
            success : function(data) {
            	if(data.IDCardsImage=="false1"){
             		$("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
             	}else if(data.photoUrl=="false2"){
             		$("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
             	}else{
             		$("#etaxRegistrationDocuments").val(data.photoUrl);
             		$("#taxRegistrationDocumentsPreview").html("");
         	 		$("#taxRegistrationDocumentsPreview").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
             	} 
            }
        };
     $("#taxRegistrationDocumentsForm").ajaxSubmit(options);
 });  
}
  
  function uploadMarketBrandUrl() {
		$(document).ready(
			function(){  
	        	var options = {
	            	url : "${pageContext.request.contextPath}/back/shopinfo/uploadImage.action",
            type : "post",  
            dataType:"json",
            success : function(data) {
            	if(data.IDCardsImage=="false1"){
             		$("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
             	}else if(data.photoUrl=="false2"){
             		$("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
             	}else{
             		$("#emarketBrandUrl").val(data.photoUrl);
             		$("#marketBrandUrlPreview").html("");
         	 		$("#marketBrandUrlPreview").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
             	} 
            }
        };
     $("#marketBrandUrlForm").ajaxSubmit(options);
 });  
	}
  function isRegionLocation(){
	  var country = $("#country").val();
	  $("#regionLocation").html("<option value='-1'>--请选择州省地区--</option>");
	  $.ajax({
		   type: "POST", dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/shopinfo/selectCountry.action",
		   data: {ids:country},
		   success: function(data){
			   var length = data.length;
			   for(var i=0;i<length;i++){
				   $("#regionLocation").append($("<option value='"+data[i].districtInfoId+"'>"+data[i].districtName+"</option>"));
			   }
		   }
		});
  }
  function ischeckispass(){
	  var isPass = $("#eisPass").val();
	  if("" == isPass){
		  $("#cheIspass").html("<font color='red'>新添加时不能选择是!</font>");
		  $("#sc").attr("checked",false);
		  $("#cc").attr("checked",true);
		  return;
	  }else{
		  $("#cheIspass").html("");
	  }
	  if(isPass == "0"){
		  $("#cheIspass").html("<font color='red'>没有通过,不能选择是!</font>");
		  $("#sc").attr("checked",false);
		  $("#cc").attr("checked",true);
		  return;
	  }else{
		  $("#cheIspass").html("");
	  }
  }
  
  function cls(){
 	//捕获触发事件的对象，并设置为以下语句的默认对象
	with(event.srcElement)
	//如果当前值为默认值，则清空
	if(value==defaultValue) value=""
}
function res(){
//捕获触发事件的对象，并设置为以下语句的默认对象
with(event.srcElement)
//如果当前值为空，则重置为默认值
if(value=="") value=defaultValue
}
</script>
<div id="addOrEditWin">
	<form id="IDCardsImageForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">身份证照片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="sfile" type="file" size="30" name="imagePath" />
			            <span id="IDCardsImageUpload"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadIDCardsImage()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
	<form id="businessLicenseForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">营业执照图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="yfile" type="file" size="30" name="imagePath"/>
			            <span id="businessLicenseUpload"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadBusinessLicense()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
	<form id="companyDocumentsForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">公司证件图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="gfile" type="file" size="30" name="imagePath"/>
			            <span id="companyDocumentsUpload"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadCompanyDocuments()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
	<form id="taxRegistrationDocumentsForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">税务登记证图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="sfile" type="file" size="30" name="imagePath"/>
			            <span id="taxRegistrationDocumentsUpload"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadTaxRegistrationDocuments()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
	<form id="marketBrandUrlForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="850px;" height="500px;">
	          <tr>
			      <td class="toright_td" width="150px">售卖品牌图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="smfile" type="file" size="30" name="imagePath"/>
			            <span id="marketBrandUrlUpload"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadMarketBrandUrl()"/>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="shopInfoId" type="hidden" name="shopInfo.shopInfoId" value=""/>
        <input id="eIDCardsImage" type="hidden" name="shopInfo.IDCardsImage" value=""/>
        <input id="ebusinessLicense" type="hidden" name="shopInfo.businessLicense" value=""/>
        <input id="ecompanyDocuments" type="hidden" name="shopInfo.companyDocuments" value=""/>
        <input id="etaxRegistrationDocuments" type="hidden" name="shopInfo.taxRegistrationDocuments" value=""/>
        <input id="emarketBrandUrl" type="hidden" name="shopInfo.marketBrandUrl" value=""/>
        <input id="everifier" type="hidden" name="shopInfo.verifier" value=""/>
        <input id="eisPass" type="hidden" name="shopInfo.isPass" value=""/>
        
	    <table align="center" class="addOrEditTable" width="850px;">
	    	<tr>
		      <td class="toright_td" width="150px">店铺分类:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		           <select id="shopCategoryId" name="shopInfo.shopCategoryId">
		              <option value="-1">--请选择店铺分类--</option>
					  <s:iterator value="shopCategoryList">
					  	<option value="<s:property value="shopCategoryId"/>"><s:property value="shopCategoryName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		      <td class="toright_td" width="150px">选择会员:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		           <select id="customerId" name="shopInfo.customerId">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">店铺名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="shopName" type="text" size="30" name="shopInfo.shopName" class="{validate:{required:true,maxlength:[50]}}"/></td>
		      <td class="toright_td" width="150px">经营类型:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		           <select id="businessType" name="shopInfo.businessType">
		              <option value="-1">--请选择经营类型--</option>
					  <s:iterator value="#application.keybook['businessType']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		    	<td class="toright_td" width="150px">国家:</td>
		      	<td class="toleft_td" colspan="3">&nbsp;&nbsp;
		           <select id="country" name="shopInfo.country" onchange="isRegionLocation()"> 
		              <option value="-1">--请选择国家--</option>
					  <s:iterator value="districtInfoList">
					  	<option value="<s:property value="districtInfoId"/>"><s:property value="districtName"/></option>
					  </s:iterator>
		           </select>
		     	 </td>
		        <td class="toright_td" width="150px">州省地区:</td>
		    	<td class="toleft_td" colspan="3">&nbsp;&nbsp;
		           <select id="regionLocation" name="shopInfo.regionLocation">
		              <option value="-1">--请选择州省地区--</option>
		           </select>
		     	 </td>
		    </tr>
		    <tr>
		    	<td class="toright_td" width="150px">城市:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="city" type="text" size="30" name="shopInfo.city" class="{validate:{required:true,maxlength:[100]}}"/></td>
		        <td class="toright_td" width="150px">详细地址(街道):</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="address" type="text" size="30" name="shopInfo.address" class="{validate:{required:true,maxlength:[200]}}"/></td>
		    </tr>
		    <tr>
		        <td class="toright_td" width="150px">邮政编码:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="postCode" type="text" size="30" name="shopInfo.postCode" class="{validate:{required:true,maxlength:[30]}}"/></td>
		        <td class="toright_td" width="150px">主要销售产品:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="mainProduct" type="text" size="30" name="shopInfo.mainProduct"  onfocus="cls()" onblur="res()" value="product(,)product(,)product(,)product" class="{validate:{required:true,maxlength:[300]}}"/><font style="color: red">注:按照表格内格式填写</font></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">公司注册年份:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" id="companyRegistered" name="shopInfo.companyRegistered" size="25" readonly="readonly"/>&nbsp;
				<img onclick="WdatePicker({el:'companyRegistered',dateFmt:'yyyy-MM-dd'})" 
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      </td>
		      <td class="toright_td" width="150px">公司法人:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="legalOwner" type="text" size="30" name="shopInfo.legalOwner" class="{validate:{required:true,maxlength:[100]}}" /></td>
		     </tr>
		    <tr>
		    	<td class="toright_td" width="150px">身份证:</td>
		      	<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="IDCards" type="text" size="30" name="shopInfo.IDCards" class="{validate:{required:true,maxlength:[30]}}" /></td>
		        <td class="toright_td" width="150px">公司认证:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="companyCertification" type="text" size="30" name="shopInfo.companyCertification" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		    	<td class="toright_td" width="150px">电子邮箱:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="email" type="text" size="30" name="shopInfo.email" class="{validate:{required:true,maxlength:[100]}}"/></td>
		        <td class="toright_td" width="150px">联系电话:</td>
		        <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="phone" type="text" size="30" name="shopInfo.phone" class="{validate:{required:true,maxlength:[30]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">营业时间开始:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="businessHoursStart" type="text" size="30" name="shopInfo.businessHoursStart" class="{validate:{required:true,maxlength:[100]}}"/></td>
		      </td>
		      <td class="toright_td" width="150px">营业时间结束:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="businessHoursEnd" type="text" size="30" name="shopInfo.businessHoursEnd" class="{validate:{required:true,maxlength:[100]}}"/></td>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">售卖品牌名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="marketBrand" type="text" size="30" name="shopInfo.marketBrand" class="{validate:{required:true,maxlength:[30]}}"/></td>
		      <td class="toright_td" width="150px">售卖品牌图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="marketBrandUrlPreview"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">身份证图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="IDCardsImagePreview"></span>
		      </td>
		      <td class="toright_td" width="150px">执照图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="businessLicensePreview" ></span>
		      </td>
			</tr>
			<tr>
		      <td class="toright_td" width="150px">公司证件图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="companyDocumentsPreview"></span>
		      </td>
		      <td class="toright_td" width="150px">税务登记证图片预览 :</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		          &nbsp;&nbsp;&nbsp;&nbsp;<span id="taxRegistrationDocumentsPreview" ></span>
		      </td>
			</tr>  
		    <tr>
		    	<td class="toright_td">是否关闭:</td>
			    <td  class="toleft_td" colspan="6">
			    	<input  type="radio" id="cc" name="shopInfo.isClose" value="0" checked="checked"/>否
			    	<input  type="radio" id="sc" name="shopInfo.isClose" value="1" onclick="ischeckispass()"/>是
			    	&nbsp;<span id="cheIspass"></span>
			    </td>
	    	</tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
