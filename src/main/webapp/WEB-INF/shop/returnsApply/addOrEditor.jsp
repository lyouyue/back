<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
<%--    $("#form1").form({--%>
<%--       url:"${pageContext.request.contextPath}/back/returnsApply/saveOrUpdateReturnsApply.action",--%>
<%--       onSubmit:function(){--%>
<%--	       var s1 = $("#s1").val();--%>
<%--	       var s2 = $("#s2").val();--%>
<%--	       var s3 = $("#s3").val();--%>
<%--	       var address = $("#address").val();--%>
<%--	       $("#shippingAddress").val(s1+s2+s3+address);--%>
<%--       	fillHiddenUrlsValue();//将urls填充到隐藏域中 函数在handlers.js中--%>
<%--           return $(this).form('validate');--%>
<%--       },--%>
<%--       success:function(data){--%>
<%--       	 window.location.reload(); //提交表单后重新刷新本页--%>
<%--       }--%>
<%--   }); --%>
 	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {
           	 var s1 = $("#s1").val();
		     var s2 = $("#s2").val();
		     var s3 = $("#s3").val();
		     var address = $("#address").val();
		     $("#shippingAddress").val(s1+s2+s3+address);
               var options = {  
                     url : "${pageContext.request.contextPath}/back/returnsApply/saveOrUpdateReturnsApply.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) { 
                    	 closeWin();
                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表  
					 $("#returnsApplyId").val(null);
	                      }
	                  };  
               		  var productId=$("select option:selected").val();
               		  if(productId == -1){
						  msgShow("系统提示", "<p class='tipInfo'>没有套餐不能退货！</p>", "warning");  
               			  return false;
               		  }else{
               			  $("#form1").ajaxSubmit(options);
               			//$("input.button_save").attr("disabled","disabled");
               		  }
               });
       }
    });
  })
  
   function getCustomerId(){
   		var customerId=$("select option:selected").val();
   		getOrdersByCustomerId(customerId);
   	}
 	function getOrdersByCustomerId(customerId){
  		$.ajax({
  			url:"${pageContext.request.contextPath}/back/returnsApply/findordersByCustomerId.action",
  			type:"post",
  			dataType:"json",
  			data:{customerId:$("#customerId").val()},
  			success:function(data){
  				var ordersList=data;
  				if(ordersList.length>0){
	   				var htmlStr="<select id='ordersId' name='returnsApply.ordersId' onchange='getOrdersId();'>";
	   				htmlStr+="<option>---请选择订单---</option>";
	   				for(i=0;i<ordersList.length;i++){
	   					htmlStr+="<option id='orders_"+ordersList[i].ordersId+"' value='"+ordersList[i].ordersId+"'>"+ordersList[i].ordersNo+"</option>"
	   				}
 		            htmlStr+="</select>";
 		            $("#ordersListHtml").html(htmlStr);
		        }else{
		        	$("#ordersListHtml").html("<font color=\"red\">该会员没有订单信息!</font>");
		        }
  			}
  		});
   	}
   	 function getOrdersId(){
   		var ordersId=$("select option:selected").val();
   		getOrdersListByOrdersId(ordersId);
   	}
  	  function getOrdersListByOrdersId(ordersId){
  		$.ajax({
  			url:"${pageContext.request.contextPath}/back/returnsApply/findOrdersListListByOrdersId.action",
  			type:"post",
  			dataType:"json",
  			data:{ordersId:$("#ordersId").val()},
  			success:function(data){
  				var ordersLisList=data;
  				if(ordersLisList.length>0){
	   				var htmlStr="<select id='productId' name='returnsApply.productId' onchange='getProductAccessories();'>";
	   				htmlStr+="<option>---请选择套餐---</option>";
	   				for(i=0;i<ordersLisList.length;i++){
	   					htmlStr+="<option id='ordersList_"+ordersLisList[i].orderListId+"' value='"+ordersLisList[i].productId+"'>"+ordersLisList[i].shopName+"</option>"
	   				}
 		            htmlStr+="</select>"
 		            $("#ordersListListHtml").html(htmlStr);
		         }else{
		        	 $("#ordersListListHtml").html("<font color=\"red\">该订单没有套餐信息!</font>");
		         }
  			}
  		});
  	}
  	  //得到套餐附件
  	  function getProductAccessories(){
  		  var productId=$("select option:selected").val();
  		  $.ajax({
  			url:"${pageContext.request.contextPath}/back/returnsApply/getProductInfoByProductId.action",
  			type:"post",
  			dataType:"json",
  			data:{productId:$("#productId").val()},
  			success:function(data){
  				if(data!=null){
  					$("#ddproductAccessories").html(data.standard);
  					$("#productAccessories").val(data.standard);
  				}
  			}
  		});
  	  }
  	 //判断是否隐藏收获地址
  	function hidenAddress(id){
  		 var split = id.split("_");
  		 if(split[1]==2){
  			 $("#div1").css("display","none");
  		 }else{
  			 $("#div1").css("display","");
  		 }
  	 }
  	 //判断收获地址是否与原地址相同
  	 function verdictAddress(id){
  		 var split = id.split("_");
  		 if(split[1]==1){
  			 $("#div2").css("display","");
  		 }else{
  			 $("#div2").css("display","none");
  		 }
  	 }
