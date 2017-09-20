<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
  <div id="congeal" >
  	<table align="center" class="addOrEditTable" width="600px;">
	    <tr>
	      <td class="toright_td" width="150px">冻结状态:&nbsp;&nbsp;</td>
	      <td  class="toleft_td">&nbsp;&nbsp;
	      	<input id="clockedState_1"  type="radio" name="clockedState" value="1"/>已冻结&nbsp;&nbsp;
	      	<input id="clockedState_0"  type="radio" name="clockedState" value="0"/>未冻结
	      </td>
	    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="submitForm3()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </div>

