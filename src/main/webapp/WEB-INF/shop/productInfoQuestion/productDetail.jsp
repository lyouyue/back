<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showProductDetail(id){
		createWindow(1000,500,"&nbsp;&nbsp;套餐详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#productDetailWin").css("display","");
		$("#detailWin").css("display","none");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoObject.action",
			   data: {productId:id},
			   dataType: "JSON",
			   success: function(data){
				   var productInfo = data.productInfo;
				   $("#d_brandId").val(productInfo.brandId);
				   $("#d_shopInfoId").val(productInfo.shopInfoId);
				   $("#d_productName").html(productInfo.productFullName);
				   $("#d_tuanPrice").html(productInfo.tuanPrice);
				   $("#d_memberPrice").html(productInfo.memberPrice);
				   $("#d_marketPrice").html(productInfo.marketPrice);
				   $("#d_salesPrice").html(productInfo.salesPrice);
				   $("#d_costPrice").html(productInfo.costPrice);
				   $("#d_smallPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+productInfo.logoImg+"' width='120px' height='120px' />");
				   $("#d_putSaleDate").html(data.putSaleDate);
				   $("#d_createDate").html(data.createDate);
				   $("#d_measuringUnitName").html(productInfo.measuringUnitName);
				   $("#d_packingSpecifications").html(productInfo.packingSpecifications);
				   $("#d_manufacturerModel").html(productInfo.manufacturerModel);
				   $("#virtualCoinNumber").html(productInfo.virtualCoinNumber);
				   $("#giveAwayCoinNumber").html(productInfo.giveAwayCoinNumber);
				   $("#d_updateDate").html(data.updateDate);
				   if(productInfo.isPutSale=="1"){
					   $("#d_disPutSale").html("<font class='color_002'>没有上架</font>");
				   }else if(productInfo.isPutSale=="2"){
					   $("#d_disPutSale").html("<font class='color_001'>已上架</font>");
				   }else{
					   $("#d_disPutSale").html("<font class='color_003'>违规下架</font>");
				   }
				   if(productInfo.isPass=="0"){
	  				    $("#d_isPass").html("<font class='color_002'>未通过</font>");
	  			   }else if(productInfo.isPass=="1"){
	  				    $("#d_isPass").html("<font class='color_001'>已通过</font>");
	  			   }else if(productInfo.isPass=="2"){
	  				    $("#d_isPass").html("<font class='color_004'>待申请</font>");
	  			   }else if(productInfo.isPass=="3"){
	  				    $("#d_isPass").html("<font class='color_003'>待审核</font>");
	  			   }
				   $("#d_productCode").html(productInfo.productCode);
				   $("#d_storeNumber").html(productInfo.storeNumber);
				   $("#d_pointConvert").html(productInfo.pointConvert);
				   if(productInfo.isTop=="0"){
					   $("#d_isTop").html("<font class='color_002'>否</font>");
				   }else{
					   $("#d_isTop").html("<font class='color_001'>是</font>");
				   }
				   if(productInfo.isNew=="0"){
					   $("#d_isNew").html("<font class='color_002'>否</font>");
				   }else{
					   $("#d_isNew").html("<font class='color_001'>是</font>");
				   }
				   if(productInfo.isHot=="0"){
					   $("#d_isHot").html("<font class='color_002'>否</font>");
				   }else{
					   $("#d_isHot").html("<font class='color_001'>是</font>");
				   }
				   if(productInfo.isRecommend=="0"){
					   $("#d_isRecommend").html("<font class='color_002'>否</font>");
				   }else{
					   $("#d_isRecommend").html("<font class='color_001'>是</font>");
				   }
				   $("#d_productTypeName").html(data.productTypeName);//分类的名称
				   //所选的属性的json----start
				   var jaattrList = data.attrList;
				   if(jaattrList!=""){
					   var prodAttr1 = eval(jaattrList);
					   if(prodAttr1.length>0){
						   var htmlAttrStr1="<tr><td colspan='2'>套餐的属性</td></tr>";
			  			   for(var i=0;i<prodAttr1.length;i++){
			  					htmlAttrStr1+="<tr><td>"+prodAttr1[i].name+"</td>"
			  					htmlAttrStr1+="<td>"+prodAttr1[i].attrValueName+"</td></tr>"
			  				}
			  				 $("#totalProdAttr1").html(htmlAttrStr1);
		  			    }
				   }else{
					   $("#totalProdAttr1").html("");
				   }
	  			  //所选的属性的json----end
	  			  //所选的参数json-----start
	  			  if(productInfo.productParametersValue!=""){
					   var prodPara1 = eval(productInfo.productParametersValue);
		  			   if(prodPara1.length){
			  			   var htmlParaStr1="<tr><td colspan='2'>套餐的参数</td></tr>";
			  			   for(var i=0;i<prodPara1.length;i++){
			  				   htmlParaStr1+="<tr><td>"+prodPara1[i].name+"</td>";
			  				   htmlParaStr1+="<td><table>";
			  				   var paraInfoValue1=eval(prodPara1[i].paramGroupInfo);
			  				   for(var j=0;j<paraInfoValue1.length;j++){
			  					   htmlParaStr1+="<tr><td>"+paraInfoValue1[j].name+"</td>";
			  					   htmlParaStr1+="<td>"+paraInfoValue1[j].value+"</td></tr>";
			  				   }
			  				   htmlParaStr1+="</table></td>";
			  				   htmlParaStr1+="</tr>";
			  			   }
			  			   $("#totalProdPara1").html(htmlParaStr1);
		  			   }
	  			   }else{
	  				   $("#totalProdPara1").html("");
	  			   }
	  			  //所选的参数json-----end
	  			  //标签
	  			var jatageNameList = data.tageNameList;
				   if(jatageNameList!=""){
					   var prodAttr1 = eval(jatageNameList);
					   if(prodAttr1.length>0){
						   htmlAttrStr1="";
						   htmlAttrStr2="";
			  			   for(var i=0;i<prodAttr1.length;i++){
			  				 if(i==prodAttr1.length-1){
			  					htmlAttrStr1+=prodAttr1[i].ttName
			  					htmlAttrStr2+=prodAttr1[i].stName
			  					}else{
			  						htmlAttrStr1+=prodAttr1[i].ttName+","
				  					htmlAttrStr2+=prodAttr1[i].stName+","
			  					}
			  				}
			  				 $("#d_labels").html(htmlAttrStr1);
			  				 $("#d_labels1").html(htmlAttrStr2);
		  			    }
				   }else{
					   $("#d_labels").html("");
				   }
			   }
		});
	}
