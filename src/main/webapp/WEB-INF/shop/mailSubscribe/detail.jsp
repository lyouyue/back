<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <div id="detailWin">
			    <table align="center" class="addOrEditTable" width="800px">
<!-- 			        <tr>
				      <td class="toright_td" width="150px">图片预览 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td" width="440px">&nbsp;&nbsp;
				          &nbsp;&nbsp;&nbsp;&nbsp;<span id="view_photo"></span>
				      </td>
				    </tr> -->
				    <tr>
				      <td class="toright_td" width="150px">标题:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				       <span id="view_title"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">摘要:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				       <span id="view_brief"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">内容:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				        <div id="view_content"></div>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">是否发送:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				        <div id="view_isSend"></div>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">发布人:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				       <span id="view_publishUser"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">修改人:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				       <span id="view_modifyUser"></span>
				      </td>
				    </tr>
				     <tr>
				      <td class="toright_td" width="150px">创建时间:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				        <span id="view_createTime"></span>
				      </td>
				    </tr>
				     <tr>
				      <td class="toright_td" width="150px">修改时间:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				        <span id="view_updateTime"></span>
				      </td>
				    </tr>
			    </table>
			    <%-- <div style="text-align:center;padding:5px 0;">
					<input type="button" id="updateIsPass"  class="button_save" value="" style="cursor:pointer;"/>&nbsp;
					<input type="button" id="close" class="button_close" onclick="closeWin()" style="cursor:pointer;"/>&nbsp;
				</div> --%>
				 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
				 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
				</div>
		  </div>
</html>