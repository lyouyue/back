<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//查询用户是否已存在
	function checkUsers1(){
		var value = $("#uuserName").val();
		var usersId = $("#usersId").val();
		var returnVal=0;
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/users/checkUsers1.action",
				data:{userName:value,usersId:usersId},
				async:false,
				success:function(data){
					if(data == "ok"){
						$("#userMsg").html("<em style='color:green'>可用</em>");
						returnVal=  1;
					}else{
						$("#userMsg").html("<em style='color:red'>已存在</em>");
					}
				}
			});
		}else{
			$("#userMsg").html("");
		}
		return returnVal;
	}
   
</script>
  <div id="addOrEditWin">
    <form id="form1"  method="post" action="">
        <input id="usersId" type="hidden" name="users.usersId"  value=""/>
        <input id="registerDate" type="hidden" name="users.registerDate" value=""/>
	    <table align="center" class="addOrEditTable" >
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>用户名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<input id="uuserName" type="text" name="users.userName" class="{validate:{required:true}}" onblur="checkUsers1();"/>
		      	<span id="userMsg"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>密码:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="password" type="password" name="users.password" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>真实姓名:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="trueName" type="text" name="users.trueName" class="{validate:{required:true,maxlength:[16]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>电子邮件:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="email" type="text" name="users.email" class="{validate:{required:true,email:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>手机号码:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="phone" type="text" name="users.phone" class="{validate:{required:true,mobile:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>备注:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="comments" type="text" name="users.comments" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>状态:&nbsp;&nbsp;</td>
			  <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input  id="lockState_0" type="radio" name="users.lockState" checked="checked" value="0"/>未冻结&nbsp;&nbsp;<input  id="lockState_1" type="radio" name="users.lockState" value="1"/>已冻结</td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
	    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    </div>
	</form>
  </div>
