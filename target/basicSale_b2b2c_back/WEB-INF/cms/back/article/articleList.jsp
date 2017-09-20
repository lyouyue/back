<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>新闻信息</title>
    <jsp:include page="../../../../WEB-INF/util/import.jsp"/>
    <!-- kindEdite -->
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
	<!-- kindEdite end-->
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/base64.js"></script>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/swfUpload/swfupload.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/swfUpload/swfupload.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/swfUpload/swfupload.queue.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/swfUpload/fileprogress.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/swfUpload/handlers.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/swfUpload/uploadConfig.js"></script>
    <script type="text/javascript">
    $(function(){
			//表单提交和 验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		    	 fillHiddenUrlsValue();//将urls填充到隐藏域中 函数在handlers.js中 
		    	 var imageUrl=$("#imageUrl1").val();
		    	 if(imageUrl != null && imageUrl !=''){
		       $(document).ready(
	              function() {  
	            	 $("#contentBK").val(editor.html());
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/cmsArticle/saveOrUpdateArticle.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) {
                        	 location.reload();
//                         	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
// 							 $("#tt").datagrid("reload"); //删除后重新加载列表
                         }
                     };  
                     $("#form1").ajaxSubmit(options); 
                     $("input.button_save").attr("disabled","disabled");//防止重复提交
                  });
		    	 }else{
		    		 $("#mymessage1").html("<font color='Red'>请上传图片！</font>");
		    	 }
		       }
		    });
			
		   //审核新闻，修改审核状态 
			$("#updateIsPass").click(function(){
			    var articleId = $("#view_articleId").val();
				var isPass = $("input[name='cmsArticle.isPass'][checked='checked']").val();
				$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/cmsArticle/updateIsPass.action",
				   data: {articleId:articleId,isPass:isPass},
				   success: function(data){
					      if(data.isSuccess=="true"){
					    	  $("#tt").datagrid("reload"); //删除后重新加载列表
					      }
					      closeWin();
				        }
		            });
				
			});
			
		   $("#tt").datagrid({//数据表格
				/* title:"新闻内容列表信息: <font color=blue>${categoryName}</font>",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/cmsArticle/listArticle.action?categoryId=${categoryId}",
				idField:"articleId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"新闻标题",width:150, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.articleId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					},
					<%--{field:"articleId",title:"新闻ID",width:60}, 
				
					{field:'articleType',title:'新闻类型',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "无";} 
	                        if(value=="1"){ return "文档";} 
	                        if(value=="2"){ return "图片";} 
	                        if(value=="3"){ return "视频 ";} 
	                        if(value=="4"){ return "音频";} 
                            }
               		},
					{field:'isEssence',title:'设置精华 ',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "普通";} 
	                        if(value=="1"){ return "精华";} 
                            }
               		},
					{field:'isOpenDiscuss',title:'是否开放评价 ',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "不开放";} 
	                        if(value=="1"){ return "开放";} 
                            }
               		},
					{field:'isDeal',title:'删除状态',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "正常";} 
	                        if(value=="1"){ return "回收站";} 
                            }
               		},
               		{field:'isPass',title:'审核状态 ',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<span style='color:yellow'>未审核</span>";} 
	                        if(value=="1"){ return "<span style='color:green'>已审核</span>";} 
	                        if(value=="2"){ return "<span style='color:red'>不通过</span>";} 
                            }
                 		},
					{field:'caozuo',title:'发送邮件 ',width:100, 
    				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
    	                        return "<a style='display:block;' id='"+rowData.articleId+"' onclick='listCustomer(this.id)'>发送邮件</a>";   
                            }
               		},
               		{field:"clickCount",title:"点击次数",width:100},
					 {field:'isDeal',title:'是否删除 ',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "正常";} 
	                        if(value=="1"){ return "回收站";} 
                            }
                 		},
                 		--%>
					{field:"categoryName",title:"分类名称",width:100},
					{field:"sortCode",title:"排序",width:100},
					        		
					{field:"isShow",title:"是否显示",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                    		if(value=="0"){ return "<font class='color_002'>不显示</font>";} 
                       		if(value=="1"){ return "<font class='color_001'>显示</font>";} 
                    	}
					}, 
					{field:"createTime",title:"创建时间",width:100}
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
						createWindow(890,450,"&nbsp;&nbsp;添加新闻","icon-add",false,"addOrEditWin",5);
						$(".ke-icon-fullscreen").click();
						$(".ke-icon-fullscreen").click();
					    $("#articleId").val("");
					    $("#fileId1").val("");
					    $("#imageUrl1").val("");
					    $("#photo1").html("");
					    $("#mymessage1").html("");
						//"content"为文本域的ID
						//KindEditor.html("#content",""); 
						editor.html("");
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
						var potoUploadRoot = "${fileUrlConfig.uploadFileVisitRoot}";
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(890,450,"&nbsp;&nbsp;修改新闻","icon-edit",false,"addOrEditWin",5);
							$(".ke-icon-fullscreen").click();
							$(".ke-icon-fullscreen").click();
							$("#fileId1").val("");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/cmsArticle/getArticleObject.action",
							   data: {id:rows[0].articleId},
							   success: function(data){
								   $("#articleId").val(data.cmsArticle.articleId);
								   $("#categoryId").val(data.cmsArticle.categoryId);
								   $("input[name='cmsArticle.articleType'][value='"+data.cmsArticle.articleType+"']").attr("checked",true);
								   $("#title").val(data.cmsArticle.title);
								   $("#brief").val(data.cmsArticle.brief);
								   //$("#content").val(data.cmsArticle.content);
								   $("#imageUrl1").val(data.cmsArticle.imgUrl); 
								   //"content"为文本域的ID
								   //发布人
								   $("#publishUser").val(data.cmsArticle.publishUser); 
								   //修改人
								   $("#modifyUser").val(data.cmsArticle.modifyUser); 
								   //创建时间
								   $("#updateTime").val(data.cmsArticle.updateTime); 
								   //seoTitle
								   $("#seoTitle").val(data.cmsArticle.seoTitle); 
								   $("#photo1").html("<img style='padding-top:10px' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.cmsArticle.imgUrl+"'onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='30px' height='30px' />");
								   $("#imgTrueName").val(data.cmsArticle.imgTrueName);
								   $("#outUrl").val(data.cmsArticle.outUrl);
								   $("#clickCount").val(data.cmsArticle.clickCount);
								   $("#keywords").val(data.cmsArticle.keywords);
								   $("#sortCode").val(data.cmsArticle.sortCode);
								   $("#isDeal").val(data.cmsArticle.isDeal);
								   $("input[name='cmsArticle.isEssence'][value='"+data.cmsArticle.isEssence+"']").attr("checked",true);
								   $("input[name='cmsArticle.isPass'][value='"+data.cmsArticle.isPass+"']").attr("checked",true);
								   $("input[name='cmsArticle.isOpenDiscuss'][value='"+data.cmsArticle.isOpenDiscuss+"']").attr("checked",true);
								   $("input[name='cmsArticle.isShow'][value='"+data.cmsArticle.isShow+"']").attr("checked",true);
								   $("#createTime").val(data.cmsArticle.createTime);
								   $("#isPass").val(data.cmsArticle.isPass);
								   
								  
								   //处理附件 的显示 begin
								   var htmlurls="";
								    //文档类型 
								    //1 无 
								    if(data.cmsArticle.articleType==0){
								       $("#acttId2").hide();
									   $("#acttId").hide();
								    }
								   //2处理音频，视频 
								   if(data.cmsArticle.articleType==3 ||data.cmsArticle.articleType==4){
				                       $("#acttId2").hide();
									   $("#acttId").show();
									   if(data.attList.length!=0){
										   for(var i=0;i<data.attList.length;i++){
											   if(i==0&&data.attList[i].attUrl!=null && data.attList[i].attUrl!=""){
												   $("#attUrls_0").val(data.attList[i].attUrl);
											   }else{
												   addInput(data.attList[i].attUrl);
											   }
										   }
									   }
									  
									   //3处理文档 ，图片 
								   }
								   else if(data.cmsArticle.articleType==1 || data.cmsArticle.articleType==2){
									    $("#acttId").hide();
									    $("#acttId2").show();
// 				                        $("#parentDiv").show();
// 				                        $("#fsUploadProgress").show();
										if(data.cmsArticle.articleType==1){
											multiFileUploadByType("doc");
										}else{
											multiFileUploadByType("img");
										}
									     var attUrls="";
									     for(var i=0;i<data.attList.length;i++){
									    	 attUrls+=data.attList[i].attUrl+",";
									     }
									     //去掉最后一个@ 
									     attUrls=attUrls.substr(0,attUrls.length-1);
									     $("#urls").val(attUrls);
								         //将已有附件初始化
								         //附件的 id 
								        var ids="";
								        if(data.attList.length!=0){
								        	 for(var i=0;i<data.attList.length;i++){
								        	 ids+=data.attList[i].attachmentId+",";
									     }
								        	 ids=ids.substr(0,ids.length-1);
								        	 initFJ("${pageContext.request.contextPath}/back/cmsArticleAtt/deleteAtt.action",ids,attUrls);
								        }
								       
								   }
								   //处理附件 的显示 end 
							   KindEditor.html("#content",data.cmsArticle.content);
							   editor.html(data.cmsArticle.content);
							   }
							});
						}
					}
				},"-",
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
											if(i==rows.length-1)ids+=rows[i].articleId;
											else ids+=rows[i].articleId+",";
										}
										$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/cmsArticle/deleteArticle.action",
										   data: {ids:ids},
										   success: function(data){
											   if(data.isSuccess=="true"){
											      $("#tt").datagrid("clearSelections");//删除后取消所有选项
											      if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
											   }else{
												   msgShow("系统提示", "<p class='tipInfo'>删除失败！</p>", "warning");  
											   }
										   }
										});
									}	
								}
							});
						}
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
			createWindow(890,450,"&nbsp;&nbsp;新闻详情","icon-edit",false,"detailWin",5);
			$.ajax({
               type: "POST",
               dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/cmsArticle/getArticleObject.action",
			   data: {id:id},
			   success: function(data){
//				   var potoUploadRoot = "<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>";
				   var potoUploadRoot = "${fileUrlConfig.uploadFileVisitRoot}";
				   // hidden 新闻主键 
				   $("#view_articleId").val(data.cmsArticle.articleId);
				   //显示图片
				   $("#view_photo").html("<img style='padding-top:10px;'  src='"+potoUploadRoot+data.cmsArticle.imgUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='30px' height='30px' />");
				   //新闻类型  
				   if(data.cmsArticle.articleType=="0"){
					   $("#view_articleType").html("无");
				   }
				   if(data.cmsArticle.articleType=="1"){
					   $("#view_articleType").html("文档 ");
				   }
				   if(data.cmsArticle.articleType=="2"){
					   $("#view_articleType").html("图片 ");
				   }
				   if(data.cmsArticle.articleType=="3"){
					   $("#view_articleType").html("视频 ");
				   }
				   if(data.cmsArticle.articleType=="4"){
					   $("#view_articleType").html("音频");
				   }
				    //是否为精华 
				    if(data.cmsArticle.isEssence=="0"){
				    	$("#view_isEssence").html("非精华 ");
				    }
				    if(data.cmsArticle.isEssence=="1"){
				    	$("#view_isEssence").html("精华 ");
				    }
				    //审核状态 
				   $("input[name='cmsArticle.isPass'][value='"+data.cmsArticle.isPass+"']").attr("checked",true);
				    //是否开放评价 
				   $("input[name='cmsArticle.isOpenDiscuss'][value='"+data.cmsArticle.isOpenDiscuss+"']").attr("checked",true);
				   if(data.cmsArticle.isOpenDiscuss=="0"){
					   $("#view_isOpenDiscuss").html("不开放 ");
				   }
				   if(data.cmsArticle.isOpenDiscuss=="1"){
					   $("#view_isOpenDiscuss").html("开放评价 ");
				   }
				   //是否显示 
				   $("input[name='cmsArticle.isShow'][value='"+data.cmsArticle.isShow+"']").attr("checked",true);
				    if(data.cmsArticle.isShow=="0"){
				    	$("#view_isShow").html("<font class='color_002'>不显示</font> ");
				    }
				    if(data.cmsArticle.isShow=="1"){
				    	$("#view_isShow").html("<font class='color_001'>显示</font>");
				    }
				   //标题
				   $("#view_title").html(data.cmsArticle.title);
				   //摘要 
				   $("#view_brief").html(data.cmsArticle.brief);
				   //seo关键词 
				   $("#view_keywords").html(data.cmsArticle.keywords);
				   //新闻内容 
				   $("#view_content").html(data.cmsArticle.content);
				   // 图片 路径 
				   $("#view_imgUrl").html(data.cmsArticle.imgUrl); 
				   //图片真实名称 
				   $("#view_imgTrueName").html(data.cmsArticle.imgTrueName);
				   //外网访问地址 
				   $("#view_outUrl").html(data.cmsArticle.outUrl);
				   //点击次数 
				   $("#view_clickCount").html(data.cmsArticle.clickCount);
				   //排序 
				   $("#view_sortCode").html(data.cmsArticle.sortCode);
				   //是否回收站 
				   $("#view_isDeal").val(data.cmsArticle.isDeal);
				   
				   //发布人
				   $("#view_publishUser").html(data.cmsArticle.publishUser); 
				   //修改人
				   $("#view_modifyUser").html(data.cmsArticle.modifyUser); 
				   //创建时间
				   $("#view_updateTime").html(data.cmsArticle.updateTime); 
				   //seoTitle
				   $("#view_seoTitle").html(data.cmsArticle.seoTitle); 
				   if(data.cmsArticle.isDeal="0"){
					   $("#view_isDeal").html("正常");
				   }
				   if(data.cmsArticle.isDeal="1"){
					   $("#view_isDeal").html("回收站");
				   }
				   //创建时间 
				   $("#view_createTime").html(data.cmsArticle.createTime);
				   //处理附件 的显示 begin
				   var htmlurls="";
				   //处理音频，视频 ,直接取数据库的数据 的 
				   if(data.cmsArticle.articleType==3 ||data.cmsArticle.articleType==4){
                       $("#view_acttId2").hide();
					   $("#view_acttId").show();
					   if(data.attList.length!=0){
						   for(var i=0;i<data.attList.length;i++){
							   if(i==0&&data.attList[i].attUrl!=null && data.attList[i].attUrl!=""){
								   $("#view_attUrls_0").html("地址："+data.attList[i].attUrl);
							   }else{
								   addAtturls(data.attList[i].attUrl);
							   }
						   }
					   }
					   //处理文档 ，图片 
				   }
				   else if(data.cmsArticle.articleType==1 || data.cmsArticle.articleType==2){
					    $("#view_acttId").hide();
                        $("#view_acttId2").show();
					     var attUrls="";
					     for(var i=0;i<data.attList.length;i++){
					    	 attUrls+=data.attList[i].attUrl+",";
					     }
					     //去掉最后一个@ 
					     attUrls=attUrls.substr(0,attUrls.length-1);
					     $("#view_urls").val(attUrls);
				         //准备做附件的  显示和下载  
					    if(attUrls!=null)fileHtml=initFJDownLoad(attUrls);
				        $("#attachmentsImgOrdoc").html(fileHtml);
				   }
				   //处理附件 的显示 end 
			   }
			});
			
		}
		 
		/*  //上传图片 
		function uploadPhoto() {
			$(document).ready(  
               function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/back/cmsArticle/uploadImage.action",
                        type : "post",  
                        dataType:"json",
                        success : function(data) {
	                        if(data.photoUrl=="false1"){
	                          $("#mymessage").html(" <font style='color:red'>请选择上传文件</font>");
	                        }else if(data.photoUrl=="false2"){
	                          $("#mymessage").html(" <font style='color:red'>请上传jpg、png、gif格式的文件 ！</font>");
	                        }else{
	                         
	                         $("#imgUrl").val(data.photoUrl);
	                         $("#photo").html("");
	                       	 $("#photo").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='120px' height='120px' />");
	                        } 
                        }
                    };
                   $("#photoForm").ajaxSubmit(options);
            });  
		} */
		 //初始化新闻附件 
		function initFJ(deleteActionUrl,ids,urls){//初始化已有附件列表
			if(urls!=null&&urls!=""){
				$("#fjInfo").css("display","");
				var idArr=ids.split(","); 
				var fjUrls=urls.split(","); 
				var htmlStr="<div style='margin-left:26px;font-weight: bolder;color:#385ea2'>原有文件:</div>";
				for(i=0;i<fjUrls.length;i++){
					fileSubmitUrl.push(fjUrls[i]);//将已有的附件加载到url数组中进行合并
					var fiUrl=fjUrls[i].split("@");
					var fileName=fiUrl[1];
					var deleteParams=deleteActionUrl+"_"+idArr[i]+"_"+fjUrls[i]+"_"+i;
					htmlStr+="<div id='fj_"+i+"' class='fjWrapper'><div style='float:left;margin-left: 10px'>"+fiUrl[1]+"</div>"+
					"<div  style='float:right;margin-right: 10px'><a id='"+deleteParams+"' href='#' onclick='deleteExsitsFJ(this.id)'>删除</a></div></div>";
				}
				$("#fjInfo").html(htmlStr);
			}
		}
		  function query(){
			var title = $("#s_title").val();
			var articleType = $("#s_articleType").val();
			var isDeal = $("#s_isDeal").val();
			var isEssence = $("#s_isEssence").val();
			var isPass = $("#s_isPass").val();
			var isOpenDiscuss = $("#s_isOpenDiscuss").val();
			var isShow = $("#s_isShow").val();
			if(title==""||title==null){
				 title="none";
			}
			//params =title+"_"+articleType+"_"+isDeal+"_"+isEssence+"_"+isPass+"_"+isOpenDiscuss+"_"+isShow;
			var params =title+"_"+isShow;
			
			$('#tt').datagrid('reload',{params:params}); 
			pageSplit(pageSize,{params:params});//调用分页函数
		 }
		  
		  function selectType(obj){
			  var typeValue = obj.value;
			  if(typeValue=="1"){
				  $("#acttId").hide();
				  multiFileUploadByType("doc");
				  $("#acttId2").show();
			  }
			  if(typeValue=="2"){
				  $("#acttId").hide();
				  multiFileUploadByType("img");
				  $("#acttId2").show();
			  }
			  if(typeValue=="3"||typeValue=="4" ){
				  $("#acttId").show();
				  $("#acttId2").hide();
			  }
			  if(typeValue=="0" ){
				  $("#acttId").hide();
				  $("#acttId2").hide();
			  }
			  
		  }
		    //一个或多个视频、音频的添加 
		    var count=1;
		    function addInput(urlValue){
                var id="mainDiv_"+count;
                if(urlValue==undefined){
					var htmlStr="<div id='"+id+"'><input type='text' id='attUrls_"+count+"' name='attUrls' value='' />&nbsp;<input type='button' value='删除' onclick=\"deleteAttUrls('"+id+"')\" /></div>"
					$("#mainDiv").append(htmlStr);
                }else{
					var htmlStr="<div id='"+id+"'><input type='text' id='attUrls_"+count+"' name='attUrls' value="+urlValue+" />&nbsp;<input type='button' value='删除' onclick=\"deleteAttUrls('"+id+"')\" /></div>"
					$("#mainDiv").append(htmlStr);
                }
				count++;
		    }
		    // 一个或多个视频、音频的详细  
		    function addAtturls(urlValue){
                if(urlValue==undefined){
					var htmlStr="<div>地址："+urlValue+"</div>"
					$("#view_mainDiv").append(htmlStr);
                }else{
					var htmlStr="<div>地址："+urlValue+"</div>"
					$("#view_mainDiv").append(htmlStr);
                }
		    }
		    
		    //视频、音频的删除 
		    function deleteAttUrls(id){
		    	$("#"+id).remove();
		    }
		    
		    //查询会员信息 发送邮件-------------------------------------begin-------------------------------------------
			 function listCustomer(id){
				 $("#id").val(id);
				 $("#cusList").html("");
				 createWin(750,450,"&nbsp;&nbsp;查看会员","icon-edit",false,"cusWin",10);
				 $("#cusList").datagrid({
					title:"会员列表信息:",
					iconCls:"icon-save", 
					width:"auto",
					height:"auto",
					fitColumns: true,//宽度自适应
					align:"center",
					loadMsg:"正在处理，请等待......",
					//nowrap: false,//true是否将数据显示在一行
					striped: true,//true是否把一行条文化
					url:"${pageContext.request.contextPath}/back/cmsArticle/listCustomer.action",
					idField:"customerId",//唯一性标示字段
					frozenColumns:[[//冻结字段
					    {field:"ck",checkbox:true}
					]],
					columns:[[//未冻结字段
			            {field:"loginName",title:"会员名称",width:150,
							formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
			                	return rowData.loginName;  
			         	  	}  
						}
					]],
					pagination:true,//显示分页栏
					rownumbers:true,//显示行号   
					singleSelect:true,//true只可以选中一行
					toolbar:[{//工具条
						text:"发送邮件",
						iconCls:"icon-add",
						handler:function(){
							var id = $("#id").val();
							var rows = $("#cusList").datagrid("getSelections");//找到所有选中的行
							if(rows.length<=0){
								msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
							}else{
								$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要发送邮件吗?</p>",function(data){
									if(data){//判断是否删除
										if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
											var ids="";
											for(i=0;i<rows.length;i++){
												if(i==rows.length-1)ids+=rows[i].customerId;
												else ids+=rows[i].customerId+",";
											}
											$.ajax({
											   type: "POST",
											   dataType: "JSON",
											   url: "${pageContext.request.contextPath}/back/cmsArticle/sendMail.action",
											   data: {ids:ids,id:id},
											   success: function(data){
												   if(data.isSuccess=="true"){
													  msgShow("系统提示", "<p class='tipInfo'>发送成功！</p>", "warning");  
												   }else{
													  msgShow("系统提示", "<p class='tipInfo'>发送失败！</p>", "warning");  
												   }
											   }
											});
										}	
									}
								});
							}
						}
					},"-",{
						text:"向所有会员发送邮件",
						iconCls:"icon-add",
						handler:function(){
							var id = $("#id").val();
							$.ajax({
							   type: "POST",
							   dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/cmsArticle/sendMails.action",
							   data: {id:id},
							   success: function(data){
								   if(data.isSuccess=="true"){
									  msgShow("系统提示", "<p class='tipInfo'>发送成功！</p>", "warning");  
								   }else{
									  msgShow("系统提示", "<p class='tipInfo'>发送失败！</p>", "warning");  
								   }
							   }
							});
						}
					},"-",{text:"刷新",
						iconCls:"icon-reload",
						handler:function(){
							$("#cusList").datagrid("clearSelections");//删除后取消所有选项
							$("#cusList").datagrid("reload");
						}
					}]
				 });
                 pageSplit(pageSize);//调用分页函数，取代以下自定义代码
				 /*var p = $("#cusList").datagrid("getPager");//分页处理程序
					$(p).pagination({
						pageSize: 10,//每页显示的记录条数，默认为10
				        pageList: [5,10,15,20],//可以设置每页记录条数的列表
				        beforePageText: "第",//页数文本框前显示的汉字
				        afterPageText: "页    共 {pages}页",
				        displayMsg: "当前显示 <font color=red style='font-weight: bolder;'>{from} - {to}</font> 条记录   共<font style='font-weight: bolder;' color=red> {total} </font>条记录",
						onSelectPage:function(pageNumber, pageSize){
				        	$(this).pagination("loading");
				        	$("#cusList").datagrid("reload",{currentPage:pageNumber,pageSize:pageSize});
				        	$(this).pagination("loaded");
						}

					});*/
			 }
			 function createWin(width,height,title,iconCls,inline,winId){
	   			$("#win1").css("display","");
				$("#win1").window({
					title:title,iconCls:iconCls,minimizable:false,maximizable:true,closable:true,shadow:false,
					closed:true,draggable:true,resizable:true,inline:inline,width:width,height:height,modal:true,top:30
				}).window("open");
	   		}
			//查询会员信息 发送邮件-------------------------------------end-------------------------------------------
			
			function reset(){
				$("#s_title").val("");
		       	$("#s_isShow").val("");
			}
</script>
</head>
<body  >
	<table   class="searchTab">
		<tr>
			<td class="search_toright_td"   style="width:80px;"> 新闻标题：</td>
			<td class="search_toleft_td" style="width:155px;;"><input type="text" id="s_title" name="s_title" class="searchTabinput"/></td>
			<td class="search_toright_td"  style="width:70px;"> 是否显示：</td>
			<td class="search_toleft_td" style="width:105px;">
				<select name="s_isShow" id="s_isShow" class="querySelect">
					<option value="none">--请选择--</option>
					<option value="0">不显示</option>
					<option value="1">显示</option>
				 </select>
			</td>
			<td class="search_toleft_td">
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
				<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
			 </td>
	</table>
		<!-- 数据表单   -->
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<!-- 添加或修改表单 -->
		<jsp:include page="addOrEditor.jsp"/>
		<!-- 详细查看审核 -->
		<jsp:include page="detail.jsp"/>
		</div>
		<div id="win1" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">	  
		  <jsp:include page="customerList.jsp"></jsp:include>
		</div>
  </body>
</html>
