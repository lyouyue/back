<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>商品金币政策信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
    		 $("#form1").form({
		        url:"${pageContext.request.contextPath}/back/productpoint/saveOrUpdateProductPoint.action",
		        onSubmit:function(){
		        	var num=$("input[type=checkbox][name=productInfos][checked]").length;
					if(num==0){
						msgShow("系统提示", "<p class='tipInfo'>请填写指标再保存！</p>", "warning");  
						return false;
					}
		        	validateData();
		        	return $(this).form("validate");
		        },
		        success:function(data){
		        	 window.location.reload(); //提交表单后重新刷新本页
		        }
		    });

    		$("#form2").validate({meta: "validate",
		       submitHandler:function(form){
		       $(document).ready(
		            function() {
		               var options = {
		                     url : "${pageContext.request.contextPath}/back/productpoint/saveOrUpdateProductPoint.action",
		                     type : "post",
		                     dataType:"json",
		                     success : function(data) {
		                    	 closeWin();
		                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
			                      }
			                  };
			                  $("#form2").ajaxSubmit(options);
			                  //$("input.button_save").attr("disabled","disabled");
		               });
		       }
		    });
		   $("#tt").datagrid({//数据表格
				title:"商品金币政策列表信息",
				iconCls:"icon-save",
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/productpoint/listProductPoint.action",
				queryParams:{pageSize:pageSize},
				idField:"productPointId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					 {field:"productPointId",title:"商品金币编号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.productPointId+"' onclick='showDetailInfo(this.id);'>"+rowData.productPointId+"</a>";
		         	  }
					},
					{field:"proName",title:"商品名称",width:120},
					{field:"integral",title:"金币值",width:120},
					{field:"endTime",title:"截止日期",width:120},
					{field:"updName,delName",title:"操作",width:120,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.productPointId+"' onclick='updOrDelSA(this.id,"+rowData.productPointId+",1);'>"+"修改"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.productPointId+"' onclick='updOrDelSA(this.id,"+rowData.productPointId+",2);'>"+"删除"+"</a>";
		         	  	}
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(800,'auto',"&nbsp;&nbsp;添加商品","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#form1").css("display","");
						$("#form2").css("display","none");
						$("#detailWin").css("display","none");
						getProductInfoList();//获取商品信息
					}
				},"-",{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].productPointId;
											else ids+=rows[i].productPointId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/productpoint/deleteProductPoint.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
									}
								}
							});
						}
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});
    	function getProductInfoList(){
			 var productName=$("#productName").val();
			 $.ajax({//获取MES牌号信息
				   type: "POST",
				   url: "${pageContext.request.contextPath}/back/productpoint/listProductInfo.action",
				   data: {productName:productName},
				   dataType: "JSON",
				   success: function(data){
					   var htmlStr="<tr style='background-color: #C4E1FF;font-weight: bolder;'><td width='8px' class='toleft_td'><input type='checkbox' onclick='checkedAll(this)'></td><td width='250px' class='toleft_td'>&nbsp;&nbsp;商品名称</td><td width='150px' class='toleft_td'>&nbsp;&nbsp;金币值</td></tr>";
					   for(i=0;i<data.length;i++){
						   htmlStr+="<tr><td width='8px' class='toleft_td'><input type='checkbox' onclick='checkedOne(this)' class='productInfos'  id='"+i+"' name='productInfos' value='"+data[i].productId+"_"+data[i].productFullName+"'></td>"+
						   "<td width='250px' class='toleft_td'>&nbsp;&nbsp;"+data[i].productFullName+"</td><td width='150px' class='toleft_td'>&nbsp;&nbsp;"+
						   "<input type='text' id='dis_"+i+"'  name='integrals' style='display:none'/></td></tr>";
					   }
					   $("#subTalbe").html(htmlStr);
				   }
			});
		 }
    	// 选择所有
		function checkedAll(obj){//选中所有或者去掉所有选中的
			var isChecked=obj.checked;
		    if(isChecked){
		    	$(".productInfos").each(function() {
		    	    $(this).attr("checked", true);
		    	    var idIndex=$(this).attr("id");
		    	    $("#dis_"+idIndex).css("display","");
		    	    $("#dis_"+idIndex).val("");
		    	});
		    }else{
		    	$(".productInfos").each(function() {
		    	    $(this).attr("checked", false);
		    	    var idIndex=$(this).attr("id");
		    	    $("#dis_"+idIndex).val(" ");
		    	    $("#dis_"+idIndex).css("display","none");
		    	});
		    }
		}
    	// 选择一个
		function checkedOne(obj){
			var idIndex=obj.id;
			var isOneChedcked=obj.checked;
			if(isOneChedcked){
		    	$("#dis_"+idIndex).css("display","");
		    	$("#dis_"+idIndex).val("");
		    }else{
		    	$("#dis_"+idIndex).val(" ");
		    	$("#dis_"+idIndex).css("display","none");
		    }
		}
		function validateData(){
			$(".productInfos").each(function() {
				if($(this).attr("checked")){
					var idIndex=this.id;
					$("#dis_"+idIndex).validatebox({required:true,missingMessage:'不可为空'});
				}
			});
		}
		
		function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
    					$("#addOrEditWin").css("display","");
						$("#form1").css("display","none");
						$("#form2").css("display","");
						$("#detailWin").css("display","none");
    			$.ajax({
					   type: "POST", dataType: "JSON",
					    url: "${pageContext.request.contextPath}/back/productpoint/getProductPointInfo.action",
					   data: {productPointId:id},
					   success: function(data){
						       $("#dproductPointId").val(data.productPointId);
							   $("#dproName").val(data.proName);
							   $("#proNameText").html(data.proName);
							   $("#dendTime").val(data.endTime);
							   $("#endTimeText").html(data.endTime);
							   $("#dproductId").val(data.productId);
							   $("#dintegral").val(data.integral);
					   }
					});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/productpoint/deleteProductPoint.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
				});
    		}
	    }
    </script>
    <style type="text/css">
   	 .querybtn a{height:28px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
    </style>
  </head>

  <body style="background:#F0FFF0;">
  		<table id="tt"></table>
  		<!-- 添加或者修改 -->
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		<jsp:include page="addOrEditor.jsp"/>
		<!-- 详情页面 -->
		<jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
