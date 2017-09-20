<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="600px">
    	<tr>
	      <td class="toright_td" width="150px">操作人:</td><td  class="toleft_td">&nbsp;&nbsp;<span style="color:green;font-weight:bolder" id="doperator"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">卖家等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsellersLevel"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">卖家头衔:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsellersRank"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">等级图标:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dlevelIcon"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">操作时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="doptionDate"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">备注:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dremark"></span></td>
	    </tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>