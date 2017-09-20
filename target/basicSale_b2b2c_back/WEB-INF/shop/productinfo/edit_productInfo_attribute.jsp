<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
		//提交修改商品属性表单
		function updateProductAttr(){
			$("#productAttrForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSaveProductAttr").removeAttr("onclick");
					var ropts ={
						url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductAttribute.action",
						type : "post",
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){
								msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
								$("#tt").datagrid("reload");
							}else{
								msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
							}
							$("#e_btnSaveProductAttr").attr("onclick","javascript:updateProductAttr();");
						}
					};
					$("#productAttrForm").ajaxSubmit(ropts);
				}
			});
			$("#productAttrForm").submit();
		}
		
		//参数属性初始化
		function initProdAttAndProPara(jaListProductAttr,jattributeValueList,jpaiList,ppINfo,productAttr,productPara) {
			//分类的属性start
			$("#e_totalProdAttr").html("");
			if (jaListProductAttr != "") {
				var listProductAttr = eval(jaListProductAttr); //分类属性的集合
				if (listProductAttr!=null&&listProductAttr.length > 0) {
					var htmlAttrStr = "";
					for (var i = 0; i < listProductAttr.length; i++) {
						var attributeValueList = eval(jattributeValueList);
						var ids="";
						var paiList = eval(jpaiList);
						for(var n = 0; n < paiList.length; n++){
							ids+=","+paiList[n].attrValueId;
						}
						if(ids!=""){
							ids+=",";
						}
						var tmp="";//作为临时组品的数据
						for (var j = 0; j < attributeValueList.length; j++) {
							if(listProductAttr[i].productAttrId==attributeValueList[j].productAttrId){
									if(ids.indexOf(","+attributeValueList[j].attrValueId+",")>=0){
										tmp += "<option style='width:80px ' value='" + attributeValueList[j].attrValueId + "' selected='selected'>" + attributeValueList[j].attrValueName + "</option>";
									}else{
										tmp += "<option style='width:80px ' value='" + attributeValueList[j].attrValueId + "'>" + attributeValueList[j].attrValueName + "</option>";
									}
							}
						}
						//如果tmp不为空 则添加对应的属性及属性值数据
						if(tmp!=""){
							if((i+1)%2==1){
								htmlAttrStr += "<tr>";
							}
							htmlAttrStr += "<th style='text-align: right;'>" + listProductAttr[i].name + ":</th><input type='hidden' name='listProdAttr[" + i + "].name'  value='" + listProductAttr[i].productAttrId + "'/>";
							if((i+1)%2==1&&i==(listProductAttr.length-1)){
								htmlAttrStr +=  "<td colspan='3'>";
							}else{
								htmlAttrStr +=  "<td>";
							}
							htmlAttrStr += "<select id='e_" + listProductAttr[i].name + "' name='listProdAttr[" + i + "].value'>";
							htmlAttrStr += tmp;
							htmlAttrStr += " </select></td>";
							if((i+1)%2==0){
								htmlAttrStr += "</tr>";
							}else{
								if(i==(listProductAttr.length-1)){
									htmlAttrStr += "</tr>";
								}
							}
						}
					}
					$("#e_totalProdAttr").html(htmlAttrStr);
				}
			}
			if (productAttr != "") {
				productAttr = eval(productAttr);
				for (var i = 0; i < productAttr.length; i++) {
					$("#e_" + productAttr[i].name).val(productAttr[i].value);
				}
			}
			//分类的属性end
			//分类的参数start
			if (ppINfo != "") {
				var htmlParaStr = '';
				var infoObj = eval(ppINfo);
				var trHtml = '';
				var h = 0;
				var trHtml = '';
				for (var i = 0; i < infoObj.length; i++) {
					trHtml += "<table id='e_parameterTable" + i + "' class='parameterTable' width='100%' style='margin:10px;'> ";
					trHtml += "<tr><td style='border: 0px solid #d0d0d0;'><strong style='text-align: center;width: 100%;display:inline-block;'>" + infoObj[i].name + "</strong></td><input type='hidden' name='listParamGroup[" + i + "].name' value='" + infoObj[i].name + "'/><input type='hidden'  name='listParamGroup[" + i + "].paramGroupId' value='" + infoObj[i].paramGroupId + "'/>";
					trHtml += "<input type='hidden'  name='listParamGroup[" + i + "].order' value='" + infoObj[i].order + "' style='width: 50px;' />";
					trHtml += "</tr>";
					trHtml += "<tr ><td style='border: 0px solid #d0d0d0;'><table id='e_parameterInfoTable" + i + "' width='100%'>";
					var a = eval(infoObj[i].paramGroupInfo);
					for (var u = 0; u < a.length; u++) {
						if((u+1)%2==1){//当前参数为第奇数个时，追加<tr>标签
							trHtml += "<tr>";
						}
						trHtml += " <th style='text-align: right;width: 200px'>" + a[u].name +"：</th><input type='hidden'  name='listParamGroupInfo[" + h + "].name' value='" + a[u].name + "'/>";
						if((u+1)%2==1&&u==(a.length-1)){
							trHtml += "<td colspan='3'>";
						}else{
							trHtml += "<td>";
						}
						trHtml += " <input type='hidden' id='e_pgiId0' name='listParamGroupInfo[" + h + "].pgiId' value='" + a[u].pgiId + "'/> ";
						trHtml += " <input type='hidden' name='listParamGroupInfo[" + h + "].order' value='" + a[u].order + "'/><input type='hidden' name='listParamGroupInfo[" + h + "].pgInfoId' value='" + a[u].pgInfoId + "'/>";
						trHtml += " <input type='text' id='e_"+a[u].pgInfoId+"' name='listParamGroupInfo[" + h + "].value' value='" + a[u].value +"'/> </td>";
						h++;
						if((u+1)%2==0){//当前参数为第偶数个时，追加</tr>标签
							trHtml += "</tr>";
						}else{
							if(u==(a.length-1)){//最后一行不够两个参数时，追加</tr>标签
								trHtml += "</tr>";
							}
						}
					}
					trHtml += "</table></td></tr>";
					trHtml += "</table>";
				}
				$("#e_totalProdPara").html(trHtml);
			}
			//分类中参数展示end
			//商品中参数赋值
			if (productPara != "") {
				var infoObj = eval(productPara);
				var h = 0;
				for (var i = 0; i < infoObj.length; i++) {
					var a = eval(infoObj[i].paramGroupInfo);
					for (var u = 0; u < a.length; u++) {
						$("#e_"+a[u].pgInfoId).val(a[u].value);
					}
				}
			}
		}
	</script>
	<form id="productAttrForm" action="" method="post">
		<input type="hidden" id="e_productId_productAttr" name="productId"/>
		<table id="e_totalProdAttr" style="margin:5px;width:97%"></table>
		<div style="padding:10px 0;">
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="e_btnSaveProductAttr" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductAttr();" href="javascript:;">保存</a>
				<a id="e_btnCancelProductAttr" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
