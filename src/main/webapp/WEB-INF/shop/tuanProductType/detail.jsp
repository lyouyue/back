<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="detailWin">
    <table align="center" class="addOrEditTable" width="400px">
    <tr>
      <td class="toright_td" width="150px">分类名称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortName"></span></td>
    </tr>
    <tr>
      <td class="toright_td" width="150px">分类编码:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="dsortCode"></span></td>
    </tr>
   </table>
   <div class="editButton"  data-options="region:'south',border:false" >
	   <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div>
 </div>  
