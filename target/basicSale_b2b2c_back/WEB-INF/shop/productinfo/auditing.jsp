<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
	$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
			function() {
				var auditComment = $("#auditComment").val();
				var isPassValue = $("input[name='isPass'][checked]").val();
				 var isShowValue=$("input[name='isShow'][type='radio']:checked").val();
				if(isPassValue==0&&(auditComment==null||auditComment=='')){
					msgShow("系统提示", "<p class='tipInfo'>审核未通过时，未通过原因必填！</p>", "warning");  
				}else{
					var options = {  
						url : "${pageContext.request.contextPath}/back/productinfo/saveOrUpdateProductInfo.action",  
						type : "post",  
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){//审核成功
								closeWin();
								$("#tt").datagrid("clearSelections");//删除后取消所有选项
								$("#tt").datagrid("reload"); //保存后重新加载列表
								$("#productId").val(null);
							}else{
								msgShow("系统提示", "<p class='tipInfo'>审核失败，请重试！</p>", "warning");  
							}
						}
					};
					$("#form1").ajaxSubmit(options); 
					$("input.button_save").attr("disabled","disabled");//防止重复提交
				}
			});
		}
	});
});

function changeIsPass(id){
	/**修改审核单选框选中状态**/
	$("input[name='isPass']").each(function(i) {
		$(this).removeAttr("checked");
	});
	$("#isPass_"+id).attr("checked","checked");
	if(id==0){
		$("#btMessage").html("<i class='ColorRed'>*</i>&nbsp;&nbsp;");
	}else{
		$("#btMessage").html("");
	}
	/**修改审核单选框选中状态**/
	var is_1 = document.getElementById("isPutSale_1");//不上架
	var is_2 = document.getElementById("isPutSale_2");//上架
	//var is_3 = document.getElementById("isPutSale_3");//违规下架
	if(id==1){//审核通过  上架
		is_2.checked="checked";
		is_1.disabled="disabled";
		//is_3.disabled="disabled";
		is_2.disabled="";
	}else if(id==3){//待审核
		is_1.checked="checked";
		is_2.disabled="disabled";
		//is_3.disabled="disabled";
		is_1.disabled="";
	}else{//自营商品审核未通过  未下架
		is_1.checked="checked";
		//is_3.disabled="disabled";
		is_2.disabled="disabled";
		is_1.disabled="";
	}
	/**修改审核单选框选中状态**/
	/**修改审核单选框选中状态 begin**/
	/* var is_1 = document.getElementById("isPutSale_1");
	var is_2 = document.getElementById("isPutSale_2");
	if(id==1){//上架
		is_2.checked="checked";
		is_1.disabled="disabled";
		is_2.disabled="";
	}else{//不上架
		is_1.checked="checked";
		is_2.disabled="disabled";
		is_1.disabled="";
	} */
	/**修改审核单选框选中状态 end**/
	//审核不通过时，默认选中不推荐、不显示
	var isRecommend_0 = document.getElementById("isRecommend_0");//不推荐
	var isShow_0 = document.getElementById("isShow_0");//不显示
	var isRecommend_1 = document.getElementById("isRecommend_1");//推荐
	var isShow_1 = document.getElementById("isShow_1");//显示
	if(id==0){//审核未通过
		isRecommend_0.checked="checked";
		isRecommend_1.disabled="disabled";
		isRecommend_0.disabled="";
		isShow_0.checked="checked";
		isShow_1.disabled="disabled";
		isShow_0.disabled="";
	}else{
		isRecommend_1.disabled="";
		isRecommend_0.disabled="";
		isShow_1.disabled="";
		isShow_0.disabled="";
	}
	
}
</script>
<div id="addOrEditWin">
	
	<form id="form1"  method="post" enctype="multipart/form-data">
		<input id="productId" type="hidden" name="productId" value="">
		<input type="hidden" name="isTop" value="0" noclear="true"/>
		<table align="center" class="addOrEditTable" width="900px;" style="margin-left:50px;">
			<tr>
				<td class="toright_td" width="150px">审核状态:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="isPass_3" type="radio" name="isPass" value="3" onclick="changeIsPass(this.value)"/>待审核&nbsp;&nbsp;&nbsp;
					<input id="isPass_1" type="radio" name="isPass" value="1" onclick="changeIsPass(this.value)"/>审核通过&nbsp;&nbsp;&nbsp;
					<input id="isPass_0" type="radio" name="isPass" value="0" onclick="changeIsPass(this.value)"/>未通过&nbsp;&nbsp;&nbsp;
				<td class="toright_td" width="150px">是否上架:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="isPutSale_1" type="radio" name="isPutSale" value="1"/>未上架&nbsp;&nbsp;&nbsp;
					<input id="isPutSale_2" type="radio" name="isPutSale" value="2"/>上架&nbsp;&nbsp;&nbsp;
					<!-- <input id="isPutSale_3" type="radio" name="isPutSale" value="3"/>违规下架 -->
				</td>
			</tr>
			
			<tr>
			<!-- <td class="toright_td" width="150px">是否置顶:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="isTop_0" type="radio" name="isTop" value="0"/>否&nbsp;&nbsp;&nbsp;<input id="isTop_1" type="radio" name="isTop"  value="1"/>是</td> -->
				<td class="toright_td" width="150px">是否推荐:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="isRecommend_0" type="radio" name="isRecommend" value="0"/>否&nbsp;&nbsp;&nbsp;
					<input id="isRecommend_1" type="radio" name="isRecommend" value="1"/>是</td>
				<td class="toright_td" width="150px">是否显示在列表:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="isShow_0" type="radio" name="isShow" value="0"/>不显示&nbsp;&nbsp;&nbsp;
					<input id="isShow_1" type="radio" name="isShow" value="1"/>显示
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span id="btMessage"></span>备注:&nbsp;&nbsp;</td>
				<td class="toleft_td" colspan="3">&nbsp;&nbsp;<textarea style="margin-top:10px;" id="auditComment" type="text" name="auditComment" value="" cols="70" rows="5"></textarea></td>
			</tr>
<!-- 		    <tr> -->
<!-- 		      <td class="toright_td" width="150px">是否为新商品:&nbsp;&nbsp;</td> -->
<!-- 			  <td class="toleft_td">&nbsp;&nbsp;<input id="isNew_0" type="radio" name="isNew" value="0"/>否&nbsp;&nbsp;&nbsp;<input id="isNew_1" type="radio" name="isNew" checked="checked" value="1"/>是</td> -->
<!-- 		      <td class="toright_td" width="150px">是否热销:&nbsp;&nbsp;</td> -->
<!-- 			  <td class="toleft_td">&nbsp;&nbsp;<input id="isHot_0" type="radio" name="isHot" value="0"/>否&nbsp;&nbsp;&nbsp;<input id="isHot_1" type="radio" name="isHot"  value="1"/>是</td> -->
<!-- 		    </tr> -->
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
