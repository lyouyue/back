<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	var isPass;
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#passWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/shopapply/getShopApplyById.action",
			   data: {ids:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dshopCategoryId").val(data.shopCategoryId);
				   $("#dcustomerId").val(data.customerId);
				   $("#dpmc").html(data.shopName);
				   $("#szdq").html(data.region);
				   $("#xxdz").html(data.address);
				   $("#yzbm").html(data.postCode);
				   $("#lxdh").html(data.phone);
				   $("#sfz").html(data.IDCards);
				   $("#sfztp").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.IDCardsImage+"' width='120px' height='120px' />");
			   	   $("#sfzzp").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.permitImage+"' width='150px' height='150px' />");
				   $("#sqsj").html(data.applyTime);
				   var num = data.isPass;
				   if(num == 0){
					   isPass = "否";
				   }else{
					   isPass = "是";
				   }
				   $("#jftg").html(isPass);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="850px;">
		<tr>
			<td class="toright_td" width="150px">店铺分类:</td>
			<td class="toleft_td">&nbsp;&nbsp;
				<select id="dshopCategoryId" name="shopCategory.shopCategoryName" disabled="disabled">
				    	<s:iterator value="shopCategoryList">
				  			<option value="<s:property value="shopCategoryId"/>"><s:property value="shopCategoryName"/></option>
				  		</s:iterator>
	           </select>
		    </td>
	    </tr>
		<tr>
		      <td class="toright_td" width="150px">选择会员:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dcustomerId" name="shopApply.customerId" disabled="disabled">
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
	    <tr>
		    <td class="toright_td">店铺名称:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dpmc"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">所在地区:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="szdq"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">详细地址:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="xxdz"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">邮政编码:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="yzbm"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">联系电话:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="lxdh"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">身份证:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="sfz"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">身份证图片:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="sfztp"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">执照照片:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="sfzzp"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">申请时间:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="sqsj"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">是否通过:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="jftg"></span></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>