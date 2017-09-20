<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){
		$(".isPass").click(function(){
			$("#usaveIsPass").val(this.value);
		});
		$(".phoneShowStatus").click(function(){
			$("#savePhoneShowStatus").val(this.value);
		});
		$("#newbu").click(function(){
// 			校验输入的佣金抽成数值
			var reg=/^\d+(\.\d+)?$/;
			var s= $.trim($("#pcommission").val());
			if(s!=""){
				if(reg.test(s)){
					if(Number(s)>=Number(1) && Number(s)<=Number(100)){
						$("#csmsg").html("");
						tj();
					}else{
						$("#csmsg").html("数值在1-100之间");
					}
				}else{
					$("#csmsg").html("请输入数字");
				}
			}else{
				$("#csmsg").html("");
				tj();
			}
		});
	});
	function tj(){
		$("newbu").attr("disabled","disabled");
		var url="${pageContext.request.contextPath}/back/discountcoupon/saveOrUpdateuseStatus.action";
		$.post(url,{discountCouponId:$("#udiscountCouponID").val(),useStatus:$.trim($("#usaveIsPass").val())},function(data){
			if(data.isSuccess){
				closeWin();
				    $("#tt").datagrid("reload");
			}
		},'json');
	}
</script>
<div id="useStatusWin">
     <input id="udiscountCouponID" type="hidden" name="discountCoupon.discountCouponID" value=""/>
	 <table align="center" class="addOrEditTable" width="700px;">
		    <tr>
		    	<td class="toright_td">是否通过:</td>
			    <td class="toleft_td" colspan="3">
			    	<input type="hidden" id="usaveIsPass" value=""/>
			    	<input id="isPass_6"  type="radio" name="discountCoupon.isPass" class="isPass" value="0" checked="checked"/>不启用
			    	<input id="isPass_5"  type="radio" name="discountCoupon.isPass" class="isPass" value="1"/>启用
			    </td>
	    	</tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="newbu" class="easyui-linkbutton" icon="icon-save"  href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
