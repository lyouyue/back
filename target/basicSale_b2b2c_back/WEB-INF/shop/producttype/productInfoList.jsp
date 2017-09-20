<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>商品信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"商品列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/producttype/listProductInfoByProductTypeId.action?productTypeId=${productTypeId}",
				queryParams:{pageSize:pageSize},
				idField:"productId",//唯一性标示字段
				/* frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]], */
				columns:[[//未冻结字段
					{field:"logoImg",title:"商品图片",width:120,formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='25' height='25' />";
						}
					},
					{field:"productFullName",title:"商品名称",width:150}, 
					{field:"marketPrice",title:"原价(元)",width:120},
					{field:"salesPrice",title:"销售价(元)",width:120},
					{field:"isShow",title:"是否显示",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="1"){ return "<font class='color_001'>显示</font>";}
							if(value=="0"){ return "<font class='color_002'>不显示</font>";}
						}
					},
					{field:"isPass",title:"审核状态",width:100, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="0"){ 
								return "<font class='color_002'>未通过</font>";
							}else if(value=="1"){
								return "<font class='color_001'>已通过</font>";
							}else if(value=="2"){
								return "<font class='color_004'>待申请</font>";
							}else{
								return "<font class='color_003'>待审核</font>";
							} 
						}
					},
					{field:"passUserName",title:"审核人",width:120},
					{field:"isPutSale",title:"是否上架",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="2"){ return "<font class='color_001'>已上架</font>";} 
							if(value=="1"){ return "<font class='color_002'>未上架</font>";} 
							if(value=="3"){ return "<font class='color_003'>违规下架</font>";} 
						}
					},
					{field:"putSaleDate",title:"上架时间",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return toJsonDate(value,"yyyy-MM-dd hh:mm:ss");}
					},
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[/* {
					text:"删除", 
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
								$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/producttype/deleteTypeProduct.action?productTypeId=${productTypeId}",
										   data: {productId:rows[0].productId},
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
				},"-", */{
					text:"返回商品分类",
					iconCls:"icon-back",
					handler:function(){
						//location.href="${pageContext.request.contextPath}/back/producttype/gotoProductTypePage.action";
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
			pageSplit(pageSize);//调用分页函数
		});
    
    </script>
  </head>

<body>
	<!-- <table  class="searchTab">
	</table> -->
	<table id="tt"></table>
	<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;"></div>
</body>
</html>
