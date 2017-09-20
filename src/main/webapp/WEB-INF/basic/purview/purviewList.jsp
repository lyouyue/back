<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>权限信息</title>
		<jsp:include page="../../util/import.jsp"/>
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/jquery.simple.purview.tree.js"></script>
		<script type="text/javascript">
		var simpleTreeCollection;
		//var name="";
		var id="";
		$(document).ready(function(){
			simpleTreeCollection = $(".simpleTree").simpleTree({
				//autoclose: true,
				//是否自动收起
				autoclose: true,
				afterClick:function(node){
					//name=('span:first',node).text();
					id=$("span:first",node).attr("pid");
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
		 $(function(){
			 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		    	   var imageUrl=$("#imageUrl1").val();
		    	   if(imageUrl!= null && imageUrl!=''){
				       $(document).ready(
			              function() {  
		                     var options = {  
		                         url : "${pageContext.request.contextPath}/back/purview/saveOrUpdatePurview.action",  
		                         type : "post",  
		                         dataType:"json",
		                         success : function(data) { 
		                        	closeWin();
		                        	//msgShow("系统提示", "<p class='tipInfo'>保存成功！</p>", "info");
		                        	location.reload();
		                         }
		                     };  
		                     $("#form1").ajaxSubmit(options);  
		                     $("input.button_save").attr("disabled","disabled");//防止重复提交
		                  });
			       }else{
			    	   $("#mymessage1").html(" <font style='color:red'>请上传图片</font>");
	       			}
		       }
		    });
		});
		
		function addPurview(id){
			//准备初始数据 ,父亲分类 
			createWindow(800,"auto","&nbsp;&nbsp;添加权限","icon-add",false,"addOrEditWin");
			var number = document.all.addTable.rows.length;
			if(number==4){
				$("#trId").remove();
			}
			$("#fileId1").val("");
			$("#photo1").html("");
			$("#addOrEditWin").css("display","");
			$("#detailWin").css("display","none");//隐藏修改窗口
			$("#managerFunctionsWin").css("display","none");//隐藏修改窗口
			$("#parentId").val(id);
			$("#purviewId").val("");
			$("#imageUrl1").val("");
			$("#mymessage1").html("");
		}
		
		//详情
		function getPurviewInfo(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/purview/getPurviewObject.action",
			       data: {purviewId:id},
				   success: function(data){
						//显示 
						createWindow(700,"auto","&nbsp;&nbsp;权限详情","icon-tip",false,"detailWin");
					    $("#addOrEditWin").css("display","none");
					    $("#managerFunctionsWin").css("display","none");
					    $("#dpurviewName").html(data.purviewName);
						$("#durl").html(data.url);
						$("#dsortCode").html(data.sortCode);
				     }
				});
		}
		
		//删除一个分类 
		function deletePurview(id){
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
			 		$.ajax({
					   type: "POST",
					   dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/purview/delPurview.action",
				       data: {ids:id},
					   success: function(data){
				    	     if(data.isSuccess=="true"){
				    	    	 msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
				    	    	 location.reload();
				    	     }else{
				    	    	 msgShow("系统提示", "<p class='tipInfo'>此分类下面还有子分类，请先删除子分类！</p>", "warning");
				    	     }
					     }
					});
				}
			});
		}
		
		//编辑
		function editPurview(purviewId){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/purview/getPurviewObject.action",
				   async: false,
			       data: {purviewId:purviewId},
				   success: function(data){
			    	   //显示 
					   $("#fileId1").val("");
			    	   createWindow(800,"auto","&nbsp;&nbsp;修改权限","icon-edit",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#managerFunctionsWin").css("display","none");
						$("#detailWin").css("display","none");//隐藏修改窗口
			    	    $("#fpurviewId").val(data.purviewId);
			    	    $("#purviewId").val(data.purviewId);
			    	    $("#oldParentId").val(data.parentId);
			    	    $("#parentId").val(data.parentId);
			    	    $("#purviewName").val(data.purviewName);
			    	    $("#sortCode").val(data.sortCode);
			    	    $("#url").val(data.url);
			    	    $("#isLeaf").val(data.isLeaf);
			    	    $("#imageUrl1").val(data.iconUrl);
			    	    $("#photo1").html("<img style='padding-top:10px' src='<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.iconUrl+"' width='30px' height='30px' />");
			    	    initPurview(purviewId,data.parentId,data.isLeaf);
					}
				});
		}
		
		//取消 
		function cancel(){
			$("#addOrEditWin").css("display","none");
		}
		
		function createDetailWindow(title,iconCls,inline,winId){
			$("#win").css("display","");
			$("#win").window({
				title:title,iconCls:iconCls,minimizable:false,maximizable:true,closable:true,shadow:false,
				closed:true,draggable:true,resizable:true,inline:inline,width:900,height:'500',modal:true,top:30
			}).window("open");
		}
	</script>
	</head>
	<body>
		<jsp:include page="../../util/item.jsp"/>
		<div class="main">
			<div class="treeCommonMain">
				<div class="treeCommonBox">
					<ul class="simpleTree">
						<li class="root" id='1' style="margin:  0 0 0 -13px;">
							<ul>
								<li id='2'>
								<span>&nbsp;&nbsp;系统权限</span>
								    <a href="javascript:addPurview(1)" class="folder">
								     	&nbsp;&nbsp;<img style="vertical-align:top;" src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/tree/folder_add.png"/>&nbsp;添加
								    </a>
									<ul class="ajax">
										<li id='3'>{url:${pageContext.request.contextPath}/back/purview/getNodes.action?id=1}</li>
									</ul>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
	        <!-- 新增分类  -->
		    <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			  	  <!-- 添加或者修改 -->
				  <jsp:include page="addOrEditor.jsp"/>
				  <!-- 详情页 -->
				  <jsp:include page="detail.jsp"/>
				  <!-- 管理权限 -->
			      <jsp:include page="functionsList.jsp"/>
		    </div>
	    </div>
	</body>
</html>
