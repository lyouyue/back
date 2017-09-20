<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员充值明细信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"会员充值记录:${customerName}",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customer/customerRechargeList.action?customerId="+${customerId},
				queryParams:{pageSize:pageSize},
				idField:"rechargeId",//唯一性标示字段
				columns:[[//未冻结字段
		            {field:"rechargeCode",title:"充值流水号",width:240, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
			               //return "<a style='display:block;cursor: pointer;' id='"+rowData.rechargeId+"' onclick='showDetailInfo(this.id);'>"+rowData.rechargeCode+"</a>";
			               return rowData.rechargeCode;
		         	  }  },
		            {field:"rechargeAmount",title:"充值金额（元）",width:240},
		            {field:"rechargeType",title:"充值类型",width:240,
		            	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="1"){ return "普通充值";}
                        if(value=="2"){ return "会员中心普通充值";}
                        if(value=="3"){ return "后台普通充值";}
                     }},
		            {field:"state",title:"充值状态",width:240,
		            	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="0"){ return "未支付";}
                        if(value=="1"){ return "已支付";}
                     }},
		            {field:"rechargeTime",title:"充值时间",width:240}
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
				},"-",
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
			queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,loginName:$("#loginName").val()};
			$("#tt").datagrid("load",queryParams);
			pageSplit(pageSize,queryParams);//调用分页函数
		}
	</script>
</head>
<body>
  <jsp:include page="../../util/item.jsp"/>
  <div class="main">
		<div style="font-weight: bolder;margin:0px 0px 5px 5px;color:red;">
			余额：${requestScope.customerBankroll.balance }&nbsp;元&nbsp;&nbsp;
			充值总金额：${requestScope.customerBankroll.rechargeBalance }&nbsp;元
		</div>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;margin-bottom: ">
		  <form id="form1"  method="post"></form>
		<!-- 详情页面 -->
		<%-- <jsp:include page="customerMallCoinDetail.jsp"/> --%>
		</div>
		</div>
</body>
</html>
