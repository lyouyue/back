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
                         url : "${pageContext.request.contextPath}/back/shopBrand/save.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 window.location.reload();
//                         	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
// 							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     //$("input.button_save").attr("disabled","disabled");
                  });
		       }
		    });
  })
  function findBrand(value){
	  $.ajax({
		   type: "POST", dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/shopBrand/findShopBrand.action",
		   data: {shopInfoId:value},
		   success: function(data){
			   $("#newBrand").html("");
			   var brandList = eval(data.brandList);
			   var brandHtml="<option  value='-1'>---请选择---</option>";
			   for(var i=0;i<brandList.length;i++){
				   brandHtml+="<option id='"+brandList[i].brandId+"' value='"+brandList[i].brandId+"'>"+brandList[i].brandName+"</option>";
			   }
			   $("#newBrand").html(brandHtml);
		   }
		});
  }
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
	    <table align="center" class="addOrEditTable" width="600px;">
	    	<tr>
		      <td align="center" width="150px">店铺名称:&nbsp;&nbsp;</td>
		      <td align="center" width="150px">
	      		<select id="" name="shopSelect" onchange="findBrand(this.value);">
	      			<option  value="-1">---请选择---</option>
			      	<s:iterator value="shopInfoList">
			      		<option id="${shopInfoId}" value="${shopInfoId}">${shopName}</option>
			      	</s:iterator>
	      		</select>
		      </td>
		    </tr>
		    <tr>
		      <td align="center" width="150px">品牌名称:&nbsp;&nbsp;</td>
		      <td align="center" width="150px">
		      	<select id="newBrand" name="brandSelect" >
		      		<option  value="-1">---请选择---</option>
			      	<s:iterator value="brandList">
			      		<option id="${brandId}" value="${brandId}">${brandName}</option>
			      	</s:iterator>
	      		</select>
		      </td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
