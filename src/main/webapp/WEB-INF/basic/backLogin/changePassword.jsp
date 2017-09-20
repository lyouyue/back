<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>修改密码</title>
<jsp:include page="../../util/import.jsp"/>
<script type="text/javascript">
	//修改密码
	function updatePassword() {
	    var newpass = $("#txtNewPass").val();
	    var rePass = $("#txtRePass").val();
	    var oldPassWord = $('#oldPassWord').val();//旧密码
	    $.getJSON("${pageContext.request.contextPath}/back/users/checkOldPassWord.action",{params:oldPassWord},function(json){
	    	if(eval(json.isSuccess)){
			    if(newpass == ''){
			    	$("#msg1").html("");
			    	$("#msg3").html("");
			    	$("#msg2").html("<font color='#FF0000'>新密码为空！</font>");
			    }else if(rePass == ''){
			    	$("#msg1").html("");
			    	$("#msg2").html("");
			    	$("#msg3").html("<font color='#FF0000'>确认密码为空！</font>");
			    }else if(newpass != rePass){
			    	$("#msg1").html("");
			    	$("#msg2").html("");
			    	$("#msg3").html("<font color='#FF0000'>两次密码不一至,请重新输入</font>");
			    }else if(newpass != oldPassWord){
			    	$.ajax({
						   type: "POST",
						   dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/users/updatePassword.action",
						   data: {password:newpass},
						   success: function(data){
								 parent.location.href="${pageContext.request.contextPath}/HYYTBackLogin/HYYTBackLogin.action";
						   }
					});
			    	$("#btnEp").attr("disabled",true);//防止重复提交
			    }else{
			    	$("#msg1").html("");
		    		$("#msg2").html("<font color='#FF0000'>新密码与旧密码一致，请重新输入！</font>");
		    		$("#msg3").html("");
			    }
	    	}else{
	    		$("#msg1").html("<font color='#FF0000'>旧密码输入错误！</font>");
	    		$("#msg2").html("");
	    		$("#msg3").html("");
	    	}
	    });
	}
</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<form id="form5" name="form5" action="" method="post">
        <table align="center" class="addOrEditTable" style="width:600px;">
            <tr>
                <td class="toright_td" width="180px"><font style="color: Red">* </font>旧密码：</td>
                <td class="toleft_td"><input id="oldPassWord" type="password" name=oldPassWord class="txt01" />&nbsp;&nbsp;&nbsp;&nbsp;<span id="msg1"></span></td>
            </tr>
            <tr>
                <td class="toright_td" width="180px"><font style="color: Red">* </font>新密码：</td>
                <td class="toleft_td"><input id="txtNewPass" type="password" name="password" class="txt01" />&nbsp;&nbsp;&nbsp;&nbsp;<span id="msg2"></span></td>
            </tr>
            <tr>
                <td class="toright_td" width="180px"><font style="color: Red">* </font>确认密码：</td>
                <td class="toleft_td"><input id="txtRePass" type="password" class="txt01" />&nbsp;&nbsp;&nbsp;&nbsp;<span id="msg3"></span></td>
            </tr>
        </table>
       	<div data-options="region:'south',border:false" style="text-align:center;padding:15px 0;">
			 <a id="btnEp" class="easyui-linkbutton" icon="icon-save" href="javascript:updatePassword()">保存</a>
	    </div>
    </form>
       
</body>
</html>

