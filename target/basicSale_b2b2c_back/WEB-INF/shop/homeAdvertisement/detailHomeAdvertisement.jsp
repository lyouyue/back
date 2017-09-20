<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,470,"&nbsp;&nbsp;首页广告位详情","icon-tip",false,"detailWin",20);
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/homeAdvertisement/getHomeAdvertisementObject.action",
			   data: {advertisementId:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#dimageUrl").html("<img style='padding-top:10px'  src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.imageUrl+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='200px' height='100px' />");
				   $("#dtitle").html(data.title);
				   $("#dlink").html(data.link);
				   $("#dsortCode").html(data.sortCode);
				   //$("#dshowLocation").val(data.showLocation);
				   if(data.isShow=="0"){
					   $("#disShow").html("<font class='color_002'>不显示</font>");
				   }else if(data.isShow=="1"){
					   $("#disShow").html("<font class='color_001'>显示</font>");
				   }
				   if(data.showLocation=="1"){
					   $("#dshowLocation").html("首页");
				   }
				   <s:iterator value="#application.homekeybook['advertisemenLocation']" var="hkb">
				   		if(data.showLocation==<s:property value="#hkb.value" />){
				   			$("#dshowLocation").html("<s:property value='#hkb.name' />");
				   		}
				   </s:iterator>
				   $("#dsynopsis").html(data.synopsis);
				   $("#dcreateTime").html(data.createTime);
				   $("#dpublishUser").html(data.publishUser);
				   $("#dupdateTime").html(data.updateTime);
				   $("#dmodifyUser").html(data.modifyUser);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="800px;">
    	<tr>
		    <td class="toright_td" width="150px">图片:</td><td  class="toleft_td"  colspan="3">&nbsp;&nbsp;<span id="dimageUrl"></span></td>
	    </tr>
<%-- 	     <tr>
		      <td class="toright_td">显示位置:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="dshowLocation" disabled="disabled">
		              <option value="-1">--请选择--</option>
					  <s:iterator value="#application.keybook['showLocation']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr> --%>
	    <tr>
	    	<td class="toright_td" width="150px">主题:</td><td class="toleft_td"   colspan="3">&nbsp;&nbsp;<span id="dtitle"></span></td>
	    </tr>
	    <tr>
   	      <td class="toright_td" width="150px">简介:</td><td  class="toleft_td"  colspan="3">&nbsp;&nbsp;<span id="dsynopsis"></span></td>
		</tr>
	    <tr>
		    <td class="toright_td" width="150px">链接:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dlink"></span></td>
		    <td class="toright_td" width="150px">排序:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="150px">是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
		    <td class="toright_td" width="150px">显示位置:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dshowLocation"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="150px">创建时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td>
		    <td class="toright_td" width="150px">创建人:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dpublishUser"></span></td>
	    </tr>
	    <tr>
		    <td class="toright_td" width="150px">修改时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dupdateTime"></span></td>
		    <td class="toright_td" width="150px">修改人:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dmodifyUser"></span></td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>