<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
		function updateProduct(){//表单验证
			$("#basicForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					var reg = /^[1-9]{1}\d*$/;//正整数正则
					if($("#e_marketPrice").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>市场价格必填!</p>", "warning");
						return false;
					}else if($("#e_salesPrice").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>销售价格必填!</p>", "warning");
						return false;
					}else if(parseInt($("#e_marketPrice").val())<parseInt($("#e_salesPrice").val())){
						msgShow("系统提示", "<p class='tipInfo'>销售价不能大于市场价!</p>", "warning");
						return false;
					}else if($("#e_storeNumber").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>库存必填!</p>", "warning");
						return false;
					}else if($("#e_productCode").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，套餐编号必填!</p>", "warning");
						isRepeats = false;
					}else if($("#e_measuringUnitName").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，计量单位必填!</p>", "warning");
						isRepeats = false;
					}else if($("#e_giveAwayCoinNumber").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，赠送购买者金币必填!</p>", "warning");
						isRepeats = false;
					}else if($("#e_shopProCategoryId").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，机构内部分类必填！</p>", "warning");  
						isRepeats = false;
						return isRepeats;
					}
					/* else if($("#e_barCode").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，条形码必填!</p>", "warning");
						isRepeats = false;
					}else if($("#e_weight").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，套餐重量必填!</p>", "warning");
						isRepeats = false;
					}else if($("#e_packingSpecifications").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，包装规格必填!</p>", "warning");
						isRepeats = false;
					}else if($("#e_manufacturerModel").val()==""){
						msgShow("系统提示", "<p class='tipInfo'>基本信息，制造商型号必填!</p>", "warning");
						isRepeats = false;
					} */
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSaveBaseInfo").removeAttr("onclick");
					var ropts ={
						url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductInfo.action",
						type : "post",
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){
								msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
								$("#tt").datagrid("reload");
							}else{
								msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
							}
							$("#e_btnSaveBaseInfo").attr("onclick","javascript:updateProduct();");
						}
					};
					$("#basicForm").ajaxSubmit(ropts);
				}
			});
			$("#basicForm").submit();
		}
		//初始化基本信息
		function initProductBaseInfo(productInfo){
			$("#e_smallPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+productInfo.logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
			$("#e_productTypeId-hidden").html(productInfo.productTypeId);
			$("#e_logoImg").val(productInfo.logoImg);
			$("#e_productName").val(productInfo.productName);
			$("#e_marketPrice").val(productInfo.marketPrice);
			$("#e_salesPrice").val(productInfo.salesPrice);
			$("#e_storeNumber").val(productInfo.storeNumber);
			$("#e_productCode").val(productInfo.productCode);
			$("#u_upRatio").val(productInfo.upRatio);
			$("#u_secRatio").val(productInfo.secRatio);
			$("#u_thiRatio").val(productInfo.thiRatio);
			assign(productInfo.measuringUnitName);//计量单位
			$("#e_packingSpecifications").val(productInfo.packingSpecifications);
			$("#e_manufacturerModel").val(productInfo.manufacturerModel);
			$("#e_giveAwayCoinNumber2").val(productInfo.giveAwayCoinNumber);
			$("#e_barCode").val(productInfo.barCode);
			$("#e_weight").val(productInfo.weight);
			$("#e_note").val(productInfo.note);
			$("#e_productId").val(productInfo.productId);
			$("#e_productId_functionDesc").val(productInfo.productId);
			$("#e_productId_productAttr").val(productInfo.productId);
			$("#e_productId_parameters").val(productInfo.productId);
			$("#e_productId_sourceImg").val(productInfo.productId);
			$("#e_productId_specifications").val(productInfo.productId);
			$("#e_seoTitle").val(productInfo.seoTitle);
			$("#e_seoKeyWord").val(productInfo.seoKeyWord);
			$("#e_seoDescription").val(productInfo.seoDescription);
		}
		//初始化发货地
		function initAddressProvince(firstAreaList,secondAreaList,deliveryAddressProvince,deliveryAddressCities){
			var addressHtml = "";
			addressHtml += "<select id='e_deliveryAddressProvince' name='productInfo.deliveryAddressProvince' onchange='chengeArea(this.value,\"1\",\"\",\"#e_deliveryAddressCities\")' class='{validate:{required:true}} select_zx'>";
			addressHtml += "<option value=''>--省--</option>";
			if(firstAreaList!=null){
				for(var i=0;i<firstAreaList.length;i++){
					if(Number(firstAreaList[i].aid)==Number(deliveryAddressProvince)){
						addressHtml += "<option  value='"+firstAreaList[i].aid+"' selected='selected'>"+firstAreaList[i].name+"</option>";
					}else{
						addressHtml += "<option  value='"+firstAreaList[i].aid+"' >"+firstAreaList[i].name+"</option>";
					}
				}
			}
			addressHtml += "</select>";
			addressHtml += "<select id='e_deliveryAddressCities' name='productInfo.deliveryAddressCities' class='{validate:{required:true}} select_zx' style='margin-left:3px;'>";
			addressHtml += "<option value=''>--地级市--</option>";
			if(secondAreaList!=null){
				for(var i=0;i<secondAreaList.length;i++){
					if(Number(secondAreaList[i].aid)==Number(deliveryAddressCities)){
						addressHtml += "<option  value='"+secondAreaList[i].aid+"' selected='selected'>"+secondAreaList[i].name+"</option>";
					}else{
						addressHtml += "<option  value='"+secondAreaList[i].aid+"' >"+secondAreaList[i].name+"</option>";
					}
				}
			}
			addressHtml += "</select>";
			$("#e_deliveryAddressProvinceTD").html(addressHtml);
		}
		//初始化机构内部分类
		function initShopProCategory(shopProCategoryList,shopProCategoryId){
			//初始化机构内部分类  shopCategery
			if(shopProCategoryList!=null){
				var shopCategeryHtml="";
				shopCategeryHtml+="<select id='e_shopProCategoryId' name='shopProCategoryId' class='{validate:{required:true}} select_zx'>";
				shopCategeryHtml+="<option value=''>请选择</option>";
				for(var i=0; i<shopProCategoryList.length; i++){
					if(shopProCategoryId==shopProCategoryList[i].shopProCategoryId){
						shopCategeryHtml+="<option  value='"+shopProCategoryList[i].shopProCategoryId+"' id='"+shopProCategoryList[i].shopProCategoryId+"' selected='selected'>"+shopProCategoryList[i].shopProCategoryName+"</option>";
					}else{
						shopCategeryHtml+="<option  value='"+shopProCategoryList[i].shopProCategoryId+"' id='"+shopProCategoryList[i].shopProCategoryId+"'>"+shopProCategoryList[i].shopProCategoryName+"</option>";
					}
				}
				shopCategeryHtml+="</select>";
			}
			$("#e_shopCategery").html(shopCategeryHtml);
		}
		
		//初始化套餐分类
		function initProductType(categoryLevel1,categoryLevel2,categoryLevel3,categoryLevel4){
			//定义变量
			var html1="";
			var html2="";
			var html3="";
			var html4="";
			//变量赋值
			//1
			<s:iterator value="#application.categoryMap" var="type1">
				if(<s:property value="#type1.key.productTypeId"/> == categoryLevel1){
					var name='<s:property value="#type1.key.sortName"/>';
					html1="<select disabled=\"disabled\" ><option>"+name+"</option></select>";
				}
			</s:iterator>
			//2
			<s:iterator value="#application.categoryMap" var="type1">
				if(<s:property value="#type1.key.productTypeId"/> == categoryLevel1){
					<s:iterator value="#type1.value" var="type2">
					if(<s:property value="#type2.key.productTypeId"/> == categoryLevel2){
						var name='<s:property value="#type2.key.sortName"/>';
						html2="<select disabled=\"disabled\" ><option>"+name+"</option></select>";
					}
					</s:iterator>
				}
			</s:iterator>
			//3
			<s:iterator value="#application.categoryMap" var="type1">
				if(<s:property value="#type1.key.productTypeId"/> == categoryLevel1){
					<s:iterator value="#type1.value" var="type2">
					if(<s:property value="#type2.key.productTypeId"/> == categoryLevel2){
						<s:iterator value="#type2.value" var="type3">
							if(<s:property value="#type3.key.productTypeId"/> == categoryLevel3){
								var name='<s:property value="#type3.key.sortName"/>';
								html3="<select disabled=\"disabled\" ><option>"+name+"</option></select>";
							}
						</s:iterator>
					}
					</s:iterator>
				}
			</s:iterator>
			//4
			if($("#categoryLevel4").val()!=null&&$("#categoryLevel4").val()!=""){
			<s:iterator value="#application.categoryMap" var="type1">
				if(<s:property value="#type1.key.productTypeId"/> == categoryLevel1){
					<s:iterator value="#type1.value" var="type2">
					if(<s:property value="#type2.key.productTypeId"/> == categoryLevel2){
						<s:iterator value="#type2.value" var="type3">
							if(<s:property value="#type3.key.productTypeId"/> == categoryLevel3){
								<s:iterator value="#type3.value" var="type4">
									if(<s:property value="#type4.productTypeId"/> == categoryLevel4){
										var name='<s:property value="#type4.sortName"/>';
										html4="<select disabled=\"disabled\" ><option>"+name+"</option></select>";
									}
								</s:iterator>
							}
						</s:iterator>
					}
					</s:iterator>
				}
			</s:iterator>
			}
			//将html文本显示在页面上
			$("#e_productType-span-1").html(html1);
			$("#e_productType-span-2").html(html2);
			$("#e_productType-span-3").html(html3);
			$("#e_productType-span-4").html(html4);
		}
		//初始化品牌和计量单位
		function initBrandAndMeasuringUnit(brandList,measuringUnitList,brandId,measuringUnitName){
			//品牌start
			var s="";
			if(brandList!=null){
				s = "<select id='e_brandId' name='productInfo.brandId' disabled=\"disabled\" class='{validate:{required:true}}'>";
				s+= "<option  value=''>";
				s+="请选择";
				s+="</option>";
				for(var i=0;i<brandList.length;i++){
					if(Number(brandList[i].brandId)==Number(brandId)){
						s+= "<option  value='"+brandList[i].brandId+"' selected='selected'>";
					}
					s+=brandList[i].brandName;
					s+="</option>";
				}
				s+="</select>";
			}
			$("#e_brandTd").html(s);
			//计量单位名称的选择
			var m="";
			if(measuringUnitList!=null){
				m = "<select id='e_measuringUnitName' name='productInfo.measuringUnitName' class='{validate:{required:true}}' onchange='assign(this.value);'>";
				m+= "<option  value=''>";
				m+="请选择";
				m+="</option>";
				for(var i=0;i<measuringUnitList.length;i++){
					if(measuringUnitList[i].name==measuringUnitName){
						m+= "<option  value='"+measuringUnitList[i].name+"' selected='selected'>";
					}else{
						m+= "<option  value='"+measuringUnitList[i].name+"'>";
					}
					m+=measuringUnitList[i].name;
					m+="</option>";
				}
				m+="</select>";
			}
			$("#e_measuringUnit").html(m);
		}
		function assign(value){
			$("#e_measuringUnitName1").html("/"+value);
		}
		
	</script>
	<form id="e_photoForm" method="post" enctype="multipart/form-data">
		<table style="margin:11px;">
			<tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐 Logo：</th>
				<td colspan="3">
					<input id="e_fileId" type="file" name="imagePath"/>
					<span id="e_mymessage"></span><br>
					<input id="e_buttonId" type="button" value="上传" style="width: 58px;" onclick="uploadProductPhoto('update','image_product')"/>
					<%-- &nbsp;&nbsp;<span><font color="RED">提示：请上传800*800像素的图片！</font></span> --%>
					<div class="imgMessage" style="margin-left:0px;">提示：请上传规格宽800px，高800px的图片</div>
				</td>
				<th class="toright_td">Logo预览：</th>
				<td style="text-align: center;width:42%;">
					<span id="e_smallPhoto"></span>
				</td>
			</tr> 
		</table>
	</form>
	<form id="basicForm"  action="" method="post" enctype="multipart/form-data">
		<input type="hidden" id="e_productId" name="productId"/>
		<input type="hidden" id="e_logoImg" name="productInfo.logoImg"/>
		<table style="margin:11px;">
			<%-- <tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐 Logo：</th>
				<td colspan="5">
					<span id="e_smallPhoto"></span>
					<input id="e_otherUploadImgsId" type="file" name="otherUploadImgs" value="" class="productImageFile"/>
					<s:property value="name"/>
				</td>
			</tr> --%>
			<tr>
				<th style="text-align: right;width:200px;"><i class="product_colorRed">*</i>&nbsp;套餐分类：</th>
				<td colspan="3">
					<input id="e_productTypeId-hidden" type="hidden" name="productInfo.productTypeId" />
					<span id="e_productType-span-1"></span>
					<span id="e_productType-span-2"></span>
					<span id="e_productType-span-3"></span>
					<span id="e_productType-span-4"></span>
				</td>
				<th style="text-align: right;"><i class="ColorRed">*</i>&nbsp;机构内部分类：</th>
				<td id="e_shopCategery"></td>
			</tr>
			<tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐名称：</th>
				<td><input  type="text" id="e_productName" disabled="disabled" name="productInfo.productName" class="{validate:{required:true,maxlength:[50]}} us_input" /></td>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐品牌：</th><td id="e_brandTd"></td>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;计量单位：</th><td id="e_measuringUnit"></td>
			</tr>
			<tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐编号：</th><td><input   type="text" id="e_productCode" name="productInfo.productCode" class="{validate:{required:true,maxlength:[30]}} us_input"  /></td>
				<th style="text-align: right; width:115px;"><i class="ColorRed">*</i>&nbsp;发货地：</th>
				<td id="e_deliveryAddressProvinceTD" colspan="3"></td>
			</tr>
			<tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;市场价格：</th><td><input id="e_marketPrice" type="text"  name="productInfo.marketPrice" class="{validate:{required:true,number:true}} us_input"/></td>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;销售价格：</th><td><input id="e_salesPrice" type="text" name="productInfo.salesPrice" class="{validate:{required:true,number:true}} us_input"/></td>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐库存：</th><td><input type="text" id="e_storeNumber" name="productInfo.storeNumber" class="{validate:{required:true,number:true,maxlength:[8]}} us_input"/></td>
			</tr>
			<tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;赠送金币：</th><td><input type="text" id="e_giveAwayCoinNumber2" name="productInfo.giveAwayCoinNumber" class="{validate:{required:true,number:true}} us_input"/></td>
				<th class="toright_td">&nbsp;套餐重量：</th><td><input id="e_weight" type="text" name="productInfo.weight" class="{validate:{number:true,maxlength:[10]}} us_input"  />&nbsp;&nbsp;&nbsp;kg<span id="e_measuringUnitName1"></span></td>
				<th class="toright_td">&nbsp;包装规格：</th><td><input type="text" id="e_packingSpecifications" name="productInfo.packingSpecifications" class="{validate:{maxlength:[200]}} us_input" /></td>
			</tr>
			<tr>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;上一级返利：</th><td><input type="text" id="u_upRatio" name="productInfo.upRatio" class="{validate:{required:true,number:true,max:99,min:1}} us_input" value="<s:property value="productInfo.upRatio" />"/>&nbsp;&nbsp;&nbsp;%</td>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;上二级返利：</th><td><input type="text" id="u_secRatio" name="productInfo.secRatio" class="{validate:{required:true,number:true,max:99,min:1}} us_input" value="<s:property value="productInfo.secRatio" />"/>&nbsp;&nbsp;&nbsp;%</td>
				<th class="toright_td"><i class="ColorRed">*</i>&nbsp;上三级返利：</th><td><input type="text" id="u_thiRatio" name="productInfo.thiRatio" class="{validate:{required:true,number:true,max:99,min:1}} us_input" value="<s:property value="productInfo.thiRatio" />"/>&nbsp;&nbsp;&nbsp;%</td>
			</tr>
			<tr>
				<th class="toright_td">&nbsp;条形码：</th><td><input type="text" id="e_barCode" name="productInfo.barCode" class="{validate:{number:true,maxlength:[13]}} us_input" /></td>
				<th class="toright_td">&nbsp;制造商型号：</th><td><input type="text" id="e_manufacturerModel" name="productInfo.manufacturerModel" class="text,{validate:{maxlength:[200]}} us_input"/></td>
				<th class="toright_td">套餐备提示：</th><td><input id="e_note" type="text" name="productInfo.note" class="{validate:{maxlength:[1000]}} us_input"/></td>
			</tr>
			<tr>
				<th class="toright_td">SEO 标题：</th><td><input id="e_seoTitle" type="text" name="productInfo.seoTitle" class="{validate:{maxlength:[100]}} us_input"/></td>
				<th class="toright_td">SEO 关键字：</th><td><input id="e_seoKeyWord" type="text" name="productInfo.seoKeyWord" class="{validate:{maxlength:[100]}} us_input"/></td>
				<th class="toright_td">SEO 描述：</th><td><input id="e_seoDescription" type="text" name="productInfo.seoDescription" class="{validate:{maxlength:[200]}} us_input"/></td>
			</tr>
		</table>
		<div style="padding:0px;">
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="e_btnSaveBaseInfo" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProduct();" href="javascript:;">保存</a>
				<a id="e_btnCancelBaseInfo" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
