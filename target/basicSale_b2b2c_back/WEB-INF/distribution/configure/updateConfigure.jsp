<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
    <title>分销配置信息</title>
    <jsp:include page="../../util/import.jsp"/>
    
    <script type="text/javascript">
    $(function(){//表单验证
    	   //表单验证
    	    $("#selectForm").validate({meta: "validate", 
    	       submitHandler:function(form){
    	       $(document).ready(
    	             function() {  
    	                   var options = {  
    	                       url : "${pageContext.request.contextPath}/back/configure/saveOrUpdateDisConfigure.action",  
    	                       type : "post",
    	                       dataType:"json",
    	                       success : function(data) {
    	                    		if(data.flag==true){
    	                    			/* var address = "";
    									$.ajax({
    										url:"${pageContext.request.contextPath}/back/update/getTomcatAddress.action",
    										type:"post",
    										dataType:"text",
    										async:false,//false同步;true异步
    										success:function(data){
    											address = data;
    											var attr = new Array();
    											attr= address.split(";");
    											for (var i=0; i<attr.length; i++) {
    												var url= "http://"+attr[i] + "/back/update/updateConfig.action?callback=?";
    												$.getJSON(url);
    											}
    										}
    									}); */
    	                    			window.location.href="${pageContext.request.contextPath}/back/configure/gotoConfigurePage.action";
    								}else{
    									msgShow("系统提示", "<p class='tipInfo'>保存失败，请重试！</p>", "warning");
    								}
    	                       }
    	                   };  
    	                   $("#selectForm").ajaxSubmit(options); 
    	                   $("input.button_save").attr("disabled","disabled");//防止重复提交
    	                });
    	       }
    	    });
    	  });
	//验证金额   xxx.xx
    jQuery.validator.addMethod("amountDecimal", function(value, element) {
    var length = value.length;
    var amount =/^\d+(\.\d\d?)?$/;
     return this.optional(element) || (length <= 10 && amount.test(value));
    }, "金额格式错误");
	//验证红包金额   1-100之间的整数
    jQuery.validator.addMethod("amount", function(value, element) {
    var length = value.length;
    var amount =/^(?:0|[1-9][0-9]?|100)$/;
     return this.optional(element) || (length <= 10 && amount.test(value));
    }, "请填写1-100之间的整数！");
    </script>
  </head>
  
  <body>
  <form name="selectForm" id="selectForm">
  <input id="configureId" type="hidden" name="disConfigure.configureId" value="${disConfigure.configureId}"/>
	<table  width="700px" style="text-align: center;background-color: white;">
		<thead>
		<tr><th>分销配置信息：</th></tr>
		</thead>
		<tr>
			<!-- 消费返利阀值   -->
			<td class="toright_td">消费临界金额：</td>
			<td class="toleft_td"><input type="text" id="rebatePrice" class="{validate:{required:true,amountDecimal:true}}" style="width: 100px;"  name="disConfigure.rebatePrice" value="${disConfigure.rebatePrice}"/></td>
		</tr>
		<tr>
			<td class="toright_td">红包1名称：</td>
			<td class="toleft_td"><input type="text" id="redbag1Name"  style="width: 100px;"  name="disConfigure.redbag1name" value="${disConfigure.redbag1name}"/></td>
			<td class="toright_td">红包1金额：</td>
			<td class="toleft_td"><input type="text" id="redbag1Price"  class="{validate:{amount:true}}" style="width: 100px;"  name="disConfigure.redbag1price" value="${disConfigure.redbag1price}"/></td>
		</tr>
		<tr>
			<td class="toright_td">红包2名称：</td>
			<td class="toleft_td"><input type="text" id="redbag2Name"  style="width: 100px;"  name="disConfigure.redbag2name" value="${disConfigure.redbag2name}"/></td>
			<td class="toright_td">红包2金额：</td>
			<td class="toleft_td"><input type="text" id="redbag2Price"  class="{validate:{amount:true}}" style="width: 100px;"  name="disConfigure.redbag2price" value="${disConfigure.redbag2price}"/></td>
		</tr>
		<tr>
			<td class="toright_td">红包3名称：</td>
			<td class="toleft_td"><input type="text" id="redbag3Name"  style="width: 100px;"  name="disConfigure.redbag3name" value="${disConfigure.redbag3name}"/></td>
			<td class="toright_td">红包3金额：</td>
			<td class="toleft_td"><input type="text" id="redbag3Price"  class="{validate:{amount:true}}" style="width: 100px;"  name="disConfigure.redbag3price" value="${disConfigure.redbag3price}"/></td>
		</tr>
		<tr>
			<td class="toright_td">红包4名称：</td>
			<td class="toleft_td"><input type="text" id="redbag4Name"  style="width: 100px;"  name="disConfigure.redbag4name" value="${disConfigure.redbag4name}"/></td>
			<td class="toright_td">红包4金额：</td>
			<td class="toleft_td"><input type="text" id="redbag4Price"  class="{validate:{amount:true}}" style="width: 100px;"  name="disConfigure.redbag4price" value="${disConfigure.redbag4price}"/></td>
		</tr>
		<tr>
			<td class="toright_td">红包5名称：</td>
			<td class="toleft_td"><input type="text" id="redbag5Name"  style="width: 100px;"  name="disConfigure.redbag5name" value="${disConfigure.redbag5name}"/></td>
			<td class="toright_td">红包5金额：</td>
			<td class="toleft_td"><input type="text" id="redbag5Price"  class="{validate:{amount:true}}" style="width: 100px;"  name="disConfigure.redbag5price" value="${disConfigure.redbag5price}"/></td>
		</tr>
		<tr>
			<td class="toright_td">红包6名称：</td>
			<td class="toleft_td"><input type="text" id="redbag6Name"  style="width: 100px;"  name="disConfigure.redbag6name" value="${disConfigure.redbag6name}"/></td>
			<td class="toright_td">红包6金额：</td>
			<td class="toleft_td"><input type="text" id="redbag6Price"  class="{validate:{amount:true}}" style="width: 100px;"  name="disConfigure.redbag6price" value="${disConfigure.redbag6price}"/></td>
		</tr>
		<tr>
			<td colspan="4">
				<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
					<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
				</div>
			</td>
		</tr>
	</table>
</form>
</body>
</html>
