<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
   //上传图片 
	function uploadPhoto() {
		$(document).ready(  
			function() {  
				var options = {  
					url : "${pageContext.request.contextPath}/back/sellersStrategy/uploadImage.action",
					type : "post",  
					dataType:"json",
					success : function(data) {
						if(data.photoUrl=="false1"){
							$("#bigmymessage").html(" <font style='color:red'>请选择上传图片</font>");
						}else if(data.photoUrl=="false2"){
							$("#bigmymessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
						}else{
							$("#levelIcon").val(data.photoUrl);
							$("#photo").html("");
							$("#photo").html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='120px' height='120px' />");
						} 
					}
				};
			$("#photoFormBig").ajaxSubmit(options);
		});  
	}
	
	//查询级别是否存在
	function checkSellersLevel(){
		var value = $("#sellersLevel").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/sellersStrategy/checkSellersLevel.action",
				data:{sellersLevel:value},
				success:function(data){
					if(data == "ok"){
						$("#sellersRank_1").html("<em style='color:green'>未添加</em>");
						$("#save").css("display","");
					}else{
						$("#sellersRank_1").html("<em style='color:red'>该级别以存在,请修改或更换级别</em>");
						$("#loginName").focus();
						$("#save").css("display","none");
					}
				}
			});
		}else{
			$("#sellersRank_1").html("");
		}
	}
</script>
  <div id="addOrEditWin">
  		<!--//right-->
		<!-- 异步上传图片 -->
  		<form id="photoFormBig" method="post" enctype="multipart/form-data">
			<table align="center" class="addOrEditTable" width="600px;">
				<tr>
					<td class="toright_td" width="150px">等级图标:&nbsp;&nbsp; </td>
					<td class="toleft_td" width="440px">
						<input id="fileId" type="file"  name="imagePath"/>
							<span id="bigmymessage"></span><br/>
						<input id="buttonId" type="button" value="上传预览" onclick="return uploadPhoto()"/>
							<span><font id="tishi" color="red"></font><font color="red">提示：请上传100x100像素的图像</font></span>
						<br/>
					</td>
				</tr> 
			</table>
		</form>
		<form id="form1"  method="post" action="">
			<input id="sellersLevelId" type="hidden" name="sellersStrategy.sellersLevelId" value="" noclear="true"/>
			<input id="levelIcon" type="hidden" name="sellersStrategy.levelIcon" value="" noclear="true"/>
				<table align="center" class="addOrEditTable" width="600px;">
					<tr id="SLevel_1">
						<td class="toright_td" width="150px">卖家等级:&nbsp;&nbsp;</td>
						<td  class="toleft_td" width="440px">&nbsp;&nbsp;
							<select id="sellersLevel" name="sellersLevel" >
								<option value="-1" >--请选择--</option>
								<s:iterator value="#application.keybook['sellersStrategyLevel']" var="kb">
									<option onclick="checkSellersLevel();" id="opt_<s:property value="#kb.value"/>" value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
								</s:iterator>
							</select>
							<script type="text/javascript">
								$("#sellersLevel").change(function(){
									$("#sellersRank").val($("#opt_"+$(this).val()).text());
								});
							</script>
						</td>
					</tr>
					<tr id="SRank_1">
						<td class="toright_td" width="150px">卖家头衔:&nbsp;&nbsp;</td>
						<td  class="toleft_td">&nbsp;&nbsp;
							<input id="sellersRank" type="text" name="sellersStrategy.sellersRank" readonly="readonly" class="{validate:{required:true,maxlength:[100]}}"/>
							<span id="sellersRank_1"></span>
						</td>
					</tr>
					<tr>
						<td class="toright_td" width="150px">等级折扣值(%):&nbsp;&nbsp;</td>
						<td class="toleft_td">&nbsp;&nbsp;
							<input id="levelDiscountValue" type="text" name="sellersStrategy.levelDiscountValue" class="{validate:{required:true,maxlength:[2]}}"/>
						</td>
					</tr>
					<tr id="djtb">
		      			<td class="toright_td" width="150px">等级图标:&nbsp;&nbsp;</td>
		      			<td  class="toleft_td"><div id="photo"></div></td>
		    		</tr>
					<tr id="zxck">
						<td class="toright_td" width="150px">最小参考值:&nbsp;&nbsp;</td>
						<td class="toleft_td">&nbsp;&nbsp;
							<input id="minRefValue" type="text" name="sellersStrategy.minRefValue" class="{validate:{required:true,maxlength:[4]}}"/>
						</td>
					</tr>
					<tr id="zdck">
						<td class="toright_td" width="150px">最大参考值:&nbsp;&nbsp;</td>
						<td class="toleft_td">&nbsp;&nbsp;
							<input id="maxRefValue" type="text" name="sellersStrategy.maxRefValue" class="{validate:{required:true,maxlength:[4]}}"/>
						</td>
					</tr>
			   </table>
			   <div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			   </div>
	</form>
</div>
