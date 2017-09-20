<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
  <div id="addOrEditWin">
    <form id="form1"  method="post" action="">
        <input id="logisticsId" type="hidden" name="logistics.logisticsId" value=""/>
        <input id="createDate" type="hidden" name="logistics.createDate" value=""/>
	    <table style="text-align: center;width: 600px;margin-left: 17px;" class="addOrEditTable">
		    <tr style="width:580px;">
		      <td class="toright_td" width="200px"><font style="color: Red">* </font>物流公司代码:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="440px">&nbsp;&nbsp;<input style="width: 200px;" id="code" type="text" name="logistics.code" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="200px"><font style="color: Red">* </font>物流公司名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="440px">&nbsp;&nbsp;<input style="width: 200px;" id="deliveryCorpName" type="text" name="logistics.deliveryCorpName" class="{validate:{required:true,maxlength:[200]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="200px"><font style="color: Red">* </font>物流公司网址:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="440px">&nbsp;&nbsp;<input style="width: 200px;" id="deliveryUrl" type="text" name="logistics.deliveryUrl" class="{validate:{required:true,url:true,maxlength:[300]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="200px"><font style="color: Red">* </font>排序:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="440px">&nbsp;&nbsp;<input style="width: 200px;" id="sortCode" type="text" name="logistics.sortCode" class="{validate:{required:true,maxlength:[10],digits:true}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="200px">是否常用:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="440px">&nbsp;&nbsp;
			      <input id="isCommon_1"  type="radio" name="logistics.isCommon" checked="checked" value="1"/>是&nbsp;&nbsp;
			      <input id="isCommon_0"  type="radio" name="logistics.isCommon" value="0"/>否
		      </td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
	    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    </div>
	</form>
  </div>
