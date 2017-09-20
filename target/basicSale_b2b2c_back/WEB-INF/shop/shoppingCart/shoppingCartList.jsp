<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>购物车</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"购物车列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shoppingCart/listShoppingCart.action",
				queryParams:{pageSize:pageSize},
				idField:"shopCartId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"customerId",title:"会员",width:120},
					{field:"shopInfoId",title:"店铺",width:120},
					{field:"productId",title:"商品",width:120},
					{field:"quantity",title:"数量",width:50},
					{field:"createTime",title:"创建时间",width:100},
					{field:"updName,delName",title:"操作",width:30, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.shopCartId+"' onclick='updOrDelSA(this.id,"+rowData.shopCartId+",1);'>"+"修改"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.shopCartId+"' onclick='updOrDelSA(this.id,"+rowData.shopCartId+",2);'>"+"删除"+"</a>";  
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
						createWindow(900,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#product").html("");
						$("#cusName").html("");
						$("#shopName").html("");
						$("#cusadd").css("display","");
						$("#cusupdate").css("display","none");
						$("#shopadd").css("display","");
						$("#shopupdate").css("display","none");
						$("#shopCartId").val(null);
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
											if(i==rows.length-1)ids+=rows[i].shopCartId;
											else ids+=rows[i].shopCartId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/shoppingCart/deleteShoppingCart.action",
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
	    			createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
	    			$("#cusadd").css("display","none");
					$("#cusupdate").css("display","");
					$("#shopadd").css("display","none");
					$("#shopupdate").css("display","");
	    			$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/shoppingCart/getShoppingCartInfo.action",
						   data: {shopCartId:id},
						   success: function(data){
							   $("#shopCartId").val(data[0].shopCartId);
							   $("#createTime").val(data[0].createTime);
						       $("#ucustomerId").val(data[0].customerId);
						       $("#uproductId").val(data[0].productId);
						       $("#ushopInfoId").val(data[0].shopInfoId);
						       $("#quantity").val(data[0].quantity);
						       $("#cusName").html(data[1]);
						       $("#shName").html(data[2]);
						       $("#product").html(data[3]);
						   }
						});
	    		}else{
	    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
	    				function(data){
	    					if(data == true)
	    					$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/shoppingCart/deleteShoppingCart.action",
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
  </head>
  
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		</div>
  </body>
</html>
