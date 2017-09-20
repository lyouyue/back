<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>商品属性信息</title>
		<jsp:include page="../../../WEB-INF/util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/productAttributeTtree.js"></script>
		<script type="text/javascript">
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
			//初始化加载右侧查询条件
			listProductParameters(16);//默认为毛呢大衣
		});
		//维护商品参数
		function listProductParameters(id){
			$("#productParametersIframe").attr("src","${pageContext.request.contextPath}/back/productAttribute/gotoProductAttributeList.action?productTypeId="+id);
			$("#productParametersDiv").show();
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
									<span> &nbsp;商品分类</span> 
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
	    <!-- 右侧查询列表 -->
	    <div style="width: 80%;display: none;padding-left: 10px;overflow-y:auto;overflow-x:auto; float: left; height:100%" id="productParametersDiv" >
			<iframe id="productParametersIframe"  frameborder="0" height="750px" width="100%" scrolling="no"/>
		</div>
		<br clear="all"/>
	</div>
	</body>
</html>
