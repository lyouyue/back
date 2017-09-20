<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>欢迎登录QypaasJsp平台管理系统</title>
	<link rel="shopjsp icon" href="${fileUrlConfig.sysFileVisitRoot_back}common/imgs_init/sj.ico"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/base.css"/>
	<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/login.css"/>
    <style type="text/css">
       ::-ms-clear, ::-ms-reveal{display: none;}
    </style>
	<script type="text/javascript">
		$(function(){
			if (navigator.userAgent.toLowerCase().indexOf("chrome") >= 0) {
	            $(window).load(function () {
	                $('input:-webkit-autofill').each(function () {
	                    var text = $(this).val(); var name = $(this).attr('name');
	                    $(this).after(this.outerHTML).remove();
	                     $('input[name=' + name + ']').val(text);
	                 });
	            });
	        }
		});
		var messg='${falseMsg}';
		$(function () {
		     //点击图片更换验证码
		     $("#verification").click(function(){
		         $(this).attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
		     });
		     if(messg=="noPurviews"){
		    	 $("#msg").html("<font color='red'>该用户没有权限，请与管理员联系！</font>");
		     }else if(messg=="lockedTrue"){
		    	 $("#msg").html("<font color='red'>该用户已被冻结，请与管理员联系！</font>");
		     }
		 });
		//点击换一换更换验证码
		function hyh(){
			$("#verification").attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
		}
		function loginCheck(){
			$.ajax({
    			url:"${pageContext.request.contextPath}/backLogin/checkingUsers.action",
    			dataType:"json",
    			type:"post",
    			data:{userName:$("#userName").val(),password:$("#password").val(),verificationCode:$("#verificationCode").val()},
    			success:function(data){
    				if(data.isExsit=="1"){
    					//重新调用验证码图片，【?timetemp="+new Date()】加上时间参数作用是每次请求都不一样，可以激活
						$("#verification").attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
						$("#msg").html("<font color='red'>温馨提示：用户名或密码输入有误,请重新登录！</font>");
    				}else if(data.isExsit=="2"){
    					//重新调用验证码图片，【?timetemp="+new Date()】加上时间参数作用是每次请求都不一样，可以激活
						$("#verification").attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
    					$("#msg").html("<font color='red'>验证码输入有误，请从新输入！</font>");
    					$("#verificationCode").val("");
    				}else if(data.isExsit=="3"){
    					//重新调用验证码图片，【?timetemp="+new Date()】加上时间参数作用是每次请求都不一样，可以激活
						$("#verification").attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
    					$("#msg").html("<font color='red'>验证码失效，点击刷新！</font>");
    				} else if(data.isExsit=="4"){
    					//重新调用验证码图片，【?timetemp="+new Date()】加上时间参数作用是每次请求都不一样，可以激活
						$("#verification").attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
    					$("#msg").html("<font color='red'>温馨提示：该用户已被冻结，请与管理员联系！</font>");
    				}else{
    					window.location.href="${pageContext.request.contextPath}/back/backLogin/userLogin.action";
    				}
    			}
    		});
		}
		$(document).ready(function (){
		      $(".loginBotton").bind("click",function(){
		    	  loginCheck();
		      });
	     });
		function keyDown(event){
			var e= event ? event : (window.event ? window.event : null);
		    if (e.keyCode == 13){
		        e.returnValue=false;
		        e.cancel = true;
		        loginCheck();
		    }
		}
	</script>

  </head>

  <body>

		<div class="loginMain">
		   <div class="loginma_main">
			 <span class="sysLogo">欢迎您！登录QypaasJsp商城运营管理系统</span>
			 <div class="loginInfo">
				  <ul>
					  <li><input id="userName" name="userName" type="text" class="loginName" value="" /></li>
					  <li><input id="password" name="password" type="password" class="loginPassword" value=""  onkeydown="keyDown(event);"/></li>
					  <li><input type="text" class="loginpwd_yzm" id="verificationCode"  name="verificationCode"  value=""  onkeydown="keyDown(event);"/>
					  	<span title="看不清，换一张"  style=" display:block; float:left; width:100px; height:40px;"><img src="" style="width:90px;height: 40px; cursor: pointer;"  id="verification"  alt="看不清，换一张"/></span>
					  	<a onclick="hyh()"  style="width:80px; height:43px; line-height:43px; display:block; float:left; margin-left:0px; text-decoration: none; font-size:14px; color: #005c99; cursor: pointer;">换一换</a>
						<script type="text/javascript">
						 //初始化加载
						 $(function(){
							 //初始化加载验证码信息
							 $("#verification").attr("src","${pageContext.request.contextPath}/backLogin/userFirstLogin.action?timestamp="+new Date().getTime());
							 //初始化聚焦操作
							 $("#userName").focus();
						 });
						</script>
						 <div style="clear:both;"></div></li>
					  <li><input type="button" class="loginBotton"/></li>
				  </ul>
				  <div style="padding-left: 302px;"><span id="msg"></span></div>
			 </div>
			 </div>
		</div>

	</body>
</html>
