<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
    <tr>
      <td class="toright_td" width="150px">分类名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dshopCategoryName"></span></td>
    </tr>
    <tr>
      <td class="toright_td" width="150px">分类编码:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
    </tr>
    <tr>
      <td class="toright_td" width="150px">所属级别:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dlevel"></span></td>
    </tr>
   </table>
	<!-- <div style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" style="cursor:pointer;"/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
 </div>  
