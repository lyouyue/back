<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="600px">
	      <td align="right" width="150px">分类名称:</td><td align="left">&nbsp;&nbsp;<span id="dshopProCategoryName"></span></td>
	    </tr>
	    <tr>
	      <td align="right" width="150px">排序号:</td><td align="left">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	    </tr>
	    </tr>
	      <td align="right" width="150px">是否显示:</td><td align="left">&nbsp;&nbsp;<span id="disShow"></span></td>
	    </tr>
	    <tr>
	      <td align="right" width="150px">分类图片:</td><td align="left">&nbsp;&nbsp;<span id="dcategoryImage"></span></td>
	    </tr>
	    <tr>
	      <td align="right" width="150px">分类描述:</td><td align="left">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
	 	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
   </div>
 </div>