<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>特别套餐信息</title>
    <jsp:include page="../../util/import.jsp"/>
	
    <script type="text/javascript">
    $(function(){
		   var productTypeId = "<s:property value="productTypeId"/>";
		   var rightShowTypeId = "<s:property value="#session.rightShowTypeId"/>";
		   $("#tt").datagrid({//数据表格
				title:"套餐信息列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/specialpro/productList.action?productTypeId="+productTypeId,
				queryParams:{pageSize:pageSize},                                                                 
				idField:"productId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"title",title:"排序号(最大3位)",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<input id='sort_"+rowIndex+"' type='text' name='title' style='width:50px;' ></input>";  
		         	  }  
					},
		            {field:"productName",title:"套餐名称",width:250}, 
					{field:"memberPrice",title:"会员价",width:250},
					{field:"describle",title:"套餐描述",width:250} 
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"提交",
					iconCls:"icon-add",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择添加项！</p>", "warning");
						}else{
							if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
								var flag = true;
								var ids="";
								for(i=0;i<rows.length;i++){
									var sortNo = $("#sort_"+i).val();
									if(rows[i].sortNo != ""){
										if(i==rows.length-1)ids+=rows[i].productId+"_"+rows[i].sortNo;
										else ids+=rows[i].productId+"_"+rows[i].sortNo+",";
									}else{
										flag = false;
										msgShow("系统提示", "<p class='tipInfo'>请输入对应的排序号！</p>", "warning");
										break;
									}
								}
								if(flag){
									$.ajax({
									   type: "POST",
									   dataType: "JSON",
									   url: "${pageContext.request.contextPath}/back/rightShow/saveOrUpdateRightShowInfo.action?rightShowTypeId="+rightShowTypeId,
									   data: {ids:ids},
									   success: function(data){
										   javascript:close();
									   }
									});
								}
							}	
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
    
   	function query(){
		var title = $("#title").val();
		params = "title_"+title;
		$('#tt').datagrid('reload',{params:params}); 
	 }
   	
   	function close(){
  			parent.opener.location.reload();
		parent.close();
   	}
    	
    </script>

  </head>
  
  <body>
  		<span class="querybtn" style="font-size: 15px;">套餐名：<input type="text" style="height: 23px;" id="title" name="title"/></span>
		    		<span ><a href="javascript:query();" id="btn1" iconCls="icon-search"  >查询</a></span>  
  		<table id="tt"></table>
  </body>
</html>
