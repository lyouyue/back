<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>自营店铺商品信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
    		 $("#form1").form({
		        url:"${pageContext.request.contextPath}/back/shopProduct/saveOrUpdateShopProduct.action",
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
		   $("#tt").datagrid({//数据表格
				/* title:"店铺商品列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopProduct/findProductListByShopInfoId.action?shopInfoId=${shopInfoId}",
				queryParams:{pageSize:pageSize},                                                                                      
				idField:"shopInfoProductId",//唯一性标示字段
				columns:[[//未冻结字段
					{field:"productName",title:"商品名称",width:120},
					{field:"logoImg",title:"商品图片",width:100, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='60px' height='25px' />";  
		         	  }  
					},
					{field:"salesPrice",title:"销售价格",width:120},
					{field:"storeNumber",title:"库存数",width:120},
					{field:"isPutSale",title:"是否上架",width:100, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="1"){ return "<font class='color_002'>未上架</font>";} 
	                        if(value=="2"){ return "<font class='color_001'>已上架</font>";} 
	                        if(value=="3"){ return "<font class='color_003'>违规下架</font>";} 
                            }
                 	}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"返回自营店铺列表",
					iconCls:"icon-back",
					handler:function(){
						/*  location.href="${pageContext.request.contextPath}/back/shopinfo/gotoShopInfoPage.action"; */
						window.location.href = document.referrer;
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
	</script>
	<style type="text/css">
		.querybtn a{height:28px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
	</head>
	<body >
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<!-- <table class="searchTab">
		</table><br /> -->
		<table id="tt"></table>
	</div>
	</body>
</html>
