<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//修改店铺信息
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
    	   var imageUrl1=$("#imageUrl1").val();
    	   var imageUrl2=$("#imageUrl2").val();
    	   if(imageUrl1!=null && imageUrl1!='' || imageUrl2!=null && imageUrl2!=''){
    		   if(imageUrl1!=null && imageUrl1!=''){
    			   if(imageUrl2!=null && imageUrl2!=''){
	               var options = {
                     url : "${pageContext.request.contextPath}/back/selfSupportShopInfo/saveOrUpdateShopInfo.action",
                     type: "POST",
                     dataType: "JSON",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 	 $("#tt").datagrid("reload"); //保存后重新加载列表
					 	 $("#wshopInfoId").val(null);
	                 }};
	              $("#form1").ajaxSubmit(options);  
	              $("input.button_save").attr("disabled","disabled");//防止重复提交
    		   }else{
    			   $("#mymessage2").html(" <font style='color:red'>请上传店铺首页大图!</font>");
    			   if(imageUrl1!=null && imageUrl1!=''){}else{
    				   $("#mymessage1").html(" <font style='color:red'>请上传店铺Logo!</font>");
    			   }
    		   }
   		   }else{
    		   $("#mymessage1").html(" <font style='color:red'>请上传店铺Logo!</font>");
    		   if(imageUrl2!=null && imageUrl2!=''){}else{
    			   $("#mymessage2").html(" <font style='color:red'>请上传店铺首页大图!</font>");
    		   }
    	   }
    	   }else{
    	   $("#mymessage1").html(" <font style='color:red'>请上传店铺Logo!</font>");
    	   $("#mymessage2").html(" <font style='color:red'>请上传店铺首页大图!</font>");
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
<div id="addOrEditWin">
<form id="photoForm1" method="post" enctype="multipart/form-data">
	<table align="center" class="addOrEditTable" width="850px;" height="500px;">
		<tr>
			<td class="toright_td" width="150px"><span style="color:red">* </span>店铺Logo:&nbsp;&nbsp; </td>
			<td class="toleft_td" width="328px;">
				&nbsp;&nbsp;<input id="fileId1" type="file" size="30" name="imagePath"/>
					<span id="mymessage1"></span>
				<input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_shopInfo','120px','120px','1')"/>
				<div class="imgMessage">提示：请上传规格宽120px，高60px的图片</div>
			</td>
			<td class="toright_td" width="150px">店铺Logo预览 :</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="photo1"></span>
			</td>
		</tr>
	</table>
</form>
<form id="photoForm2" method="post" enctype="multipart/form-data">
	<table align="center" class="addOrEditTable" width="850px;" height="500px;">
		<tr>
			<td class="toright_td" width="150px"><span style="color:red">* </span>店铺首页大图:&nbsp;&nbsp; </td>
			<td class="toleft_td" width="328px;">
				&nbsp;&nbsp;<input id="fileId2" type="file" size="30" name="imagePath"/>
					<span id="mymessage2"></span>
					<input id="buttonId2" type="button" value="上传预览" onclick="uploadPhoto('image_shopInfo','120px','120px','2')"/>
					<div class="imgMessage">提示：请上传规格宽120px，高60px的图片</div>
			</td>
			<td class="toright_td" width="150px">店铺首页大图预览 :</td>
			<td  class="toleft_td" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="photo2"></span>
			</td>
		</tr>
	 </table>
</form>
<form id="form1"  method="post">
    <input id="wshopInfoId" type="hidden" name="shopInfo.shopInfoId" value=""/>
    <input id="wids" type="hidden" name="ids" value=""/>
    <input id="wsaveIsPass" type="hidden" name="saveIsPass" value="0"/>
    <input id="imageUrl1" type="hidden" name="shopInfo.logoUrl" value=""/>
    <input id="imageUrl2" type="hidden" name="shopInfo.bannerUrl" value=""/>
	<table align="center" class="addOrEditTable" width="850px;">
		<tr> 
		    <td class="toright_td" width="150px"><span style="color:red">* </span>店铺名称:</td>
		    <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="wshopName" type="text" size="30" name="shopInfo.shopName" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    <td class="toright_td" width="150px"><span style="color:red">* </span>店铺类型:</td>
		    <td class="toleft_td" colspan="3">&nbsp;
		        <select id="wshopInfoType" name="shopInfo.shopInfoType" style="width:127px;" >
		            <option value="-1">--请选择店铺类型--</option>
				  	<option value="1">平台自营店铺</option>
				  	<option value="2">平台加盟店铺</option>
		        </select>
		   </td>
	   </tr>
	   <tr>
		   <td class="toright_td" width="150px"><span style="color:red">* </span>店铺分类:</td>
		   <td class="toleft_td" colspan="3">&nbsp;
		       <select id="wshopCategoryId" name="shopInfo.shopCategoryId" class="querySelect">
		          <option value="-1">--请选择店铺分类--</option>
				  <s:iterator value="shopCategoryList">
				  	<option value="<s:property value="shopCategoryId"/>"><s:property value="shopCategoryName"/></option>
				  </s:iterator>
		       </select>
	   	   </td>
		   <td class="toright_td" width="150px"><span style="color:red">* </span>店铺模板:</td>
		   <td class="toleft_td" colspan="3">&nbsp;
		        <select id="wtemplateSet" name="shopInfo.templateSet" style="width:127px;">
				  	<option value="1">--店铺模板(一)--</option>
				  	<option value="2">--店铺模板(二)--</option>
				  	<option value="3">--店铺模板(三)--</option>
				  	<option value="4">--店铺模板(四)--</option>
				  	<option value="5">--店铺模板(五)--</option>
		        </select>
		   </td>
		</tr>
		<tr>
		    <td class="toright_td" width="150px"><span style="color:red">* </span>主要销售产品:</td>
		    <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="wmainProduct" type="text" size="30" name="shopInfo.mainProduct"  onfocus="cls()" onblur="res()" value="product(,)product(,)product(,)product" class="{validate:{required:true,maxlength:[300]}}"/><font style="color: red">&nbsp;&nbsp;&nbsp;&nbsp;注:按照表格内格式</font></td>
		    <td class="toright_td" width="150px"><span style="color:red">* </span>联系电话:</td>
		    <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="wphone" type="text" size="30" name="shopInfo.phone" class="{validate:{required:true,maxlength:[30]}}"/></td>
	    </tr>
	    <tr>
		   	<td class="toright_td">店铺地址:</td>
		   	<td class="toleft_td" colspan="7">&nbsp;&nbsp;<input id="waddressForInvoice" type="text"  size="30" name="shopInfo.addressForInvoice" class="{validate:{maxlength:[100]}}"/></td>
	    </tr>
		<tr>
			<td class="toright_td" width="150px">运费:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="wpostage" type="text" size="30" name="shopInfo.postage"  /></td>
			<td class="toright_td" width="150px">订单是否包邮:</td>
			<td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="wminAmount" type="text" size="30" name="shopInfo.minAmount"  /></td>
		</tr>
		<tr>
			<td class="toright_td" width="150px"><span style="color:red">* </span>营业时间:</td>
			<td class="toleft_td" colspan="7">&nbsp;
				<input id="wbusinessHoursStart" type="text" size="30" name="shopInfo.businessHoursStart" class="{validate:{required:true,maxlength:[100]}}"/>
				至<input id="wbusinessHoursEnd" type="text" size="30" name="shopInfo.businessHoursEnd" class="{validate:{required:true,maxlength:[100]}}"/>
			</td>
		</tr>
		<tr>
			<td class="toright_td">店铺简介:</td>
			<td class="toleft_td" colspan="7">
				&nbsp;&nbsp;<textarea id="wsynopsis"  name="shopInfo.synopsis" class="{validate:{maxlength:[1000]}}" style="line-height:20px; height:60px; width:700px; font-size:12px;resize: none;overflow-y:scroll;" cols="60" rows="5" name="shopInfo.synopsis" wrap="scroll"></textarea>
				</td>
		</tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</form>
</div>