</script>
<div id="addOrEditorWin">
    <form id="form1"  method="post">
        <input id="returnsApplyId" type="hidden" name="returnsApply.returnsApplyId" value="">
        <input id="shippingAddress" type="hidden" name="returnsApply.shippingAddress" value="">
        <input id="productAccessories" type="hidden" name="returnsApply.productAccessories" value="">
        <input id="applyTime" type="hidden" name="returnsApply.applyTime" value="">
        <input id="ecustomerId" type="hidden" name="ecustomerId" value="">
        <input id="ereturnsApplyNo" type="hidden" name="ereturnsApplyNo" value="">
        <input id="eordersId" type="hidden" name="eordersId" value="">
        <input id="eordersNo" type="hidden" name="eordersNo" value="">
        <input id="eproductId" type="hidden" name="eproductId" value="">
        <input id="eproductName" type="hidden" name="eproductName" value="">
        <input id="edproductAccessories" type="hidden" name="edproductAccessories" value="">
        <input id="edshippingAddress" type="hidden" name="shippingAddress"  value="">
<%--        <input id="updateMember" type="hidden" name="updateMember"  value="">--%>
	    <table align="center" class="addOrEditTable">
	    	<tr>
		      <td class="toright_td" width="150px">会员名称:</td>
		      <td class="toleft_td">
		           <select id="customerId" name="returnsApply.customerId" onchange="getCustomerId();">
		              <option value="-1">--请选择会员--</option>
					  <s:iterator value="customerList">
					  	<option value="<s:property value="customerId"/>"><s:property value="loginName"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
				<td class="toright_td" width="150px">订单信息:</td>
				<td><span id="ordersListHtml"></span></td>
  			</tr>
  			<tr>
				<td class="toright_td" width="150px">套餐信息:</td>
				<td><span id="ordersListListHtml"></span><span id="ordersListListHtmls"></span></td>
  			</tr>
  			<tr>
		      <td class="toright_td" width="150px">期望处理方式:</td>
			  <td class="toleft_td">&nbsp;&nbsp;<input id="disposeMode_2" type="radio" name="returnsApply.disposeMode" value="2" onclick="hidenAddress(this.id);"/>退货</td>
		    </tr>
		    <tr>
	   	      <td class="toright_td" width="150px" colspan="1">问题描述:</td>
			      <td  class="toleft_td">
			       <textarea id="problemDescription" rows="8" cols="48" style="width:690px;height:300px;visibility:hidden;" name="returnsApply.problemDescription" class="{validate:{required:true,maxlength:[500]}}"></textarea>
				   <script type="text/javascript">
						KindEditor.ready(function(K){
							var editor1 = K.create('#problemDescription',{
								cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
								uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subSys=shop",
								fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subSys=shop",
								allowFileManager : false,
								allowPreviewEmoticons : false,
								items : [
			                              'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'cut', 'copy', 'paste',
			                              'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
			                              'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
			                              'superscript', 'clearhtml', 'selectall', '|', 'fullscreen', '|',
			                              'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
			                              'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image',
			                              'table', 'hr', 'emoticons', 'pagebreak', 'link', 'unlink'
			                          ],
			                    filterMode : false
							});
							prettyPrint();
						});
				   </script>
			  </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐外观:</td>
		      <td class="toleft_td">
		           <select id="tradeDress" name="returnsApply.tradeDress">
		              <option value="-1">--请选择外观--</option>
					  <s:iterator value="#application.keybook['tradeDress']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐包装:</td>
		      <td class="toleft_td">
		           <select id="commodityPackaging" name="returnsApply.commodityPackaging">
		              <option value="-1">--请选择包装--</option>
					  <s:iterator value="#application.keybook['commodityPackaging']" var="kb">
					  	<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					  </s:iterator>
		           </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">返修凭据:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="repairCredentials" type="checkbox" name="returnsApply.repairCredentials" value="0"/>有发票</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐附件:</td>
		      <td class="toleft_td" colspan="3"><span id="ddproductAccessories"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">期望返回方式:</td>
			  <td class="toleft_td">
			  	&nbsp;&nbsp;<input id="returnsMode_0" type="radio" name="returnsApply.returnsMode" value="0"/>会员送货至售后<br/>
			  	&nbsp;&nbsp;<input id="returnsMode_1" type="radio" name="returnsApply.returnsMode" value="1"/>会员邮寄套餐至售后<br/>
			  	&nbsp;&nbsp;<input id="returnsMode_2" type="radio" name="returnsApply.returnsMode" value="2"/>上门取货
			  </td>
		    </tr>
	    	 <tr style="display: " id="div1">
		      <td class="toright_td" width="150px">收获地址:</td>
			  <td class="toleft_td">
			  	&nbsp;&nbsp;<input id="shippingAddress_0" type="radio" name="isAddress" value="0" onclick="verdictAddress(this.id)"/>与取货地址相同<br/>
			  	&nbsp;&nbsp;<input id="shippingAddress_1" type="radio" name="isAddress" value="1" onclick="verdictAddress(this.id)"/>与取货地址不同<br/>
			  </td>
		    </tr>
		    <tr id="div2" style="display: none;">
	  			<td class="toright_td" width="150px">省市区：</td>
	  			<td class="toleft_td">&nbsp;&nbsp;
   				  	 <select id="s1" class="{validate:{required:true}}">
						<option>省份</option>
					</select>
					<select id="s2" class="{validate:{required:true}}">
						<option>地级市</option>
					</select>
					<select id="s3" class="{validate:{required:true}}">
						<option>市、县级市、县</option>
					</select>
					详细地址：<input type="text" name="address" id="address" value="" class="{validate:{required:true,maxlength:[50]}}"/>
	  			</td>
	  		</tr>
		    <tr>
		      <td class="toright_td" width="150px">联系人:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="linkman" type="text" name="returnsApply.linkman" class="{validate:{required:true,maxlength:[15]}}"/></td>
		    </tr>
		     <tr>
		      <td class="toright_td" width="150px">手机号码:</td>
		      <td class="toleft_td" colspan="3">&nbsp;&nbsp;<input id="mobilePhone" type="text" name="returnsApply.mobilePhone" class="{validate:{required:true,maxlength:[20]}}"/></td>
		    </tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
