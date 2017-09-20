<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function checkAttrValueCount(){
		var count = $("#attributeValueCount").val();
		if(Number(count)==0){//没有对应的属性值
			msgShow("系统提示", "<p class='tipInfo'>请先给当前属性添加属性值后，再设置显示!</p>", "warning");
			$("#isListShow_0").attr("checked",true);
		}
	}
	
	$(function() {//表单验证
	//表单验证
	$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
			$("#btnSave").removeAttr("onclick");//提交锁定
			//判断是否选择了所属分类
			var productTypeId=$("#productTypeId").val();
			//名称
			var value = $("#name").val();
			$("#productTypeId").removeAttr("disabled"); 
			if(productTypeId!=null&&productTypeId!=""&&productTypeId!="-1"){
				$(document).ready(
					function() {
						var options = {  
							url : "${pageContext.request.contextPath}/back/productAttribute/saveOrUpdateProductAttr.action",  
							type : "post",  
							dataType:"json",
							success : function(data) {
								closeWin();
								$("#tt").datagrid("clearSelections");//删除后取消所有选项
								$("#tt").datagrid("reload"); //保存后重新加载列表
								$("#productAttrId").val(null);
								$("#btnSave").attr("onclick","$('#form1').submit();");//解除提交锁定
							}
						};
						var flag = true;
						//未修改的属性名称
						var productAttributeName = $("#productAttributeName").val();
						if(productAttributeName != value){
							$.ajax({
								type:"post",
								url:"${pageContext.request.contextPath}/back/productAttribute/checkName.action",
								data:{name:value,ids:productTypeId},
								success:function(data){
									if(data == "ok"){
										if(groupAttrValue(flag)){
											$("#form1").ajaxSubmit(options);  
										}
									}
								}
							});
						}else{
							if(groupAttrValue(flag)){
								$("#form1").ajaxSubmit(options);  
							}
						}
				});
			}else{
				msgShow("系统提示", "<p class='tipInfo'>所属分类不能为空！</p>", "warning");  
			}
		}
	});
	})
	//把填写的属性值追加成字符串
	function groupAttrValue(flag){
		var infos="";
		for(var i=0;i<newItemNumber;i++){
			var infoName= $("#sortValue"+i).val();
			var infoValue= $("#nameValue"+i).val();
			var attrValueId = $("#attrValueId"+i).val();
			//效验
			if((infoValue==null||infoValue=="")&&typeof infoValue !="undefined"){
				flag = false;
				var error=$("#error"+i).attr("id");
				if(error==null||error==""){
					$("#nameValue"+i).after("<label id='error"+i+"' style=' color: red;margin-left: 0.5em;position: relative;top: 0;width: 20em'>不可为空</label>");
				}
			}
			if(attrValueId==null||attrValueId==''){
				attrValueId = 0;
			}
			if(flag&&typeof infoName !="undefined"&&typeof infoValue !="undefined"){
				infos+=infoName+"_"+attrValueId+","+infoValue;
				if((newItemNumber-1)!=i){
					infos+="@";
				}
			}
		}
		//最后一个字符为@时，要截取掉
		if(infos!=null){
			var lastIndex = infos.lastIndexOf("@");
			if(Number(lastIndex)==Number(infos.length-1)){
				infos = infos.substr(0,lastIndex);
			}
		}
		$("#info").val(infos);
		return flag;
	}
	//查询属性名称是否已存在
	function checkName(){
		var value = $("#name").val();
		var id = "${productTypeId}";
		if(value!=""&&id!=""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/productAttribute/checkName.action",
				data:{name:value,ids:id},
				success:function(data){
					if(data == "ok"){
						$("#nameMsg").html("<em style='color:green'>可用</em>");
						$("#save").css("display","");
					}else{
						$("#nameMsg").html("<em style='color:red'>已存在</em>");
						$("#name").focus();
						$("#save").css("display","none");
					}
				}
			});
		}else{
			$("#nameMsg").html("");
		}
	}
	//变量记录追加了几个文本
	var newItemNumber = 1;
	function addType(){
		var html = "<tr class='addAttrValue'>"+
			"<td align='center'><input id='sortValue"+newItemNumber+"' type='text' name='sortValue"+newItemNumber+"' class='{validate:{required:true,digits:true}} attrValueSort' style='width:50px;' value='"+getMaxSortNum('attrValueSort')+"'/></td>"+
			"<td colspan='2' align='center'><input id='nameValue"+newItemNumber+"' type='text' name='nameValue"+newItemNumber+"' class='{validate:{required:true}}' value=''/></td>"+
			"<td align='center'><a onclick='remove_tr($(this),null);' href='javascript:'>移除</a></td>"+
			"</tr>";
		$('#tr_model > tr:last').after(html);
		newItemNumber++;
	}
	//移除文本
	function remove_tr(o,attributeValueId){
		if(attributeValueId!=null){
			ids = attributeValueId;
			$.ajax({
				type: "POST",dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/attributeValue/deleteAttributeValues.action",
				data: {ids:ids},
				success: function(data){
					if(data.isSuccess=="true"){
						o.parents('tr:first').remove();
						msgShow("系统提示", "<p class='tipInfo'>移除成功！</p>", "warning");
					}else{
						msgShow("系统提示", "<p class='tipInfo'>移除失败！</p>", "warning");
					}
				}
			});
		}else{
			o.parents('tr:first').remove();
		}
	}
	//初始化规格值
	function initAttributeValue(attributeValueList){
		$(".addAttrValue").remove();
		if(attributeValueList!=null){
			for(var i=0;i<attributeValueList.length;i++){
				if(i==0){
					$("#nameValue0").val(attributeValueList[i].attrValueName);
					$("#attrValueId0").val(attributeValueList[i].attrValueId);
					$("#sortValue0").val(attributeValueList[i].sort);
				}else{
					var html = "<tr class='addAttrValue'>"+
					"<td align='center'><input id='sortValue"+newItemNumber+"' type='text' name='sortValue"+newItemNumber+"' class='{validate:{required:true,digits:true}} attrValueSort' value='"+attributeValueList[i].sort+"' style='width:50px;'/></td>"+
					"<td  colspan='2' align='center'><input id='attrValueId"+newItemNumber+"' type='hidden' value='"+attributeValueList[i].attrValueId+"'/><input class='{validate:{required:true}}' id='nameValue"+newItemNumber+"' type='text' name='nameValue"+newItemNumber+"' value='"+attributeValueList[i].attrValueName+"'/></td>"+
					"<td align='center'><a onclick='remove_tr($(this),"+attributeValueList[i].attrValueId+");' href='javascript:'>移除</a></td>"+
					"</tr>";
					$('#tr_model > tr:last').after(html);
				}
				newItemNumber++;
			}
		}
	}
