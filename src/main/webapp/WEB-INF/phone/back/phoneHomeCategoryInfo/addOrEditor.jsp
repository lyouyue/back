<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	//表单验证
    $("#form1").validate({meta: "validate", 
       submitHandler:function(form){
   	   var imageUrl=$("#imageUrl1").val();
   	   if(imageUrl!=null && imageUrl!=''){
       $(document).ready(
             function() {  
                var options = {  
                    url : "${pageContext.request.contextPath}/back/phoneHomeCategoryInfo/saveOrUpdatePhoneHomeCategoryInfo.action",  
                    type : "post",  
                    dataType:"json",
                    success : function(data) { 
                    	if(data.strFlag==true){
		                   	 closeWin();
		                   	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 $("#categoryInfoId").val(null);
                    	}
                    }
                };  
                $("#form1").ajaxSubmit(options);
				 $("input.button_save").attr("disabled","disabled");
                /* var img=$("#imageUrl").val();
                if(img!=""){
                }else{
                	 $("#mymessage").html(" <font style='color:red'>请选择上传图片</font>");
                } */
             });
   	   }else{
   			$("#mymessage1").html("<font color='Red'>请上传图片！</font>");
   	   }
       }
    });
  })
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
	    <table align="center" class="addOrEditTable" width="730px;">
	  		<!--   <tr>
			      <td class="toleft_td" colspan="2">
			      		<font color="red">图片大小说明:</font>&nbsp;&nbsp;
				      	<font color="red">三图布局:左侧大图320*356,右侧小图320*173</font>&nbsp;&nbsp;
				      	<font color="red">四图布局:320*173</font>&nbsp;&nbsp;
				      	<font color="red">轮播图:480*180</font>
			      </td>
			  </tr> -->
	          <tr>
			      <td class="toright_td" width="122px"><span style="color:red">* </span>图片:</td>
			      <td class="toleft_td" width="440px">
			      &nbsp;&nbsp;<input id="fileId1" type="file"  name="imagePath"/>
			            <span id="mymessage1"></span>
			  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_phoneCategoryInfo','30px','30px','1')"/>
			  	        <div class="imgMessage">提示：请上传规格宽60px，高60px的图片</div>
			      </td>
			  </tr> 
		</table>
   	</form>
    <form id="form1"  method="post">
        <input id="categoryInfoId" type="hidden" name="phoneHomeCategoryInfo.categoryInfoId" value="" noclear="true">
        <input id="imageUrl1" type="hidden" name="phoneHomeCategoryInfo.imageUrl" value="">
        <input id="categoryId" type="hidden" name="phoneHomeCategoryInfo.categoryId" value="" noclear="true">
        <input id="createTime" type="hidden" name="phoneHomeCategoryInfo.createTime" value="">
        <input id="publishUser" type="hidden" name="phoneHomeCategoryInfo.publishUser" value="">
	    <table align="center" class="addOrEditTable" width="700px;">
	    	<tr>
		      <td class="toright_td" width="150px">图片预览:</td>
		      <td  class="toleft_td"><span id="photo1"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>标题:</td>
		      <td class="toleft_td">
		      &nbsp;&nbsp;<input id="title" type="text" style="width:230px;" name="phoneHomeCategoryInfo.title" value="" class="{validate:{required:true,maxlength:[25]}}"/>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">描述:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="synopsis" type="text" style="width:230px;" name="phoneHomeCategoryInfo.synopsis" value="" class="{validate:{maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>链接:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="link" type="text" style="width:230px;" name="phoneHomeCategoryInfo.link" value="" class="{validate:{required:true,maxlength:[500],url:true}}"/>
		      <span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>App链接:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="appLink" type="text" style="width:230px;" name="phoneHomeCategoryInfo.appLink" value="" class="{validate:{required:true,maxlength:[500],url:true}}"/>
		      <span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>排序号:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" style="width:230px;" maxlength="3" value="" name="phoneHomeCategoryInfo.sortCode" class="{validate:{required:true,digits:true,maxlength:[2]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否显示:</td>
		      <td class="toleft_td">
			      &nbsp;<input id="isShow_1"  type="radio" name="phoneHomeCategoryInfo.isShow" value="1"/>是&nbsp;&nbsp;
			      <input id="isShow_0"  type="radio" name="phoneHomeCategoryInfo.isShow" value="0"/>否
		      </td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
