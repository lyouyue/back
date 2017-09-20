<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员等级升迁信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <!-- kindEdite -->
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/themes/default/default.css"/>
		<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css"/>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/kindeditor.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/lang/zh_CN.js"></script>
		<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.js"></script>
		<!-- kindEdite end-->
    <script type="text/javascript">
	$(function(){
		//表单验证
		$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
		function() {
				var id=$('input[name="buyersLevel"]:checked').val();
				var options = {
				url : "${pageContext.request.contextPath}/back/buyersRecord/savaOrUpdateBuyersRecord.action?buyersLevel="+id,
				type : "post",  
				dataType:"json",
					success : function(data) { 
						closeWin();
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload"); //保存后重新加载列表
					}
				};  
				$("#remark").val(KindEditor.instances[0].html());
				$("#form1").ajaxSubmit(options);
				$("input.button_save").attr("disabled","disabled");//防止重复提交
		});
	}
	});	
		   $("#tt").datagrid({//数据表格
				/* title:"买家等级升迁记录",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/buyersRecord/listBuyersRecord.action?customerId=${customerId}",
				idField:"ratingRecordId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"buyersLevel",title:"买家等级",width:80}, 
					{field:"buyerRank",title:"买家头衔",width:80},
					
					{field:"levelIcon",title:"等级图标",width:80,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"'/>";
						}
					},
					/* {field:"minRefValue",title:"最小参考值",width:120},
					{field:"maxRefValue",title:"最大参考值",width:120}, */
					{field:"remark",title:"备注",width:160},
					{field:"operator",title:"操作人",width:50},
					{field:"optionDate",title:"操作时间",width:50},
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					/* text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(800,500,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#id1").val("");
						$(".ke-icon-fullscreen").click();
   						$(".ke-icon-fullscreen").click();
					}
				},"-", {*/
					text:"返回会员等级列表",
					iconCls:"icon-back",
					handler:function(){
						 location.href="${pageContext.request.contextPath}/back/buyersRecord/gotoBRCustomerPage.action";
					}
				},"-",{text:"刷新",
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
			createWindow(700,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/back/buyersRecord/getBuyersRecordObject.action",
				data: {ratingRecordId:id},
				dataType: "JSON",
				success: function(data){
					$("#dratingRecordId").html(data.ratingRecordId);
					$("#dcustomerId").html(data.customerId);
					$("#dbuyersLevel").html(data.buyersLevel);
					$("#dbuyerRank").html(data.buyerRank);
					$("#dlevelIcon").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.levelIcon+"' width='60px' height='50px' />");
					$("#dremark").html(data.remark);
					$("#doptionDate").html(data.optionDate);
					$("#dminRefValue").html(data.minRefValue);
					$("#dmaxRefValue").html(data.maxRefValue);
					$("#doperator").html(data.operator);
					$("#dlineOfCredit").html(data.lineOfCredit);
					$("#dcreditDate").html(data.creditDate);
				}
			});
		}
	
    </script>
  </head>
  
  <body>
    <jsp:include page="../../util/item.jsp"/>
  		 <!-- 查询框  -->
  <div  class="main">
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<%--  <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditBuyersRecord.jsp"/> --%>
		 <%--  <!-- 详情页 -->
		  <jsp:include page="detailBuyersRecord.jsp"/> --%>
		</div>
		</div>
  </body>
</html>
