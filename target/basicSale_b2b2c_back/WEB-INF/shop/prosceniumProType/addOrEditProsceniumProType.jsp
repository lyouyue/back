<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   		$("#form1").form({
	        url:"${pageContext.request.contextPath}/prosceniumProType/saveProsceniumProType.action",
	        onSubmit:function(){
	        	var num=$("input[type=checkbox][name=productTypes][checked]").length;
				if(num==0){
					msgShow("系统提示", "<p class='tipInfo'>请选择分类！</p>", "warning");  
					return false;
				}
<%--		        	validateData();--%>
	        	return $(this).form("validate");
	        },
	        success:function(data){
	        	//$("input.button_save").attr("disabled","disabled");
	        	 window.location.reload(); //提交表单后重新刷新本页
	        }
	    }); 
  
  		 $("#form2").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/prosceniumProType/updateProsceniumProType.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
                         }
                     };  
                     $("#form2").ajaxSubmit(options);  
                     //$("input.button_save").attr("disabled","disabled");
                  });
		       }
		    });
  })
  
     function getProductTypeInfoList(){
		 var sortName=$("#sortName").val();
		 $.ajax({//获取MES牌号信息
			   type: "POST",
			   url: "${pageContext.request.contextPath}/prosceniumProType/listProductTypeInfo.action",
			   data: {sortName:sortName},
			   dataType: "JSON",
			   success: function(data){
				   var htmlStr="<tr style='background-color: #C4E1FF;font-weight: bolder;'><td width='8px' class='toleft_td'><input type='checkbox' onclick='checkedAll(this)'></td><td width='250px' class='toleft_td'>&nbsp;&nbsp;商品分类名称</td></tr>";
				   for(i=0;i<data.length;i++){
					   htmlStr+="<tr><td width='8px' class='toleft_td'><input type='checkbox' onclick='checkedOne(this)' class='productTypes'  id='"+i+"' name='productTypes' value='"+data[i].productTypeId+"_"+data[i].sortName+"'></td>"+
					   "<td width='250px' class='toleft_td'>&nbsp;&nbsp;"+data[i].sortName+"</td>";
				   }
				   $("#subTalbe").html(htmlStr);
			   }
		});
	 }
  
  // 选择所有
		function checkedAll(obj){//选中所有或者去掉所有选中的
			var isChecked=obj.checked;
		    if(isChecked){
		    	$(".productTypes").each(function() {
		    	    $(this).attr("checked", true);
		    	    var idIndex=$(this).attr("id");
<%--		    	    $("#dis_"+idIndex).css("display","");--%>
<%--		    	    $("#dis_"+idIndex).val("");--%>
<%--		    	    $("#dis_"+0).focus();--%>
		    	});
		    }else{
		    	$(".productTypes").each(function() {
		    	    $(this).attr("checked", false);
		    	    var idIndex=$(this).attr("id");
<%--		    	    $("#dis_"+idIndex).val(" ");--%>
<%--		    	    $("#dis_"+idIndex).css("display","none");--%>
		    	});
		    }
		}
    	// 选择一个
		function checkedOne(obj){
			var idIndex=obj.id;
			var isOneChedcked=obj.checked;
			if(isOneChedcked){
		    	$("#dis_"+idIndex).css("display","");
		    	$("#dis_"+idIndex).val("");
<%--		    	$("#dis_"+idIndex).focus();--%>
		    }else{
		    	$("#dis_"+idIndex).val(" ");
		    	$("#dis_"+idIndex).css("display","none");
		    }
		}
</script>
<div id="addOrEditWin">
    <form id="form1" action="post">
<%--				<input type="hidden" name="disproduct.promotionId" value="${promotionId}">--%>
				<table align="center" class="addOrEditTable">
					<tr>
						<td class="toright_td"width="100px;">商品分类信息：</td>
						<td class="toleft_td" height="10px;">
							<div style="margin:10px 10px 0px 10px">
								分类名称：<input type="text" name="sortName" id="sortName"/>
							 &nbsp;&nbsp;<span ><a href="javascript:getProductTypeInfoList();" id="btn1" iconCls="icon-search" >查询</a></span>
							</div>
							<div style="margin:0px 10px 10px 10px; width:600px;height:400px;overflow-y:scroll;">
		         		<table id="subTalbe" class="addOrEditTable" width="600px"></table>
	    		 	</div>
						</td>
					</tr>
				</table>
		<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
		</div>
	</form>
</div>
