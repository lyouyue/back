<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>信息列表页面</title>
    <jsp:include page="../../../../WEB-INF/util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"信息列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/cmsInformation/listCmsInformation.action",
				idField:"informationId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"标题",width:120, formatter:function(value,rowData,rowIndex){//function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		            	return "<a style='display:block;' id='"+rowData.informationId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					},
					{field:"categoryName",title:"信息分类",width:100},
                 	{field:"publishUser",title:"发布人 ",width:100},
					{field:"isShow",title:"是否显示 ",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "不显示";} 
	                        if(value=="1"){ return "显示";} 
                            }
                 	},
					{field:"createTime",title:"创建时间" ,width:100},
					{field:"updateTime",title:"修改时间" ,width:100}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(850,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("input.button_save").removeAttr("disabled");
						$(".ke-icon-fullscreen").click();
						$(".ke-icon-fullscreen").click();
						$("#photo").html("");
						$("#fileId").val(null);
						//清空ke编辑器中的值
						KindEditor.instances[0].html('');
					}
				},"-",
				{
					text:"修改", 
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(850,500,"&nbsp;&nbsp;修改","icon-add",false,"addOrEditWin");
							$("input.button_save").removeAttr("disabled");
							$(".ke-icon-fullscreen").click();
							$(".ke-icon-fullscreen").click();
							$("#fileId").val(null);
							//清空ke编辑器中的值
							//KindEditor.instances[0].html('');
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/cmsInformation/getCmsInformationObject.action",
							   data: {informationId:rows[0].informationId},
							   success: function(data){
								   $("#informationId").val(data.informationId);
								   $("#categoryId").val(data.categoryId);
								   $("#cityName").val(data.cityName);
								  /*  var d = data.districtList;
									var xiaoquHtml2 = "<option value=\"0\">请选择小区</option>";
									$.each(d,function(k,v){
							    		var districtName = v.districtName;
							    		xiaoquHtml2+="<option value=\""+districtName+"\">"+districtName+"</option>";
							    	});
								   $("#districtName").html(xiaoquHtml2); */
								   $("#districtName").val(data.districtName);
								   $("#title").val(data.title);
								   $("#brief").val(data.brief);
								   $("#content").val(data.content);
								   $("#createTime").val(data.createTime);
								   $("#publishUser").val(data.publishUser);
								   $("#author").val(data.author);
								   $("#imageUrl").val(data.imgUrl);
								   if(data.imgUrl!=null && data.imgUrl!=""){
										  $("#photo").html("<img  src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.imgUrl+"' width='120px' height='120px' />");
									   }else{
									      $("#photo").text("图片不存在");
									   }
								   $("#outUrl").val(data.outUrl);
								   $("#isShow_"+data.isShow).attr("checked",true);
								   //向ke编辑器中的初始化赋值
									KindEditor.instances[0].html(data.content);  
							   }
							});
						}
					}
				},"-",
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
										for(var i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].informationId;
											else ids+=rows[i].informationId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/cmsInformation/deleteCmsInformation.action",
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
				},"-",{text:"刷新",
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
			createWindow(700,450,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
			$.ajax({
				   type: "POST",
				   url: "${pageContext.request.contextPath}/back/cmsInformation/getCmsInformationObject.action",
				   data: {informationId:id},
				   dataType: "JSON",
				   success: function(data){
					   //显示图片 
					   if(data.imgUrl!=null && data.imgUrl!=""){
						  var uploadFileVisitRoot = "<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>";
						  $("#view_photo").html("<img src='"+uploadFileVisitRoot+data.imgUrl+"' width='120px' height='120px' />");
					   }else{
					      $("#view_photo").text("图片不存在");
					   }
					  // $("#dimgUrl").html("<img  src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.imgUrl+"' width='120px' height='120px' />");
					   $("#dtitle").html(data.title);
					   $("#dcategoryName").html(data.categoryName);
					   $("#dbrief").html(data.brief);
					   $("#dcontent").html(data.content);
					   $("#dcityName").html(data.cityName);
					   $("#ddistrictName").html(data.districtName);
					   $("#dauthor").html(data.author);
					   $("#doutUrl").html(data.outUrl);
					   if(data.isShow=="0"){
						   $("#disShow").html("未显示");
					   }else{
						   $("#disShow").html("显示");
					   }
					   $("#dcreateTime").html(data.createTime);
					   $("#dupdateTime").html(data.updateTime);
					   $("#dpublishUser").html(data.publishUser);
					   $("#dmodifyUser").html(data.modifyUser);
				   }
					   
			});
		}
		
		function query(){
			queryParams={pageSize:pageSize,currentPage:currentPage,title:$("#title1").val(),isShow:$("#isShow1").val(),categoryId:$("#categoryId1").val()};
			$("#tt").datagrid("clearSelections");//删除后取消所有选项
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		function reset(){
			$("#title1").val("");
			$("#isShow1").val("");
			$("#categoryId1").val("");
		}
    </script>
  </head>
  
  <body>
	  	<table width="100%;" style="border:1px solid #99BBE8;text-align: center;">
	  			<tr>
			  		<td><span class="querybtn" style="font-size: 12px;">标题：<input type="text" style="height: 16px;width: 160px;" id="title1" /></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  		</td>
			  		 <td><span class="querybtn" style="font-size: 12px;">信息分类：<select id="categoryId1">
			           <option value="-1"  selected="selected">请选择分类</option>
			             <s:iterator value="#request.cmsInformationCategoryList">
						  	<option value="<s:property value="informationCategoryId"/>"><s:property value="categoryName"/></option>
						  </s:iterator>
			           </select></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  		</td> 
			  		<td><span class="querybtn" style="font-size: 12px;">是否显示：<select id="isShow1">
	              <option value="-1">请选择</option>
	              <option value="0">不显示</option>
	              <option value="1">显示</option>
	            </select></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  		</td>
			  		
			  		<td>
			  		<span class=""><a href="javascript:query();" id="btn1" iconCls="icon-search"  >查询</a></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  		<span><a href="javascript:reset();" id="btn2" iconCls="icon-undo" >重置</a></span>
			  		</td>
			  	</tr>	
		</table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			 <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditInformation.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
