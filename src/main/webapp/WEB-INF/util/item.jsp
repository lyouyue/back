<%@ page language="java" pageEncoding="utf-8" import="java.util.*" %>
<div class="item">
	<img src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/item.png" />
	<span id="itemName"></span>
</div>
<script type="text/javascript">
$(function(){
	var title = document.title;
	$("#itemName").html(title);
});
</script>
