<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
 	//查询会员是否已存在
	function checkCustomer(){
		var value = $("#loginName").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/customer/checkLoginName.action",
				data:{loginName:value},
				success:function(data){
					if(data == "ok"){
						$("#userMsg").html("<em style='color:green'>可用</em>");
						$("#btnSubmit").css("display","");
					}else{
						$("#userMsg").html("<em style='color:red'>已存在</em>");
						$("#loginName").focus();
						$("#btnSubmit").css("display","none");
					}
				}
			});
		}else{
			$("#userMsg").html("");
		}
	}
 	//查询邮箱是否已存在
	function checkEmail(){
		var value = $("#email").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/customer/checkEmail.action",
				data:{email:value},
				success:function(data){
					if(data == "ok"){
						$("#userEmail").html("<em style='color:green'>可用</em>");
						$("#btnSubmit").css("display","");
					}else{
						$("#userEmail").html("<em style='color:red'>已存在</em>");
						$("#qq").focus();
						$("#btnSubmit").css("display","none");
					}
				}
			});
		}else{
			$("#userEmail").html("");
		}
	}
</script>
<div id="addOrEditWin" style="display: none;">
  	<form id="photoForm" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="150px">头像上传:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="440px">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
		            <span id="mymessage"></span>
		  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto()"/>
		      </td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post" action="" >
        <input id="customerId" type="hidden" name="customer.customerId" value="">
        <input id="photoUrl" type="hidden" name="customer.photoUrl" value="">
        <input id="registerDate" type="hidden" name="customer.registerDate" value="">
        <input id="registerIp" type="hidden" name="customer.registerIp" value="">
        <input id="lockedDate" type="hidden" name="customer.lockedDate" value="">
<%--        <input id="password" type="hidden" name="customer.password" value="">--%>
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">登录名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<input id="loginName" type="text" name="customer.loginName" class="{validate:{required:true,maxlength:[50]}}" onblur="checkCustomer()">
			      <span id="userMsg"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">密码:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="password" type="password" name="customer.password" class="{validate:{required:true,maxlength:[16]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">头像预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="photo"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">昵称:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="nickName" type="text" name="customer.nickName" class="{validate:{required:true,maxlength:[25]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">性别:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sex_0"  type="radio" name="customer.sex" checked="checked" value="0"/>男&nbsp;&nbsp;&nbsp;<input id="sex_1"  type="radio" name="customer.sex" value="1"/>女</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">生日:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	<input  type="text" name="customer.birthday" id="birthday"/>&nbsp;
				<img onclick="WdatePicker({el:'birthday',dateFmt:'yyyy-MM-dd'})" 
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">真实名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="trueName" type="text" name="customer.trueName" class="{validate:{required:true,maxlength:[15]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">电子邮箱:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="email" type="text" name="customer.email" class="{validate:{required:true,email:true}}" onblur="checkEmail();"/>
		      	<span id="userEmail"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">QQ号:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="qq" type="text" name="customer.qq" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">冻结状态:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="lockedState_0"  type="radio" name="customer.lockedState" checked="checked" value="0"/>可用&nbsp;&nbsp;&nbsp;<input id="lockedState_1"  type="radio" name="customer.lockedState" value="1"/>冻结</td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
		</div>
	</form>
  </div>
