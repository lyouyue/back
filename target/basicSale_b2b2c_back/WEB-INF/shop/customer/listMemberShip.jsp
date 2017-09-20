<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>店铺VIP会员信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
    	$("#tt").datagrid({//数据表格
			/* title:"店铺VIP会员信息列表",
			iconCls:"icon-save",  */
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/memberShip/listMemberShip.action", 
			idField:"memberShipId",//唯一性标示字段
// 			frozenColumns:[[//冻结字段
// 			    {field:"ck",checkbox:false}
// 			]],
			columns:[[//未冻结字段
	            {field:"loginName",title:"会员名称",width:80},
				{field:"shopName",title:"店铺名称",width:80},
				{field:"discount",title:"折扣比例",width:80},
				{field:"state",title:"审核状态",width:50,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
						if(value==1){ 
							return "<font class='color_003'>待审核</font>";
						}else if(value==2){ 
							return "<font class='color_001'>审核通过</font>";
						}else if(value==3){ 
							return "<font class='color_002'>审核拒绝</font>";
						} 
                     }
				}
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号   
			singleSelect:true//true只可以选中一行
		});
		pageSplit(pageSize);//调用分页函数
    });
    
    function query(){
		  queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shopName:$("#qshopName").val(),state:$("#qstate").val()};
		  $("#tt").datagrid("load",queryParams); 
		  pageSplit(pageSize,queryParams);//调用分页函数
  	}
	function reset(){
		$("#qshopName").val("");
		$("#qstate").val("");
	}
    </script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:85px;">&nbsp;&nbsp;&nbsp;&nbsp;店铺名称：</td>
				<td class="search_toleft_td" style="width: 160px;"> 
				<input type="text"  id="qshopName" name="shopName" class="searchTabinput"/>
				</td>
				<td class="search_toright_td" style="width:75px;">审核状态：</td>
				<td class="search_toleft_td"  style="width:125px;">
					<select id="qstate" name="state" class="querySelect">
						<option value="">--请选择--</option>
						<option value="1">--待审核--</option>
						<option value="2">--审核通过--</option>
						<option value="3">--审核拒绝--</option>
					</select>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
	<table id="tt"></table>
	<div id="win" style="display:none;"></div>
	</div>
  </body>
</html>
