<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
	    <tr>
	      <td class="toright_td" width="150px">等级图标:</td><td colspan="3" class="toleft_td">&nbsp;&nbsp;<span id="dlevelIcon"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dbuyerRank"></span></td>
	      <td class="toright_td" width="150px">等级折扣值:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dlevelDiscountValue"></span>&nbsp;折</td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">最小参考值:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dminRefValue"></span>&nbsp;元</td>
	      <td class="toright_td" width="150px">最大参考值:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dmaxRefValue"></span>&nbsp;元</td>
	    </tr>
	   <!--  <tr>
	      <td class="toright_td" width="150px">会员类型:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dtype"></span></td>
	      <td class="toright_td" width="150px">会员头衔:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dbuyerRank"></span></td>
	    </tr>
	     <tr>
	      <td class="toright_td" width="150px">授信额度:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dlineOfCredit"></span>&nbsp;元</td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">授信期限:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="dcreditDate"></span>&nbsp;天</td>
	    </tr> -->
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
	   <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>