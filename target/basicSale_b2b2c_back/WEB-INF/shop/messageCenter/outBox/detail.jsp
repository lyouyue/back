<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <div id="detailWin">
			    <table align="center" class="addOrEditTable" width="700px">
				     <tr>
				      <td class="toright_td" width="150px">收件人:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
					      <span id="view_toMemberId"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">主题:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				          <span id="view_messageTitle"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">内容:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
					      <span id="view_content"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">发送状态:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
					      <span id="view_messageSendState"></span>
				      </td>
				    </tr>
			    </table>
			    <!-- <div style="text-align:center;padding:5px 0;">
					<input type="button" id="close" class="button_close" onclick="closeWin()"/>&nbsp;
				</div> -->
				 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
				</div>
		  </div>
</html>