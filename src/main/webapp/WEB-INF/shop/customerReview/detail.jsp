<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/customerReview/getCustomerReviewObject.action",
			   data: {customerReviewId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dproductId").val(data.productId);
				   $("#dcustomerId").val(data.customerId);
				   $("#dtitle").html(data.title);
				   $("#dlevel").html(data.level);
				   $("#dcontent").val(data.content);
				   $("#dadvantage").html(data.advantage);
				   $("#dshortcoming").html(data.shortcoming);
				   if(data.state=="0"){
					   $("#dstate").html("未审核");
				   }else{
					   $("#dstate").html("已审核");
				   }
				   $("#dbackReview").val(data.backReview);
				   if(data.backState=="0"){
					   $("#dbackState").html("未回复");
				   }else{
					   $("#dbackState").html("已回复");
				   }
				   $("#dcreateTime").html(data.createTime);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	 <tr>
	      <td class="toright_td" width="200px">会员名称:</td>
	      <td class="toleft_td">&nbsp;&nbsp;
	           <select id="dcustomerId" disabled="disabled">
	              <option value="-1">--请选择类型--</option>
				  <s:iterator value="customerList">
				  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
				  </s:iterator>
	           </select>
	      </td>
		</tr>
    	<tr>
		      <td class="toright_td" width="200px">套餐信息:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dproductId" disabled="disabled">
		              <option value="-1">--请选择套餐--</option>
					  <s:iterator value="productInfoList">
					  	<option value="<s:property value="productId"/>"><s:property value="productName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
	    <tr><td class="toright_td" width="200px">评价标题:</td><td class="toleft_td" width="500px">&nbsp;&nbsp;<span id="dtitle"></span></td></tr>
	    <tr><td class="toright_td" width="200px">评价等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dlevel"></span></td></tr>
    	<tr>
	   	      <td class="toright_td" width="200px" colspan="1">评价内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="dcontent" rows="8" cols="48"></textarea>
			  </td>
		</tr>
	    <tr><td class="toright_td" width="200px">产品优点:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dadvantage"></span></td></tr>
	    <tr><td class="toright_td" width="200px">产品不足:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dshortcoming"></span></td></tr>
	    <tr><td class="toright_td" width="200px">评价状态:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dstate"></span></td></tr>
		<tr>
	   	      <td class="toright_td" width="200px" colspan="1">回复内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="dbackReview" rows="8" cols="48"></textarea>
			  </td>
		    </tr>
	    <tr><td class="toright_td" width="200px">回复状态:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbackState"></span></td></tr>
	    <tr><td class="toright_td" width="200px">评价时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td></tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>