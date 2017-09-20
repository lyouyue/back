<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,400,"&nbsp;&nbsp;促销活动详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$("#checkPromotionWin").css("display","none");
		$("#promotionDiscountWin").css("display","none");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/promotion/getPromotionObjectDetai.action",
			   data: {promotionId:id},
			   dataType: "JSON",
			   success: function(data){
				   var platformPromotion = data.platformPromotion;
				   $("#dsmallCard").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+platformPromotion.smallPoster+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
			   	   $("#dbigCard").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+platformPromotion.largePoster+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='50px' height='50px' />");
				   $("#dpromotionName").html(platformPromotion.promotionName);
				   $("#dbeginTime").html(platformPromotion.beginTime);
				   $("#dendTime").html(platformPromotion.endTime);
				   if(platformPromotion.useStatus=="0"){
					   $("#duseStatus").html("<font class='color_002'>未开启</font>");
				   }else if(platformPromotion.useStatus=="1"){
					   $("#duseStatus").html("<font class='color_001'>开启</font>");
				   }else if(platformPromotion.useStatus=="2"){
					   $("#duseStatus").html("<font class='color_002'>已关闭</font>");
				   }
				   $("#dshopPromotionInfo").html(platformPromotion.shopPromotionInfo);
				   var salesPromotionDiscount=data.salesPromotionDiscount;
				   if(salesPromotionDiscount!=null&&salesPromotionDiscount.discount!=null&&salesPromotionDiscount.discount!=""){
				 	  $("#ddiscount").html(salesPromotionDiscount.discount);
				   }else{
					   $("#ddiscount").html("无折扣");
				   }
				   
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	<tr>
		    <td class="toright_td" width="200px">促销活动大海报:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbigCard"></span></td>
		    <td class="toright_td" width="200px">促销活动小海报:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsmallCard"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td">活动主题:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dpromotionName"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td">活动简介:</td>
			<td  class="toleft_td" colspan="3" style="word-break: break-all; word-wrap:break-word;">&nbsp;&nbsp;
			       <span id="dshopPromotionInfo"  ></span>
			  </td>
	    </tr>
	    <tr><td class="toright_td">折扣率:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="ddiscount"></span></td>
	    </tr>
	    <tr><td class="toright_td">开始时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dbeginTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">结束时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dendTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">活动状态:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="duseStatus"></span></td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>