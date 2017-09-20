<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table style="text-align: center;" class="addOrEditTable">
   	    <tr><td style="text-align: right;width: 200px;">图片:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="view_photo"></span></td></tr>
	    <tr><td style="text-align: right;width: 200px;">信息标题:</td><td style="text-align: left;width: 500px;">&nbsp;&nbsp;<span id="dtitle"></span></td></tr>
	    <tr><td style="text-align: right;width: 200px;">信息分类:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dcategoryName"></span></td></tr>
	    <tr><td style="text-align: right;width: 200px;">摘要:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dbrief"></span></td></tr>
   		<tr><td style="text-align: right;width: 200px;">是否显示:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="disShow"></span></td></tr>
   		<tr><td style="text-align: right;width: 200px;">创建时间:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dcreateTime"></span></td></tr>
   		<tr><td style="text-align: right;width: 200px;">修改时间:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dupdateTime"></span></td></tr>
   		<tr><td style="text-align: right;width: 200px;">创建人:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dpublishUser"></span></td></tr>
   		<tr><td style="text-align: right;width: 200px;">修改人:</td><td style="text-align: left;">&nbsp;&nbsp;<span id="dmodifyUser"></span></td></tr>
    	<tr><td style="text-align: right;width: 200px;">信息内容:</td><td style="text-align: left;">
    		<div id="dcontent" style="width:550px; height:300px; overflow:auto; border:0px solid #000000;"></div>
    	</td></tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
</div>