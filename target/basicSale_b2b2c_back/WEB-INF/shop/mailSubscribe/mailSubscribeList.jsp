<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>邮件订阅信息</title>
     <jsp:include page="../../util/import.jsp"/>
     	<!-- kindEdite -->
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
		<!-- kindEdite end-->
				
	    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/base64.js"></script>
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
    	       $(document).ready(
    	          function() {  
    	        	 $("#contentBK").val(editor.html());
    	             var options = {  
    	                 url : "${pageContext.request.contextPath}/back/mailSubscribe/saveOrUpdateMailSubscribe.action",  
    	                 type : "post",  
    	                 dataType:"json",
    	                 success : function(data) {
    	                	 location.reload();
//    	                 	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
//    						 $("#tt").datagrid("reload"); //删除后重新加载列表
    	                 }
    	             };  
    	             $("#form1").ajaxSubmit(options); 
    	             $("input.button_save").attr("disabled","disabled");//防止重复提交
    	          });
    	       }
    	    });
    	
    	
		   $("#tt").datagrid({//数据表格
				title:"邮件订阅列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/mailSubscribe/listMailSubscribes.action",
				idField:"articleId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"文章标题",width:150, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.articleId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
		         	  }  
					}, 
					{field:"isSend",title:"是否发送",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                    		if(value=="0"){ return "未发送";} 
                       		if(value=="1"){ return "已发送";} 
                        }
               		},
					{field:"operate",title:"发送邮件",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        return "<a style='display:block;' id='"+rowData.articleId+"' onclick='listCustomer(this.id)'>发送邮件</a>";   
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
						createWindow(830,450,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$(".ke-icon-fullscreen").click();
						$(".ke-icon-fullscreen").click();
					    $("#articleId").val("");
						//"content"为文本域的ID
						//KindEditor.html("#content",""); 
						editor.html("");
					}
				},"-",{
					text:"修改", 
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(830,450,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
							$(".ke-icon-fullscreen").click();
							$(".ke-icon-fullscreen").click();
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/mailSubscribe/getMailSubscribeObject.action",
							   data: {id:rows[0].articleId},
							   success: function(data){
								   $("#articleId").val(data.mailSubscribe.articleId);
								   //标题
								   $("#title").val(data.mailSubscribe.title);
								   //摘要 
								   $("#brief").val(data.mailSubscribe.brief);
								   //是否发送
								   $("#isSend").val(data.mailSubscribe.isSend);
								   //发布人
								   $("#publishUser").val(data.mailSubscribe.publishUser); 
								   //创建时间
								   $("#createTime").val(data.mailSubscribe.createTime);
							   	   KindEditor.html("#content",data.mailSubscribe.content);
							       editor.html(data.mailSubscribe.content);
							   }
							});
						}
					}
				},"-",{
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
										   url: "${pageContext.request.contextPath}/back/mailSubscribe/deleteMailSubscribe.action",
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
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit();//调用分页函数
		});
        
		function showDetailInfo(id){
			createWindow(850,450,"&nbsp;&nbsp;查看、审核 ","icon-edit",false,"detailWin");
			$.ajax({
               type: "POST",
               dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/mailSubscribe/getMailSubscribeObject.action",
			   data: {id:id},
			   success: function(data){
				   //标题
				   $("#view_title").html(data.mailSubscribe.title);
				   //摘要 
				   $("#view_brief").html(data.mailSubscribe.brief);
				   //文章内容 
				   $("#view_content").html(data.mailSubscribe.content);
				   //是否发送
				   if(data.mailSubscribe.isSend=="0"){
					   $("#view_isSend").html("未发送");
				   }
				   if(data.mailSubscribe.isSend=="1"){
					   $("#view_isSend").html("已发送");
				   }
				   //发布人
				   $("#view_publishUser").html(data.mailSubscribe.publishUser); 
				   //修改人
				   $("#view_modifyUser").html(data.mailSubscribe.modifyUser); 
				   //创建时间
				   $("#view_createTime").html(data.mailSubscribe.createTime);
				   //修改时间 
				   $("#view_updateTime").html(data.mailSubscribe.updateTime); 
			   }
			});
		}
		 
		 //上传图片 
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
		}
		 
		function query(){
			var title = $("#s_title").val();
			var isSend = $("#s_isSend").val();
			 if(title==""||title==null){
				 title="none";
			 }
			//params =title+"_"+articleType+"_"+isDeal+"_"+isEssence+"_"+isPass+"_"+isOpenDiscuss+"_"+isShow;
			var params =title+"_"+isSend;
			
			$('#tt').datagrid('reload',{params:params}); 
			pageSplit(pageSize,{params:params});//调用分页函数
		 }
		  
		    //查询会员信息 发送邮件-------------------------------------begin-------------------------------------------
			 function listCustomer(id){
				 $("#id").val(id);
				 $("#cusList").html("");
				 createWin(750,450,"&nbsp;&nbsp;查看","icon-edit",false,"cusWin");
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
					url:"${pageContext.request.contextPath}/back/mailSubscribe/listCustomer.action",
					idField:"customerId",//唯一性标示字段
					frozenColumns:[[//冻结字段
					    {field:"ck",checkbox:true}
					]],
					columns:[[//未冻结字段
			            {field:"loginName",title:"会员名称",width:150,
							formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
			                	return rowData.loginName;  
			         	  	}  
						},
						{field:"email",title:"邮箱",width:150 
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
							}else if(rows.length>20){
								msgShow("系统提示", "<p class='tipInfo'>一次最多只能发送20个会员！</p>", "warning");
							}else{
								$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要发送邮件吗?</p>",function(data){
									if(data){//判断是否删除
										msgShow("系统提示", "<p class='tipInfo'>邮件正在发送！</p>", "warning");  
										if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
											var ids="";
											for(i=0;i<rows.length;i++){
												if(i==rows.length-1)ids+=rows[i].customerId;
												else ids+=rows[i].customerId+",";
											}
											$.ajax({
											   type: "POST",
											   dataType: "JSON",
											   url: "${pageContext.request.contextPath}/back/mailSubscribe/sendMail.action",
											   data: {ids:ids,id:id},
											   success: function(data){
												   if(data.isSuccess=="true"){
  									                  $("#cusList").datagrid("unselectAll");//删除后取消所有选项 
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
					}/* ,"-",{
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
									  $.messager.alert("发送结果：","发送成功！"); 
								   }else{
									  $.messager.alert("发送结果：","发送失败！"); 
								   }
							   }
							});
						}
					} */,"-",{text:"刷新",
						iconCls:"icon-reload",
						handler:function(){
							$("#cusList").datagrid("clearSelections");//删除后取消所有选项
							$("#cusList").datagrid("reload");
						}
					}]
				 });
                 pageSplit(pageSize);//调用分页函数，取代以下自定义代码
				 /*var p = $('#cusList').datagrid('getPager');//分页处理程序
					$(p).pagination({
						pageSize: 10,//每页显示的记录条数，默认为10  
				        pageList: [5,10,15,20],//可以设置每页记录条数的列表   
				        beforePageText: '第',//页数文本框前显示的汉字   
				        afterPageText: '页    共 {pages}页',  
				        displayMsg: '当前显示 <font color=red style="font-weight: bolder;">{from} - {to}</font> 条记录   共<font style="font-weight: bolder;" color=red> {total} </font>条记录',
						onSelectPage:function(pageNumber, pageSize){
				        	$(this).pagination('loading'); 
				        	$('#cusList').datagrid('reload',{currentPage:pageNumber,pageSize:pageSize}); 
				        	$(this).pagination('loaded'); 
						}
			
					});*/
			 }
		    
			 function createWin(width,height,title,iconCls,inline,winId){
	   			$('#win1').css("display","");
				$('#win1').window({
					title:title,iconCls:iconCls,minimizable:false,maximizable:true,closable:true,shadow:false,
					closed:true,draggable:true,resizable:true,inline:inline,width:width,height:height,modal:true,top:30
				}).window('open');
	   		}
			 
			//查询会员信息 发送邮件-------------------------------------end-------------------------------------------
			function a(){
				window.locking();
			}
    </script>
  </head>
  
  <body>
  <!-- 查询框  -->
  <div style="width: 99%">
	   <table   style="border:1px solid #99BBE8;text-align: center;" width="100%">
	       <tr>
		          <td class="toright_td">标题：</td>
		          <td class="toleft_td"><input type="text" id="s_title" name="s_title"/></td>
	              <td class="toright_td">是否发送：</td>
		          <td class="toleft_td">
		              <select name="s_isSend" id="s_isSend">
		               <option value="none">--请选择--</option>
		               <option value="0">未发送</option>
		               <option value="1">已发送</option>
		             </select>
		          </td>
		      	  <td class="toright_td">&nbsp;</td>
	         	  <td class="toleft_td">
	              <a href="javascript:query();" id="btn1" iconCls="icon-search" >
	              <img src="${fileUrlConfig.sysFileVisitRoot_back}css/themes/icons/search.png" style="border: none;vertical-align: middle;"/>查询</a>
	             </td>
	        </tr>   
	   </table>
	    <!-- 数据表单   -->
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  <!-- 添加或修改表单 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详细  查看 审核 -->
		  <jsp:include page="detail.jsp"/>
		</div>
		<div id="win1" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">	  
		  <jsp:include page="customerList.jsp"></jsp:include>
		</div>
		<div id="divDisable" style="display: none;width:expression(document.body.offsetWidth);height:expression(document.body.offsetHeight); z-index: 1000; position: absolute;left: 0px; top: 0px;filter:alpha(opacity=50); background-color:White"></div>
		<br/><br/><br/><br/> 
	  </div>

  </body>
</html>
