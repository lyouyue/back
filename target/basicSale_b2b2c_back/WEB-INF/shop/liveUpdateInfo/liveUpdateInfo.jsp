<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>生成静态页</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    	function updateCategory(){
    		$.ajax({
			   type: "POST", 
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/liveUpdateInfo/updateCategoryInfo.action",
			   success: function(data){
				    if(data.isSuccess=="success"){
				    	msgShow("系统提示", "<p class='tipInfo'>success！</p>", "warning");  
				    }else{
				    	msgShow("系统提示", "<p class='tipInfo'>fail！</p>", "warning");  
				    }
			   }
			});
        }
    	function updateArticle(){
    		$.ajax({
			   type: "POST", 
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/liveUpdateInfo/findFooterArticle.action",
			   success: function(data){
				    if(data.isSuccess=="success"){
				    	msgShow("系统提示", "<p class='tipInfo'>success！</p>", "warning");  
				    }else{
				    	msgShow("系统提示", "<p class='tipInfo'>fail！</p>", "warning");  
				    }
			   }
			});
        }
    </script>
  </head>
  <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:150px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
  </style>  
  <body>
	    <span class="querybtn">
	    	<a href="javascript:updateCategory();" id="btn1">同步首页商品分类信息</a>
	    </span>
	    <br/>
	     <span class="querybtn">
	    	<a href="javascript:updateArticle();" id="btn2">同步首页底部文章信息</a>
	    </span>
  </body>
</html>
