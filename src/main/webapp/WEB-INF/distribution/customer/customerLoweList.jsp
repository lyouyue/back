<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
	<title>会员推广信息</title>
	<meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="-1"/>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
	$(function(){
	$("#tt").datagrid({//数据表格
			 title:"<font color='black'>会员推广信息</font> &nbsp;&nbsp;<font color='black'>一级会员总数:</font><font color='red'><s:property value='#request.level1'/></font>,<font color='black'>二级会员总数 :</font><font color='red'><s:property value='#request.level2'/></font>,<font color='black'>三级会员总数 :</font><font color='red'><s:property value='#request.level3'/></font>",
			iconCls:"icon-save", 
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/disCustomer/listLoweCustomer.action?customerId="+${customerId},
			idField:"customerId",//唯一性标示字段
			frozenColumns:[[//冻结字段
				{field:"ck",checkbox:true}
			]],
			columns:[[//未冻结字段
				/* {field:"customerId",title:"会员ID",width:40}, */
				{field:"loginName",title:"会员名称",width:80},
				{field:"wxName",title:"微信昵称",width:80},
				{field:"phone",title:"手机号",width:60},
				{field:"email",title:"电子邮箱",width:80},
				{field:"registerIp",title:"注册IP",width:60},
				{field:"registerDate",title:"注册日期",width:50},
				{field:"money",title:"返利总金额",width:50,
					formatter:function(value,rowData,rowIndex){
						if(value==''||value==null){
							return "<font color='red'>￥0.00</font>";
						}else{
							return "<font color='red'>￥"+value+"</font>";
						}
					}
				}
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号
			singleSelect:true,//true只可以选中一行
			toolbar:[{//工具条
				text:"返回会员列表",
				iconCls:"icon-back",
				handler:function(){
					history.go(-1);
				}
			},"-",{text:"查看分销返利",
				iconCls:"icon-search",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");
					if(rows.length==0){
						msgShow("系统提示", "<p class='tipInfo'>请选择至少一个会员！</p>", "warning");  
					}else{
					var customerId=rows[0].customerId;
					var levelId=$("#qlevelId").val();
					createWindow(750,450,"&nbsp;&nbsp;查看分销返利","icon-search",false,"distributionWin");
					$("#distributionList").datagrid({//数据表格
						width:"auto",
						height:"auto",
						fitColumns: true,//宽度自适应
						align:"center",
						loadMsg:"正在处理，请等待......",
						//nowrap: false,//true是否将数据显示在一行
						striped: true,//true是否把一行条文化
						url:"${pageContext.request.contextPath}/back/disCustomer/getReturnAmount.action?customerId="+customerId+"&levelId="+levelId,
						idField:"customerId",//唯一性标示字段
						frozenColumns:[[//冻结字段
						    {field:"ck",checkbox:true}
						]],
						columns:[[//未冻结字段
						          {field:"loginName",title:"会员名称",width:80},
									{field:"amount",title:"返利金额",width:80,
						        	  formatter:function(value,rowData,rowIndex){
											if(value==''||value==null){
												return "￥0.00";
											}else{
												return "￥"+value;
											}
										}  
									},
									{field:"finalAmount",title:"订单最终支付金额",width:60,
										formatter:function(value,rowData,rowIndex){
											if(value==''||value==null){
												return "￥0.00";
											}else{
												return "￥"+value;
											}
										}
									},
									{field:"ordersNo",title:"订单编号",width:80},
									{field:"transactionTime",title:"交易时间",width:80}
										
						]],
						pagination:true,//显示分页栏
						rownumbers:true,//显示行号   
						singleSelect:false,//true只可以选中一行
					});
					pageSplitThis(null,null,"distributionList");//调用分页函数
					}
				}
			}
			]
		});
		pageSplit(pageSize);//调用分页函数
		});
	//提交1
	function submitForm(){
		$("#form1").submit();
	}
	//提交2
	function submitForm2(){
		$("#form2").submit();
	}

	//冻结状态操作
	function submitForm3(){
		var rows = $("#tt").datagrid("getSelections");
		var customerIds="";
		for(var i=0;i<rows.length;i++){
			customerIds+=rows[i].customerId+",";
		}
		customerIds=customerIds.substring(0, customerIds.lastIndexOf(","));
		var lsCheckValue=$('input[name="clockedState"]:checked').val();
		$.post("${pageContext.request.contextPath}/back/customer/changeLockedState.action",{params:lsCheckValue,customerIds:customerIds},function(data){
			if(data.isSuccess==true){
				 closeWin();
	 $("#tt").datagrid("clearSelections");
					 $("#tt").datagrid("reload");
			}
		},'json');
	}


	//详情
		function showDetailInfo(id){
			createWindow(900,'450',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
			$("#congeal").css("display","none");
			$("#lineOfCreditWin").css("display","none");
			$("#detailFansWin").css("display","none");
			$("#invoiceInfolWin").css("display","none");
			$("#rechargeWin").css("display","none");
			$("#detailWin").css("display","");
			$.post("${pageContext.request.contextPath}/back/customer/getCustomerObject.action",{"customerId":id},function(data){
				if(data != null){
					var s=data.shopCustomerInfo;
					var c=data.customer;
					var b=data.customerBankroll;
					$("#dd_registerIp").html(c.registerIp);
					$("#d_loginName").html(c.loginName);
					$("#d_customerId").html(c.customerId);
					$("#d_balance").html(b.balance+"元");
					$("#d_photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+c.photoUrl+"' width='120px' height='120px' />");
					<s:iterator value="#application.keybook['sex']" var="kb">
						if(s.sex==<s:property value="#kb.value"/>){
								$("#d_sex").html("<s:property value='#kb.name'/>");
						}
					</s:iterator>
					$("#dd_birthday").html(data.format);
//					$("#d_trueName").html(s.trueName);
					$("#d_phone").html(data.customer.phone);
					$("#d_userEmail").html(data.customer.email);
					$("#d_note").val(s.notes);
//					if(data.buyersRecord.lineOfCredit!=null&&data.buyersRecord.lineOfCredit!=""){
//						$("#d_lineOfCredit").html(formatCurrency(data.buyersRecord.lineOfCredit));
//					}else{
//						$("#d_lineOfCredit").html("无");
//					}
					if(data.customer.lockedState==0){
						$("#d_lockedState").html("未冻结");
					}else{
						$("#d_lockedState").html("已冻结");
					}
				}
			},'json');

	}

		//微信粉丝详情
		function showWxDetailInfo(id){
			createWindow(900,400,"&nbsp;&nbsp;粉丝详情","icon-tip",false,"detailFansWin");
			$("#congeal").css("display","none");
			$("#lineOfCreditWin").css("display","none");
			$("#detailFansWin").css("display","none");
			$("#invoiceInfolWin").css("display","none");
			$("#rechargeWin").css("display","none");
			$("#detailWin").css("display","none");
			$("#detailFansWin").css("display","");
			$.ajax({
				 type: "POST",
				url: "${pageContext.request.contextPath}/back/customer/getFansUserInfoObject.action",
				data: {customerId:id},
				dataType: "JSON",
				success: function(data){
					$("#d_customerId").html(data.customerId);
					$("#d_openid").html(data.userOpenId);
					$("#d_oginName").html(data.oginName);
					$("#d_nickname").html(data.nickName);
						<s:iterator value="#request.fansGroupListaa" var="kb">
							if("<s:property value='#kb.id'/>"==data.fansGroupId){
								$("#d_fansGroupId").html(<s:property value='#kb.name'/>);
							}
					 </s:iterator>
					if(data.subscribe=="0"){
						$("#d_subscribe").html("否");
					}else{
						$("#d_subscribe").html("是");
					}
					if(data.bindingFlag=="0"){
						$("#d_bindingFlag").html("否");
					}else{
						$("#d_bindingFlag").html("是");
					}
					if(data.sex=="2"){
						$("#d_sex").html("女");
					}else if(data.sex=="1"){
						$("#d_sex").html("男");
					}
					$("#d_country").html(data.userCountry);
					$("#d_province").html(data.userProvince);
					$("#d_city").html(data.userCity);
					$("#d_language").html(data.userLanguage);
					$("#d_userSignature").html(data.userSignature);
					$("#d_subscribeTime").html(formatTimeConvert(data.subscribe_time));
					$("#d_unionid").html(data.unionid);
					if(data.plateformRemark==""||data.plateformRemark==null){
						$("#d_plateformRemark").html("/");
					}else{
						$("#d_plateformRemark").html(data.plateformRemark);
					}
					if(data.latitude!=""){
						$("#d_latitude").html(data.latitude);
					}else{
						$("#d_latitude").html("/");
					}
					if(data.longitude!=""){
						$("#d_longitude").html(data.longitude);
					}else{
						$("#d_longitude").html("/");
					}
					if(data.locationPrecision!=""){
						$("#d_precision").html(data.locationPrecision);
					}else{
						$("#d_precision").html("/");
					}
					if(data.remark!=""){
						$("#d_remark").html(data.remark);
					}else{
						$("#d_remark").html("/");
					}
				}
				});
		}
		/* function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,loginName:$("#qloginName").val(),registerDate:$("#qregisterDate").val(),lockedState:$("#qlockedState").val(),registerDate2:$("#qregisterDate2").val(),email:$("#qemail").val(),phone:$("#qphone").val(),wxUserOpenId:$("#qwxUserOpenId").val()};
			$("#tt").datagrid("load",queryParams);
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		
		function reset(){
			$("#qloginName").val("");
			$("#qemail").val("");
			$("#qphone").val("");
			$("#qregisterDate").val("");
			$("#qregisterDate2").val("");
			$("#qlockedState").val("");
			$("#qwxUserOpenId").val("");
		} */
		/**
		 * 将数值四舍五入(保留2位小数)后格式化成金额形式
		 *
		 * @param num 数值(Number或者String)
		 * @return 金额格式的字符串,如'1,234,567.45'
		 * @type String
		 */
		function formatCurrency(num) {
			num = num.toString().replace(/\$|\,/g,'');
			if(isNaN(num))
			num = "0";
			sign = (num == (num = Math.abs(num)));
			num = Math.floor(num*100+0.50000000001);
			cents = num%100;
			num = Math.floor(num/100).toString();
			if(cents<10)
			cents = "0" + cents;
			for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
			num = num.substring(0,num.length-(4*i+3))+','+
			num.substring(num.length-(4*i+3));
			return (((sign)?'':'-') + num + '.' + cents);
		}
		function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,levelId:$("#qlevelId").val(),loginName:$("#qloginName").val(),wxName:$("#qWxName").val()};
		  	$("#tt").datagrid("load",queryParams); 
		  	pageSplit(pageSize,queryParams);//调用分页函数
	    }
		function reset(){
			$("#qloginName").val("");
			$("#qWxName").val("");
			$("#qlevelId").val("");
		}
	</script>
</head>
<body>
<jsp:include page="../../util/item.jsp"/>

	<form id="formShopPar" action="${pageContext.request.contextPath}/back/shopCustomerService/gotoShopCustomerServicePage.action" method="post">
	<input id="shopName"  type="hidden" name="shopName"/>
	<input id="ids"  type="hidden" name="ids"/>
	</form>
	  <div class="main">
	  <table class="searchTab">
				<tr>
					<td class="search_toright_td" style="width:85px;">会员名称：</td>
					<td class="search_toleft_td" style="width:140px;"><input type="text" id="qloginName"  name="loginName"/></td>
					<td class="search_toright_td" style="width:80px;">微信昵称：</td>
					<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qWxName" name="wxName"/></td>
					<td class="search_toleft_td" style="width:80px;">
					<select id="qlevelId" class="querySelect">
		              <option value="0">一级</option>
		              <option value="1">二级</option>
		              <option value="3">三级</option>
		            </select></td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
			</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<form id="form1"></form>
		  <jsp:include page="distributionReturnList.jsp"/> 
	  </div>
	  </div>
  </body>
</html>
