<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(800,360,"&nbsp;&nbsp;优惠券详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#useStatusWin").css("display","none");
		$("#passWin").css("display","none");
		$("#detailWin").css("display","");
		$("#congeal").css("display","none");
		$("#manualGive").css("display","none");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/discountcoupon/getDiscountCouponById.action",
			   data: {ids:id},
			   dataType: "JSON",
			   success: function(data){
				  $("#dshopInfoId").html(data.shopInfoId);
				  $("#ddiscountCouponName").html(data.discountCouponName);
				  $("#ddiscountCouponAmount").html(data.discountCouponAmount);
				  $("#ddiscountCouponLowAmount").html(data.discountCouponLowAmount);
				  $("#dcreateTime").html(data.createTime);
				  $("#dbeginTime").html(data.beginTime);
				  $("#dsurplus").html(data.surplus);
				  $("#drestrictCount").html(data.restrictCount);
				  $("#dexpirationTime").html(data.expirationTime);
				  $("#ddistributionCount").html(data.distributionCount);
				  $("#dverifier").html(data.verifier);
				  $("#dcheckTime").html(data.checkTime);
				  if(data.useStatus==1){
					  $("#duseStatus").html("<font class='color_001'>启用</font>"); 
				  }else{
					  $("#duseStatus").html("<font class='color_002'>未启用</font>");
				  }
				  if(data.isPass==2){
					  $("#disPass").html("<font class='color_001'>审核通过</font>"); 
				  }else if(data.isPass==1){
					  $("#disPass").html("<font class='color_003'>待审核</font>");
				  }else{
					  $("#disPass").html("<font class='color_002'>审核未通过</font>");
				  }
				  
				  if(data.templatetype==1){
					  $("#dtemplatetype").html("模板一"); 
				  }else if(data.templatetype==2){
					  $("#dtemplatetype").html("模板二"); 
				  }else if(data.templatetype==3){
					  $("#dtemplatetype").html("模板三"); 
				  }else if(data.templatetype==4){
					  $("#dtemplatetype").html("模板四"); 
				  }
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="700px;">
	    <tr>
		    <td class="toright_td" style="width: 150px;">优惠劵名称：</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="ddiscountCouponName"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" style="width: 150px;">优惠金额：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="ddiscountCouponAmount"></span></td>
		    <td class="toright_td" style="width: 150px;">优惠下限金额：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="ddiscountCouponLowAmount"></span></td>
	    </tr> 
	    <tr>
		    <td class="toright_td" style="width: 150px;">发放个数：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="ddistributionCount"></span></td>
		    <td class="toright_td" style="width: 150px;">剩余个数：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsurplus"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" style="width: 150px;">开始时间：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbeginTime"></span></td>
		    <td class="toright_td" style="width: 150px;">结束时间：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dexpirationTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" style="width: 150px;">创建时间：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td>
		    <td class="toright_td" style="width: 150px;">启用状态：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="duseStatus"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" style="width: 150px;">审核人：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dverifier"></span></td>
		    <td class="toright_td" style="width: 150px;">审核状态：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disPass"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" style="width: 150px;">审核时间：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcheckTime"></span></td>
		    <td class="toright_td" style="width: 150px;">优惠券模板：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dtemplatetype"></span></td>
	    </tr>
<!-- 	    <tr> -->
<!-- 		      <td class="toright_td" width="150px">优惠券图片预览 :</td> -->
<!-- 		      <td  class="toleft_td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
<!-- 		      	<span id="dddiscountImage" ></span> -->
<!-- 		      </td> -->
<!-- 			</tr> -->
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>