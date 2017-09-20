<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
	<form id="form1" action=""></form>
    <table align="center" class="addOrEditTable" style="width: 700px;">
	    <tr>
	      <td class="toright_td" width="150px">操作功能：</td><td class="toleft_td">&nbsp;&nbsp;<span id="dopDesc"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">操作人：</td><td class="toleft_td">&nbsp;&nbsp;<span id="duserTrueName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">IP：</td><td class="toleft_td">&nbsp;&nbsp;<span id="dip"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">操作时间：</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dopDate"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">操作参数：</td><td  class="toleft_td"   >&nbsp;&nbsp;
	      		<div id="dopParams"  style="width:528px; word-wrap:break-word; word-break:break-all; margin-top:-28px;"></div>
	      </td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>