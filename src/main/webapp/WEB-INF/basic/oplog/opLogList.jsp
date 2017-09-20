<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>操作日志信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"日志列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/opLog/listOpLog.action",
				idField:"opId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					//{field:"opId",title:"编号",width:20},
					{field:"opDesc",title:"操作功能",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
			             return "<a style='display:block;' id='"+rowData.opId+"' onclick='showDetailInfo(this.id);'>"+rowData.opDesc+"</a>";  
			      	  }  
					},
					{field:"userTrueName",title:"操作人",width:60},
					// {field:"opParams",title:"操作参数",width:150},
					{field:"ip",title:"IP",width:60},
					{field:"opDate",title:"操作时间",width:100}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true//true只可以选中一行
			});
			pageSplit();//调用分页函数
		});
    	
    function showDetailInfo(id){
		createWindow(800,300,"&nbsp;&nbsp;操作日志详情","icon-tip",false,"detailWin");
		$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/opLog/getOpLogObject.action",
				data: {opId:id},
				dataType: "JSON",
				success: function(data){
					$("#dopDesc").html(data.opDesc);
					$("#duserTrueName").html(data.userTrueName);
					$("#dip").html(data.ip);
					$("#dopDate").html(data.opDate);
					$("#dopParams").html(data.opParams);
				}
		});
	}
	   function query(){
		$("#tt").datagrid("clearSelections"); //取消所有选项
		queryParams={opDesc:$.trim($("#opDesc").val()),startTime:$.trim($("#s_startTime").val()),endTime:$.trim($("#s_endTime").val())};
		$("#tt").datagrid("reload",queryParams); 
		pageSplit(pageSize,queryParams);//调用分页函数
	  }
	  function reset(){
	      $("#opDesc").val("");
	      $("#s_startTime").val("");
	      $("#s_endTime").val("");
   	  }
    </script>
  </head>
  
  <body>
  <jsp:include page="../../util/item.jsp"/>
  		<div class="main">
			<table  class="searchTab">
				<tr>
					<td class="search_toright_td"  style="width:85px;">操作功能：</td>
					<td class="search_toleft_td"  style="width:160px;"><input id="opDesc" type="text" name="opDesc"/></td>
					<td class="search_toright_td" style="width:70px;">操作时间：</td>
					<td class="search_toleft_td" style="width:275px;">
						<input id="s_startTime" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'s_endTime\')||\'2050-10-01\'}'})"/> -
						<input id="s_endTime" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'s_startTime\')}',maxDate:'2050-10-01'})"/>
					</td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
		    </table> 
	  		<table id="tt"></table>
	  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 详情页 -->
			<jsp:include page="detailOpLog.jsp"/>
		</div>
  		</div>
  </body>
</html>
