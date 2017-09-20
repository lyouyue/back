<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>特别套餐分类</title>
		<jsp:include page="../../util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}shop/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.rightShowType.tree.js"></script>
		<script type="text/javascript">
		var simpleTreeCollection;
		var name="";
		var id="";
		$(document).ready(function(){

		simpleTreeCollection = $('.simpleTree').simpleTree({
			autoclose: true,
			afterClick:function(node){
				name=('span:first',node).text();
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
		 
		});
		
		
		
		//删除一个分类 
		function deleteRightShowType(id){
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
				 $.ajax({
					 type:"post",
					 dataType:"json",
					 url:"${pageContext.request.contextPath}/back/rightShow/deleteRightShowType.action", 
					 data:{rightShowTypeId:id},
					 success:function(data){
						 msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
						  location.reload();
					 }
				 });
				}
			});
		}
		//维护展示信息
		function matainShowInfo(id,type){
			location.href='${pageContext.request.contextPath}/back/rightShow/gotoRightShowInfoPage.action?rightShowTypeId='+id+'&type='+type;
		}
	</script>
	</head>
	<body>
	<div>
		<div style="float: left; padding-left: 20px;">
			<form action="a" target="Index" method="post">
				<ul class="simpleTree">
					<li class="root" id='1'>
						<ul>
							<li id='2'>
								<span>首页右面展示分类</span> 
							     <a  onclick="addRightShowType(0)" style="cursor: pointer;">
							                   添加首页右面展示模块
								 </a>
								<ul class="ajax">
									<li id='3'>
										{url:${basePath}rightShow/getNodes.action?id=0} 
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
			</form>
		</div>
  
	  <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
	  	<!-- 新增或修改分类  -->
		 <jsp:include page="addOrEditRightShowType.jsp"></jsp:include>
	  	<!-- 详情  -->
		 <jsp:include page="detailRightShowType.jsp"></jsp:include>
		 
	  </div>
	</div>
	</body>
</html>
