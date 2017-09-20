<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<title>信息维护</title>
		<jsp:include page="../../../../WEB-INF/util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/informationCategorTtree.js"></script>
		<script type="text/javascript">
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
			});
			//获取单个对象，或者：var obj = document.getElementById('2')
			var obj = $("#2")[0];// 2 为需要展开的根目录id
			simpleTreeCollection.each(function(){
				this.nodeToggle(obj);//自动触发展开
			});
		});
		 
		//维护信息 
		function listActicle(id){
		  $("#articleIframe").attr("src","${pageContext.request.contextPath}/back/cmsInformation/gotoCmsInformationPage.action?categoryId="+id);
		  $("#articleDiv").show();
		}
	</script>
	</head>
	<body>
	<!-- 左侧树形结构 -->
	<div style="width: 18%;float: left; ">
		 <div style="float: left;padding-left: 20px;width: 100%;overflow-x:auto;height: 100%;">
			<ul class="simpleTree">
				<li class="root" id='1'>
					<ul>
						<li id='2'>
							<span> &nbsp;信息分类</span> 
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
    </div>
    <!-- 右侧信息列表 -->
    
    <div style="width: 80%;display: none;padding-left: 5px;overflow-y:auto;overflow-x:auto; float: left; height:100%" id="articleDiv" >
		    <iframe id="articleIframe"  frameborder="0" height="750px" width="100%" scrolling="no"/>
	  </div>
	  <br clear="all"/>    	  
	</body>
</html>
