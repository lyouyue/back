<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {  
               var options = {  
                     url : "${pageContext.request.contextPath}/back/customerReview/saveOrUpdateCustomerReview.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#customerReviewId").val(null);
	                      }
	                  };  
	                  $("#form1").ajaxSubmit(options);  
	                  //$("input.button_save").attr("disabled","disabled");
               });
       }
    });
  })
  function clickReview(id){
	 $("#xingxing").html("");
	 var tt = "";
	 if(id==1){
	 	tt = tt +"<img id='"+id+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
	 	for(var i=2;i<6;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		}
	 }else if(id==2){
		 for(var i=1;i<3;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
		 for(var i=3;i<6;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
	 }else if(id==3){
		 for(var i=1;i<4;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
		 for(var i=4;i<6;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
	 }else if(id==4){
		 for(var i=1;i<5;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
		 for(var i=5;i<6;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/kong.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
	 }else if(id==5){
		 for(var i=1;i<6;i++){
			 tt = tt + "<img id='"+i+"' src='${fileUrlConfig.sysFileVisitRoot_back}images/shi.png' width='20px' height='20px' onclick='clickReview(this.id);'/>";
		 }
	 }
	 $("#xingxing").html(tt);
	 $("#level").val(id);
  }
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="customerReviewId" type="hidden" name="customerReview.customerReviewId" value="">
        <input id="createTime" type="hidden" name="customerReview.createTime" value="">
        <input id="level" type="hidden" name="customerReview.level" value="">
	    <table align="center" class="addOrEditTable">
	    	<tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="customerId" name="customerReview.customerId">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
	    	<tr>
		      <td class="toright_td" width="150px">套餐信息:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		           <select id="productId" name="customerReview.productId">
		              <option value="-1">--请选择套餐--</option>
					  <s:iterator value="productInfoList">
					  	<option value="<s:property value="productId"/>"><s:property value="productName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">评价主题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="title" type="text" name="customerReview.title" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px">评价等级:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      	<div id="xingxing">
		      	</div>
		      </td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">评价内容:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="content" rows="8" cols="48"  name="customerReview.content" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">产品优点:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="advantage" type="text" name="customerReview.advantage" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">产品不足:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="shortcoming" type="text" name="customerReview.shortcoming" class="{validate:{required:true,maxlength:[250]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">审核状态:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="state_0"  type="radio" name="customerReview.state" checked="checked" value="0"/>未审核&nbsp;&nbsp;&nbsp;<input id="state_1"  type="radio" name="customerReview.state" value="1"/>已审核</td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">评价回复:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			       <textarea id="backReview" rows="8" cols="48"  name="customerReview.backReview" class="{validate:{required:true,maxlength:[500]}}"></textarea>
			  </td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px">回复状态:&nbsp;&nbsp;</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="backState_0"  type="radio" name="customerReview.backState" checked="checked" value="0"/>未回复&nbsp;&nbsp;&nbsp;<input id="backState_1"  type="radio" name="memberReview.backState" value="1"/>已回复</td>
		    </tr>
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
		<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
	</div>
  </form>
</div>
