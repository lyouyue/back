<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="addOrEditWin">
	<input type="hidden" name="evaluateId" id="eevaluateId"/>
    <table align="center" class="addOrEditTable">
    	<tr><td class="toright_td" width="150px">订单号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="eordersNo"></span></td><td class="toright_td" width="150px">店铺名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="eshopName"></span></td></tr>
    	<tr><td class="toright_td" width="150px">套餐名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="eproductFullName"></span></td><td class="toright_td" width="150px">套餐价格:</td><td class="toleft_td">&nbsp;&nbsp;￥<span id="esalesPrice"></span></td></tr>
	    <tr><td class="toright_td" width="150px">评价人:</td><td class="toleft_td" width="250px">&nbsp;&nbsp;<span id="eappraiserName"></span></td><td class="toright_td" width="150px">评价等级:</td><td class="toleft_td">&nbsp;&nbsp;<span id="elevel"></span></td></tr>
    	<tr><td class="toright_td" width="150px">评价时间:</td><td class="toleft_td">&nbsp;&nbsp;<span id="ecreateTime"></span></td>
    		<td class="toright_td" width="150px">评价状态:</td>
			<td class="toleft_td">&nbsp;&nbsp;
				<input  type="radio" name="eevaluateState" value="0"/>正常显示&nbsp;
				<input  type="radio" name="eevaluateState" value="1"/>禁止显示
			</td>
		</tr>
    	<tr>
	   	      <td class="toright_td" width="150px" >评价内容:</td>
			      <td  class="toleft_td" colspan="3" >&nbsp;&nbsp;
			       <textarea id="econtent" rows="8" cols="48" class="{validate:{maxlength:[500]}}" style="margin-bottom:0px; margin-top:5px; margin-left: -5px; width: 611px; height: 84px;"></textarea>
			  </td>
		</tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="updateEvaluate" class="easyui-linkbutton" icon="icon-save"  href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>