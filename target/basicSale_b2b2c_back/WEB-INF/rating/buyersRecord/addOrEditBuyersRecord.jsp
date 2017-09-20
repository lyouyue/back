<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
 <script type="text/javascript">
/*  $(function(){
		//表单验证
		$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
		function() {
				var id=$('input[name="buyersLevel"]:checked').val();
				if( id !=$("#dbuyersLevel").val()){
				var options = {
				url : "${pageContext.request.contextPath}/back/buyersRecord/savaOrUpdateBuyersRecord.action?buyersLevel="+id,
				type : "post",  
				dataType:"json",
					success : function(data) { 
						closeWin();
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload"); //保存后重新加载列表
					}
				};  
			/* 	$("#remark").val(KindEditor.instances[0].html()); 
				$("#form1").ajaxSubmit(options);
				$("input.button_save").attr("disabled","disabled");//防止重复提交
			}
		});
	}
	});	
 }); */
 //买家等级升迁
 function customerBuyers(){
		var id=$('input[name="buyersLevel"]:checked').val();
		var customerId=$("#customerId").val();
		var remark=$("#remark").val();
		if( id !=$("#dbuyersLevel").val()){
			if(remark !=""){
				$.ajax({
					type: "POST",
					dataType: "JSON",
					url : "${pageContext.request.contextPath}/back/buyersRecord/savaOrUpdateBuyersRecord.action",
					data: {id:id,remark:remark,customerId:customerId},
					success: function(data){
					if(data.isSuccess=="true"){
						$("#tt").datagrid("reload"); //保存后重新加载列表
					}else{
						msgShow("系统提示", "<p class='tipInfo'>请重新选择，操作失败！</p>", "warning");
					}
						closeWin();
					}
				});
			}else{
				msgShow("系统提示", "<p class='tipInfo'>备注不能为空，请重新操作！</p>", "warning");
			}
		}else{
			msgShow("系统提示", "<p class='tipInfo'>请重新选择，操作失败！</p>", "warning");
		}
 }
</script>
  <div id="addOrEditWin">
		<form id="form1"  method="post" action="">
			<input id="ratingRecordId" type="hidden" name="buyersRecord.ratingRecordId" value="" noclear="true"/>
			<input id="customerId" type="hidden" name="buyersRecord.customerId" value="${customerId}" noclear="true"/>
			<input id="dbuyersLevel" type="hidden" name="buyersRecord.buyersLevel" value="" noclear="true"/>
				<table align="center" class="addOrEditTable" style="width: 700px;">
					<tr>
		      			<td class="toright_td" width="50px">操作人:</td>
		      			<td  class="toleft_td"><span style="color:green;font-weight:bolder">${sessionScope.users.userName}</span></td>
		    		</tr>
					<tr>
						<td class="toright_td" width="70px">等级策略:</td>
		     				<td class="toleft_td" width="300px" >
		     					<table class="toleft_td" class="addOrEditTable" style="width:610px; margin-top:0">
		     						<tr>
		     							<td style="font-weight:bold;">选择</td><td style="font-weight:bold;">买家等级</td><td style="font-weight:bold;">买家头衔</td><td style="font-weight:bold;">等级折扣值(%) </td><td style="font-weight:bold;">等级图标</td>
		     							<td style="font-weight:bold;">最小参考值</td><td style="font-weight:bold;">最大参考值</td><!-- <th>授信额度(￥)</th><th>授信期限(天)</th> -->
		     						</tr>
		     						<s:iterator value="listBuyersStrategy" var="lb" status="s">
			     						<tr>
			     							<td>
			     								<input  type="radio" id="level_<s:property value='#lb.buyersLevel'/>" name="buyersLevel" <s:if test="#s.index==0">checked="checked"</s:if> value="<s:property value='#lb.buyersLevel'/>">
			     							</td>
			     							<td><s:property value='#lb.buyersLevel' /></td>
			     							<td><s:property value='#lb.buyerRank' /></td>
			     							<td><s:property value='#lb.levelDiscountValue' /></td>
			     							<td><div><img src='<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/><s:property value='#lb.levelIcon' />'  /></div></td>
			     							<td><s:property value='#lb.minRefValue' /></td>
			     							<td><s:property value='#lb.maxRefValue' /></td>
			     							<%-- <td><s:property value='#lb.lineOfCredit' /></td>
			     							<td><s:property value='#lb.creditDate' /></td> --%>
			     						</tr>
		     						</s:iterator>
		     					</table>
		     				</td>
		    		</tr>
		    		<tr>
				      <td class="toright_td" width="50px"><span style="color:red">* </span>备注:</td>
				      <td class="toleft_td">
				      	<textarea id="remark" rows="3" cols="40" style="width:604px;height:35px;" name="buyersRecord.remark" class="{validate:{required:true,maxlength:[250]}}"></textarea>
				      </td>
				    </tr>
				</table>
			    <div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="customerBuyers()" href="javascript:;">保存</a>
			    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			    </div>
	</form>
  </div>
