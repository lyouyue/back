<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>卖家会员信息</title>
    <meta http-equiv="Cache-Control" content="no-cache"/>
  	<meta http-equiv="Expires" content="-1"/>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
    	$("#tt").datagrid({//数据表格
			title:"卖家会员列表信息",
			iconCls:"icon-save", 
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/sellersRecord/listSRCustomer.action", 
			idField:"customerId",//唯一性标示字段
			frozenColumns:[[//冻结字段
			    {field:"ck",checkbox:true}
			]],
			columns:[[//未冻结字段
	            {field:"loginName",title:"登录名称",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	               return "<span id='"+rowData.customerId+"'>"+rowData.loginName+"</span>";  
	         	  }  
				},
				{field:"trueName",title:"真实姓名",width:80},
				{field:"type",title:"会员类别",width:60,
					formatter:function(value,rowData,rowIndex){
						   if(value==1){
							    return"企业会员";
						   }
						   if(value==2){
							    return"店铺";
						   }
						   if(value==3){
							   return "普通会员";
						   }
					 }	
				},
				{field:"email",title:"电子邮箱",width:80},
				/* {field:"registerDate",title:"注册日期",width:80}, */
				{field:"registerIp",title:"注册IP",width:80},
				{field:"lockedState",title:"状态",width:50,
					formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="0"){ return "<font color='#EE0000'>未冻结</font>";} 
                        if(value=="1"){ return "<font color='#0033FF'>已冻结</font>";} 
                     }
				}
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号   
			singleSelect:true,//true只可以选中一行
			toolbar:[{//工具条
				text:"等级维护",
				iconCls:"icon-search",
				handler:function(){
					var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
					if(rows.length==0){//没有选择修改项
						msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");  
					}if(rows.length>1){//超过了一个选择项
						msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");  
					}else if(rows.length==1){
						location.href="${pageContext.request.contextPath}/back/sellersRecord/gotoSellersRecordId.action?customerId="+rows[0].customerId;
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
    	
    	//详情
		function showDetailInfo(id){
			createWindow(700,'450',"&nbsp;&nbsp;详细个性信息","icon-tip",false,"detailWin");
			$("#congeal").css("display","none");
			$("#detailWin").css("display","");
			$("#lineOfCreditWin").css("display","none");
			$.post("${pageContext.request.contextPath}/back/customer/getCustomerObject.action",{"customerId":id},function(data){
				if(data != null){
					var s=data.shopCustomerInfo;
					var c=data.customer;
					$("#d_loginName").html(data.customer.loginName);
					$("#d_photo").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.customer.photoUrl+"' width='120px' height='120px' />");
					<s:iterator value="#application.keybook['sex']" var="kb">
				           if(s.sex==<s:property value="#kb.value"/>){
				                   $("#d_sex").html("<s:property value='#kb.name'/>");
				           }
					</s:iterator>
					$("#d_birthday").html(s.birthday);
					$("#d_trueName").html(s.trueName);
					$("#d_phone").html(data.customer.phone);
					$("#d_userEmail").html(data.customer.email);
					$("#d_note").val(s.notes);
					if(c.lineOfCredit!=null&&c.lineOfCredit!=""){
						$("#d_lineOfCredit").html(formatCurrency(c.lineOfCredit));
					}else{
						$("#d_lineOfCredit").html("无");
					}
				    if(data.customer.lockedState==0){
					    $("#d_lockedState").html("未冻结");
				    }else{
					    $("#d_lockedState").html("已冻结");
				    }
				}
			},'json');
    	}
        });  
 	 	/**
 	 	 * 将数值四舍五入(保留2位小数)后格式化成金额形式
 	 	 *
 	 	 * @param num 数值(Number或者String)
 	 	 * @return 金额格式的字符串,如'1,234,567.45'
 	 	 * @type String
 	 	 */
 	 	function formatCurrency(num) {
 	 	    num = num.toString().replace(/\$|\,/g,'');
 	 	    if(isNaN(num))
 	 	    num = "0";
 	 	    sign = (num == (num = Math.abs(num)));
 	 	    num = Math.floor(num*100+0.50000000001);
 	 	    cents = num%100;
 	 	    num = Math.floor(num/100).toString();
 	 	    if(cents<10)
 	 	    cents = "0" + cents;
 	 	    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
 	 	    num = num.substring(0,num.length-(4*i+3))+','+
 	 	    num.substring(num.length-(4*i+3));
 	 	    return (((sign)?'':'-') + num + '.' + cents);
 	 	}
    </script>
  </head>
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		</div>
  </body>
</html>
