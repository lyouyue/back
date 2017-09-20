<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>

<!-- 后台存在的js -->

<!-- 添加商品样式 -->
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}shop/css/modal.css"/>
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}productInfo/css/choseTagsAlert.css"/>
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}productInfo/css/productInfo_add.css"/>
		
<style type="text/css">
	#merchandise_add{color: #595959; background-color:#FFF;font-size:12px !important;height:auto !important; height:100%;}
	.specificationSelect {height: 100px;padding: 5px;overflow-y: scroll;border: 1px solid #cccccc;}
	.specificationSelect li {float: left;min-width: 150px;_width: 200px;}
	.hidden {display: none;}
	#specificationSelect{overflow:hidden;}
	.addProductByPT td{text-align:left;width:371px;height:30px;line-height:30px; border: 1px solid #d0d0d0;padding: 3px 3px;}
	.addProductByPT th{text-align:right;background:#f2f2f2;width:11%;height:30px;line-height:30px;border: 1px solid #d0d0d0;padding: 3px 3px;}
	#totalProdAttr td{width:574px;height:30px;line-height:30px;}
	#totalProdAttr th{width:400px;height:30px;line-height:30px;}
	.addProductByPTProdPara td{padding: 3px;height:30px;line-height:30px;vertical-align: middle;text-align:left; border: 1px solid #d0d0d0;padding: 3px 3px;}
	.addProductByPTProdPara th{text-align:right;background:#f2f2f2;height:30px;line-height:30px;border: 1px solid #d0d0d0;padding: 3px 3px; }
	.ColorRed{color:RED;}
	.ke-icon-fullscreen{display:none;}
	.ke-edit{height:262px;}
	/* #selectShop .datagrid-wrap{height:auto;max-height:335px;}
	#selectShop .datagrid-view{max-height:271px;} */
</style>

<script type="text/javascript">
	function setWidth(){
		$(".setWidth").each(function(i) {
			$(this).removeAttr("style");
			$(this).attr("style","width: 994px; height: auto;");
		});
	}
	function saveProduct(){
		$("#inputForm").validate({
			meta: "validate",
			submitHandler: function(form) {
				if($("#productType-span-3").find("option:selected").length>0){
					if($("#productType-span-3").find("option:selected").attr("loadType")=="1"){
						var submitFlag=validateSubmit();
						if(submitFlag){//true 通过了提交验证
							//控制保存按钮，避免重复提交
							$("#add_btnSave").removeAttr("onclick");
							$("#functionDescKE").val(editor1.html());
							//form表单控制提交按钮，防止重复提交
							//使用时，在jsp里面需要加上以下内容：
							//1.from提交按钮submit加上class="submitImg"。
							//2.在submit后面加上<span class="submitImgLoad"></span>用来显示图标和提示信息
							var pta=$("#productTypeId-1").val()+","+$("#productTypeId-2").val()+","+$("#productTypeId-3").val()+","+$("#productTypeId-4").val();
							$("#productTypeAddress").val(pta);
							//处理运费
							if($('input[name="productInfo.isChargeFreight"]:checked').val()==2){
								$("#freightPriceHidd").val($("#freightPrice").val());
							}
							var ropts ={
								url : "${pageContext.request.contextPath}/back/productinfo/saveOrUpdateFrontProduct.action",
								type : "post",
								dataType:"json",
								success : function(data) {
									if(data.isSuccess){
										msgShow("系统提示", "<p class='tipInfo'>保存成功！</p>", "warning");
										$("#tt").datagrid("reload");
										closeWin();
									}else{
										msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");
										//控制保存按钮可用
										$("#add_btnSave").attr("onclick","javascript:saveProduct();");
									}
								}
							};
							$("#inputForm").ajaxSubmit(ropts);
						}
					}else{
						msgShow("系统提示", "<p class='tipInfo'>请选择商品分类！</p>", "warning");  
					}
				}else{
					msgShow("系统提示", "<p class='tipInfo'>请选择商品分类！</p>", "warning");  
				}
			}
		});
		$("#inputForm").submit();
	}
	function validateSubmit(){
		var reg = /^[1-9]{1}\d*$/;//正整数正则
		var isRepeats = true;
		var specifications = new Array();
		var speciArray = new Array();
		$("#specificationProductTable").find("tr:gt(0)").each(function(i) {
			var specificationValues = $(this).find("select").serialize();
			if(specificationValues!=""){
				var inputparam = $(this).find("input").serialize();
				if ($.inArray(specificationValues, speciArray)>=0) {
					msgShow("系统提示", "<p class='tipInfo'>商品规格重复！</p>", "warning");  
					isRepeats = false;
					return false;
				} else {
					speciArray.push(specificationValues);
					specifications.push(specificationValues +"@"+ inputparam);
				}
			}
		});
		if (isRepeats) {
			$("#parameters").val(specifications);
		}
		isRepeats = changePrice(isRepeats);//校验价格不为空 且销售价不大于市场价
		isRepeats = checkImg(isRepeats);
		if(isRepeats){
			var address=$("#deliveryAddressCities").val();
			var marketPrice=$("#marketPrice").val();
			var salesPrice=$("#salesPrice").val();
			var storeNumber=$("#storeNumber").val();
			var giveAwayCoinNumber=$("#giveAwayCoinNumber2").val();
			if(address==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，发货地必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#marketPrice").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，市场价格必填！</p>", "warning");  
				isRepeats = false;
			}else if($("#salesPrice").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，销售价格必填！</p>", "warning");  
				isRepeats = false;
			}else if(parseInt(marketPrice)<parseInt(salesPrice)){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，销售价不能大于市场价！</p>", "warning");  
				isRepeats = false;
			}else if($("#productName").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，商品名称必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#brandId").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，品牌必选！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#storeNumber").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，库存必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#otherUploadImgsId").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，商品Logo必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#productCode").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，商品编号必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#measuringUnitName").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，计量单位必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if(giveAwayCoinNumber==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，赠送购买者金币必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}else if($("#shopProCategoryId").val()==""){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，店铺内部分类必填！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}
			/* else if($("#barCode").val()==""){
				$.messager.alert("提醒","基本信息，条形码必填!");
				isRepeats = false;
				return isRepeats;
			}else if($("#weight").val()==""){
				$.messager.alert("提醒","基本信息，商品重量必填!");
				isRepeats = false;
				return isRepeats;
			}else if($("#packingSpecifications").val()==""){
				$.messager.alert("提醒","基本信息，包装规格必填!");
				isRepeats = false;
				return isRepeats;
			}else if($("#manufacturerModel").val()==""){
				$.messager.alert("提醒","基本信息，制造商型号必填!");
				isRepeats = false;
				return isRepeats;
			} */
			var numberTest = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/
			if(!numberTest.test(marketPrice)){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，市场价请输入合法数字！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}
			if(!numberTest.test(salesPrice)){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，销售价请输入合法数字！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}
			if(!numberTest.test(storeNumber)){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，库存请输入合法数字！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}
			if(!numberTest.test(giveAwayCoinNumber)){
				msgShow("系统提示", "<p class='tipInfo'>基本信息，赠送金币请输入合法数字！</p>", "warning");  
				isRepeats = false;
				return isRepeats;
			}
		}
		return isRepeats;
	}
	//校验价格不为空 且销售价不大于市场价
	//校验库存不为空 
	function changePrice(isRepeats){
		var salesPriceArray = new Array();
		var marketPriceArray = new Array();
		if(isRepeats){
			//判断市场价格是否为空
			$("input[name='marketPrice']").each(function(i) {
				if(!($(this).val()!=null&&$(this).val()!='')){
					msgShow("系统提示", "<p class='tipInfo'>商品规格，市场价格必填！</p>", "warning");  
					isRepeats = false;
					return false;
				}else{
					marketPriceArray.push($(this).val());
				}
			});
		}
		if(isRepeats){
			//判断销售价格是否为空
			$("input[name='salesPrice']").each(function(i) {
				if(!($(this).val()!=null&&$(this).val()!='')){
					msgShow("系统提示", "<p class='tipInfo'>商品规格，销售价格必填！</p>", "warning");  
					isRepeats = false;
					return false;
				}else{
					salesPriceArray.push($(this).val());
				}
			});
		}
		if(isRepeats){
			//判断库存是否为空
			$("input[name='storeNumber']").each(function(i) {
				if(!($(this).val()!=null&&$(this).val()!=''&&$(this).val()>0)){
					msgShow("系统提示", "<p class='tipInfo'>商品规格，库存必填！</p>", "warning");  
					isRepeats = false;
					return false;
				}
			});
		}
		if(isRepeats){
			//判断销售价不大于市场价
			if(salesPriceArray.length==marketPriceArray.length){
				for(var j=0;j<salesPriceArray.length;j++){
					if(Number(salesPriceArray[j])>Number(marketPriceArray[j])){//销售价大于市场价
						msgShow("系统提示", "<p class='tipInfo'>商品规格，规格相同的销售价格不能大于其市场价格！</p>", "warning");  
						isRepeats = false;
						break;
					}
				}
			}
		}
		return isRepeats;
	}
	//验证图片
	function checkImg(isRepeats){
		if(isRepeats){
			//判断标题是否为空
			$(".listProductImage_addTitle").each(function(i) {
				if(!($(this).val()!=null&&$(this).val()!='')){
					msgShow("系统提示", "<p class='tipInfo'>图片，标题必填！</p>", "warning");  
					isRepeats = false;
					return false;
				}
			});
		}
		if(isRepeats){
			//判断排序是否为空
			$(".listProductImage_addOrders").each(function(i) {
				if(!($(this).val()!=null&&$(this).val()!='')){
					msgShow("系统提示", "<p class='tipInfo'>图片，排序必填！</p>", "warning");  
					isRepeats = false;
					return false;
				}
			});
		}
		if(isRepeats){
			//判断图片是否为空
			$(".addSource").each(function(i) {
				if(!($(this).val()!=null&&$(this).val()!='')){
					msgShow("系统提示", "<p class='tipInfo'>图片，图片必须上传！</p>", "warning");  
					isRepeats = false;
					return false;
				}
			});
		}
		return isRepeats;
	}
	//更改邮费方式
	function isChargeFreight(value) {
		if (value == "1") {
			$("#freightPrice").closest("tr").css("display", "none");
			$("#freightPriceHidd").val("0");
		} else {
			$("#freightPrice").closest("tr").css("display", "");
			$("#freightPriceHidd").val($("#freightPrice").val());
		}
	}
	// 增加商品图片
	function addProductImageHtml(){
		var $productImageTable = $("#productImageTable");
		var Index = $(".imgs").length;
		var trHtml = "<tr class='imgs' id='img_"+ Index +"'> '+'<input class='addSource' type='hidden' name='listProductImage["+Index+"].source' id='source"+Index+"' value=''/>";
		trHtml+= "<input type='hidden' name='listProductImage["+Index+"].large' id='large"+Index+"' value='"+Index+"'/>";
		trHtml+= "<input type='hidden' name='listProductImage["+Index+"].medium' id='medium"+Index+"' value='"+Index+"'/>";
		trHtml+= "<input type='hidden' name='listProductImage["+Index+"].thumbnail' id='thumbnail"+Index+"' value='"+Index+"'/>";
		//图片上传开始
		trHtml+= "<td style='text-align: center;'>";
		trHtml+= "<form id='photoForm_"+ Index +"' method='post' enctype='multipart/form-data'>";
		trHtml+= "<table align='center' class='addOrEditTable' width='740px' style='margin-top: 0;'>";
		trHtml+= "<tr>";
		trHtml+= "<td style='text-align: center;'>&nbsp;&nbsp;";
		trHtml+= "<span id='photo_"+ Index +"'><img id='photoImg_"+ Index +"' style='width:40px;height:40px;margin-left:-8px;margin-bottom:-8px;' src='${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png'/></span>";
		trHtml+= "</td>";
		trHtml+= "<td  style='text-align: center;padding:7px 7px;' >";
		trHtml+= "<span id='mymessag"+ Index +"'></span>";
		trHtml+= "<input id='fileId_"+ Index +"' type='file' name='imagePath' style='width:145px;float:left;margin-top:5px;'/>";
		trHtml+= "<input id='buttonId_"+ Index +"' style='float:left;margin-top:3px;' type='button' value='上传预览' onclick='uploadProPhoto("+ Index +")'/>";
		trHtml+= "</td>";
		trHtml+= "</tr>"; 
		trHtml+= "</table>";
		trHtml+= "</form>";
		trHtml+= "</td>";
		//图片上传结束
		
		trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].title' class='listProductImage_addTitle product_input' maxlength='150' style='width:210px;'/> </td> ";
		trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].orders' class='listProductImage_addOrders product_input' maxlength='9' style='width: 50px !important;' value='"+getMaxSortNum('listProductImage_addOrders')+"'/> </td>";
		trHtml+= "<td style='text-align: center;'> <a  href='javascript:;' class='opt_links deletopt' onclick='javascript:deleteProductImage("+Index+");'>删除</a> </td> </tr>";
		$productImageTable.append(trHtml);
	}
	//上传图片
	function uploadProPhoto(imageIndex) {
		//添加上传提示信息，控制按钮不可用
			addFormPhotoMessage3(imageIndex);
			$(document).ready( function() {
				var options = {
					//url : "${pageContext.request.contextPath}/back/upload/asyncUploadImage.action?imageInfoPath="+imageInfoPath,
					url : "${pageContext.request.contextPath}/back/productinfo/uploadImageFront.action?is_ajax=2",
					type : "post",
					dataType : "json",
					async:false,
					success : function(data) {
						//清空上传提示信息，恢复按钮可用
						clearFormPhotoMessage3(imageIndex);
						if(data.photoUrl=="false"){
							msgShow("系统提示", "<p class='tipInfo'>文件扩展名不是PNG或JPG！</p>", "warning");  
						}else if(data.photoUrl=="false2"){
							msgShow("系统提示", "<p class='tipInfo'>请选择图片后再上传！</p>", "warning");  
						}else{
							var productImg = data.photoUrl;
							//$("#photo_"+imageIndex).html("");
							//$("#photo_"+imageIndex).html("<img style='width:40px;height:40px;' src='"+data.uploadFileVisitRoot+productImg.source+"'/>");
							$("#photoImg_"+imageIndex).attr('src',data.uploadFileVisitRoot+productImg.source);
							$("#photoImg_"+imageIndex).attr('alt',data.uploadFileVisitRoot+productImg.source);
							$("#source"+imageIndex).val(productImg.source);
							$("#large"+imageIndex).val(productImg.large);
							$("#medium"+imageIndex).val(productImg.medium);
							$("#thumbnail"+imageIndex).val(productImg.thumbnail);
						}
					}
				};
				$("#photoForm_"+imageIndex).ajaxSubmit(options);
			});
	}
	//添加上传提示信息，控制按钮不可用
	function addFormPhotoMessage3(imageIndex){
		$("#mymessag"+imageIndex).html("<font style='color:green'>文件提交中......</font>");//修改提示信息
		$("#buttonId_"+imageIndex).attr("disabled","true");//提交按钮不可用
	}
	
	//清空上传提示信息，恢复按钮可用
	function clearFormPhotoMessage3(imageIndex){
		$("#mymessag"+imageIndex).html("");//清空提示信息
		$("#buttonId_"+imageIndex).removeAttr("disabled");//提交按钮恢复可用
	}
	// 删除商品图片
	function deleteProductImage(value){
		$("#img_"+value).remove();
	}
	//编辑图片
	function editImage(value){
		$("#imageNum").val(value);
		$("#controlButton").removeAttr("disabled");
		$("#tx-file").val("");
	}
	//根据分类ID查询参数、属性、规格
	function getOtherInfoById(v){
		$("#productTypeId").val(v);
		if(v!="0"){
			$("#productType-span-4").attr("flag","true");
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/productinfo/selectOtherInfoByProductTypeId.action",
				data: {selectProductTypeId:v},
				success: function(data){
					if(data!=null){
						//品牌start
						var s="";
						if(data.brandList!=null){
							s = "<select id='brandId' name='productInfo.brandId' class='{validate:{required:true}}'>";
							s+= "<option  value=''>";
							s+="请选择";
							s+="</option>";
							for(var i=0;i<data.brandList.length;i++){
								s+= "<option  value='"+data.brandList[i].brandId+"'>";
								s+=data.brandList[i].brandName;
								s+="</option>";
							}
							s+="</select>";
							//计量单位名称的选择
							var m="";
							m = "<select id='measuringUnitName' name='productInfo.measuringUnitName' class='{validate:{required:true}}' onchange='assign(this.value);'>";
							m+= "<option  value=''>";
							m+="请选择";
							m+="</option>";
							for(var i=0;i<data.measuringUnitList.length;i++){
								m+= "<option  value='"+data.measuringUnitList[i].name+"'>";
								m+=data.measuringUnitList[i].name;
								m+="</option>";
							}
							m+="</select>";
						}
						$("#brandTd").html(s);
						$("#measuringUnit").html(m);
						//分类的属性begin
						var jaListProductAttr = data.listProductAttr;
						var attributeValueList = data.attributeValueList;
						$("#totalProdAttr").html("");
						if (jaListProductAttr !=""&&jaListProductAttr!=null) {
							var listProductAttr = eval(jaListProductAttr); //分类属性的集合
							if (listProductAttr.length > 0) {
								var htmlAttrStr = "<tr><strong>商品属性</strong></tr>";
								for (var i = 0; i < listProductAttr.length; i++) {
									if((i+1)%2==1){
										htmlAttrStr += "<tr>";
									}
									if(attributeValueList!=null&&attributeValueList.length>0){
										var tmp="";//作为临时组品的数据
										for (var j = 0; j < attributeValueList.length; j++) {
											if(listProductAttr[i].productAttrId==attributeValueList[j].productAttrId){
												tmp += "<option value='" + attributeValueList[j].attrValueId + "'>" + attributeValueList[j].attrValueName + "</option>";
											}
										}
										//如果tmp不为空 则添加对应的属性及属性值数据
										if(tmp!=""){
											htmlAttrStr += "<th style='text-align: right;'>" + listProductAttr[i].name + ":</th><input type='hidden' name='listProdAttr[" + i + "].name'  value='" + listProductAttr[i].productAttrId + "'/>";
											if((i+1)%2==1&&i==(listProductAttr.length-1)){
												htmlAttrStr +=  "<td colspan=\"3\">";
											}else{
												htmlAttrStr +=  "<td>";
											}
											htmlAttrStr += "<select id='" + listProductAttr[i].name + "' name='listProdAttr[" + i + "].value'>"
											htmlAttrStr += tmp;
											htmlAttrStr += " </select></td>";
										}
									}
									if((i+1)%2==0){
										htmlAttrStr += "</tr>";
									}else{
										if(i==(listProductAttr.length-1)){
											htmlAttrStr += "</tr>";
										}
									}
								}
								$("#totalProdAttr").html(htmlAttrStr);
							}
						}else{
							$("#totalProdAttr").html("");
						}
						//分类的属性end
						//分类的参数begin
						var productPara = data.productPara;
						if (productPara != "" && productPara!=null) {
							$("#totalProdPara").empty();
							//var productPara = data.productPara;//分类的参数集合
							var htmlParaStr = "";
							var infoObj = eval(productPara.info);
							var h = 0;
							var trHtml = "";
							for (var i = 0; i < infoObj.length; i++) {//参数组循环
									trHtml += "<table class='paramsTable' id='parameterTable" + i + "'  width='100%'><tr>";
									trHtml += "<td style=\"border: 0px solid #d0d0d0;\"><strong  style='text-align: center;width: 100%;display:inline-block;'>" + infoObj[i].name + "</strong><input type='hidden' name='listParamGroup[" + i + "].name' value='" + infoObj[i].name + "'/><input type='hidden'  name='listParamGroup[" + i + "].paramGroupId' value='" + infoObj[i].paramGroupId + "'/>";
									trHtml += "<input type='hidden'  name='listParamGroup[" + i + "].order' value='" + infoObj[i].order + "' style='width: 50px;'/></td>";
									trHtml += "</tr>";
									trHtml += "<tr><td style='border: 0px solid #d0d0d0;'><table id='parameterInfoTable" + i + "' width='100%'>";
									var a = eval(infoObj[i].paramGroupInfo);
									for (var u = 0; u < a.length; u++) {//参数循环
										if((u+1)%2==1){//当前参数为第奇数个时，追加<tr>标签
											trHtml += "<tr>";
										}
										trHtml += "<th style='text-align: right;width: 200px;'> " + a[u].name + "：</th><input type='hidden'  name='listParamGroupInfo[" + h + "].name' value='" + a[u].name + "'/> <input type='hidden'  name='listParamGroupInfo[" + h + "].pgiId' value='" + a[u].pgiId + "'/> ";
										if((u+1)%2==1&&u==(a.length-1)){
											trHtml += "<td colspan=\"3\">";
										}else{
											trHtml += "<td>";
										}
										trHtml += "<input type='hidden' name='listParamGroupInfo[" + h + "].order' value='" + a[u].order + "'/><input type='hidden' name='listParamGroupInfo[" + h + "].pgInfoId' value='" + a[u].pgInfoId + "'/>";
										trHtml += "<input class='us_input' type='text' name='listParamGroupInfo[" + h + "].value' value='" + a[u].value + "'/> </td>";
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
							$("#totalProdPara").append(trHtml);
						}else{
							$("#totalProdPara").html("");
						}
						//分类的参数end
						//分类的规格begin
						var specificationList = data.specificationList;
						if(specificationList!=""&&specificationList!=null){
							var specificationHtmlStr="";
							for(var i=0;i<specificationList.length;i++){
								var specification=specificationList[i];
								var specification_param=specification.specificationId+"_"+specification.name+"_"+specification.notes;
								specificationHtmlStr+="<div style='float:left;margin:5px 10px;'>";
								specificationHtmlStr+="<span style='display:block;'>";
								specificationHtmlStr+="<input onclick='showSelectedSpecification("+specification.specificationId+")' id='"+specification.specificationId+"' class='check' name='specificationIds' type='checkbox' value='"+specification_param+"'/>";
								specificationHtmlStr+="&nbsp;<label for='"+specification.specificationId+"'>"+specification.name;
								specificationHtmlStr+="[&nbsp;"+specification.notes+"&nbsp;]</label></span></div>";
							}
							$("#specificationSelect").html(specificationHtmlStr);
						}else{
							$("#specificationSelect").html("");
						}
						//分类的规格end
					}
				}
			});
		}else{
			//清除品牌、规格、参数等信息
			$("#brandTd").html("");
			$("#measuringUnit").html("");
			$("#totalProdAttr").html("");
			$("#totalProdPara").html("");
			$("#specificationSelect").html("");
			$("#productType-span-4").attr("flag","false");
		}
	}
	//显示选中的规格
	var count_specificationValues_id_index=0;
	function showSelectedSpecification(specificationId){
		var isChecked=$("#"+specificationId).attr("checked");
		if(isChecked!="checked"){
			$(".specificationValu"+specificationId).hide();
		}else{
			$(".specificationValu"+specificationId).show();
		}
		var selectedSpecificationValuesHtmlStr="";
		var specificationProductHtmlStr="";
		$("#specificationProductTable-title").css("display","");
		var isOwnChecked=false;
		$("#specificationSelect input:checked").each(function(i){
			isOwnChecked=true;
			var specificationValueStringArray=this.value.split("_");
			var specificationId=specificationValueStringArray[0];
			var name=specificationValueStringArray[1];
			var notes=specificationValueStringArray[2];
			specificationProductHtmlStr+="<th style='text-align:center;padding:5px 10px;width:15%' id='specification_"+specificationId+"'>";
			specificationProductHtmlStr+="<span  style='margin:6px; display:inline;  white-space:nowrap;'>"+name+"</span>";
			specificationProductHtmlStr+="<span  style=''>[&nbsp;"+notes+"&nbsp;]</span></th>";
			selectedSpecificationValuesHtmlStr+=showSelectedSpecificationValue(specificationId);
		});
		specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;市场价格</th>";
		specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;销售价格</th>";
		specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;商品库存</th>";
		specificationProductHtmlStr+="<th style='text-align:center;'>操作</th>";
		$("#specificationProductTable-title").html(specificationProductHtmlStr);
	}
	//显示规格对应的规格值
	function showSelectedSpecificationValue(specificationId){
		var selectedSpecificationValuesHtmlStr="";
		$.ajax({
			type: "POST",
			dataType: "JSON",
			url: "${pageContext.request.contextPath}/back/productinfo/getSpecificationValueBySpecificationId.action",
			async:false,
			data: {specificationId: specificationId},
			success: function(data){
				specificationValueList=data;
				selectedSpecificationValuesHtmlStr+="<td class='specificationValu"+specificationId+"'style='width:auto; height:24px; padding:10px 20px; text-align:center;'>";
				selectedSpecificationValuesHtmlStr+="<select class='disabled_"+specificationId+"' name='specification_"+specificationId+"'>";
				for(var i=0;i<specificationValueList.length;i++){
					var specificationValue=specificationValueList[i];
					selectedSpecificationValuesHtmlStr+="<option value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
				}
				selectedSpecificationValuesHtmlStr+="</select></td>";
			}
		});
		return 	selectedSpecificationValuesHtmlStr;
	}

	//新增的规格tr计数器，便于动态生成存放规格的tr
	function addNewSpecificationValue(){
		var marketPrice=$("#marketPrice").val();
		var salesPrice=$("#salesPrice").val();
		var storeNumber=$("#storeNumber").val();
		var check_objs=$("#specificationSelect input:checked");
		if(check_objs.length>0){
			count_specificationValues_id_index++;
			var newTrHtmlStr="<tr id='selectedSpecificationValues_"+count_specificationValues_id_index+"' class='selectedSpecificationValuesTD'>";
			var selectedSpecificationValuesHtmlStr="";
			var isOwnChecked=false;
			$("#specificationSelect input:checked").each(function(i){
				isOwnChecked=true;
				var specificationValueStringArray=this.value.split("_");
				var specificationId=specificationValueStringArray[0];
				var name=specificationValueStringArray[1];
				var notes=specificationValueStringArray[2];
				selectedSpecificationValuesHtmlStr+=showSelectedSpecificationValue(specificationId);
			});
			selectedSpecificationValuesHtmlStr+="<td style='width:200px;text-align: center;'><input id='marketPric"+count_specificationValues_id_index+"' type='text'  name='marketPrice' value='"+marketPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
			selectedSpecificationValuesHtmlStr+="<td style='width:200px;text-align: center;'><input id='salesPric"+count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
			selectedSpecificationValuesHtmlStr+="<td style='width:200px;text-align: center;'><input id='storeNumber_"+count_specificationValues_id_index+"' type='text' name='storeNumber' value='"+storeNumber+"' class='{validate:{required:true,number:true,maxlength:[8]}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
			if(isOwnChecked){
				selectedSpecificationValuesHtmlStr+="<td class='delettext' style='padding-left:10px; width:120px; white-space:nowrap;text-align: center;'><a class='opt_links' href='javascript:deleteSpecification("+count_specificationValues_id_index+");' >删除</a></td>";
			}
			newTrHtmlStr+=selectedSpecificationValuesHtmlStr+"</tr>";
			$("#specificationProductTable").append(newTrHtmlStr);
			lockCheckBox();//锁住复选框
		}else{
			msgShow("系统提示", "<p class='tipInfo'>至少选择一个规格！</p>", "warning");  
		}
	}

	// 删除规格商品
	function deleteSpecification(specificationValues_id_index){
		//清除用下拉框展示规格对应的规格值
		$("#selectedSpecificationValues_"+specificationValues_id_index).remove();
		if($("#specificationProductTable tr").length==1){
			unLockCheckBox();
		}
	}

	function lockCheckBox(){
		$("#specificationSelect input").each(function(i){
			$(this).attr("disabled","disabled");
		});
	}

	function unLockCheckBox(){
		$("#specificationSelect input").each(function(i){
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
	//初始化一级分类
	function initProductTypeFirst(){
		var html='';
		html +="<select class='select_zx'  id='productTypeId-1' name='productInfo.categoryLevel1' onchange='getNextLevelDate(1,this.value,this.value,null,null);'>";
		html +="<option value='' selected='selected'>请选择</option>";
		<s:iterator value="#application.categoryList" var="type1">
		var productTypeId = '<s:property value="#type1.productTypeId"/>';
		var sortName = '<s:property value="#type1.sortName"/>';
		html +="<option value='"+productTypeId+"'>"+sortName+"</option>";
		</s:iterator>
		html +="</select>";
		$("#productType-span-1").html(html);
	}
	//商品分类数据追加
	function getNextLevelDate(level,value,l1,l2,l3){//leve为当前分类级别 value为当前分类ID l1,l2,l3分别为一级二级三级分类ID
		//清除品牌、规格、参数等信息
		$("#brandTd").html("");
		$("#measuringUnit").html("");
		$("#totalProdAttr").html("");
		$("#totalProdPara").html("");
		$("#specificationSelect").html("");
		//删除添加规格表表头部分
		$("#specificationProductTable-title").empty();
		//删除添加规格表的每一行
		$(".selectedSpecificationValuesTD").remove();
		$("#productType-span-4").attr("flag","false");
		var html="";
		var nextLevel=level+1;
		if(level=="1"){//点击一级分类时
			//清除去其他
			$("#productType-span-2").html(html);
			$("#productType-span-3").html(html);
			$("#productType-span-4").html(html);
			<s:iterator value="#application.categoryList" var="type1">
				if(value==<s:property value="#type1.productTypeId"/>){
					html+=" <select id=\"productTypeId-2\" name=\"productInfo.categoryLevel2\" onchange=\"getNextLevelDate("+nextLevel+",this.value,"+l1+",this.value,"+l3+");\"><option value=\"0\">请选择</option>";
					<s:iterator value="#type1.childProductType" var="type2">
						if(value==<s:property value="#type2.parentId"/>){
							var id='<s:property value="#type2.productTypeId"/>';
							var name='<s:property value="#type2.sortName"/>';
							html+="<option value=\""+id+"\" >"+name+"</option>";
						}
					</s:iterator>
					html+="</select>";
				}
			</s:iterator>
		}else if(level=="2"){//点击二级分类时
			//清除去其他
			$("#productType-span-3").html(html);
			$("#productType-span-4").html(html);
			$("#productType-span-4").attr("flag","false");
			<s:iterator value="#application.categoryList" var="type1">
				if(l1 == <s:property value="#type1.productTypeId"/>){
				<s:iterator value="#type1.childProductType" var="type2">
					if(l1==<s:property value="#type2.parentId"/> && <s:property value="#type2.productTypeId"/> == l2 && <s:property value="#type2.childProductType.size"/> >0){
						   html+=" <select id=\"productTypeId-3\" name=\"productInfo.categoryLevel3\" onchange=\"getNextLevelDateOrOtherInfo("+nextLevel+",this.value,"+l1+","+value+",this.value);\"><option value=\"0\">请选择</option>";
						 <s:iterator value="#type2.childProductType" var="type3">
							var id='<s:property value="#type3.productTypeId"/>';
							var name='<s:property value="#type3.sortName"/>';
							var loadType='<s:property value="#type3.loadType"/>';
							html+="<option loadType=\""+loadType+"\" value=\""+id+"\" >"+name+"</option>";
						 </s:iterator>
						  html+="</select>";
					}
				</s:iterator>
				}
			</s:iterator>
		}else if(level=="3"){//点击三级分类时
			//清除去其他
		}
		html+="</select>";
		$("#productType-span-"+nextLevel).html(html);
	}

	function getNextLevelDateOrOtherInfo(level,value,l1,l2,l3){//leve为当前分类级别 value为当前分类ID l1,l2,l3分别为一级二级三级分类ID
		//删除添加规格表表头部分
		$("#specificationProductTable-title").empty();
		//删除添加规格表的每一行
		$(".selectedSpecificationValuesTD").remove();
		if($("#productType-span-3").find("option:selected").attr("loadType")=="1"){
			getOtherInfoById($("#productTypeId-3").val());
		}else{
			getNextLevelDate(level,value,l1,l2,l3);
		}
	}
	//商品重量后追加计量单位
	function assign(value){
		$("#measuringUnitName1").html("/"+value);
	}
	//更改地址level等级
	function chengeArea(id,level,selectId,tagId){
		if(id==null||id==""){
			$(tagId).html("<option value=''>--地级市--</option>");
			$(tagId).val(null);
		}else{
			$.ajax({
				url:"${pageContext.request.contextPath}/back/productinfo/findAreaList.action",
				type:"post",
				dataType:"json",
				data:{areaId:id},
				success:function(data){
					if(data!=""){
						var areaList=data;
						var htmlOption="<option value=''>--请选择--</option>";
						for(var i=0;i<areaList.length;i++){
							htmlOption+="<option  value='" + areaList[i].aid+"'id='" + areaList[i].aid+"'>" + areaList[i].name+ "</option>";
						}
						if(level==1){
							$(tagId).html(htmlOption);
							$(tagId).val(selectId);
						}
					}
				}
			});
		}
	}
	function queryShopInfo(){
		$("#shopInfott").datagrid("clearSelections");//删除后取消所有选项
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopName:$("#qqshopName").val(),custName:$("#qqcustName").val(),shopCategoryId:$("#parentIdList").val(),isClose:'-1',isPass:'-1'};
		$("#shopInfott").datagrid("load",queryParams);
		pageSplitThis(pageSize,queryParams,"shopInfott");
	}
	function resetShopInfo(){
		$("#qqcustName").val("");
		$("#qqshopName").val("");
		$("#parentIdList").val("");
	}
	function confirmShop(){
		var rows = $("#shopInfott").datagrid("getSelections");//找到所有选中的行
		if(rows.length<=0){
			msgShow("系统提示", "<p class='tipInfo'>请选择店铺！</p>", "warning");
		}else{
			if(rows){
				$("#aShopInfoId").val(rows[0].shopInfoId);
				$("#aShopInfoName").html(rows[0].shopName);
				$("#addProduct").css("display","");
				$("#selectShop").css("display","none");
				/**表单信息重置 begin**/
				//重置表单 
				document.getElementById("inputForm").reset();
				//删除分类的二、三级下拉框
				$("#productType-span-2").empty();
				$("#productType-span-3").empty();
				//删除品牌下拉框
				$("#brandTd").empty();
				//删除计量单位下拉框
				$("#measuringUnit").empty();
				//删除商品属性部分
				$("#totalProdAttr").empty();
				//删除商品参数部分
				$("#totalProdPara").empty();
				//删除添加图片==>行
				$(".imgs").remove();
				//删除选择规格部分
				$("#specificationSelect").empty();
				//删除添加规格表表头部分
				$("#specificationProductTable-title").empty();
				//删除添加规格表的每一行
				$(".selectedSpecificationValuesTD").remove();
				//默认选中第一个标签（基础信息）
				$("#addTab").tabs("select","基本信息");
				/**表单信息重置 end**/
				/** 设置easyuiTabs的样式 begin**/
				$(".tabs-wrap").removeAttr("style");
				$(".tabs-wrap").attr("style","margin-left: 0px; margin-right: 0px; left: 0px; width:100%;");
				$(".setWidth").each(function(i) {
					$(this).removeAttr("style");
					$(this).attr("style","width: 994px; height: auto;");
				});
				/**设置easyuiTabs的样式 end**/
				/**KE编辑器获得光标 begin**/
				var addAndUpdateProductSum = $("#addAndUpdateProductSum").val();
				if(addAndUpdateProductSum!=null&&Number(addAndUpdateProductSum)==1){
					$(".ke-icon-fullscreen").click();
					$(".ke-icon-fullscreen").click();
					addAndUpdateProductSum = Number(addAndUpdateProductSum)+1;
				}
				$("#addAndUpdateProductSum").val(addAndUpdateProductSum);
				editor1.html("");
				/**KE编辑器获得光标 end**/
				//初始化一级分类
				initProductTypeFirst();
				$.ajax({
					type: "POST",dataType: "JSON",
					url: "${pageContext.request.contextPath}/back/productinfo/queryAddProductInfo.action",
					data:{shopInfoId:rows[0].shopInfoId},
					async:false,
					success: function(data){
						if(data!=null){
							//省
							var firstAreaList = data.firstAreaList;
							//省star
							if(firstAreaList!=null){
								var firstAreaHtml="";
								firstAreaHtml+="<select id='deliveryAddressProvince' name='productInfo.deliveryAddressProvince' onchange='chengeArea(this.value,\"1\",\"\",\"#deliveryAddressCities\")' class='{validate:{required:true}} select_zx'>";
								firstAreaHtml+="<option value=''>省</option>";
								for(var i=0; i<firstAreaList.length; i++){
									firstAreaHtml+="<option  value='"+firstAreaList[i].aid+"' id='"+firstAreaList[i].aid+"'>"+firstAreaList[i].name+"</option>";
								}
								firstAreaHtml+="</select>";
								firstAreaHtml+="<select id='deliveryAddressCities' name='productInfo.deliveryAddressCities' class='{validate:{required:true}} select_zx' style='margin-left:3px;'>";
								firstAreaHtml+="<option value=''>地级市</option>";
								firstAreaHtml+="</select>";
								$("#deliveryAddressProvinceTD").html(firstAreaHtml);
							}
							//初始化店铺内部分类  shopCategery
							var shopProCategoryList = data.shopProCategoryList;
							if(shopProCategoryList!=null){
								var shopCategeryHtml="";
								shopCategeryHtml+="<select id='shopProCategoryId' name='shopProCategoryId' class='{validate:{required:true}} select_zx'>";
								shopCategeryHtml+="<option value=''>请选择</option>";
								for(var i=0; i<shopProCategoryList.length; i++){
									shopCategeryHtml+="<option  value='"+shopProCategoryList[i].shopProCategoryId+"' id='"+shopProCategoryList[i].shopProCategoryId+"'>"+shopProCategoryList[i].shopProCategoryName+"</option>";
								}
								shopCategeryHtml+="</select>";
								$("#shopCategery").html(shopCategeryHtml);
							}
						}
					}
				});
			}
		}
	}
	</script>
<!-- 后台存在的js -->

<div id="merchandise_add">
	<div id="addProduct" class="product_content">
		<form  action="" id="inputForm" method="post" enctype="multipart/form-data"  >
			<input id="aShopInfoId" type="hidden" name="productInfo.shopInfoId" value=""/>
			<input id="parameters" type="hidden" name="parameters" value=""/>
			<input id="productTypeAddress" type="hidden" name="productInfo.productTypeAddress"/>
			<input id="productTypeId" type="hidden" name="productInfo.productTypeId"/>
			<input id="functionDescKE" type="hidden" name="productInfo.functionDesc"/>
			<div id="product_rightBox" >
				<div class="easyui-tabs" id="addTab">
					<div title="基本信息"  class="addProductByPT setWidth">
						<table style="margin:1px 11px 11px 11px;">
							<tr>
								<td style="border:0px solid #d0d0d0;" colspan="4"><font color="red">已选店铺：<span id="aShopInfoName"></span></font></td>
							</tr>
							<tr>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;商品 Logo：</th>
								<td colspan="5">
									<input id="otherUploadImgsId" type="file" name="otherUploadImgs" class="productImageFile {validate:{required:true}}"/>
									<s:property value="name"/>
									<%-- &nbsp;&nbsp;<span style="margin-left:13%;"><font color="RED">提示：请上传800*800像素的图片！</font></span> --%>
									<div class="imgMessage" style="margin-left:0px;">提示：请上传规格宽800px，高800px的图片</div>
								</td>
							</tr>
							<tr>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;商品分类：</th>
								<td colspan="3">
									<select class="select_zx"  id="productTypeId-1" name="productInfo.categoryLevel1" onchange="getNextLevelDate(1,this.value,this.value,null,null);">
										<option value="" selected="selected">请选择</option>
										<s:iterator value="#application.categoryList" var="type1">
											<option value="<s:property value="#type1.productTypeId"/>"  >
												<s:property value="#type1.sortName"/>
											</option>
									</s:iterator>
								</select>
								<span id="productType-span-2">
								</span>
								<span id="productType-span-3">
								</span>
								<span id="productType-span-4" flag="false">
								</span>
								</td>
								<th style="text-align: right;"><i class="ColorRed">*</i>&nbsp;店铺内部分类：</th>
								<td id="shopCategery"></td>
							</tr>
							<tr>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;商品名称：</th>
								<td><input  type="text" id="productName" name="productInfo.productName" value="<s:property value="productInfo.productName" />" class="{validate:{required:true,maxlength:[50]}} us_input" /></td>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;商品品牌：</th><td id="brandTd"></td>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;计量单位：</th><td id="measuringUnit"></td>
							</tr>
							<tr>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;商品编号：</th><td><input   type="text" id="productCode" name="productInfo.productCode" class="{validate:{required:true,maxlength:[30]}} us_input"  /></td>
								<th style="text-align: right; width:115px;"><i class="ColorRed">*</i>&nbsp;发货地：</th>
								<td id="deliveryAddressProvinceTD" colspan="3"></td>
							</tr>
							<tr>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;市场价格：</th><td><input id="marketPrice" type="text"  name="productInfo.marketPrice" class="{validate:{required:true,number:true}} us_input"/></td>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;销售价格：</th><td><input id="salesPrice" type="text" name="productInfo.salesPrice" class="{validate:{required:true,number:true}} us_input"/></td>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;商品库存：</th><td><input   type="text" id="storeNumber" name="productInfo.storeNumber" class="{validate:{required:true,number:true,maxlength:[8]}} us_input"/></td>
							</tr>
							<tr>
								<th class="toright_td"><i class="ColorRed">*</i>&nbsp;赠送金币：</th><td><input type="text" id="giveAwayCoinNumber2" name="productInfo.giveAwayCoinNumber" class="{validate:{required:true,number:true}} us_input" value="<s:property value="productInfo.giveAwayCoinNumber" />"/></td>
								<th class="toright_td">&nbsp;商品重量：</th><td><input id="weight" type="text" name="productInfo.weight" />&nbsp;&nbsp;&nbsp;kg<span id="measuringUnitName1"></span></td>
								<th class="toright_td">&nbsp;包装规格：</th><td><input type="text" id="packingSpecifications" name="productInfo.packingSpecifications" /></td>
							</tr>
							<tr>
								
							</tr>
							<tr>
								<th class="toright_td">&nbsp;条形码：</th><td><input type="text" id="barCode" name="productInfo.barCode" class="{validate:{number:true,maxlength:[13]}} us_input"/></td>
								<th class="toright_td">&nbsp;制造商型号：</th>
								<td>
									<input type="text" id="manufacturerModel" name="productInfo.manufacturerModel" />
									<input type="hidden" id="isChargeFreight" name="productInfo.isChargeFreight" value="1" />
								</td>
								<th class="toright_td">商品备提示：</th><td><input   type="text" name="productInfo.note" class="{validate:{maxlength:[1000]}} us_input"/></td>
							</tr>
							<tr>
								<th class="toright_td">SEO 标题：</th><td><input   type="text" name="productInfo.seoTitle" class="{validate:{maxlength:[100]}} us_input"/></td>
								<th class="toright_td">SEO 关键字：</th><td><input   type="text" name="productInfo.seoKeyWord" class="{validate:{maxlength:[100]}} us_input"/></td>
								<th class="toright_td">SEO 描述：</th><td><input   type="text" name="productInfo.seoDescription" class="{validate:{maxlength:[200]}} us_input"/></td>
							</tr>
						</table>
						<input type="hidden" name="productInfo.isPutSale" value="1"/>
						<input type="hidden" id="freightPriceHidd" name="productInfo.freightPrice" value="0"/>
					</div>
					<div title="详情" class="setWidth">
						<table style="margin:10px 8px 8px 8px;">
							<tr>
								<td colspan="3">
								<textarea id="functionDesc" rows="5" style="width:100%;height:285px;visibility:hidden;" cols="48" name="" class="{validate:{maxlength:[700]}}"></textarea>
								</td>
							</tr>
						</table>
					</div>
					<!-- 商品属性 -->
					<div title="属性" class="addProductByPT">
						<table id="totalProdAttr" style="margin:13px 10px 10px 10px;"></table>
					</div>
					<!-- 商品参数 -->
					<div title="参数" class="addProductByPTProdPara setWidth">
						<table id="totalProdPara" style="margin:6px;width:97%;"></table>
					</div>
					<!-- 商品图片 -->
					<div title="图片" class="addProductByPT" style="height:auto;min-height:340px;">
						<input id="addProductImage" class="yl_button" type="button" value="添加滚动图片" onclick="javascript:addProductImageHtml();" style="margin-top:10px;margin-left: 12px;"/>
						&nbsp;&nbsp;<span><font color="RED">提示：请上传800*800像素的图片！</font></span>
						<table id="productImageTable" style="margin: 11px;" class="tabllist"  >
							<tr>
								<td width="28%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">图片上传预览</font></td>
								<td width="30%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">标题</font></td>
								<td width="22%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">排序</font></td>
								<td width="20%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">操作</font></td>
							</tr>
						</table>
					</div>
					<!-- 商品规格 begin-->
					<div title="商品规格" class="addProductByPT">
						<!-- 添加规格-->
						<div style="margin-bottom:7px;">
							<span>
							<input type="button" class="yl_button" style="margin-top:10px;margin-left: 14px;" value="添加规格" onclick="addNewSpecificationValue()"/>
							</span>
						</div>
						<!-- 当前分类下的规格 begin-->
						<div id="specificationSelect"></div>
						<!-- 当前分类下的规格 end -->
						<!-- 规格值 begin-->
						<div style="height:auto;min-height:240px; overflow-x:auto; overflow-y:hidden; margin:11px;">
							<table id="specificationProductTable" style="margin:5px;width:947px;; height:auto;">
								<!--选定规格值名称 -->
								<tr id="specificationProductTable-title" class="titlebg"></tr>
								<!--选定规格值-->
								<tr id="selectedSpecificationValues_0" class="selectedSpecificationValuesTD"></tr>
							</table>
						</div>
						<!-- 规格值 end -->
					</div>
					<!-- 商品规格 end -->
				</div>
				<div style="padding:0px;">
					<div class="editButton"  data-options="region:'south',border:false" >
						<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="javascript:saveProduct();" href="javascript:;">保存</a>
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div id="selectShop" style="width:980px;height:400px;margin: 0 auto;">
		<table class="searchTab" style="margin-top: 5px;border-collapse:separate;">
			<tr>
				<td class="toright_td" style="width:80px;'">店铺账号：</td>
				<td class="toleft_td" style="width:110px;"><input type="text" style="width: 93px;" id="qqcustName" name="custName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="toright_td" style="width:65px;">店铺名称：</td>
				<td class="toleft_td" style="width:110px;"><input type="text" style="width: 93px;" id="qqshopName" name="shopName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="toright_td" style="width:85px;">店铺分类：</td>
				<td class="toleft_td" style="width:110px;">
					<select id="parentIdList"  style="width:100px" name="shopInfo.shopCategoryId" class="{validate:{required:true}} Registration ;querySelect">
						<option value="-1">--请选择--</option>
						<s:iterator  value="shopCategoryList">
							<option  value="<s:property value="shopCategoryId" />">
								<s:if test="level==1">&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
								<s:if test="level==2">&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
								<s:if test="level==3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="shopCategoryName"/></s:if>
							</option>
						</s:iterator>
					</select>
				</td>
				<td class="toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:queryShopInfo()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:resetShopInfo()">重置</a>
				</td>
			</tr>
		</table>
		<table id="shopInfott"></table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="confirmShop_btnSave" class="easyui-linkbutton" icon="icon-save" onclick="confirmShop();" href="javascript:;">确认</a>
			<a id="confirmShop_btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</div>
</div>
