<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>套餐规格信息</title>
		<jsp:include page="../../../WEB-INF/util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/specificationTtree.js"></script>
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
			//初始化加载右侧查询条件
			listSpecification(16);//16为毛呢大衣
		});
		 
		//维护套餐规格
		function listSpecification(id){
		  $("#articleIframe").attr("src","${pageContext.request.contextPath}/back/specificationTree/gotoSpecificationTreePage.action?productTypeId="+id);
		  $("#articleDiv").show();
		}
		
		
		//更新初始化套餐分类信息  
		function initProdutTypeInfo(){
			$.ajax({
				type: "POST",dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/producttype/initProdutTypeInfo.action",
				async:false,//false同步;true异步
				success: function(data){
					if(data.isSuccess=="true") {
						msgShow("系统提示", "<p class='tipInfo'>同步成功！</p>", "warning");
					}else{
						msgShow("系统提示", "<p class='tipInfo'>同步失败，请重试！</p>", "warning");
					}
				}
			});
			
			//获取前台更新初始化信息url
			var prefixUrl='${fileUrlConfig.initDatabaseUrl}';
			var split=prefixUrl.split("@");
			//更新前台套餐分类信息
			var url=split[0]+"back/producttype/initProdutTypeInfo.action?callback=?";
			$.getJSON(url);
			msgShow("系统提示", "<p class='tipInfo'>分类信息同步成功！</p>", "warning");
		}
	</script>
	</head>
	<body>
	  <jsp:include page="../../util/item.jsp"/>
	<!-- 左侧树形结构 -->
	<div class="main">
	<div style="width: 19%;float: left; ">
		<div class="treeCommonMain">
			<div class="treeCommonBox">
				<ul class="simpleTree">
					<li class="root" id='1' style="margin: 0 0 0 -13px;">
						<ul>
							<li id='2'>
								<span> &nbsp;套餐分类</span> 
	<!--						<a style="margin-left: 10px;cursor:hand;" href="javascript:;"  onclick="initProdutTypeInfo()"><font color="red">同步初始化套餐分类》</font> </a> -->
								<ul class="ajax">
									<li id='3'>
										{url:${pageContext.request.contextPath}/back/producttype/getNodes.action?id=1} 
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
    </div>
    <!-- 右侧套餐规格列表 -->
    <div style="width: 80%;display: none;padding-left: 10px;overflow-y:auto;overflow-x:auto; float: left; height:100%" id="articleDiv" >
		    <iframe id="articleIframe"  frameborder="0" height="750px" width="100%" scrolling="no"/>
	  </div>
	  <br clear="all"/>    
	  </div>	  
	</body>
</html>
