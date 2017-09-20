<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>套餐参数信息</title>
		<jsp:include page="../../../WEB-INF/util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/productParametersTtree.js"></script>
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
			listProductParameters(16);
		});
		//维护套餐参数
		function listProductParameters(id){
			$("#productParametersIframe").attr("src","${pageContext.request.contextPath}/back/productParameters/gotoProductParametersPage.action?productTypeId="+id);
			//$("#productParametersIframe").attr("src","${pageContext.request.contextPath}/back/productParameters/gotoProductParametersNewPage.action?productTypeId="+id);
			$("#productParametersDiv").show();
			/* createWindow(900,500,"&nbsp;&nbsp;维护套餐参数","icon-add",false,"addOrEditWin",10);
			$("#appendTable").html("");
			$("#addOrEditWin").css("display","");
			$("#productParametersId").val(null);
			$("#productTypeId").val(id);
			$("#parentIdList").css("display","");
			$("#secondListHtml").html("");
			//看该参数是否已经添加参数
			$.ajax({
				url:"${pageContext.request.contextPath}/back/productParameters/getPorductParameters.action",
				type:"post",
				dataType:"json",
				data:{productTypeId:id},
				success:function(data){
					if(data!=null){
						$("#appendTable").html("");
						$("#productParametersId").val(data.productParametersId);
						$("#name").val(data.name);
						$("#productTypeId").val(data.productTypeId);
						//$("#productParametersInfo").val(productParameters.info);
						$("#sort").val(data.sort);
						var infoObj=eval(data.info);
						var index=0;
						var infoIndex=0;
						for(var i=0;i<infoObj.length;i++){
							var trHtml ='<table id="parameterTable'+i+'" class="parameterTable addOrEditTable" style="border: 1px solid #d0d0d0;width:100%;margin-top:0px;"> ';
							trHtml+='<tr  class="parameterTr" style="background:#ccc;color: blue">' +
									'<td>参数组名称<\/td><td> <input type="text" name="listParamGroup[' + i + '].name" value="'+infoObj[i].name+'" class="{validate:{required:true}}"\/><input type="hidden"  name="listParamGroup[' + i + '].paramGroupId" value="'+infoObj[i].paramGroupId+'"\/> <\/td> ';
							trHtml+='<td>排序<\/td><td> <input type="text" name="listParamGroup[' + i + '].order " class="{validate:{number:true,maxlength:[2]}}" value="'+infoObj[i].order+'" style="width: 50px;" \/> <\/td> ';
							trHtml+='<td><a href="javascript:;" id="' + i + '" name="'+infoObj[i].paramGroupId+'" class="addParamGroupInfo">[添加参数]<\/a></td><td> <a href="javascript:;" id="'+i+'" class="deleteParameter">[删除参数组]<\/a>  <\/td> ';
							trHtml+=' <\/td><\/tr>';
							trHtml+='<tr ><td  colspan="6"><table id="parameterInfoTable' + i + '" class="parameterInfoTable addOrEditTable" style="width:100%;margin-top:0px;">';
							var a =eval(infoObj[i].paramGroupInfo);
							//var h=$(".parameterInfoTable tr").length;
							for(var u=0;u<a.length;u++){
								trHtml+='<tr class="parameterInfoTr">';
								trHtml+='<td>参数名称 <\/td> <td> <input type="text" name="listParamGroupInfo[' +infoIndex + '].name" value="'+a[u].name+'" class="{validate:{required:true}}"\/> <input type="hidden" id="pgiId0" name="listParamGroupInfo[' +infoIndex+ '].pgiId" value="'+a[u].pgiId+'"\/><input type="hidden"  name="listParamGroupInfo[' + infoIndex + '].pgInfoId" value="'+a[u].pgInfoId+'"\/> <\/td>';
								trHtml+='<td>参数排序 <\/td> <td> <input type="text" name="listParamGroupInfo[' + infoIndex + '].order" class="{validate:{number:true,maxlength:[2]}}" value="'+a[u].order+'"  style="width: 50px;" \/> <\/td><td>  <a href="javascript:;" class="deteleParamGroupInfo">[删除]<\/a> <\/td><\/tr>' ;
								infoIndex++;
							}
							trHtml+='<\/table></td><\/tr>';
							trHtml+='<\/table>';
							$("#appendTable").append(trHtml);
							index++;
						}
						$("#parameterIndex").val(index);
					}else{
						$("#appendTable").html("");
						$("#parameterIndex").val(0);
						$("#productParametersId").val("");
						$("#name").val("");
						$("#sort").val("");
					}
				}
			}); */
			
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
		<div style="width: 80%;display: none;padding-left: 10px;overflow-y:auto;overflow-x:auto; float: left; height:750px" id="productParametersDiv" >
				<iframe id="productParametersIframe"  frameborder="0" height="750px" width="100%"/>
		</div>
		<br clear="all"/>
	</div>
	<%-- <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<!-- 添加或者修改 -->
		<jsp:include page="productParameters.jsp"/>
	</div> --%>
	</body>
</html>
