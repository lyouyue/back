<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>地区信息</title>
    <jsp:include page="../../../WEB-INF/util/import.jsp"/>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}basic/js/areaTtree.js"></script>
    <script type="text/javascript">
    $(function(){
	    //表单验证
	    $("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
	         function() {  
	            var options = {  
	       		    url: "${pageContext.request.contextPath}/back/area/saveOrEditArea.action",
	                type : "post",  
	                dataType:"json",
	                success : function(data) { 
	               	 if(data.isSuccess==true){
	                   	 closeWin();
	                   	 location.reload();
	               	 }else{
               			msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");  
						$("input.button_save").attr("disabled",false);
	                 }
	                }
	            };  
	            $("#form1").ajaxSubmit(options);  
	            $("input.button_save").attr("disabled","disabled");//防止重复提交
	         });
	       }
	    });
    });
    
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
	});
	//添加
	function addArea(id){
		//准备初始数据 ,父亲分类 
		createWindow(700,"auto","&nbsp;&nbsp;添加地区","icon-add",false,"addOrEditWin");
		$("#detailWin").css("display","none");//隐藏修改窗口
		$("#addOrEditWin").css("display","");
		$("#parentId").val(id);
		$("#areaId").val("");	
	}
	//编辑
	function editArea(id){
		$.ajax({
		   type: "POST",
		   dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/area/getAreaObject.action",
	       data: {id:id},
		   success: function(data){
				createWindow(700,"auto","&nbsp;&nbsp;修改地区","icon-add",false,"addOrEditWin"); 
				$("#detailWin").css("display","none");//隐藏修改窗口
				$("#addOrEditWin").css("display","");
	    	    $("#areaId").val(data.areaId);
	    	    $("#parentId").val(data.parentId);	
				$("#name").val(data.name);
				$("#areaCode").val(data.areaCode);
				$("#orders").val(data.orders);
		     }
		});
	}
	//详情
	function getArea(id){
		$.ajax({
		   type: "POST",
		   dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/area/getAreaObject.action",
	       data: {id:id},
		   success: function(data){
				createWindow(700,"auto","&nbsp;&nbsp;修改地区","icon-tip",false,"detailWin"); 
				$("#addOrEditWin").css("display","none");
			    $("#detailWin").css("display","");
				$("#dname").html(data.name);
				$("#dareaCode").html(data.areaCode);
				$("#dorders").html(data.orders);
		     }
		});
	}
	//删除一个地区
	function deleteArea(id){
		$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
			if(data){//判断是否删除
			 $.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/area/deleteArea.action",
			       data: {id:id},
				   success: function(data){
					   if(data.isSuccess==true){
						    location.reload();
					   }
				     }
				});
		}
		});
	}
	//取消 
	function cancel(){
		 location.reload();
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
								<span> &nbsp;全国</span> 
								<ul class="ajax">
									<li id='3'>
										{url:${pageContext.request.contextPath}/back/area/getNodes.action?parentId=0} 
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- 新增地区 -->
	<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<div id="addOrEditWin">
		    <form id="form1"  method="post" action="">
		        <input id="parentId" type="hidden" name="basicArea.parentId" />
		        <input id="areaId" type="hidden" name="basicArea.areaId"  noclear="true" />
			    <table align="center" class="addOrEditTable" width="600px;">
				    <tr>
				      <td class="toright_td" width="150px"><font style="color: Red">* </font>地区名称:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="basicArea.name" class="{validate:{required:true,maxlength:[50]}}"/></td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px"><font style="color: Red">* </font>地区编码:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;<input id="areaCode" type="text" name="basicArea.areaCode" class="{validate:{required:true,maxlength:[50]}}"/></td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px"><font style="color: Red">* </font>排序号:&nbsp;&nbsp;</td>
				      <td class="toleft_td">&nbsp;&nbsp;<input id="orders" type="text" name="basicArea.orders" class="{validate:{required:true,maxlength:[8],digits:true}}"/></td>
				    </tr>
			    </table>
			    <div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	            </div>
			</form>
		 </div>
		 <!-- 详情页 -->
		 <jsp:include page="detail.jsp"/>
	</div>
  </body>
</html>
