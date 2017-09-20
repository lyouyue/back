<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}shop/css/tree.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.speType.tree.js"></script>
	<script type="text/javascript">
	var proIds = "";
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
	function findProductsBT(id){
		$.ajax({
		   type: "POST", 
		   dataType: "JSON",
		   url: "${pageContext.request.contextPath}/specialpro/findProductsBT.action",
		   data: {productTypeId:id},
		   success: function(data){
				if(data!=null){
					 var str = "&nbsp;&nbsp;&nbsp;<b style='color: green;'>请选择以下套餐</b><br/>&nbsp;&nbsp;&nbsp;";
					 for(var i=0;i<data.length;i++){
					     str += "<input type='checkbox' onclick='putValue("+data[i].productId+","+data[i].productId+")' name='proIds' >"+data[i].productFullName+"&nbsp;&nbsp;&nbsp;";
			   		 }
					$("#products").html(str); 
				}
		   }
		});
	}
	 //传值
	function putValue(id,name){
		 
		$("#showThingId").value=id;
		$("#thingName").value=name;
<%--			 window.close();--%>
	}
   </script>
  <div id="addOrEditWin2">
   		<div style="float: left; padding-left: 20px;width: 100%">
		<form action="a" target="Index" method="post">
			<br/>
			&nbsp;&nbsp;&nbsp;<b style="color: green;">套餐分类列表</b>
			<ul class="simpleTree">
				<li class="root" id='1'>
					<ul>
						<li id='2'>
							<span>套餐分类</span> 
<%--							     <a  onclick="addProductType(1)" style="cursor: pointer;">--%>
<%--								 </a>--%>
							<ul class="ajax">
								<li id='3'>
									{url:${basePath}producttype/getNodes.action?id=1} 
								</li>
							</ul>
						</li>
					</ul>
				</li>
			</ul>
		</form>
	</div><br/>
	<div style="width: 80%">
	    <form id="form1"  method="post" action="" style="margin-top: 0">
	    	<input id="proIds" type="hidden" name="proIds" >
	    	<input id="speProTypeId" type="hidden"  name="speProTypeId" >
		    <div>
		       <div id="products"></div>
<%--				    <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">--%>
<%--		                <a id="btnSubmit" class="easyui-linkbutton" icon="icon-ok" href="javascript:submitForm()" >确定</a> --%>
<%--		                <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>--%>
<%--		            </div>--%>
		    </div>
		</form>
	</div>
	 
  </div>
	  