<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>金币兑换信息信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>

    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"金币兑换列表信息",
				iconCls:"icon-save",
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/integralexChange/listIntegralexChange.action",
				queryParams:{pageSize:pageSize},
				idField:"integralId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"productId",title:"商品名称",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.integralId+"' onclick='showDetailInfo(this.id);'>"+rowData.productId+"</a>";
		         	  }
					},
					{field:"pointExchange",title:"金币兑换",width:80},
					{field:"maxUsers",title:"兑换人数上限",width:80},
					{field:"maxProducts",title:"可兑换商品数量",width:120},
					{field:"chooseVIP",title:"允许兑换的会员等级",width:120},
					{field:"beginTime",title:"开启时间",width:120},
					{field:"endTime",title:"结束时间",width:120},
					{field:'state',title:'状态',width:100,
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>未启用</font>";}
	                        if(value=="1"){ return "<font color='#0033FF'>已启用</font>";}
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
						createWindow(800,600,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#integralId").val(null);
					}
				},"-",{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/integralexChange/getIntegralexChangeInfo.action",
							   data: {integralId:rows[0].integralId},
							   success: function(data){
								   $("#integralId").val(data.integralId);
								   $("#productId").val(data.productId);
								   $("#pointExchange").val(data.pointExchange);
								   $("#maxUsers").val(data.maxUsers);
								   $("#maxProducts").val(data.maxProducts);
								   $("#chooseVIP").val(data.chooseVIP);
								   $("#beginTime").val(data.beginTime);
								   $("#endTime").val(data.endTime);
								   $("#state_"+data.state).attr("checked",true);
							   }
							});
						}
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
											if(i==rows.length-1)ids+=rows[i].integralId;
											else ids+=rows[i].integralId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/integralexChange/deleteIntegralexChange.action",
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

    </script>
  </head>

  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditIntegralexChange.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detailIntegralexChange.jsp"/>
		</div>
  </body>
</html>
