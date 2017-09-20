<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   //表单验证
	    $("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
              function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/back/shoppingCart/saveOrUpdateShoppingCart.action",  
                        type : "post",  
                        dataType:"json",
                        success : function(data) { 
                       	 closeWin();
                       	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 $("#tt").datagrid("reload"); //保存后重新加载列表
						 $("#shopCartId").val(null);
                        }
                    };  
                    $("#form1").ajaxSubmit(options); 
                    //$("input.button_save").attr("disabled","disabled");
                 });
	       }
	    });
  })
  
  function getShopInfoId(){
   		var shopInfoId=$("select option:selected").val();
   		getProductByShopInfoId(shopInfoId);
   	}
 	function getProductByShopInfoId(shopInfoId){
  		$.ajax({
  			url:"${pageContext.request.contextPath}/back/shoppingCart/findProductListByShopInfoId.action",
  			type:"post",
  			dataType:"json",
  			data:{shopInfoId:$("#shopInfoId").val()},
  			success:function(data){
  				var productList=data;
  				if(productList.length>0){
	   				var htmlStr="<select id='productId' name='shoppingCart.productId'>";
	   				htmlStr+="<option>---请选择套餐---</option>";
	   				for(i=0;i<productList.length;i++){
	   					htmlStr+="<option value='"+productList[i].productId+"'>"+productList[i].productFullName+"</option>"
	   				}
 		            htmlStr+="</select>";
 		            $("#product").html(htmlStr);
		        }else{
		        	$("#product").html("<font color='red'>此店铺没有套餐！</font>");
		        }
  			}
  		});
   	}
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="shopCartId" type="hidden" name="shoppingCart.shopCartId" value="">
        <input id="createTime" type="hidden" name="shoppingCart.createTime" value="">
        <input id="ucustomerId" type="hidden" name="customerId" value="">
        <input id="uproductId" type="hidden" name="productId" value="">
        <input id="ushopInfoId" type="hidden" name="shopInfoId" value="">
        
	    <table align="center" class="addOrEditTable" width="600px;">
	    	<tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
			      <div id="cusadd" style="display: ">
			           <select id="customerId" name="shoppingCart.customerId">
			              <option value="-1">--请选择会员--</option>
						  <s:iterator value="customerList">
						  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
						  </s:iterator>
			           </select>
			      </div>
			     <div id="cusupdate" style="display: none;">
			     	<span id="cusName"></span>
			     </div>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">店铺名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
			      <div id="shopadd" style="display: ">
			           <select id="shopInfoId" name="shoppingCart.shopInfoId" onchange="getShopInfoId();">
			              <option value="-1">--请选择店铺--</option>
						  <s:iterator value="shopInfoList">
						  	<option value="<s:property value="shopInfoId"/>"><s:property value="shopName"/></option>
						  </s:iterator>
			           </select>
			      </div>
			      <div id="shopupdate" style="display: none;">
			      	<span id="shName"></span>
			      </div>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		          <span id="product"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐数量:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="quantity" type="text" name="shoppingCart.quantity" class="{validate:{required:true,maxlength:[4]}}"/></td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
