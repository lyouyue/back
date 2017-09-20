<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员余额提现信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"会员提现记录",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customer/drawing/drawingPageList.action",
				queryParams:{pageSize:pageSize},
				idField:"drawingId",//唯一性标示字段
				frozenColumns:[[//冻结字段
					{field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"drawingCode",title:"提现编号",width:240, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						return "<a style='display:block;cursor: pointer;' id='"+rowData.drawingId+"' onclick='showDetailInfo(this.id);'>"+rowData.drawingCode+"</a>";
					}  },
					{field:"drawingAmount",title:"提现金额(元)",width:240},
					{field:"remarks",title:"备注",width:240},
					{field:"state",title:"状态",width:240,//状态 1、已提交  2、已审核  3、已发放
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						if(value=="1"){ return "<font class='color_002'>已提交</font>";}
						if(value=="2"){ return "<font class='color_003'>已审核</font>";}
						if(value=="3"){ return "<font class='color_001'>已发放</font>";}
					}},
					{field:"createTime",title:"申请时间",width:240},
					{field:"updateTime",title:"发放时间",width:240}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<%
				if("check".equals((String)functionsMap.get(purviewId+"_check"))){
				%>
					{//工具条
					text:"审核",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择审核项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够审核一项！</p>", "warning");
						}else if(rows.length==1){
							if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
								createWindow(800,"auto","&nbsp;&nbsp;会员余额提现审核","icon-tip",false,"passWin");
								$("input.button_save").removeAttr("disabled");
								$("#detailWin").css("display","none");
								$("#passWin").css("display","");
								$("#pdrawingId").val(rows[0].drawingId);//提现记录Id
								$("#saveIsPass").val(rows[0].state);//提现记录状态
								$("#premarks").val(rows[0].remarks);//提现记录备注
								if(rows[0].state==1){//状态 1、已提交  2、已审核  3、已发放
									$("#isPass_1").attr("checked","checked");
								}else if(rows[0].state==2){
									$("#isPass_2").attr("checked","checked");
									$("#isPass_1").attr("disabled","disabled");//设置失效
								}else if(rows[0].state==3){
									$("#isPass_3").attr("checked","checked");
									$("#isPass_1").attr("disabled","disabled");//设置失效
									$("#isPass_2").attr("disabled","disabled");//设置失效
								}
							}
						}
					}
				},"-",
				<%
				}
				%>
				{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});
		function query(){
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,drawingCode:$("#qdrawingCode").val(),startTime:$("#qcreateTime").val(),endTime:$("#qcreateTime2").val(),state:$("#qstate").val()};
			$("#tt").datagrid("load",queryParams);
			pageSplit(pageSize,queryParams);//调用分页函数
		}
		function reset(){
			$("#qdrawingCode").val("");
			$("#qcreateTime").val("");
			$("#qcreateTime2").val("");
			$("#qstate").val("");
		}
		//详情
		function showDetailInfo(id){
			createWindow(900,'auto',"&nbsp;&nbsp;会员余额提现详情","icon-tip",false,"detailWin");
			$("#passWin").css("display","none");
			$("#detailWin").css("display","");
			$.post("${pageContext.request.contextPath}/back/customer/drawing/getDrawingObject.action",{"drawingId":id},function(data){
				if(data != null){
					$("#d_customerName").html(data.customerName);//会员ID
					$("#d_drawingCode").html(data.drawing.drawingCode);//提现编号
					$("#d_phone").html(data.drawing.phone);//联系电话
					$("#d_bankName").html(data.drawing.bankName);//银行名称
					$("#d_bankAddre").html(data.drawing.bankAddre);//银行地址
					$("#d_cardNum").html(data.drawing.cardNum);//卡号
					$("#d_realName").html(data.drawing.realName);//真实姓名
					$("#d_createTime").html(data.drawing.createTime);//申请时间
					if(data.drawing.updateTime!=null){
						$("#d_updateTime").html(data.drawing.updateTime);//发放时间
					}else{
						$("#d_updateTime").html("未发放");//发放时间
					}
					if(data.drawing.updateUserId!=null&&data.drawing.updateUserId!=""){
						$("#d_userName").html(data.userName);//发放人ID
					}else{
						$("#d_userName").html("未发放");//发放人ID
					}
					if(data.drawing.remarks!=null&&data.drawing.remarks!=""){
						$("#d_remarks").html(data.drawing.remarks);//备注
					}else{
						$("#d_remarks").html("无");//备注
					}

					$("#d_drawingAmount").html(data.drawing.drawingAmount);//提现金额
					if(data.drawing.state==1){//状态 1、已提交  2、已审核  3、已发放
						$("#d_state").html("已提交");
					}else if(data.drawing.state==2){
						$("#d_state").html("已审核");
					}else if(data.drawing.state==3){
						$("#d_state").html("已发放");
					}
				}
			},'json');

		}
	</script>
</head>
<body>
<jsp:include page="../../util/item.jsp"/>
  <div class="main">
		<table  class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:75px; ">提现编号：</td>
				<td class="search_toleft_td" style="width: 155px;">
					<input type="text" id="qdrawingCode" name="drawingCode" />
				</td>
				<td class="search_toright_td" style="width:75px;">申请日期：</td>
				<td class="search_toleft_td" style="width:230px;">
					<!-- <input type="text" id="qcreateTime" name="createTime" readonly="readonly" onclick="WdatePicker({maxDate:'#F{$dp.$D(\'qcreateTime2\',{d:-1})||\'2020-10-01\'}',el:'qcreateTime',dateFmt:'yyyy-MM-dd'})" />
					-<input type="text" id="qcreateTime2" name="createTime2" readonly="readonly" onclick="WdatePicker({minDate:'#F{$dp.$D(\'qcreateTime\',{d:1})}',el:'qcreateTime2',dateFmt:'yyyy-MM-dd'})" /> -->
					<input id="qcreateTime" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qcreateTime\')}'})"/>
					- <input id="qcreateTime2" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qcreateTime2\')}'})"/>
				</td>
				<td class="search_toright_td" style="width:65px;">状态 ：</td>
				<td class="search_toleft_td" style="width: 110px;">
					<select id="qstate">
						<option value="-1">--请选择--</option>
						<option value="1">已提交</option>
						<option value="2">已审核</option>
						<option value="3">已发放</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<form id="form1"  method="post"></form>
		<!-- 详情页面 -->
		<jsp:include page="drawingDetail.jsp"/>
		<jsp:include page="isPassDrawing.jsp"/>
		</div>
		</div>
</body>
</html>