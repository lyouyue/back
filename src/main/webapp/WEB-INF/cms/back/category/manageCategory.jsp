<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>新闻分类信息</title>
		<jsp:include page="../../../../WEB-INF/util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/manageCategorTtree.js"></script>
		<script type="text/javascript">
		var flag = true;
		var simpleTreeCollection;
		//var name="";
		var id="";
		$(document).ready(function(){

		simpleTreeCollection = $('.simpleTree').simpleTree({
			//autoclose: true,
			autoclose: false,
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
		function addCategory(id){
			//准备初始数据 ,父亲分类 
			$("#btnSubmit").removeAttr("disabled");
			flag=true;
			// false是inline:是否内联
			createWindow(700,"auto","&nbsp;&nbsp;添加新闻分类","icon-add",false,"addOrEditWin");
			$("#detailWin").css("display","none");//隐藏修改窗口
			$("#addOrEditWin").css("display","");
			$("#parentId").val(id);
			
		}
		function editCategory(id){
			$("#btnSubmit").removeAttr("disabled");
			flag=true;
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/category/getCategoryObject.action",
			       data: {categoryId:id},
				   success: function(data){
						// false是inline:是否内联
						createWindow(700,"auto","&nbsp;&nbsp;修改新闻分类","icon-add",false,"addOrEditWin"); 
						$("#detailWin").css("display","none");//隐藏修改窗口
						$("#addOrEditWin").css("display","");
			    	    $("#categoryId").val(data.categoryId);
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
				   url: "${pageContext.request.contextPath}/back/category/delCategory.action",
			       data: {ids:id},
				   success: function(data){
			    	    //strFlag="1"，有文章 。strFlag="2" 可以删除，既是叶子节点也没有文章
			    	    if(data.strFlag=="1"){
			    	    	 msgShow("系统提示", "<p class='tipInfo'>有文章，先删除文章！</p>", "warning");  
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
		//详情
		function getCategory(id){
			flag=true;
			$.ajax({
			   type: "POST",
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/category/getCategoryObject.action",
		       data: {categoryId:id},
			   success: function(data){
					//显示 
					createWindow(700,"auto","&nbsp;&nbsp;分类详情","icon-tip",false,"detailWin");
				    $("#addOrEditWin").css("display","none");
				    $("#detailWin").css("display","");
					$("#dcategoryName").html(data.categoryName);
					$("#dkeywords").html(data.keywords);
					$("#dsortCode").html(data.sortCode);
			     }
			});
		}
		//取消 
		function cancel(){
			 location.reload();
			//$("#addOrEditWin").css("display","none");
		}
		
		//提交 
		function tijiao(){
			$("#btnSubmit").attr("disabled","disabled");//防止重复提交
			var categoryId = $("#categoryId").val();
			var parentId = $("#parentId").val();
			var categoryName = $("#categoryName").val();
			var keywords = $("#keywords").val();
			var sortCode = $("#sortCode").val();
			if(isNaN(sortCode)){
				$("#codeError").html("<front style='color:red'>请输入正整数</front>");
				flag=false;
			}else{
				flag=true;
			}
			var isLeaf = $("#isLeaf").val();
			/**
			*/
			if(flag){
				flag=false;
				$.ajax({
					type: "POST",
					dataType: "JSON",
					url: "${pageContext.request.contextPath}/back/category/saveOrEditCategory.action",
					data: {"categoryId":categoryId,"parentId":parentId,
						"categoryName":categoryName,"keywords":keywords,"sortCode":sortCode,"isLeaf":isLeaf},
					success: function(data){
						location.reload();
						//location.href="${pageContext.request.contextPath}/back/category/getNodes.action?id="+categoryId;
					}
				});
			}
		}
		 
		//获取前台更新初始化信息url
		var prefixUrl='${application.fileUrlConfig.initDatabaseUrl}';
		//更新前台底部新闻信息
		function footArticleFront(){
			var split = prefixUrl.split("@");
			var url=split[0]+"front/helpCenter/updateInServletContextArticle.action?callback=?";
			$.getJSON(url);
			msgShow("系统提示", "<p class='tipInfo'>新闻初始化信息同步成功！</p>", "warning");
		}
	</script>
</head>
<body>
	    <jsp:include page="../../../util/item.jsp"/>
		<div class="main">
			<div  class="treeCommonMain">
				<div class="treeCommonBox">
					<ul class="simpleTree">
						<li class="root" id='1' style="margin:0 0 0 -13px;">
							<ul>
								<li id='2'>
									<span> &nbsp;新闻分类 </span> 
								    <a  onclick="addCategory(0)" style="cursor: pointer;" class="folder">
								        <img style="vertical-align: top;" src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/tree/folder_add.png"/>&nbsp;添加
									</a>
									<a style="margin-left: 10px;cursor:hand;" href="javascript:;"  onclick="footArticleFront()"><font color="red">同步新闻分类&nbsp;》</font> </a>
									<ul class="ajax">
										<li id='3'>
											{url:${pageContext.request.contextPath}/back/category/getNodes.action?id=0} 
										</li>
									</ul>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
		  	<!-- 新增分类  -->
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<div id="addOrEditWin">
					    <form id="form1"  method="post" action="">
					        <input id="parentId" type="hidden" name="category.parentId" />
					        <input id="categoryId" type="hidden" name="category.categoryId"  noclear="true"/>
					        <input id="isLeaf" type="hidden" name="category.isLeaf" />
						    <table align="center" class="addOrEditTable" width="600px;">
							    <tr>
							      <td class="toright_td" width="150px"><span style="color:red">* </span>分类名称:&nbsp;&nbsp;</td>
							      <td  class="toleft_td">&nbsp;&nbsp;<input id="categoryName" type="text" name="category.categoryName" class="{validate:{required:true,maxlength:[50]}}"/></td>
							    </tr>
							    <tr>
							      <td class="toright_td" width="150px"><span style="color:red">* </span>分类关键词:&nbsp;&nbsp;</td>
							      <td class="toleft_td">&nbsp;&nbsp;<input id="keywords" type="text" name="category.keywords" class="{validate:{required:true,maxlength:[300]}}"/></td>
							    </tr>
							     
							    <tr>
							      <td class="toright_td" width="150px"><span style="color:red">* </span>分类排序:&nbsp;&nbsp;</td>
							      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="category.sortCode" class="{validate:{required:true,maxlength:[11],digits:true}}"/><span id="codeError"></span></td>
							    </tr>
						    </table>
						    <div class="editButton"  data-options="region:'south',border:false" >
				               <a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" onclick="tijiao()" href="javascript:">保存</a> 
				               <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="cancel()">取消</a>
				            </div>
						</form>
				</div>
			  <!-- 详情页 -->
			  <jsp:include page="detail.jsp"/>
			</div>
		</div>
	</body>
</html>
