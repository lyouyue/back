<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//商品的列表展示查询
	function querySelt(){
		var typeId = $.trim($("#typeId").val());
		$("#productList").datagrid("clearSelections"); //取消所有选项
		pageNumber=1;
		queryParams={typeId:typeId,productName:$.trim($("#productNameT").val()),productNo:$.trim($("#productNoT").val())};
		$("#productList").datagrid("reload",queryParams); 
		pageSplitThis(pageSize,queryParams,"productList");
	}
	
	function resetSelt(){
	   $("#productNoT").val("");
	   $("#productNameT").val("");
	}
	// 选择所有
	function checkedAll(obj){//选中所有或者去掉所有选中的
		var isChecked=obj.checked;
	    if(isChecked){
	    	$(".productInfos").each(function() {
	    	    $(this).attr("checked", true);
	    	    var idIndex=$(this).attr("id");
	    	    $("#dis_"+idIndex).css("display","");
	    	    $("#dis_"+idIndex).val(idIndex);
	    	});
	    }else{
	    	$(".productInfos").each(function() {
	    	    $(this).attr("checked", false);
	    	    var idIndex=$(this).attr("id");
	    	    $("#dis_"+idIndex).val("");
	    	    $("#dis_"+idIndex).css("display","none");
	    	});
	    }
	}
	// 选择一个
	function checkedOne(obj){
		var idIndex=obj.id;
		var isOneChedcked=obj.checked;
		if(isOneChedcked){
	    	$("#dis_"+idIndex).css("display","");
	    	$("#dis_"+idIndex).val(idIndex);
	    }else{
	    	$("#dis_"+idIndex).val("");
	    	$("#dis_"+idIndex).css("display","none");
	    }
	}
	function closeWin1(){
		queryParams={typeId:""};
   		$("#productList").datagrid("reload",queryParams); //保存后重新加载列表
   		closeWin();
	}
	
</script>
<div id="addWin" style="width:870px;height:400px;margin: 0 auto;">
	<form id="form1" method="post">
		<input id="productData" type="hidden"  name="productData" />
		<!-- 查询框  -->
		<div class="main">
		    <table class="searchTab">
			   <tr>
					<td class="search_toright_td" width="80px;">分类名称：</td>
					<td class="search_toleft_td" height="10px;" width="145px;">
						<select id="typeId" name="dayRecommend.typeId" style="width:125px;line-height:20px;"  onchange="querySelt()" class="{validate:{required:true}}">
							<option value="">--请选择分类--</option>
							<s:iterator value="#application.categoryMap" var="type1">
								<option value="<s:property value="#type1.key.productTypeId"/>"  >
								<s:property value="#type1.key.sortName"/>
								<s:iterator value="#type1.value" var="type2">
									<option value="<s:property value="#type2.key.productTypeId"/>"  >
										&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type2.key.sortName"/>
								 		<s:iterator value="#type2.value" var="type3">
										<option value="<s:property value="#type3.key.productTypeId"/>" >
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type3.key.sortName"/>
												<s:iterator value="#type3.value" var="type4">
													<option value="<s:property value="#type4.productTypeId"/>" >
													&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type4.sortName"/>
													</option>
												</s:iterator>	
										</option>
										</s:iterator>	
									</option>
								</s:iterator>
								</option>
							</s:iterator>
						</select> 
					</td>
					<td class="search_toright_td" style="width:80px;">商品名称：</td>
					<td class="search_toleft_td" style="width:135px;"><input type="text" id="productNameT" style="width:110px;" /></td>
					<td class="search_toright_td" style="width:60px;">商品编号：</td>
					<td class="search_toleft_td" style="width:145px;"><input type="text" id="productNoT" style="width:120px;" /></td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:querySelt()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:resetSelt()">重置</a>
					 </td>
				</tr>
			</table>
			<table id="productList"></table>
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
</div>
