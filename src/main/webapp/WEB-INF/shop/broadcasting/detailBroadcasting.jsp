<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/broadcasting/getBroadcastingInfo.action",
			   data: {broadcastingId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dbroadcastingIamgeUrl").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.broadcastingIamgeUrl+"' width='120px' height='120px' />");
				   $("#dtitle").html(data.title);
				   $("#dsynopsis").html(data.synopsis);
				   $("#dinterlinkage").html(data.interlinkage);
				   $("#dsortCode").html(data.sortCode);
				   $("#dshowLocation").val(data.showLocation);
				   if(data.isShow=="0"){
					   $("#disShow").html("不显示");
				   }else if(data.isShow=="1"){
					   $("#disShow").html("显示");
				   }
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="800px;">
    	<tr>
		    <td class="toright_td" width="200px">图片:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dbroadcastingIamgeUrl"></span></td>
	    </tr>
	     <tr>
		      <td class="toright_td">显示位置:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dshowLocation" disabled="disabled">
		              <option value="-1">--请选择--</option>
					  <s:iterator value="#application.keybook['showLocation']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
	    <tr>
	    	<td class="toright_td">主题:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dtitle"></span></td>
	    </tr>
	    <tr>
   	      <td class="toright_td" width="200px" colspan="1">简介:</td>
		      <td  class="toleft_td">
		       <textarea id="dsynopsis" rows="8" cols="48" ></textarea>
		  </td>
		</tr>
<%--		<tr>--%>
<%--			<td class="toright_td">简介:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsynopsis"></span></td>--%>
<%--	    </tr>--%>
	    <tr>
		    <td class="toright_td">链接:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dinterlinkage"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">排序:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td">是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
	    </tr>
    </table>
    <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>