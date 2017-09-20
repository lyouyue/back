<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
		<title></title>
	</head>
	<body>
		<div >
			<h1>
				商品分类
			</h1>
			<div>
				<s:iterator value="#session.proTypeBeanList" var="ptb">
					<div> 
					<h3>
						<a target="proInfo" href="${pageContext.request.contextPath}/specialpro/findProducts.action?productTypeId=<s:property value="#ptb.proTypeId"/>" style="color: red"><s:property value="#ptb.proTypeName"/></a>
					</h3>
					<div>
						<ul>
							<s:iterator value="#ptb.proTypeList" var="pt">
								<li>
									<a target="proInfo" href="${pageContext.request.contextPath}/specialpro/findProducts.action?productTypeId=<s:property value="#pt.productTypeId"/>"><s:property value="#pt.sortName"/></a>
								</li>
							</s:iterator>
						</ul>
						</div>
				</div>
				</s:iterator>
			</div>
		</div>
	</body>
</html>
