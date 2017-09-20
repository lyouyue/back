<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
  <div id="detailWin" >
  <table align="center" class="addOrEditTable" width="600px;">
		   <tr>
		      <td class="toright_td" width="150px">头像预览:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" colspan="1">&nbsp;&nbsp;<span id="d_photo"></span></td>
			   <td class="toright_td" width="150px">会员类型:&nbsp;&nbsp;</td>
			   <td  class="toleft_td" >&nbsp;&nbsp;<span id="d_type"></span></td>
		   </tr>
		   <tr>
		      <td class="toright_td" width="150px">登录名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_loginName"></span></td>
		      <td class="toright_td" width="150px">性别:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="d_sex"></span></td>
		   </tr>
		   <tr>
		      <td class="toright_td" width="150px">生日:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="dd_birthday"></span></td>
		      <td class="toright_td" width="150px">手机:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="d_phone"></span></td>

		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">邮箱:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="d_userEmail"></span></td>
		      <td class="toright_td" width="150px">账户余额:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_balance"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">冻结状态:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="d_lockedState"></span></td>
		      <td class="toright_td" width="150px">注册ip:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="dd_registerIp"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">注册时间:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="dd_registerDate"></span></td>
		      <td class="toright_td" width="150px">是否关联微信:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<span id="dd_wxUserOpenId"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">简介:&nbsp;&nbsp;</td>
		      <td class="toleft_td"  colspan="3">&nbsp;&nbsp;<span id="d_notes"></span></td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
  </div>

