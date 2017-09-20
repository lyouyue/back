<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员收货地址信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/city.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"会员地址列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,
				align:"center",
				loadMsg:"正在处理，请等待......",
				striped: true,
				url:"${pageContext.request.contextPath}/back/customerAcceptAddress/listCustomerAcceptAddress.action?customerId=${customerId}",
			    queryParams:{pageSize:pageSize},                                                                                     
				idField:"customerAcceptAddressId",
				frozenColumns:[[
				    {field:"ck",checkbox:true}
				]],
				columns:[[
		            {field:"consignee",title:"收货人姓名",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.customerAcceptAddressId+"' onclick='showDetailInfo(this.id);'>"+rowData.consignee+"</a>";  
		         	  }  
					},
					{field:"regionLocation",title:"省",width:120},
					{field:"city",title:"市",width:120},
					{field:"areaCounty",title:"县",width:120},
					{field:"address",title:"详细地址",width:120},
					{field:"mobilePhone",title:"手机",width:120},
					{field:"isSendAddress",title:"是否为默认地址",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font color='#EE0000'>否</font>";} 
	                        if(value=="1"){ return "<font color='#0033FF'>是</font>";} 
                         }
					}
					
				]],
				pagination:true,
				rownumbers:true,
				singleSelect:true,
				toolbar:[{
					text:"返回会员列表",
					iconCls:"icon-back",
					handler:function(){
						 location.href="${pageContext.request.contextPath}/back/customer/gotoCustomerPage.action";
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});
    
    	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
    			$.ajax({
					   type: "POST", dataType: "JSON",
					   url: "${pageContext.request.contextPath}/back/customerAcceptAddress/getCustomerAcceptAddressObject.action",
					   data: {customerAcceptAddressId:id},
					   success: function(data){
						   $("#customerAcceptAddressId").val(data.customerAcceptAddressId);
						   $("#customerId").val(data.customerId);
						   $("#s1").val(data.country);
						   $("#s2").val(data.city);
						   $("#s3").val(data.regionLocation);
						   $("#consignee").val(data.consignee);
						   $("#lastName").val(data.lastName);
						   $("#email").val(data.email);
						   $("#address").val(data.address);
						   $("#postcode").val(data.postcode);
						   $("#phone").val(data.phone);
						   $("#mobilePhone").val(data.mobilePhone);
						   $("#flagContractor").val(data.flagContractor);
						   $("#bestSendDate_"+data.bestSendDate).attr("checked",true);
						   $("#isSendAddress_"+data.isSendAddress).attr("checked",true);
					   }
					});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/customerAcceptAddress/deleteCustomerAcceptAddress.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
				});
    		}
    	}
    </script>
  </head>
  
  <body onload="setup('省份','地级市','市、县级市、县')">
  <jsp:include page="../../util/item.jsp"/>
  	 <div class="main">
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div>
		</div>
  </body>
</html>
