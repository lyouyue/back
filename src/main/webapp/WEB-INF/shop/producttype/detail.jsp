<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">	
	<table align="center" class="addOrEditTable" width="400px">
		<tr>
			<td class="toright_td" width="150px">PC端分类图片:</td><td colspan="3" class="toleft_td">&nbsp;&nbsp;<span id="dcategoryImage"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">微信端分类图片:</td><td colspan="3" class="toleft_td">&nbsp;&nbsp;<span id="dcategoryImageWx"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">APP端分类图片:</td><td colspan="3" class="toleft_td">&nbsp;&nbsp;<span id="dcategoryImageApp"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">PC分类名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortName"></span></td>
			<td class="toright_td" width="150px">APP分类名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortAppName"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">分类排序:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
			<td class="toright_td" width="150px">分类描述:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px">是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
			<td class="toright_td" width="150px">是否推荐:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disRecommend"></span></td>
		</tr>
		<%-- <tr>
			<td class="toright_td" width="150px">是否专业推荐:</td><td colspan="3" class="toleft_td">&nbsp;&nbsp;<span id="dindustrySpecific"></span></td>
		</tr> --%>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>  
