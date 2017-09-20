<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>数据抓取页面</title>
    <jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
		//数据抓取===================================================begin==================================================
		//导出商品分类及品牌数据excel
		function outExcel(){
			createWindow(700,'auto',"&nbsp;&nbsp;数据导出","icon-save",false,"detailWin"); 
		}
		
		function submitUrl(){
			 $.ajax({
			       type: "POST",dataType: "JSON",
			       url: "${pageContext.request.contextPath}/back/updateInitInformation/outExcel.action",
			       data:{urlPath:$("#urlPath").val()},
			       success: function(data){
			        if(data.success=="true") {
// 			         	msgShow("系统提示", "<p class='tipInfo'>导出成功！</p>", "warning");
						window.location.href="http\://192.168.1.124/zczgFS/zczg/excel/productTypeInfo.xls";
			        }else{
			       	    msgShow("系统提示", "<p class='tipInfo'>导出失败，请重试！</p>", "warning");
			        }
			       }
			   });
		}
		
		//导入商品分类及品牌数据excel
		function leadingExcel(){
			createWindow(700,150,"&nbsp;&nbsp;导入Excel数据","icon-add",false,"addOrEditWin");
		}

		//上传文件
		function uploadExcelFile() {
			$(document).ready(  
	              function() {  
	                   var options = {
	                       url : "${pageContext.request.contextPath}/back/updateInitInformation/uploadExcelFile.action",
	                       type : "post",  
	                       dataType:"json",
	                       success : function(data) {
	                    	   msgShow("系统提示", "<p class='tipInfo'>导入成功！</p>", "warning");
	                       }
	                   };
	                  $("#excelFileForm").ajaxSubmit(options);
	           });  
		}
		//数据抓取===================================================end==================================================
			
	</script>
  </head>
  <body>
 
	  <span class="querybtn"><a href="javascript:outExcel();"  style="width: 300px;color:red;">导出【商品分类及品牌关系】数据</a></span>
	  <br/><br/><br/>
	  <span class="querybtn"><a href="javascript:leadingExcel();" style="width: 300px;color:red;">导入【商品分类及品牌关系】数据</a></span>
	  <br/><br/><br/>
	  <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		 <!-- 导入Excel数据 -->
		 <div id="addOrEditWin">
		 	<form id="excelFileForm" method="post" enctype="multipart/form-data">
		     <table align="center" class="addOrEditTable" width="600px;">
		          <tr>
				      <td class="toright_td" width="150px">导入Excel数据:&nbsp;&nbsp; </td>
				      <td class="toleft_td" width="440px">
				      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
				  	        <input id="buttonId" type="button" value="开始导入数据" onclick="uploadExcelFile()"/>
				      </td>
				  </tr> 
		          <tr>
				      <td class="toright_td" width="150px">是否插入ROOT行”:&nbsp;&nbsp; </td>
				      <td class="toleft_td" width="440px">
				      	<input name="root"  type="radio" value="1" />是
				      	<input name="root"  type="radio" value="0" checked="checked"/>否
				      </td>
				  </tr> 
			 </table>
		   	</form>
		   	<form id="form1"></form>
		 </div>
	 <!-- 导出 -->
	  <div id="detailWin">
        <input id="actorId" type="hidden" name="actor.actorId" value=""/>
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">URL地址:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<input size="50" id="urlPath" type="text" name="urlPath" class="{validate:{required:true}}"/><span id="na"></td>
		    </tr>
	    </table>
	   <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="button" id="save" class="button_save" onclick="submitUrl()"  value="" style="cursor:pointer;"/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	   </div>
  </div>
	  </div>
  </body>
  
</html>
