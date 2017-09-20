<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(800,440,"&nbsp;&nbsp;套餐答疑详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#productDetailWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/productInfoQuestion/getProductInfoQuestionInfo.action",
			data: {ids:id},
			dataType: "JSON",
			success: function(data){
				$("#dproductName").html(data.productName);
				$("#dcustomerName").html(data.customerName);
				$("#daskQuestion").html(data.askQuestion);
				<s:iterator value="#application.keybook['askType']" var="kb">
				if(data.askType==<s:property value='#kb.value'/>){
					$("#daskType").html("<s:property value='#kb.name'/>");
				}
				</s:iterator>
				$("#duserName").html(data.answerName);
				$("#danswer").html(data.answer);
				$("#daskTime").html(data.askTime);
				$("#dcheckTime").html(data.checkTime);
				if(data.status==1){
					$("#dstatus").html("<font class='color_002'>未通过审核</font>");
				}else if(data.status==2){
					$("#dstatus").html("<font class='color_001'>通过审核</font>");
				}else if(data.status==3){
					$("#dstatus").html("<font class='color_003'>待审核</font>");
				}
				if(data.shopStatus==1){
					$("#dshopStatus").html("<font class='color_002'>未通过审核</font>");
				}else if(data.shopStatus==2){
					$("#dshopStatus").html("<font class='color_001'>通过审核</font>");
				}else if(data.shopStatus==3){
					$("#dshopStatus").html("<font class='color_003'>待审核</font>");
				}
			}
		});
	}
</script>
<div id="detailWin">
	<table align="center" class="addOrEditTable" width="800px;" >
		<input type="hidden" id="tageNameList" value="<s:property value="tageNameList"/>"/>
		<tr>
			<td class="toright_td" width="150px">套餐名称:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dproductName"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >会员名称:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dcustomerName"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >咨询类型:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="daskType"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >咨询内容:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="daskQuestion"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >咨询时间:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="daskTime"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >机构回复:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="danswer"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >审核人名称:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="duserName"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >审核时间:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dcheckTime"></span></td>
		</tr>
		<tr>
			<td class="toright_td" >审核状态:</td><td class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dstatus"></span></td>
		</tr>
 	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
    </div>
</div>