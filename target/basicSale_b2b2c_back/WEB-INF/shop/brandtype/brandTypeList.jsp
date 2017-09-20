<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <title>选择分类</title>
  <base target="_self"></base>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Cache-Control" content="no-cache"/>
  <meta http-equiv="Expires" content="-1"/>
  <jsp:include page="../../util/import.jsp"/>
  <link rel="styleSheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}dtree/css/dtree.css"/>
  <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}dtree/js/dtree_brandtype.js"></script>
  <script type="text/javascript">
    function save(){
	   $("#form1").submit(); 
	   window.close(); 
	}
  </script>
  </head>
  <body>
  	<form action="${pageContext.request.contextPath}/back/brandtype/saveBrandType.action" method="post" name="form1" id="form1">
  		<input type="hidden" name="brandType.brandId" value="<s:property value="brandId"/>"/>
	 	<div class="dtree">
			<script type="text/javascript">
				d = new dTree('d');	
				<s:iterator value="productTypeList" var="productType">
			 		d.add(<s:property value="#productType.productTypeId"/>,<s:property value="#productType.parentId"/>,'<s:property value="#productType.sortName"/>','');
			 	</s:iterator>
				document.write(d);
				<s:iterator value="brandTypeList" var="brandType">
					$("#"+<s:property value="#brandType.productTypeId"/>).attr("checked","true");
				</s:iterator>
			</script>
			<input type="button" value="提交数据" onclick="save();"/>
		</div>
	</form>
  </body>
</html>
