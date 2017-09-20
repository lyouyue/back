<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){
		$(".isPass").click(function(){
			$("#pissaveIsPass").val(this.value);
		});
		$(".phoneShowStatus").click(function(){
			$("#savePhoneShowStatus").val(this.value);
		});
		$("#pis").click(function(){
// 			校验输入的佣金抽成数值
			var reg=/^\d+(\.\d+)?$/;
			var s= $.trim($("#pcommission").val());
			if(s!=""){
				if(reg.test(s)){
					if(Number(s)>=Number(1) && Number(s)<=Number(100)){
						$("#csmsg").html("");
						tjp();
					}else{
						$("#csmsg").html("数值在1-100之间");
					}
				}else{
					$("#csmsg").html("请输入数字");
				}
			}else{
				$("#csmsg").html("");
				tjp();
			}
		});
	});
	function tjp(){
		$("pis").attr("disabled","disabled");
		var url="${pageContext.request.contextPath}/back/discountcoupon/saveOrUpdateispass.action";
		$.post(url,{discountCouponId:$("#pdiscountCouponID").val(),ispass:$.trim($("#pissaveIsPass").val())},function(data){
			if(data.isSuccess){
				closeWin();
				    $("#tt").datagrid("reload");
			}
		},'json');
	}
</script>
<div id="passWin">
        <input id="pdiscountCouponID" type="hidden" name="discountCoupon.discountCouponID" value=""/>
	    <table align="center" class="addOrEditTable" width="700px;" height="400px;">
	    	<tr>
		      <td class="toright_td" width="150px">优惠劵名称:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pdiscountCouponName" type="text" size="30" name="discountCoupon.discountCouponName" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">优惠券码:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pdiscountCouponCode" type="text" size="30" name="discountCoupon.discountCouponCode" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">优惠金额:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pdiscountCouponAmount" type="text" size="30" name="discountCoupon.discountCouponAmount" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">优惠下限金额:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pdiscountCouponLowAmount" type="text" size="30" name="discountCoupon.discountCouponLowAmount" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">开始时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pbeginTime" type="text" size="30" name="discountCoupon.beginTime" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">到期时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pexpirationTime" type="text" size="30" name="discountCoupon.expirationTime" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">发放个数:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pdistributionCount" type="text" size="30" name="discountCoupon.distributionCount" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">创建时间:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="pcreateTime" type="text" size="30" name="discountCoupon.createTime" readonly="readonly" /></td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">优惠券模板:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input style="border: 0" id="ptemplatetype" type="text" size="30" name="discountCoupon.createTime" readonly="readonly" /></td>
		    </tr>
<!-- 	    	<tr> -->
<!-- 		      <td class="toright_td" width="150px">优惠券图片:</td> -->
<!-- 		      <td class="toleft_td" colspan="3">&nbsp;&nbsp; -->
<!-- 		      <span id="pdiscountImage"></span> -->
<!-- 		      </td> -->
<!-- 		    </tr> -->
		    <tr>
		    	<td class="toright_td">是否通过:</td>
			    <td class="toleft_td" colspan="3">
			    	<input type="hidden" id="pissaveIsPass" value=""/>
			    	<input id="isPass_1"  type="radio" class="isPass" name="discountCoupon.isPass" value="1"/>待审核
			    	<input id="isPass_2"  type="radio" class="isPass" name="discountCoupon.isPass" value="2"/>通过
			    	<input id="isPass_3"  type="radio" class="isPass" name="discountCoupon.isPass" value="3"/>未通过
			    </td>
	    	</tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
		<a id="pis" class="easyui-linkbutton" icon="icon-save"  href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
