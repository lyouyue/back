<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
 <div id="addOrEditWin" >
    <form id="form1"  method="post" action="">
        <input id="parentId" type="hidden" name="shopCategory.parentId" value=""/>
        <input id="shopCategoryId" type="hidden" name="shopCategory.shopCategoryId" value=""/>
        <input id="level" type="hidden" name="shopCategory.level" value=""/>
        <input id="loadType" type="hidden" name="shopCategory.loadType" value=""/>
        <input id="createTime" type="hidden" name="shopCategory.createTime" value="">
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>分类名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="u_shopCategoryName" type="text" name="shopCategory.shopCategoryName" value="" class="{validate:{required:true,maxlength:[25]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>分类编码:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="u_sortCode" type="text" name="shopCategory.sortCode" value="" class="{validate:{required:true,maxlength:[4],digits:true}}"/></td>
		    </tr>
	    </table>
	    <div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    </div>
	</form>
 </div>
