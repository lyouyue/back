<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
    	var mony1=$("#discountCouponAmount").val();
    	var mony2=$("#discountCouponLowAmount").val();
    	if(parseInt(mony1)>parseInt(mony2)){
    		msgShow("系统提示", "<p class='tipInfo'>优惠券使用下限金额不能小于优惠金额！</p>", "warning");  
    	}else{
	       $(document).ready(
	            function() {
	               var options = {  
	                     url : "${pageContext.request.contextPath}/back/discountcoupon/saveOrUpdateDiscountCoupon.action",  
	                     type : "post",  
	                     dataType:"json",
	                     success : function(data) { 
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						 $("#tt").datagrid("reload"); //保存后重新加载列表
						 $("#ediscountCouponID").val(null);
		                      }
		                  };  
	               		  if(checkEndTime() == false){
	               			$("#sendTime").html("<font color=\"red\">活动结束时间不能小于当前时间!</font>");
	            	        return false; 
	               		  }else{
	               			$("#form1").ajaxSubmit(options); 
	               			$("input.button_save").attr("disabled","disabled");
	               		  }
               });
    	}
       }
  	
    });
  });
  
 function uploadDiscountImage() {
	$(document).ready(  
       function() {  
            var options = {  
                url : "${pageContext.request.contextPath}/back/discountcoupon/uploadImage.action",
                type : "post",  
                dataType:"json",
                success : function(data) {
                 if(data.discountImage=="false1"){
                   $("#mybigmessage").html(" <font style='color:red'>请选择上传图片</font>");
                 }else if(data.photoUrl=="false2"){
                   $("#mybigmessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
                 }else{
                  $("#udiscountImage").val(data.photoUrl);
                  $("#discountImages").html("");
                	 $("#discountImages").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='150px' height='150px' />");
                 } 
                }
            };
           $("#iDCardsImageForm").ajaxSubmit(options);
    });  
}
		
function checkEndTime(){  
	
	var d = new Date();
	var vYear = d.getFullYear();
	var vMon = d.getMonth() + 1;
	var vDay = d.getDate();
	var h = d.getHours();
	var m = d.getMinutes(); 
	var se = d.getSeconds(); 
	s = vYear+"-"+(vMon<10 ? "0" + vMon : vMon)+"-"+(vDay<10 ? "0"+"-"+ vDay : vDay);
	
    var expirationTime=$("#expirationTime").val(); 
    if(expirationTime == ""){
    	return false;
    }else{
    	var start=new Date(expirationTime.replace("-", "/").replace("-", "/"));  
	    var end=new Date(s.replace("-", "/").replace("-", "/")); 
	    if(end-start == 0){
	    	$("#sendTime").html("<font color=\"red\">活动结束时间不能小于当前时间!</font>");
	        return false; 
	    }
	    if(end > start){ 
	    	$("#sendTime").html("<font color=\"red\">活动结束时间不能小于当前时间!</font>");
	        return false;  
	    }
	    $("#sendTime").html("");
	    return true;
    }
    
} 

</script>
	<div id="addOrEditWin">
<!-- 	<form id="iDCardsImageForm" method="post" enctype="multipart/form-data"> -->
<!-- 	     <table align="center" class="addOrEditTable" width="750px;" height="400px;"> -->
<!-- 	          <tr> -->
<!-- 			      <td class="toright_td" width="150px">优惠券图片:&nbsp;&nbsp; </td> -->
<!-- 			      <td class="toleft_td" width="440px">&nbsp;&nbsp;&nbsp;&nbsp; -->
<!-- 			      	<input id="fileId" type="file" size="30" name="imagePath" /> -->
<!-- 		            <span id="msfzzp"></span> -->
<!-- 		  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadDiscountImage()"/> -->
<!-- 			      </td> -->
<!-- 			  </tr>  -->
<!-- 		 </table> -->
<!--    	</form> -->
    <form id="form1"  method="post">
    	<input id="ediscountCouponID" type="hidden" name="discountCoupon.discountCouponID"  noclear="true">
<!--     	<input id="udiscountImage" type="hidden" name="discountCoupon.discountImage"/> -->
	    <table align="center" class="addOrEditTable" width="750px;">
	    	<tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>优惠劵名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="discountCouponName" type="text" size="25" name="discountCoupon.discountCouponName" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>优惠金额:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="discountCouponAmount" type="text" size="25" name="discountCoupon.discountCouponAmount" class="{validate:{required:true,money:true,maxlength:[10]}}"/></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>优惠券使用下限金额:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="discountCouponLowAmount" type="text" size="25" name="discountCoupon.discountCouponLowAmount" class="{validate:{required:true,money:true,maxlength:[10]}}"/></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>发放个数:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="restrictCount" type="text" size="25" name="discountCoupon.distributionCount" class="{validate:{required:true,digits:true,maxlength:[8],min:1}}"/></td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>开始时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="discountCoupon.beginTime" id="beginTime" onclick="WdatePicker({el:'beginTime',dateFmt:'yyyy-MM-dd'})" class="{validate:{required:true}}"/>&nbsp;
				<label class="error" for="beginTime" generated="true"></label>
		      </td>
		    </tr>
		    
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>到期时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="discountCoupon.expirationTime" id="expirationTime" onclick="WdatePicker({el:'expirationTime',dateFmt:'yyyy-MM-dd'})" class="{validate:{required:true}}" onchange="checkEndTime()" />&nbsp;
		      	<label class="error" for="expirationTime" generated="true"></label>
		      	<span id="sendTime"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>优惠券模板:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<select style="width:150px" id="templatetype" name ="discountCoupon.templatetype" class="{validate:{required:true}}">
		      		<option value="">请选择</option>
		      		<option value="1">模板一</option>
		      		<option value="2">模板二</option>
		      		<option value="3">模板三</option>
		      		<option value="4">模板四</option>
		      	</select>
		      </td>
		    </tr>
<!-- 		    <tr> -->
<!-- 		      <td class="toright_td" width="150px">优惠券图片预览 :</td> -->
<!-- 		      <td  class="toleft_td">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
<!-- 		      	<span id="discountImages" ></span> -->
<!-- 		      </td> -->
<!-- 			</tr> -->
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</form>
</div>
