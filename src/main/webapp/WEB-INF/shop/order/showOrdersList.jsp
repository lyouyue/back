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
  	  <th>明细ID</th>
      <th>订单ID</th>
      <th>套餐ID</th>
      <th>套餐名</th>
      <th>原价</th>
      <th>本店价</th>
      <th>折扣价</th>
      <th>数量</th>
    </tr>
    <s:iterator value="listOrderList" var="orderslist">
	    <tr>
	      <td><s:property value="#orderslist.orderListId"/></td>
	      <td><s:property value="#orderslist.orders.ordersId"/></td>
	      <td><s:property value="#orderslist.productId"/></td>
	      <td><s:property value="#orderslist.shpname"/></td>
	      <td><s:property value="#orderslist.marketPrice"/></td>
	      <td><s:property value="#orderslist.shopPrice"/></td>
	      <td><s:property value="#orderslist.memberPrice"/></td>
	      <td><s:property value="#orderslist.numbers"/></td>
	    </tr>
    </s:iterator>
 </table>
  </body>
</html>
