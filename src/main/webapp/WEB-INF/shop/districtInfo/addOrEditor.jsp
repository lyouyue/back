<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
 <div id="addOrEditWin" >
    <form id="form1"  method="post" action="">
        <input id="parentId" type="hidden" name="districtInfo.parentId" value=""/>
        <input id="districtInfoId" type="hidden" name="districtInfo.districtInfoId" value=""/>
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">地区名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="districtName" type="text" name="districtInfo.districtName" value="" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">地区排序:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="districtInfo.sortCode" value="" class="{validate:{required:true,maxlength:[4]}}"/></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	   </div>
	</form>
 </div>
