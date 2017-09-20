<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<style type="text/css">
#functionDescValue img{
	width:auto;
	max-width:765px;
	height:auto;
}
</style>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;套餐详情","icon-tip",false,"detailWin");
		$/* ("#addOrEditWin").css("display","none");
		$("#addShopInfo").css("display","none");
		$("#showInListWin").css("display","none");
		$("#merchandise_add").css("display","none");
		$("#editProductWin").css("display","none"); */
		$("#detailWin").css("display","");
		/* $(".newAdd").remove(); */
		$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoObject.action",
				data: {productId:id},
				dataType: "JSON",
				success: function(data){
					var productInfo = data.productInfo;
					var productImgList = data.productImgList;
					if(data.shopName!=null){
						$("#dshopName").html(data.shopName);
					}else{
						$("#dshopName").html("/");
					}
					if(data.brandName!=null){
						$("#dbrandId").html(data.brandName);
					}else{
						$("#dbrandId").html("/");
					}
					if(data.shopProCategoryName!=null){
						$("#dshopProCategoryName").html(data.shopProCategoryName);
					}else{
						$("#dshopProCategoryName").html("/");
					}
					$("#dshopInfoId").val(productInfo.shopInfoId);
					$("#dproductName").html(productInfo.productFullName);
					$("#dtuanPrice").html(productInfo.tuanPrice);
					$("#dmemberPrice").html(productInfo.memberPrice);
					$("#dmarketPrice").html(productInfo.marketPrice);
					$("#dsalesPrice").html(productInfo.salesPrice);
					$("#dcostPrice").html(productInfo.costPrice);
					$("#dsmallPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+productInfo.logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='120px' height='120px' />");
					$("#dcreateDate").html(data.createDate);
					$("#dmeasuringUnitName").html(productInfo.measuringUnitName);
					
					$("#virtualCoinNumber").html(productInfo.virtualCoinNumber);
					$("#giveAwayCoinNumber").html(productInfo.giveAwayCoinNumber);
					$("#dstoreNumber").html(productInfo.storeNumber);
					$("#dproductId").html(productInfo.productId);
					$("#dproductTypeName").html(data.productTypeName);//分类的名称
					$("#dqrCode").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+productInfo.qrCode+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='120px' height='120px' />");
					
					
					if(productInfo.manufacturerModel!=null&&productInfo.manufacturerModel!=""){
						$("#dmanufacturerModel").html(productInfo.manufacturerModel);
					}else{
						$("#dmanufacturerModel").html("/");
					}
					if(productInfo.barCode!=null&&productInfo.barCode!=""){
						$("#dbarCode").html(productInfo.barCode);
					}else{
						$("#dbarCode").html("/");
					}
					if(productInfo.auditComment!=null&&productInfo.auditComment!=""){
						$("#dauditComment").html(productInfo.auditComment);
					}else{
						$("#dauditComment").html("/");
					}
					if(data.putSaleDate!=null&&data.putSaleDate!=""){
						$("#dputSaleDate").html(data.putSaleDate);
					}else{
						$("#dputSaleDate").html("/");
					}
					if(productInfo.packingSpecifications!=null&&productInfo.packingSpecifications!=""){
						$("#dpackingSpecifications").html(productInfo.packingSpecifications);
					}else{
						$("#dpackingSpecifications").html("/");
					}
					if(productInfo.productCode!=null&&productInfo.productCode!=""){
						$("#dproductCode").html(productInfo.productCode);
					}else{
						$("#dproductCode").html("/");
					}
					if(data.updateDate!=null&&data.updateDate!=""){
						$("#dupdateDate").html(data.updateDate);
					}else{
						$("#dupdateDate").html("/");
					}
					if(productInfo.pointConvert!=null&&productInfo.pointConvert!=""){
						$("#dpointConvert").html(productInfo.pointConvert);
					}else{
						$("#dpointConvert").html("/");
					}
					if(productInfo.note!=null&&productInfo.note!=""){
						$("#dnote").html(productInfo.note);
					}else{
						$("#dnote").html("/");
					}
					if(productInfo.seoTitle!=null&&productInfo.seoTitle!=""){
						$("#dseoTitle").html(productInfo.seoTitle);
					}else{
						$("#dseoTitle").html("/");
					}
					if(productInfo.seoKeyWord!=null&&productInfo.seoKeyWord!=""){
						$("#dseoKeyWord").html(productInfo.seoKeyWord);
					}else{
						$("#dseoKeyWord").html("/");
					}
					if(productInfo.seoDescription!=null&&productInfo.seoDescription!=""){
						$("#dseoDescription").html(productInfo.seoDescription);
					}else{
						$("#dseoDescription").html("/");
					}
					if(productInfo.isPutSale=="1"){
						$("#ddisPutSale").html("<font class='color_002'>未上架</font>");
					}else if(productInfo.isPutSale=="2"){
						$("#ddisPutSale").html("<font class='color_001'>已上架</font>");
					}else{
						$("#ddisPutSale").html("<font class='color_003'>违规下架</font>");
					}
					if(productInfo.isPass=="0"){
						 $("#disPass").html("<font class='color_002'>未通过</font>");
					}else if(productInfo.isPass=="1"){
						 $("#disPass").html("<font class='color_001'>已通过</font>");
					}else if(productInfo.isPass=="2"){
						 $("#disPass").html("<font class='color_004'>待申请</font>");
					}else if(productInfo.isPass=="3"){
						 $("#disPass").html("<font class='color_003'>待审核</font>");
					}
					if(productInfo.isTop=="0"){
						$("#disTop").html("<font class='color_002'>否</font>");
					}else{
						$("#disTop").html("<font class='color_001'>是</font>");
					}
					if(productInfo.isNew=="0"){
						$("#disNew").html("<font class='color_002'>否</font>");
					}else{
						$("#disNew").html("<font class='color_001'>是/font>");
					}
					if(productInfo.isHot=="0"){
						$("#disHot").html("<font class='color_002'>否</font>");
					}else{
						$("#disHot").html("<font class='color_001'>是</font>");
					}
					if(productInfo.isRecommend=="0"){
						$("#disRecommend").html("<font class='color_002'>否</font>");
					}else{
						$("#disRecommend").html("<font class='color_001'>是</font>");
					}
					var imgHtml="";
					if(productImgList!=null&&productImgList!=""){
						for(var i=0;i<productImgList.length;i++){
							imgHtml+="<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+productImgList[i].thumbnail+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' style='margin-left:5px;'/>";
						}
					}else{
						imgHtml+="/";
					}
					$("#duploadImage").html(imgHtml);
					//所选的属性的json----start
					var jaattrList = data.attrList;
					var htmlAttrStr1="";
					if(jaattrList!=""){
						var prodAttr1 = eval(jaattrList);
						if(prodAttr1.length>0){
							htmlAttrStr1+="<tr class='titlebg newAdd'><td align='center' colspan='4'>套餐属性</td></tr>";
							for(var i=0;i<prodAttr1.length;i++){
								if((i+1)%2==1){//当前参数为第奇数个时，追加<tr>标签
									htmlAttrStr1 += "<tr style='line-height: 22px' class='newAdd'>";
								}
								htmlAttrStr1+="<td width='19%;' align='right'>"+prodAttr1[i].name+":</td>"
								if(i==(prodAttr1.length-1)){
									htmlAttrStr1+="<td colspan=\"3\" width='81%;' align='left'>"+prodAttr1[i].attrValueName+"</td>"
								}else{
									htmlAttrStr1+="<td width='31%;' align='left'>"+prodAttr1[i].attrValueName+"</td>"
								}
								if((i+1)%2==0){//当前参数为第偶数个时，追加</tr>标签
									htmlAttrStr1 += "</tr>";
								}else{
									if(i==(prodAttr1.length-1)){//最后一行不够两个参数时，追加</tr>标签
										htmlAttrStr1 += "</tr>";
									}
								}
							}
						}
				}
				$("#detailTable").append(htmlAttrStr1);
				//所选的属性的json----end
				//所选的参数json-----start
				var htmlParaStr1="";
				if(productInfo.productParametersValue!=""){
					var prodPara1 = eval(productInfo.productParametersValue);
					if(prodPara1.length){
						htmlParaStr1+="<tr class='titlebg newAdd'><td colspan='4' align='center'>套餐参数</td></tr>";
						for(var i=0;i<prodPara1.length;i++){
							htmlParaStr1+="<tr><td width='136px' align='right' class='newAdd'>"+prodPara1[i].name+"</td>";
							htmlParaStr1+="<td colspan='3' class='newAdd'><table style='border-collapse:collapse;border-spacing:0;width:100%;'>";
							var paraInfoValue1=eval(prodPara1[i].paramGroupInfo);
							for(var j=0;j<paraInfoValue1.length;j++){
									var paraInfo_value = '/';
									if(paraInfoValue1[j].value!=''&&paraInfoValue1[j].value!=null){
										paraInfo_value = paraInfoValue1[j].value;
									}
									if((j+1)%2==1){//当前参数为第奇数个时，追加<tr>标签
										htmlParaStr1 += "<tr style='line-height: 22px;' class='newAdd'>";
									}
									htmlParaStr1+="<td align='right' width='25%'>"+paraInfoValue1[j].name+":</td>";
									
									if((j+1)%2==1&&j==(paraInfoValue1.length-1)){
										htmlParaStr1+="<td colspan=\"3\" align='left' width='75%'>"+paraInfo_value+"</td>";
										
									}else{
										htmlParaStr1+="<td align='left' width='25%'>"+paraInfo_value+"</td>";
										
									}
									if((j+1)%2==0){//当前参数为第偶数个时，追加</tr>标签
										htmlParaStr1 += "</tr>";
									}else{
										if(j==(paraInfoValue1.length-1)){//最后一行不够两个参数时，追加</tr>标签
											htmlParaStr1 += "</tr>";
										}
									}
							}
							htmlParaStr1+="</table></td>";
							htmlParaStr1+="</tr>";
						}
					}
				}
				$("#detailTable").append(htmlParaStr1);
				//所选的参数json-----end
				var functionDescHtml=""
				if(productInfo.functionDesc!=null&&productInfo.functionDesc!=""){
					functionDescHtml += "<tr class='titlebg newAdd'><td colspan='4' align='center'>套餐详情</td></tr>";
					functionDescHtml += "<tr><td align='left' colspan='4' class='newAdd'>&nbsp;&nbsp;";
					functionDescHtml += "<span id='functionDescValue' style='width:800px;'>"+productInfo.functionDesc+"</span>";
					functionDescHtml += "</td></tr>";
				}
				$("#detailTable").append(functionDescHtml);
			}
		});
	}
