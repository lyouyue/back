<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
	    <tr>
	      <td class="toright_td" width="150px">用户名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="duserName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">密码:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dpassword"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">真实姓名:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dtrueName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">电子邮件:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="demail"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">手机号码:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dphone"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">备注:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcomments"></span></td>
	    </tr>
	    <!-- <tr>
	      <td class="toright_td" width="150px">注册日期:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dregisterDate"></span></td>
	    </tr> -->
	    <tr>
	      <td class="toright_td" width="150px">状态:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dlockState"></span></td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>