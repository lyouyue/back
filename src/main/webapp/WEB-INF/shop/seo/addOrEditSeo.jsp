<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/shopseo/saveOrUpdateShopSeo.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					 	 $("#shopSeoId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="shopSeoId" type="hidden" name="shopSeo.shopSeoId" >
	    <table align="center" class="addOrEditTable">
		    <tr>
		      <td class="toright_td" width="150px">标题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="title" type="text" name="shopSeo.title" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">关键字:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="keywords" type="text" name="shopSeo.keywords" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">描述:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="description" type="text" name="shopSeo.description" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">类型来源:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="categorySource" type="text" name="shopSeo.categorySource" class="{validate:{required:true,maxlength:[25]}}"/></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
		</div>
  </form>
</div>
