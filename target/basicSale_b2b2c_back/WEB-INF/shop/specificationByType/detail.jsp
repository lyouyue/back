<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,450,"&nbsp;&nbsp;商品规格详情","icon-tip",false,"detailWin",5);
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$(".gzv").remove();
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/specification/getSpecificationInfo.action",
			   data: {specificationId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dname").html(data.specification.name);
				   $("#dnotes").html(data.specification.notes);
				   $("#dsort").html(data.specification.sort);
				   $("#dproductTypeId").val(data.specification.productTypeId);
				   if(data.specification.type=="0"){
					  $("#dtype").html("文本"); 
				   }else if(data.specification.type=="1"){
					  $("#dtype").html("图片"); 
				   }
				   var html = "<tr class='gzv'><td class='titlebg' colspan='2' align='center' style='font-weight:bold;'>排序号</td><td class='titlebg' colspan='2' align='center' style='font-weight:bold;' >规格值名称</td></tr>";
				   for(var i=0;i<data.specificationValueList.length;i++){
					   html += "<tr class='gzv'>"
					   html += "<td colspan='2' align='center'>"+data.specificationValueList[i].sort+"</td><td colspan='2' align='center'>"+data.specificationValueList[i].name+"</td>"
				   	   html += "</tr>";
				   }
				$("#ggzv").append(html);
			   }
		});
	}
</script>
<div id="detailWin">
	<table id="ggzv" align="center" class="addOrEditTable" style="width: 94%;margin-right:3%; margin-left:3%;text-align: center;">
		<tr><td class="titlebg" colspan="4" style="font-weight:bold;">规格信息</td></tr>
		<tr>
			<td class="toright_td" style="width: 25%;">所属商品分类:</td>
			<td class="toleft_td" style="width: 25%;">&nbsp;&nbsp;
				<select id="dproductTypeId" disabled="disabled">
					<s:iterator value="#application.productTypeList">
						<option value="<s:property value="productTypeId"/>"><s:property value="sortName"/></option>
					</s:iterator>
				</select>
			</td>
			<td class="toright_td" style="width: 25%;">规格名称:</td>
			<td class="toleft_td" style="width: 25%;">&nbsp;&nbsp;<span id="dname"></span></td>
		</tr>
		<tr>
			<td class="toright_td">规格备注:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dnotes"></span></td>
			<td class="toright_td">排序:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsort"></span></td>
		</tr>
		<tr><td class="titlebg" colspan="4" style="font-weight:bold;">规格值信息</td></tr>
   </table>
	<!-- <div id="div1">
		<table id="ggzv" class="addOrEditTable" style="width: 94%;margin-right:3%; margin-left:3%;text-align: center;">
		</table>
	</div> -->
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>