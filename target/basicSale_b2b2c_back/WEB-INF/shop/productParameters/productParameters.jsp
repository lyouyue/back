<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/json2.js"></script>
<script type="text/javascript">
	$(function(){
		$("#form1").validate({meta: "validate", 
			submitHandler:function(form){
				$(document).ready(
					function() {  
					var options = {  
						url : "${pageContext.request.contextPath}/back/productParameters/saveOrUpdateProductParameters.action",  
						type : "post",  
						dataType:"json",
						success : function(data) {
							if(data.isSuccess){
								msgShow("系统提示", "<p class='tipInfo'>保存成功！</p>", "warning");  
							}else{
								msgShow("系统提示", "<p class='tipInfo'>保存失败！</p>", "warning");  
							}
						}
					};
					$("#form1").ajaxSubmit(options);  
					$("input.button_save").attr("disabled","disabled");//防止重复提交
				});
			}
		});
	});
 $().ready(function() {

		//var $inputForm = $("#inputForm");
		var $parameterTable = $("#appendTable");
		var $addParameter = $("#addParameter");//添加参数组
		var $deleteParameter = $("a.deleteParameter");//删除参数组
		var $addParamGroupInfo = $("a.addParamGroupInfo");//继续添加参数明细
		var $deteleParamGroupInfo =$("a.deteleParamGroupInfo");
		//var parameterIndex = $("#parameterIndex").val();
		
		// 增加参数组
		$addParameter.live("click", function() {
			var parameterIndex=$("#parameterIndex").val();
			var rnd=RndNum();//随机数
			var pgInfoId = RndNum();//参数id随机数
			var pgiLength=$(".parameterInfoTable tr").length;//当前参数table中行数
			var $this = $(this);
			var trHtml ='<table id="parameterTable'+parameterIndex+'" class="parameterTable addOrEditTable" style="border: 1px solid #d0d0d0;width:100%;margin-top:2px;"> ';
			trHtml+='<tr  class="parameterTr" style="background:#ccc;color: blue">' +
					'<td>参数组名称<\/td><td> <input type="text" name="listParamGroup[' + parameterIndex + '].name" class="{validate:{required:true}}"\/><input type="hidden"  name="listParamGroup[' + parameterIndex + '].paramGroupId" value="'+rnd+'"\/> <\/td> ';
			trHtml+='<td>排序<\/td><td> <input type="text" name="listParamGroup[' + parameterIndex + '].order" class="{validate:{number:true,maxlength:[2]}}" style="width: 50px;" \/> <\/td> ';
			trHtml+='<td><a href="javascript:;" id="' + parameterIndex + '" name="'+rnd+'" class="addParamGroupInfo">[添加参数]<\/a></td><td> <a href="javascript:;" id="'+parameterIndex+'" class="deleteParameter">[删除参数组]<\/a>  <\/td> ';
			trHtml+=' <\/td><\/tr>';
			trHtml+='<tr ><td  colspan="6"><table id="parameterInfoTable' + parameterIndex + '" class="parameterInfoTable addOrEditTable" style="width:100%;margin-top:0px;">';
			trHtml+='<tr class="parameterInfoTr">';
			trHtml+='<td>参数名称 <\/td> <td> <input type="text" name="listParamGroupInfo[' + pgiLength + '].name" class="{validate:{required:true}}"\/> <input type="hidden" id="pgiId0" name="listParamGroupInfo[' + pgiLength + '].pgiId" value="'+rnd+'"\/><input type="hidden"  name="listParamGroupInfo[' + pgiLength + '].pgInfoId" value="'+pgInfoId+'"\/> <\/td>';
			trHtml+='<td>参数排序 <\/td> <td> <input type="text" name="listParamGroupInfo[' + pgiLength + '].order" class="{validate:{number:true,maxlength:[2]}}" style="width: 50px;" \/> <\/td><td>  <a href="javascript:;" class="deteleParamGroupInfo">[删除]<\/a> <\/td>' ;
			trHtml+='<\/tr><\/table></td><\/tr>';
			trHtml+='<\/table>';
			$parameterTable.append(trHtml);
			parameterIndex ++;
			parameterIndex=$("#parameterIndex").val(parameterIndex);
		});
		// 删除参数组
		$deleteParameter.live("click", function() {
			var $this = $(this);
			if ($parameterTable.find("table.parameterTable").size() <= 1) {
				msgShow("系统提示", "<p class='tipInfo'>至少保留一个参数组！</p>", "warning");  
			} else {
				$("#parameterInfoTable"+this.id).html("");
				$("#parameterTable"+this.id).remove();
			}
		});
		//添加参数
		$addParamGroupInfo.live("click",function(){
			var $this = $(this);
			var pgInfoId = RndNum();//参数id随机数
			var trLength=$(".parameterInfoTable tr").length;
			var trHtml ='<tr class="parameterInfoTr"><td>参数名称 <\/td>  <td> <input type="text" name="listParamGroupInfo[' +trLength + '].name" class="{validate:{required:true}}"/>  <input type="hidden" name="listParamGroupInfo[' + trLength + '].pgiId"  value="'+this.name+'"/><input type="hidden"  name="listParamGroupInfo[' + trLength + '].pgInfoId" value="'+pgInfoId+'"\/><\/td><td>参数排序 <\/td> <td> <input type="text" name="listParamGroupInfo[' +trLength + '].order"  style="width: 50px;" class="{validate:{number:true,maxlength:[2]}}"\/> <\/td> ';
			trHtml+='<td><a href="javascript:;" class="deteleParamGroupInfo">[删除]<\/a> <\/td> <\/tr>';
			$("#parameterInfoTable"+this.id).append(trHtml);
		});
		// 删除参数
		$deteleParamGroupInfo.live("click", function() {
			var $this = $(this);
			$this.closest("tr").remove();
		});
	});

	//获取随机数
		function RndNum(){
			var rnd="";
			for(var i=0;i<4;i++){
				rnd+=Math.floor(Math.random()*10+1);
			}
			return rnd;
		}

	//看该参数是否已经添加参数
	 function getProdType(productTypeId){
 		 $.ajax({
  			url:"${pageContext.request.contextPath}/back/productParameters/getPorductParameters.action",
  			type:"post",
  			dataType:"json",
  			data:{productTypeId:productTypeId},
  			success:function(data){
  				if(data!=null){
  					$("#appendTable").html("");
  					$("#productParametersId").val(data.productParametersId);
				   $("#name").val(data.name);
				   //$("#productParametersInfo").val(productParameters.info);
				   $("#sort").val(data.sort);
  				   var infoObj=eval(data.info);
				   var index=0;
				   var infoIndex=0;
				   for(var i=0;i<infoObj.length;i++){
						var trHtml ='<table id="parameterTable'+i+'" class="parameterTable addOrEditTable" style="border: 1px solid #d0d0d0;width:100%;margin-top:2px;"> ';
						trHtml+='<tr  class="parameterTr" style="background:#ccc;color: blue">' +
								'<td>参数组名称<\/td><td> <input type="text" name="listParamGroup[' + i + '].name" value="'+infoObj[i].name+'" class="{validate:{required:true}}"\/><input type="hidden"  name="listParamGroup[' + i + '].paramGroupId" value="'+infoObj[i].paramGroupId+'"\/> <\/td> ';
						trHtml+='<td>排序<\/td><td> <input type="text" name="listParamGroup[' + i + '].order " class="{validate:{number:true,maxlength:[2]}}" value="'+infoObj[i].order+'" style="width: 50px;" \/> <\/td> ';
						trHtml+='<td><a href="javascript:;" id="' + i + '" name="'+infoObj[i].paramGroupId+'" class="addParamGroupInfo">[添加参数]<\/a></td><td> <a href="javascript:;" id="'+i+'" class="deleteParameter">[删除参数组]<\/a>  <\/td> ';
						trHtml+=' <\/td><\/tr>';
						trHtml+='<tr ><td colspan="6"><table id="parameterInfoTable' + i + '" class="parameterInfoTable addOrEditTable" style="width:100%;margin-top:0px;">';
						var a =eval(infoObj[i].paramGroupInfo);
						//var h=$(".parameterInfoTable tr").length;
						for(var u=0;u<a.length;u++){
							trHtml+='<tr class="parameterInfoTr">';
							trHtml+='<td>参数名称 <\/td> <td> <input type="text" name="listParamGroupInfo[' +infoIndex + '].name" value="'+a[u].name+'" class="{validate:{required:true}}"\/> <input type="hidden" id="pgiId0" name="listParamGroupInfo[' +infoIndex+ '].pgiId" value="'+a[u].pgiId+'"\/><input type="hidden"  name="listParamGroupInfo[' + infoIndex + '].pgInfoId" value="'+a[u].pgInfoId+'"\/> <\/td>';
							trHtml+='<td>参数排序 <\/td> <td> <input type="text" name="listParamGroupInfo[' + infoIndex + '].order" class="{validate:{number:true,maxlength:[2]}}" value="'+a[u].order+'"  style="width: 50px;" \/> <\/td><td>  <a href="javascript:;" class="deteleParamGroupInfo">[删除]<\/a> <\/td><\/tr>' ;
							infoIndex++;
						}
						trHtml+='<\/table></td><\/tr>';
						trHtml+='<\/table>';
						$("#appendTable").append(trHtml);
						index++;
				   }
				  $("#parameterIndex").val(index);
  				}else{
  					$("#appendTable").html("");
  					$("#parameterIndex").val(0);
  					$("#productParametersId").val("");
					$("#name").val("");
					$("#sort").val("");
  				}
  			}
  		});
 	 }
