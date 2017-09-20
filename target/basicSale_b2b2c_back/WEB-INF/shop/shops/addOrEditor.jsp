<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
$(function(){//表单验证
    $("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
             function(){
                   var options = {  
                       url : "${pageContext.request.contextPath}/back/shops/saveOrUpdateShops.action",
                       type : "post",
                       dataType:"json",
                       success : function(data) {
                      	 closeWin();
                      	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
                       }
                   };
                   $("select").attr("disabled",false);
                   $("#form1").ajaxSubmit(options);  
                });
       }
    });
});

//选择地区进行赋值
function setValue(id){
	var areaValue = $("#"+id).val();
	var areaArr = areaValue.split("@");
	$("#areaId").val(areaArr[0]);//区域ID
	$("#areaName").val(areaArr[1]);//区域名称
}

function chengeArea(id,level,selectId){
	$.ajax({
  			url:"${pageContext.request.contextPath}/back/shops/findAreaList.action",
  			type:"post",
  			dataType:"json",
  			data:{areaId:id},
  			success:function(data){
  				if(data!=""&&data!=null){
  					var areaList=data;
  					var htmlOption="<option value=''>--请选择--</option>";
						for(var i=0;i<areaList.length;i++){
							htmlOption+="<option value='" + areaList[i].areaId+"'id='" + areaList[i].areaId+"'>" + areaList[i].name+ "</option>";
						}
						//console.log(htmlOption);
  					if(level==1){
  						$("#secondArea").html(htmlOption);
  						$("#secondArea").val(selectId);
						$("#threeArea").html("<option value=''>--请选择--</option>");
  					}else if(level==2){
  						$("#threeArea").html("");
  						$("#threeArea").append(htmlOption);
  						$("#threeArea").val(selectId);
  					}else if(level==3){
  						$("#threeArea").html("");
  						$("#threeArea").append(htmlOption);
  						$("#threeArea").val(selectId);
  					}
  				}else{
  					$("#secondArea").html("<option value=''>--请选择--</option>");
  				}
  			}
		});
}
</script>
<div id="addOrEditWin" align="center">
	<form id="form1"  method="post" >
		<input type="hidden" id="shopsId" name="shops.shopsId" />
		<input type="hidden" id="shopsCode" name="shops.shopsCode">
		<input type="hidden" id="createTime" name="shops.createTime">
		<table style="text-align: center;" class="addOrEditTable" >
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>商城名称:</td>
				<td class="toleft_td">&nbsp;&nbsp;<input style="width: 260px;" id="shopsName" type="text" name="shops.shopsName" class="{validate:{required:true,maxlength:[50]}}"/></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>所在地区:</td>
				<td class="toleft_td">
					&nbsp;&nbsp;<select style=" padding:1px 1px 1px 1px;" name="shops.regionLocation" id="firstArea" onchange="chengeArea(this.value,'1','')" class="{validate:{required:true}}">
						<option value="">--请选择--</option>
						<s:iterator value="firstAreaList" var="first" >
							<option value="<s:property value="#first.aid"/>" id="<s:property value="#first.aid"/>"><s:property value="#first.name"/></option>
						</s:iterator>
					</select>&nbsp;&nbsp;
					<select style="padding:1px 1px 1px 1px;" name="shops.city" id="secondArea" onchange="chengeArea(this.value,'2','')" class="{validate:{required:true}}">
							<option value="" >--请选择--</option>
					</select>
				</td>
			</tr>
			<tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>商城详细地址:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width: 260px;" id="address" type="text" name="shops.address" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
			<tr>
				<td class="toright_td" width="150px">备注:</td>
				<td class="toleft_td" width="700px">&nbsp;&nbsp;<textarea style="width: 258px;margin-top: 10px;" id="note" name="shops.note" cols="50" rows="3"  class="{validate:{maxlength:[500]}}"></textarea></td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
</div>
