<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//提交
    	function showDetailInfo2(id){
			createWindow(900,"auto","&nbsp;&nbsp;订单日志信息","icon-tip",false,"detailWin2");
			$.ajax({
			   type: "POST", 
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/orders/getOrdersOPLogObject.action",
			   data: {ordersNo:id}, 
			   success: function(data){
				   var logList= eval(data.ordersOPLogList);
				   var showLog = "<tr class='titlebg'><td align='center' colspan='3'>订单号:&nbsp;&nbsp;&nbsp;&nbsp;"+data.ordersNo+"<\/td><\/tr>";
				   showLog+="<tr><td width='300px;'>操作类型<\/td><td width='300px;'>操作人<\/td><td width='300px;'>操作时间<\/td><\/tr>";
				   for(var i=0;i<logList.length;i++){
					   var state="";
					   if(logList[i].ordersOperateState==0||logList[i].ordersOperateState==1){
						   state="生成订单";
					   }else if(logList[i].ordersOperateState==2){
						   state="已付款";
					   }else if(logList[i].ordersOperateState==3){
						   state="已配货";
					   }else if(logList[i].ordersOperateState==4){
						   state="已发货";
					   }else if(logList[i].ordersOperateState==5){
						   state="完成";
					   }else if(logList[i].ordersOperateState==6){
						   state="取消订单";
					   }else if(logList[i].ordersOperateState==7){
						   state="异常订单";
					   }else if(logList[i].ordersOperateState==8){
						   state="修改订单";
					   }
					   showLog+="<tr><td>"+state+"<\/td><td>"+logList[i].operatorName+"<\/td><td>"+logList[i].operatorTime+"<\/td><\/tr>";
					}
				   $("#showLog").html(showLog);
			   }
			});
    	}
    </script>
	  <div id="detailWin2">
	  	<table id="showLog" align="center" class="addOrEditTable" width="900px;" height="500px;">
	   	</table>
   		 <div class="editButton"  data-options="region:'south',border:false" >
              <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
         </div>
	  </div>
