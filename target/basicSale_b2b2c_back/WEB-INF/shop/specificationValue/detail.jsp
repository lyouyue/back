<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(800,'auto',"&nbsp;&nbsp;商品规格值详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/specificationValue/getSpecificationValueInfo.action",
			   data: {specificationValueId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dspecificationId").val(data.specificationId);
				   $("#dname").html(data.name);
				   $("#dsort").html(data.sort);
				   $("#dtypeName").html(data.typeName);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="500px;">
	    <%-- <tr>
		      <td class="toright_td" width="200px">商品规格:</td>
		      <td class="toleft_td">
		           <select id="dspecificationId" disabled="disabled">
					  <s:iterator value="#request.specificationList">
					  	<option value="<s:property value="specificationId"/>"><s:property value="name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr> --%>
	    <tr><td class="toright_td" width="200px">名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dname"></span></td></tr>
	    <tr><td class="toright_td" width="200px">排序号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsort"></span></td></tr>
	    <%--<tr>
		    <td class="toright_td" width="200px">图片:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dimage"></span></td>
	    </tr> --%>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>