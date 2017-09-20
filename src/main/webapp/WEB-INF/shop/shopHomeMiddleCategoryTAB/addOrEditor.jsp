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
                    url : "${pageContext.request.contextPath}/back/shopHomeMiddleCategoryTAB/saveOrUpdateShopHomeMiddleCategoryTAB.action",  
                    type : "post",  
                    dataType:"json",
                    success : function(data) { 
                    	if(data.strFlag==true){
		                   	 closeWin();
		                   	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
		                   	 queryParams={pageSize:pageSize,currentPage:currentPage,title:$("#title1").val(),isShow:$("#isShow").val(),imageType:$("#imageType").val()};
		            	  	 $("#tt").datagrid("load",queryParams); 
							 $("#categoryTabId").val(null);
                    	}
                    }
                };  
                $("#form1").ajaxSubmit(options);
                $("input.button_save").attr("disabled","disabled");//防止重复提交
               /*  var img=$("#imageUrl").val();
                if(img!=""){
                }else{
                	 $("#mymessage").html(" <font style='color:red'>请选择上传图片</font>");
                } */
             });
       }
    });
  })
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="700px;">
          <tr>
		      <td class="toright_td" width="150px">图片:</td>
		      <td class="toleft_td">
		      <input id="fileId1" type="file"  name="imagePath"/>
		           <span id="mymessage1"></span>
		  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_homeMiddleCategoryBilateral','120px','120px','1')"/>
		      </td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="categoryTabId" type="hidden" name="shopHomeMiddleCategoryTAB.categoryTabId" value="">
        <input id="imageUrl1" type="hidden" name="shopHomeMiddleCategoryTAB.imageUrl" value="">
        <input id="categoryId" type="hidden" name="shopHomeMiddleCategoryTAB.categoryId" value="">
        <input id="createTime" type="hidden" name="shopHomeMiddleCategoryTAB.createTime" value="">
        <input id="publishUser" type="hidden" name="shopHomeMiddleCategoryTAB.publishUser" value="">
        
	    <table align="center" class="addOrEditTable" width="700px;">
	    	<tr>
		      <td class="toright_td" width="150px">图片预览:</td>
		      <td  class="toleft_td"><span id="photo1"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">图片类型:</td>
		      <td class="toleft_td">
		      		<s:iterator value="#application.homekeybook['middleTAB']" var="kb">
						<input type="radio" id="imageType_<s:property value="#kb.value"/>" name="shopHomeMiddleCategoryTAB.imageType" value="<s:property value="#kb.value"/>"/><s:property value="#kb.name"/>&nbsp;&nbsp;
					 </s:iterator>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">标题:</td>
		      <td class="toleft_td">
		      <input id="title" type="text" style="width:230px;" name="shopHomeMiddleCategoryTAB.title" value="" class="{validate:{required:true,maxlength:[25]}}"/>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">描述:</td>
		      <td class="toleft_td"><input id="synopsis" type="text" style="width:230px;" name="shopHomeMiddleCategoryTAB.synopsis" value="" class="{validate:{maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">链接:</td>
		      <td class="toleft_td"><input id="link" type="text" style="width:230px;" name="shopHomeMiddleCategoryTAB.link" value="" class="{validate:{required:true,maxlength:[500],url:true}}"/>
		      <span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否显示:</td>
		      <td class="toleft_td">
			      <input id="isShow_1" type="radio" name="shopHomeMiddleCategoryTAB.isShow" value="1"/>是&nbsp;&nbsp;
			      <input id="isShow_0" type="radio" name="shopHomeMiddleCategoryTAB.isShow" value="0"/>否
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">排序号:</td>
		      <td class="toleft_td"><input id="sortCode" type="text" style="width:50px;" maxlength="3" value="" name="shopHomeMiddleCategoryTAB.sortCode" class="{validate:{required:true,number:true,maxlength:[2],digits:true}}"/></td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
