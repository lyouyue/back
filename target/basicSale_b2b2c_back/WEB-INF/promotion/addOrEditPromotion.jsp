<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){//表单验证
	$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
			var endTime=$("#endTime").val(); 
			var beginTime=$("#beginTime").val(); 
			var imageUrl1=$("#imageUrl1").val();
			var imageUrl2=$("#imageUrl2").val();
			if(endTime!=null&&endTime!=''&beginTime!=null&beginTime!=''){
				if(imageUrl1 !=null && imageUrl1!='' || imageUrl2!=null && imageUrl2!=''){
					if(imageUrl1 !=null && imageUrl1!=''){
					if(imageUrl2!=null && imageUrl2!=''){
					$(document).ready(
					function() {  
						var options = {
						url : "${pageContext.request.contextPath}/back/promotion/saveOrUpdatePromotion.action",  
						type : "post",  
						dataType:"json",
						success : function(data) { 
								closeWin();
								$("#tt").datagrid("clearSelections");//保存后取消所有选项
								$("#tt").datagrid("reload"); //保存后重新加载列表
								$("#promotionId").val(null);
								$("input.button_save").removeAttr("disabled");//解除提交锁定
								}
						};
							if(checkEndTime() == false){
									$("#sendTime").html("<font color=\"red\">活动结束时间不能小于开始时间!</font>");
									return false; 
							}else{
								$("#shopPromotionInfo").val(KindEditor.instances[0].html());
									var length = $("#shopPromotionInfo").val().length;
									if(length>1000){
										msgShow("系统提示", "<p class='tipInfo'>简介内容不能超过1000！</p>", "warning");  
									}else{
										$("#form1").ajaxSubmit(options);
										$("input.button_save").attr("disabled","disabled");
									}
							}
					});
			}else{
				$("#mymessage2").html("<font color='Red'>请上传促销活动小海报！</font>");
				if(imageUrl1!=null && imageUrl1!=''){}else{
					$("#mymessage1").html("<font color='Red'>请上传促销活动大海报！</font>");
				}
			}
			}else{
				$("#mymessage1").html("<font color='Red'>请上传促销活动大海报！</font>");
				if(imageUrl2!=null && imageUrl2!=''){}else{
					$("#mymessage2").html("<font color='Red'>请上传促销活动小海报！</font>");
				}
			}
			}else{
				$("#mymessage1").html("<font color='Red'>请上传促销活动大海报！</font>");
				$("#mymessage2").html("<font color='Red'>请上传促销活动小海报！</font>");
			}
			}else{
					msgShow("系统提示", "<p class='tipInfo'>请填写活动时间！</p>", "warning");  
				}
			
		}
		});
	})
	
	function checkEndTime(){  
		var d = new Date();
		var vYear = d.getFullYear();
		var vMon = d.getMonth() + 1;
		var vDay = d.getDate();
		var h = d.getHours();
		var m = d.getMinutes(); 
		var se = d.getSeconds(); 
		s = vYear+"-"+(vMon<10 ? "0" + vMon : vMon)+"-"+(vDay<10 ? "0"+"-"+ vDay : vDay);
		
		var endTime=$("#endTime").val(); 
		var beginTime=$("#beginTime").val(); 
		if(endTime == ""){
			return false;
		}else{
			var start=new Date(beginTime.replace("-", "/").replace("-", "/"));  
			var end=new Date(endTime.replace("-", "/").replace("-", "/")); 
			if(end-start == 0){
				$("#sendTime").html("<font color=\"red\">活动结束时间不能小于开始时间!</font>");
				return false; 
			}
			if(end < start){ 
				$("#sendTime").html("<font color=\"red\">活动结束时间不能小于开始时间!</font>");
				return false;  
			}
			$("#sendTime").html("");
			return true;
		}
	}
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
		<table align="center" class="addOrEditTable" width="800px;">
			<tr>
				<td class="toright_td" width="140px">促销活动大海报:&nbsp;&nbsp; </td>
				<td class="toleft_td" style="width:386px;">
				&nbsp;&nbsp;<input id="fileId1" type="file" name="imagePath"/>
				<span id="mymessage1"></span>
				<input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_promotion','30px','30px','1')"/>
					<!-- <font color="red">&nbsp;&nbsp;注意:我们建议您使用高300，宽1000的图片</font> -->
					<div class="imgMessage">提示：请上传规格宽1000px，高300px的图片</div>
				</td>
				<td class="toright_td" width="140px">大海报预览 :</td>
				<td  class="toleft_td">&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="photo1"></span>
				</td>
			</tr> 
		</table>
	</form>
	<form id="photoForm2" method="post" enctype="multipart/form-data">
		<table align="center" class="addOrEditTable" width="800px;">
			<tr>
				<td class="toright_td" width="140px">促销活动小海报:&nbsp;&nbsp; </td>
				<td class="toleft_td" style="width:386px;">
					&nbsp;&nbsp;<input id="fileId2" type="file" name="imagePath"/>
					<span id="mymessage2"></span>
					<input id="buttonId2" type="button" value="上传预览" onclick="uploadPhoto('image_promotion','30px','30px','2')"/>
					<div class="imgMessage">提示：请上传规格宽600px，高150px的图片</div>
				</td>
				<td class="toright_td" width="140px">小海报预览 :</td>
				<td  class="toleft_td">&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="photo2"></span>
				</td>
			</tr>
		</table>
	</form>
	<form id="form1"  method="post">
		<input id="promotionId" type="hidden" name="platformPromotion.promotionId" value="" noclear="true"/>
		<input id="promotionNumber" type="hidden" name="platformPromotion.promotionNumber" value=""/>
		<input id="isPass" type="hidden" name="platformPromotion.isPass" value=""/>
		<input id="imageUrl1" type="hidden" name="platformPromotion.largePoster" value=""/>
		<input id="imageUrl2" type="hidden" name="platformPromotion.smallPoster" value=""/>
		<input id="createTime" type="hidden" name="platformPromotion.createTime" value=""/>
		<input id="useStatus" type="hidden" name="platformPromotion.useStatus" value=""/>
		<table align="center" class="addOrEditTable" width="800px;">
			<tr>
				<td class="toright_td" width="140px"><span style="color:red">* </span>活动主题:</td>
				<td class="toleft_td" colspan="3" style="width:230px;">&nbsp;&nbsp;<input style="width:120px;" id="promotionName" type="text" name="platformPromotion.promotionName" class="{validate:{required:true,maxlength:[50]}}"/></td>
			<!-- </tr>
			<tr> -->
				<td class="toright_td" width="140px"><span style="color:red">* </span>起止时间:</td>
				<td class="toleft_td" colspan="3">&nbsp;
				<input id="beginTime" style="height: 18px;width: 135px;" class="Wdate" type="text" name="platformPromotion.beginTime" onFocus="WdatePicker({ minDate:'%y-%M-%d',maxDate:'#F{$dp.$D(\'endTime\',{d:-1})}'})" />&nbsp;&nbsp;-
				<input id="endTime" style="height: 18px;width: 135px;" class="Wdate " type="text" name="platformPromotion.endTime" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'beginTime\',{d:1})}'})"/>
					<label class="error" for="expirationTime" generated="true"></label>
		      	<span id="sendTime"></span>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="140px" colspan="1">活动简介:&nbsp;&nbsp;</td>
				<td  class="toleft_td" colspan="7">
				<textarea id="shopPromotionInfo" name="platformPromotion.shopPromotionInfo" rows="4" cols="48" style="margin-top: -30px; width:709px;height:200px;" ></textarea>
				<script type="text/javascript">
					var editor;
					KindEditor.ready(function(K){
							editor = K.create("#shopPromotionInfo",{
							cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
							uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subMode=cms",
							fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subMode=cms",
							allowFileManager : false,
							allowPreviewEmoticons : false,
							items : [
		                              'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'cut', 'copy', 'paste',
		                              'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
		                              'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
		                              'superscript', 'clearhtml', 'selectall', '|', 'fullscreen', '|',
		                              'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
		                              'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image',
		                              'table', 'hr', 'emoticons', 'pagebreak', 'link', 'unlink'
		                          ],
			                    filterMode : false
						});
						prettyPrint();
					});
				</script>
				</td>
			</tr>
			
<!-- 		    <tr> -->
<!-- 		      <td class="toright_td" width="200px">活动状态:&nbsp;&nbsp;</td> -->
<!-- 			  <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="useStatus_1"  type="radio" name="platformPromotion.useStatus" checked="checked" value="1"/>开启&nbsp;&nbsp;<input id="useStatus_0" type="radio" name="platformPromotion.useStatus" value="0"/>未开启</td> -->
<!-- 		    </tr> -->
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
	</form>
</div>
