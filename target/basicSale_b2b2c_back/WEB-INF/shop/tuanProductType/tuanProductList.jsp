<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>团购商品信息</title>
    <jsp:include page="../../util/import.jsp"/>
     <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
     <link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
	<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"团购商品列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/tuanProductType/listProductInfoByTuanProductTypeId.action?tuanProductTypeId=${tuanProductTypeId}",
				queryParams:{pageSize:pageSize},
				idField:"tuanId",//唯一性标示字段
				/* frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]], */
				columns:[[//未冻结字段
				   /*  {field:"brandName",title:"品牌名称",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.brandId+"' onclick='showDetailInfo(this.id);'>"+rowData.brandName+"</a>";  
		         	  }  
					},   */
					{field:"title",title:"标题",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						  return "<a style='display:block;' id='"+rowData.productId+"' onclick='showDetailInfo(this.id);'>"+rowData.title+"</a>";  
					} 
					
					},
					{field:"productFullName",title:"商品名称",width:120},
					/* {field:"synopsis",title:"简介",width:120}, */
					{field:"tuanImageUrl",title:"图片",width:55,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='60px' height='30px' />";
						}
					},
					{field:"price",title:"团购价格",width:40},
					{field:"tuanPeriod",title:"团购周期",width:40},
					{field:"createTime",title:"申请时间",width:87},
					{field:"beginTime",title:"开启时间",width:87},
					{field:"endTime",title:"结束时间",width:87},
					{field:"openGroupCount",title:"开团人数",width:40},
					{field:"bought",title:"已购人数",width:40},
					{field:"state",title:"状态",width:30,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_004'>未启用</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>启用</font>";} 
	                        if(value=="2"){ return "<font class='color_003'>关闭</font>";} 
	                        if(value=="3"){ return "<font class='color_002'>结束</font>";} 
                         }
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{
				     	text:"返回团购分类",
						iconCls:"icon-back",
						handler:function(){
							 location.href="${pageContext.request.contextPath}/back/tuanProductType/gotoTuanProductTypePage.action";
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
			pageSplit(pageSize);//调用分页函数
		});
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,productFullName:$("#qproductFullName").val(),beginTime:$("#qbeginTime").val(),expirationTime:$("#qexpirationTime").val()};
		$("#tt").datagrid("load",queryParams);
		pageSplit(pageSize,queryParams);//调用分页函数
	}
	function reset(){
		$("#qproductFullName").val("");
		$("#qbeginTime").val("");
		$("#qexpirationTime").val("");
	}
    </script>
	<style type="text/css">
			 .linkbtn{margin-top: 5px;margin-right: 10px;}
			 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
		 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
			 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
	</head>
	<body>
		<jsp:include page="../../util/item.jsp"/>
		<div class="main">
			<table class="searchTab">
				<tr>
					<td class="search_toright_td" style="width: 80px;">商品名称：</td>
					<td class="search_toleft_td" style="width: 125px;px;"><input type="text" id="qproductFullName" name="productFullName"  style="width: 110px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
					<td class="search_toright_td" style="width:70px;">开启时间：</td>
					<td class="search_toleft_td"  style="width:125px;"><input id="qbeginTime" style="width: 110px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qexpirationTime\')}'})"/></td>
					<td class="search_toright_td" style="width:70px;">结束时间：</td>
					<td class="search_toleft_td" style="width:140px;"><input id="qexpirationTime" style="width: 110px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qbeginTime\')}'})"/></td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
			           	<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
			</table>
			<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<form id="form1" action=""></form>
				<!-- 详情页 -->
				<jsp:include page="tuanProductDetail.jsp"/>
			</div>
		</div>
	</body>
</html>
