<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>区域订单统计信息</title>
    <meta http-equiv="Cache-Control" content="no-cache"/>
  	<meta http-equiv="Expires" content="-1"/>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
    	$("#tt").datagrid({//数据表格
			/* title:"区域订单统计信息",
			iconCls:"icon-save", */ 
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/areaOrdersCount/areaOrdersCountList.action", 
			idField:"ordersId",//唯一性标示字段
			/* frozenColumns:[[//冻结字段
			    {field:"ck",checkbox:false}
			]], */
			columns:[[//未冻结字段
	            {field:"fullName",title:"区域名称",width:80},
	            {field:"count",title:"订单数量",width:80},
	            {field:"sum",title:"订单总金额",width:80}
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号   
			singleSelect:true,//true只可以选中一行
			toolbar:[//工具条
	         <%
			 if("export".equals((String)functionsMap.get(purviewId+"_export"))){
			 %>    
			{
	 			text:"导出报表",
	 			iconCls:"icon-redo",
	 			handler:function(){
	 				window.location.href="${pageContext.request.contextPath}/back/areaOrdersCount/exportCountModFuleExcel.action?createTime="+$("#qcreateTime").val()+"&createTime2="+$("#qcreateTime2").val()+"&regionLocation="+$("#firstArea").val()+"&city="+$("#secondArea").val()+"&country="+$("#threeArea").val();
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
			}],
		});
		pageSplit(pageSize);//调用分页函数
	});
 	 	function query(){
 	  	  	queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,regionLocation:$("#firstArea").val(),city:$("#secondArea").val(),country:$("#threeArea").val(),createTime:$("#qcreateTime").val(),createTime2:$("#qcreateTime2").val()};
 	  	  	$("#tt").datagrid("load",queryParams); 
 	  	  	pageSplit(pageSize,queryParams);//调用分页函数
       	}

		function reset(){
			$("#firstArea").val("");
	       	$("#secondArea").val("");
	    	$("#threeArea").val("");
	    	$("#qcreateTime").val("");
	    	$("#qcreateTime2").val("");
		}
 	 	function chengeArea(id,level,selectId){
 	 		$.ajax({
 	 	  			url:"${pageContext.request.contextPath}/back/areaOrdersCount/findAreaList.action",
 	 	  			type:"post",
 	 	  			dataType:"json",
 	 	  			data:{areaId:id},
 	 	  			success:function(data){
 	 	  				if(data!=""&&data!=null){
 	 	  					var areaList=data;
 	 	  					var htmlOption="<option value=''>--请选择--</option>";
 	 							for(var i=0;i<areaList.length;i++){
 	 								htmlOption+="<option value='" + areaList[i].areaId+"'id='" + areaList[i].areaId+"'>" + areaList[i].name+ "</option>";
 	 							}
 	 							//console.log(htmlOption);
 	 	  					if(level==1){
 	 	  						$("#secondArea").html(htmlOption);
 	 	  						$("#secondArea").val(selectId);
 	 							$("#threeArea").html("<option value=''>--请选择--</option>");
 	 	  					} else if(level==2){
 	 	  						$("#threeArea").html("");
 	 	  						$("#threeArea").append(htmlOption);
 	 	  						$("#threeArea").val(selectId);
 	 	  					} else if(level==3){
 	 	  						$("#threeArea").html("");
 	 	  						$("#threeArea").append(htmlOption);
 	 	  						$("#threeArea").val(selectId);
 	 	  					}
 	 	  				}
 	 	  				var firstArea=$("#firstArea").val();
 	 	  				if(firstArea==null||firstArea==""){
 	 	  					$("#secondArea").html("<option value=''>--请选择--</option>");
 	 	  					$("#threeArea").html("<option value=''>--请选择--</option>");
 	 	  				}
 	 	  				var secondArea=$("#secondArea").val();
	 	  				if(secondArea==null||secondArea==""){
	 	  					$("#threeArea").html("<option value=''>--请选择--</option>");
	 	  				}
 	 	  			}
 	 			});
 	 	}
 	 //选择地区进行赋值
 	 	function setValue(id){
 	 		var areaValue = $("#"+id).val();
 	 		var areaArr = areaValue.split("@");
 	 		$("#areaId").val(areaArr[0]);//区域ID
 	 		$("#areaName").val(areaArr[1]);//区域名称
 	 	}
	</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
	<div class="main">
		<form id="formShopPar" action="${pageContext.request.contextPath}/back/shopCustomerService/gotoShopCustomerServicePage.action" method="post">
			<input id="shopName"  type="hidden" name="shopName"/>
			<input id="ids"  type="hidden" name="ids"/>
		</form>
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:75px;">所在地区：</td>
				<td class="search_toleft_td" style="width: 355px;">
					&nbsp;&nbsp;<select style=" padding:1px 1px 1px 1px;" name="regionLocation" id="firstArea" onchange="chengeArea(this.value,'1','')" class="{validate:{required:true}} querySelect;">
						<option value="">--请选择--</option>
						<s:iterator value="firstAreaList" var="first" >
							<option value="<s:property value="#first.aid"/>" id="<s:property value="#first.aid"/>"><s:property value="#first.name"/></option>
						</s:iterator>
					</select>
					<select style="padding:1px 1px 1px 1px;" name="city" id="secondArea" onchange="chengeArea(this.value,'2','')" class="{validate:{required:true}} querySelect">
							<option value="" >--请选择--</option>
					</select>
					<select style="padding:1px 1px 1px 1px;" name="country" id="threeArea" onchange="chengeArea(this.value,'3','')" class="{validate:{required:true}} querySelect">
							<option value="" >--请选择--</option>
					</select>
				</td>
				<td class="search_toright_td" style="width:80px;">交易时间：</td>
				<td class="search_toleft_td" style="width: 300px;">
					<input id="qcreateTime" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qcreateTime2\')}'})"/>
					- <input id="qcreateTime2" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qcreateTime\')}'})"/>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<form id="form1"></form>
			</div>
		</div>
	</body>
</html>
