<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>首页右面展示信息</title>
    <jsp:include page="../../util/import.jsp"/>
	
    <script type="text/javascript">
    $(function(){
		   var rstId = '<s:property value="rightShowTypeId"/>';
		   var type = '<s:property value="type"/>';
		    $("#form1").form({
		        url:"${pageContext.request.contextPath}/back/rightShow/saveOrUpdateRightShowInfo.action",
		        onSubmit:function(){
		        	var num=$("input[type=checkbox][name=productInfos][checked]").length;
					if(num==0){
						msgShow("系统提示", "<p class='tipInfo'>请选择品牌！</p>", "warning");  
						return false;
					}
		        },
		        success:function(data){
		        	//$("input.button_save").attr("disabled","disabled");
		        	closeWin();
		        	$("#tt").datagrid("reload");//刷新加载列表信息
		        }
		    }); 
		   $("#tt").datagrid({//数据表格
				title:"首页右面展示品牌信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/rightShow/listRightShowBrandInfo.action?rightShowTypeId="+rstId,
				queryParams:{pageSize:pageSize},                                                         
				idField:"rightShowInfoId",//唯一性标示字段 
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"name",title:"商品ID",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               return "<a style='display:block;cursor: pointer;' id='"+rowData.showThingId+"' onclick='showDetailInfo(this.id);'>"+rowData.showThingId+"</a>";  
		         	  }  
					}, 
					{field:'flagNo',title:'展示类别',width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "商品展示";} 
	                        if(value=="2"){ return "品牌展示";} 
	                        if(value=="3"){ return "品种展示";} 
                            }
                 		},
					{field:"sort",title:"展示排序",width:200} 
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加商品索引",
					iconCls:"icon-add",
					handler:function(){
						createWindow(800,500,"&nbsp;&nbsp;添加商品","icon-add",false,"win");
						$("#form1").css("display","");
						$("#detailWin").css("display","none");
						getProductInfoList();//获取商品信息
					}
				},"-",{
					text:"删除商品索引",
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
											if(i==rows.length-1)ids+=rows[i].rightShowInfoId;
											else ids+=rows[i].rightShowInfoId+",";
										}
										$.ajax({
										   type: "POST",
										   dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/rightShow/deleteRightShowInfo.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   $("#tt").datagrid("reload"); //删除后重新加载列表
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
			 var ptId=$("#ptId").val();
			 $.ajax({//获取MES牌号信息
				   type: "POST",
				   url: "${pageContext.request.contextPath}/back/rightShow/listProductInfo.action",
				   data: {ptId:ptId},
				   dataType: "JSON",
				   success: function(data){
					   var htmlStr="<tr style='background-color: #C4E1FF;font-weight: bolder;'><td width='8px' class='toleft_td'><input type='checkbox' onclick='checkedAll(this)'></td><td width='250px' class='toleft_td'>&nbsp;&nbsp;品牌名称</td><td width='250px' class='toleft_td'>&nbsp;&nbsp;排序号</td></tr>";
					   for(i=0;i<data.length;i++){
						   htmlStr+="<tr><td width='8px' class='toleft_td'><input type='checkbox' onclick='checkedOne(this)' class='productInfos' id='"+i+"' name='productInfos' value='"+data[i].productId+"_"+data[i].productFullName+"'></td>"+
						   "<td width='250px' class='toleft_td'>&nbsp;&nbsp;"+data[i].productFullName+"</td><td width='150px' class='toleft_td'>&nbsp;&nbsp;"+
						   "<input type='text' id='dis_"+i+"' name='sorts' style='display:none'/></td></tr>";
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
		    	    $("#dis_"+0).focus();
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
		    	$("#dis_"+idIndex).focus();
		    }else{
		    	$("#dis_"+idIndex).val(" ");
		    	$("#dis_"+idIndex).css("display","none");
		    }
		}
    </script>
  </head>
  <style type="text/css">
   	 .querybtn a{height:28px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
   </style>
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
  		<jsp:include page="detailBrand.jsp"></jsp:include>
  		<form id="form1" action="post">
  				<input type="hidden" name="rightShowTypeId" value="${rightShowTypeId}">
  				<input type="hidden" name="type" value="${type}">
  				<table align="center" class="addOrEditTable">
  					<tr>
  						<td class="toright_td"width="100px;">商品信息：</td>
  						<td class="toleft_td" height="10px;">
  							<div style="margin:10px 10px 0px 10px">
  							商品分类： <select id="ptId" name="ptId">
							              <option value="-1">--请选择分类--</option>
										  <s:iterator value="productTypeList">
										  	<option value="<s:property value="productTypeId"/>"><s:property value="sortName"/></option>
										  </s:iterator>
							          </select>
  							 &nbsp;&nbsp;<span ><a href="javascript:getProductInfoList();" id="btn1" iconCls="icon-search" >查询</a></span>
  							</div>
  							<div style="margin:0px 10px 10px 10px; width:600px;height:400px;overflow-y:scroll;">
				         		<table id="subTalbe" class="addOrEditTable" width="600px" height="400px;"></table>
			    		 	</div>
  						</td>
  					</tr>
  				</table>
  				 <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
					<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
					<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
				</div>
  			</form>
		</div>
  </body>
</html>
