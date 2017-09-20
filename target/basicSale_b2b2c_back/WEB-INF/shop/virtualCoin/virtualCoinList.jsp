<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员金币详情</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"会员金币详情",
				iconCls:"icon-save",
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/virtualCoin/virtualCoinList.action",
				queryParams:{pageSize:pageSize},
				idField:"virtualCoinId",//唯一性标示字段
				columns:[[//未冻结字段
		            {field:"loginName",title:"会员名",width:240, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.customerId+"' onclick='showDetailInfo(this.id);'>"+rowData.loginName+"</a>";
		         	  }
					},
					{field:"remainingNumber",title:"剩余数量",width:240}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true//true只可以选中一行
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
  <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
  <body>
		 <table style="border:1px solid #99BBE8;text-align: center;" width="100%">
		 	<tr>
		 		<td class="toleft_td">&nbsp;&nbsp;会员名：<input type="text" id="loginName" name="loginName"/>&nbsp;&nbsp;&nbsp;<a href="javascript:query();" id="btn1" iconCls="icon-search" >
	              <img src="${fileUrlConfig.sysFileVisitRoot_back}css/themes/icons/search.png" style="border: none;vertical-align: middle;"/>查询</a></td>
		 	</tr>
		 </table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		  <form id="form1"  method="post"></form>
		  <!-- 详情页 -->
		  <jsp:include page="virtualCoinDetail.jsp"/>
		</div>
  </body>
</html>
