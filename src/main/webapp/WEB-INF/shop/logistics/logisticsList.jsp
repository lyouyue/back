<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
<title>物流公司信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
			//表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {
                         url : "${pageContext.request.contextPath}/back/logistics/saveOrUpdateLogistics.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
                         }
                     };  
                     $("#form1").ajaxSubmit(options);
					  $("input.button_save").attr("disabled","disabled");//防止重复提交
                  });
		       }
			});
			
		   $("#tt").datagrid({//数据表格
				/* title:"物流公司列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/logistics/listLogistics.action",
				idField:"logisticsId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"code",title:"物流公司代码",width:120},
					{field:"deliveryCorpName",title:"物流公司名称",width:120},
					{field:"deliveryUrl",title:"物流公司网址",width:120},
					{field:"sortCode",title:"排序",width:120},
					{field:"isCommon",title:"是否常用",width:120,formatter:function(value,rowData,rowIndex){
						if(value==0){
							return "<font style='color:red;'>不常用</font>";
						}else if(value==1){
							return "<font style='color:green;'>常用</font>";
						}
					}
					},
					{field:"createDate",title:"创建时间",width:120,formatter:function(value,rowData,rowIndex){
						return 	toJsonDate(value,"yyyy-MM-dd hh:mm:ss");
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
							createWindow(650,'auto',"&nbsp;&nbsp;添加物流公司","icon-add",false,"addOrEditWin"); 
							$("#logisticsId").val("");
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
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
							}else if(rows.length==1){
								createWindow(700,'auto',"&nbsp;&nbsp;修改物流公司","icon-edit",false,"addOrEditWin");
								$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/logistics/getLogisticsObject.action",
								   data: {id:rows[0].logisticsId},
								   success: function(data){
									   $("#logisticsId").val(data.logistics.logisticsId);
									   $("#code").val(data.logistics.code);
									   $("#deliveryCorpName").val(data.logistics.deliveryCorpName);
									   $("#deliveryUrl").val(data.logistics.deliveryUrl);
									   $("#sortCode").val(data.logistics.sortCode);
									  /*  $("#isCommon").val(data.logistics.isCommon); */
									   $("#isCommon_"+data.logistics.isCommon).attr("checked",true);
									   $("#createDate").val(data.logistics.createDate);
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
										for(var i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].logisticsId;
											else ids+=rows[i].logisticsId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/logistics/deleteLogistics.action",
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
    
    function query(){
  	    queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,code:$("#qcode").val(),deliveryCorpName:$("#qdeliveryCorpName").val()};
  	    $("#tt").datagrid("load",queryParams);
  	    pageSplit(pageSize,queryParams);//调用分页函数
    }

  	function reset(){
		$("#qcode").val("");
		$("#qdeliveryCorpName").val("");
  	}
    </script>
  </head>
  
<body>
<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
		 	<tr>
		 		<td class="search_toright_td" style="width:105px;">物流公司代码：</td>
		 		<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qcode" name="s_code" class="searchTabinput"/></td>
		 		<td class="search_toright_td" style="width:85px;">物流公司名称：</td>
		 		<td class="search_toleft_td" style="width:175px;"><input type="text" id="qdeliveryCorpName" name="s_deliveryCorpName" class="searchTabinput"/></td>
		 		<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
		 	</tr>
		</table> 
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditLogistics.jsp"/>
		</div>
	</div>
</body>
</html>
