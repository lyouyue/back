<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>套餐分类信息</title>
		<jsp:include page="../../util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.producttype.tree.js"></script>
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
			//,docToFolderConvert:true
			});
			//获取单个对象，或者：var obj = document.getElementById('2')
			var obj = $("#2")[0];// 2 为需要展开的根目录id
			simpleTreeCollection.each(function(){
				this.nodeToggle(obj);//自动触发展开
			});
			//初始化加载右侧查询条件
			listProductTypes(${productTypeId});//默认为一级分类
		});
		
		//维护套餐分类
		function listProductTypes(id){
			if(id==null||id==''){
				id = 1;
			}
			$("#productTypeIframe").attr("src","${pageContext.request.contextPath}/back/producttype/gotoProductTypeByLevelPage.action?productTypeId="+id);
			$("#productTypeDiv").show();
		}
		
		$(function(){
			 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/producttype/saveOrEditProductType.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 $("input.button_save").removeAttr("disabled");//解除重复提交锁定
                        	 closeWin();
                        	 msgShow("系统提示", "<p class='tipInfo'>成功！</p>", "warning");  
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     $("input.button_save").attr("disabled","disabled");//防止重复提交
                  });
		       }
		    });
		});
		
		function addProductType(id){
			//准备初始数据 ,父亲分类 
			createWindow(900,'auto',"&nbsp;&nbsp;添加套餐分类","icon-add",false,"win");
			$("#addOrEditWin").css("display","");
			$("#detailWin").css("display","none");//隐藏修改窗口
			$("#addOrEditWinExcel").css("display","none");
			$("#productTypeId").val("");
			$("#sortCode").val("");
			$("#sortName").val("");
			$("#parentId").val(id);
			$("#categoryDescription").val("");
			$("#categoryImage").val("");
			$("#photo1").html("");
			$("#photo2").html("");
			$("#photo3").html("");
			$("#fileId1").val("");
			$("#fileId2").val("");
			$("#fileId3").val("");
			if(id!=1){
				$("#specific").css("display","none");
			}
		}
		//编辑
		function editProductType(id){
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/producttype/getProductTypeObject.action",
				data: {productTypeId:id},
				success: function(data){
					//显示 
					createWindow(900,480,"&nbsp;&nbsp;修改套餐分类","icon-edit",false,"win",10);
					$("#fileId1").val("");
					$("#fileId2").val("");
					$("#fileId3").val("");
					$("#addOrEditWin").css("display","");
					$("#detailWin").css("display","none");//隐藏修改窗口
					$("#addOrEditWinExcel").css("display","none");
					$("#productTypeId").val(data.productTypeId);
					$("#parentId").val(data.parentId);
					$("#sortName").val(data.sortName);
					$("#sortAppName").val(data.sortAppName);
					$("#sortCode").val(data.sortCode);
					$("#level").val(data.level);
					$("#categoryDescription").val(data.categoryDescription);
					$("#imageUrl1").val(data.categoryImage);
					$("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
					$("#imageUrl2").val(data.categoryImageWx);
					$("#photo2").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageWx+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
					$("#imageUrl3").val(data.categoryImageApp);
					$("#photo3").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageApp+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
					$("#isShow_"+data.isShow).attr("checked",true);
					$("#isRecommend_"+data.isRecommend).attr("checked",true);
					$("#industrySpecific_"+data.industrySpecific).attr("checked",true);
				}
			});
		}
		//详情
		function getProductTypeInfo(id){
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/producttype/getProductTypeObject.action",
				data: {productTypeId:id},
				success: function(data){
					$("#dsortName").html(data.sortName);
					$("#dsortAppName").html(data.sortAppName);
					$("#dlevel").html(data.level);
					$("#dsortCode").html(data.sortCode);
					$("#dcategoryDescription").html(data.categoryDescription);
					if(data.isShow=="0"){
						$("#disShow").html("不显示");
					}else if(data.isShow=="1"){
						$("#disShow").html("显示");
					}
					if(data.isRecommend=="0"){
						$("#disRecommend").html("不推荐");
					}else if(data.isRecommend=="1"){
						$("#disRecommend").html("推荐");
					}
					if(data.industrySpecific=="0"){
						$("#dindustrySpecific").html("非专业推荐");
					}else if(data.isRecommend=="1"){
						$("#dindustrySpecific").html("专业推荐");
					}
					$("#dcategoryImage").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='50px' height='50px' />");
					$("#dcategoryImageWx").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageWx+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='50px' height='50px' />");
					$("#dcategoryImageApp").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageApp+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='50px' height='50px' />");
					//显示 
					createDetailWindow("&nbsp;&nbsp;详情","icon-add",false,"win");
					$("#addOrEditWin").css("display","none");
					$("#detailWin").css("display","");
					$("#addOrEditWinExcel").css("display","none");
				}
			});
		}
		//删除一个分类 
		function deleteProductType(id){
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
					$.ajax({
						type: "POST",
						dataType: "JSON",
						url: "${pageContext.request.contextPath}/back/producttype/delProductType.action",
						data: {productTypeId:id},
						success: function(data){
							if(data.isSuccess=="true"){
								msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
								location.reload();
							}else{
								msgShow("系统提示", "<p class='tipInfo'>此分类下存在子分类或关联套餐，无法删除！</p>", "warning");  
							}
						}
					});
				}
			});
		}
		//取消 
		function cancel(){
			$("#addOrEditWin").css("display","none");
		}
		
		//根据分类查询套餐
		function findProductInfoByProductTypeId(id){
			location.href="${pageContext.request.contextPath}/back/producttype/gotoProductInfoListByProductTypeId.action?productTypeId="+id;
		}
		//根据分类查询品牌
		function findBrandByProductTypeId(id){
			location.href="${pageContext.request.contextPath}/back/brandtype/gotoBrandListByProductTypeId.action?productTypeId="+id;
		}
		//根据分类查询计量单位
		function findMeasuringUnitByProductTypeId(id){
			location.href="${pageContext.request.contextPath}/back/productMeasuringUnit/gotoProductMeasuringUnitListByProductTypeId.action?productTypeId="+id;
		}
		function createDetailWindow(title,iconCls,inline,winId){
			$("#win").css("display","");
			$("#win").window({
				title:title,iconCls:iconCls,minimizable:false,maximizable:true,closable:true,shadow:false,
				closed:true,draggable:true,resizable:true,inline:inline,width:900,height:'500',modal:true,top:30
			}).window('open');
		}
		
		
		//更新初始化套餐分类信息  
		function initProdutTypeInfo(){
			$("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
			$("<div class=\"datagrid-mask-msg\"></div>").html("正在同步，请稍候。。。").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
			$.ajax({
				type: "POST",dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/producttype/initProdutTypeInfo.action",
				async:false,//false同步;true异步
				success: function(data){
					$("body").children("div.datagrid-mask-msg").remove();
					$("body").children("div.datagrid-mask").remove();
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
			//获取手机更新初始化信息url
			var prefixUrl_phone='${fileUrlConfig.phoneBasePath}';
			var split_phone=prefixUrl_phone.split("@");
			//更新前台套餐分类信息
			var url_phone=split_phone[0]+"back/producttype/initProdutTypeInfo.action?callback=?";
			//更新前台套餐分类信息
			$.getJSON(url);
			//更新手机套餐分类信息
			$.getJSON(url_phone);
			//msgShow("系统提示", "<p class='tipInfo'>分类初始化信息更新成功！</p>", "warning");
		}
		
		//打开导入数据的窗口
		function importExcelDataInfo(id){
			createWindow(700,150,"&nbsp;&nbsp;导入Excel数据","icon-add",false,"addOrEditWinExcel");
			$("#addOrEditWinExcel").css("display","");
			$("#addOrEditWin").css("display","none");
			$("#detailWin").css("display","none");
			$("#categoryId_excel").val(id);
		}
		
		//导入Excel数据
		function uploadExcelFile() {
			$(document).ready(  
				function() {  
				var options = {
					url : "${pageContext.request.contextPath}/back/updateInitInformation/uploadExcelFile.action",
					type : "post",  
					dataType:"json",
					success : function(data) {
						msgShow("系统提示", "<p class='tipInfo'>导入成功！</p>", "warning");
					}
				};
				$("#excelFileForm").ajaxSubmit(options);
			});
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
				<ul id="corp-tree" class="simpleTree">
					<li class="root" id='1' style="margin: 0 0 0 -13px;">
						<ul>
							<li id='2'>
								<span class='folder'> &nbsp;&nbsp;<a style="cursor: pointer;" onclick="listProductTypes(1)">套餐分类</a>
								<!-- <a style="margin-left: 10px;cursor:hand;" href="javascript:;"  onclick="initProdutTypeInfo()"><font color="red">同步套餐分类&nbsp;》</font> </a> -->
								</span>
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
	<div style="width: 80%;display: none;padding-left: 10px;overflow-y:auto;overflow-x:auto; float: left; height:100%" id="productTypeDiv" >
		<iframe id="productTypeIframe"  frameborder="0" height="750px" width="100%" scrolling="no"/>
	</div>
	<br clear="all"/>
	</div>
</body>
</html>
