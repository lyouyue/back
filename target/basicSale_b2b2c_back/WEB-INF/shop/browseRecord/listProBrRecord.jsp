<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>商品浏览历史记录信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"商品浏览历史记录列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true, //true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/browseRecord/proBrRecordList.action", 
				idField:"proBrRecordId", //唯一性标示字段
				frozenColumns:[[//冻结字段 
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"title",title:"浏览记录ID",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.proBrRecordId+"' onclick='showDetailInfo(this.id);'>"+rowData.proBrRecordId+"</a>";  
		         	  }  
					}, 
					{field:"customerId",title:"会员ID",width:120},
					{field:"productId",title:"商品ID",width:120},
					{field:"lastBrTime",title:"最后浏览时间",width:200} 
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
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
											if(i==rows.length-1)ids+=rows[i].proBrRecordId;
											else ids+=rows[i].proBrRecordId+",";
										}
										$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/browseRecord/deleteProBrRecord.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   $("#tt").datagrid("reload"); //删除后重新加载列表
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
    	
    </script>

  </head>
  
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
  		<jsp:include page="addOrEditProBrRecord.jsp"></jsp:include>
  		<jsp:include page="detailProBrRecord.jsp"></jsp:include>
		</div>
  </body>
</html>
