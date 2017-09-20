<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript">
		//提交
    	function showDetailInfo(id){
			createWindow(1000,'auto',"&nbsp;&nbsp;订单明细详情","icon-tip",false,"detailWin");
			$.ajax({
			   type: "POST", 
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/orders/getOrderListObject.action",
			   data: {ordersNo:id},
			   success: function(data){
				   var uploadFileVisitRoot = data.uploadFileVisitRoot;
				   var ordersDetailList = data.ordersDetailList;
				  var htm = "";
				  htm+="<tr class='titlebg'><td align='center' colspan='13'>订单号:"+data.ordersNo+"<\/td><\/tr>";
				  htm+="<tr><td width='85px' align='center'>套餐图片<\/td><td width='120px' align='center'>套餐名称<\/td><td width='50px' align='center'>套餐编号<\/td><td width='50px' align='center'>市场价<\/td><td width='50px' align='center'>销售价<\/td><td width='50px' align='center'>购买数量<\/td><td width='50px' align='center'>条形码<\/td><td width='60px' align='center'>返利比例(一级)<\/td><td width='60px' align='center'>返利比例(二级)<\/td><td width='60px' align='center'>返利比例(三级)<\/td><td width='60px' align='center'>返利金额(一级)<\/td><td width='60px' align='center'>返利金额(二级)<\/td><td width='60px' align='center'>返利金额(三级)<\/td><\/tr>";
				  for(var i=0;i<ordersDetailList.length;i++){
					  htm+="<tr><td align='center' width='150px'> <img width='80px' height='50px' src='"+uploadFileVisitRoot+ordersDetailList[i].logoImage+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"'><\/img><\/td><td align='center'>"+ordersDetailList[i].productFullName+"<\/td><td align='center'>"+ordersDetailList[i].productCode+"<\/td><td align='center' >￥"+ordersDetailList[i].marketPrice.toFixed(2)+"<\/td><td align='center'>￥"+ordersDetailList[i].salesPrice.toFixed(2)+"<\/td><td align='center'>"+ordersDetailList[i].count+"<\/td><td align='center'>"+ordersDetailList[i].barCode+"<\/td>"+
					  "<td align='center' width='50px'>"+ordersDetailList[i].upRatio+"%"+"<\/td><td align='center' width='50px'>"+ordersDetailList[i].secRatio+"%"+"<\/td><td align='center' width='50px'>"+ordersDetailList[i].thiRatio+"%"+"<\/td><td align='center' width='50px'>"+ordersDetailList[i].upRatioAmount+"元"+"<\/td><td align='center' width='50px'>"+ordersDetailList[i].secRatioAmount+" 元"+"<\/td><td align='center' width='50px'>"+ordersDetailList[i].upRatioAmount+" 元"+"<\/td>"
					  +"<\/tr>";
				  }
				  $("#showDetail").html(htm);
			   }
			});
    	}
    </script>
	<div id="detailWin">
		<table align="center" id="showDetail" class="addOrEditTable" width="600px;" >
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
	</div>
