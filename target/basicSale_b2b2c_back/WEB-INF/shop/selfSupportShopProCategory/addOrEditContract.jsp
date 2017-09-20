<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
  	<script type="text/javascript">
	$("#org").change(function(){
		$("#usersId").val($(this).val());
		$("#usersName").val($("#opt_"+$(this).val()).text());
	});
	
	 $(function(){//修改
		  	$("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		    	   var imageUrl=$("#imageUrl1").val();
		    	   if(imageUrl!=null && imageUrl!=''){
			               var options = {
		                     url : "${pageContext.request.contextPath}/back/selfSupportShopProCategory/saveOrUpdateShopOriCategory.action",
		                     type: "POST",
		                     dataType: "JSON",
		                     success : function(data) { 
		                    	 closeWin();
		                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 	 $("#tt").datagrid("reload"); //保存后重新加载列表
							 	 $("#wshopInfoId").val(null);
			                 }};
			              $("#form1").ajaxSubmit(options);  
			              $("input.button_save").attr("disabled","disabled");//防止重复提交
		       }else{
		    	   $("#mymessage1").html(" <font style='color:red'>请上传分类图片</font>");
		       }
		       }
		    });
		  });
				</script>
  <div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
		<table align="center" class="addOrEditTable" width="800px;">
			<tr>
				<td class="toright_td" width="150px"><font style="color: Red">* </font>分类图片:&nbsp;&nbsp; </td>
				<td class="toleft_td" width="440px">
					&nbsp;&nbsp;
					<input id="fileId1" type="file"  name="imagePath" />
					<%-- <span id="ucategory"></span> --%>
					<span id="mymessage1"></span>
					<input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_shopInfo','129px','50px','1')"/> 
					<!-- <font color="red">&nbsp;&nbsp;推荐尺寸129*50</font> -->
					<div class="imgMessage">提示：请上传规格宽129px，高50px的图片</div>
				</td>
				<td class="toright_td" width="150px">分类图片预览:&nbsp;&nbsp;</td>
				<td  class="toleft_td" width="170px">&nbsp;&nbsp;<span id="photo1"></span></td>
			</tr> 
		</table>
	</form>
  
    <form id="form1" method="post" action="" >
    	<input id="ushopProCategoryId" type="hidden" name="shopProCategory.shopProCategoryId" value="">
    	<input id="ushopInfoId" type="hidden" name="shopProCategory.shopInfoId" value="">
    	<input id="imageUrl1" type="hidden" name="shopProCategory.categoryImage" value="">
	    <table align="center" class="addOrEditTable" width="800px;">
		    <tr>
		      <td class="toright_td" width="135px"><font style="color: Red">* </font>排序:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		       <input id="usortCode" type="text" name="shopProCategory.sortCode" style="width:150px;" class="{validate:{required:true}}">
		      </td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="135px"><font style="color: Red">* </font>是否显示:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
					<input id="uisShow_0" type="radio" name="shopProCategory.isShow"  value="0" checked="checked"/>否
					<input id="uisShow_1" type="radio" name="shopProCategory.isShow"  value="1"/>是
		    </tr>
		    <s:property value="#shopProCategory.isShow" />
			<tr>
		      <td class="toright_td" width="135px"><font style="color: Red">* </font>分类名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	 <input id="ushopProCategoryName" type="text" name="shopProCategory.shopProCategoryName" style="width:150px;" class="{validate:{required:true}}"> 
		      </td>
		    </tr>
			<tr>
		      <td class="toright_td" width="135px"><font style="color: Red">* </font>分类描述:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	 <input id="ucategoryDescription" type="text" name="shopProCategory.categoryDescription" style="width:150px;" class="{validate:{required:true}}" > 
		      </td>
		    </tr>
	    </table>
	 	<div class="editButton"  data-options="region:'south',border:false" >
	    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    </div>
	</form>
  </div>