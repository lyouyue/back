<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table style="align:center;width:600px" class="addOrEditTable" >
	    <tr>
	      <td style="align:right;width:150px">单位名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dname"></span></td>
	    </tr>
	    <tr>
	      <td style="align:right;width:150px">是否启用:</td><td class="toleft_td">&nbsp;&nbsp;<span id="duseState"></span></td>
	    </tr>
   </table>
   <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" style="icon:icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
 </div>