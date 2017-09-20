<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" style="width:800px;">
	    <tr>
	      <td class="toright_td" width="150px">图片浏览:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dphoto"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcategoryName"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类描述:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类连接:</td><td  class="toleft_td" style="word-wrap:break-word;word-break:break-all;">&nbsp;&nbsp;<span id="dlink" ></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">排序:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">SEO关键字:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dkeywords"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">是否显示:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="disShow"></span></td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>  
