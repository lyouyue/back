<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<title>分类维护</title>
		<jsp:include page="../../../../WEB-INF/util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/infoCategorTtree.js"></script>
		<script type="text/javascript">
		
		var simpleTreeCollection;
		//var name="";
		var id="";
		$(document).ready(function(){
			//表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/cmsInformationCategory/saveOrEditCmsInformationCategory.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 location.reload();
                         }
                     };  
                     $("#form1").ajaxSubmit(options); 
                     $("input.button_save").attr("disabled","disabled");//防止重复提交
                  });
		       }
		    });
			
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
		//添加分类
		function addCategory(id){
			//准备初始数据 ,父亲分类 
			createWindow(700,"auto","&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
			$("input.button_save").removeAttr("disabled");
			$("#parentId").val(id);
			$("#isLeaf").val(1);
		}
		//修改分类
		function editCategory(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/cmsInformationCategory/getCmsInformationCategoryObject.action",
			       data: {informationCategoryId:id},
				   success: function(data){
						createWindow(700,"auto","&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
						$("input.button_save").removeAttr("disabled");
			    	    $("#informationCategoryId").val(data.informationCategoryId);
						$("#parentId").val(data.parentId);
						$("#categoryName").val(data.categoryName);
						$("#keywords").val(data.keywords);
						$("#sortCode").val(data.sortCode);
						$("#isLeaf").val(data.isLeaf);
				     }
			});
		}
		//删除一个分类 
		function deleteCategory(id){
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
				 $.ajax({
					   type: "POST",
					   dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/cmsInformationCategory/delCmsInformationCategory.action",
				       data: {ids:id},
					   success: function(data){
				    	    //strFlag="1"，有信息 。strFlag="2" 可以删除，既是叶子节点也没有信息
				    	    if(data.strFlag=="1"){
				    	    	 msgShow("系统提示", "<p class='tipInfo'>有信息，先删除信息！</p>", "warning");  
				    	     }
				    	    if(data.strFlag=="2"){
				    	    	 msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
				    	    	 location.reload();
				    	     }
					     }
						});
				}
			});
		}
		
		//提交 
		function tijiao(){
			$("#form1").submit();
		}
		//同步新闻分类到前台
		function updateNewsTypeToFront(){
			$.messager.confirm("系统提示", "<p class='tipInfo'>确定同步新闻分类到系统内存中吗?</p>",function(data){
				if(data){//判断是否删除
					var address = "";
					$.ajax({
						url:"${pageContext.request.contextPath}/back/update/getTomcatAddress.action",
						type:"post",
						dataType:"text",
						success:function(data){
							/* msgShow("系统提示", "<p class='tipInfo'>【新闻】初始化信息同步中......</p>", "warning"); */
							address = data;
							var attr = new Array();
							attr= address.split(";");
							for (var i=0; i<attr.length; i++) {
								if($.trim(attr[i])!=""&&$.trim(attr[i])!=null){
								var url= "http://"+attr[i] + "/back/update/updateInServletContextArticle.action?callback=?";
								$.getJSON(url);
								}
							}
							/* setTimeout(function(){
								msgShow("系统提示", "<p class='tipInfo'>【新闻】初始化信息同步成功！</p>", "warning");
						    },1000); */
						}
					});
				}
			});
		}
	</script>
	</head>
	<body>
	<div style="width: 99%">
		<div style="float: left; padding-left: 20px;width: 100%;overflow-y:scroll;overflow-x:auto;height: 100%;">
					<ul class="simpleTree">
						<li class="root" id='1'>
							<ul>
								<li id='2'>
									<span>&nbsp;信息分类</span> 
								    <a onclick="addCategory(0)" style="cursor: pointer;" class="folder">
								    	&nbsp;&nbsp;<img style="vertical-align: top;margin-right:5px;" src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/tree/folder_add.png"/>&nbsp;添加
								    </a> 
<!-- 								     <a onclick="updateNewsTypeToFront()" style="cursor: pointer;color:red;"><img style="vertical-align: top;margin-right:5px;" src="${pageContext.request.contextPath}/common/back/images/tree/arrow_refresh.png"/>同步信息分类到前台</a> -->
									<ul class="ajax">
										<li id='3'>
											{url:${pageContext.request.contextPath}/back/cmsInformationCategory/getNodes.action?id=0} 
										</li>
									</ul>
								</li>
							</ul>
						</li>
					</ul>
		</div>
  <!-- 新增分类  -->
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
			  <div id="addOrEditWin" style="">
				    <form id="form1"  method="post" action="">
				        <input id="parentId" type="hidden" name="cmsInformationCategory.parentId" />
				        <input id="informationCategoryId" type="hidden" name="cmsInformationCategory.informationCategoryId"  noclear="true"/>
				        <input id="isLeaf" type="hidden" name="cmsInformationCategory.isLeaf" />
					    <table align="center" class="addOrEditTable" width="600px;">
						    <tr>
						      <td class="toright_td" width="150px">分类名称:&nbsp;&nbsp;</td>
						      <td  class="toleft_td">&nbsp;&nbsp;<input id="categoryName" type="text" name="cmsInformationCategory.categoryName" class="{validate:{required:true,maxlength:[50]}}"/></td>
						    </tr>
						    <tr>
						      <td class="toright_td" width="150px">分类关键词:&nbsp;&nbsp;</td>
						      <td class="toleft_td">&nbsp;&nbsp;<input id="keywords" type="text" name="cmsInformationCategory.keywords" class="{validate:{required:true,maxlength:[100]}}"/></td>
						    </tr>
						     
						    <tr>
						      <td class="toright_td" width="150px">分类排序:&nbsp;&nbsp;</td>
						      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="cmsInformationCategory.sortCode" class="{validate:{required:true,number:true}}"/></td>
						    </tr>
					    </table>
					    <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
				           <a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" onclick="tijiao()">保存</a> 
				           <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()">取消</a>
				        </div>
					</form>
			  </div>
		 </div> 
	</div>
	</body>
</html>
