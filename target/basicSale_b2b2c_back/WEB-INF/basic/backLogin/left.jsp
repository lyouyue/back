<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>left</title>
    <link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/left.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript">
        $(function(){
            //导航切换
            /*$(".menuson li").click(function(){
                $(".menuson li.active").removeClass("active");
                $(this).addClass("active");
            });*/

            $(".title").click(function(){
                var $ul = $(this).next("ul");
                $("dd").find("ul").slideUp();
                if($ul.is(":visible")){
                    $(this).next("ul").slideUp();
                }else{
                    $(this).next("ul").slideDown();
                }
            });
        })
        function targetCenter(_href, purviewName) {
            window.parent.frames.addPanel(_href, purviewName);
        }
    </script>
</head>

<body>
	<dl class="leftmenu">
	<s:if test="#session.map!=null&&#session.map.size>0">
	    <s:iterator value="#session.map" id="map" status="count">
	        <s:if test="#map!=null">
		        <dd>
		            <div class="title">
		                <span><img src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/workspace/leftico.png"/></span>
		                <s:property value="#map.purviewName"/>
		            </div>
		            <ul class="menuson">
		                <s:iterator value="#map.purviewList" var="purview" status="index">
		                    <li>
		                        <cite></cite>
		                        <a onclick="targetCenter('${pageContext.request.contextPath}/<s:property value='#purview.url'/>?purviewId=<s:property value="#purview.purviewId"/>','<s:property value="#purview.purviewName"/>')">
		                            <s:property value="#purview.purviewName"/>
		                        </a>
		                        <i></i>
		                    </li>
		                </s:iterator>
		            </ul>
		        </dd>
	        </s:if>
	    </s:iterator>
	</s:if>
	<s:else>
		<div style="margin:10px;">
			<font color="RED">平台管理员未给您分配权限！</font>
		</div>
	</s:else>
	</dl>
</body>
</html>
