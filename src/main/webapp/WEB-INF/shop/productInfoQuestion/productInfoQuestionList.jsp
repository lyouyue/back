<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>机构套餐答疑信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"套餐答疑列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/productInfoQuestion/listProductInfoQuestion.action",
				queryParams:{pageSize:pageSize},
				idField:"productInfoQuestionId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerName",title:"会员名称",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.productInfoQuestionId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerName+"</a>";  
		         	  }  
					}, 
		            {field:"productName",title:"套餐名称",width:120/* ,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.productId+"' onclick='showProductDetail(this.id);'>"+rowData.productName+"</a>";  
		         	  }   */
					}, 
					{field:"shopName",title:"机构名称",width:120},
					{field:"askType",title:"咨询类型",width:100,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							<s:iterator value="#application.keybook['askType']" var="kb">
							if(rowData.askType==<s:property value='#kb.value'/>){
								return "<s:property value='#kb.name'/>"
							}
							</s:iterator>
			         	  } 
					},
	              	{field:"answerName",title:"审核人名称",width:100},
	              	{field:"status",title:"审核状态",width:100, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value=="1"){return "<font class='color_002'>未通过</font>";}
							else if(value=="2"){return "<font class='color_001'>已通过</font>";}
							else if(value=="3"){return "<font class='color_003'>待审核</font>";}
						}
					},
					{field:"askTime",title:"咨询时间",width:100}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{//工具条
					text:"审核",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections"); //找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
						}else if(rows.length==1){
							var id = rows[0].productInfoQuestionId;
							createWindow(800,"auto","&nbsp;&nbsp;审核套餐答疑","icon-tip",false,"addOrEditWin");
							$("#addOrEditWin").css("display","");
							$("#productDetailWin").css("display","none");
							$("#detailWin").css("display","none");
							$.ajax({
								type: "POST", dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/productInfoQuestion/getProductInfoQuestionInfo.action",
								data: {ids:id},
								success: function(data){
									$("#productInfoQuestionId").val(data.productInfoQuestionId);
									$("#productId").val(data.productId);
									$("#productName").val(data.productName);
									$("#customerId").val(data.customerId);
									$("#customerName").val(data.customerName);
									$("#askType").val(data.askType);
									$("#askQuestion").val(data.askQuestion);
									$("#askTime").val(data.askTime);
									$("#answerId").val(data.answerId);
									$("#answer").val(data.answer);
									$("#status_"+data.status).attr("checked",true);
									$("#userId").val(data.userId);
									$("#updateTime").val(data.updateTime);
									$("#shopStatus").val(data.shopStatus);
									$("#aproductName").html(data.productName);
									$("#acustomerName").html(data.customerName);
									<s:iterator value="#application.keybook['askType']" var="kb">
									if(data.askType==<s:property value='#kb.value'/>){
										$("#aaskType").html("<s:property value='#kb.name'/>");
									}
									</s:iterator>
									$("#aaskQuestion").html(data.askQuestion);
									if(data.shopStatus==1){
										$("#ashopStatus").html("未通过审核");
									}else if(data.shopStatus==2){
										$("#ashopStatus").html("通过审核");
									}else if(data.shopStatus==3){
										$("#ashopStatus").html("待审核");
									}
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
				]
			});
			pageSplit(pageSize);//调用分页函数
		});
    	function query(){
	  	  	queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,customerName:$("#qcustomerName").val(),status:$("#qstatus").val(),askType:$("#qaskType").val(),beginTime:$("#q_beginTime").val(),endTime:$("#q_endTime").val()};
	  	  	$("#tt").datagrid("load",queryParams); 
	  	  	pageSplit(pageSize,queryParams);//调用分页函数
      	}
    	function reset(){
    		$("#qcustomerName").val("");
           	$("#q_beginTime").val("");
        	$("#q_endTime").val("");
        	$("#qaskType").val("");
        	$("#qstatus").val("");
    	}
    </script>
  </head>
  
  <body>
  <jsp:include page="../../util/item.jsp"/>
  <div class="main">
	   <table class="searchTab">
			<tr>
				<td class="search_toright_td"  style="width:85px;">会员名称：</td>
				<td class="search_toleft_td" style="width:150px;"><input type="text" style="width:130px;" id="qcustomerName" name="qcustomerName" class="searchTabinput"/>&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width:65px;">咨询时间：</td>
				<td class="search_toleft_td" style="width:265px;">
					<input id="q_beginTime" class="Wdate" readonly="readonly" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'q_endTime\'||\'2050-10-01\')}'})"/>
					-<input id="q_endTime" class="Wdate" readonly="readonly" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'q_beginTime\')}',maxDate:'2050-10-01'})"/>     
				</td>
	    		<td class="search_toright_td" style="width:60px;">咨询类型：</td>
				<td class="search_toleft_td" style="width: 100px;">
					<select id="qaskType" class="querySelect">
						<option value="-1">--请选择--</option>
						<s:iterator value="#application.keybook['askType']" var="kb">
							<option value="<s:property value='#kb.value'/>"><s:property value='#kb.name'/></option>
						</s:iterator>
					</select>
				</td>
	    		<td class="search_toright_td" style="width:60px;">审核状态：</td>
	    		<td class="search_toleft_td" style="width: 100px;"><select id="qstatus" class="querySelect">
		              <option value="-1">--请选择--</option>
		              <option value="1">未通过</option>
		              <option value="2">已通过</option>
		              <option value="3">待审核</option>
		            </select></td>
	    	<td class="search_toleft_td">
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
				<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
	    	</td>
	    	</tr>
	    </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		   <!-- 套餐详情页 -->
		  <jsp:include page="productDetail.jsp"/>
		</div>
	<!--  -->	
	</div>
  </body>
</html>
