<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#form1").css("display","none");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoObject.action",
			   data: {productId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dbrandId").val(data.brandId);
				   $("#dkindId").val(data.kindId);
				   $("#dproductName").html(data.productFullName);
				   $("#dcrowd").html(data.crowd);
				   $("#ddiscountPrice").html(data.discountPrice);
				   $("#dmemberPrice").html(data.memberPrice);
				   $("#dmarketPrice").html(data.marketPrice);
				   $("#dstandard").html(data.standard);
				   $("#dstoreSafeDate").html(data.storeSafeDate);
				   $("#ddescrible").html(data.describle);
				   $("#dpercentAge").html(data.percentAge);
				   $("#dvalidity").html(data.validity);
				   $("#dproductPlace").html(data.productPlace);
				   $("#dsmallPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.smallImgUrl+"' width='120px' height='120px' />");
			   	   $("#dbigPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.bigImgUrl+"' width='150px' height='150px' />");
				   $("#dputSaleDate").html(data.putSaleDate);
				   $("#dupdateDate").html(data.updateDate);
				   if(data.isPutSale=="0"){
					   $("#ddisPutSale").html("已上架");
				   }else{
					   $("#ddisPutSale").html("没有上架");
				   }
				   $("#dproductCode").html(data.productCode);
				   $("#dstoreNumber").html(data.storeNumber);
				   $("#dpointConvert").html(data.pointConvert);
				   var loaction = "";
				   var s = data.showLocation;
				   var split = s.split(",");
				   for(var i=0;i<split.length;i++){
					   var secondSplit = split[i].split("_");
					   loaction = loaction + secondSplit[1]+ ",";
				   }
				   $("#dshowLocation").html(loaction);
			   }
		});
	}
</script>
<div id="detailWin">
	<form action="" name="form1" id="form1"></form>
    <table align="center" class="addOrEditTable">
    	<tr>
		      <td class="toright_td">套餐品牌:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dbrandId" disabled="disabled">
		              <option value="-1">--请选择品牌--</option>
					  <s:iterator value="brandList">
					  	<option value="<s:property value="brandId"/>"><s:property value="brandName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		      <td class="toright_td">套餐品种:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dkindId" disabled="disabled">
		              <option value="-1">--请选择品种--</option>
					  <s:iterator value="kindList">
					  	<option value="<s:property value="kindId"/>"><s:property value="kindName"/></option>
					  </s:iterator>
		           </select>
		      </td>
			</tr>
	    <tr>
	    	<td class="toright_td">套餐名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dproductName"></span></td>
	    	<td class="toright_td">适宜人群:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dcrowd"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td">折扣价:</td><td class="toleft_td">&nbsp;&nbsp;<span id="ddiscountPrice"></span></td>
	    	<td class="toright_td">会员价:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dmemberPrice"></span></td>
	    </tr>
		    <tr><td class="toright_td">原价:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dmarketPrice"></span></td>
		    <td class="toright_td">规格:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dstandard"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">保质期:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dstoreSafeDate"></span></td>
		    <td class="toright_td">描述:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="ddescrible"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">金币支付比率:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dpercentAge"></span></td>
		    <td class="toright_td">有效期:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dvalidity"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">套餐小图片:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsmallPhoto"></span></td>
		    <td class="toright_td" width="200px">套餐大图片:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbigPhoto"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">上架时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dputSaleDate"></span></td>
		    <td class="toright_td" width="200px">更新时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dupdateDate"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">是否上架:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="ddisPutSale"></span></td>
		    <td class="toright_td" width="200px">套餐编号:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dproductCode"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="200px">库存数:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dstoreNumber"></span></td>
	    	<td class="toright_td" width="200px">产地:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dproductPlace"></span></td>
    	</tr>
	    <tr>
		    <td class="toright_td" width="200px">金币兑换:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dpointConvert"></span></td>
	    	<td class="toright_td" width="200px">展示位置:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dshowLocation"></span></td>
    	</tr>
    </table>
   <!--  <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>