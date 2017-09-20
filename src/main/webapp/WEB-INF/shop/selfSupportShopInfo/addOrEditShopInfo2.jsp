<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//修改企业信息
  	$("#form2").validate({meta: "validate", 
       submitHandler:function(form){
    	var imageUrl3=$("#imageUrl3").val();
    	var imageUrl4=$("#imageUrl4").val();
    	if(imageUrl3!=null && imageUrl3!='' || imageUrl4!=null && imageUrl4!=''){
    		if(imageUrl3!=null && imageUrl3!=''){
    			if(imageUrl4!=null && imageUrl4!=''){
	               var options = {
                     url : "${pageContext.request.contextPath}/back/selfSupportShopInfo/saveOrUpdateEnterprise.action",
                     type: "POST",
                     dataType: "JSON",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					 	 $("#ashopInfoId").val(null);
	                 }};
	              $("#form2").ajaxSubmit(options);  
	              $("input.button_save").attr("disabled","disabled");//防止重复提交
    			}else{
    				$("#mymessage4").html(" <font style='color:red'>请上传营业执照(三证合一)!</font>");
    				if(imageUrl3!=null && imageUrl3!=''){}else{
    					$("#mymessage3").html(" <font style='color:red'>请上传身份证!</font>");
    				}
    			}
    			}else{
    			$("#mymessage3").html(" <font style='color:red'>请上传身份证!</font>");
    			if(imageUrl4!=null && imageUrl4!=''){}else{
    				$("#mymessage4").html(" <font style='color:red'>请上传营业执照(三证合一)!</font>");
    			}
    		}
    		}else{
    		$("#mymessage3").html(" <font style='color:red'>请上传身份证!</font>");
     		$("#mymessage4").html(" <font style='color:red'>请上传营业执照(三证合一)!</font>");
    	}
       }
    });
  })

  function isRegionLocation(){
	  var country = $("#country").val();
	  $("#regionLocation").html("<option value='-1'>-----请选择州省地区-----</option>");
	  $.ajax({
		   type: "POST", dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/selfSupportShopInfo/selectCountry.action",
		   data: {ids:country},
		   success: function(data){
			   var length = data.length;
			   for(var i=0;i<length;i++){
				   $("#regionLocation").append($("<option value='"+data[i].districtInfoId+"'>"+data[i].districtName+"</option>"));
			   }
		   }
		});
  }
  function ischeckispass(){
	  var isPass = $("#eisPass").val();
	  if("" == isPass){
		  $("#cheIspass").html("<font color='red'>新添加时不能选择是!</font>");
		  $("#sc").attr("checked",false);
		  $("#cc").attr("checked",true);
		  return;
	  }else{
		  $("#cheIspass").html("");
	  }
	  if(isPass == "0"){
		  $("#cheIspass").html("<font color='red'>没有通过,不能选择是!</font>");
		  $("#sc").attr("checked",false);
		  $("#cc").attr("checked",true);
		  return;
	  }else{
		  $("#cheIspass").html("");
	  }
  }
  
  function cls(){
 	//捕获触发事件的对象，并设置为以下语句的默认对象
	with(event.srcElement)
	//如果当前值为默认值，则清空
	if(value==defaultValue) value=""
}
function res(){
//捕获触发事件的对象，并设置为以下语句的默认对象
with(event.srcElement)
//如果当前值为空，则重置为默认值
if(value=="") value=defaultValue
}
</script>
<div id="addOrEditWin2">
	<form id="photoForm3" method="post" enctype="multipart/form-data">
		<table align="center" class="addOrEditTable" width="850px" height="500px;">
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>身份证:&nbsp;&nbsp; </td>
				<td class="toleft_td" width="390px">
					&nbsp;&nbsp;<input id="fileId3" type="file" size="30" name="imagePath" />
					<span id="mymessage3"></span>
					<input id="buttonId3" type="button" value="上传预览" onclick="uploadPhoto('image_shopInfo','50px','50px','3')"/>
					<div class="imgMessage">提示：请上传规格宽120px，高60px的图片</div>
				</td>
				<td class="toright_td" width="165px">身份证预览 :&nbsp;&nbsp;</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="photo3"></span>
				</td>
			</tr> 
		 </table>
	</form>
	<form id="photoForm4" method="post" enctype="multipart/form-data">
		<table align="center" class="addOrEditTable" width="850px;" height="500px;">
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>营业执照(三证合一):&nbsp;&nbsp; </td>
				<td class="toleft_td" width="390px">
					&nbsp;&nbsp;<input id="fileId4" type="file" size="30" name="imagePath"/>
					<span id="mymessage4"></span>
					<input id="buttonId4" type="button" value="上传预览" onclick="uploadPhoto('image_shopInfo','50px','50px','4')"/>
					<div class="imgMessage">提示：请上传规格宽120px，高60px的图片</div>
				</td>
				<td class="toright_td" width="165px">营业执照(三证合一)预览 :&nbsp;&nbsp;</td>
				<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="photo4" ></span>
				</td>
			</tr> 
		 </table>
	</form>
	<form id="form2"  method="post">
        <input id="ashopInfoId" type="hidden" name="shopInfo.shopInfoId" value=""/>
        <input id="aIDCardsImage" type="hidden" name="shopInfo.IDCardsImage" value=""/>
        <input id="imageUrl3" type="hidden" name="shopInfo.businessLicense" value=""/>
        <input id="imageUrl4" type="hidden" name="shopInfo.companyDocuments" value=""/>
        <input id="ataxRegistrationDocuments" type="hidden" name="shopInfo.taxRegistrationDocuments" value=""/>
        <input id="averifier" type="hidden" name="shopInfo.verifier" value=""/>
        <input id="aisPass" type="hidden" name="shopInfo.isPass" value=""/>
        
	    <table align="center" class="addOrEditTable" width="850px;">
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>企业名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="acompanyName" type="text" size="30" name="shopInfo.companyName" class="{validate:{required:true,maxlength:[100]}}" /></td>
		      <td class="toright_td" width="165px"><span style="color:red">* </span>邮政编码:&nbsp;&nbsp;</td>
		      <td class="toleft_td"  width="139px;">&nbsp;&nbsp;<input id="apostCode" type="text"  style="width: 125px;" name="shopInfo.postCode" class="{validate:{required:true,maxlength:[100]}}" /></td>
		     </tr>
		    <tr>
		        <td class="toright_td" width="150px"><span style="color:red">* </span>详细地址:&nbsp;&nbsp;</td>
		        <td class="toleft_td" colspan="7">&nbsp;&nbsp;<input id="aaddress" type="text" size="61" name="shopInfo.address" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form2').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
  </form>
</div>
