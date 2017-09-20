<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
//初始化店铺分类
$(function(){
		$('#qShopCategory').combogrid({
			idField:'shopCategoryId',
			textField:'shopCategoryName',
			rownumbers:true,//序号
			width:130,
			url:'${pageContext.request.contextPath}/back/shopsShopinfo/findShopCategoryList.action',
			columns:[[
				{field:'shopCategoryName',title:'分类名称',width:120}
			]]
		});
});
//套餐的列表展示查询
function querySelt(){
	$("#shopInfoList").datagrid("clearSelections");//取消所有选项
	var shopCategoryIds = document.getElementsByName("shopCategory.shopCategoryId");
	var shopCategoryId = "";
	if(shopCategoryIds.length>0){
		shopCategoryId = shopCategoryIds[0].value;
	}
	queryParams={shopName:$.trim($("#aqshopName").val()),customerName:$.trim($("#aqcustomerName").val()),shopCategoryId:shopCategoryId};
	$("#shopInfoList").datagrid("reload",queryParams);
	pageSplitThis(pageSize,queryParams,"shopInfoList");
}
function closeWindows(){
	queryParams={shopName:"",customerName:"",shopCategoryId:""};
	$("#shopInfoList").datagrid("reload",queryParams);
	pageSplitThis(pageSize,queryParams,"shopInfoList");
	closeWin();
}
function resetSelt(){
	$("#aqshopName").val("");
	$("#aqcustomerName").val("");
	$("#qShopCategory").val("");
}
</script>
<div id="addOrEditWin"  style="width:870px;height:400px;margin: 0 auto;">
	<form id="form1" method="post">
		<input type="hidden" id="shopsId" name="shopsId" value="${shops.shopsId}" noclear="true"/>
		<input type="hidden" id="shopsShopinfoId" name="shopsShopinfo.shopsShopinfoId" value="${shopsShopinfo.shopsShopinfoId}" noclear="true"/>
		<input type="hidden" id="shopInfoIds" name="shopInfoIds" />
		 <!-- 查询框  -->
		<div class="main">
			<table class="searchTab">
				<tr>
					<td class="search_toright_td">店铺名称：</td>
					<td class="search_toleft_td"><input type="text" id="aqshopName" name="shopInfo.shopName" style="width:100px;" /></td>
					<td class="search_toright_td">店铺管理员：</td>
					<td class="search_toleft_td"><input type="text" id="aqcustomerName" name="shopInfo.customerName" style="width:100px;" /></td>
					<%-- <td class="toright_td">店铺分类：</td>
					<td class="toleft_td" colspan="3">	
						<select id="qShopCategory" name="shopCategory.shopCategoryId" ></select><span id="shopCategoryIdError"></span>
					</td> --%>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:querySelt()">查询</a>
		           		<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:resetSelt()">重置</a>
					</td>
			   </tr>
			</table>
			<table id="shopInfoList"></table>
			<div class="editButton"  data-options="region:'south',border:false" >
		    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWindows()" href="javascript:;">取消</a>
		    </div>
	    </div>
	</form>
</div>
