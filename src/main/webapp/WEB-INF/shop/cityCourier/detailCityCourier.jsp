<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//提交
    	function showDetailInfo(id){
			createWindow(700,'auto',"&nbsp;&nbsp;同城快递详情","icon-tip",false,"detailWin");
			$.ajax({
			   type: "POST", 
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/cityCourier/getCityCourierInfo.action",
			   data: {id:id}, 
			   success: function(data){
				   $("#d_cityCourierName").html(data.cityCourier.cityCourierName);
				   $("#d_responsibleAreas").html(data.district.fullName);
				   $("#d_phone").html(data.cityCourier.phone);
				   $("#d_address").html(data.cityCourier.address);
				   $("#d_cardIdNo").html(data.cityCourier.cardIdNo);
				   $("#d_introducer").html(data.cityCourier.introducer);
				   $("#d_entryTime").html(data.cityCourier.entryTime);
			   }
			});
    	}
    </script>
	  <div id="detailWin">
	  	<table align="center" class="addOrEditTable" width="660px;" >
	   		<tr><td class="toright_td" width="150px">快递员姓名:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_cityCourierName"></span>	</td></tr>
	   		<tr><td class="toright_td" width="150px">责任区域:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_responsibleAreas"></span>	</td></tr>
	   		<tr><td class="toright_td" width="150px">联系电话:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_phone"></span>	</td></tr>
	   		<tr><td class="toright_td" width="150px">联系地址:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_address"></span>	</td></tr>
	   		<tr><td class="toright_td" width="150px">身份证号:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_cardIdNo"></span>	</td></tr>
	   		<tr><td class="toright_td" width="150px">入职时间:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_entryTime"></span>	</td></tr>
	   		<tr><td class="toright_td" width="150px">介绍人:&nbsp;&nbsp;</td><td>&nbsp;&nbsp;<span id="d_introducer"></span>	</td></tr>
	   	</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
	  </div>
