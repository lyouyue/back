<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 <div id="addOrEditWin" >
    <form id="form1"  method="post" action="">
        <input id="parentId" type="hidden" name="shopProCategory.parentId" value=""/>
        <input id="shopProCategoryId" type="hidden" name="shopProCategory.shopProCategoryId" value=""/>
        <input id="level" type="hidden" name="shopProCategory.level" value=""/>
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">分类名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="shopProCategoryName" type="text" name="shopProCategory.shopProCategoryName" value="" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">分类编码:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="shopProCategory.sortCode" value="" class="{validate:{required:true,maxlength:[4]}}"/></td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px">是否显示:&nbsp;&nbsp;</td>
			  <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="isShow_0" type="radio" name="shopProCategory.isShow" checked="checked" value="0"/>否&nbsp;&nbsp;<input id="isShow_1" type="radio" name="shopProCategory.isShow" value="1"/>是</td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	   </div>
	</form>
 </div>
