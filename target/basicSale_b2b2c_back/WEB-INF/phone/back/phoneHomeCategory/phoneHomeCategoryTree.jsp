<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>手机首页分类信息</title>
    <jsp:include page="../../../util/import.jsp"/>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}/phone/js/jquery.simple.phoneHomeCategory.tree.js"></script>
    
    <script type="text/javascript">
	    $(function(){
			 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		    	var imageUrl=$("#imageUrl1").val();
		    	if(imageUrl!=null && imageUrl!=''){
		       $(document).ready(
	             function() {  
	                var options = {  
	                	url: "${pageContext.request.contextPath}/back/phoneHomeCategory/saveOrEditPhoneHomeCategory.action",
	                    type : "post",  
	                    dataType:"json",
	                    success : function(data) { 
	                   	 if(data.strFlag==true){
	                       	 closeWin();
	                       	 location.reload();
	                   	 }else{
	                   		msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");  
							 $("input.button_save").attr("disabled",false);
	                   	 }
	                    }
	                };  
	                $("#form1").ajaxSubmit(options);
					 $("input.button_save").attr("disabled","disabled");
	             });
		    	}else{
		    		$("#mymessage1").html("<font color='Red'>请上传图片！</font>");
		    	}
		       }
		    });
		});
        var simpleTreeCollection;
		//var name="";
		var id="";
		$(document).ready(function(){

		simpleTreeCollection = $('.simpleTree').simpleTree({
			autoclose: true,
			afterClick:function(node){
				id=$('span:first',node).attr("pid");
				
			},
			afterDblClick:function(node){
				
			},
			afterMove:function(destination, source, pos){
				
			},
			afterAjax:function()
			{
			},
			animate:true
			//,docToFolderConvert:true
			});
			//获取单个对象，或者：var obj = document.getElementById('2')
			var obj = $("#2")[0];// 2 为需要展开的根目录id
			simpleTreeCollection.each(function(){
				this.nodeToggle(obj);//自动触发展开
			});
		});
		//添加
		function addCategory(id){
			//准备初始数据 ,父亲分类 
			createWindow(900,"auto","&nbsp;&nbsp;添加手机首页分类","icon-add",false,"addOrEditWin");
			$("#categoryId").val("");	
			$("#parentId").val(id);	
			$("#fileId1").val("");	
			$("#photo1").html("");	
			$("#imageUrl1").val("");	
			$("#mymessage1").html("");
			$("#isShow_1").attr("checked","checked");	
		}
		//编辑
		function editCategory(id){
			$("#fileId1").val("");
			createWindow(900,"auto","&nbsp;&nbsp;修改手机首页分类","icon-add",false,"addOrEditWin"); 
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/phoneHomeCategory/getPhoneHomeCategoryObj.action",
			       data: {id:id},
				   success: function(data){
						$("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
			    	    $("#categoryId").val(data.categoryId);
			    	    $("#parentId").val(data.parentId);
						$("#imageUrl1").val(data.categoryImage);
						$("#categoryName").val(data.categoryName);
						$("#categoryDescription").val(data.categoryDescription);
						$("#sortCode").val(data.sortCode);
						$("#keywords").val(data.keywords);
						$("#isShow_"+data.isShow).attr("checked","checked");
						$("#isLeaf").val(data.isLeaf);
						$("#level").val(data.level);
						$("#moreUrl").val(data.moreUrl);
						$("#moreAppUrl").val(data.moreAppUrl);
						$("#categoryType").val(data.categoryType);
				     }
				});
			
		}
		//删除一个地区
		function delCategory(id){
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
					 $.ajax({
						   type: "POST",
						   dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/phoneHomeCategory/delPhoneHomeCategory.action",
					       data: {id:id},
						   success: function(data){
							   if(data.strFlag==true){
								    location.reload();
							   }
						     }
						});
					}
			});
		}
		
		//查看详情
		function detailCategory(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/phoneHomeCategory/getPhoneHomeCategoryObj.action",
			       data: {id:id},
				   success: function(data){
						createWindow(900,390,"&nbsp;&nbsp;手机首页分类详情","icon-search",false,"detailWin"); 
						$("#dphoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
						$("#dcategoryName").html(data.categoryName);
						$("#dcategoryDescription").html(data.categoryDescription);
						$("#dsortCode").html(data.sortCode);
						$("#dkeywords").html(data.keywords);
						 <s:iterator value="#application.phonekeybook['homeCategory']" var="kb">
						   	if(data.categoryType==<s:property value="#kb.value"/>){
						  		 $("#dcategoryType").html("<s:property value='#kb.name'/>");
						   	}
						 </s:iterator>
						$("#dmoreUrl").html(data.moreUrl);
						$("#dmoreAppUrl").html(data.moreAppUrl);
						if(data.isShow==0){
							$("#disShow").html("否");
						}else{
							$("#disShow").html("是");
						}
				     }
				});
		}
    </script>
