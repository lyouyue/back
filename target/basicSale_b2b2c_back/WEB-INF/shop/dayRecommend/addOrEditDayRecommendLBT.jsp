<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
      if($("#imageUrl1").val()==null||$("#imageUrl1").val()==""){
    	  $("#mymessage1").html(" <font style='color:red'>请上传图片</font>");
      }else{
    	  $(document).ready(
    	           function() {  
    	              var options = {  
    	                    url : "${pageContext.request.contextPath}/back/dayRecommend/saveOrUpdateDayRecommendLBT.action",  
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
    	               $("input.button_save").attr("disabled","disabled");//防止重复提交
    	           });
      }
       }
    });
  });
</script>
<div id="addOrEditWin">
   	<form id="photoForm1" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="700px;">
	          <tr>
			      <td class="toright_td" width="150px"><span style="color:red">* </span>图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td" >
			      &nbsp;&nbsp;<input id="fileId1" type="file"  name="imagePath"/>
			            <span id="mymessage1"></span>
			  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_homeLBT','100px','50px','1')"/>
			  	        <%-- <span><font id="tishi" color="red"></font><font color="red">提示：请上传1920x396像素的图像</font></span> --%>
			  	        <div class="imgMessage">提示：请上传规格宽1423px，高396px的图片</div>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="broadcastingId" type="hidden" name="dayRecommendLBT.broadcastingId" value=""/>
        <input id="imageUrl1" type="hidden" name="dayRecommendLBT.broadcastingIamgeUrl" value=""/>
        <input id="showLocation" type="hidden" name="dayRecommendLBT.showLocation" value="0"/>
	    <table align="center" class="addOrEditTable" width="700px;">
	    	<tr>
			      <td class="toright_td" width="150px">图片预览:</td>
			      <td  class="toleft_td">
			          <span id="photo1"></span>
			      </td>
			</tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>主题:</td>
		      <td class="toleft_td"><input id="title" type="text" style="width:260px;" name="dayRecommendLBT.title" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1"><span style="color:red">* </span>简介:</td>
			      <td  class="toleft_td">
			       <textarea style="width:258px;" id="synopsis" rows="3" cols="65" name="dayRecommendLBT.synopsis" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>链接:</td>
		      <td class="toleft_td"><input id="interlinkage" type="text" style="width:260px;" name="dayRecommendLBT.interlinkage" class="{validate:{required:true,maxlength:[100],url:true}}"/>
		      		<span><font color="red">提示：请添加链接前缀，如http://</font></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>排序:</td>
		      <td class="toleft_td"><input id="sortCode" type="text" style="width:260px;" maxlength="5" name="dayRecommendLBT.sortCode" class="{validate:{required:true,number:true,maxlength:[4]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>是否显示:</td>
			  <td class="toleft_td">
				  <input id="isShow_0"  type="radio" name="dayRecommendLBT.isShow" checked="checked" value="0"/>不显示
				  <input id="isShow_1"  type="radio" name="dayRecommendLBT.isShow" value="1"/>显示
			  </td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
  </form>
</div>
