<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<script type="text/javascript">
function showShopSituationTagList(ttId,pageSize){
	$("#tt2").datagrid({//数据表格
		/* title:"未关联使用场合标签列表信息",
		iconCls:"icon-save",  */
		width:"auto",
		height:"auto",
		fitColumns: true,//宽度自适应
		align:"center",
		loadMsg:"正在处理，请等待......",
		//nowrap: false,//true是否将数据显示在一行
		striped: true,//true是否把一行条文化
		url:"${pageContext.request.contextPath}/back/shopTradeSituationTag/listShopSituationTag.action?ids="+ttId,
		idField:"stId",//唯一性标示字段
		frozenColumns:[[//冻结字段
		    {field:"ck",checkbox:true}
		]],
		columns:[[//未冻结字段
	        {field:"tageName",title:"标签名称",width:120}, 
			{field:"useState",title:"使用状态",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
					if(value=="0"){ 
						return "<font color='red'>废弃</font>";
					}else if(value=="1"){
						return "<font color='blue'>正常使用</font>";
					} 
				}
			}
		]],
		pagination:true,//显示分页栏
		rownumbers:true,//显示行号   
		singleSelect:true//true只可以选中一行
	});
	pageSplitThis(pageSize,queryParams,"tt2");//调用分页函数
}

//保存关联关系
function savaOrUpdateShopTradeSituationTag(){
	var rows = $("#tt2").datagrid("getSelections");//找到所有选中的行
	if(rows.length<=0){
		msgShow("系统提示", "<p class='tipInfo'>请选择关联项！</p>", "warning");
	}else{
		if (rows){
			var ids="";
			for(var i=0;i<rows.length;i++){
				if(i==rows.length-1)ids+=rows[i].stId;
				else ids+=rows[i].stId+",";
			}
			$.ajax({
			   type: "POST",dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/shopTradeSituationTag/savaOrUpdateShopTradeSituationTag.action",
			   data: {ids:ids,ttId:"${ids}"},
			   async : false,
			   success: function(data){
				   $("#tt2").datagrid("clearSelections");
				   $("#tt2").datagrid("reload");
				   $("#tt").datagrid("reload");
			   }
			});
		}	
	}
}

function queryTT2(){
	queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,tageName:$.trim($("#qtageName2").val()),useState:$("#quseState2").val()};
  	$("#tt2").datagrid("load",queryParams); 
	pageSplitThis(pageSize,queryParams,"tt2");//调用分页函数
}
function reset(){
	$("#qtageName2").val("");
   	$("#quseState2").val("");
}
</script>
<div id="addOrEditWin">
	<form id="form1"></form>
	<div style="width: 95%;margin: 10px auto;">
		<table style="border:1px solid #99BBE8;text-align: center;" width="100%">
		    	<tr>
		    		<td class="toright_td">标签名称 ：</td>
		    		<td class="toleft_td"><input type="text" id="qtageName2" />&nbsp;&nbsp;</td>
		    		<td class="toright_td">使用状态 ：</td>
		    		<td class="toleft_td"><select id="quseState2">
		              <option value="-1">--请选择--</option>
		              <option value="0">废弃</option>
		              <option value="1">正常使用</option>
		            </select>&nbsp;&nbsp;</td>
		    		<td>
		    		<!-- <a href="javascript:queryTT2();" id="btn2" iconCls="icon-search" >查询</a> -->
		    		<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:queryTT2()">查询</a>
	           		<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
		    		</td>
		    	</tr>
		    </table>
			<table id="tt2"></table>
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="savaOrUpdateShopTradeSituationTag()" href="javascript:;">保存</a>
		    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
	</div>
</div>
