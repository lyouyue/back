<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,450,"&nbsp;&nbsp;套餐属性详情","icon-tip",false,"detailWin",10);
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			type: "POST", dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/productAttribute/getProductAttributeById.action",
			data: {ids:id},
			success: function(data){
				var productAttr =data.productAttr;
				$("#dname").html(productAttr.name);
				$("#dsort").html(productAttr.sort);
				if(productAttr.isListShow=="0"){
 					$("#disListShow").html("<font class='color_002'>不显示</font>");
 				}else{
 					$("#disListShow").html("<font class='color_001'>显示</font>");
 				}
				$("#dproductTypeId").val(productAttr.productTypeId);
				$(".daddAttrValue").remove();
				$("#dnameValue0").html("");
				$("#dsortValue0").html("");
				var attributeValueList = data.attributeValueList;
				if(attributeValueList!=null){
					var html = "<tr class='daddAttrValue'><td class='titlebg' colspan='2' align='center' style='font-weight:bold;'>排序号</td><td class='titlebg' colspan='2' align='center' style='font-weight:bold;' >属性值名称</td></tr>";
					for(var i=0;i<attributeValueList.length;i++){
						html += "<tr class='daddAttrValue'>"
						html += "<td colspan='2' align='center'>"+attributeValueList[i].sort+"</td><td colspan='2' align='center'>"+attributeValueList[i].attrValueName+"</td>"
						html += "</tr>";
					}
					$("#sxv").append(html);
				}
			}
		});
	}
</script>
<div id="detailWin">
		<table id="sxv" align="center" class="addOrEditTable" style="width: 94%;margin-right:3%; margin-left:3%;text-align: center;">
			<tr>
				<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">属性信息</td>
			</tr>
			<tr>
				<td class="toright_td" style="width: 25%;">所属分类：</td>
				<td class="toleft_td" style="width: 25%;">
					<select  id="dproductTypeId" disabled="disabled">
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
				<td class="toright_td" style="width: 25%;">属性名称：</td>
				<td class="toleft_td" style="width: 25%;">
					<span id="dname"></span>
				</td>
			</tr>
			<tr>
				<td class="toright_td">排序：</td>
				<td class="toleft_td">
					<span id="dsort"></span>
				</td>
				<td class="toright_td">是否显示：</td>
				<td class="toleft_td">&nbsp;<span id="disListShow"></span></td>
			</tr>
			<tr>
				<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">属性值信息</td>
			</tr>
		</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>