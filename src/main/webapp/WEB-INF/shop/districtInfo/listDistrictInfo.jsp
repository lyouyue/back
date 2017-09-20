<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>地区信息</title>
		<jsp:include page="../../util/import.jsp"/>
		<link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}shop/css/tree.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.districtInfo.tree.js"></script>
		<script type="text/javascript">
		 $(function(){
			 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/districtInfo/saveOrEditDistrictInfo.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	location.reload();
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     //$("input.button_save").attr("disabled","disabled");
                  });
		       }
		    });
		});
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
		function addDistrictInfo(id){
			//准备初始数据 ,父亲分类 
			createDetailWindow("&nbsp;&nbsp;添加","icon-add",false,"win");
			$("#addOrEditWin").css("display","");
			$("#detailWin").css("display","none");//隐藏修改窗口
			$("#districtInfoId").val("");
			$("#sortCode").val("");
			$("#districtName").val("");
			$("#parentId").val(id);
		}
		//编辑
		function editDistrictInfo(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/districtInfo/getDistrictInfoObject.action",
			       data: {districtInfoId:id},
				   success: function(data){
			    	   //显示 
					    createDetailWindow("&nbsp;&nbsp;编辑","icon-edit",false,"win");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");//隐藏修改窗口
			    	    $("#districtInfoId").val(data.districtInfoId);
			    	    $("#parentId").val(data.parentId);
			    	    $("#districtName").val(data.districtName);
			    	    $("#sortCode").val(data.sortCode);
					}
				});
		}
		//详情
		function getDistrictInfo(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/districtInfo/getDistrictInfoObject.action",
			       data: {districtInfoId:id},
				   success: function(data){
						$("#ddistrictName").html(data.districtName);
						$("#dsortCode").html(data.sortCode);
						//显示 
						createDetailWindow("&nbsp;&nbsp;详情","icon-add",false,"win");
					    $("#addOrEditWin").css("display","none");
					    $("#detailWin").css("display","");
				     }
				});
		}
		//删除一个分类 
		function deleteDistrictInfo(id){
			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
				 $.ajax({
					   type: "POST",
					   dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/districtInfo/delDistrictInfo.action",
				       data: {districtInfoId:id},
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
		//取消 
		function cancel(){
			$("#addOrEditWin").css("display","none");
		}
		
		function createDetailWindow(title,iconCls,inline,winId){
			$('#win').css("display","");
			$('#win').window({
				title:title,iconCls:iconCls,minimizable:false,maximizable:true,closable:true,shadow:false,
				closed:true,draggable:true,resizable:true,inline:inline,width:900,height:'500',modal:true,top:30
			}).window('open');
		}
	</script>
	</head>
	<body>
	<div style="width: 90%">
		<div style="float: left; padding-left: 20px;width: 60%">
			<form action="a" target="Index" method="post">
				<ul class="simpleTree">
					<li class="root" id='1'>
						<ul>
							<li id='2'>
								<span>地区信息</span> 
							     <a  onclick="addDistrictInfo(1)">
							                   添加一级分类
								 </a>
								<ul class="ajax">
									<li id='3'>
									    <!-- 
									     -->
										{url:${basePath}districtInfo/getNodes.action?id=1} 
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
			</form>
		</div>
  <!-- 新增分类  -->
	  <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  <!-- 添加或者修改 -->
			  <jsp:include page="addOrEditor.jsp"/>
			  <!-- 详情页 -->
			  <jsp:include page="detail.jsp"/>
	  </div>
    </div>
	</body>
</html>
