<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(800,'auto',"&nbsp;&nbsp;套餐规格详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/specification/getSpecificationInfo.action",
			   data: {specificationId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dname").html(data.specification.name);
				   $("#dnotes").html(data.specification.notes);
				   $("#dsort").html(data.specification.sort);
				   $("#dproductTypeId").val(data.specification.productTypeId);
				   if(data.specification.type=="0"){
					  $("#dtype").html("文本"); 
				   }else if(data.specification.type=="1"){
					  $("#dtype").html("图片"); 
				   }
<%--				   $("#dproductTypeName").html(data.productTypeName);//分类的名称--%>
			   <%--var html = "<tr><th>排序号</th><th>规格名称</th><th>规格图片</th></tr>";
				   for(var i=0;i<data.specificationValueList.length;i++){
					   html += "<tr>"
					   html += "<td align='center'>"+data.specificationValueList[i].sort+"</td><td align='center'>"+data.specificationValueList[i].name+"</td><td align='center'><img src=<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.specificationValueList[i].image+" width='50px' height='50px'/></td>"
				   	   html += "</tr>";
				   }--%>
				   var html = "<tr><td align='center' style='font-weight:bold;'>排序号</td><td align='center' style='font-weight:bold;'>规格名称</td></tr>";
				   for(var i=0;i<data.specificationValueList.length;i++){
					   html += "<tr>"
					   html += "<td align='center'>"+data.specificationValueList[i].sort+"</td><td align='center'>"+data.specificationValueList[i].name+"</td>"
				   	   html += "</tr>";
				   }
				$("#ggzv").html(html);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
    	<tr>
	    	<td class="toright_td" >套餐所属分类:</td>
	    	<td class="toleft_td">&nbsp;&nbsp;
	    		<select id="dproductTypeId" disabled="disabled">
					  <s:iterator value="productTypeList">
					  	<option value="<s:property value="productTypeId"/>"><s:property value="sortName"/></option>
					  </s:iterator>
		           </select>
	    	</td>
	    </tr>
	    <tr><td class="toright_td" width="200px">规格名称:</td><td class="toleft_td" width="500px">&nbsp;&nbsp;<span id="dname"></span></td></tr>
	    <tr><td class="toright_td" width="200px">规格备注:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dnotes"></span></td></tr>
	    <tr><td class="toright_td" width="200px">排序:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsort"></span></td></tr>
<%-- 	    <tr><td class="toright_td" width="200px">规格类型:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dtype"></span></td></tr>
 --%>    </table>
    <span><font style="padding-left: 40px;">规格值信息：</font></span>
    <div id="div1">
    	<table id="ggzv" align="center" class="addOrEditTable" style="width: 710px; height: 30px;">
    	</table>
    </div>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>