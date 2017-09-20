<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript">
/*******************更改为发货开始******************************/
function sendGoods(){
	$("#sendGoodsForm").validate({meta: "validate",
		submitHandler:function(form){
			var logisticsType=$("#logisticsType").val();
			var deliverySn=$("#deliverySn").val();
			var district=$("#district").val();
			$("#codeError").val("");
			$("#cityCourierError").val("");
			if(logisticsType==1){
				var code = $("#code").combogrid('getValue');
				if(code[0]==null||code[0]==""){
					$("#codeError").html("<font color='red'>不可为空</font>");
					return false;
				}
			}else{
				var cityCourier = $("#cityCourier").combogrid('getValue');
				if(cityCourier[0]==null||cityCourier[0]==""){
					$("#cityCourierError").html("<font color='red'>不可为空</font>");
					return false;
				}
			}
			var ropts ={
				url : "${pageContext.request.contextPath}/back/orders/changeShipments.action",
				type : "post",
				dataType:"json",
				success : function(data) {
					if(data.isSuccess){
						msgShow("系统提示", "<p class='tipInfo'>设置发货成功！</p>", "warning");
						$("#tt").datagrid("reload");
						closeWin();
					}else{
						msgShow("系统提示", "<p class='tipInfo'>设置发货失败！</p>", "warning");
					}
				}
			};
			$("#sendGoodsForm").ajaxSubmit(ropts);
		}
	});
	$("#sendGoodsForm").submit();
}
//更改为发货
function changeSend(ordersId,type){
	if(type==1){
		$("#type1").css("display","");
		$("#type2").css("display","none");
	}else if(type==2){
		$("#type1").css("display","none");
		$("#type2").css("display","");
	}
	$("#type2_1").css("display","none");
	$("#detailWin2").css("display","none");
	$("#view_Order_Products").css("display","none");
	$("#sendGoodsWin").css("display","");
	$("#detailWin").css("display","none");
	/**清空同城物流table信息 **/
	$("#province").val("");
	$("#cities").val("");
	$("#district").val("");
	$("#cityCourier").val("");
	/**清空同城物流table信息 **/
	/**清空物流公司table信息 **/
	$("#deliverySn").val("");
	$(".combo-text").val("");
	/**清空物流公司table信息 **/
	$("#codeError").val("");
	$("#cityCourierError").val("");
	createWindow(800,"auto","&nbsp;&nbsp;设置订单发货","icon-edit",false,"sendGoodsWin",10);
	$("#ordersId").val(ordersId);
	$("#logisticsType").val(type);
}
//选择快递公司的同时，回填网址信息
var urlInfo=function(){
	//获取select控件的指
	var svalue=$("#sdeliveryCorpName").val();
	//与数据字典中快递公司list做比较
	<s:iterator value="#application.keybook['expressCompany']" var="kb">
		if(svalue=="<s:property value='#kb.name'/>"){
			$("#deliveryUrl").val("<s:property value='#kb.value'/>");
		}
	</s:iterator>
};

$(function(){
	//初始化物流公司信息
	$("#code").combogrid({
		idField:"code",
		textField:"deliveryCorpName",
		rownumbers:true,//序号
		width:300,
		url:"${pageContext.request.contextPath}/back/logistics/initLogistics.action",
		columns:[[
			{field:"deliveryCorpName",title:"物流公司名称",width:80},
			{field:"deliveryUrl",title:"物流公司网址",width:150}
		]]
	});
});

//异步验证是否有输入的快递公司
function changeShipments(){
	var codeValue=$("input[name='shipping.code']").val();
	$.ajax({
		type: "POST",
		dataType: "JSON",
		url:"${pageContext.request.contextPath}/back/orders/checkShipments.action",
		data: {code:codeValue},
		async:false,//false同步;true异步
		success: function(data){
			if(data.isHave==true){
				//单击提交表单
				$("#shipmentsButton").trigger("click");
			}else{
				lalert("提醒","没有该物流公司的信息！");
			}
		}
	});
}

//同城快递地址
function chengeArea(id,level){
	if(level==3){
		var province=$("#province").val();
		var city=$("#cities").val();
		var district=$("#district").val();
		var responsibleAreas=province+","+city+","+district;
		//初始化同城快递信息
		$("#cityCourier").combogrid({
			idField:"cityCourierId",
			textField:"cityCourierName",
			rownumbers:true,//序号
			width:380,
			url:"${pageContext.request.contextPath}/back/logistics/initCityCourier.action",
			queryParams :{id : responsibleAreas},
			columns:[[
				{field:"cityCourierName",title:"快递员姓名",width:80},
				{field:"responsibleAreas",title:"负责区域",width:150},
				{field:"phone",title:"联系电话",width:100}
			]]
		});
		$('#type2_1').css("display","");
	}else{
		$.ajax({
			url:"${pageContext.request.contextPath}/back/orders/findCityList.action",
			type:"post",
			dataType:"json",
			data:{areaId:id},
			success:function(data){
				if(data!=""){
					var areaList=data;
					var htmlOption="<option value='0'>--请选择--</option>";
					for(var i=0;i<areaList.length;i++){
						htmlOption+="<option  value='" + areaList[i].areaId+"'>" + areaList[i].name+ "</option>";
					}
					if(level==1){
						$("#cities").html(htmlOption);
					}if(level==2){
						$("#district").html(htmlOption);
					}
				}
			}
		});
	}
}
/*******************更改为发货结束******************************/
</script>
<div id="sendGoodsWin" >
	<form id="sendGoodsForm" method="post" action="">
		<input type="hidden" id="ordersId" name="orders.ordersId" value=""/>
		<input type="hidden" id="logisticsType" name="logisticsType" value=""/>
		<table id="type1" align="center" class="addOrEditTable">
			<tr class="titlebg" style="text-align: center;">
				<td colspan="4">物流公司配送信息</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">物流单号:</td>
				<td>
					<input style="width:295px;height:20px;line-height:20px;" id="deliverySn" type="text" name="shipping.deliverySn" value="" class="{validate:{required:true,onlyCharAndNumber:true,maxlength:[20]}}"/>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">物流公司名称:</td>
				<td>
				<select id="code" name="shipping.code" class="{validate:{required:true}} select_zx" ></select>
				<span id="codeError" style=""></span>
				</td>
			</tr>
		</table>
		<table id="type2" align="center" class="addOrEditTable">
			<tr class="titlebg" style="text-align: center;">
				<td colspan="4">同城快递配送信息</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">区域:</td>
				<td style="width:360px;">
					<select id="province" onchange="chengeArea(this.value,'1')" class="{validate:{required:true}} select_zx">
						<option value="">省</option>
						<s:iterator value="provinceList" var="first">
							<option  value="<s:property value="#first.areaId"/>"><s:property value="#first.name"/></option>
						</s:iterator>
					</select>
					<select id="cities" onchange="chengeArea(this.value,'2')" class="{validate:{required:true}} select_zx">
						<option value="">地级市</option>
					</select>
					<select id="district" onchange="chengeArea(this.value,'3')" class="{validate:{required:true}} select_zx">
						<option value="">区(县)</option>
					</select>
				</td>
			</tr>
			<tr id="type2_1">
				<td class="toright_td" width="150px">快递信息:</td>
				<td>
				<select id="cityCourier" name="cityCourier.cityCourierId" class="{validate:{required:true}}"></select><span id="cityCourierError"></span>
				</td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="sendGoods()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>
