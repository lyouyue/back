<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>店铺申请结算信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    	$(function(){
    		//审核店铺结算
			$("#updateReview").click(function(){
				$("input.button_save").attr("disabled","disabled");
			    var id = $("#settlementId").val();
			    var reviewStatus = $("input[name='shopSettlementDetail.reviewStatus']:checked").val();
				$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/settlement/updateReviewStatus.action",
				   data: {id:id,reviewStatus:reviewStatus},
				   success: function(data){
				      if(data.isSuccess=="true"){
				    	  $("#tt").datagrid("reload"); //删除后重新加载列表
				      }
				      closeWin();
				   }
		        });
				
			});
		   $("#tt").datagrid({//数据表格
				title:"店铺申请结算列表",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/settlement/listShopSettlementDetail.action",
				idField:"settlementId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"shopName",title:"店铺名称",width:120}, 
					{field:"loginName",title:"会员帐号",width:120},
					{field:"trueName",title:"会员真实姓名",width:120},
					{field:"settlementMonth",title:"申请月份",width:80},
					{field:"cycle",title:"申请周期",width:60,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="3"){ return "一整月";} 
	                        if(value=="1"){ return "上半月";}
	                        if(value=="2"){ return "下半月";} 
                         }	
					},
					{field:"totalCost",title:"申请周期内销售套餐总成本",width:150,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        return "￥"+value;
                        }
					},
					{field:"totalSales",title:"申请周期内总销售额",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        return "￥"+value;
                        }
					},
					{field:"createDate",title:"申请时间",width:120},
					{field:"reviewStatus",title:"审核状态",width:60,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font color='green'>已审核</font>";} 
	                        if(value=="0"){ return "<font color='red'>未审核</font>";} 
                         }	
					},
					{field:"reviewer",title:"审核人",width:80}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<% 
				if("audit".equals((String)functionsMap.get(purviewId+"_audit"))){
				%>
					{
					text:"审核",
					iconCls:"icon-tip",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择审核项！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>一次只能够审核一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(1000,450,"&nbsp;&nbsp;审核","icon-tip",false,"detailWin");
							$.ajax({
							   type: "POST",
							   url: "${pageContext.request.contextPath}/back/settlement/getShopSettlementDetailObject.action",
							   data: {id:rows[0].settlementId},
							   dataType: "JSON",
							   success: function(data){
								   $("input.button_save").removeAttr("disabled");
								   $("#settlementId").val(data.shopSettlementDetail.settlementId);
								   $("#view_shopName").html(data.shopSettlementDetail.shopName);
								   $("#view_loginName").html(data.shopSettlementDetail.loginName);
								   $("#view_trueName").html(data.shopSettlementDetail.trueName);
								   $("#view_settlementMonth").html(data.shopSettlementDetail.settlementMonth);
								   if(data.shopSettlementDetail.cycle==3){
									   $("#view_cycle").html("一整月");
								   }
								   if(data.shopSettlementDetail.cycle==1){
									   $("#view_cycle").html("上半月");
								   }
								   if(data.shopSettlementDetail.cycle==2){
									   $("#view_cycle").html("下半月");
								   }
								   $("#view_totalCost").html("￥"+data.shopSettlementDetail.totalCost);
								   $("#view_totalSales").html("￥"+data.shopSettlementDetail.totalSales);
								   $("#view_createDate").html(data.shopSettlementDetail.createDate);
								   if(data.shopSettlementDetail.reviewStatus==1){
									   $("input[name='shopSettlementDetail.reviewStatus']").attr('disabled','disabled');
									   $("#updateReview").attr('disabled','disabled');
								   }else{
									   $("input[name='shopSettlementDetail.reviewStatus']").removeAttr('disabled');
									   $("#updateReview").removeAttr('disabled');
								   }
								   $("input[name='shopSettlementDetail.reviewStatus'][value='"+data.shopSettlementDetail.reviewStatus+"']").attr('checked','checked');
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
			pageSplit();//调用分页函数
		});
		function query(){
			var shopName = $("#s_shopName").val();
			var ym = $("#d4").val();
			var verifier = $("#s_verifier").val();
			var reviewStatus = $("#s_reviewStatus").val();
			queryParams={shopName:shopName,ym:ym,verifier:verifier,reviewStatus:reviewStatus};
		  	$("#tt").datagrid("load",queryParams); 
		  	pageSplit(pageSize,queryParams);//调用分页函数
	    }
    </script>
    <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  </head>
  <body>
  	<table   style="border:1px solid #99BBE8;text-align: center;" width="100%">
	       <tr>
		          <td class="toright_td">店铺名称：</td>
		          <td class="toleft_td"><input type="text" id="s_shopName" name="s_shopName"/></td>   
		          <td class="toright_td">申请月份：</td>
		          <td class="toleft_td">
		          	<input type="text" name="ym" style="height:23px;" class="Wdate" id="d4" onfocus="WdatePicker({dateFmt:'yyyy-MM',maxDate:'%y-%m'})"/>
		          </td>
		          <td class="toright_td">审核人：</td>
		          <td class="toleft_td"><input type="text" id="s_verifier" name="s_verifier"/></td>
		          <td class="toright_td">审核状态： </td>
		          <td class="toleft_td">
		              <select id="s_reviewStatus" name="s_reviewStatus">
		              		<option value="">--请选择--</option>
		              		<option value="0">未审核</option>
		              		<option value="1">已审核</option>
          			  </select>
		          </td>
		      	<td class="toright_td">&nbsp;</td>
	          <td class="toleft_td">
	             <a href="javascript:query();" id="btn1" iconCls="icon-search" >
	              <img src="${fileUrlConfig.sysFileVisitRoot_back}css/themes/icons/search.png" style="border: none;vertical-align: middle;"/>查询</a>
	          </td>
	           
	       </tr>
	   </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
  			<!-- 审核页面 -->
			<jsp:include page="detail.jsp"></jsp:include>
		</div>
  </body>
</html>