</script>
<div id="productDetailWin">
    <table align="center" class="addOrEditTable" width="800px;" >
    	<input type="hidden" id="tageNameList" value="<s:property value="tageNameList"/>"/>
    	<tr>
	    	<td class="toright_td" >套餐所属分类:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="d_productTypeName"></span></td>
	    </tr>
    	<tr>
	      <td class="toright_td">套餐品牌:</td>
	      <td class="toleft_td">&nbsp;&nbsp;
	           <select id="d_brandId" disabled="disabled">
				  <s:iterator value="brandList">
				  	<option value="<s:property value="brandId"/>"><s:property value="brandName"/></option>
				  </s:iterator>
	           </select>
	      </td>
	      <td class="toright_td">机构名称:</td>
	      <td class="toleft_td">&nbsp;&nbsp;
	           <select id="d_shopInfoId" disabled="disabled">
				  <s:iterator value="shopInfoList">
				  	<option value="<s:property value="shopInfoId"/>"><s:property value="shopName"/></option>
				  </s:iterator>
	           </select>
	      </td>
		</tr>
	    <tr>
	    	<td class="toright_td">套餐名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_productName"></span></td>
	    	<td class="toright_td" width="200px">货号:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_productCode"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td">市场价格:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_marketPrice"></span></td>
	    	<td class="toright_td">销售价格:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_salesPrice"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td">佣金分享金币:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="virtualCoinNumber"></span></td>
	    	<td class="toright_td">商城赠送币:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="giveAwayCoinNumber"></span></td>

	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">套餐图片:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="d_smallPhoto"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td" >适用专业:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="d_labels"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td" >使用场合:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="d_labels1"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td" >制造商型号:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="d_manufacturerModel"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">创建时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_createDate"></span></td>
		    <td class="toright_td" width="200px">更新时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_updateDate"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">是否上架:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_disPutSale"></span></td>
		    <td class="toright_td" width="200px">上架时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_putSaleDate"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">库存数:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_storeNumber"></span></td>
	    	<td class="toright_td" width="200px">审核状态:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_isPass"></span></td>
    	</tr>
    	<tr>
	    	<td class="toright_td" width="200px">是否置顶:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_isTop"></span></td>
	    	<td class="toright_td" width="200px">是否推荐:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_isRecommend"></span></td>
    	</tr>
    	<tr>
	    	<td class="toright_td" width="200px">计量单位名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_measuringUnitName"></span></td>
	    	<td class="toright_td" width="200px">包装规格:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_packingSpecifications"></span></td>
    	</tr>
    	<tr>
	    	<td class="toright_td" width="200px">是否为新套餐:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_isNew"></span></td>
    	</tr>
    </table>
    <table align="center" id="totalProdAttr1" class="addOrEditTable" width="800px;" >
    	<input type="hidden" id="attrList" value="<s:property value="attrList"/>"/>
    	<tr><td colspan="2">套餐的属性</td></tr>
    </table>
    <table align="center" id="totalProdPara1" class="addOrEditTable" width="800px;">
    	<tr><td colspan="2">套餐的参数</td></tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
</div>