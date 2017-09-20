<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>全局国际化</title>
  </head>
  
   <body>
      看下面的文字三种方式：<br/>
      <s:text name="welcome"/><hr/>
      <s:text name="wen"/><hr/>
      <s:textfield name="welcome" key="welcome"></s:textfield><hr/>
      <!-- 3 -->
      <s:i18n name="hyyt">
        <s:text name="wen"></s:text>
      </s:i18n>
  </body>
  
</html>
