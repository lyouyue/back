<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
    	   var imageUrl=$("#imageUrl1").val();
    	   if(imageUrl!=null && imageUrl!=''){
       $(document).ready(
           function() {  
              var options = {  
                    url : "${pageContext.request.contextPath}/back/homeLBT/saveOrUpdateHomeLBT.action",  
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
               $("input.button_save").attr("disabled","disabled");
           });
    	   }else{
    		   $("#mymessage1").html(" <font style='color:red'>请上传图片</font>");
    	   }
       }
    });
  });
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="800px;">
	          <tr>
			      <td class="toright_td" width="150px"><span style="color:red">* </span>图片:&nbsp;&nbsp; </td>
			      <td class="toleft_td">
			      &nbsp;&nbsp;<input id="fileId1" type="file" name="imagePath"/>
			            <span id="mymessage1"></span>
			  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_homeLBT','100px','40px','1')"/>
			  	        <div class="imgMessage">提示：请上传规格宽1920px，高481px的图片</div>
			  	        <%-- <span><font id="tishi" color="red"></font></span> --%>
			      </td>
			  </tr> 
		 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="broadcastingId" type="hidden" name="homeLBT.broadcastingId" value=""/>
        <input id="imageUrl1" type="hidden" name="homeLBT.broadcastingIamgeUrl" value=""/>
        <input id="createTime" type="hidden" name="homeLBT.createTime" value=""/>
        <input id="publishUser" type="hidden" name="homeLBT.publishUser" value=""/>
	    <table align="center" class="addOrEditTable" width="800px;">
		    <tr>
			      <td class="toright_td" width="150px">图片预览 :&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			          &nbsp;&nbsp;&nbsp;&nbsp;<span id="photo1"></span>
			      </td>
			</tr>
		    <tr>
			      <td class="toright_td" width="150px"><font style="color: Red">* </font>主题:&nbsp;&nbsp;</td>
			      <td class="toleft_td">&nbsp;&nbsp;
			      <input id="title" type="text" name="homeLBT.title" class="{validate:{required:true,maxlength:[50]}}" style="width:313px;"/>
			      </td>
		    </tr>
		    <tr>
		   	      <td class="toright_td" width="150px" colspan="1"><font style="color: Red">* </font>简介:&nbsp;&nbsp;</td>
				  <td  class="toleft_td">&nbsp;&nbsp;
				       <textarea style="width:310px;margin-top: 10px;" id="synopsis" rows="3" cols="48" name="homeLBT.synopsis" class="{validate:{required:true,maxlength:[500]}}"></textarea>
				  </td>
		    </tr>
		    <tr>
			      <td class="toright_td" width="150px"><font style="color: Red">* </font>链接:&nbsp;&nbsp;</td>
			      <td class="toleft_td">&nbsp;&nbsp;<input id="interlinkage" type="text"  style="width:313px;" name="homeLBT.interlinkage" class="{validate:{required:true,maxlength:[100],url:true}}"/>
			      		<span><font color="red">提示：请添加链接前缀，如http://</font></span>
			      </td>
		    </tr>
		    <tr>
			      <td class="toright_td" width="150px"><font style="color: Red">* </font>排序:&nbsp;&nbsp;</td>
			      <td class="toleft_td">&nbsp;&nbsp;<input style="width:313px;" id="sortCode" type="text" name="homeLBT.sortCode" class="{validate:{required:true,number:true,maxlength:[3]}}"/></td>
		    </tr>
		    <tr>
			      <td class="toright_td" width="150px"><span style="color:red">* </span>是否显示:&nbsp;&nbsp;</td>
				  <td class="toleft_td">&nbsp;&nbsp;
					  <input id="isShow_0"  type="radio" name="homeLBT.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;
					  <input id="isShow_1"  type="radio" name="homeLBT.isShow" value="1"/>显示
				  </td>
		    </tr>
		    <tr>
			      <td class="toright_td" width="150px"><span style="color:red">* </span>显示位置:&nbsp;&nbsp;</td>
				  <td class="toleft_td">&nbsp;&nbsp;
				  	  <input id="showLocation"  type="radio" name="homeLBT.showLocation" checked="checked" value="1"/>首页
				  </td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
  </form>
</div>
