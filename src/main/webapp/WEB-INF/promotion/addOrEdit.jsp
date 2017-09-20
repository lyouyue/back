<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  		$("#form1").validate({meta: "validate", 
  	       submitHandler:function(form){
  	    	   $(document).ready(
	  	            function() {
		            	var obj = document.getElementById("customerId");
		                var txts = obj.options[obj.selectedIndex].text;
		                var options = {  
		                     url : "${pageContext.request.contextPath}/back/promotionapply/saveOrUpdatePromotionApply.action?customerNames="+encodeURIComponent(encodeURIComponent(txts))+"",
		                     type : "post",  
		                     dataType:"json",
		                     success : function(data) { 
		                    	closeWin();
		                    	$("#tt").datagrid("clearSelections");//删除后取消所有选项
								$("#tt").datagrid("reload"); //保存后重新加载列表
								$("#promotionApplyId").val(null);
			                      }
			                  };  
		                	  if(checkShopInfoId() == false){
		                		  $("#hshopName").html("<font color=\"red\">请选择会员名!</font>");
		                		  return false;
		                	  }else{}
				      		  if(checkEndTime() == false){
		                		  $("#hshopName").html("<font color=\"red\">该会员没有开通店铺!</font>");
		                		  return false;
		                	  }else{
		                		  $("#form1").ajaxSubmit(options);
		                		  $("input.button_save").attr("disabled","disabled");
		                	  }
	  	               
	  	            });
  	       }
  	    });
  })
  function checkShopInfoId(){
		var id = $("#customerId").val();
		var flag;
		if(id == -1){
			return false;
		}else{
			$.ajax({
				type: "POST", 
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/promotionapply/getCheckById.action",
				data: {ids:id},
				success: function(data){
					if(data == null){
						$("#hshopName").html("<font color=\"red\">该会员所在的店铺已关闭!</font>");
						flag = false
						return false;
					}else if(data == ""){
						$("#hshopName").html("<font color=\"red\">该会员没有开通店铺!</font>");
						flag = false
						return false;
					}else{
						$("#shopInfoId").val(data.shopInfoId);
						$("#shopName").val(data.shopName);
						$("#hshopName").html(data.shopName);
						flag = true
						return true;
					}
				}
			});
		}
  }
  function checkEndTime(){  
	    var beginTime=$("#beginTime").val(); 
	    var endTime=$("#endTime").val();  
	    if(beginTime == "" || endTime == ""){
	    	return false;
	    }else{
	    	var start=new Date(beginTime.replace("-", "/").replace("-", "/"));  
		    var end=new Date(endTime.replace("-", "/").replace("-", "/")); 
		    if(end<start){ 
		    	$("#sendTime").html("<font color=\"red\">活动结束时间不能小于活动开始时间!</font>");
		        return false;  
		    }
		    $("#sendTime").html("");
		    return true;
	    }
	} 
</script>
	<div id="addOrEditWin">
    <form id="form1"  method="post">
    	<input id="promotionApplyId" type="hidden" name="promotionApply.promotionApplyId"  noclear="true">
    	<input id="shopInfoId" type="hidden" name="promotionApply.shopInfoId" >
    	<input id="shopName" type="hidden" name="promotionApply.shopName" >
    	
	    <table align="center" class="addOrEditTable" width="850px;">
	    	<tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="promotionApply.customerId" onclick="checkShopInfoId()">
		           		<option value="-1">--请选择会员名称--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="customerName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		    <td class="toright_td">店铺名称:</td><td  class="toleft_td" colspan="3">&nbsp;&nbsp;<span id="hshopName"></span></td>
	    	</tr>
		    <tr>
		      <td class="toright_td" width="150px">开始时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="promotionApply.beginTime" id="beginTime" class="{validate:{required:true}}" onchange="checkEndTime()" />&nbsp;
				<img onclick="WdatePicker({el:'beginTime',dateFmt:'yyyy-MM-dd'})" 
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">结束时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;
		      	<input  type="text" name="promotionApply.endTime" id="endTime" class="{validate:{required:true}}" onchange="checkEndTime()" />&nbsp;
				<img onclick="WdatePicker({el:'endTime',dateFmt:'yyyy-MM-dd'})" 
				src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="20" height="25" align="middle"/>
		      	<span id="sendTime"></span>
		      </td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">促销活动详情:&nbsp;&nbsp;</td>
			      <td  class="toleft_td" colspan="3">&nbsp;&nbsp;
			       <textarea id="shopPromotionInfo" rows="8" cols="48" name="promotionApply.shopPromotionInfo" class="{validate:{required:true,maxlength:[2000]}}"></textarea>
			  </td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
