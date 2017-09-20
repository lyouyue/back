<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>首页楼层分类信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.shopHomeMiddleCategory.tree.js"></script>
    
    <script type="text/javascript">
	    $(function(){
			 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		    	   var imageUrl=$("#imageUrl1").val();
		    	   if(imageUrl != null && imageUrl!=''){
		       $(document).ready(
	             function() {  
	                var options = {  
	                	url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategory/saveOrEditShopHomeMiddleCategory.action",
	                    type : "post",  
	                    dataType:"json",
	                    success : function(data) { 
	                   	 if(data.strFlag==true){
	                       	 closeWin();
	                       	 location.reload();
	                   	 }else
	                   	msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");  
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
			createWindow(900,"auto","&nbsp;&nbsp;添加首页楼层分类","icon-add",false,"addOrEditWin",20);
			$("#categoryId").val("");	
			$("#photo1").html("");	
			$("#fileId1").val("");	
			$("#imageUrl1").val("");	
			$("#parentId").val(id);	
			$("#isShow_1").attr("checked","checked");	
			$("#mymessage1").html("");
		}
		//编辑
		function editCategory(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategory/getShopHomeMiddleCategoryObj.action",
			       data: {id:id},
				   success: function(data){
					   $("#fileId1").val("");	
					   createWindow(900,470,"&nbsp;&nbsp;修改首页楼层分类","icon-add",false,"addOrEditWin",20); 
						$("#photo1").html("<img style='padding-top:10px;' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' width='100px' height='50px' />");
			    	    $("#categoryId").val(data.categoryId);
			    	    $("#parentId").val(data.parentId);
						$("#imageUrl1").val(data.categoryImage);
						$("#categoryName").val(data.categoryName);
						$("#categoryDescription").val(data.categoryDescription);
						$("#link").val(data.link);
						$("#sortCode").val(data.sortCode);
						$("#keywords").val(data.keywords);
						$("#isShow_"+data.isShow).attr("checked","checked");
						$("#isLeaf").val(data.isLeaf);
						$("#level").val(data.level);
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
						   url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategory/delShopHomeMiddleCategory.action",
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
				   url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategory/getShopHomeMiddleCategoryObj.action",
			       data: {id:id},
				   success: function(data){
						createWindow(900,470,"&nbsp;&nbsp;首页楼层分类详情","icon-search",false,"detailWin",20); 
						$("#dphoto").html("<img style='padding-top:10px;' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' width='120px' height='120px' />");
						$("#dcategoryName").html(data.categoryName);
						$("#dcategoryDescription").html(data.categoryDescription);
						$("#dlink").html(data.link);
						$("#dsortCode").html(data.sortCode);
						$("#dkeywords").html(data.keywords);
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
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<div class="treeCommonMain">
			<div class="treeCommonBox">
				<ul class="simpleTree">
					<li class="root" id='1' style="margin:  0 0 0 -13px;">
						<ul>
							<li id='2'>
								<span> &nbsp;&nbsp;全部楼层分类</span> 
								<a onclick="addCategory(0)" style="cursor: pointer;" class="folder">
									&nbsp;&nbsp;<img style="vertical-align: top;" src="${fileUrlConfig.sysFileVisitRoot_back}shop/images/tree/folder_add.png"/>&nbsp;添加
								</a>
								<ul class="ajax">
									<li id='3'>
										{url:${pageContext.request.contextPath}/back/shopHomeMiddleCategory/getNodes.action?parentId=0} 
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
						      <td class="toright_td" width="105px"><span style="color:red">* </span>图片上传:&nbsp;&nbsp; </td>
						      <td class="toleft_td" width="450px">
						      &nbsp;&nbsp;<input id="fileId1" type="file"  name="imagePath"/>
						            <span id="mymessage1"></span>
						  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_homeMiddleCategory','100px','40px','1')"/>
						  	        <div class="imgMessage">提示：请上传规格宽60px，高60px的图片</div>
						      </td>
						  </tr> 
					 </table>
				   	</form>
				    <form id="form1"  method="post" action="">
				        <input id="parentId" type="hidden" name="shopHomeMiddleCategory.parentId" />
				        <input id="categoryId" type="hidden" name="shopHomeMiddleCategory.categoryId" />
 						<input id="imageUrl1" type="hidden" name="shopHomeMiddleCategory.categoryImage" value=""/>
 						<input id="isLeaf" type="hidden" name="shopHomeMiddleCategory.isLeaf" value=""/>
 						<input id="level" type="hidden" name="shopHomeMiddleCategory.level" value=""/>
 						
						<table align="center" class="addOrEditTable" width="600px;">
							<tr>
							<td class="toright_td" width="150px">图片预览:&nbsp;&nbsp;</td>
							<td  class="toleft_td">&nbsp;&nbsp;<span id="photo1"></span></td>
							</tr>
						    <tr>
						      <td class="toright_td" width="150px"><span style="color:red">* </span>分类名称:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input id="categoryName" style="width:230px;" type="text" name="shopHomeMiddleCategory.categoryName" class="{validate:{required:true,maxlength:[50]}}"/></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="150px">分类描述:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input id="categoryDescription" style="width:230px;" type="text" name="shopHomeMiddleCategory.categoryDescription" class="{validate:{maxlength:[150]}}"/></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="150px"><span style="color:red">* </span>分类链接:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input style="width:230px;"  id="link" type="text" name="shopHomeMiddleCategory.link" class="{validate:{required:true,maxlength:[500],url:true}}"/>
						      <span><font color="red">提示：请添加链接前缀，如http://</font></span></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="150px"><span style="color:red">* </span>排序:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input style="width:230px;" id="sortCode" type="text" name="shopHomeMiddleCategory.sortCode" class="{validate:{required:true,maxlength:[5],digits:true}}"/></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="150px">SEO关键字:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input style="width:230px;" id="keywords" type="text" name="shopHomeMiddleCategory.keywords" class="{validate:{maxlength:[150]}}"/></td>
						    </tr>
							<tr>
								<td class="toright_td" width="150px"><span style="color:red">* </span>是否显示:&nbsp;&nbsp;</td>
								<td  class="toleft_td">&nbsp;&nbsp;
									<input id="isShow_1" type="radio" name="shopHomeMiddleCategory.isShow" value="1"/>是&nbsp;&nbsp;
									<input id="isShow_0" type="radio" name="shopHomeMiddleCategory.isShow" value="0"/>否
								</td>
							</tr>
						</table>
						<div class="editButton"  data-options="region:'south',border:false" >
							<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
							<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			            </div>
					</form>
			  </div>
			  
 			<!-- 详情 -->
			<jsp:include page="detail.jsp"/>			
		</div>
		</div>
  </body>
</html>
