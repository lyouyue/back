<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
$("#addShopInfoForm").validate({meta: "validate", 
    submitHandler:function(form){
        $(document).ready(
             function() {
			//判断是否有选中的套餐
			var rows = $("#shopInfoList").datagrid("getSelections");//找到所有选中的行
				if(rows.length<=0){
					msgShow("系统提示", "<p class='tipInfo'>请选择一个机构！</p>", "warning");
				}else if(rows.length>1){
					msgShow("系统提示", "<p class='tipInfo'>只能选择一个机构</p>", "warning");
				}else{
					if(rows){
						var shopInfoIds="";
						for(var i=0;i<rows.length;i++){
							if(i==rows.length-1)shopInfoIds+=rows[i].shopInfoId;
							else shopInfoIds+=rows[i].shopInfoId+",";
						}
						$("#shopInfoIds").val(shopInfoIds);//数据放入表单
						 var options = {
							url:"${pageContext.request.contextPath}/back/productinfo/copyBasicProductInfo.action", 
							type:"post",
							dataType:"json",
							success:function(data){
								$("#productIds").val("");
								closeWin();
								$("#tt").datagrid("clearSelections");//删除后取消所有选项
								$("#tt").datagrid("reload"); //保存后重新加载列表
								$("#shopInfoList").datagrid("clearSelections");//删除后取消所有选项
								$("#shopInfoList").datagrid("reload"); //保存后重新加载列表
							}
						};
						$("#addShopInfoForm").ajaxSubmit(options);
					}
				}
			});
			}
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
</script>
<div id="addShopInfo" >
	<form id="addShopInfoForm" method="post">
		<input type="hidden" id="productIds" name="productIds" value="" />
		<input type="hidden" id="shopInfoIds" name="shopInfoIds" value="" />
		 <!-- 查询框  -->
		<div class="main">
			<table class="searchTab"> 
				<tr>
					<td class="search_toright_td" style="width: 75px;">机构名称：</td>
					<td class="search_toleft_td" style="width: 160px;">
						<input type="text" id="aqshopName" name="shopInfo.shopName" style="width:150px;" />
					</td>
					<td class="search_toright_td" style="width:85px;">机构管理员：</td>
					<td class="search_toleft_td" style="width: 175px;">
						<input type="text" id="aqcustomerName" name="shopInfo.customerName" style="width:150px;" />
					</td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:querySelt()">查询</a>
					</td>
			   </tr>
		   </table>
			<table id="shopInfoList"></table>
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
</div>
