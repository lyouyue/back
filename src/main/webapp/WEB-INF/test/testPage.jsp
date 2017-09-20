<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head >
		<title>app接口测试页面</title>
		<jsp:include page="../util/import.jsp"/>
	</head>
	<body>
	<jsp:include page="../util/item.jsp"/>
	<div class="main">
			<form id="submitForm" action="/back/test/gotoAction.action" method="post">
				<div align="center" style="width:100%;">
					<font style="font-weight:bold;">请求地址：</font><br/><input name="reqActionUrl"  type="text" style="width:600px;height:20px;" value="${reqActionUrl }"/><br/><br/>
					<font color="BLUE">例如：http://192.168.1.8:8080/app/login/customerLogin</font><br/><br/>
					<font style="font-weight:bold;">请求参数：</font><br/>
					<textarea name="reqParameters" rows="10" cols="5" style="width:600px;" ><s:property value="reqParameters" escape="false"/></textarea>
						<br /><br />
					<font color="BLUE">例如：phone=15010908223&password=14e1b600b1fd579f47433b88e8d85291&equipmentNumber=123456</font><br/><br/>
						<input type="submit" style="width: 80px;" value="提   交"/>
						<br/>
					<font style="font-weight:bold;">http响应结果：</font><br/><textarea rows="6" cols="10" style="width:600px;" >${responseValue}</textarea><br /><br />
					<font style="font-weight:bold;">http响应码：</font>${responseCode }<br /><br />
					<br/>
					<br/>
					<br/>
				</div>
			</form>
	</div>
	</body>
</html>
