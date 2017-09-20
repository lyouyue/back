<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/json2.js"></script>
<script type="text/javascript">

	$(function(){
		$("#form1").validate({meta: "validate", 
			submitHandler:function(form){
				$(document).ready(function(){
					$("#btnSave").removeAttr("onclick");//防止重复提交 ,去掉a标签中的onclick事件
					var options = {  
						url : "${pageContext.request.contextPath}/back/productParameters/saveOrUpdateProductParameters.action",  
						type : "post",  
						dataType:"json",
						success : function(data) { 
							closeWin();
							$("#tt").datagrid("clearSelections");//删除后取消所有选项
							$("#tt").datagrid("reload"); //保存后重新加载列表
						}
					};
					$("#form1").ajaxSubmit(options);  
				});
			}
		});
	});
	$().ready(function() {
		var $parameterTable = $("#appendTable");
		var $addParameter = $("#addParameter");//添加参数组
		var $deleteParameter = $("a.deleteParameter");//删除参数组
		var $addParamGroupInfo = $("a.addParamGroupInfo");//继续添加参数明细
		var $deteleParamGroupInfo =$("a.deteleParamGroupInfo");
		
		//增加参数组
		$addParameter.live("click", function() {
			var parameterIndex=$("#parameterIndex").val();
			var rnd=RndNum();//随机数
			var pgInfoId = RndNum();//参数id随机数
			var pgiLength=$(".parameterInfoTable tr").length;//当前参数table中行数
			var $this = $(this);
			var trHtml ='<table id="parameterTable'+parameterIndex+'" class="parameterTable" bgcolor="#FFCC33"> ';
			trHtml+='<tr  class="parameterTr" style="color: blue">' +
					'<td>参数组名称<\/td><td> <input type="text" name="listParamGroup[' + parameterIndex + '].name" class="{validate:{required:true}}"\/><input type="hidden"  name="listParamGroup[' + parameterIndex + '].paramGroupId" value="'+rnd+'"\/> <\/td> ';
			trHtml+='<td>排序<\/td><td> <input type="text" name="listParamGroup[' + parameterIndex + '].order" class="{validate:{digits:true,maxlength:[2]}}" style="width: 50px;" \/> <\/td> ';
			trHtml+='<td><a href="javascript:;" id="' + parameterIndex + '" name="'+rnd+'" class="addParamGroupInfo">[添加参数]<\/a></td><td> <a href="javascript:;" id="'+parameterIndex+'" class="deleteParameter">[删除参数组]<\/a>  <\/td> ';
			trHtml+=' <\/td><\/tr>';
			trHtml+='<tr > <table id="parameterInfoTable' + parameterIndex + '" class="parameterInfoTable">';
			trHtml+='<tr class="parameterInfoTr">';
			trHtml+='<td>参数名称 <\/td> <td> <input type="text" name="listParamGroupInfo[' + pgiLength + '].name" class="{validate:{required:true}}"\/> <input type="hidden" id="pgiId0" name="listParamGroupInfo[' + pgiLength + '].pgiId" value="'+rnd+'"\/><input type="hidden"  name="listParamGroupInfo[' + pgiLength + '].pgInfoId" value="'+pgInfoId+'"\/> <\/td>';
			trHtml+='<td>参数排序 <\/td> <td> <input type="text" name="listParamGroupInfo[' + pgiLength + '].order" class="{validate:{digits:true,maxlength:[2]}}" style="width: 50px;" \/> <\/td><td>  <a href="javascript:;" class="deteleParamGroupInfo">[删除]<\/a> <\/td>' ;
			trHtml+='<\/tr><\/table><\/tr>';
			trHtml+='<\/table>';
			$parameterTable.append(trHtml);
			parameterIndex ++;
			parameterIndex=$("#parameterIndex").val(parameterIndex);
		});
		// 删除参数组
		$deleteParameter.live("click", function() {
			var $this = $(this);
			if ($parameterTable.find("table.parameterTable").size() <= 1) {
				msgShow("系统提示", "<p class='tipInfo'>参数组至少保留一个！</p>", "warning");
			} else {
				$("#parameterInfoTable"+this.id).html("");
				$("#parameterTable"+this.id).remove();
			}
		});
		//添加参数
		$addParamGroupInfo.live("click",function(){
			var $this = $(this);
			var pgInfoId = RndNum();//参数id随机数
			var trLength=$(".parameterInfoTable").length;
			var infoIndex=$("#parameterInfoIndex").val();
			if(Number(trLength)<20){
				var trHtml = "<tr class='e_parazv parameterInfoTable'>"
				trHtml += "<td align='center'><input type='text' name='listParamGroupInfo[" + infoIndex + "].order' value='"+getMaxSortNum('paramSort')+"' style='width: 50px;' class='{validate:{required:true,digits:true,maxlength:[2]}} paramSort'/></td>";
				trHtml += "<td colspan='2' align='center'>";
				trHtml += "<input type='text' name='listParamGroupInfo[" + infoIndex + "].name' class='{validate:{required:true}}'/> ";
				trHtml += "<input type='hidden' name='listParamGroupInfo[" + infoIndex + "].pgiId'  value='"+this.name+"'/>";
				trHtml += "<input type='hidden'  name='listParamGroupInfo[" + infoIndex + "].pgInfoId' value='"+pgInfoId+"'/>";
				trHtml += "</td>";
				trHtml += "<td><a href='javascript:;' class='deteleParamGroupInfo'>[删除]</a></td></tr>";
				$("#appendTable").append(trHtml);
			}else{
				msgShow("系统提示", "<p class='tipInfo'>参数最多只能添加20个！</p>", "warning");
			}
			infoIndex++;
			$("#parameterInfoIndex").val(infoIndex);
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
						var trHtml ='<table id="parameterTable'+i+'" class="parameterTable" bgcolor="#FFCC33"> ';
						trHtml+='<tr  class="parameterTr" style="color: blue">' +
								'<td>参数组名称<\/td><td> <input type="text" name="listParamGroup[' + i + '].name" value="'+infoObj[i].name+'" class="{validate:{required:true}}"\/><input type="hidden"  name="listParamGroup[' + i + '].paramGroupId" value="'+infoObj[i].paramGroupId+'"\/> <\/td> ';
						trHtml+='<td>排序<\/td><td> <input type="text" name="listParamGroup[' + i + '].order " class="{validate:{digits:true,maxlength:[2]}}" value="'+infoObj[i].order+'" style="width: 50px;" \/> <\/td> ';
						trHtml+='<td><a href="javascript:;" id="' + i + '" name="'+infoObj[i].paramGroupId+'" class="addParamGroupInfo">[添加参数]<\/a></td><td> <a href="javascript:;" id="'+i+'" class="deleteParameter">[删除参数组]<\/a>  <\/td> ';
						trHtml+=' <\/td><\/tr>';
						trHtml+='<tr > <table id="parameterInfoTable' + i + '" class="parameterInfoTable">';
						var a =eval(infoObj[i].paramGroupInfo);
						//var h=$(".parameterInfoTable tr").length;
						for(var u=0;u<a.length;u++){
							trHtml+='<tr class="parameterInfoTr">';
							trHtml+='<td>参数名称 <\/td> <td> <input type="text" name="listParamGroupInfo[' +infoIndex + '].name" value="'+a[u].name+'" class="{validate:{required:true}}"\/> <input type="hidden" id="pgiId0" name="listParamGroupInfo[' +infoIndex+ '].pgiId" value="'+a[u].pgiId+'"\/><input type="hidden"  name="listParamGroupInfo[' + infoIndex + '].pgInfoId" value="'+a[u].pgInfoId+'"\/> <\/td>';
							trHtml+='<td>参数排序 <\/td> <td> <input type="text" name="listParamGroupInfo[' + infoIndex + '].order" class="{validate:{digits:true,maxlength:[2]}}" value="'+a[u].order+'"  style="width: 50px;" \/> <\/td><td>  <a href="javascript:;" class="deteleParamGroupInfo">[删除]<\/a> <\/td><\/tr>' ;
							infoIndex++;
						}
						trHtml+='<\/table><\/tr>';
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
		<input id="sort" type="hidden" name="productParameters.sort" value="1"/>
		<input id="parameterInfoIndex" type="hidden" value="0"/>
		<input id="parameterIndex" type="hidden" value="0"/>
		<table id="appendTable" align="center" class="addOrEditTable" style="width: 850px;text-align: center;">
			<tr><td class="titlebg" colspan="4" style="font-weight:bold;">参数组信息</td></tr>
			<tr>
				<td class="toright_td" width="25%"><span style="color:red">* </span>参数组名称:</td>
				<td class="toleft_td groupInfo" width="25%" id="paraGroupName">&nbsp;&nbsp;</td>
				<td class="toright_td" width="25%"><span style="color:red">* </span>排序号:</td>
				<td class="toleft_td groupInfo" width="25%" id="paraGroupSort">&nbsp;&nbsp;</td>
			</tr>
			<tr><td class="titlebg" colspan="4" style="font-weight:bold;">详细参数信息</td></tr>
			<tr>
				<td class="titlebg" align="center" style="font-weight:bold;"><span style="color:red">* </span>排序号</td>
				<td class="titlebg" colspan="2" align="center" style="font-weight:bold;"><span style="color:red">* </span>参数名称</td>
				<td class="titlebg" style="font-weight:bold;text-align: center;">操作</td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit();" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>
