<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title></title>
		   <jsp:include page="../../util/import.jsp"/>
		   <link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/jqueryeasyui/themes/testTable.css">
<!-- 	   <link rel="stylesheet" type="text/css" href="css/testTable.css"/> -->
		<script>
		var products = [
		    {productid:'FI-SW-01',name:'一周动态'},
		    {productid:'K9-DL-01',name:'商城统计'},
		    {productid:'RP-SN-01',name:'两周动态'},
		    {productid:'RP-LI-02',name:'三周动态'},
		    {productid:'FL-DSH-01',name:'四周动态'},
		    {productid:'FL-DLH-02',name:'机构统计'},
		    {productid:'AV-CB-01',name:'用户动态'}
		];
		$(function(){
			$('#tt').datagrid({
				method:'get',
				singleSelect:true,
				idField:'itemid',
				url:'../../datagrid_data.json',
				fitColumns:true,
				pagination: true, //显示分页
				singleSelect:false,
				columns:[[
					{field:'ck',checkbox:true},
					{field:'productid',title:'消息类型',width:100,
						formatter:function(value){
							for(var i=0; i<products.length; i++){
								if (products[i].productid == value) return products[i].name;
							}
							return value;
						},
						editor:{
							type:'combobox',
							options:{
								valueField:'productid',
								textField:'name',
								data:products,
								required:true
							}
						}
					},
					{field:'attr1',title:'消息名称',width:80,editor:'text'},
					{field:'unitcost',title:'编码',width:80,align:'center',editor:'numberbox'},
					{field:'status',title:'消息内容',width:180,align:'center',editor:{type:'text'}},
					{field:'listprice',title:'更新时间',width:80,align:'center',editor:{type:'numberbox',options:{precision:1}}},
					{field:'action',title:'操作',width:80,align:'center',
						formatter:function(value,row,index){
							if (row.editing){
								var s = '<a href="#" onclick="saverow(this)">保存</a> ';
								var c = '<a href="#" onclick="cancelrow(this)">取消</a>';
								return s+c;
							} else {
								var e = '<a href="#" onclick="editrow(this)">设置</a> ';
								var d = '<a href="#" onclick="deleterow(this)">删除</a>';
								return e+d;
							}
						}
					}
				]],
				onBeforeEdit:function(index,row){
					row.editing = true;
					updateActions(index);
				},
				onAfterEdit:function(index,row){
					row.editing = false;
					updateActions(index);
				},
				onCancelEdit:function(index,row){
					row.editing = false;
					updateActions(index);
				}
			});
		});
		function updateActions(index){ //更新当前行的方法
			$('#tt').datagrid('updateRow',{
				index:index,
				row:{}
			});
		}
		function getRowIndex(target){//获取当前行index
			var tr = $(target).closest('tr.datagrid-row');
			return parseInt(tr.attr('datagrid-row-index'));
		}
		function editrow(target){//编辑当前行
			$('#tt').datagrid('beginEdit', getRowIndex(target));
		}
		function deleterow(target){//删除当前行
			$.messager.confirm('Confirm','确定删除该信息吗?',function(r){
				if (r){
					$('#tt').datagrid('deleteRow', getRowIndex(target));
				}
			});
		}
		function saverow(target){//结束编辑并保存内容
			$('#tt').datagrid('endEdit', getRowIndex(target));
		}
		function cancelrow(target){//取消编辑
			$('#tt').datagrid('cancelEdit', getRowIndex(target));
		}
		function insert(){//添加新行的方法

			$("#myDialog").dialog({
				closed:false,
				buttons:[{
					text:'保存',
					iconCls:'icon-save',
					handler:function(){
							$('#myDialogFrom').submit();
						}
					},{
					text:'取消',
					iconCls:'icon-cancel',
					handler:function(){
						$('#myDialog').dialog('close');
					}
				}]
			});





			// var row = $('#tt').datagrid('getSelected');
			// var index = 0;
			// if (row){
			// 	index = $('#tt').datagrid('getRowIndex', row);
			// }
			// $('#tt').datagrid('insertRow', {
			// 	index: index,
			// 	row:{}
			// });
			// $('#tt').datagrid('selectRow',index);
			// $('#tt').datagrid('beginEdit',index);
		}
		function reject(){//删除选中行的方法
			var row = $('#tt').datagrid('getSelections');
			var temID = [];
			if(row.length==0) {
	            $.messager.alert("提示", "请选择要删除的行！", "info");  
	            return;  
	        }else{
	            for (i = 0; i < row.length;i++) {  
	            	//console.log(row[i]);
	            	temID.push($('#tt').datagrid('getRowIndex',row[i]));          
	            }
	            $.messager.confirm('提示', '是否删除选中数据?', function (r) {
	                if(!r){return;}
	                for(var i = (temID.length-1);i >= 0;i--){	           
	                	$('#tt').datagrid('deleteRow',Number(temID[i]));
	                };
	            temID = [];
				//$('#tt').datagrid('reload');//删完重新加载
				
//提交
//              $.ajax({  
//                  type: "POST",  
//                  async: false,  
//                  url: "/EvaluationTemplate/DelTem?id=" + temID,  
//                  data: temID,  
//                  success: function (result) {  
//                      if (result.indexOf("t") <= 0) {  
//                          $('#dg').datagrid('clearSelections');  
//                          $.messager.alert("提示", "恭喜您，信息删除成功！", "info");  
//                          $('#dg').datagrid('reload');  
//                      } else {  
//                          $.messager.alert("提示", "删除失败，请重新操作！", "info");  
//                          return;  
//                      }  
//                  }  
//              });  
           });  
        }  
//			if (row) {
//		         var rowIndex = $('#tt').datagrid('getRowIndex', row);
//		         $('#tt').datagrid('deleteRow', rowIndex);  
//		         $('#tt').datagrid('reload');//删除后重新加载下
//			 }
		}
		//刷新当前表格的方法
		function getChanges(){
			$('#tt').datagrid('reload');
		}
		
		//查询当前表格的方法
		function doSearch(){
			$('#tt').datagrid('load',{
				searchName: $('#searchName').val(),
				startTime: $('#startTime').datebox('getValue'),
				endTime:$('#endTime').datebox('getValue')
			});
		}
		//清除当前搜索的方法
		function clearSearch(){
			$('#searchName').textbox('setValue','');
			$('#startTime').datebox('setValue','');
			$('#endTime').datebox('setValue','');
		}
		//为弹层表单设置submit方式
		$('#myDialogFrom').form({
		    url:"#",
		    onSubmit: function(param){
				console.log(param);
		    },
		    success:function(data){
				alert(data)
		    }
		});

	</script>
	<style>
		.datagrid-row-selected {
			  background-color: #ffffff;
			  color: #000000;
			}
		#myDialogFrom{
			height: 100%;
			box-sizing: border-box;
			overflow: hidden;
		}
		#myDialogFrom table{
			box-sizing: border-box;
		    width: 96%;
		    height: 90%;
		    margin: auto;
		    margin-top: 2%;
		    border: 1px solid #eee;
		}
		#myDialogFrom tr td:nth-child(1){
			width: 30%;
			text-align: right;
			background-color: #f2f2f2;
			box-sizing: border-box;
		}
		#myDialogFrom tr{
			height: 20%;
		}
		#myDialogFrom tr:nth-child(3){
			height: 40%;
		}
		#myDialogFrom input[type="radio"]{
			vertical-align: bottom;
		}
	</style>

	</head>

	<body>
		

		<div id="cc" class="easyui-layout" data-options="fit:true" style="width:600px;height:400px;">
			<div data-options="region:'center',title:'系统信息消息'" style="padding:5px;background:#eee;">
				<div id="TableSearch">
					名称: <input id="searchName" class="easyui-textbox" type="text" name="name"></input>
					起始时间: <input id="startTime" class="easyui-datebox"></input>
					结束时间: <input id="endTime" class="easyui-datebox"></input>
					<a onclick="doSearch()" href="#" class="easyui-linkbutton" iconCls="icon-search">查询</a>
					<a onclick="clearSearch()" href="#" class="easyui-linkbutton" iconCls="icon-undo">重置</a>
				</div>
				<div id="TableBox">
				<div id="tb" style="height:auto">
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="insert()">添加</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-send',plain:true" onclick="removeit()">发送</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="reject()">删除</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="getChanges()">刷新</a>
				</div>
				<table id="tt">
					
				</table>
				</div>
			</div>
		</div>
		
		<div id="myDialog" class="easyui-dialog" style="width:600px;height:300px"
				data-options="title:'添加消息',modal:false,closed:true">
			<form id="myDialogFrom" method="post">
				<table border="1" cellspacing="0">
					<tr>
						<td>消息类型:</td>
						<td>
							<select class="easyui-combobox" name="messageType">
								<option value="AL">一周动态</option>
								<option value="AK">商城统计</option>
								<option value="AZ">优惠活动</option>
								<option value="AR">账号安全</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>消息名称:</td>
						<td><input name="messageName" class="easyui-textbox" style="width:80%;height:32px"></td>
					</tr>
					<tr>
						<td>消息内容:</td>
						<td><input name="messageContent" class="easyui-textbox" data-options="multiline:true" style="width:80%;height:95%"></td>
					</tr>
					<tr>
						<td>保存时是否发送消息:</td>
						<td>
							<label for="yesSend">发送</label><input id="yesSend" type="radio" class="easyui-radio" name="sendMessage">
							<label for="noSend">不发送</label><input id="noSend" type="radio" class="easyui-radio" name="sendMessage">
						</td>
					</tr>
				</table>
			</form>
		</div>



	</body>

</html>