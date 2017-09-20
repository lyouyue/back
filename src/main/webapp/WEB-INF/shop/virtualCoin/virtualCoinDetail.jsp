<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/virtualCoin/getVirtualCoinById.action",
			   data: {customerId:id},
			   dataType: "JSON",
			   success: function(data){
				   var list = data;
				   var listHtml="<tr><td style='text-align: center;'>序号<\/td><td style='text-align: center;'>流水号<\/td><td style='text-align: center;'>类型<\/td><td style='text-align: center;'>交易数量<\/td><td style='text-align: center;'>剩余数量<\/td> <td style='text-align: center;'>交易时间<\/td>  <\/tr>";
				   for(var i=0;i<list.length;i++){
					   var type="";
					   if(list[i].type==1){                         
						   type="收入";
					   }else{
						   type="支出";
					   }
					   listHtml+="<tr><td style='text-align: center;'>"+Number(parseInt(i)+parseInt(1))+"<\/td><td style='text-align: center;'>"+list[i].serialNumber+"<\/td><td style='text-align: center;'>"+type+"<\/td><td style='text-align: center;'>"+list[i].transactionNumber+"<\/td><td style='text-align: center;'>"+list[i].remainingNumber+"<\/td><td style='text-align: center;'>"+list[i].tradeTime+"<\/td><\/tr>";
				   }
				   $("#showDetail").html(listHtml);
			   }
		});
	}
</script>
<div id="detailWin">
    <table id="showDetail" align="center" class="addOrEditTable" width="850px;">
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
</div>