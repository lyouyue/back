<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript">
	var infos="";
	var imageUrl="";
	$(function(){//表单验证
		$("#form1").validate({meta: "validate", 
			submitHandler:function(form){
				$("#btnSave").removeAttr("onclick");//提交锁定
				$(document).ready(function() {
					var options = {  
						url : "${pageContext.request.contextPath}/back/specification/saveOrUpdateSpecification.action",  
						type : "post",  
						dataType:"json",
						success : function(data) {
							closeWin();
							$("#tt").datagrid("clearSelections");//删除后取消所有选项
							$("#tt").datagrid("reload"); //保存后重新加载列表
							$("#specificationId").val(null);
							infos="";
							imageUrl="";
							$("#btnSave").attr("onclick","$('#form1').submit();");//解除提交锁定
						}
					};
					var flag = true;
					var specificationId = $("#especificationId").val();
					infos="";
					//if(specificationId==null||specificationId==""){
						//把填写的规格值追加成字符串
						for(var i=0;i<newItemNumber;i++){
							var infoName= $("#sortValue"+i).val();
							var infoValue= $("#nameValue"+i).val();
							var specificationValueId = $("#specificationValueId"+i).val();
							$("#nameValue"+i).attr("onBlur","validateValue(this);");
							//效验
							if((infoValue==null||infoValue=="")&&typeof infoValue !="undefined"){
								flag = false;
								var error=$("#error"+i).attr("id");
								if(error==null||error==""){
									$("#nameValue"+i).after("<label id='error"+i+"' style=' color: red;margin-left: 0.5em;position: relative;top: 0;width: 20em'>不可为空</label>");
								}
							}
							if(specificationValueId==null||specificationValueId==''){
								specificationValueId = 0;
							}
							if(flag&&typeof infoName !="undefined"&&typeof infoValue !="undefined"){
								infos+=infoName+"_"+specificationValueId+","+infoValue;
								if((newItemNumber-1)!=i){
									infos+="@";
								}
							}
						}
						//最后一个字符为@时，要截取掉
						if(infos!=null){
							var lastIndex = infos.lastIndexOf("@");
							if(Number(lastIndex)==Number(infos.length-1)){
								infos = infos.substr(0,lastIndex);
							}
						}
						$("#info").val(infos);
						$("#imageUrl").val(imageUrl);
					//}
					if(flag){
						$("#form1").ajaxSubmit(options);  
					}
				});
			}
		});
	})
	//验证规格值是否存在
	function validateValue(obj){
		var value = $(obj).val();
		if($(obj)!=null&&$(obj)!=""&&value!=""){
			//obj.removeAttr("onblur");
			var nextObj = $(obj).next();
			if(nextObj!=null&&nextObj!=""){
				nextObj.remove();
			}
		}else{
			var idValue = $(obj).attr("id");
			idValue = idValue.replace("nameValue","error");
			var error=$("#"+idValue).attr("id");
			if(error==null||error==""){
				$(obj).after("<label id='"+idValue+"' style=' color: red;margin-left: 0.5em;position: relative;top: 0;width: 20em'>不可为空</label>");
			}
		}
	}
	//类型为文本图片上传隐藏
	function text(){
		$("#image").css("display","none");
		$("#imageValue").css("display","none");
		$(".iamgeValue").css("display","none");
	}
	//类型为图片，图片上传显示
	function image(){
		$("#image").css("display","");
		$("#imageValue").css("display","");
		$(".iamgeValue").css("display","");
	}
	//变量记录追加了几个文本
	var newItemNumber = 1;
	function addType(){
		var html = "<tr class='addSpecValue'>"+
				"<td align='center'><input id='sortValue"+newItemNumber+"' type='text' name='sortValue"+newItemNumber+"' class='{validate:{required:true,digits:true}} specValueSort' value='"+getMaxSortNum('specValueSort')+"' style='width:50px;'/></td>"+
				"<td colspan='2' align='center'><input id='nameValue"+newItemNumber+"' type='text' name='nameValue"+newItemNumber+"' class='{validate:{required:true}}' value=''/></td>"+
				"<td class='iamgeValue' style='display:none'>"+
				"<form id='photoForm_"+newItemNumber+"' method='post' enctype='multipart/form-data'>"+
				"&nbsp;&nbsp;&nbsp;&nbsp;<input id='fileId' type='file' name='imagePath'/>"+
				"<span id='mes_"+newItemNumber+"'></span>"+
				"<input id='buttonId' type='button' value='上传预览' onclick='uploadPhoto("+newItemNumber+")'/>"+
				"<span id='photo_"+newItemNumber+"'></span>"+ 
				"</form></td>"+
				"<td align='center'><a onclick='remove_tr($(this),null);' href='javascript:'>移除</a></td>"+
				"</tr>";
		$('#tr_model > tr:last').after(html);
		if($("#s_dtype_image").val=="1"){
			$("#image").css("display","");
			$("#imageValue").css("display","");
			$(".iamgeValue").css("display","");
		}
		newItemNumber++;
		if($("#s_dtype_image").attr("checked")=="checked"){
			$("#image").css("display","");
			$("#imageValue").css("display","");
			$(".iamgeValue").css("display","");
		}
	}
	//移除文本
	function remove_tr(o,specificationValueId){
		if(specificationValueId!=null){
			ids = specificationValueId;
			$.ajax({
				type: "POST",dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/specificationValue/deleteSpecificationValue.action",
				data: {ids:ids},
				success: function(data){
					if(data.isSuccess=="true"){
						o.parents('tr:first').remove();
						msgShow("系统提示", "<p class='tipInfo'>移除成功！</p>", "warning");
					}else{
						msgShow("系统提示", "<p class='tipInfo'>移除失败！</p>", "warning");
					}
				}
			});
		}else{
			o.parents('tr:first').remove();
		}
	}
	//上传图片 
	function uploadPhoto(id) {
		$(document).ready(  
			 function() {  
				var options = {  
					url : "${pageContext.request.contextPath}/back/specification/uploadImage.action",
					type : "post",  
					dataType:"json",
					success : function(data) {
						if(data.photoUrl=="false1"){
							$("#mes_"+id).html(" <font style='color:red'>请选择上传图片</font>");
						}else if(data.photoUrl=="false2"){
							$("#mes_"+id).html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
						}else{
							var s = id+"_"+data.photoUrl;
							imageUrl = imageUrl+","+s;
							$("#photoUrl").val(data.photoUrl);
							$("#photo_"+id).html("");
							$("#photo_"+id).html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='20px' height='20px' />");
						} 
					}
				};
				$("#photoForm_"+id).ajaxSubmit(options);
		});
	}
	//初始化规格值
	function initSpecificationValue(specificationValueList){
		$(".addSpecValue").remove();
		if(specificationValueList!=null){
			for(var i=0;i<specificationValueList.length;i++){
				if(i==0){
					$("#nameValue0").val(specificationValueList[i].name);
					$("#specificationValueId0").val(specificationValueList[i].specificationValueId);
					$("#sortValue0").val(specificationValueList[i].sort);
				}else{
					var html = "<tr class='addSpecValue'>"+
					"<td align='center'><input id='sortValue"+newItemNumber+"' type='text' name='sortValue"+newItemNumber+"' class='{validate:{required:true,digits:true}} specValueSort' value='"+specificationValueList[i].sort+"' style='width:50px;'/></td>"+
					"<td colspan='2' align='center'><input id='specificationValueId"+newItemNumber+"' type='hidden' value='"+specificationValueList[i].specificationValueId+"'/><input id='nameValue"+newItemNumber+"' type='text' name='nameValue"+newItemNumber+"'  class='{validate:{required:true}}' value='"+specificationValueList[i].name+"'/></td>"+
					"<td class='iamgeValue' style='display:none'>"+
					"<form id='photoForm_"+newItemNumber+"' method='post' enctype='multipart/form-data'>"+
					"&nbsp;&nbsp;&nbsp;&nbsp;<input id='fileId' type='file' name='imagePath'/>"+
					"<span id='mes_"+newItemNumber+"'></span>"+
					"<input id='buttonId' type='button' value='上传预览' onclick='uploadPhoto("+newItemNumber+")'/>"+
					"<span id='photo_"+newItemNumber+"'></span>"+ 
					"</form></td>"+
					"<td align='center'><a onclick='remove_tr($(this),"+specificationValueList[i].specificationValueId+");' href='javascript:'>移除</a></td>"+
					"</tr>";
					$('#tr_model > tr:last').after(html);
				}
				newItemNumber++;
			}
		}
	}
