<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
	    <tr>
	      <td class="toright_td" width="150px">卖家等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsellersLevel"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">卖家头衔:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsellersRank"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">等级折扣值:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dlevelDiscountValue"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">等级图标:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dlevelIcon"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">最小参考值:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dminRefValue"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">最大参考值:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dmaxRefValue"></span></td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
	   <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
</div>