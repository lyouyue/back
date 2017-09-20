<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
    <tr>
      <td class="toright_td" width="150px">地区名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="ddistrictName"></span></td>
    </tr>
    <tr>
      <td class="toright_td" width="150px">地区排序:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
    </tr>
   </table>
	<!-- <div style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()"/>&nbsp;
	</div> -->
	 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
 </div>  