</script>
<div id="addOrEditWin">
	<form id="form1"  method="post">
		<input id="especificationId" type="hidden" name="specification.specificationId" value=""/>
		<input id="info" type="hidden" name="info" value=""/>
		<input id="imageUrl" type="hidden" name="imageUrl" value=""/>
		<input id="productTypeId" name="specification.productTypeId"  type="hidden" value=""/>
		<table align="center" class="addOrEditTable" style="width: 850px;">
			<tr>
				<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">规格信息</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>商品分类名称:</td>
				<td class="toleft_td">&nbsp;
					<select id="sproductTypeId" class="{validate:{required:true}}">
						<option value="">--请选择分类--</option>
						<s:iterator value="#application.categoryMap" var="type1">
							<option value="<s:property value="#type1.key.productTypeId"/>"  >
							<s:property value="#type1.key.sortName"/>
							<s:iterator value="#type1.value" var="type2">
								<option value="<s:property value="#type2.key.productTypeId"/>"  >
									&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type2.key.sortName"/>
									<s:iterator value="#type2.value" var="type3">
									<option value="<s:property value="#type3.key.productTypeId"/>" >
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type3.key.sortName"/>
										<s:iterator value="#type3.value" var="type4">
											<option value="<s:property value="#type4.productTypeId"/>" >
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type4.sortName"/>
										</s:iterator>
									</option>
									</s:iterator>	
								</option>
							</s:iterator>
							</option>
						  </s:iterator>
						  </select>
				</td>
				<td class="toright_td" width="150px"><span style="color:red">* </span>规格名称:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="specification.name" class="{validate:{required:true,maxlength:[150]}}"></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>排序:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="sort" type="text" name="specification.sort" class="{validate:{required:true,digits:true,maxlength:[5]}}" style="width:80px;"></td>
				<td class="toright_td" width="150px"><span style="color:red">* </span>规格备注:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="notes" type="text" name="specification.notes" class="{validate:{required:true,maxlength:[500]}}"></td>
			</tr>
			<input id="s_dtype_text" type="hidden" name="specification.type" value="0" />
			<%--<tr>
				<td class="toright_td" width="150px">规格类型:&nbsp;&nbsp;</td>
				<td class="toleft_td" colspan="3">
				&nbsp;&nbsp;<input id="s_dtype_text" type="radio" name="specification.type" checked="checked" value="0" onclick="text();"/>文本
				&nbsp;&nbsp;
				<input id="s_dtype_image" type="radio" name="specification.type" value="1" onclick="image()"/>图片</td>
			</tr> --%>
			<tr>
				<td colspan="4" class="titlebg" style="font-weight:bold;text-align: center;">添加规格值</td>
			</tr>
			<tr>
				<td class="titlebg" style="font-weight:bold;text-align: center;"><span style="color:red">* </span>排序</td>
				<td colspan="2" class="titlebg" style="font-weight:bold;text-align: center;"><span style="color:red">* </span>规格值</td>
				<td id="image" style="font-weight:bold;text-align: center;display:none" class="titlebg">规格图片</td>
				<td class="titlebg" style="font-weight:bold;text-align: center;">操作</td>
			</tr>
			<tbody id="tr_model">
				<tr id="0"></tr>
				<tr id="1">
					<td align="center" width="20%"><input id="sortValue0" type="text" class='{validate:{required:true,digits:true}} specValueSort' name="sortValue0" value="1" style="width:50px;"/></td>
					<td colspan="2" align="center" width="40%">
						<input id="specificationValueId0" type="hidden"/>
						<input id="nameValue0" type="text" name="nameValue0" value="" class="{validate:{required:true}}"/>
					</td>
					<td class="iamgeValue" style="display:none">
						<form id="photoForm_0" method="post" enctype="multipart/form-data">
							&nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
							<span id="mes_0"></span>
							<input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto(0)"/>
							<span id="photo_0"></span>
						</form>
					</td>
					<td align="center" width="30%"><a class="btn-add marginleft" id="add_type" href="javascript:addType();"> <span>添加规格值</span> </a></td>
				</tr>
			</tbody>
		</table>
	</form>
	<div data-options="region:'south',border:false" class="editButton">
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
</div>
