<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>生成静态页</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    	function query(){
    		$.post("${pageContext.request.contextPath}/back/buildInit/build.action",function(data){
			    if(data.isSuccess=="true"){
			    	msgShow("系统提示", "<p class='tipInfo'>success！</p>", "warning");  
			    }else{
			    	msgShow("系统提示", "<p class='tipInfo'>fail！</p>", "warning");  
			    }
    		},'json');
        }
    </script>
  </head>
  <body>
	    <span class="querybtn">
	    	<a href="javascript:query();" id="btn1">生成首页静态页信息</a>
	    </span> 
  </body>
</html>
