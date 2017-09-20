<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id,paramGroupId){
		createWindow(800,450,"&nbsp;&nbsp;套餐参数详情","icon-tip",false,"detailWin");
		$("#parentIdList1").css("display","none");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/back/productParameters/getPorductParametersInfo.action",
			data: {productParametersId:id},
			dataType: "JSON",
			success: function(data){
			$(".parazv").remove();
			var productParameters = data.productParameters;
			var a= eval(productParameters.info);
			var detailHtml = '';
			if(a!=null&&a!=""){
				for(var q=0;q<a.length;q++){//listParamGroup
					if(Number(a[q].paramGroupId)==Number(paramGroupId)){//当前组
						detailHtml += "<tr class='parazv'>";
						detailHtml += "<td class='toright_td' width='25%'>参数组名称:</td>";
						detailHtml += "<td class='toleft_td' width='25%'>&nbsp;&nbsp;<span>"+a[q].name+"</span></td>";
						detailHtml += "<td class='toright_td' width='25%'>排序号:</td>";
						detailHtml += "<td class='toleft_td' width='25%'>&nbsp;&nbsp;<span>"+a[q].order+"</span></td>";
						detailHtml += "</tr>";
						var b= eval(a[q].paramGroupInfo);
						detailHtml += "<tr class='parazv'><td class='titlebg' colspan='4' style='font-weight:bold;'>详细参数信息</td></tr>";
						detailHtml += "<tr class='parazv'><td class='titlebg' colspan='2' align='center' style='font-weight:bold;'>排序号</td><td class='titlebg' colspan='2' align='center' style='font-weight:bold;'>参数名称</td></tr>";
						for(var w=0;w<b.length;w++){//listParamGroupInfo
							if(b[w].pgiId==a[q].paramGroupId){
								detailHtml += "<tr class='parazv'>"
								detailHtml += "<td colspan='2' align='center'>"+b[w].order+"</td><td colspan='2' align='center'>"+b[w].name+"</td>"
								detailHtml += "</tr>";
							}
						}
					}
				}
			}
			$("#paraTable").append(detailHtml);
			//$("#dproductTypeName").html(data.prodTypeNames);//分类的名称
			}
		});
	}
	
	
</script>
<div id="detailWin">
	<table id="paraTable" align="center" class="addOrEditTable" style="width: 94%;margin-right:3%; margin-left:3%;text-align: center;">
		<tr><td class="titlebg" colspan="4" style="font-weight:bold;">参数组信息</td></tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>