<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>卖家等级策略</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		 //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/sellersStrategy/savaOrUpdateSellersStrategy.action",  
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
				title:"卖家等级策略",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/sellersStrategy/listSellersStrategy.action",
				idField:"sellersLevelId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"sellersLevel",title:"卖家等级",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.sellersLevelId+"' onclick='showDetailInfo(this.id);'>"+rowData.sellersLevel+"</a>";  
		         	  }  
					}, 
					{field:"sellersRank",title:"卖家头衔",width:120},
					{field:"levelDiscountValue",title:"等级折扣值(%)",width:120},
					{field:"levelIcon",title:"等级图标",width:80,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' width='60px' height='50px' />";
						}
					},
					{field:"minRefValue",title:"最小参考值",width:120},
					{field:"maxRefValue",title:"最大参考值",width:120}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(700,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
					}
				},"-",{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(700,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/sellersStrategy/getSellersStrategyObject.action",
							   data: {sellersLevelId:rows[0].sellersLevelId},
							   success: function(data){
							       $("#SLevel_1").hide();
							       $("#SRank_1").hide();
								   $("#sellersLevelId").val(data.sellersLevelId);
								   $("#sellersLevel").val(data.sellersLevel);
								   $("#sellersRank").val(data.sellersRank);
								   $("#levelIcon").val(data.levelIcon);
								   $("#photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.levelIcon+"' width='60px' height='50px' />");
								   $("#minRefValue").val(data.minRefValue);
								   $("#maxRefValue").val(data.maxRefValue);
								   $("#levelDiscountValue").val(data.levelDiscountValue);
								   $("#lineOfCredit").val(data.lineOfCredit);
							   }
							});	   
						}
					}
				} ,"-",{
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
											if(i==rows.length-1)ids+=rows[i].sellersLevelId;
											else ids+=rows[i].sellersLevelId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/sellersStrategy/deleteSellersStrategy.action",
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
			pageSplit();//调用分页函数
		});
    
		function showDetailInfo(id){
			createWindow(700,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/back/sellersStrategy/getSellersStrategyObject.action",
				data: {sellersLevelId:id},
				dataType: "JSON",
				success: function(data){
					$("#dsellersLevelId").html(data.sellersLevelId);
					$("#dsellersLevel").html(data.sellersLevel);
					$("#dsellersRank").html(data.sellersRank);
					$("#dlevelIcon").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.levelIcon+"' width='60px' height='50px' />");
					$("#dminRefValue").html(data.minRefValue);
					$("#dmaxRefValue").html(data.maxRefValue);
					$("#dlevelDiscountValue").html(data.levelDiscountValue);
				}
			});
		}
		
    </script>
  </head>
  
  <body>
  		 <!-- 查询框  -->
  <div style="width: 99%">
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			 <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditSellersStrategy.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detailSellersStrategy.jsp"/>
		</div>
		</div>
  </body>
</html>
