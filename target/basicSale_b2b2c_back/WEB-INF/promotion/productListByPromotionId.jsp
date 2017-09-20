<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>促销活动商品信息</title>
    <jsp:include page="../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"促销活动商品列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/disproduct/findProductListByPromotionId.action?promotionId=${promotionId}",
				queryParams:{pageSize:pageSize},
				idField:"applyPromotionId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"productFullName",title:"商品名称",width:100},
					{field:"shopName",title:"所属店铺",width:100},   
					{field:"promotionState",title:"审核状态",width:30, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='gray'>待审核</font>";} 
	                        if(value=="1"){ return "<font color='blue'>通过</font>";} 
	                        if(value=="2"){ return "<font color='red'>拒绝</font>";} 
	                        if(value=="3"){ return "<font color='green'>再次申请</font>";} 
                            }
                 	},
					{field:"sort",title:"排序",width:80, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        return "<input id='sort_"+rowData.applyPromotionId+"' name='sortValue' type='text' value='"+value+"' onblur='updateSort("+rowData.applyPromotionId+","+rowData.sort+");'/>";
                            }
                 	},
                 	{field:"option",title:"操作",width:40, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(rowData.promotionState==0){
			               		return "<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,1);'>"+"通过"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,2);'>"+"拒绝"+"</a>|&nbsp;&nbsp;<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,3);'>"+"删除"+"</a>";  
							}else if(rowData.promotionState==1){
								return "<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,2);'>"+"拒绝"+"</a>|&nbsp;&nbsp;<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,3);'>"+"删除"+"</a>";
							}else if(rowData.promotionState==2){
								return "<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,1);'>"+"通过"+"</a>|&nbsp;&nbsp;<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,3);'>"+"删除"+"</a>";
							}else if(rowData.promotionState==3){
			               		return "<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,1);'>"+"通过"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,2);'>"+"拒绝"+"</a>|&nbsp;&nbsp;<a id='"+rowData.applyPromotionId+"' onclick='updOrDelSA(this.id,3);'>"+"删除"+"</a>";  
							}
						
		         	  	}
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
				if("add_ch".equals((String)functionsMap.get(purviewId+"_add_ch"))){
				%>  
				{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(800,500,"&nbsp;&nbsp;添加商品","icon-add",false,"addOrEditWin");
						$("#form1").css("display","");
						getProductInfoList();//获取商品信息
					}
				},"-",
				<%
				 }
				if("pass_ch".equals((String)functionsMap.get(purviewId+"_pass_ch"))){
				%>
				{
					text:"批量通过",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择通过项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要通过吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].applyPromotionId;
											else ids+=rows[i].applyPromotionId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/disproduct/batch.action?flag=1",
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
				if("notPass_ch".equals((String)functionsMap.get(purviewId+"_notPass_ch"))){
				%>
				{
					text:"批量拒绝",
					iconCls:"icon-search",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择拒绝项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要拒绝吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].applyPromotionId;
											else ids+=rows[i].applyPromotionId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/disproduct/batch.action?flag=2",
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
				if("delete_ch".equals((String)functionsMap.get(purviewId+"_delete_ch"))){
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
											if(i==rows.length-1)ids+=rows[i].applyPromotionId;
											else ids+=rows[i].applyPromotionId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/disproduct/deleteDisproduct.action",
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
				{
					text:"返回促销活动申请",
					iconCls:"icon-back",
					handler:function(){
						 location.href="${pageContext.request.contextPath}/back/promotion/gotoPromotionPage.action";
					}
				},"-",{
					text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});
	
		 function updOrDelSA(id,flag){
	    		$.ajax({
	    			type:"post",dataType:"json",
	    			url:"${pageContext.request.contextPath}/back/promotion/checkPromotionType.action",
	    			data:{promotionId:${promotionId}},
	    			success:function(data){
	    				if(data.isSuccess=="true"){
	    					if(flag == 1||flag==2){
	    		    			$.ajax({
	    							   type: "POST", dataType: "JSON",
	    							   url: "${pageContext.request.contextPath}/back/disproduct/approveOrReject.action",
	    							   data: {promotionId:id,flag:flag},
	    							   success: function(data){
	    								   if(data.isSuccess=="false"){
	    									   msgShow("系统提示", "<p class='tipInfo'>其他促销活动中已经有此商品，暂不能通过！</p>", "warning");
	    								   }
	    									   $("#tt").datagrid("clearSelections");//取消所有选项
	    									   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //重新加载列表
	    							   }
	    							});
	    		    		}else{
	    		    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
	    		    				function(data){
	    		    					if(data == true)
	    		    					$.ajax({
	    								   type: "POST", dataType: "JSON",
	    								   url: "${pageContext.request.contextPath}/back/disproduct/deleteDisproduct.action",
	    								   data: {ids:id},
	    								   success: function(data){
	    									   $("#tt").datagrid("clearSelections");//取消所有选项
	    									   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //重新加载列表
	    								   }
	    								});
	    						});
	    		    		}
	    				}else{
	    					msgShow("系统提示", "<p class='tipInfo'>该活动已开启或已关闭，不能对商品进行操作！</p>", "warning");
	    				}
	    			}
	    		});
	    	}
		
		 function query(){
		  	  	queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopName:$("#qshopName").val(),promotionState:$("#qpromotionState").val()};
		  	  	$("#tt").datagrid("load",queryParams); 
		  	  	pageSplit(pageSize,queryParams);//调用分页函数
	   	}
		 
		 function updateSort(id,value){
			 var sortValue=$("#sort_"+id).val();
			 if(sortValue!=value){//判断 如何过sort的值 没有发生改变则不操作数据库
			 $.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/disproduct/updateSort.action",
				   data: {sortValue:sortValue,id:id},
				   success: function(data){
					   $("#tt").datagrid("clearSelections");//取消所有选项
					   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //重新加载列表
				   }
				});
			 }
		 }
		 function reset(){
			$("#qshopName").val("");
			$("#qpromotionState").val("");
		 }
	</script>
</head>
<!--   <body style="background:#F0FFF0;"> -->
	<body >
	<jsp:include page="../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:85px;"> 店铺名称：</td>
				<td class="search_toleft_td" style="width:155px;"><input type="text" id="qshopName" name="s_name"/></td>
				<td class="search_toright_td" style="width: 75px;"> 活动状态：</td>
				<td class="search_toleft_td" style="width: 110px;"><select id="qpromotionState">
					<option value="-1">--请选择--</option>
					<option value="0">待审核</option>
					<option value="1">通过</option>
					<option value="2">拒绝</option>
					<option value="3">再次申请</option>
				</select></td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		</div>
	</body>
</html>
