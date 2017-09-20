<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="600px">
	    <tr>
	      <td class="toright_td" width="150px">图片浏览:</td><td  class="toleft_td" width="150px" colspan="3">&nbsp;&nbsp;<span id="dphoto"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类名称:</td><td  class="toleft_td" width="150px">&nbsp;&nbsp;<span id="dcategoryName"></span></td>
	      <td class="toright_td" width="150px">分类类型:</td><td  class="toleft_td" width="150px">&nbsp;&nbsp;<span id="dcategoryType"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">排序:</td><td  class="toleft_td" width="150px">&nbsp;&nbsp;<span id="dsortCode"></span></td>
	      <td class="toright_td" width="150px">是否显示:</td><td  class="toleft_td" width="150px">&nbsp;&nbsp;<span id="disShow"></span></td>
	    </tr>
	    
	    <tr>
	      <td class="toright_td" width="150px">分类更多链接:</td><td  class="toleft_td" width="450px"  colspan="3">&nbsp;&nbsp;<span id="dmoreUrl"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">App分类更多链接:</td><td  class="toleft_td" width="450px"  colspan="3">&nbsp;&nbsp;<span id="dmoreAppUrl"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">分类描述:</td><td  class="toleft_td" width="450px"  colspan="3">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">SEO关键字:</td><td  class="toleft_td" width="450px"  colspan="3">&nbsp;&nbsp;<span id="dkeywords"></span></td>
	    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
   		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>  
