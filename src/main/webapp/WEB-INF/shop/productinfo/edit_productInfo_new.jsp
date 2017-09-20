<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<style type="text/css">
	#editProductWin{color: #595959; background-color:#FFF;font-size:12px !important;height:auto !important; height:100%;}
	#e_specificationSelect{overflow:hidden;}
	#e_totalProdAttr td{width:574px;height:30px;line-height:30px;}
	#e_totalProdAttr th{width:400px;height:30px;line-height:30px;}
</style>
<script type="text/javascript">
		function updateProduct(){//表单验证
			$("#basicForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSaveBaseInfo").removeAttr("onclick");
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
						msgShow("系统提示", "<p class='tipInfo'>基本信息，店铺内部分类必填！</p>", "warning");  
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
		//提交修改详情表单
		function updateFunctionDesc(){
			$("#proFunctionDescForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSaveFunctionDesc").removeAttr("onclick");
					$("#e_functionDescKE").val(editor2.html());
					var ropts ={
						url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductFunctionDesc.action",
						type : "post",
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){
								msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
								$("#tt").datagrid("reload");
							}else{
								msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
							}
							$("#e_btnSaveFunctionDesc").attr("onclick","javascript:updateFunctionDesc();");
						}
					};
					$("#proFunctionDescForm").ajaxSubmit(ropts);
				}
			});
			$("#proFunctionDescForm").submit();
		}
		//提交修改套餐属性表单
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
		//提交修改套餐参数表单
		function updateProductParameters(){
			$("#productParametersForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSaveProductParameters").removeAttr("onclick");
					var ropts ={
						url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductParameters.action",
						type : "post",
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){
								msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
								$("#tt").datagrid("reload");
							}else{
								msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
							}
							$("#e_btnSaveProductParameters").attr("onclick","javascript:updateProductParameters();");
						}
					};
					$("#productParametersForm").ajaxSubmit(ropts);
				}
			});
			$("#productParametersForm").submit();
		}
		//提交修改套餐图片表单
		function updateProductSourceImg(){
			var isSubmit = true;
			if(isSubmit){
				//判断标题是否为空
				$(".listProductImage_title").each(function(i) {
					if(!($(this).val()!=null&&$(this).val()!='')){
						msgShow("系统提示", "<p class='tipInfo'>图片，标题必填！</p>", "warning");  
						isSubmit = false;
						return false;
					}
				});
			}
			if(isSubmit){
				//判断排序是否为空
				$(".listProductImage_orders").each(function(i) {
					if(!($(this).val()!=null&&$(this).val()!='')){
						msgShow("系统提示", "<p class='tipInfo'>图片，排序必填！</p>", "warning");  
						isSubmit = false;
						return false;
					}
				});
			}
			if(isSubmit){
				//判断排序是否为空
				$(".source").each(function(i) {
					if(!($(this).val()!=null&&$(this).val()!='')){
						msgShow("系统提示", "<p class='tipInfo'>图片，图片必须上传！</p>", "warning");  
						isSubmit = false;
						return false;
					}
				});
			}
			if(isSubmit){
				//控制保存按钮变灰，避免重复提交
				$("#e_btnSaveProductSourceImg").removeAttr("onclick");
				var ropts ={
					url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductSourceImg.action",
					type : "post",
					dataType:"json",
					success : function(data) {
						if(data.isSuccess){
							var productImgIdList = data.productImgIdList;
							$(".productImg").each(function(i) {
								$(this).val(productImgIdList[i]);
							});
							msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
							$("#tt").datagrid("reload");
						}else{
							msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
						}
						$("#e_btnSaveProductSourceImg").attr("onclick","javascript:updateProductSourceImg();");
					}
				};
				$("#productSourceImgForm").ajaxSubmit(ropts);
			}
		}
		//提交修改套餐规格、价格和库存表单
		function updateProductSpecifications() {
			$(".addDisabled").removeAttr("disabled");
			$("#e_specificationsForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSavespecifications").removeAttr("onclick");
					var submitFlag=validateUpdateSubmit();
					//表单提交
					if(submitFlag){
						var ropts ={
							url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductSpecification.action",
							type : "post",
							dataType:"json",
							success : function(data) {
								if(data.isSuccess){
									msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
									$("#tt").datagrid("reload");
									//删除选择规格部分
									$("#e_specificationSelect").empty();
									//删除添加规格表表头部分
									$("#e_specificationProductTable-title").empty();
									//删除添加规格表的每一行
									$(".e_selectedSpecificationValuesTD").remove();
									var productId = $("#e_productId_specifications").val();
									$.ajax({
										type: "POST",dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoByProductId.action",
										data:{productId:productId},
										async:false,
										success: function(data){
											if(data!=null){
												//初始化规格
												initSpecification(data.specificationList,data.productInfo.goods,data.productInfo.productId);
											}
										}
									});
									//closeWin();
								}else{
									msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
								}
								$("#e_btnSavespecifications").attr("onclick","javascript:updateProductSpecifications();");
							}
						};
						$("#e_specificationsForm").ajaxSubmit(ropts);
					}else{
						$("#e_btnSavespecifications").attr("onclick","javascript:updateProductSpecifications();");
					}
				}
			});
			$("#e_specificationsForm").submit();
		}
		function validateUpdateSubmit(){
			//是否有重复
			var isRepeats = true;
			var specifications = new Array();
			var speciArray = new Array();
			//判断添加的规格值是否有重复的
			$("#e_specificationProductTable").find("tr:gt(0)").each(function(i) {//找到添加规格行
				var specificationValues = $(this).find("select").serialize();//找到当前行的所有规格值组下拉框，并把当前的规格值组序列化
				if(specificationValues!=""){
					var inputparam = $(this).find("input").serialize();//找到当前行的所有文本框，并序列化
					var count=specificationValues.split("&").length;
					var tmp=specificationValues.substring(0,specificationValues.indexOf("specification"));
					//替换所有的指定字符串为空“127-277-”
					//即将127-277-specification_2=4&127-277-specification_86=503&127-277-specification_87=506转化成
					//specification_2=4&specification_86=503&specification_87=506
					if(tmp!=""){
						var specificationValuesReplaced=specificationValues;
						specificationValuesReplaced=specificationValuesReplaced.replace(eval("/"+tmp+"/g"),'');
					}else{
						specificationValuesReplaced=specificationValues;
					}
					if ($.inArray(specificationValuesReplaced, speciArray)>=0) {//判断当前行的规格值是否存在之前的数组中
						msgShow("系统提示", "<p class='tipInfo'>套餐规格重复！</p>", "warning");  
						isRepeats = false;
						$(".addDisabled").attr("disabled","disabled");
						return false;
					} else {
						speciArray.push(specificationValuesReplaced);//存放到规格的数组中，下次对比使用
						specifications.push(specificationValues +"@"+ inputparam);//保存使用的数组
					}
				}
			});
			/* 1137-2803-specification_90=270&1137-2803-specification_91=275
			@productId=2803&marketPrice=44&salesPrice=22&storeNumber=2,
			1137-2802-specification_90=270&1137-2802-specification_91=274
			@productId=2802&marketPrice=33&storeNumber=2,
			specification_90=270&specification_91=276@
			productId=0&marketPrice=22&salesPrice=11&storeNumber=1 */
			if (isRepeats) {
				isRepeats = changePrice(isRepeats);//校验价格不为空 且销售价不大于市场价
				if(isRepeats){
					$("#e_specifications").val(specifications);
					return true;
				}else{
					$(".addDisabled").attr("disabled","disabled");
					return false;
				}
			}else{
				$(".addDisabled").attr("disabled","disabled");
				 return false;
			}
			return true;
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
		//初始化店铺内部分类
		function initShopProCategory(shopProCategoryList,shopProCategoryId){
			//初始化店铺内部分类  shopCategery
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
			//套餐中参数赋值
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
		//新增的规格tr计数器，便于动态生成存放规格的tr
		var e_count_specificationValues_id_index=0;
		//存放当前分类下的所有规格，用于动态控制不同规格以及对应的规格值的展示
		var specificationArray=new Array();
		//初始化规格
		function initSpecification(specificationList,goods,productId) {
			var specificationHtmlStr="";
			if(specificationList!=null){
				for(var i=0;i<specificationList.length;i++){
					var specificationId=specificationList[i].specificationId;
					specificationArray.push(specificationId);
					var name=specificationList[i].name;
					var notes=specificationList[i].notes;
					var specification_param=specificationId+"_"+name+"_"+notes;
					specificationHtmlStr+="<div style='float:left;margin:5px 10px;'>";
					specificationHtmlStr+="<span style='display:block;'>";
					specificationHtmlStr+="<input disabled='disabled' onclick='changeSelectedSpecification("+specificationId+")' id='e_"+specificationId+"' class='check' name='specificationIds' type='checkbox' value='"+specification_param+"'/>";
					specificationHtmlStr+="&nbsp;<label for='e_"+specificationId+"'>"+name;
					specificationHtmlStr+="[&nbsp;"+notes+"&nbsp;]</label></span></div>";
				}
			}
			$("#e_specificationSelect").html(specificationHtmlStr);
			if(specificationHtmlStr!=""){
				initSelectedSpecificationValue(goods,productId);
			}
			//是否锁定复选框
			initLockCheckBox();
		}

		//初始化显示规格对应的规格值
		function initSelectedSpecificationValue(goods,productId){
			var specificationIdArray =new Array();
			$("#e_specificationSelect input:checked").each(function(i){
				var specificationValueStringArray=this.value.split("_");
				var specificationId=specificationValueStringArray[0];
				specificationIdArray.push(specificationId);
			});
			var selectedSpecificationValuesHtmlStr="";
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/productinfo/getGoodsProductSpecificationValue.action",
				async:false,
				data: {goods:goods,productId:productId},
				success: function(data){
					if(data!=null){
						var productInfoList = data.productInfoList;
						var data = data.psvGroupList;
						for(i=0;i<data[0].length;i++){
							var productSpecificationValueObj=data[0][i];
							var selectedSpecificationId=productSpecificationValueObj.specificationId;
							document.getElementById("e_"+selectedSpecificationId).checked=true;
						}
						var specificationProductHtmlStr="";
						$("#e_specificationProductTable-title").css("display","");
						var isOwnChecked=false;
						$("#e_specificationSelect input:checked").each(function(i){
							isOwnChecked=true;
							var specificationValueStringArray=this.value.split("_");
							var specificationId=specificationValueStringArray[0];
							var name=specificationValueStringArray[1];
							var notes=specificationValueStringArray[2];
							specificationProductHtmlStr+="<th style='text-align:center;padding:5px 10px;width:15%' id='specification_"+specificationId+"'>";
							specificationProductHtmlStr+="<span  style='margin:6px; display:inline;  white-space:nowrap;'>"+name+"</span>";
							specificationProductHtmlStr+="<span  style=''>[&nbsp;"+notes+"&nbsp;]</span></th>";
						});
						specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;市场价格</th>";
						specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;销售价格</th>";
						specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;套餐库存</th>";
						specificationProductHtmlStr+="<th style='text-align:center;width:8%'>&nbsp;上/下架状态</th>";
						specificationProductHtmlStr+="<th style='text-align:center;'>操作</th>";
						$("#e_specificationProductTable-title").html(specificationProductHtmlStr);
						for(i=0;i<data.length;i++){
							var selectedSpecificationValuesHtmlStr="";
							e_count_specificationValues_id_index=i;
							var old_productId="";
							var priceAndStoreHtml="";
							for(j=0;j<data[i].length;j++){
								var productSpecificationValueObj=data[i][j];
								var goodId=productSpecificationValueObj.goodId;
								var productId=productSpecificationValueObj.productId;
								var specificationValueId=productSpecificationValueObj.specificationValueId;
								var specificationId=productSpecificationValueObj.specificationId;
									$.ajax({
										type: "POST",
										dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/productinfo/getSpecificationValueBySpecificationId.action",
										async:false,
										data: {specificationId: specificationId},
										success: function(data){
											if(data!=null){
												var ssv_obj=$("#e_selectedSpecificationValues_"+e_count_specificationValues_id_index);
												if(ssv_obj.attr("id")==null){
													var ssvTrHtml="<tr class='e_selectedSpecificationValuesTD' id='e_selectedSpecificationValues_"+e_count_specificationValues_id_index+"'></tr>";//动态创建多组tr
													$("#e_specificationProductTable").append(ssvTrHtml);
												}
												specificationValueList=data;
												selectedSpecificationValuesHtmlStr+="<td class='e_specificationValue_"+specificationId+"'  style='text-align:center;'>";
												for(var k=0;k<productInfoList.length;k++){
													if(productInfoList[k]!=null&&productInfoList[k].productId==productId){
														//上下架显示 1下架 2上架
														if(k>0&&productInfoList[k].isPutSale==2){
															selectedSpecificationValuesHtmlStr+="<select disabled=disabled id='"+e_count_specificationValues_id_index+"_"+specificationId+"' class='e_disable_"+specificationId+" e_sort_"+specificationId+" addDisabled' name='"+goodId+"-"+productId+"-specification_"+specificationId+"'>";
														}else{
															selectedSpecificationValuesHtmlStr+="<select id='"+e_count_specificationValues_id_index+"_"+specificationId+"' class='e_disable_"+specificationId+" e_sort_"+specificationId+"' name='"+goodId+"-"+productId+"-specification_"+specificationId+"'>";
														}
													}
												}
												
												for(var i=0;i<specificationValueList.length;i++){
												var specificationValue=specificationValueList[i];
												if(specificationValueId==specificationValue.specificationValueId){
													selectedSpecificationValuesHtmlStr+="<option selected value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
												}else{
													selectedSpecificationValuesHtmlStr+="<option value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
												}
											}
											selectedSpecificationValuesHtmlStr+="</select></td>";
										}
									}
								});
								for(var k=0;k<productInfoList.length;k++){
									if(productInfoList[k]!=null&&productId!=old_productId&&productInfoList[k].productId==productId){
										priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_productId_"+e_count_specificationValues_id_index+"' type='hidden'  name='productIdParam' value='"+productInfoList[k].productId+"' />";
										priceAndStoreHtml+="<input id='e_marketPric_"+e_count_specificationValues_id_index+"' type='text'  name='marketPrice' value='"+productInfoList[k].marketPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										/* if(k>0){
											//上下架显示 1下架 2上架
											if(productInfoList[k].isPutSale==2){
												priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input disabled='disabled' id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
											}else{
												priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
											}
										}else{
											priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										} */
										priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_storeNumber_"+e_count_specificationValues_id_index+"' type='text' name='storeNumber' value='"+productInfoList[k].storeNumber+"' class='{validate:{required:true,number:true,maxlength:[8]}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										if(productInfoList[k].isPutSale==2){
											priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><font color='RED'>上架</font></td>";
										}else{
											priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><font color='GREEN'>下架</font></td>";
										}
									}
								}
								old_productId = productId; 
							}
							selectedSpecificationValuesHtmlStr+=priceAndStoreHtml;
							if(i>0){
								selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='padding-left:10px; width:120px; white-space:nowrap;text-align: center;'><a href='javascript:removeSpecification("+productId+","+e_count_specificationValues_id_index+");' >[&nbsp;解除组关联&nbsp;]</a></td>";
							}else{
								selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='padding-left:10px; width:120px; white-space:nowrap;'></td>";
							}
							$("#e_selectedSpecificationValues_"+e_count_specificationValues_id_index).html(selectedSpecificationValuesHtmlStr);
						}
					}
				}
			});
		}
		//操作复选框显示选中的规格以及对应的规格值
		function changeSelectedSpecification(specificationId){
			var isChecked=$("#e_"+specificationId).attr("checked");
			if(isChecked!="checked"){
				$(".e_specificationValue_"+specificationId).hide();
				$(".e_disable_"+specificationId).attr("disabled",true);
			}else{
				var objsArray=$(".e_specificationValue_"+specificationId);
				if(objsArray!=null&&objsArray.length==0){
					var opSpecificationId=0;
					for(i=0;i<specificationArray.length;i++){
						if(specificationArray[i]==specificationId){
							if(i==0){
								opSpecificationId=specificationArray[i+1];
							}else{
								opSpecificationId=specificationArray[i-1];
							}
							break;
						}
					}
					var selectedSpecificationValuesHtmlStr=changeSelectedSpecificationValue(specificationId);
					$(".e_specificationValue_"+opSpecificationId).each(function(i){
						$(this).after(selectedSpecificationValuesHtmlStr);
					});
				}else{
					$(".e_specificationValue_"+specificationId).show();
					$(".e_disable_"+specificationId).attr("disabled",false);
				}
			}
			var check_objs=$("#e_specificationSelect input:checked");
			//if(check_objs.length<3){
				var selectedSpecificationValuesHtmlStr="";
				var specificationProductHtmlStr="";
				$("#e_specificationProductTable-title").css("display","");
				$("#e_specificationSelect input:checked").each(function(i){
					isOwnChecked=true;
					var specificationValueStringArray=this.value.split("_");
					var specificationId=specificationValueStringArray[0];
					var name=specificationValueStringArray[1];
					var notes=specificationValueStringArray[2];
					specificationProductHtmlStr+="<th style='text-align:center;padding:5px 10px;' id='specification_"+specificationId+"'>";
					specificationProductHtmlStr+="<span  style='margin:5px 15px 5px 5px; display:inline;'>"+name+"</span>";
					specificationProductHtmlStr+="<span  style='margin:0px;15px 5px 5px; display:inline;'>[&nbsp;"+notes+"&nbsp;]</span></th>";
					
				});
				specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;市场价格</th>";
				specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;销售价格</th>";
				specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;套餐库存</th>";
				specificationProductHtmlStr+="<th style='text-align:center;width:8%'>&nbsp;上/下架状态</th>";
				specificationProductHtmlStr+="<th style='text-align:center;'>操作</th>";
				$("#e_specificationProductTable-title").html(specificationProductHtmlStr);
				if(check_objs.length==0){
					$(".e_delete_text").hide();
				}else{
					$(".e_delete_text").show();
				}
			//}else if(check_objs.length>2){
				//$("#"+specificationId).attr("checked",false);
				//$.messager.alert("提醒", "最多选择两个规格!");
			//}
		}
		//显示规格对应的规格值
		function changeSelectedSpecificationValue(specificationId){
			var selectedSpecificationValuesHtmlStr="";
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/productinfo/getSpecificationValueBySpecificationId.action",
				async:false,
				data: {specificationId: specificationId},
				success: function(data){
					specificationValueList=data;
					selectedSpecificationValuesHtmlStr+="<td style='text-align:center;' class='e_specificationValue_"+specificationId+"'>";
					selectedSpecificationValuesHtmlStr+="&nbsp;&nbsp;<select class='e_disable_"+specificationId+" e_sort_"+specificationId+"' name='specification_"+specificationId+"' style='margin-left:-6px;'>";
					for(var i=0;i<specificationValueList.length;i++){
						var specificationValue=specificationValueList[i];
						selectedSpecificationValuesHtmlStr+="<option value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
					}
					selectedSpecificationValuesHtmlStr+="</select></td>";
				}
			});
			return selectedSpecificationValuesHtmlStr;
		}
		//添加规格值
		function addNewSpecificationValueUpdate(){
			var marketPrice=$("#e_marketPrice").val();
			var salesPrice=$("#e_salesPrice").val();
			var storeNumber=$("#e_storeNumber").val();
			var check_objs=$("#e_specificationSelect input:checked");
			if(check_objs!=null&&check_objs.length>0){
				e_count_specificationValues_id_index++;
				var newTrHtmlStr="<tr class='e_selectedSpecificationValuesTD' id='e_selectedSpecificationValues_"+e_count_specificationValues_id_index+"'>";
				var selectedSpecificationValuesHtmlStr="";
				var isOwnChecked=false;
				$("#e_specificationSelect input:checked").each(function(i){
					isOwnChecked=true;
					var specificationValueStringArray=this.value.split("_");
					var specificationId=specificationValueStringArray[0];
					var name=specificationValueStringArray[1];
					var notes=specificationValueStringArray[2];
					selectedSpecificationValuesHtmlStr+=changeSelectedSpecificationValue(specificationId);
				});
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_productId_"+e_count_specificationValues_id_index+"' type='hidden'  name='productIdParam' value='0' />";
				selectedSpecificationValuesHtmlStr+="<input id='e_marketPric_"+e_count_specificationValues_id_index+"' type='text'  name='marketPrice' value='"+marketPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_storeNumber_"+e_count_specificationValues_id_index+"' type='text' name='storeNumber' value='"+storeNumber+"' class='{validate:{required:true,number:true,maxlength:[8]}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><font color='GREEN'>下架</font></td>";
				if(isOwnChecked){
					selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='padding-left:10px; width:120px; white-space:nowrap;text-align: center;'><a class='opt_links' href='javascript:deleteSpecificationUpdate("+e_count_specificationValues_id_index+");'>删除</a></td>";
				}
				newTrHtmlStr+=selectedSpecificationValuesHtmlStr+"</tr>";
				$("#e_specificationProductTable").append(newTrHtmlStr);
				editLockCheckBox();//锁住复选框
			}else{
				msgShow("系统提示", "<p class='tipInfo'>至少选择一个规格！</p>", "warning");  
			}
		}
		// 删除规格套餐
		function deleteSpecificationUpdate(specificationValues_id_index){
			$("#e_selectedSpecificationValues_"+specificationValues_id_index).remove();
			if($("#e_specificationProductTable tr").length==1){
				unEditLockCheckBox();
			}
		}
		// 异步解除当前套餐所在组的规格以及规格值的关联关系
		function removeSpecification(productId,e_count_specificationValues_id_index){
			$.messager.confirm("系统提示", "<p class='tipInfo'>套餐规格组解除后将无法恢复！</p>",function(data){
				var optionProductId = $("#e_productId").val();
				if(data){
					$.ajax({
						type: "POST",
						dataType: "JSON",
						url: "${pageContext.request.contextPath}/back/productinfo/removeProductSpecificationValueGoodsGuanlian.action",
						data: {productId: productId,optionProductId:optionProductId},
						success: function(data){
							if(data.isSuccess){
								$("#e_selectedSpecificationValues_"+e_count_specificationValues_id_index).remove();
							}
						}
					});
				}
				return true;
			});
		}
		//初始化图片
		function initProductImg(productImgList){
			var $e_productImageTable = $("#e_productImageTable");
			var trHtml = "";
			if(productImgList!=null){
				for(var i=0;i<productImgList.length;i++){
					var Index=i;
					trHtml += "<tr class='e_imgs' id='e_img_"+ Index +"'> '+'<input class='source' type='hidden' name='listProductImage["+Index+"].source' id='e_source"+Index+"' value='"+productImgList[i].source+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].productId' id='e_productId"+Index+"' value='"+productImgList[i].productId+"'/>";
					trHtml+= "<input type='hidden' class='productImg' name='listProductImage["+Index+"].productImageId' id='e_productImageId"+Index+"' value='"+productImgList[i].productImageId+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].large' id='e_large"+Index+"' value='"+productImgList[i].large+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].medium' id='e_medium"+Index+"' value='"+productImgList[i].medium+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].thumbnail' id='e_thumbnail"+Index+"' value='"+productImgList[i].thumbnail+"'/>";
					//图片上传开始
					trHtml+= "<td style='text-align: center;'>";
					trHtml+= "<form id='e_photoForm_"+ Index +"' method='post' enctype='multipart/form-data'>";
					trHtml+= "<table align='center' class='addOrEditTable' width='740px' style='margin-top: 0;'>";
					trHtml+= "<tr>";
					trHtml+= "<td style='text-align: center;'>&nbsp;&nbsp;";
					trHtml+= "<span id='e_photo_"+ Index +"'><img id='e_photoImg_"+ Index +"' style='width:40px;height:40px;margin-left:-8px;margin-bottom:-8px;' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' src='${fileUrlConfig.uploadFileVisitRoot}"+productImgList[i].source+"'/></span>";
					trHtml+= "</td>";
					trHtml+= "<td  style='text-align: center;padding:7px 7px;' >";
					trHtml+= "<span id='e_mymessag"+ Index +"'></span>";
					trHtml+= "<input id='e_fileId_"+ Index +"' type='file' name='imagePath' style='width:145px;float:left;margin-top:5px;'/>";
					trHtml+= "<input id='e_buttonId_"+ Index +"' style='float:left;margin-top:3px;' type='button' value='上传预览' onclick='uploadProPhotoUpdate("+ Index +")'/>";
					trHtml+= "</td>";
					trHtml+= "</tr>"; 
					trHtml+= "</table>";
					trHtml+= "</form>";
					trHtml+= "</td>";
					//图片上传结束
					trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].title' value='"+productImgList[i].title+"' class='listProductImage_title product_input' maxlength='150' style='width:210px;'/> </td> ";
					trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].orders' value='"+productImgList[i].orders+"' class='listProductImage_orders product_input' maxlength='9' style='width: 50px !important;'/> </td>";
					trHtml+= "<td style='text-align: center;'> <a  href='javascript:;' class='opt_links deletopt' onclick='javascript:deleteProductImageUpdate("+Index+","+productImgList[i].productImageId+");'>删除</a> </td> </tr>";
				}
			}
			$e_productImageTable.append(trHtml);
		}
		//增加套餐图片
		function addProductImageHtmlUpdate(){
			var $e_productImageTable = $("#e_productImageTable");
			var Index = $(".e_imgs").length;
			var trHtml = "<tr class='e_imgs' id='e_img_"+ Index +"'> '+'<input class='source' type='hidden' name='listProductImage["+Index+"].source' id='e_source"+Index+"' value=''/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].productId' id='e_productId"+Index+"' value=''/>";
			trHtml+= "<input type='hidden' class='productImg' name='listProductImage["+Index+"].productImageId' id='e_productImageId"+Index+"' value=''/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].large' id='e_large"+Index+"' value='"+Index+"'/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].medium' id='e_medium"+Index+"' value='"+Index+"'/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].thumbnail' id='e_thumbnail"+Index+"' value='"+Index+"'/>";
			//图片上传开始
			trHtml+= "<td style='text-align: center;'>";
			trHtml+= "<form id='e_photoForm_"+ Index +"' method='post' enctype='multipart/form-data'>";
			trHtml+= "<table align='center' class='addOrEditTable' width='740px' style='margin-top: 0;'>";
			trHtml+= "<tr>";
			trHtml+= "<td style='text-align: center;'>&nbsp;&nbsp;";
			trHtml+= "<span id='e_photo_"+ Index +"'><img id='e_photoImg_"+ Index +"' style='width:40px;height:40px;margin-left:-8px;margin-bottom:-8px;' src='${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png'/></span>";
			trHtml+= "</td>";
			trHtml+= "<td  style='text-align: center;padding:7px 7px;' >";
			trHtml+= "<span id='e_mymessag"+ Index +"'></span>";
			trHtml+= "<input id='e_fileId_"+ Index +"' type='file' name='imagePath' style='width:145px;float:left;margin-top:5px;'/>";
			trHtml+= "<input id='e_buttonId_"+ Index +"' style='float:left;margin-top:3px;' type='button' value='上传预览' onclick='uploadProPhotoUpdate("+ Index +")'/>";
			trHtml+= "</td>";
			trHtml+= "</tr>"; 
			trHtml+= "</table>";
			trHtml+= "</form>";
			trHtml+= "</td>";
			//图片上传结束
			
			trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].title' class='listProductImage_title product_input' maxlength='150' style='width:210px;'/> </td> ";
			trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].orders' class='listProductImage_orders product_input' maxlength='9' style='width: 50px !important;' value='"+getMaxSortNum('listProductImage_orders')+"'/> </td>";
			trHtml+= "<td style='text-align: center;'> <a  href='javascript:;' class='opt_links deletopt' onclick='javascript:deleteProductImageUpdate("+Index+",0);'>删除</a> </td> </tr>";
			$e_productImageTable.append(trHtml);
		}
		//上传图片
		function uploadProPhotoUpdate(imageIndex) {
			//添加上传提示信息，控制按钮不可用
				addFormPhotoMessageUpdate(imageIndex);
				$(document).ready( function() {
					var options = {
						//url : "${pageContext.request.contextPath}/back/upload/asyncUploadImage.action?imageInfoPath="+imageInfoPath,
						url : "${pageContext.request.contextPath}/back/productinfo/uploadImageFront.action?is_ajax=2",
						type : "post",
						dataType : "json",
						async:false,
						success : function(data) {
							//清空上传提示信息，恢复按钮可用
							clearFormPhotoMessageUpdate(imageIndex);
							if(data.photoUrl=="false"){
								msgShow("系统提示", "<p class='tipInfo'>文件扩展名不是PNG或JPG！</p>", "warning");  
							}else if(data.photoUrl=="false2"){
								msgShow("系统提示", "<p class='tipInfo'>请选择图片后再上传！</p>", "warning");  
							}else{
								var productImg = data.photoUrl;
								$("#e_photoImg_"+imageIndex).attr('src',data.uploadFileVisitRoot+productImg.source);
								$("#e_photoImg_"+imageIndex).attr('alt',data.uploadFileVisitRoot+productImg.source);
								$("#e_source"+imageIndex).val(productImg.source);
								$("#e_large"+imageIndex).val(productImg.large);
								$("#e_medium"+imageIndex).val(productImg.medium);
								$("#e_thumbnail"+imageIndex).val(productImg.thumbnail);
							}
						}
					};
					$("#e_photoForm_"+imageIndex).ajaxSubmit(options);
				});
		}
		//添加上传提示信息，控制按钮不可用
		function addFormPhotoMessageUpdate(imageIndex){
			$("#e_mymessag"+imageIndex).html("<font style='color:green'>文件提交中......</font>");//修改提示信息
			$("#e_buttonId_"+imageIndex).attr("disabled","true");//提交按钮不可用
		}
		
		//清空上传提示信息，恢复按钮可用
		function clearFormPhotoMessageUpdate(imageIndex){
			$("#e_mymessag"+imageIndex).html("");//清空提示信息
			$("#e_buttonId_"+imageIndex).removeAttr("disabled");//提交按钮恢复可用
		}
		// 删除套餐图片
		function deleteProductImageUpdate(value,productImageId){
			if(productImageId!=0&&productImageId!=null){
				$.messager.confirm("系统提示", "<p class='tipInfo'>套餐图片删除后将无法恢复！</p>",function(data){
					if(data){
							$.ajax({
								type: "POST",
								dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/productinfo/deleteProductImg.action",
								data: {productImageId: productImageId},
								success: function(data){
									if(data.flag){
										$("#e_img_"+value).remove();
										msgShow("系统提示", "<p class='tipInfo'>删除图片成功！</p>", "warning");  
									}else{
										msgShow("系统提示", "<p class='tipInfo'>删除图片失败！</p>", "warning");  
									}
								}
							});
					}
					return true;
				});
			}else{
				$("#e_img_"+value).remove();
			}
		}
		function editLockCheckBox(){
			$("#e_specificationSelect input").each(function(i){
				$(this).attr("disabled","disabled");
			});
		}
		function initLockCheckBox(){
			if($("#e_specificationProductTable tr").length==1){
				unEditLockCheckBox();
			}
		}
		function unEditLockCheckBox(){
			$("#e_specificationSelect input").each(function(i){
				$(this).removeAttr("disabled");
			});
		}
		function checkOrder(obj){
			if(!/^\d+$/.test(obj.value)){
				obj.value="";
			}else if(obj.value.length>5){
				obj.value="";
			}
		}
		function assign(value){
			$("#e_measuringUnitName1").html("/"+value);
		}
		
	</script>
	<div id="editProductWin" >
		<div class="product_content">
			<!--right-->
			<div id="product_rightBox" >
				<div class="easyui-tabs" id="editTab">
					<!-- 修改套餐基本信息 -->
					<div title="基本信息" class="addProductByPT setWidth">
						<form id="e_photoForm" method="post" enctype="multipart/form-data">
							<table style="margin:11px;">
								<tr>
									<th class="toright_td"><i class="ColorRed">*</i>&nbsp;套餐 Logo：</th>
									<td colspan="3">
										<input id="e_fileId" type="file" name="imagePath"/>
										<span id="e_mymessage"></span><br>
										<input id="e_buttonId" type="button" value="上传" style="width: 58px;" onclick="uploadProductPhoto('update','image_product')"/>&nbsp;&nbsp;<span><font color="RED">提示：请上传800*800像素的图片！</font></span>
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
									<th style="text-align: right;"><i class="ColorRed">*</i>&nbsp;店铺内部分类：</th>
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
					</div>
					<!-- 修改套餐FCK -->
					<div title="详情" class="setWidth">
						<form id="proFunctionDescForm" action="" method="post" enctype="multipart/form-data">
							<input type="hidden" id="e_productId_functionDesc" name="productId"/>
							<table style="margin:10px 8px 8px 8px;width:98%;">
								<tr>
									<td class="toleft_td" colspan="3">
										<input type="hidden" name="productInfo.functionDesc" id="e_functionDescKE"/>
										<textarea id="e_functionDesc" rows="5" style="width:972px;height:255px;visibility:hidden;" cols="48" name="" class="{validate:{maxlength:[700]}}"></textarea>
									</td>
								</tr>
							</table>
							<div style="padding:0px;">
								<div class="editButton"  data-options="region:'south',border:false" >
									<a id="e_btnSaveFunctionDesc" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateFunctionDesc();" href="javascript:;">保存</a>
									<a id="e_btnCancelFunctionDesc" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
								</div>
							</div>
						</form>
					</div>
					<!-- 修改套餐属性 -->
					<div title="属性" class="addProductByPT" style="margin: 10px;width: 994px; height: auto;">
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
					</div>
					<!-- 修改套餐参数 -->
					<div title="参数" class="addProductByPTProdPara">
						<form id="productParametersForm" action="" method="post">
							<input type="hidden" id="e_productId_parameters" name="productId"/>
							<table id="e_totalProdPara" style="margin:10px;width:959px;"></table>
							<div style="padding:10px 0;">
								<div class="editButton"  data-options="region:'south',border:false" >
									<a id="e_btnSaveProductParameters" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductParameters();" href="javascript:;">保存</a>
									<a id="e_btnCancelProductParameters" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
								</div>
							</div>
						</form>
					</div>
					<!-- 修改套餐图片 -->
					<div title="图片" class="addProductByPT" style="height:auto;min-height:410px;">
						<form id="productSourceImgForm" action="" method="post" enctype="multipart/form-data">
							<input type="hidden" id="e_productId_sourceImg" name="productId"/>
							<input id="e_addProductImage" class="yl_button" type="button" value="添加滚动图片" onclick="javascript:addProductImageHtmlUpdate();" style="margin-top:10px;margin-left: 12px;"/>
							&nbsp;&nbsp;<span><font color="RED">提示：请上传800*800像素的图片！</font></span>
							<table id="e_productImageTable" style="margin: 11px;"  class="table_list" >
								<tr>
									<td width="28%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">图片上传预览</font></td>
									<td width="30%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">标题</font></td>
									<td width="22%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">排序</font></td>
									<td width="20%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">操作</font></td>
								</tr>
							</table>
							<div style="padding:10px 0;">
								<div class="editButton"  data-options="region:'south',border:false" >
									<a id="e_btnSaveProductSourceImg" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductSourceImg();" href="javascript:;">保存</a>
									<a id="e_btnCancelSourceImg" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
								</div>
							</div>
						</form>
					</div>
					<!-- 套餐规格 begin-->
					<div title="套餐规格" class="addProductByPT" style="height:auto;min-height:410px;">
						<form action="" method="post" id="e_specificationsForm">
							<input type="hidden" id="e_productId_specifications" name="productId"/>
							<input id="e_specifications" type="hidden" name="specifications" value=""/>
							<!-- 添加规格-->
							<div style="margin-bottom:7px;">
								<span>
									<input type="button" class="yl_button" value="添加规格" onclick="addNewSpecificationValueUpdate()" style="margin-top:10px;margin-left: 14px;"/>
								</span>
							</div>
							<!-- 当前分类下的规格 begin-->
							<div id="e_specificationSelect"></div>
							<!-- 当前分类下的规格 end -->
							<!-- 规格值 begin-->
							<div style="height:auto; overflow-x:auto; overflow-y:hidden;  ">
								<table id="e_specificationProductTable" style="margin:15px; width:97%; height:auto;">
									<!--选定规格值名称 -->
									<tr id="e_specificationProductTable-title" class="titlebg"></tr>
									<!--选定规格值-->
									<tr id="e_selectedSpecificationValues_0" class="e_selectedSpecificationValuesTD"></tr>
								</table>
							</div>
							<!-- 规格值 end -->
							<div style="padding:10px 0;">
								<div class="editButton"  data-options="region:'south',border:false" >
									<a id="e_btnSavespecifications" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductSpecifications();" href="javascript:;">保存</a>
									<a id="e_btnCancelspecifications" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
								</div>
							</div>
						</form>
					</div>
					<!-- 套餐规格 end -->
				</div>
				<!--//right-->
			</div>
		</div>
	</div>
