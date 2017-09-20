<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<style type="text/css">
	body{font-family: Arial, Helvetica, sans-serif;font-size:12px}
	li{list-style:none}
	.test_ul ul{ list-style:none; }
	.test_ul li{ float:left;margin-left:4.5px;width:16px;height:16px;font-size:15px; border: 1px solid #ccc;text-align: center;cursor: pointer;} 
	.onFirstWord{color:red;}
</style>
<script type="text/javascript">
$(function(){//表单验证
	   //表单验证
	    $("#form1").validate({meta: "validate", 
	       submitHandler:function(form){
	       $(document).ready(
              function() {  
            	  	var options = {  
                          url : "${pageContext.request.contextPath}/back/brandtype/saveMoreBrandType.action",  
                          type : "post",  
                          dataType:"json",
                          success : function(data) { 
                          closeWin();
           				  $("#tt").datagrid("reload"); //保存后重新加载列表
                          }
                      };
                    $("#form1").ajaxSubmit(options);  
                    $("input.button_save").attr("disabled","disabled");//防止重复提交
                 });
	       }
	    });
	    var firstWordArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0", "1", "2","3","4","5","6","7","8","9"]; 
	    var firstWordHtml="";
	    for(var i=0;i<firstWordArray.length;i++){
	    	firstWordHtml += "<li id='firstWord_"+firstWordArray[i]+"' onclick='dj(\""+firstWordArray[i]+"\")'>"+firstWordArray[i]+"</li>";
	    }
	    $("#firstWordS").html(firstWordHtml);
	  });
	  function dj(id){
		var va= $("#sb").val();
		$("#firstWord_"+va).removeAttr("class");
		$("#firstWord_"+id).attr("class","onFirstWord");
		$("#sb").val(id);
		  $.ajax({
			  type: "POST", dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/brandtype/findTypeBrand.action",
			   data:{id:id,productTypeId:'${productTypeId}'},
			   success: function(data){
				   list = data.list;
				   var html="";
				   html="<table class='addOrEditTable' width='100%'>";
					for(var i=0;i<list.length;i++){
						if((i+1)%4==1){
							html+="<tr>";
						}
						html+="<td width='25%'><input type='checkbox' name='brandIds' value='"+list[i].brandId+"'\/>&nbsp;&nbsp;&nbsp;&nbsp;"+list[i].brandName+"</td>";
						if((i+1)%4==0){
							html+="</tr>";
						}else{
							if((i+1)==list.length){
								html+="</tr>";
							}
						}
					}
					html+="</table>"; 
				$("#showBrandList").html(html);
			   }
		  });
	  }
</script>

<div>
	<ul class="test_ul" id="firstWordS"></ul>
</div>
<div style="clear:both; border-bottom: solid 1px #000;margin-top: 15px;height:5px;"></div>
<div id="addOrEditWin" style="margin-left: 44px;width:95%;">
	<input id="sb"  type="hidden" value="1">
    <form id="form1"  method="post" action="" >
    	<div id="showBrandList" style="margin-left: 40px;width:95%;"></div>
    	<input type="hidden" name="productTypeId" value="${productTypeId}" noclear="true"/>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>

