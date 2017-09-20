<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">	
<div id="detailFansWin">
    <table align="center" class="addOrEditTable" width="800px">
	    <tr>
	      <td class="toright_td" width="150px">会员标识:</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_openid"></span></td>
	    </tr>
	     <tr>
	      <td class="toright_td" width="150px">昵称:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_nickname"></span></td>
	    </tr>
	     <tr>
	      <td class="toright_td" width="150px">名称备注:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_plateformRemark"></span></td>
	    </tr>
	     <tr>
	      <td class="toright_td" width="150px">性别:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_sexx"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员所在国家:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_country"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员所在省份:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_province"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员所在城市:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_city"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员语言:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_language"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">是否订阅该公众号:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_subscribe"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员备注:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_remark"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员关注时间:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_subscribeTime"></span></td>
	    </tr>
<!-- 	    <tr> -->
<!-- 	      <td class="toright_td" width="150px">UNIONID:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_unionid"></span></td> -->
<!-- 	    </tr> -->
	    <tr>
	      <td class="toright_td" width="150px">地理位置纬度:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_latitude"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员所在经度:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_longitude"></span></td>
	    </tr>
	    <tr>
	      <td class="toright_td" width="150px">会员所在精度:</td><td  class="toleft_td">&nbsp;&nbsp;<span id="d_precision"></span></td>
	    </tr>
   </table>
   <!-- <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
   </div> -->
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
	 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
 </div>