</script>
<div id="detailWin">
	<table id="detailTable" align="center" class="addOrEditTable" width="800px;" style="margin-left:43px;">
		<input type="hidden" id="tageNameList" value="<s:property value="tageNameList"/>"/>
		<tr class="titlebg"><td colspan='4' align='center'>套餐信息</td></tr>
		<tr>
			<td align="right" width="150px">套餐LOGO:</td>
			<td  align="left"  width="250px" height="150px">&nbsp;&nbsp;<span id="dsmallPhoto"></span></td>
			<td align="right" width="150px">套餐二维码:</td>
			<td  align="left"  width="250px" height="150px">&nbsp;&nbsp;<span id="dqrCode"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">套餐ID:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dproductId"></span></td>
			<td align="right" width="150px">套餐名称:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dproductName"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">套餐编号:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dproductCode"></span></td>
			<td align="right" width="150px">店铺名称:</td>
			 <td align="left" width="250px">&nbsp;&nbsp;<span id="dshopName"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">套餐所属分类:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dproductTypeName"></span></td>
			<td align="right" width="150px">店铺内部分类:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dshopProCategoryName"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">套餐品牌:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dbrandId"></span></td>
			<td align="right" width="150px">库存数:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="dstoreNumber"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">市场价格:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="dmarketPrice"></span></td>
			<td align="right" width="150px">销售价格:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dsalesPrice"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">商城赠送金币:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="giveAwayCoinNumber"></span></td>
			<td align="right" width="150px">条形码:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dbarCode"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">包装规格:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="dpackingSpecifications"></span></td>
			<td align="right" width="150px">计量单位:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="dmeasuringUnitName"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">制造商型号:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dmanufacturerModel"></span></td>
			<td align="right" width="150px">是否推荐:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="disRecommend"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">是否上架:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="ddisPutSale"></span></td>
			<td align="right" width="150px">上架时间:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dputSaleDate"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">创建时间:</td><td  align="left" width="250px">&nbsp;&nbsp;<span id="dcreateDate"></span></td>
			<td align="right" width="150px">更新时间:</td><td  align="left" width="250px">&nbsp;&nbsp;<span id="dupdateDate"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">审核状态:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="disPass"></span></td>
			<td align="right" width="150px">审核备注:</td>
			<td  align="left" colspan="3">&nbsp;&nbsp;<span id="dauditComment"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">套餐图片:</td>
			<td  align="left" colspan="3" style="line-height: 10px;">&nbsp;&nbsp;<span id="duploadImage"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">套餐备注:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dnote"></span></td>
			<td align="right" width="150px">SEO标题:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="dseoTitle"></span></td>
		</tr>
		<tr>
			<td align="right" width="150px">SEO关键字:</td>
			<td align="left" width="250px">&nbsp;&nbsp;<span id="dseoKeyWord"></span></td>
			<td align="right" width="150px">SEO描述:</td>
			<td  align="left" width="250px">&nbsp;&nbsp;<span id="dseoDescription"></span></td>
		</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>