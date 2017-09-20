<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,"auto","&nbsp;&nbsp;退货申请详情","icon-tip",false,"detailWin");
		$("#addOrEditorWin").css("display","none");
		$("#reviewWin").css("display","none");
		$("#detailOPLogWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/returnsApply/getReturnsApplyObject.action",
			   data: {returnsApplyId:id},
			   dataType: "JSON",
			   success: function(data){
				   var customer = data.customer;
				   var returnsApply = data.returnsApply;
				   var uploadFileVisitRoot = data.uploadFileVisitRoot;
				   var showUploadImgList = data.showUploadImgList;
				   var imgHtml="";
				   for(var i=0;i<showUploadImgList.length;i++){
					   imgHtml+="<img style='height: 50px; width: 50px;' src='"+uploadFileVisitRoot+showUploadImgList[i]+"'/>";
				   }
				   $("#dreturnsApplyNo").html(returnsApply.returnsApplyNo);
				   $("#dcustomerId").html(customer.loginName);
				   $("#dordersNo").html(returnsApply.ordersNo);
				   $("#dproductName").html(returnsApply.productName);
				   if(returnsApply.disposeMode=="0"){
					   $("#ddisposeMode").html("返修");
				   }else if(returnsApply.disposeMode=="1"){
					   $("#ddisposeMode").html("换货");
				   }else{
					   $("#ddisposeMode").html("退货退款");
				   }
				   $("#dproblemDescription").html(returnsApply.problemDescription);
				   $("#duploadImage").html(imgHtml);
				   $("#dlinkman").html(returnsApply.linkman);
				   $("#dmobilePhone").html(returnsApply.mobilePhone);
				   $("#dapplyTime").html(returnsApply.applyTime);
				   $("#dcount").html(returnsApply.count);
				   if(returnsApply.returnsState=="1"){ 
					   $("#dreturnsState").html("退货中");
				   }else if(returnsApply.returnsState=="2"){
					   $("#dreturnsState").html("退货完成");
				   }else if(returnsApply.returnsState=="3"){
					   $("#dreturnsState").html("退款中");
				   }else if(returnsApply.returnsState=="4"){
					   $("#dreturnsState").html("退款完成");
				   }else if(returnsApply.returnsState=="5"){
					   $("#dreturnsState").html("订单处理完成");
				   } 
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	<tr>
    		<td class="toright_td" width="150px">退货申请编号:&nbsp;&nbsp;</td>
    		<td class="toleft_td" width="400px">&nbsp;&nbsp;<span id="dreturnsApplyNo"></span></td>
    		<td class="toright_td" width="150px">会员名称:&nbsp;&nbsp;</td>
	        <td class="toleft_td" width="400px">&nbsp;&nbsp;<span id="dcustomerId"></span></td>
    	</tr>
    	<tr>
	    	<td class="toright_td" width="150px">订单号:&nbsp;&nbsp;</td>
	    	<td class="toleft_td" width="400px">&nbsp;&nbsp;<span id="dordersNo"></span></td>
	    	<td class="toright_td" width="150px">套餐名称:&nbsp;&nbsp;</td>
	    	<td class="toleft_td" width="400px">&nbsp;&nbsp;<span id="dproductName"></span></td>
    	</tr>
	    <tr>
	    	<td class="toright_td" width="150px">期望处理方式:&nbsp;&nbsp;</td>
	    	<td class="toleft_td" width="400px">&nbsp;&nbsp;<span id="ddisposeMode"></span></td>
   	        <td class="toright_td" width="150px" colspan="1">问题描述:&nbsp;&nbsp;</td>
		    <td  class="toleft_td" width="400px">&nbsp;&nbsp;<label id="dproblemDescription" ></label></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="300px">申请退货图片:&nbsp;&nbsp;</td>
		    <td class="toleft_td" width="400px" colspan="3">&nbsp;&nbsp;<span id="duploadImage"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="150px">联系人:</td>
		    <td class="toleft_td" width="400px"><span id="dlinkman"></span></td>
	    	<td class="toright_td" width="150px">手机号码:</td>
	    	<td class="toleft_td" width="400px"><span id="dmobilePhone"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td" width="150px">申请时间:</td>
	    	<td class="toleft_td" width="400px"><span id="dapplyTime"></span></td>
	    	<td class="toright_td" width="150px">退货数量:</td>
	    	<td class="toleft_td" width="400px"><span id="dcount"></span></td>
	    </tr>
	    <tr>
	    	<td class="toright_td" width="150px">退货状态:</td>
	    	<td class="toleft_td" width="400px" colspan="3"><span id="dreturnsState"></span></td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>