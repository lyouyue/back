<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>草稿箱</title>
     <jsp:include page="../../../util/import.jsp"/>
     <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
			//表单提交和 验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
	            	 var flag = true;
	            	 if($("#toMemberId2").is(":checked")){
			    	     var str = $("#toMemberId").val();
			    	     if(str==""){
			    	    	 flag = false;
			    	     }
			    	     $("#toMemberId2").val(str); 
	            	 }
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/messageCenter/saveOrUpdateMessageCenter.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) {
                        	if(data.isSuccess == "true"){
                				location.reload();
                        		$("#tt").datagrid("clearSelections");//删除后取消所有选项
 								$("#tt").datagrid("reload"); //删除后重新加载列表
 								//$("input.button_save").attr("disabled","disabled");
                			}
                    		if(data.isSuccess == "false"){
                    			msgShow("系统提示", "<p class='tipInfo'>以下会员不存在</p><p class='tipInfo'>"+data.sb2+"</p>", "warning");
                    		}
                         }
                     };  
                     if(flag){
                    	 $("#form1").ajaxSubmit(options); 
                     }else{
                    	 msgShow("系统提示", "<p class='tipInfo'>请输入收件人！</p>", "warning");
                     }
                  });
		       }
		    });
		   $("#tt").datagrid({//数据表格
				title:"系统消息草稿箱:",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/messageCenter/listDraftsMessage.action",
				idField:"messageId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"messageTitle",title:"主题",width:150, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.messageId+"' onclick='showDetailInfo(this.id);'>"+rowData.messageTitle+"</a>";  
		         	  }  
					}, 
					{field:'createDate',title:'创建时间',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                       	return rowData.createDate;
                            }
                 		}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
					if("send".equals((String)functionsMap.get(purviewId+"_send"))){
				%>
					{
					text:"立即发送", 
					iconCls:"icon-redo",
					handler:function(){
						$("input.button_save").removeAttr("disabled");
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(750,450,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/messageCenter/getMessageCenterObject.action",
							   data: {id:rows[0].messageId},
							   success: function(data){
								   $("#messageId").val(data.messageCenter.messageId);
								   $("#fromMemberId").val(data.messageCenter.fromMemberId);
								   $("#fromMemberName").val(data.messageCenter.fromMemberName);
								   $("#toMemberName").val(data.messageCenter.toMemberName);
								   $("#messageOpen").val(data.messageCenter.messageOpen);
								   $("#messageState").val(data.messageCenter.messageState);
								   $("#messageType").val(data.messageCenter.messageType);
								   $("#messageIsMore").val(data.messageCenter.messageIsMore);
								   $("#ip").val(data.messageCenter.ip);
								   if(data.messageCenter.toMemberId=="all"){
									   $("#toMemberId1").attr("checked",true);
									   $("#toMemberId2").removeAttr("checked");
								   }else{
									   $("#toMemberId2").attr("checked","checked");
									   $("#toMemberId1").removeAttr("checked");
									   $("#toMemberId").val(data.messageCenter.toMemberName).removeAttr("disabled").css("color","black");
								   }
								   $("#messageTitle").val(data.messageCenter.messageTitle);
								   $("#content").val(data.messageCenter.content);
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
											if(i==rows.length-1)ids+=rows[i].messageId;
											else ids+=rows[i].messageId+",";
										}
										$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/messageCenter/deleteDriftsMessage.action",
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
			createWindow(750,450,"&nbsp;&nbsp;查看 ","icon-edit",false,"detailWin");
			$.ajax({
               type: "POST",
               dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/messageCenter/getMessageCenterObject.action",
			   data: {id:id},
			   success: function(data){
				   $("#view_toMemberName").html(data.messageCenter.toMemberName);
				   $("#view_messageTitle").html(data.messageCenter.messageTitle);
				   $("#view_content").html(data.messageCenter.content);
				   if(data.messageCenter.messageSendState==1){
					   $("#view_messageSendState").html("立即发送");
				   }
				   if(data.messageCenter.messageSendState==2){
					   $("#view_messageSendState").html("保存草稿");
				   }
			   }
			});
		}
function query(){
	var messageTitle = $("#s_messageTitle").val();
	if(messageTitle==""){
		messageTitle = "none";
	}
	var startDate = $("#startDate").val();
	if(startDate==""){
		startDate = "none";
	}
	var endDate = $("#endDate").val();
	if(endDate==""){
		endDate = "none";
	}
	params = messageTitle+"_"+startDate+"_"+endDate;
	$('#tt').datagrid('reload',{params:params}); 
	pageSplit();//调用分页函数 方法在common.js中  显式分页栏 
}
    </script>
  </head>
  
  <body>
  <!-- 查询框  -->
  <div style="width: 99%">
	   <table   style="border:1px solid #99BBE8;text-align: center;" width="100%">
	       <tr>
		          <td class="toright_td">消息标题：</td>
		          <td class="toleft_td"><input type="text" id="s_messageTitle" name="s_messageTitle"/></td>
		          <td class="toright_td">创建时间：</td>
		          <td class="toleft_td">&nbsp;
		            <input id="startDate" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'endDate\')}'})"/>-
		            <input id="endDate" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'startDate\')}'})"/>    
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
		  	<jsp:include page="editorMessage.jsp"></jsp:include>
		  	<jsp:include page="detail.jsp"></jsp:include>
		</div>
		<br/><br/><br/><br/> 
	  </div>
  </body>
</html>
