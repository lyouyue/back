<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>前台套餐分类信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"前台套餐分类列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/prosceniumProType/listProsceniumProType.action",
				queryParams:{pageSize:pageSize},
				idField:"prosceniumProTypeId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"productTypeName",title:"套餐分类名称",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.prosceniumProTypeId+"' onclick='showDetailInfo(this.id);'>"+rowData.productTypeName+"</a>";  
		         	  }  
					}, 
					{field:'isShow',title:'是否显示',width:50, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>不显示</font>";} 
	                        if(value=="1"){ return "<font color='#0033FF'>显示</font>";} 
                            }
                 	},
                 	{field:"updName,delName",title:"操作",width:10, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.prosceniumProTypeId+"' onclick='updOrDelSA(this.id,"+rowData.prosceniumProTypeId+",1);'>"+"修改"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.prosceniumProTypeId+"' onclick='updOrDelSA(this.id,"+rowData.prosceniumProTypeId+",2);'>"+"删除"+"</a>";  
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
						createWindow(900,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#updateWin").css("display","none");
						getProductTypeInfoList();
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
											if(i==rows.length-1)ids+=rows[i].prosceniumProTypeId;
											else ids+=rows[i].prosceniumProTypeId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/prosceniumProType/deleteProsceniumProType.action",
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
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});
    	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
	    			createWindow(900,500,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
	    			$("#addOrEditWin").css("display","none");
					$("#updateWin").css("display","");
	    			$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/prosceniumProType/getProsceniumProTypeObject.action",
						   data: {prosceniumProTypeId:id},
						   success: function(data){
							     $("#prosceniumProTypeId").val(data.prosceniumProTypeId);
								   $("#productTypeId").val(data.productTypeId);
								   $("#productTypeName").val(data.productTypeName);
								   $("#uproductTypeName").html(data.productTypeName);
								   $("#isShow_"+data.isShow).attr("checked",true);
						   }
						});
	    		}else{
	    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
	    				function(data){
	    					if(data == true)
	    					$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/prosceniumProType/deleteProsceniumProType.action",
							   data: {ids:id},
							   success: function(data){
								   $("#tt").datagrid("clearSelections");//删除后取消所有选项
								   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
							   }
							});
					});
	    		}
	    	}
    </script>
    <style type="text/css">
   	 .querybtn a{height:28px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
    </style>
  </head>
  
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditProsceniumProType.jsp"/>
		   <!-- 修改 -->
		  <jsp:include page="updateStats.jsp"/>
		</div>
  </body>
</html>
