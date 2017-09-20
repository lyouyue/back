<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>首页楼层数据信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.shopHomeMiddleCategory.tree.listLink.js"></script>
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
			//,docToFolderConvert:true
			});
		//获取单个对象，或者：var obj = document.getElementById('2')
			var obj = $("#2")[0];// 2 为需要展开的根目录id
			simpleTreeCollection.each(function(){
				this.nodeToggle(obj);//自动触发展开
			});
			showTable(1,1);
		});
	 
		//点击name触发
		function showTable(id,level){
			/* 
			   判断是一级分类还是二级分类
			   一级分类操作：左侧小分类  以及 下方的促销图片
			   二级分类操作：中间tab部分 以及 小轮播图
			 */
			 var url="${pageContext.request.contextPath}/back/";
			 if(level==1){
				 url+="shopHomeMiddleCategoryBilateral/gotoShopHomeMiddleCategoryBilateralPage.action";
			 }else{
				 url+="shopHomeMiddleCategoryTAB/gotoShopHomeMiddleCategoryTABPage.action";
			 }
			 $("#iframe").attr("src",url+"?categoryId="+id);
		 	 $("#iframeDIV").show();
		}
    </script>
</head>
<body>
		<jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
		<div class="main">
			 <div style="width: 19%;float: left; ">
				<div class="treeCommonMain">
					<div class="treeCommonBox">
						<ul class="simpleTree">
							<li class="root" id='1' style="margin:  0 0 0 -13px;">
								<ul>
									<li id='2'>
										<span> &nbsp;&nbsp;楼层分类</span> 
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
			</div>
			<!-- 	右侧列表 begin -->
			<div style="width: 80%;display: none;padding-left: 10px;overflow-y:auto;overflow-x:auto; float: left; height:100%" id="iframeDIV" >
					<iframe id="iframe"  frameborder="0" height="750px" width="100%" scrolling="no"/>
			</div>
			<br clear="all"/>
			<!-- 	右侧列表 end -->
			</div>
	</body>
</html>
