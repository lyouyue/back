<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
//管理功能权限
    function managerFuncs(id){
    	createWindow(700,"auto","&nbsp;&nbsp;功能权限管理","icon-add",false,"win");
    	$("#funName").val("");
    	$("#funValue").val("");
        $("#addOrEditWin").css("display","none");
        $("#managerFunctionsWin").css("display","");
        $("#detailWin").css("display","none");
        $("#fpurviewId").val(id);
		$("#tt").datagrid({//数据表格
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/functions/listFunctions.action",
				idField:"fid",//唯一性标示字段
				queryParams:{"purviewId":id},
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"funName",title:"功能权限名",width:120}, 
					{field:"funValue",title:"功能权限值",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[        
				{text:"修改", 
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
							   url: "${pageContext.request.contextPath}/functions/getFunctionsObject.action",
							   data: {fid:rows[0].fid},
							   success: function(data){
								  $("#fid").val(data.fid); 
								  $("#fpurviewId").val(data.purviewId); 
								  $("#funName").val(data.funName); 
								  $("#funValue").val(data.funValue); 
							   }
							});
						}
					}
				}
				,
				"-"
				,
				{text:"删除",
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
											if(i==rows.length-1)ids+=rows[i].fid;
											else ids+=rows[i].fid+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/functions/deleteFunctions.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("reload");
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
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
		pageSplit(pageSize,{"purviewId":id});//调用分页函数
	}
    
    $(function(){
		 //表单验证
	    $("#form2").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
             function() {  
            	 var options = {  
                    url : "${pageContext.request.contextPath}/functions/saveOrUpdateFunctions.action",  
                    type : "post",  
                    dataType:"json",
                    success : function(data) { 
        	         	$("#fid").val("");
        	         	$("#funName").val("");
        	         	$("#funValue").val("");
                   	    msgShow("系统提示", "<p class='tipInfo'>保存成功！</p>", "info");
                   	    $("#tt").datagrid("reload");
                    }
                };  
                $("#form2").ajaxSubmit(options);  
             });
	       }
	    });
	});
	    
    function clearSelect(){
    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
    }
	    
</script>

<div id="managerFunctionsWin">
	<table id="tt"></table>
	<form id="form2"  method="post" action="">
	    <input id="fid" type="hidden" name="functions.fid" value=""/>
	    <input id="fpurviewId" type="hidden" name="functions.purviewId" value="" noclear="true"/>
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">功能权限名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="funName" type="text" name="functions.funName" value="" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">功能权限值:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="funValue" type="text" name="functions.funValue" value="" class="{validate:{required:true,maxlength:[200]}}"/></td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form2').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>
