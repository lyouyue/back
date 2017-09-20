<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>等级策略信息</title>
	<jsp:include page="../../util/import.jsp"/>
	<script type="text/javascript">
		$(function(){
		//表单验证
			$("#form1").validate({meta: "validate", 
				submitHandler:function(form){
					var imageUrl=$("#imageUrl1").val();
					if(imageUrl!=null && imageUrl!=''){
					$(document).ready(
						function() {  
							var options = {  
								url : "${pageContext.request.contextPath}/back/buyersStrategy/savaOrUpdateBuyersStrategy.action",  
								type : "post",  
								dataType:"json",
								success : function(data) { 
									closeWin();
									$("#tt").datagrid("clearSelections");//删除后取消所有选项
									$("#tt").datagrid("reload"); //保存后重新加载列表
									$("#buyersLevel").attr("disabled",true);
									$("#levelDiscountValue").attr("disabled",true);
								}
							};
							$("#buyersLevel").removeAttr("disabled");
							$("#levelDiscountValue").removeAttr("disabled");
							$("#form1").ajaxSubmit(options); 
						$("input.button_save").attr("disabled","disabled");//防止重复提交
					});
				}else{
					$("#mymessage1").html("<font color='Red'>请上传图片！</font>");
				}
				}
		    });
			
		   $("#tt").datagrid({//数据表格
				/* title:"会员等级策略",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/buyersStrategy/listBuyersStrategy.action",
				idField:"buyersLevelId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"buyerRank",title:"会员等级",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.buyersLevelId+"' onclick='showDetailInfo(this.id);'>"+rowData.buyerRank+"</a>";  
		         	  }  
					},
					{field:"levelIcon",title:"等级图标",width:80,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='72px' height='15px' />";
						}
					},
					{field:"levelDiscountValue",title:"等级折扣值（%）",width:120},
					{field:"minRefValue",title:"最小参考值（元）",width:120},
					{field:"maxRefValue",title:"最大参考值（元）",width:120}
					
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[//工具条
				<%
				if("add".equals((String)functionsMap.get(purviewId+"_add"))){
				%>     
				{
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						$("#photo1").html("");
						$("#imageUrl1").val("");
						$("#mymessage1").html("");
						$("#fileId1").val("");
						$("#buyersLevelId").val("");
						$("#BLevel_1").show();
						$("#BRank_1").show();
						createWindow(920,'auto',"&nbsp;&nbsp;添加等级策略","icon-add",false,"addOrEditWin");
						$("#buyersLevel").removeAttr("disabled");
						$("#levelDiscountValue").removeAttr("disabled");
					}
				},"-",
				<%
				}
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							$("#fileId1").val("");
							createWindow(920,'auto',"&nbsp;&nbsp;修改等级策略","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/buyersStrategy/getBuyersStrategyObject.action",
							   data: {buyersLevelId:rows[0].buyersLevelId},
							   success: function(data){
								   $("#buyersLevelId").val(data.buyersLevelId);
								   $("#buyersLevel").val(data.buyersLevel);
								   $("#imageUrl1").val(data.levelIcon);
								   $("#buyerRank").val(data.buyerRank);
								   $("#photo1").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.levelIcon+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='72px' height='15px' />");
								   $("#minRefValue").val(data.minRefValue);
								   $("#maxRefValue").val(data.maxRefValue);
								   $("#levelDiscountValue").val(data.levelDiscountValue);
								   $("#lineOfCredit").val(data.lineOfCredit);
								   $("#creditDate").val(data.creditDate);
								   $("#type_"+data.type).attr("checked",true);
								   $("#buyersLevel").attr("disabled",true);
								   $("#levelDiscountValue").attr("disabled",true);
							   }
							});	   
						}
					}
				} ,"-",
				<%
				}
				if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
				%>
				{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].buyersLevelId;
											else ids+=rows[i].buyersLevelId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/buyersStrategy/deleteBuyersStrategy.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
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
				}]
			});
			pageSplit();//调用分页函数
		});
    
		function showDetailInfo(id){
			createWindow(700,'auto',"&nbsp;&nbsp;等级策略详情","icon-tip",false,"detailWin");
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/back/buyersStrategy/getBuyersStrategyObject.action",
				data: {buyersLevelId:id},
				dataType: "JSON",
				success: function(data){
					$("#dbuyersLevelId").html(data.buyersLevelId);
					$("#dbuyerRank").html(data.buyerRank);
					$("#dlevelIcon").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.levelIcon+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'  width='72px' height='15px'/>");
					$("#dlevelDiscountValue").html(data.levelDiscountValue);
					$("#dminRefValue").html(data.minRefValue);
					$("#dmaxRefValue").html(data.maxRefValue);
				}
			});
		}
		
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,buyerRank:$("#qbuyerRank").val()};
	  	$("#tt").datagrid("load",queryParams); 
	  	pageSplit(pageSize,queryParams);//调用分页函数
    }
	function reset(){
		$("#qbuyerRank").val("");
		//$("#qtype").val("");
	}
</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<!-- 查询框  -->
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:85px;">会员等级：</td>
				<td class="search_toleft_td" style="width:115px;">
					<select id="qbuyerRank" name="s_buyerRank" >
						<option value="" >--请选择--</option>
						<s:iterator value="#application.keybook['buyersStrategyLevel']" var="kb">
							<option onclick="checkBuyersLevel();" id="opt_<s:property value="#kb.value"/>" value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
						</s:iterator>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加或者修改 -->
			<jsp:include page="addOrEditBuyersStrategy.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detailBuyersStrategy.jsp"/>
		</div>
	</div>
</body>
</html>
