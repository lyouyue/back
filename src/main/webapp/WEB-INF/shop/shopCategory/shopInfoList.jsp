<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>店铺信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"店铺基本信息:<s:property value='#request.shopCategoryName'/>类",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopCategory/findShopInfoByShopCategoryId.action?shopCategoryId="+'${shopCategoryId}',
				queryParams:{pageSize:pageSize},
				idField:"shopInfoId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerName",title:"会员名称",width:70, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.shopInfoId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerName+"</a>";  
		         	  	}  
					}, 
					{field:"shopName",title:"店铺名称",width:70}, 
// 					{field:"shopCategoryName",title:"店铺分类名称",width:70}, 
					{field:"mainProduct",title:"主要销售产品",width:70}, 
					{field:"isPass",title:"审核状态",width:30,
						formatter:function(value,rowData,rowIndex){
							   if(value==3){
								    return"<font class='color_001'>是</font>";
							   }else{
								    return"<font class='color_002'>否</font>";
							   }
						 }	
					},  
					
					{field:"isClose",title:"是否关闭",width:30,
						formatter:function(value,rowData,rowIndex){
							   if(value==0){
								    return"<font class='color_001'>否</font>";
							   }else{
								    return"<font class='color_002'>是</font>";
							   }
						 }	
					}, 
					{field:"verifier",title:"店铺审核人",width:70}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				{text:"返回店铺分类列表",
					iconCls:"icon-back",
					handler:function(){
						history.go(-1);
					}
				}
				,"-",
				{text:"刷新",
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
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopName:$("#qshopName").val(),isClose:$("#qisClose").val(),custName:$("#qcustName").val(),shopCategoryId:$("#parentIdList").val(),isPass:$("#qisPass").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#qshopName").val("");
    		$("#qcustName").val("");
    	}
	</script>
</head>
	<style type="text/css">
		.linkbtn{margin-top: 5px;margin-right: 10px;}
		.linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
		.querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
		.querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
	<body>
		<jsp:include page="../../util/item.jsp"/>
		 <!-- 查询框  -->
			<div class="main">
				<table class="searchTab">
					<tr>
						<td class="search_toright_td" style="width: 80px;">会员名称：</td>
						<td class="search_toleft_td" style="width: 160px;"><input type="text" class="searchTabinput" id="qcustName" name="custName" class="searchTabinput"/>&nbsp;&nbsp;</td>
						<td class="search_toright_td" style="width:70px;">店铺名称：</td>
						<td class="search_toleft_td" style="width:170px;"><input type="text" class="searchTabinput"  id="qshopName" name="shopName" class="searchTabinput"/>&nbsp;&nbsp;</td>
						<%-- <td class="toright_td">平台 店铺 分类：</td>
						<td class="toleft_td">
							<select  id="parentIdList"  name="shopInfo.shopCategoryId" class="{validate:{required:true}} Registration">
								<option value="-1">--请选择分类--</option>
							<s:iterator  value="shopCategoryList">
								<option  value="<s:property value="shopCategoryId" />">
									<s:if test="level==1">&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
									<s:if test="level==2">&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
									<s:if test="level==3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
								</option>
							</s:iterator>
						</select>
					</td> --%>
				<%-- </tr>
				<tr>	
					<td class="toright_td">是否关闭 ：</td>
					<td class="toleft_td">
						<select id="qisClose">
							<option value="-1">--请选择--</option>
							<option value="0">否</option>
							<option value="1">是</option>
						</select>&nbsp;&nbsp;
					</td>
					<td class="toright_td">是否通过 ：</td>
					<td class="toleft_td">
						<select id="qisPass">
							<option value="-1">--请选择--</option>
							<option value="1">未审核</option>
							<option value="2">未通过</option>
							<option value="3">通过</option>
						</select>&nbsp;&nbsp;
					</td>
					<td></td> --%>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
						<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
			</table>
			<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<!-- 详情页 -->
				<jsp:include page="detailShopInfo.jsp"/>
			</div>
			</div>
	</body>
</html>
