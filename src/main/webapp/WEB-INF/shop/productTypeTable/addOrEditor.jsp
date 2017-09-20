<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//添加上传提示信息，控制按钮不可用
	function addFormPhotoMessage(type){
		$("#mymessage"+type).html("<font style='color:green'>文件提交中......</font>");//修改提示信息
		$("#buttonId"+type).attr("disabled","true");//提交按钮不可用
	}
	//清空上传提示信息，恢复按钮可用
	function clearFormPhotoMessage(type){
		$("#mymessage"+type).html("");//清空提示信息
		$("#buttonId"+type).removeAttr("disabled");//提交按钮恢复可用
	}
	
	//上传大图片 
	function uploadPhoto(imageInfoPath,type) {
		//添加上传提示信息，控制按钮不可用
		addFormPhotoMessage(type);
		$(document).ready( function() {
			var options = {
				url : "${pageContext.request.contextPath}/back/upload/asyncUploadImage.action?imageInfoPath="+imageInfoPath,
				type : "post",
				dataType : "json",
				success : function(data) {
					//清空上传提示信息，恢复按钮可用
					clearFormPhotoMessage(type);
					if (data.photoUrl == "false_error") {//上传文件错误，请重试！
						//msgShow("图片异常","您上传的图片格式不对，请确认图片类型为：.gif,.jpg,.jpeg,.png,.bmp格式；上传图片大小不超过2M。",'error');
						msgShow(data.photoUrlErrorMessage,data.photoUrlErrorMessage+"请确认图片类型为：.gif,.jpg,.jpeg,.png,.bmp格式；上传图片大小不超过2M。","error");
					} else {
						$("#imageUrl"+type).val(data.photoUrl);
						$("#photo"+type).html("");
						$("#photo"+type).html("<img style='padding-top:10px' src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
					}
				}
			};
			$("#photoForm"+type).ajaxSubmit(options);
		});
	}
</script> 
 <div id="addOrEditWin" >
 	<form id="photoFormPC" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="140px">pc端图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="389px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileIdPC" type="file"  name="imagePath"/>
		            <span id="mymessagePC"></span>
		  	        <input id="buttonIdPC" type="button" value="上传预览" onclick="uploadPhoto('image_productType','PC')"/>
		      </td>
		      <td class="toright_td" width="100px">pc端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photoPC"></span></td>
		  </tr> 
	 </table>
   	</form>
 	<form id="photoFormWx" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="140px">微信端图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="389px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileIdWx" type="file"  name="imagePath"/>
		            <span id="mymessageWx"></span>
		  	        <input id="buttonIdWx" type="button" value="上传预览" onclick="uploadPhoto('image_productType','Wx')"/>
		      </td>
		      <td class="toright_td" width="100px">微信端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photoWx"></span></td>
		  </tr> 
	 </table>
   	</form>
 	<form id="photoFormApp" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="140px">app端图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="389px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileIdApp" type="file"  name="imagePath"/>
		            <span id="mymessageApp"></span>
		  	        <input id="buttonIdApp" type="button" value="上传预览" onclick="uploadPhoto('image_productType','App')"/>
		      </td>
		      <td class="toright_td" width="100px">App端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photoApp"></span></td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post" action="">
        <input id="parentId" type="hidden" name="productType.parentId" value="${productTypeId }" noclear="true"/>
        <input id="productTypeId" type="hidden" name="productType.productTypeId" value=""/>
        <input id="imageUrlPC" type="hidden" name="productType.categoryImage" value="" />
        <input id="imageUrlWx" type="hidden" name="productType.categoryImageWx" value=""/>
        <input id="imageUrlApp" type="hidden" name="productType.categoryImageApp" value=""/>
        <input id="level" type="hidden" name="productType.level" value="" />
        <input id="loadType" type="hidden" name="productType.loadType" value="" />
	    <table align="center" width="600px;" class="addOrEditTable">
	    	<%-- <tr>
		      <td class="toright_td" width="150px">pc端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photoPC"></span></td>
		    </tr> --%>
	    	<%-- <tr>
		      <td class="toright_td" width="150px">微信端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photoWx"></span></td>
		    </tr> --%>
	    	<%-- <tr>
		      <td class="toright_td" width="150px">App端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photoApp"></span></td>
		    </tr> --%>
		    <tr>
		      <td style="text-align: right;width: 140px;">分类名称:&nbsp;&nbsp;</td>
		      <td style="text-align: left;">&nbsp;&nbsp;<input id="sortName" type="text" name="productType.sortName" value="" class="{validate:{required:true,maxlength:[200]}}"/></td>
		    <!-- </tr>
		    <tr> -->
		      <td class="toright_td" width="140px">App分类名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="sortAppName" type="text" name="productType.sortAppName" value="" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td style="text-align: right;width: 140px;">分类排序:&nbsp;&nbsp;</td>
		      <td style="text-align: left;">&nbsp;&nbsp;<input id="sortCode" type="text" name="productType.sortCode" value="" class="{validate:{required:true,number:true,maxlength:[4]}}"/></td>
		    <!-- </tr> -->
		     <%-- <tr>
		      <td class="toright_td" width="150px">分类楼层:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	<select id="floor" name="productType.floor" class="{validate:{required:true}}" >
				  		<option>---请选择---</option>
				  	<s:iterator value="#application.homekeybook['floor']" var="hbk">
				  		<option value="<s:property value='#hbk.value' />"><s:property value='#hbk.name' /></option>
				  	</s:iterator>
				  </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">首页分类ID:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="categoryDescription" type="text" name="productType.categoryDescription" value="" class="{validate:{required:true,maxlength:[150]}}"/></td>
		    </tr> --%>
		   <!--  <tr> -->
		      <td style="text-align: right;width: 140px;">分类描述:&nbsp;&nbsp;</td>
		      <td style="text-align: left;">&nbsp;&nbsp;<input id="categoryDescription" type="text" name="productType.categoryDescription" value="" class="{validate:{required:true,maxlength:[300]}}"/></td>
		    </tr>
		    <tr>
		      <td style="text-align: right;width: 140px;">是否显示:&nbsp;&nbsp;</td>
		      <td style="text-align: left;">&nbsp;&nbsp;<input id="isShow_0" type="radio" name="productType.isShow" value="0"/>不显示&nbsp;&nbsp;&nbsp;<input id="isShow_1" type="radio" checked="checked" name="productType.isShow" value="1"/>显示</td>
		    <!-- </tr>
		     <tr> -->
		      <td style="text-align: right;width: 140px;">是否推荐:&nbsp;&nbsp;</td>
		      <td style="text-align: left;">&nbsp;&nbsp;<input id="isRecommend_0" type="radio" name="productType.isRecommend" value="0"/>不推荐&nbsp;&nbsp;&nbsp;<input id="isRecommend_1" type="radio" checked="checked" name="productType.isRecommend" value="1"/>推荐</td>
		    </tr>
	    </table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	   </div>
	</form>
 </div>
