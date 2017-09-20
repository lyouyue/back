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
                         url : "${pageContext.request.contextPath}/back/rightShow/saveOrUpdateRightShowType.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 location.reload();//重新加载
                         }
                     };  
                     $("#form1").ajaxSubmit(options);
					  $("input.btnSubmit").attr("disabled","disabled");
                  });
		       }
		    });
		});
		//添加
		function addRightShowType(id){
			//准备初始数据 ,父亲分类 
			createWindow(500,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin"); 
			$("#parentId").val(id);
		}
		//编辑
		function editRightShowType(id){
			$.ajax({
			   type: "POST",
			   dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/rightShow/getRightShowTypeObject.action",
		       data: {rightShowTypeId:id},
			   success: function(data){
		    	   //显示 
		    	    createWindow(500,'auto',"&nbsp;&nbsp;编辑","icon-edit",false,"addOrEditWin"); 
		    	    $("#rightShowTypeId").val(data.rightShowTypeId);
		    	    $("#parentId").val(data.parentId);
					$("#typeName").val(data.typeName);
					$("#show_"+data.showType).attr("selected",true);
				}
			});
		}
		//保存信息
		function submitForm(){
			$("#form1").submit();
		}
	</script>
  	 <!-- 新增分类  -->
	  <div id="addOrEditWin" >
		    <form id="form1"  method="post" action="">
		        <input id="rightShowTypeId" type="hidden" name="rightShowType.rightShowTypeId" />
		        <input id="parentId" type="hidden" name="rightShowType.parentId" />
			    <table align="center" class="addOrEditTable" width="80%">
				    <tr>
				      <td class="toright_td" width="30%">模块名称:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;<input id="typeName" type="text" name="rightShowType.typeName" class="{validate:{required:true,maxlength:[15]}}"/></td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="30%">展示类别:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;
				      <select name="rightShowType.showType">
				      	<option selected="selected">---请选择类别---</option>
				      	<s:iterator value="modTypeList" var="modType">
					      	<option id="show_<s:property value='#modType.value'/>" value="<s:property value='#modType.value'/>"><s:property value="#modType.name"/></option>
				      	</s:iterator>
				      </select>
				      </td>
				    </tr>
			    </table>
			    <div region="south" border="false" style="margin-top:10px; text-align: center; height: 30px; line-height: 30px;">
   		      		<a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" href="javascript:submitForm()">保存</a> 
           	 		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
           		</div>
			</form>
	  </div>
		 
