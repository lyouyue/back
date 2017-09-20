<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
	    <tr>
	      <td class="toright_td" width="150px">标签名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dtageName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">使用状态:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="duseState"></span></td>
	    </tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
	 	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
 </div>