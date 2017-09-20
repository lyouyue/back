<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="600px">
	    <tr>
	      <td class="toright_td" width="150px">登录名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dloginName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">手机号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dphone"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">买家等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="ddbuyersLevel"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">买家头衔:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dbuyerRank"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">等级图标:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dlevelIcon"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">最小参考值:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dminRefValue"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">最大参考值:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dmaxRefValue"></span></td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>