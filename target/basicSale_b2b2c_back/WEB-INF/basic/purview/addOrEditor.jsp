<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//初始化权限树信息
	function initPurview(purviewId,parentId,isLeaf){
	   $.ajax({
		   type: "POST",
		   dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/purview/getResetPurviewList.action?purviewId="+purviewId,
		   async: false,
		   success: function(data){
			   var initPurviewSelectStr="<tr id='trId'><td class='toright_td' width='110px'>更换父节点:&nbsp;&nbsp;</td><td class='toleft_td'>&nbsp;&nbsp;<select  name='selectParentId' id='selectParentId' style='width:180px;' onchange='resetParentId(this.value)'></select></td></tr>";
			   $("#trId").remove();//清除之前加载的html片段
			   $("#addTable").append(initPurviewSelectStr);
			   var initPurviewStr="<option value='-1'>--请选择权限--</option>";
			   for(var i=0;i<data.length;i++){
				   if(data[i].purviewId==1){//系统权限
					   if(parentId==data[i].purviewId){
						   initPurviewStr+="<option value='"+data[i].purviewId+"_"+data[i].isLeaf+"' style='font-weight:bold;margin-left:15px;' selected='selected'>"+data[i].purviewName+"</option>";
					   }else{
						   initPurviewStr+="<option value='"+data[i].purviewId+"_"+data[i].isLeaf+"' style='font-weight:bold;margin-left:15px;'>"+data[i].purviewName+"</option>";
					   }
				   }else{
					   if(data[i].levelCode==1){//一级权限
						   if(parentId==data[i].purviewId){
							   initPurviewStr+="<option value='"+data[i].purviewId+"_"+data[i].isLeaf+"' style='font-weight:bold;margin-left:15px;' selected='selected'>&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].purviewName+"</option>";
						   }else{
							   initPurviewStr+="<option value='"+data[i].purviewId+"_"+data[i].isLeaf+"' style='font-weight:bold;margin-left:15px;'>&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].purviewName+"</option>";
						   }
					   }else{//二级权限
						   if(parentId==data[i].purviewId){
						   	   initPurviewStr+="<option value='"+data[i].purviewId+"_"+data[i].isLeaf+"' style='margin-left:25px;' selected='selected'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].purviewName+"</option>";
						   }else{
						   	   initPurviewStr+="<option value='"+data[i].purviewId+"_"+data[i].isLeaf+"' style='margin-left:25px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[i].purviewName+"</option>";
						   }
					   }
				   }
			   }
			   $("#selectParentId").html(initPurviewStr);
		   }
		});
	}
	//重置父节点Id
	function resetParentId(value){
		var strs= new Array(); 
		strs = value.split("_");
		if(strs[0]!=-1){
			$("#parentId").val(strs[0]);
		}
	}
</script>

 <div id="addOrEditWin" >
 	<form id="photoForm1" method="post" enctype="multipart/form-data">
	     <table align="center" class="addOrEditTable" width="600px;">
	          <tr>
			      <td class="toright_td" width="120px"><font style="color: Red">* </font>权限图标:&nbsp;&nbsp; </td>
			      <td class="toleft_td"  width="328px">&nbsp;
			      <input id="fileId1" type="file" name="imagePath" style="width:143px;"/>
			            <span id="mymessage1"></span>
			  	        <input id="buttonId1"  type="button" value="上传预览" onclick="uploadPhoto('image_purview','30px','30px','1')"/>
			  	        <div class="imgMessage">提示：请上传规格宽36px，高36px的图片</div>
			      </td>
			      <td class="toright_td" width="75px">图片预览 :&nbsp;&nbsp;</td>
		     	  <td  class="toleft_td" width="192px">&nbsp;&nbsp;<span id="photo1"></span></td>
			  </tr> 
		 </table>
   	</form>
   	
    <form id="form1"  method="post" action="">
        <input id="parentId" type="hidden" name="purview.parentId" value=""/>
        <input id="oldParentId" type="hidden" name="oldParentId" value=""/>
        <input id="purviewId" type="hidden" name="purview.purviewId" value="" noclear="true"/>
        <input id="isLeaf" type="hidden" name="purview.isLeaf" value=""/>
        <input id="imageUrl1" type="hidden" name="purview.iconUrl" >
	    <table align="center" class="addOrEditTable" width="600px;" id="addTable">
		    <tr>
		      <td class="toright_td" width="110px"><font style="color: Red">* </font>权限名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input style="width:180px;" id="purviewName" type="text" name="purview.purviewName" value="" class="{validate:{required:true,maxlength:[25]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="110px"><font style="color: Red">* </font>权限路径:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:180px;" id="url" type="text" name="purview.url" value="" class="{validate:{required:true,maxlength:[500]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="110px"><font style="color: Red">* </font>排序:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:180px;" id="sortCode" type="text" name="purview.sortCode" value="" class="{validate:{required:true,number:true,maxlength:[8]}}"/></td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    </div>
	</form>
 </div>
