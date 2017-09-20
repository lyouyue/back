<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(700,'auto',"&nbsp;&nbsp;金币流水详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/mallCoin/getVirtualCoinById.action",
			   data: {mallCoinId:id},
			   dataType: "JSON",
			   success: function(data){
				   var frozenNumber;
				   if(data.frozenNumber==null||data.frozenNumber==""){
					   frozenNumber=0;
				   }else{
					   frozenNumber=data.frozenNumber;
				   }
				   $("#dfrozenNumber").html(frozenNumber);
				   $("#dbackMsg").val(data.remarks);
			   }
		});
	}
</script>
<div id="detailWin">
    <table align="center" class="addOrEditTable">
	    <tr>
	    	<td class="toright_td" width="150px">冻结数量:</td>
	    	<td class="toleft_td"><span id="dfrozenNumber"></span></td>
	    </tr>
		<tr>
	   	   <td class="toright_td" width="150px" colspan="1">备注:&nbsp;&nbsp;</td>
		   <td class="toleft_td">&nbsp;&nbsp;<textarea id="dbackMsg" rows="8" cols="60" style="margin-top:10px;"></textarea></td>
	    </tr>
    </table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
	</div>
</div>