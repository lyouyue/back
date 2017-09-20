<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table align="center" style="width: 700px;" class="addOrEditTable">
    <tr>
      <td class="toright_td" width="125px">PC端分类图片:</td><td  class="toleft_td" style="width:160px;">&nbsp;&nbsp;<span id="dcategoryImage"></span></td>
    <!-- </tr>
    <tr> -->
      <td class="toright_td" width="125px">微信端分类图片:</td><td  class="toleft_td" style="width:160px;">&nbsp;&nbsp;<span id="dcategoryImageWx"></span></td>
    <!-- </tr>
    <tr> -->
      <td class="toright_td" width="125px">App端分类图片:</td><td  class="toleft_td" style="width:160px;">&nbsp;&nbsp;<span id="dcategoryImageApp"></span></td>
    </tr>
    <tr>
      <td style="text-align: right;width: 100px;">分类名称:</td>
      <td style="text-align: left; width:160px;">&nbsp;&nbsp;<span id="dsortName"></span></td>
   <!--  </tr>
    <tr> -->
      <td style="text-align: right;width: 100px;">App分类名称:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="dsortAppName"></span></td>
   <!--  </tr>
    <tr> -->
      <td style="text-align: right;width: 100px;">分类排序:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="dsortCode"></span></td>
    </tr>
    <tr>
      <td style="text-align: right;width: 100px;">分类描述:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
    <!-- </tr> -->
   <%--  <tr>
      <td style="text-align: right;width: 150px;">分类楼层:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="dfloor"></span></td>
    </tr>
    <tr>
      <td style="text-align: right;width: 150px;">首页分类ID:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="dcategoryDescription"></span></td>
    </tr> --%>
    <!-- <tr> -->
      <td style="text-align: right;width: 100px;">是否显示:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="disShow"></span></td>
    <!-- </tr>
    <tr> -->
      <td style="text-align: right;width: 100px;">是否推荐:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="disRecommend"></span></td>
    </tr>
    <tr>
      <td style="text-align: right;width: 100px;">所属级别:</td>
      <td style="text-align: left;">&nbsp;&nbsp;<span id="dlevel"></span></td>
    <!-- </tr>
    <tr> -->
      <td style="text-align: right;width: 100px;">分类ID:</td>
      <td style="text-align: left;" colspan="3">&nbsp;&nbsp;<span id="dproductTypeId"></span></td>
    </tr>
   </table>
	<!-- <div style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()"/>&nbsp;
	</div> -->
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
 </div>  
