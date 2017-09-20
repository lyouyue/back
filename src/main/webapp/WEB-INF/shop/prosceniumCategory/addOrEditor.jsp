<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/prosceniumCategory/saveOrUpdateProsceniumCategory.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 $("#prosceniumCategoryId").val(null);
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     $("input.button_save").attr("disabled","disabled");
                  });
		       }
		    });
  })
  
   //上传图片 
	function uploadPhoto() {
		$(document).ready(  
              function() {  
                   var options = {  
                       url : "${pageContext.request.contextPath}/back/prosceniumCategory/uploadImage.action",
                       type : "post",  
                       dataType:"json",
                       success : function(data) {
                        if(data.photoUrl=="false1"){
                          $("#mymessage").html(" <font style='color:red'>请选择上传图片</font>");
                        }else if(data.photoUrl=="false2"){
                          $("#mymessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
                        }else{
                         $("#prosceniumCategoryUrl").val(data.photoUrl);
                         $("#photo").html("");
                       	 $("#photo").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='120px' height='120px' />");
                        } 
                       }
                   };
                  $("#photoForm").ajaxSubmit(options);
           });  
	}
  
//套餐分类的二级
	 function getSecondProdType(){
		var parentId="";
		parentId=$("#productTypeId").val();
		$.ajax({
			url:"${pageContext.request.contextPath}/back/prosceniumCategory/findProductType.action",
			type:"post",
			dataType:"json",
			data:{parentId:parentId},
			success:function(data){
				var secondList=data;
				if(secondList.length>0){
	   				var htmlStr="&nbsp;&nbsp;<select id='secondProdTypeId' name='prosceniumCategory.secondProductTypeId' >";
	   				htmlStr+="<option>---请选择---</option>";
	   				for(i=0;i<secondList.length;i++){
	   					htmlStr+="<option  value='"+secondList[i].productTypeId+"'>"+secondList[i].sortName+"</option>"
	   				}
		            htmlStr+="</select> <span id='thirdListHtml'></span>"
		            $("#secondListHtml").html(htmlStr);
		         }
			}
		});
	}
</script>
<div id="addOrEditWin">
	<form id="photoForm" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="700px;">
          <tr>
		      <td class="toright_td" width="150px">分类图片:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="470px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
		            <span id="mymessage"></span>
		  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto()"/>
		  	        <span><font color="red">提示：请上传185*185像素的图片</font></span>
		      </td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="prosceniumCategoryId" type="hidden" name="prosceniumCategory.prosceniumCategoryId" value="">
        <input id="prosceniumCategoryUrl" type="hidden" name="prosceniumCategory.prosceniumCategoryUrl" value="">
<%--        <input id="productTypeName" type="hidden" name="prosceniumCategory.productTypeName" value="">--%>
<%--        <input id="secondProductTypeName" type="hidden" name="prosceniumCategory.secondProductTypeName" value="">--%>
<%--        <input id="upproductTypeId" type="hidden" name="prosceniumCategory.productTypeId" value="">--%>
<%--        <input id="secondProductTypeId" type="hidden" name="prosceniumCategory.secondProductTypeId" value="">--%>
	    <table align="center" class="addOrEditTable" width="700px;">
	    	<tr>
		      <td class="toright_td" width="150px">图片预览:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="470px">&nbsp;&nbsp;<span id="photo"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐分类:</td>
		      <td>
		      	<span id="firstListHtml"></span>&nbsp;&nbsp;
		      	<select id="productTypeId" name="prosceniumCategory.productTypeId" onchange="getSecondProdType();">
	      			<option value="-1">---请选择---</option>
		      		<s:iterator value="productTypeList" var="pt">
		      			<option value="<s:property value='#pt.productTypeId'/>"><s:property value="#pt.sortName"/></option>
		      		</s:iterator>
		      	</select>
		      	<span id="secondListHtml"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">标题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="title" type="text" name="prosceniumCategory.title" class="{validate:{required:true,maxlength:[25]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">简介:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="synopsis" type="text" name="prosceniumCategory.synopsis" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">链接:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="interlinkage" type="text" name="prosceniumCategory.interlinkage" class="{validate:{required:true,maxlength:[250],url:true}}"/><span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">排序号:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="prosceniumCategory.sortCode" class="{validate:{required:true,maxlength:[4]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否显示:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="isShow_1" type="radio" name="prosceniumCategory.isShow" checked="checked" value="1"/>显示&nbsp;&nbsp;&nbsp;<input id="isShow_0" type="radio" name="prosceniumCategory.isShow" value="0"/>不显示</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""  style="cursor:pointer;"/>&nbsp;
	</div>
  </form>
</div>
