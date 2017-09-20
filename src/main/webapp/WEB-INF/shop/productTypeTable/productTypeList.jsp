<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>套餐分类列表信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
   	    //表单验证
	    $("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
              function() {  
                 var options = {  
                     url : "${pageContext.request.contextPath}/back/productTypeTable/saveOrEditProductType.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 if(data.strFlag==true){
	                       	 closeWin();
	                       	 location.reload();
	                   	 }else{
	                   		msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");  
							 $("input.button_save").attr("disabled",false);//防止重复提交
	                     }
                     }
                 };  
                 $("#form1").ajaxSubmit(options); 
                 $("input.button_save").attr("disabled","disabled");//防止重复提交
              });
	       }
	    });
			
	   $("#tt").datagrid({//数据表格
			/* title:"套餐分类列表信息:<font style='color:blue;'>套餐分类&nbsp;&gt;&nbsp;${prodTypeNames}</font>",
			iconCls:"icon-save",  */
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/productTypeTable/listProductType.action?productTypeId=${productTypeId}",
			idField:"productTypeId",//唯一性标识字段
			frozenColumns:[[//冻结字段
			    {field:"ck",checkbox:true}
			]],
			columns:[[//未冻结字段
	            {field:"sortName",title:"分类名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                return "<a style='display:block;' id='"+rowData.productTypeId+"' onclick='showDetailInfo(this.id);'>"+rowData.sortName+"</a>";  
	         	  }  
				}, 
				{field:"categoryImage",title:"分类图片",width:80,formatter:function(value,rowData,rowIndex){
					return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.categoryImage+"' width='60px' height='30px' />";
				}
				},
				{field:"isShow",title:"是否显示",width:100,formatter:function(value,rowData,rowIndex){ 
	            	if(value==0){
	            		return "<font class='color_002'>不显示</font>";
	            	}else if(value==1){
	            		return "<font class='color_001'>显示</font>";
	            	}
	           	 }
				}, 
				{field:"isRecommend",title:"是否推荐",width:100,formatter:function(value,rowData,rowIndex){ 
	           		if(value==0) {
	           			return "<font class='color_002'>不推荐</font>";
	           		}else if(value==1) {
	           			return "<font class='color_001'>推荐</font>";
	           		}
				}
				}, 
				{field:"level",title:"分类级别",width:100,formatter:function(value,rowData,rowIndex){ 
	           		if(value==1) {
	           			return "一级分类";
	           		}else if(value==2) {
	           			return "二级分类";
	           		}else if(value==3) {
	           			return "三级分类";
	           		}
				}
				}
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号   
			singleSelect:true,//true只可以选中一行
			toolbar:[{//工具条
				text:"添加",
				iconCls:"icon-add",
				handler:function(){
					createWindow(900,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin"); 
					$("#detailWin").css("display","none");
					$("#addOrEditWin").css("display","");
				}
			},"-",{
				text:"修改", 
				iconCls:"icon-edit",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
					}else if(rows.length==1){
						$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/productTypeTable/getProductTypeObject.action",
						   data: {productTypeId:rows[0].productTypeId},
						   success: function(data){
								createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
								$("#detailWin").css("display","none");//隐藏修改窗口
								$("#addOrEditWin").css("display","");
					    	    $("#productTypeId").val(data.productTypeId);
					    	    $("#parentId").val(data.parentId);
					    	    $("#sortName").val(data.sortName);
					    	    $("#sortAppName").val(data.sortAppName);
					    	    $("#sortCode").val(data.sortCode);
					    	    //$("#floor").val(data.floor);
					    	    $("#level").val(data.level);
					    	    $("#loadType").val(data.loadType);
					    	    //$("#categoryDescription").val(data.categoryDescription);
					    	    $("#imageUrlPC").val(data.categoryImage);
					    	    $("#photoPC").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' width='50px' height='50px' />");
					    	    $("#imageUrlWx").val(data.categoryImageWx);
					    	    $("#photoWx").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageWx+"' width='50px' height='50px' />");
					    	    $("#imageUrlApp").val(data.categoryImageApp);
					    	    $("#photoApp").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageApp+"' width='50px' height='50px' />");
					    	    $("#isShow_"+data.isShow).attr("checked",true);
					    	    $("#isRecommend_"+data.isRecommend).attr("checked",true);
						   }
						});
					}
				}
		},"-",{
			text:"删除",
			iconCls:"icon-remove",
			handler:function(){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==0){
					msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
				}else if(rows.length>1){//超过了一个选择项
					msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
				}else if(rows.length==1){
					$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
						if(data){//判断是否删除
							if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
								$.ajax({
								   type: "POST",dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/productTypeTable/delProductType.action",
								   data: {productTypeId:rows[0].productTypeId},
								   success: function(data){
									   $("#tt").datagrid("clearSelections");//删除后取消所有选项
									   if(data.isSuccess=="true"){
							    	      msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
							    	      location.reload();
							    	   }else{
							    	      msgShow("系统提示", "<p class='tipInfo'>此分类下面还有子分类，请先删除子分类！</p>", "warning");  
							    	   }
								   }
								});
							}	
						}
					});
				}
			}
		}
		,"-",{
			text:"维护子分类",
			iconCls:"icon-search",
			handler:function(){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==0){//没有选择修改项
					msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
				}if(rows.length>1){//超过了一个选择项
					msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
				}else if(rows.length==1){
					var type_level = <s:property value="type_level"/>;//商城控制套餐分类级别
					var level = ${level}+2;
					if(Number(level)==Number(type_level)){
						msgShow("系统提示", "<p class='tipInfo'>平台规定分类维护最多添加三级！</p>", "warning");  
					}else{
						location.href="${pageContext.request.contextPath}/back/productTypeTable/gotoProductTypeTablePage.action?productTypeId="+rows[0].productTypeId;
					}
					
				}
			}
		},"-",
		/*
		{
			text:"查询品牌",
			iconCls:"icon-search",
			handler:function(){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==0){//没有选择修改项
					$.messager.alert("提示","请选择分类");  
				}if(rows.length>1){//超过了一个选择项
					$.messager.alert("提示","只能够选择一项"); 
				}else if(rows.length==1){
					location.href="${pageContext.request.contextPath}/back/brandtype/gotoBrandListByProductTypeId.action?productTypeId="+rows[0].productTypeId;
				}
			}
		},"-", */
		<%
		String type_level= request.getAttribute("type_level").toString();
		String level = request.getAttribute("level").toString();
		if(Integer.parseInt(type_level)==(Integer.parseInt(level)+1)){
		%>
		{
			text:"查询套餐",
			iconCls:"icon-search",
			handler:function(){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==0){//没有选择修改项
					msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
				}if(rows.length>1){//超过了一个选择项
					msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
				}else if(rows.length==1){
					location.href="${pageContext.request.contextPath}/back/producttype/gotoProductInfoListByProductTypeId.action?productTypeId="+rows[0].productTypeId;
				}
			}
		},"-",{
			text:"查询计量单位",
			iconCls:"icon-search",
			handler:function(){
				var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
				if(rows.length==0){//没有选择修改项
					msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
				}if(rows.length>1){//超过了一个选择项
					msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
				}else if(rows.length==1){
					location.href="${pageContext.request.contextPath}/back/productMeasuringUnit/gotoProductMeasuringUnitListByProductTypeId.action?productTypeId="+rows[0].productTypeId;
				}
			}
		},"-",
		<%
		}
		%>
		<%
		String productTypeId = request.getAttribute("productTypeId").toString();
		Object prodTypeNames = request.getAttribute("prodTypeNames");
		if(productTypeId!=null&&!"0".equals(productTypeId)&&(prodTypeNames!=null&&"1".equals(level))){
		%>
		{
			text:"返回一级分类",
			iconCls:"icon-back",
			handler:function(){
				location.href="${pageContext.request.contextPath}/back/productTypeTable/gotoProductTypeTablePage.action";
			}
		},"-",
		<%
		}else if(productTypeId!=null&&!"0".equals(productTypeId)&&(prodTypeNames!=null&&"2".equals(level))){
		%>
		{
			text:"返回二级分类",
			iconCls:"icon-back",
			handler:function(){
				/* location.href="${pageContext.request.contextPath}/back/productTypeTable/gotoProductTypeTablePage.action?productTypeId=${parentId}"; */
				history.back(-1);
			}
		},"-",
		<%
		}else if(productTypeId!=null&&!"0".equals(productTypeId)&&(prodTypeNames!=null&&"3".equals(level))){
		%>
		{
			text:"返回三级分类",
			iconCls:"icon-back",
			handler:function(){
				/* location.href="${pageContext.request.contextPath}/back/productTypeTable/gotoProductTypeTablePage.action?productTypeId=${parentId}"; */
				history.back(-1);
			}
		},"-",
		<%
		}
		%>
		{text:"刷新",
			iconCls:"icon-reload",
			handler:function(){
				$("#tt").datagrid("clearSelections");//删除后取消所有选项
				$("#tt").datagrid("reload");
			}
		}
		]
		});
		pageSplit();//调用分页函数
	});
    
	function showDetailInfo(id){
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/productTypeTable/getProductTypeObject.action",
			   data: {productTypeId:id},
			   dataType: "JSON",
			   success: function(data){
					createWindow(800,'auto',"&nbsp;&nbsp;套餐分类详情","icon-add",false,"detailWin");
				    $("#addOrEditWin").css("display","none");
				    $("#detailWin").css("display","");
				    $("#dproductTypeId").html(data.productTypeId);
					$("#dsortName").html(data.sortName);
					$("#dsortAppName").html(data.sortAppName);
					$("#dlevel").html(data.level);
					$("#dsortCode").html(data.sortCode);
					/* $("#dcategoryDescription").html(data.categoryDescription);
					<s:iterator value="#application.homekeybook['floor']" var="hkb">
						if(data.floor==<s:property value="#hkb.value" />){
							$("#dfloor").html("<s:property value='#hkb.name' />");
						}
					</s:iterator> */
					if(data.isShow==0){
						$("#disShow").html("<font class='color_002'>不显示</font>");
					}else if(data.isShow==1){
						$("#disShow").html("<font class='color_001'>显示</font>");
					}
					if(data.isRecommend==0){
						$("#disRecommend").html("<font class='color_002'>不推荐</font>");
					}else if(data.isRecommend==1){
						$("#disRecommend").html("<font class='color_001'>推荐</font>");
					}
					$("#dcategoryImage").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImage+"' width='50px' height='50px' />");
					$("#dcategoryImageWx").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageWx+"' width='50px' height='50px' />");
					$("#dcategoryImageApp").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.categoryImageApp+"' width='50px' height='50px' />");
			   }
		});
	}
</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<!-- <table class="searchTab">
		</table><br/> -->
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 添加或者修改 -->
				<jsp:include page="addOrEditor.jsp"/>
				<!-- 详情页 -->
				<jsp:include page="detail.jsp"/>
			</div>
	</div>
</body>
</html>
