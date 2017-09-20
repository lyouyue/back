<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>机构信息</title>
    <jsp:include page="../../util/import.jsp"/>
     <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/makePy.min.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"机构机构列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/brand/listBrand.action",
				queryParams:{pageSize:pageSize},
				idField:"brandId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"brandImageUrl",title:"首页推荐机构图片",width:80,
						formatter:function(value,rowData,rowIndex){
						return "<a style='display:block;' id='"+rowData.brandId+"' onclick='showDetailInfo(this.id);'><img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.brandBigImageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='30px' height='30px' /></a>";
						}
					},
				   {field:"brandName",title:"机构名称",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.brandId+"' onclick='showDetailInfo(this.id);'>"+rowData.brandName+"</a>";  
		         	  }  
					}, 
					{field:"firstWord",title:"机构归类",width:50},
					{field:"title",title:"标题",width:80},
					{field:"synopsis",title:"简介",width:80},
					{field:"isShow",title:"是否显示",width:50,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>否</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>是</font>";} 
                         }
					},
					{field:"isRecommend",title:"机构频道推荐",width:50,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>否</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>是</font>";} 
                         }
					},
					{field:"isHomePage",title:"店铺首页机构推荐",width:50,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>否</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>是</font>";} 
                         }
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<%
					if("add".equals((String)functionsMap.get(purviewId+"_add"))){
				%>	
					{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(930,440,"&nbsp;&nbsp;添加机构机构","icon-add",false,"addOrEditWin");
						$("#brandId").val("");
						$("#brandName").val("");
						$("#title").val("");
						$("#synopsis").val("");
						$("#sortCode").val("");
						$("#fileId1").val("");
						$("#fileId2").val("");
						$("#photo1").html("");
						$("#photo2").html("");
						$("#imageUrl1").val("");
						$("#imageUrl2").val("");
						$("#mymessage1").html("");
						$("#mymessage2").html("");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
					}
				},"-",
				<%
				 }
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							$("#fileId1").val("");
							$("#fileId2").val("");
							createWindow(930,440,"&nbsp;&nbsp;修改机构机构","icon-edit",false,"addOrEditWin");
	    			$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/brand/getBrandInfo.action",
						   data: {brandId:rows[0].brandId},
						   success: function(data){
							   $("#brandId").val(data.brandId);
							   $("#brandName").val(data.brandName);
							   $("#sortCode").val(data.sortCode);
							   $("#title").val(data.title);
							   $("#synopsis").val(data.synopsis);
							   $("#firstWord").val(data.firstWord);
							   $("#isShow_"+data.isShow).attr("checked",true);
							   $("#isRecommend_"+data.isRecommend).attr("checked",true);
							   $("#isHomePage_"+data.isHomePage).attr("checked",true);
						       $("#imageUrl1").val(data.brandBigImageUrl);
						       $("#imageUrl2").val(data.brandImageUrl);
						       $("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.brandBigImageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='100px' height='40px' />");
						       $("#photo2").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.brandImageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='100px' height='40px' />");
						   }
						});
						}
					}
				} ,"-", 
				<%
					 }
					if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
				%>
				{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].brandId;
											else ids+=rows[i].brandId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/brand/deleteBrand.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
									}	
								}
							});
						}
					}
				}
				<%
					}
				%>
				,"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});
    	//机构详情
	    function showDetailInfo(id){
			createWindow(800,315,"&nbsp;&nbsp;机构机构详情","icon-tip",false,"detailWin");
			$.ajax({
				   type: "POST",
				   url: "${pageContext.request.contextPath}/back/brand/getBrandInfo.action",
				   data: {brandId:id},
				   dataType: "JSON",
				   success: function(data){
					   $("#dbrandName").html(data.brandName);
					   $("#dtitle").html(data.title);
					   $("#dsynopsis").html(data.synopsis);
					   $("#dsortCode").html(data.sortCode);
					   $("#dfirstWord").html(data.firstWord);
					   $("#dphoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.brandBigImageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='100px' height='50px' />");
					   $("#dphoto2").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.brandImageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='100px' height='50px' />");
					   if(data.isShow=="0"){
						   $("#disShow").html("<font class='color_002'>否</font>");
					   }else{
						   $("#disShow").html("<font class='color_001'>是</font>");
					   }
					   if(data.isRecommend=="0"){
						   $("#disRecommend").html("<font class='color_002'>否</font>");
					   }else{
						   $("#disRecommend").html("<font class='color_001'>是</font>");
					   }
					   if(data.isHomePage=="0"){
						   $("#disHomePage").html("<font class='color_002'>否</font>");
					   }else{
						   $("#disHomePage").html("<font class='color_001'>是</font>");
					   }
				   }
			});
		}
    	function query(){
    		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,brandName:$("#qbrandName").val(),isShow:$("#qisShow").val(),isRecommend:$("#qisRecommend").val(),isHomePage:$("#qisHomePage").val(),firstWord:$("#qfirstWord").val()};
    	  	$("#tt").datagrid("load",queryParams); 
    	  	pageSplit(pageSize,queryParams);//调用分页函数 
        }
    	function reset(){
    		$("#qbrandName").val("");
           	$("#qisShow").val("");
        	$("#qisRecommend").val("");
        	$("#qisHomePage").val("");
        	$("#qfirstWord").val("");
    	}
    </script>
    <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  </head>
  <body>
  	  <jsp:include page="../../util/item.jsp"/>
  	  <div class="main">
	   <table class="searchTab">
	    	<tr>
	    		<td class="search_toright_td"  style="width:80px;">机构名称：</td>
	    		<td class="search_toleft_td"  style="width:130px;"><input type="text" id="qbrandName" name="brandName" style="width:120px;"/></td>
	    		<td class="search_toright_td" style="width: 65px;">是否显示：</td>
	    		<td class="search_toleft_td" style="width:80px;"><select id="qisShow" class="querySelect">
	              <option value="-1">--请选择--</option>
	              <option value="0">否</option>
	              <option value="1">是</option>
	            </select></td>
	    		<td class="search_toright_td" style="width:95px;">机构频道推荐：</td>
	    		<td class="search_toleft_td" style="width: 80px;"><select id="qisRecommend" class="querySelect">
		              <option value="-1">--请选择--</option>
		              <option value="0">否</option>
		              <option value="1">是</option>
		            </select></td>
	    		<td class="search_toright_td" style="width:120px;">机构首页机构推荐：</td>
	    		<td class="search_toleft_td" style="width:80px;"><select id="qisHomePage" class="querySelect">
		              <option value="-1">--请选择--</option>
		              <option value="0">否</option>
		              <option value="1">是</option>
		            </select></td>
	    		<td class="search_toright_td" style="width:70px;">机构归类：</td>
	    		<td class="search_toleft_td" style="width:95px;"><select id="qfirstWord" class="querySelect">
	    		 	  <option value="-1">--请选择--</option>
		              <option value="0">0</option>
		              <option value="1">1</option>
		              <option value="2">2</option>
		              <option value="3">3</option>
		              <option value="4">4</option>
		              <option value="5">5</option>
		              <option value="6">6</option>
		              <option value="7">7</option>
		              <option value="8">8</option>
		              <option value="9">9</option>
		              <option value="A">A</option>
		              <option value="B">B</option>
		              <option value="C">C</option>
		              <option value="D">D</option>
		              <option value="E">E</option>
		              <option value="F">F</option>
		              <option value="G">G</option>
		              <option value="H">H</option>
		              <option value="I">I</option>
		              <option value="J">J</option>
		              <option value="K">K</option>
		              <option value="L">L</option>
		              <option value="M">M</option>
		              <option value="N">N</option>
		              <option value="O">O</option>
		              <option value="P">P</option>
		              <option value="Q">Q</option>
		              <option value="R">R</option>
		              <option value="S">S</option>
		              <option value="T">T</option>
		              <option value="U">U</option>
		              <option value="V">V</option>
		              <option value="W">W</option>
		              <option value="X">X</option>
		              <option value="Y">Y</option>
		              <option value="Z">Z</option>
		            </select></td>
	    		<td class="search_toleft_td">
	    			<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
	    		</td>
	    		<td></td>
	    	</tr>
	    </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		   <!-- 详情页 -->
		  <jsp:include page="detailBrand.jsp"/>
		</div>
		</div>
  </body>
</html>