</script>
<div id="addOrEditWin">
	<form id="form1"  method="post" >
		<input id="productParametersId" type="hidden" name="productParameters.productParametersId" />
		<input id="productTypeId" type="hidden" name="productParameters.productTypeId"/>
		<table align="center" class="addOrEditTable" >
			<tr>
			  <td class="toright_td" width="150px">商品参数名称:</td>
			  <td class="toleft_td" width="500px">&nbsp;&nbsp;<input id="name" style="margin-left:-6px;" type="text" name="productParameters.name" class="{validate:{required:true,maxlength:[20]}}"/></td>
			</tr>
			<tr>
				<input id="totalNumber" type="hidden" name="totalNumber" value="1"/> <!-- 记录一共有多少文本框 //-->
				<input id="productParametersInfo" type="hidden" name="productParameters.info" value=""/> <!-- 用来存储商品详细参数内容 //-->
			  <td class="toright_td" width="150px">商品参数值:</td>
			  <td width="500px" id="infoAdd" style="display: " class="toleft_td" valign="middle">&nbsp;&nbsp;
					<input  id="parameterIndex"  type=hidden  value="0"/>
					<a id="addParameter" class="easyui-linkbutton" href="javascript:void();">添加参数组</a>
					<div id="appendTable">
					</div>
				</td>
			</tr>
			<tr >
			<td class="toright_td" width="150px">排序号:</td>
				<td width="500px" class="toleft_td">&nbsp;&nbsp;<input id="sort" style="margin-left:-6px;" type="text" name="productParameters.sort" class="{validate:{required:true,number:true,maxlength:[2]}}"/></td>
			</tr>
			
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
  </form>
</div>

