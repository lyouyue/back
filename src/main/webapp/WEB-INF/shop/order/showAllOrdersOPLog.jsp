<%@ page language="java" pageEncoding="utf-8" import="java.util.*" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员信息</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/admin.css"/>
    <script type="text/javascript">
	</script>
  </head>
  <body>
  <table width="97%" border="0" cellpadding="0" cellspacing="0" class="right">
		<tr>
			<td height="30" class="crumb">
			</td>
		</tr>
  </table>
 <table width="90%" border="0" cellpadding="0" cellspacing="0" class="list">
  	<tr>
  	  <th>日志ID</th>
      <th>订单ID</th>
      <th>操作员</th>
      <th>操作时间</th>
      <th>类型</th>
      <th>备注</th>
    </tr>
    <s:iterator value="listOrdersOPLog" var="ordersOPLog">
	    <tr>
	      <td><s:property value="#ordersOPLog.ordersOPLogId"/></td>
	      <td><s:property value="#ordersOPLog.orders.ordersId"/></td>
	      <td><s:property value="#ordersOPLog.ooperatorName"/></td>
	      <td><s:property value="#ordersOPLog.operatorTime"/></td>
	      <td><s:property value="#ordersOPLog.type"/></td>
	      <td><s:property value="#ordersOPLog.comments"/></td>
	    </tr>
    </s:iterator>
     <tr>
       <td colspan="8">
	       <a href="${pageContext.request.contextPath}/ordersOPLog/findOrdersOPLogList.action?pageIndex=${pageHelper.firstPageIndex}">首页</a>
	      <a href="${pageContext.request.contextPath}/ordersOPLog/findOrdersOPLogList.action?pageIndex=${pageHelper.prePageIndex}">上一页</a>
	      <c:forEach items="${pageHelper.optionalPageIndexList}" var="pageIndex">
	       <a href="${pageContext.request.contextPath}/redbag/findRedbagList.action?pageIndex=${pageIndex}">[${pageIndex}]</a>
	      </c:forEach>
	      <a href="${pageContext.request.contextPath}/ordersOPLog/findOrdersOPLogList.action?pageIndex=${pageHelper.nextPageIndex}">下一页</a>
	      <a href="${pageContext.request.contextPath}/ordersOPLog/findOrdersOPLogList.action?pageIndex=${pageHelper.lastPageIndex}">尾页</a>
	      <span>第${pageHelper.pageIndex}/${pageHelper.pageCount}页，共${pageHelper.pageRecordCount}条数据</span>
      </td>
     </tr>
 </table>
 
  </body>
</html>
