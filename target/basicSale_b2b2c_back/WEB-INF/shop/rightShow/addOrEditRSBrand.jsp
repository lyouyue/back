<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
	<script type="text/javascript">
		$(function(){
			//表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/rightShow/saveOrUpdateRightShowInfo.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 location.reload();//重新加载
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                  });
		       }
		    });
		});
		function submitForm(){
			$("#form1").submit();
		}
	</script>
  	 <!-- 新增分类  -->
	  <div id="addOrEditWin" >
		    <form id="form1"  method="post" action="">
		        <input id="rightShowTypeId" type="hidden" name="rightShowInfo.rightShowTypeId" />
			    <table align="center" class="addOrEditTable" width="100%">
				    <tr>
				      <td class="toright_td" width="30%">选择品牌:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;
				      	<select name="rightShowInfo.showThingId">
				      		<option>---请选择品牌---</option>
				      		<s:iterator value="#session.brandList">
				      			<option value="<s:property value="brandId"/>"><s:property value="brandName"/></option>
				      		</s:iterator>
				      	</select>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="30%">标识符:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;
				      	<input  type="text" style="width: 50px;" name="rightShowInfo.flagNo" value="2" readonly="readonly"/>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="30%">展示排序(位置):&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;
				      	<input id="typeName" type="text" name="rightShowInfo.sort" class="{validate:{required:true,maxlength:[3]}}"/>
				      </td>
				    </tr>
			    </table>
			    <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
   		      		<a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" href="javascript:submitForm()">保存</a> 
           	 		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
           		</div>
			</form>
	  </div>
