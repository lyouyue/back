<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>同城快递信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
    	    //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/cityCourier/saveOrUpdateCityCourier.action", 
                         queryParams:{pageSize:pageSize},
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
		   $("#tt").datagrid({//数据表格
				/* title:"同城快递员信息列表",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true, //true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/cityCourier/ListCityCourier.action", 
				idField:"cityCourierId", //唯一性标示字段
				frozenColumns:[[//冻结字段 
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"cityCourierName",title:"快递员姓名",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.cityCourierId+"' onclick='showDetailInfo(this.id);'>"+rowData.cityCourierName+"</a>";  
		         	  }  
					}, 
					{field:"responsibleAreas",title:"责任区域",width:120},
					{field:"phone",title:"联系电话",width:120},
					{field:"entryTime",title:"入职时间",width:200} 
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				<%
				if("add".equals((String)functionsMap.get(purviewId+"_add"))){
				%>
					{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(675,'auto',"&nbsp;&nbsp;添加同城快递","icon-add",false,"addOrEditWin"); 
						$("#cityCourierId").val(null);
					}
				},"-",
				<%
				}
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
					{
					text:"修改", 
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){//没有选择修改项
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");
						}if(rows.length>1){//超过了一个选择项
							msgShow("系统提示", "<p class='tipInfo'>只能够修改一项！</p>", "warning");
						}else if(rows.length==1){
							createWindow(700,'auto',"&nbsp;&nbsp;修改同城快递","icon-edit",false,"addOrEditWin");
							$.ajax({
							   type: "POST", 
							   dataType: "JSON",
							   url: "${pageContext.request.contextPath}/back/cityCourier/getCityCourierInfo.action",
							   data: {id:rows[0].cityCourierId},
							   success: function(data){
								   var cityCourier=data.cityCourier;
								   var cityList=data.cityList;
								   var districtList=data.districtList;
								   $("#cityCourierId").val(cityCourier.cityCourierId);
								   $("#cityCourierName").val(cityCourier.cityCourierName);
								   $("#responsibleAreas").val(cityCourier.responsibleAreas);
								   $("#phone").val(cityCourier.phone);
								   $("#address").val(cityCourier.address);
								   $("#cardIdNo").val(cityCourier.cardIdNo);
								   $("#entryTime").val(cityCourier.entryTime);
								   $("#introducer").val(cityCourier.introducer);
								   var area=cityCourier.responsibleAreas.split(",");
								   $("#province").val(area[0]);
								   var citiesOption="<option value=''>--请选择--</option>";
			 						for(var i=0;i<cityList.length;i++){
			 							citiesOption+="<option  value='" + cityList[i].areaId+"'>" + cityList[i].name+ "</option>";
			 						}
			 						$("#cities").html(citiesOption);
			 						var districtOption="<option value=''>--请选择--</option>";
			 						for(var i=0;i<districtList.length;i++){
			 							districtOption+="<option  value='" + districtList[i].areaId+"'>" + districtList[i].name+ "</option>";
			 						}
			 						$("#district").html(districtOption);
								   $("#cities").val(area[1]);
								   $("#district").val(area[2]);
							   }
							});
						}
					}
				},"-",
				<%
				}
				if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
				%>
					{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].cityCourierId;
											else ids+=rows[i].cityCourierId+",";
										}
										$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/cityCourier/deleteCityCouriers.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   $("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
									}	
								}
							});
						}
					}
				},"-",
				<% 
				}
				%>
				{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});

	function reset(){
		$("#q_cityCourierName").val("");
       	$("#q_phone").val("");
    	$("#qprovince").val("");
    	$("#qcities").val("");
    	$("#qdistrict").val("");
	}
	function query(){
		var province=$("#qprovince").val();
		var cities=$("#qcities").val();
		var district=$("#qdistrict").val();
		var cityCourierName=$("#q_cityCourierName").val();
		var phone=$("#q_phone").val();
		var responsibleAreas="";
		if(province!=null&&province!=""){
			//responsibleAreas=province;
			if(cities!=""&&cities!=null){
				//responsibleAreas+=","+cities;
				if(district!=""&&district!=null){
					responsibleAreas =province+","+cities+","+district;
					queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,cityCourierName:cityCourierName,phone:phone,responsibleAreas:responsibleAreas};
					$("#tt").datagrid("load",queryParams); 
					pageSplit(pageSize,queryParams);//调用分页函数 
				}else{
					msgShow("系统提示", "<p class='tipInfo'>请选择县（区）</p>", "warning");
				}
			}else{
				msgShow("系统提示", "<p class='tipInfo'>请选择县（区）</p>", "warning");
			}
		}else{
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,cityCourierName:cityCourierName,phone:phone,responsibleAreas:responsibleAreas};
		$("#tt").datagrid("load",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数 
		}
	}
    </script>
<script type="text/javascript">
function chengeArea11(id,level){
	$.ajax({
		url:"${pageContext.request.contextPath}/back/cityCourier/findCityList.action",
		type:"post",
		dataType:"json",
		data:{id:id},
		success:function(data){
			if(data!=""){
				var areaList=data;
				var htmlOption="<option value=''>--请选择--</option>";
				for(var i=0;i<areaList.length;i++){
					htmlOption+="<option  value='" + areaList[i].areaId+"'>" + areaList[i].name+ "</option>";
				}
				if(level==1){
					$("#qcities").html(htmlOption);
				}if(level==2){
					$("#qdistrict").html(htmlOption);
				}
			}
			var firstArea=$("#qprovince").val();
		if(firstArea==null||firstArea==""){
			$("#qcities").html("<option value=''>--请选择--</option>");
			$("#qdistrict").html("<option value=''>--请选择--</option>");
		}
		var secondArea=$("#qcities").val();
		if(secondArea==null||secondArea==""){
			$("#qdistrict").html("<option value=''>--请选择--</option>");
		}
		}
	});
}
</script>
  </head>
  
<body>
<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width: 95px;">快递员姓名：</td>
				<td class="search_toleft_td" style="width: 140px;"><input type="text" id="q_cityCourierName" name="q_cityCourierName" style="width:120px;"/></td>
				<td class="search_toright_td" style="width: 65px;">联系电话：</td>
				<td class="search_toleft_td" style="width: 140px;"><input type="text" id="q_phone" name="q_phone" style="width:120px;"/></td>
				<td class="search_toright_td" style="width: 65px;">责任区域： </td>
				<td class="search_toleft_td" style="width:388px;">
					<select id="qprovince" onchange="chengeArea11(this.value,'1')" class="{validate:{required:true}}; querySelect" style="text-align: left;width: 120px;">
					<option value="">省</option>
						<s:iterator value="provinceList" var="first">
							<option  value="<s:property value="#first.areaId"/>"><s:property value="#first.name"/></option>
						</s:iterator>
					</select>
					<select id="qcities" onchange="chengeArea11(this.value,'2')" class="{validate:{required:true}}; querySelect" style="text-align: left;width: 120px;">
						<option value="">地级市</option>
					</select>
					<select id="qdistrict" class="{validate:{required:true}}; querySelect" style="text-align: left;width: 120px;">
						<option value="">区(县)</option>
					</select>
		          <!-- <input type="text" id="q_responsibleAreas" name="q_responsibleAreas" style="width:120px;"/> -->
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<jsp:include page="addOrEditCityCourier.jsp"></jsp:include>
				<jsp:include page="detailCityCourier.jsp"></jsp:include>
			</div>
	</div>
</body>
</html>
