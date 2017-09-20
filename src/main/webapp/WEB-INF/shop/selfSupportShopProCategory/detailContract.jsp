<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="600px">
	      <td class="toright_td" width="150px">分类名称:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dshopProCategoryName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">排序号:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	    </tr>
	    </tr>
	      <td class="toright_td" width="150px">是否显示:</td><td class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类图片:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dcategoryImage"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类描述:</td><td class="toleft_td">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
	 	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
   </div>
 </div>