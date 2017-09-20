<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
function query1(){
	queryParams={pageSize:pageSize,currentPage:currentPage,loginName:$("#loginName2").val(),orderNo:$("#orderNo2").val()};
	$("#distributionList").datagrid("clearSelections");//删除后取消所有选项
	$("#distributionList").datagrid("load",queryParams); 
	pageSplitThis(pageSize,queryParams,"distributionList");//调用分页函数
};
function reset1(){
	$("#loginName2").val("");
	$("#orderNo2").val("");
}
</script>
  <div id="distributionWin">
	<form id="form2" method="post" action="">
  				<table width="100%;" style="border:1px solid #99BBE8;text-align: center;">
	  			<tr>
	  		<%-- 	<td><span class="querybtn" style="font-size: 12px;">会员名称：<input type="text" id="loginName2" /></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  		</td> --%>
			  		<td><span class="querybtn" style="font-size: 12px;">订单编号：<input type="text" id="orderNo2" /></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  		</td>
			  		<td>
			  		<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query1()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset1()">重置</a>
			  		</td>
			  	</tr>	
		</table><br/>
  			</form>
		<table id="distributionList">
		</table>
</div>
  