</script>
<div id="addOrEditWin">
	<input id="productAttributeName" type="hidden" value="" />
	<input id="attributeValueCount" type="hidden" value="0" />
	<form id="form1"  method="post">
		<input id="eproductTypeId" type="hidden" name="productAttribute.productTypeId" />
		<input id="productAttrId" type="hidden" name="productAttribute.productAttrId" />
		<input id="info" type="hidden" name="info" value=""/>
		<table align="center" class="addOrEditTable" style="width: 850px;">
			<tr>
				<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">属性信息</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>所属分类：</td>
				<td class="toleft_td">
					<span id="firstListHtml"></span>
					<select  id="productTypeId" disabled="disabled" class="{validate:{required:true}}">
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
													&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type4.sortName"/>
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
				<td class="toright_td" width="150px"><span style="color:red">* </span>属性名称：</td>
				<td class="toleft_td">
					<input style="width:155px" id="name" type="text" name="productAttribute.name" class="{validate:{required:true,maxlength:[150]}}"  onchange="checkName()"/>
					<span id="nameMsg"></span>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>排序：</td>
				<td class="toleft_td"><input style="width:70px" id="sort" type="text" name="productAttribute.sort" class="{validate:{required:true,digits:true,maxlength:[5]}}"/></td>
				<td class="toright_td"  width="150px"><span style="color:red">* </span>是否显示：</td>
				<td class="toleft_td">&nbsp;<input id="isListShow_0" name="productAttribute.isListShow" checked="checked"  type="radio" value="0"/>不显示&nbsp;&nbsp;&nbsp;<input id="isListShow_1"  type="radio" name="productAttribute.isListShow" onclick="javascript:checkAttrValueCount();" disabled="disabled" value="1"/>显示</td>
			</tr>
			<tr>
				<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">添加属性值</td>
			</tr>
			<tr class="titlebg">
				<td  width="20%"  style="font-weight:bold;text-align: center;"><span style="color:red">* </span>排序</td>
				<td  width="40%" colspan="2"  style="font-weight:bold;text-align: center;"><span style="color:red">* </span>属性值</td>
				<td  width="30%"  style="font-weight:bold;text-align: center;">操作</td>
			</tr>
			<tbody id="tr_model">
				<tr id="0"></tr>
				<tr id="1">
					<input id="attrValueId0" type="hidden"/>
					<td align="center" ><input id="sortValue0" type="text" class="{validate:{required:true,digits:true}} attrValueSort" name="sortValue0" value="1" style="width:50px;"/></td>
					<td colspan="2" align="center" ><input id="nameValue0" type="text" name="nameValue0" class="{validate:{required:true}}" value="" /></td>
					<td align="center"><a class="btn-add marginleft" id="add_type" href="javascript:addType();"> <span>添加属性值</span> </a></td>
				</tr>
			</tbody>
		</table>
</form>
<%-- <div id="ggz" style="display: ">
	<table align="center" class="addOrEditTable" style="width: 850px; height: 30px;">
		<tr>
			<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">添加属性值</td>
		</tr>
		<tr>
			<td class="titlebg" style="font-weight:bold;text-align: center;">属性值</td>
			<td class="titlebg" style="font-weight:bold;text-align: center;">排序</td>
			<td class="titlebg" style="font-weight:bold;text-align: center;">操作</td>
		</tr>
		<tbody id="tr_model">
			<tr id="0"></tr>
			<tr id="1">
				<input id="attrValueId0" type="hidden"/>
				<td align="center" ><input id="nameValue0" type="text" name="nameValue0" class="{validate:{required:true,digits:true}}" value="" /></td>
				<td align="center" ><input id="sortValue0" type="text" class="{validate:{required:true,digits:true}} attrValueSort" name="sortValue0" value="1" /></td>
				<td align="center"><a class="btn-add marginleft" id="add_type" href="javascript:addType();"> <span>添加属性值</span> </a></td>
			</tr>
		</tbody>
	</table>
</div> --%>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
