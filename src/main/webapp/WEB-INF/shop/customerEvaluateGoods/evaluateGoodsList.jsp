<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员评价信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    		$(function(){
    			//修改评价内容和状态
    	   		$("#updateEvaluate").click(function(){
    	   			$("#updateEvaluate").attr("disabled","disabled");
    	   			var evaluateId = $("#eevaluateId").val();
				    var content = $("#econtent").val();
					var evaluateState = $("input[name='eevaluateState']:checked").val();
					$.ajax({
					   type: "POST",
					   dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/evalGoods/updateContentAndEvaluateState.action",
					   data: {id:evaluateId,content:content,evaluateState:evaluateState},
					   success: function(data){
					      if(data.isSuccess=="true"){
					    	  $("#tt").datagrid("reload"); //删除后重新加载列表
					      }else{
					    	  msgShow("系统提示", "<p class='tipInfo'>系统错误，操作失败！</p>", "warning");
					      }
					      closeWin();
					   }
			     });
			});
		   $("#tt").datagrid({//数据表格
				/* title:"会员评价列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/evalGoods/listEvalGoods.action",
				queryParams:{pageSize:pageSize},
				idField:"evaluateId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"ordersNo",title:"订单编号",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        return "<a id='"+rowData.evaluateId+"' onclick='showDetailInfo(this.id);'>"+value+"</a>";;
                         }
					},
					{field:"shopName",title:"机构名称",width:90},
					{field:"logoImg",title:"套餐图片",width:60,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        return "<img align='center' src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.logoImg+"' width='30px' height='30px' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' />";
                         }
					}, 
					{field:"productFullName",title:"套餐名称",width:150},
					{field:"level",title:"评价等级",width:60,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<span class='color_001'>好评</span>";} 
	                        if(value=="0"){ return "<span class='color_003'>中评</span>";} 
	                        if(value=="-1"){return "<span class='color_002'>差评</span>";} 
                         }	
					},
					{field:"evaluateState",title:"评价状态",width:60,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<span class='color_001'>正常显示</span>";} 
	                        if(value=="1"){ return "<span class='color_002'>禁止显示</span>";} 
                         }
					},
					{field:"appraiserName",title:"评价人",width:120},
					{field:"createTime",title:"评价时间",width:120}
				]],
				toolbar:[
				<% 
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
					{//工具条
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							$("#updateEvaluate").removeAttr("disabled");
							createWindow(900,"auto","&nbsp;&nbsp;修改评价信息","icon-tip",false,"addOrEditWin");
							$.ajax({
								   type: "POST",
								   url: "${pageContext.request.contextPath}/back/evalGoods/getEvaluateGoods.action",
								   data: {evaluateId:rows[0].evaluateId},
								   dataType: "JSON",
								   success: function(data){
									   $("#eevaluateId").val(data.evaluateId);
									   $("#eappraiserName").html(data.appraiserName);
									   var level;
									   if(data.level==1){
										   level="<span class='color_001'>好评</span>";
									   }else if(data.level==0){
										   level="<span class='color_002'>中评</span>";
									   }else if(data.level==-1){
										   level="<span class='color_003'>差评</span>";
									   }
									   $("#elevel").html(level);
									   $("#eshopName").html(data.shopName);
									   $("#ecreateTime").html(data.createTime);
									   $("#eordersNo").html(data.ordersNo);
									   $("#eproductFullName").html(data.productFullName);
									   $("#esalesPrice").html(data.salesPrice.toFixed(2));
									   $("#econtent").html(data.content);
									   var evaluateState;
									   if(data.evaluateState==0){
										   evaluateState = "<span class='color_001'>正常显示</span>";
									   }else{
										   evaluateState = "<span class='color_002'>禁止显示</span>";
									   }
									   $("input[name='eevaluateState'][value='"+data.evaluateState+"']").attr('checked','checked');
								   }
							});
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
				}
				],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
			});
			pageSplit(pageSize);//调用分页函数
		});
    	//查询
		 function query(){
    		var orderNo = $("#s_orderNo").val();
    		var appraiserName = $("#s_appraiserName").val();
    		var shopName = $("#s_shopName").val();
    		var level = $("#s_level").val();
    		var evaluateState = $("#s_evaluateState").val();
    		var startDate = $("#startDate").val();
    		var endDate = $("#endDate").val();
			queryParams={orderNo:orderNo,appraiserName:appraiserName,shopName:shopName,level:level,evaluateState:evaluateState,startDate:startDate,endDate:endDate};
			$("#tt").datagrid("load",queryParams); 
			pageSplit(pageSize,queryParams);
	    }
    	
		function reset(){
			$("#s_orderNo").val("");
	       	$("#s_appraiserName").val("");
	    	$("#s_shopName").val("");
	    	$("#startDate").val("");
	    	$("#endDate").val("");
	    	$("#s_level").val("");
	    	$("#s_evaluateState").val("");
		}
</script>
</head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
		<div class="main">
			<table   class="searchTab">
				<tr>
					<td class="search_toright_td"  style="width:80px;"> 订单编号：</td>
					<td class="search_toleft_td" style="width:130px;"><input type="text" id="s_orderNo" name="s_orderNo" style="width:115px"/></td>
					<td class="search_toright_td" style="width: 65px;"> 机构名称：</td>
					<td class="search_toleft_td" style="width: 130px;"><input type="text" id="s_shopName" name="s_shopName" style="width:115px"/></td>
					<td class="search_toright_td" style="width:50px;"> 评价人：</td>
					<td class="search_toleft_td" style="width: 100px;"><input type="text" id="s_appraiserName" name="s_appraiserName" style="width:115px"/></td>
					<td class="search_toright_td" style="width: 70px;"> 评价等级：</td>
					<td class="search_toleft_td" style="width: 100px;">
						<select id="s_level" name="s_level"  class="querySelect">
							<option value="">--请选择--</option>
							<option value="1">好评</option>
							<option value="0">中评</option>
							<option value="-1">差评</option>
						</select>
					</td>
					<td class="search_toright_td" style="width: 70px;"> 评价状态： </td>
					<td class="search_toleft_td" style="width: 100px;">
						<select id="s_evaluateState" name="s_evaluateState" class="querySelect">
							<option value="">--请选择--</option>
							<option value="0">正常显示</option>
							<option value="1">禁止显示</option>
						</select>
					</td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
				
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
			<form id="form1" action=""></form>
			<!-- 详情页 -->
			<jsp:include page="evaluateGoodsDetail.jsp"/>
			<!-- 修改页 -->
			<jsp:include page="editorEvaluateGoods.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>
