<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/promotionapply/getPromotionApplyById.action",
			   data: {ids:id},
			   dataType: "JSON",
			   success: function(data){
				  $("#dcustomerId").html(data.shopName);
				  $("#dhopInfoId").html(data.customerName);
				  $("#dbeginTime").html(data.beginTime);
				  $("#dendTime").html(data.endTime);
				  $("#applyTime").html(data.applyTime);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="850px;">
	    <tr>
		    <td class="toright_td">会员名称:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dcustomerId"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">店铺名称:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dhopInfoId"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">活动开始时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dbeginTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">活动结束时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dendTime"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">申请时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="applyTime"></span></td>
	    </tr>
	    <tr>
   	      <td class="toright_td" width="150px" colspan="1">促销活动详情:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		       <textarea id="dshopPromotionInfo" rows="8" cols="48" class="{validate:{required:true,maxlength:[2000]}}"></textarea>
		  </td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>