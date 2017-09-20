<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
 <div id="addOrEditWin" >
 	<form id="photoForm1" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="140px"><span style="color:red">* </span>PC端图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="380px">
		      &nbsp;&nbsp;<input id="fileId1" type="file"  name="imagePath"/>
		            <span id="mymessage1"></span>
		  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_productType','30px','30px','1')"/>
		  	        <div class="imgMessage">提示：请上传规格宽48px，高48px的图片</div>
		      </td>
		      <td class="toright_td" width="100px">PC端图片预览:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="photo1"></span></td>
		  </tr> 
	 </table>
   	</form>
 	<form id="photoForm2" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="140px"><span style="color:red">* </span>微信端图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="380px">&nbsp;
		      	   <input id="fileId2" type="file"  name="imagePath"/>
		           <span id="mymessage2"></span>
		  	       <input id="buttonId2" type="button" value="上传预览" onclick="uploadPhoto('image_productType','30px','30px','2')"/>
		  	       <div class="imgMessage">提示：请上传规格宽48px，高48px的图片</div>
		      </td>
		      <td class="toright_td" width="100px">微信端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photo2"></span></td>
		  </tr> 
	 </table>
   	</form>
 	<form id="photoForm3" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="140px"><span style="color:red">* </span>APP端图片上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="380px">
		      &nbsp;&nbsp;<input id="fileId3" type="file"  name="imagePath"/>
		            <span id="mymessage3"></span>
		  	        <input id="buttonId3" type="button" value="上传预览" onclick="uploadPhoto('image_productType','30px','30px','3')"/>
		  	        <div class="imgMessage">提示：请上传规格宽48px，高48px的图片</div>
		      </td>
		      <td class="toright_td" width="100px">APP端图片预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photo3"></span></td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post" action="">
        <input id="parentId" type="hidden" name="productType.parentId" value=""/>
        <input id="productTypeId" type="hidden" name="productType.productTypeId" value=""/>
        <input id="imageUrl1" type="hidden" name="productType.categoryImage" value=""/>
        <input id="imageUrl2" type="hidden" name="productType.categoryImageWx" value=""/>
        <input id="imageUrl3" type="hidden" name="productType.categoryImageApp" value=""/>
        <input id="level" type="hidden" name="productType.level" value=""/>
        <input id="loadType" type="hidden" name="productType.loadType" value=""/>
	    <table align="center" class="addOrEditTable" width="600px;">
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
		      <td class="toright_td" width="140px"><span style="color:red">* </span>PC分类名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="sortName" type="text" name="productType.sortName" value="" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    <!-- </tr>
		    <tr> -->
		      <td class="toright_td" width="140px"><span style="color:red">* </span>APP分类名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="sortAppName" type="text" name="productType.sortAppName" value="" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="140px"><span style="color:red">* </span>分类排序:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="productType.sortCode" value="" class="{validate:{required:true,maxlength:[5],digits:true}}"/></td>
		    <!-- </tr>
		    <tr> -->
		      <td class="toright_td" width="140px"><span style="color:red">* </span>分类描述:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="categoryDescription" type="text" name="productType.categoryDescription" value="" class="{validate:{required:true,maxlength:[150]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="140px"><span style="color:red">* </span>是否显示:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="isShow_0" type="radio" name="productType.isShow" value="0"/>不显示&nbsp;&nbsp;&nbsp;<input id="isShow_1" type="radio" checked="checked" name="productType.isShow" value="1"/>显示</td>
		    <!-- </tr>
		     <tr> -->
		      <td class="toright_td" width="140px"><span style="color:red">* </span>是否推荐:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="isRecommend_0" type="radio" name="productType.isRecommend" value="0"/>不推荐&nbsp;&nbsp;&nbsp;<input id="isRecommend_1" type="radio" checked="checked" name="productType.isRecommend" value="1"/>推荐</td>
		    </tr>
		     <!-- <tr id="specific">
		      <td class="toright_td" width="140px">是否专业推荐:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="industrySpecific_0" type="radio" name="productType.industrySpecific" value="0"/>否&nbsp;&nbsp;&nbsp;<input id="industrySpecific_1" type="radio" checked="checked" name="productType.industrySpecific" value="1"/>是</td>
		    </tr> -->
	    </table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	   </div>
	</form>
 </div>
