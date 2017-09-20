<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员金币明细</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"会员金币详情",
				iconCls:"icon-save", */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/mallCoin/customerMallCoinList.action?customerId="+${customerId},
				queryParams:{pageSize:pageSize},
				idField:"mallCoinId",//唯一性标示字段
				columns:[[//未冻结字段
		            {field:"serialNumber",title:"流水号",width:240, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
			               return "<a style='display:block;cursor: pointer;' id='"+rowData.mallCoinId+"' onclick='showDetailInfo(this.id);'>"+rowData.serialNumber+"</a>";
		         	  }  },
		            {field:"ordersNo",title:"订单号",width:240},
		            {field:"type",title:"类型",width:240,
		            	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="1"){ return "收入";}
                        if(value=="2"){ return "支出";}
                        if(value=="3"){ return "取消订单";}
                        if(value=="4"){ return "交易作废";}
                     }},
		            {field:"transactionNumber",title:"交易数量",width:240},
					/* {field:"remainingNumber",title:"剩余数量",width:240}, */
		           /*  {field:"proportion",title:"当时分享比例",width:240,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value!=null||value!="0") return rowData.proportion+"%";
							else return "0";
	                     }}, */
		            {field:"tradeTime",title:"交易时间",width:240}
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
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  <form id="form1"  method="post"></form>
		<!-- 详情页面 -->
		  <jsp:include page="customerMallCoinDetail.jsp"/>
		</div>
		</div>
  </body>
</html>
