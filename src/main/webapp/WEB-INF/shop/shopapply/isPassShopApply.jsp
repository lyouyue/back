<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
  	$("#nextform").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/shopapply/saveOrNextShopApply.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
	                      }
	                  };  
	                  $("#nextform").ajaxSubmit(options);  
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="passWin">
  <form id="nextform" method="post" >
  <input id="ssid" type="hidden" name="shopApply.shopApplyId"/>
  <input id="scid" type="hidden" name="shopApply.shopCategoryId"/>
  <input id="ccid" type="hidden" name="shopApply.customerId"/>
  
    <table align="center" class="addOrEditTable" width="850px;">
		<tr>
			<td class="toright_td" width="150px">店铺分类:</td>
			<td class="toleft_td">&nbsp;&nbsp;
				<select id="dpfl" name="shopCategory.shopCategoryName" disabled="disabled">
				    	<s:iterator value="shopCategoryList">
				  			<option value="<s:property value="shopCategoryId"/>"><s:property value="shopCategoryName"/></option>
				  		</s:iterator>
	           </select>
		    </td>
	    </tr>
		<tr>
		    <td class="toright_td">会员名称:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="shymc" type="text" size="75" name="shopApply.customerName" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">店铺名称:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="sdpmc" type="text" size="75" name="shopApply.shopName" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">所在地区:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="sszdq" type="text" size="75" name="shopApply.region" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">详细地址:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="sxxdz" type="text" size="75" name="shopApply.address" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">邮政编码:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="syzbm" type="text" size="75" name="shopApply.postCode" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">联系电话:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="slxdh" type="text" size="75" name="shopApply.phone" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">身份证:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="ssfz" type="text" size="75" name="shopApply.IDCards" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">身份证图片:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<span id="ssfztp"></span><input id="insfztp" type="hidden" name="shopApply.IDCardsImage" />
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">执照照片:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<span id="ssfzzp"></span><input id="insfzzp" type="hidden" name="shopApply.permitImage" />
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">申请时间:</td>
		    <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
		    	<input id="ssqsj" type="text" size="75" name="shopApply.applyTime" readonly="readonly"/>
		    </td>
	    </tr>
	    <tr>
		    <td class="toright_td">审核是否通过:</td>
		    <td  class="toleft_td" colspan="3">
		    	<input type="radio" name="shopApply.isPass" value="1" checked="checked"/>是
		    	<input type="radio" name="shopApply.isPass" value="0"  />否
		    </td>
	    </tr>
    </table>
	<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>