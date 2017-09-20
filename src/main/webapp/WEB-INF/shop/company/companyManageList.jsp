<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>企业信息管理</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"企业信息管理",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/company/listCompantManage.action",
				queryParams:{pageSize:pageSize},
				idField:"shopInfoId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerName",title:"会员名称",width:70, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							return "<a style='display:block;' id='"+rowData.shopInfoId+"' name="+rowData.type+"  onclick='showDetailInfo(this.id,this.name);'>"+rowData.customerName+"</a>";  
		         	  	}  
					}, 
					{field:"companyName",title:"企业名称",width:100}, 
					{field:"postCode",title:"邮政编码",width:40},
					{field:"passUserName",title:"审核人名称",width:60},
					/* {field:"registerDate",title:"注册日期",width:100}, */
					{field:"lockedState",title:"冻结状态",width:40,
						formatter:function(value,rowData,rowIndex){
							   if(value==1){
								    return"<font class='color_002'>已冻结</font>";
							   }else if(value==0){
								    return"<font class='color_001'>未冻结</font>";
							   }else{
								   return "--";
							   }
						 }	
					},
					{field:"shopInfoCheckSatus",title:"企业审核状态",width:40,
						formatter:function(value,rowData,rowIndex){
							   if(value==3){
								    return"<font class='color_002'>未通过</font>";
							   }else if(value==2){
								    return"<font class='color_001'>通过</font>";
							   }else if(value==1){
								   return "<font class='color_003'>未审核</font>";
							   }else{
								   return "--";
							   }
						 }	
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
				   {
						text:"企业审核",
						iconCls:"icon-search",
						handler:function(){
							$("#congeal").css("display","none");
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){//没有选择修改项
								msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
							}if(rows.length>1){//超过了一个选择项
								msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
							}else if(rows.length==1){
								shopInfoCheck(rows[0].shopInfoId);
							}
						}
					},"-",{
						text:"冻结操作",
						iconCls:"icon-search",
						handler:function(){
							var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
							if(rows.length==0){
								msgShow("系统提示", "<p class='tipInfo'>请选择要冻结的会员！</p>", "warning");  
							}else{
								createWindow(800,'auto',"&nbsp;&nbsp;冻结操作","icon-tip",false,"congeal");
								$("#detailWin").css("display","none");
								$("#addOrEditWin").css("display","none");
								$("#passWin").css("display","none");
								$("#pass2Win").css("display","none");
								$("#congeal").css("display","");
								var ls=rows[0].lockedState;
								$("#clockedState_"+ls).attr("checked",true);
							}
						}
					}
					,"-",{text:"刷新",
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
		//冻结状态操作
		function submitForm3(){
			var rows = $("#tt").datagrid("getSelections");
			var customerIds="";
			for(var i=0;i<rows.length;i++){
				customerIds+=rows[i].customerId+",";
			}
			customerIds=customerIds.substring(0, customerIds.lastIndexOf(","));
			var lsCheckValue=$('input[name="clockedState"]:checked').val();
			$.post("${pageContext.request.contextPath}/back/customer/changeLockedState.action",{params:lsCheckValue,customerIds:customerIds},function(data){
				if(data.isSuccess==true){
					 closeWin();
	            	 $("#tt").datagrid("clearSelections");
				   	 $("#tt").datagrid("reload"); 
				}
			},'json');
		}
    	function query(){
			  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,companyName:$("#qcompanyName").val(),custName:$("#qcustName").val(),shopInfoCheckSatus:$("#qshopInfoCheckSatus").val(),registerDate2:$("#qregisterDate2").val(),registerDate:$("#qregisterDate").val()};
			  $("#tt").datagrid("load",queryParams); 
			  pageSplit(pageSize,queryParams);//调用分页函数
	    }
    	function reset(){
    		$("#qcustName").val("");
           	$("#qcompanyName").val("");
        	$("#qshopInfoCheckSatus").val("");
        	$("#qregisterDate").val("");
        	$("#qregisterDate2").val("");
    	}
    </script>
  </head>
  <style type="text/css">
	   	 .linkbtn{margin-top: 5px;margin-right: 10px;}
	   	 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	   	 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
	   	 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td"  style="width:80px;">会员名称：</td>
				<td class="search_toleft_td" style="width:145px;"><input type="text" style="width: 140px;" id="qcustName" name="custName" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width:75px;">企业名称：</td>
				<td class="search_toleft_td" style="width:145px;"><input type="text" style="width: 140px;" id="qcompanyName" name="companyName" class="searchTabinput"/></td>
				<td class="search_toright_td" style="width: 105px;">企业审核状态：</td>
				<td class="search_toleft_td" style="width:115px;">
					<select id="qshopInfoCheckSatus" class="querySelect">
						<option value="-1">--请选择--</option>
						<option value="1">未审核</option>
						<option value="2">通过</option>
						<option value="3">未通过</option>
					</select>
				</td>
				<!-- <td class="toright_td" style="width:65px;">注册日期：</td>
				<td class="toleft_td" style="width: 230px;">
					<input id="qregisterDate" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qregisterDate\')}'})"/>
					- <input id="qregisterDate2" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qregisterDate2\')}'})"/>
				</td> -->
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 添加和修改 -->
			<jsp:include page="addOrEditCompanyManage.jsp"/>
			<!-- 详情页 -->
			<jsp:include page="detailCompanyManage.jsp"/>
			<!-- 审核页面 -->
			<jsp:include page="isPassCompanyManage.jsp"/>
			<jsp:include page="isPass2CompanyManage.jsp"/>
			<!-- 冻结 -->
			<jsp:include page="congeal.jsp"/>
		</div>
	</div>
</body>
</html>
