<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   //表单验证
		   
  })
  
</script>
<div id="updateWin">
    <form id="form2"  method="post">
        <input id="prosceniumProTypeId" type="hidden" name="prosceniumProType.prosceniumProTypeId" value="">
        <input id="productTypeId" type="hidden" name="prosceniumProType.productTypeId" value="">
        <input id="productTypeName" type="hidden" name="prosceniumProType.productTypeName" value="">
	    <table align="center" class="addOrEditTable" width="600px;">
	    	<tr>
		      <td class="toright_td" width="150px">套餐分类名称:&nbsp;&nbsp;</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<span id="uproductTypeName"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否显示:&nbsp;&nbsp;</td>
			  <td class="toleft_td" colspan="1">&nbsp;&nbsp;<input id="isShow_0" type="radio" name="prosceniumProType.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;<input id="isShow_1" type="radio" name="prosceniumProType.isShow" value="1"/>显示</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
