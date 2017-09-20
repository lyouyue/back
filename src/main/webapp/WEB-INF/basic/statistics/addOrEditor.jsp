<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){//表单验证
		$("#form1").validate({meta: "validate", 
		submitHandler:function(form){
		$(document).ready(
			function() {  
				var options = {  
					url : "${pageContext.request.contextPath}/back/statistics/saveOrUpdateStatistics.action",  
					type : "post",  
					dataType:"json",
					success : function(data) { 
						closeWin();
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload"); //保存后重新加载列表
						$("#statisticsId").val(null);
						}
					};  
					$("#form1").ajaxSubmit(options);  
					$("input.button_save").attr("disabled","disabled");//防止重复提交
				});
			}
		});
	})
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="statisticsId" type="hidden" name="statistics.statisticsId"  noclear="true">
	    <table align="center" class="addOrEditTable" style="width:90%;">
	       <tr>
	         <td class="toright_td" width="150px"><font style="color: Red">* </font>模块类型:</td>
		    	<td class="toleft_td" >&nbsp;
		           <select id="statisticsType" name="statistics.statisticsType" class="{validate:{required:true,maxlength:[200]}}" style="width:30%;">
		             <option value="">请选择</option>
		              <s:iterator value="#application.keybook['statisticsType']" var="kb">
						<option value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
					</s:iterator>
		           </select>
		     	 </td>
		     	 </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="statisticsName" type="text" name="statistics.statisticsName" style="width:40%;" class="{validate:{required:true,maxlength:[200]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>名称编码:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="statisticsCode" type="text" name="statistics.statisticsCode"  style="width:40%;" class="{validate:{required:true,number:true}}" readonly="readonly"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>展示内容:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="statisticsNum" type="text" name="statistics.statisticsNum" style="width:40%;" class="{validate:{required:true,maxlength:[200]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>背景颜色:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="statisticColor" type="text" name="statistics.statisticColor" style="width:40%;" class="{validate:{required:true,maxlength:[200]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><font style="color: Red">* </font>排序:</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="statistics.sortCode"  style="width:40%;" maxlength="4" class="{validate:{required:true,number:true}}"></td>
		    </tr>
		    <tr>
		    	<td class="toright_td"><font style="color: Red">* </font>是否显示:</td>
			    <td  class="toleft_td" >&nbsp;&nbsp;
				    <input id="isShow_0"  type="radio" name="statistics.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;&nbsp;
				    <input id="isShow_1"  type="radio" name="statistics.isShow" value="1"/>显示</td>
			    </td>
	    	</tr>
	    	<tr>
		      <td class="toright_td" width="150px">链接:</td>
		      <td  class="toleft_td">&nbsp;&nbsp;<input id="statisticsUrl" type="text" name="statistics.statisticsUrl" style="width:40%;" class="{validate:{maxlength:[500]}}"></td>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
  </form>
</div>
