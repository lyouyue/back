<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/brandShowcase/saveOrUpdateBrandShowcase.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 	 $("#tt").datagrid("reload"); //保存后重新加载列表
						 	$("#brandShowcaseId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  $("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
   
   //根据品牌获得商品信息
  	 function getProductInfoList(){
	  	var html = "";
  		var brandId=$("#brandId").val();
  		$.ajax({
  			url:"${pageContext.request.contextPath}/brandShowcase/getProductListByBrandId.action",
  			type:"post",
  			dataType:"json",
  			data:{brandId:brandId},
  			success:function(data){
  				if(data.length>0){
	   				html +="<select id='productId' name='brandShowcase.productId'>";
	   				html +="<option value='-1'>---请选择商品---</option>";
	   				for(i=0;i<data.length;i++){
	   					html +="<option value='"+data[i].productId+"'>"+data[i].productFullName+"</option>";
	   				}
		         }
  				html +="</select>";
				$("#productHtml").html(html);
  			}
  		});
  	}
<%--  <s:if test='"+prodTypeList2[i].productTypeId+"=="+parentId2+"'>selected='selected'</s:if>--%>
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="brandShowcaseId" type="hidden" name="brandShowcase.brandShowcaseId" value="" noclear="true"/>
        <input id="brandId" type="hidden" name="brandShowcase.brandId" value="" noclear="true"/>
        <input id="productId" type="hidden" name="brandShowcase.productId" value="" noclear="true"/>
	    <table align="center" class="addOrEditTable" width="800px;">
			 <tr>
		      <td class="toright_td" width="150px">品牌:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           	<span id="brandInfoList"></span>
		      </td>
		    </tr>
			 <tr>
		      <td class="toright_td" width="150px">商品:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           	<span id="productHtml"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">主题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="title" type="text" name="brandShowcase.title" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">简介:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="synopsis" type="text" name="brandShowcase.synopsis" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">是否显示:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="isShow_0"  type="radio" name="brandShowcase.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;<input id="isShow_1"  type="radio" name="brandShowcase.isShow" value="1"/>显示</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value="" style="cursor:pointer;"/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
  </form>
</div>
