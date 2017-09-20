<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/broadcasting/saveOrUpdateBroadcasting.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 	 $("#tt").datagrid("reload"); //保存后重新加载列表
						 	$("#broadcastingId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
               });
       }
    });
  })
   //上传大图片 
		function uploadPhoto() {
			$(document).ready(  
               function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/back/broadcasting/uploadImage.action",
                        type : "post",  
                        dataType:"json",
                        success : function(data) {
	                        if(data.photoUrl=="false1"){
	                          $("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
	                        }else if(data.photoUrl=="false2"){
	                          $("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
	                        }else{
	                         $("#broadcastingIamgeUrl").val(data.photoUrl);
	                         $("#bigPhoto").html("");
	                       	 $("#bigPhoto").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
	                        } 
                        }
                    };
                   $("#bigPhotoForm").ajaxSubmit(options);
            });  
		}
  //上传图片提示语   
  function presentation(){
	  var showLocation = $("#showLocation").val();
	  if(showLocation==1){
		  $("#tishi").html("提示：请上传564*202像素的图片");
	  }else if(showLocation==2){
		  $("#tishi").html("提示：请上传187*181像素的图片");
	  }else if(showLocation==3){
		  $("#tishi").html("提示：请上传197*156像素的图片");
	  }else if(showLocation==4){
		  $("#tishi").html("提示：请上传192*199像素的图片");
	  }else if(showLocation==5){
		  $("#tishi").html("提示：请上传1000*90像素的图片");
	  }else if(showLocation==6){
		  $("#tishi").html("提示：请上传300*400像素的图片");
	  }
  }
</script>
<div id="addOrEditWin">
	<form id="bigPhotoForm" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="800px;">
	          <tr>
			      <td class="toright_td" width="150px">图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" width="470px">
			      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file" name="imagePath"/>
			            <span id="mybigmessage"></span>
			  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto()"/>
			  	        <span><font id="tishi" color="red"></font></span>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="broadcastingId" type="hidden" name="broadcasting.broadcastingId" value=""/>
        <input id="broadcastingIamgeUrl" type="hidden" name="broadcasting.broadcastingIamgeUrl" value=""/>
	    <table align="center" class="addOrEditTable" width="800px;">
	    	<tr>
			      <td class="toright_td" width="150px">图片预览 :</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			          &nbsp;&nbsp;&nbsp;&nbsp;<span id="bigPhoto"></span>
			      </td>
			</tr>
			 <tr>
		      <td class="toright_td" width="150px">显示位置:</td>
		      <td class="toleft_td" width="470px;">&nbsp;&nbsp;
		           <select id="showLocation" name="broadcasting.showLocation" onchange="presentation();">
		              <option value="-1">--请选择显示位置--</option>
					  <s:iterator value="#application.keybook['showLocation']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">主题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="title" type="text" name="broadcasting.title" class="{validate:{required:true,maxlength:[25]}}"/></td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">简介:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="synopsis" rows="8" cols="48" name="broadcasting.synopsis" class="{validate:{required:true,maxlength:[1000]}}"></textarea>
			  </td>
		    </tr>
<%--		    <tr>--%>
<%--		      <td class="toright_td" width="150px">简介:</td>--%>
<%--		      <td class="toleft_td">&nbsp;&nbsp;<input id="synopsis" type="text" name="broadcasting.synopsis" class="{validate:{required:true,maxlength:[50]}}"/></td>--%>
<%--		    </tr>--%>
		    <tr>
		      <td class="toright_td" width="150px">链接:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="interlinkage" type="text" name="broadcasting.interlinkage" class="{validate:{required:true,maxlength:[500,url:true]}}"/>
		      		<span><font color="red">提示：请添加链接前缀，如http://</font></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">排序:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="broadcasting.sortCode" class="{validate:{required:true,maxlength:[4]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否显示:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="isShow_0"  type="radio" name="broadcasting.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;<input id="isShow_1"  type="radio" name="broadcasting.isShow" value="1"/>显示</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
  </form>
</div>
