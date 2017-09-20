<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>管理员角色信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
			//表单验证
		   $(function(){//表单验证
		    $('#form1').form({
		       url:'${pageContext.request.contextPath}/back/usersActor/saveOrUpdateUsersActor.action',
		       onSubmit:function(){
		    	   $("input.button_save").attr("disabled",true);
		    	   if($(this).form('validate')){
		    		   return true;
		    	   }else{
		    		   $("input.button_save").attr("disabled",false); 
		    		   return false;
		    	   }

		       },
		       success:function(data){
		    	   closeWin();
		    	   $("#tt").datagrid("clearSelections");//删除后取消所有选项
		    	   $("#tt").datagrid("reload"); //删除后重新加载列表
		       	 //window.location.reload(); //提交表单后重新刷新本页
		       }
		   }); 
		  })
			
		   $("#tt").datagrid({//数据表格
				/* title:"管理员角色列表信息:&nbsp;&nbsp;<font color='blue'><s:property value='#request.userNameInfo'/></font>",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/usersActor/listUsersActorByUsersId.action?usersId=${usersId}",
				idField:"userActorId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"actorName",title:"角色名称",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(750,'auto',"&nbsp;&nbsp;添加管理员角色","icon-add",false,"addOrEditWin");
						$("#form1").css("display","");
						getActorList();//获取商品信息
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
											if(i==rows.length-1)ids+=rows[i].userActorId;
											else ids+=rows[i].userActorId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/usersActor/deleteUsersActor.action",
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
				},"-",{
					text:"返回管理员列表",
					iconCls:"icon-back",
					handler:function(){
						 /* location.href="${pageContext.request.contextPath}/back/users/gotoUsersPage.action"; */
						/* history.go(-1); */
						//返回上一页
						window.location.href = document.referrer;
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
    
    	function getActorList(){
			 var actorName=$("#actorName").val();
			 $.ajax({//获取MES牌号信息
				   type: "POST",
				   url: "${pageContext.request.contextPath}/back/usersActor/listActorInfo.action",
				   data: {actorName:actorName,usersId:${usersId}},
				   dataType: "JSON",
				   success: function(data){
					   var htmlStr="<tr style='font-weight: bolder;' class='titlebg'><td width='8px' class='toleft_td'><input style='margin:6px 0px 0px 25px;' type='checkbox' onclick='checkedAll(this)'></td><td width='250px' class='toleft_td'>&nbsp;&nbsp;角色名称</td></tr>";
					   for(var i=0;i<data.length;i++){
						   htmlStr+="<tr><td width='8px' class='toleft_td'><input style='margin:6px 0px 0px 25px;' type='checkbox' onclick='checkedOne(this)' class='actorInfos'  id='"+i+"' name='ids' value='"+data[i].actorId+"'></td>"+
						   "<td width='250px' class='toleft_td'>&nbsp;&nbsp;"+data[i].actorName+"</td>";
					   }
					   $("#subTalbe").html(htmlStr);
				   }
			});
		 }
    	// 选择所有
		function checkedAll(obj){//选中所有或者去掉所有选中的
			var isChecked=obj.checked;
		    if(isChecked){
		    	$(".actorInfos").each(function() {
		    	    $(this).attr("checked", true);
		    	    var idIndex=$(this).attr("id");
		    	});
		    }else{
		    	$(".actorInfos").each(function() {
		    	    $(this).attr("checked", false);
		    	    var idIndex=$(this).attr("id");
		    	});
		    }
		}
    	// 选择一个
		function checkedOne(obj){
			var idIndex=obj.id;
			var isOneChedcked=obj.checked;
			if(isOneChedcked){
		    }else{
		    }
		}
    	function reset1(){
    		$("#actorName").val("");
    	}
    </script>
    <style type="text/css">
   	 .querybtn a{height:28px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
    </style>
  </head>
  <body >
  <jsp:include page="../../util/item.jsp"/>
  <div class="main">
  		<table id="tt"></table>
  	</div>
  		<div id="win" style="display:none;">
  			<form id="form1" action="post">
  				<input id="usersId" type="hidden" name="usersActor.usersId" value="${usersId}" noclear="true">
  				<table align="center" class="addOrEditTable">
  					<tr>
  						<td class="toright_td"width="100px;">角色信息：</td>
  						<td class="toleft_td" height="10px;">
  							<div style="margin:10px 10px 0px 10px">
	  							  角色名称：<input type="text" name="actorName"  id="actorName"/>&nbsp;&nbsp;
	  							 <span >
		  							 <a id="btnCancel" class="easyui-linkbutton" icon="icon-search"  href="javascript:getActorList();">查询</a>&nbsp;&nbsp;
									 <a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset1()">重置</a>
	  							 </span>
  							</div>
  							<div style="margin:0px 10px 10px 10px;">
				         		<table id="subTalbe" class="addOrEditTable" width="600px"></table>
			    		 	</div>
  						</td>
  					</tr>
  				</table>
		  		<div class="editButton"  data-options="region:'south',border:false" >
			    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			    </div>
  			</form>
		</div>
  </body>
</html>
