<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
    	   var imageUrl=$("#imageUrl1").val();
    	   var showLocation=$("#showLocation").val();
       if(showLocation!='---请选择---'){
    	   if(imageUrl !=null && imageUrl !=''){
    		   $("#locationError").html("");//清空提示语
    		   $(document).ready(
    	           function() {  
    	              var options = {  
    	                    url : "${pageContext.request.contextPath}/back/homeAdvertisement/saveOrUpdateHomeAdvertisement.action",  
    	                    type : "post",  
    	                    dataType:"json",
    	                    success : function(data) { 
    	                    	 closeWin();
    	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
    						 	 $("#tt").datagrid("reload"); //保存后重新加载列表
    						 	 $("#advertisementId").val(null);
    	                    }
    	               };  
    	               $("#form1").ajaxSubmit(options);  
    	               $("input.button_save").attr("disabled","disabled");
    	           });
	    	   }else{
	    		   $("#mymessage1").html("<font color='Red'>请上传图片</font>");
	    	   }
    	   }else{
    	   $("#locationError").html("<front style='color:red'>显示位置必选</front>");
       }
       }
    });
  });
  //根据页面所选位置，提示图片上传不同大小
  function choice(){
	  var showLocation=$("#showLocation").val()
		if(showLocation==6){
			$("#msg").html("提示：请上传规格宽1200px，高300px的图片");
		}else if(showLocation==5){
			$("#msg").html("提示：请上传规格宽1200px，高60px的图片");
		}else if(showLocation==4){
			$("#msg").html("提示：请上传规格宽206px，高160px的图片");
		}else if(showLocation==3){
			$("#msg").html("提示：请上传规格宽206px，高160px的图片");
		}else if(showLocation==2){
			$("#msg").html("提示：请上传规格宽206px，高233px的图片");
		}else if(showLocation==1){
			$("#msg").html("提示：请上传规格宽206px，高77px的图片");
		}else{
			$("#msg").html("");
		}
  }
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="800px;">
	          <tr>
			      <td class="toright_td" width="150px"><span style="color:red">* </span>图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td">
			      &nbsp;&nbsp;<input id="fileId1" type="file" name="imagePath"/>
			            <span id="mymessage1"></span>
			  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_homeAdvertisement','100px','40px','1')"/>
			  	        <!-- <div class="imgMessage">提示：请上传规格宽120px，高60px的图片</div> -->
			  	        <div class="imgMessage"><span id="msg"></span></div>
			  	        <%-- <span><font id="tishi" color="red"></font></span> --%>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="advertisementId" type="hidden" name="homeAdvertisement.advertisementId" value=""/>
        <input id="imageUrl1" type="hidden" name="homeAdvertisement.imageUrl" value=""/>
        <input id="createTime" type="hidden" name="homeAdvertisement.createTime" value=""/>
        <input id="publishUser" type="hidden" name="homeAdvertisement.publishUser" value=""/>
	    <table align="center" class="addOrEditTable" width="800px;">
	    	<tr>
			      <td class="toright_td" width="150px">图片预览 :</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			          &nbsp;&nbsp;&nbsp;&nbsp;<span id="photo1"></span>
			      </td>
			</tr>
			<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>显示位置:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;
			  <!-- <input id="showLocation"  type="radio" name="homeAdvertisement.showLocation" checked="checked" value="1"/>首页 -->
				  <select id="showLocation" name="homeAdvertisement.showLocation" value="" onclick="choice();">
				  		<option>---请选择---</option>
				  	<s:iterator value="#application.homekeybook['advertisemenLocation']" var="hbk">
				  		<option value="<s:property value='#hbk.value' />"><s:property value='#hbk.name' /></option>
				  	</s:iterator>
				  </select>
				  <span id="locationError"></span>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>主题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      <input style="width:313px;" id="title" type="text" name="homeAdvertisement.title" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1"><span style="color:red">*</span>简介:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea style="width:310px;margin-top: 10px;"  id="synopsis" rows="3" cols="48" name="homeAdvertisement.synopsis" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>链接:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      		<input style="width:313px;" id="link" type="text" name="homeAdvertisement.link" class="{validate:{required:true,maxlength:[100],url:true}}"/>
		      		<span><font color="red">提示：请添加链接前缀，如http://</font></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>排序:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	  <input style="width:313px;" id="sortCode" type="text" name="homeAdvertisement.sortCode" class="{validate:{required:true,number:true,maxlength:[3],digits:true}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>是否显示:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;
				  <input id="isShow_0"  type="radio" name="homeAdvertisement.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;
				  <input id="isShow_1"  type="radio" name="homeAdvertisement.isShow" value="1"/>显示
			  </td>
		    </tr>
      </table>
	  <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
      </div>
  </form>
</div>
