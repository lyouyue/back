<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin" >
    <table align="center" style="width: 600px;" class="addOrEditTable">
    	 <tr>
	      	<td class="toright_td" width="100px">图片预览:&nbsp;&nbsp;</td>
	    	<td class="toleft_td" >&nbsp;&nbsp;<span id="dphoto"></span></td>
		</tr>
    	 <tr>
	      	<td class="toright_td" width="100px">标题:&nbsp;&nbsp;</td>
	    	<td class="toleft_td" >&nbsp;&nbsp;<span id="dtitle"></span></td>
		</tr>
	    <tr><td class="toright_td" >描述:&nbsp;&nbsp;</td>
	    	<td class="toleft_td" >&nbsp;&nbsp;<span id="dsynopsis"></span></td>
    	</tr>
	    <tr><td class="toright_td" >链接:&nbsp;&nbsp;</td>
	    	<td class="toleft_td">&nbsp;&nbsp;<span id="dlink"></span></td>
    	</tr>
	    <tr>
	      <td class="toright_td" >图片类型:&nbsp;&nbsp;</td>
	    	<td class="toleft_td">&nbsp;&nbsp;<span id="dimageType"></span></td>
		</tr>
	    <tr>
	      <td class="toright_td" >是否显示:&nbsp;&nbsp;</td>
	    	<td class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
		</tr>
	    <tr><td class="toright_td" >排序:&nbsp;&nbsp;</td>
	    	<td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	    </tr>
    	<tr>
   	      <td class="toright_td"  >创建时间:&nbsp;&nbsp;</td>
		  <td  class="toleft_td">&nbsp;&nbsp;<span id="dcreateTime"></span></td>
		</tr>
		<tr>
   	      <td class="toright_td"  >创建人:&nbsp;&nbsp;</td>
		  <td  class="toleft_td">&nbsp;&nbsp;<span id="dpublishUser"></span></td>
	    </tr>
		<tr>
   	      <td class="toright_td"  >修改时间:&nbsp;&nbsp;</td>
		  <td  class="toleft_td">&nbsp;&nbsp;<span id="dupdateTime"></span></td>
	    </tr>
		<tr>
   	      <td class="toright_td"  >修改人:&nbsp;&nbsp;</td>
		  <td  class="toleft_td">&nbsp;&nbsp;<span id="dmodifyUser"></span></td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>