</head>
<body>
	<jsp:include page="../../../util/item.jsp"/>
	<div class="main">
		<div class="treeCommonMain">
			<div class="treeCommonBox">
				<ul class="simpleTree">
					<li class="root" id='1' style="margin:  0 0 0 -13px;">
						<ul>
							<li id='2'>
								<span>&nbsp;全部分类</span> 
								<a onclick="addCategory(0)" style="cursor: pointer;" class="folder">
									<img style="vertical-align: top;" src="${fileUrlConfig.sysFileVisitRoot_back}/shop/images/tree/folder_add.png"/>&nbsp;添加
								</a>
								<ul class="ajax">
									<li id='3'>
										{url:${pageContext.request.contextPath}/back/phoneHomeCategory/getNodes.action?parentId=0} 
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
		<!-- 新增分类 -->
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<div id="addOrEditWin">
					<form id="photoForm1" method="post" enctype="multipart/form-data">
					     <table align="center" class="addOrEditTable" width="600px;">
					          <tr>
							      <td class="toright_td" width="140px"><span style="color:red">* </span>图片上传:&nbsp;&nbsp; </td>
							      <td class="toleft_td" style="width:350px;">
							            &nbsp;&nbsp;<input id="fileId1" type="file"  name="imagePath"/>
							            <span id="mymessage1"></span>
							  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_phoneCategory','30px','30px','1')"/>
							  	        <div class="imgMessage">提示：请上传规格宽50px，高50px的图片</div>
							      </td>
							      <td class="toright_td" width="115px">图片预览:&nbsp;&nbsp;</td>
							     <td  class="toleft_td">&nbsp;&nbsp;<span id="photo1"></span></td>
							  </tr> 
						 </table>
				   	</form>
				    <form id="form1"  method="post" action="">
				        <input id="parentId" type="hidden" name="poneHomeCategory.parentId" />
				        <input id="categoryId" type="hidden" name="poneHomeCategory.categoryId"  noclear="true"/>
 						<input id="imageUrl1" type="hidden" name="poneHomeCategory.categoryImage" value=""/>
 						<input id="isLeaf" type="hidden" name="poneHomeCategory.isLeaf" value=""/>
 						<input id="level" type="hidden" name="poneHomeCategory.level" value=""/>
					    <table align="center" class="addOrEditTable" width="600px;">
						    <tr>
						      <td class="toright_td" width="140px"><span style="color:red">* </span>分类名称:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input style="width:140px;" id="categoryName" type="text" name="poneHomeCategory.categoryName" class="{validate:{required:true,maxlength:[50]}}"/></td>
						      <td class="toright_td" width="140px"><span style="color:red">* </span>分类类型:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;
							      <select id="categoryType" name="poneHomeCategory.categoryType">
								      <s:iterator value="#application.phonekeybook['homeCategory']" var="kb">
										<option value="<s:property value='#kb.value'/>"><s:property value="#kb.name"/></option>
									 </s:iterator>
							      </select>
						      </td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="140px"><span style="color:red">* </span>排序:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input style="width:140px;"  id="sortCode" type="text" name="poneHomeCategory.sortCode" class="{validate:{required:true,maxlength:[5],digits:true}}"/></td>
						      <td class="toright_td" width="140px"><span style="color:red">* </span>是否显示:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;
							      <input id="isShow_1"  type="radio" name="poneHomeCategory.isShow" value="1"/>是&nbsp;&nbsp;
							      <input id="isShow_0"  type="radio" name="poneHomeCategory.isShow" value="0"/>否
						      </td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="140px">PC分类（更多）链接:&nbsp;&nbsp;</td>
						      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="width:350px;" id="moreUrl" type="text" name="poneHomeCategory.moreUrl" class="{validate:{maxlength:[250],url:true}}"/>
						      <span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="140px">APP分类（更多）链接:&nbsp;&nbsp;</td>
						      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="width:350px;" id="moreAppUrl" type="text" name="poneHomeCategory.moreAppUrl" class="{validate:{maxlength:[250],url:true}}"/>
						      <span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="140px">分类描述:&nbsp;&nbsp;</td>
						      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="width:350px;" id="categoryDescription" type="text" name="poneHomeCategory.categoryDescription" class="{validate:{maxlength:[150]}}"/></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="140px">SEO关键字:&nbsp;&nbsp;</td>
						      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="width:350px;"  id="keywords" type="text" name="poneHomeCategory.keywords" class="{validate:{maxlength:[150]}}"/></td>
						    </tr>
					    </table>
					    <div class="editButton"  data-options="region:'south',border:false" >
							<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
							<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
						</div>
					</form>
			</div>
			<!-- 详情页 -->
			<jsp:include page="detail.jsp"/>
		</div>
	 </div>
  </body>
</html>
