<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
	 <script type="text/javascript">
	 //详情
		function getRightShowTypeInfo(id){
			$.ajax({
				   type: "POST",
				   dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/rightShow/getRightShowTypeObject.action",
			       data: {rightShowTypeId:id},
				   success: function(data){
						//显示 
						createWindow(500,'auto',"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
						//createDetailWindow("&nbsp;&nbsp;详情","icon-add",false,"win");
						$("#d_typeName").html(data.typeName);
						$("#d_show_"+data.showType).attr("selected",true);
				     }
				});
		}
	 </script>
		<div id="detailWin">
		     <table align="center" class="addOrEditTable" width="80%">
			    <tr>
			      <td class="toright_td" width="30%">分类名称:&nbsp;&nbsp;</td><td class="toleft_td">&nbsp;&nbsp;<span id="d_typeName"></span></td>
			    </tr>
			    <tr>
			      <td class="toright_td" width="30%">展示类别:&nbsp;&nbsp;</td>
			      <td  class="toleft_td">&nbsp;&nbsp;
			      <select disabled="disabled">
			      	<option selected="selected">---请选择类别---</option>
			      	<s:iterator value="modTypeList" var="modType">
				      	<option id="d_show_<s:property value='#modType.value'/>" value="<s:property value='#modType.value'/>"><s:property value="#modType.name"/></option>
			      	</s:iterator>
			      </select>
			      </td>
			    </tr>
		     </table>
 				<!-- <div style="text-align:center;padding:5px 0;">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
				</div> -->
				<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
				</div>
		  </div>  
