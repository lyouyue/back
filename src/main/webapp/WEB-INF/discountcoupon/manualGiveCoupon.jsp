<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
    <script type="text/javascript">
     $(function(){
            $("#saveCoupon").click(function(){
                var customerRows = $("#mgc").datagrid("getSelections");//找到会员列表中选中的行
                var couponRows = $("#tt").datagrid("getSelected");//找到优惠券列表中选中的行
                var couponId=couponRows.discountCouponID;
                if(customerRows.length<=0){
                    msgShow("系统提示", "<p class='tipInfo'>请选择赠送的会员</p>", "warning");
                }else{
                    if(customerRows) {
                        var customerCouponIds = "";
                        for (i = 0; i < customerRows.length; i++) {
                            if(i==customerRows.length-1)customerCouponIds+=customerRows[i].customerId;
                            else customerCouponIds+=customerRows[i].customerId+",";
                        }
                        $("#customerCouponIds").val(customerCouponIds);//数据放入表单
                        $("#couponID").val(couponId);
                        $.ajax({
                            url:"${pageContext.request.contextPath}/back/discountcoupon/manualGiveCoupon.action",
                            type:"post",
                            dataType:"json",
                            data:{ids:customerCouponIds,discountCouponId:couponId},
                            success:function(data){
                                if(data.isSuccess=="true"){
                                    msgShow("系统提示", "<p class='tipInfo'>赠送成功！</p>", "warning");
                                }
                                closeWin();
                                $("#tt").datagrid("reload"); //保存后重新加载列表
                            }
                        })
                    }
                }
            })
        })
        //冻结状态操作
        function submitForm3(){
            var rows = $("#mgc").datagrid("getSelections");
            var customerIds="";
            for(var i=0;i<rows.length;i++){
                customerIds+=rows[i].customerId+",";
            }
            customerIds=customerIds.substring(0, customerIds.lastIndexOf(","));
            var lsCheckValue=$('input[name="clockedState"]:checked').val();
            $.post("${pageContext.request.contextPath}/back/customer/changeLockedState.action",{params:lsCheckValue,customerIds:customerIds},function(data){
                if(data.isSuccess==true){
                    closeWin();
                    $("#mgc").datagrid("clearSelections");
                    $("#mgc").datagrid("reload");
                }
            },'json');
        }
        function queryCustomer(){
        	 queryParams = {
                     selectFlag: true,
                     pageSize: pageSize,
                     currentPage: currentPage,
                     loginName: $("#qloginName").val(),
                     registerDate: $("#qregisterDate").val(),
                     lockedState: $("#qlockedState").val(),
                     registerDate2: $("#qregisterDate2").val(),
                     email: $("#qemail").val(),
                     phone: $("#qphone").val(),
                     wxUserOpenId: $("#qwxUserOpenId").val(),
                 };
                 $("#mgc").datagrid("load", queryParams);
                 pageSplit(pageSize, queryParams);//调用分页函数
 /*            var customerGroupId=$("#customerGroupId").val();
            if(customerGroupId=="choose") {
                queryParams = {
                    selectFlag: true,
                    pageSize: pageSize,
                    currentPage: currentPage,
                    loginName: $("#qloginName").val(),
                    registerDate: $("#qregisterDate").val(),
                    lockedState: $("#qlockedState").val(),
                    registerDate2: $("#qregisterDate2").val(),
                    email: $("#qemail").val(),
                    phone: $("#qphone").val(),
                    wxUserOpenId: $("#qwxUserOpenId").val(),
                };
                $("#mgc").datagrid("load", queryParams);
                pageSplit(pageSize, queryParams);//调用分页函数
            }else{
                $("#mgc").datagrid({//数据表格
                    title:"会员列表信息",
                    iconCls:"icon-save",
                    width:"auto",
                    height:"auto",
                    fitColumns: true,//宽度自适应
                    align:"center",
                    loadMsg:"正在处理，请等待......",
                    striped: true,//true是否把一行条文化
                    queryParams :{
                        selectFlag: true,
                        pageSize: pageSize,
                        currentPage: currentPage,
                        loginName: $("#qloginName").val(),
                        registerDate: $("#qregisterDate").val(),
                        lockedState: $("#qlockedState").val(),
                        registerDate2: $("#qregisterDate2").val(),
                        email: $("#qemail").val(),
                        phone: $("#qphone").val(),
                        wxUserOpenId: $("#qwxUserOpenId").val(),
                        customerGroupId: $("#customerGroupId").val()
                    },
                    url:"${pageContext.request.contextPath}/back/customer/customerGroup.action",
                    idField:"customerId",//唯一性标示字段
                    frozenColumns:[[//冻结字段
                        {field:"ck",checkbox:true}
                    ]],
                    columns:[[//未冻结字段
                        {field:"customerId",title:"会员ID",width:40},
                        {field:"loginName",title:"会员名称",width:80, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                            return "<a style='display:block;cursor: pointer;' id='"+rowData.customerId+"' onclick='showDetailInfo(this.id);'>"+rowData.loginName+"</a>";
                        }
                        },
                        {field:"sex",title:"性别",width:30,
                            formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                                <s:iterator value="#application.keybook['sex']" var="kb">
                                if(value==<s:property value="#kb.value"/>){
                                    return "<s:property value='#kb.name'/>";
                                }
                                </s:iterator>
                                return "保密";
                            }
                        },
                        {field:"email",title:"电子邮箱",width:80},
                        {field:"phone",title:"手机号",width:60},
                        {field:"registerIp",title:"注册IP",width:60},
                        {field:"lockedState",title:"状态",width:50,
                            formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                                if(value=="0"){ return "<font color='#EE0000'>未冻结</font>";}
                                if(value=="1"){ return "<font color='#0033FF'>已冻结</font>";}
                            }
                        },
                        {field:"balance",title:"账户余额",width:50},
                        {field:"wxUserOpenId",title:"是否关联微信账号",width:50,
                            formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                                if(value=="0"){ return "<font color='#EE0000'>否</font>";}
                                //if(value=="1"){ return "<font color='#0033FF'>是</font>";}
                                if(value=="1"){ return "<a style='display:block;cursor: pointer;color:#0033FF' id='"+rowData.customerId+"' onclick='showWxDetailInfo(this.id);'>是</a>";}
                            }
                        }
                    ]],
                    pagination:true,//显示分页栏
                    rownumbers:true,//显示行号
                    singleSelect:true,//true只可以选中一行
                });
//                $("#mgc").datagrid("load", queryParams);
                pageSplit(pageSize, queryParams);//调用分页函数
            } */
        }
        function reset(){
            $("#qloginName").val("");
            $("#qemail").val("");
            $("#qphone").val("");
            $("#qregisterDate").val("");
            $("#qregisterDate2").val("");
            $("#qlockedState").val("");
            $("#qwxUserOpenId").val("");
        }
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
<div id="manualGive" style="width:1055px;height:auto;margin: 0 auto;">
<form id="formGiveCoupon" method="post" >
    <input id="customerCouponIds" type="hidden"  name="customerCouponIds" />
    <input id="couponID" type="hidden"  name="couponID" />
<div class="main">
	<table class="searchTab">
	    <tr>
	        <td class="search_toright_td" style="width: 65px;">会员名称：</td>
	        <td class="search_toleft_td" style="width:115px;"><input type="text" id="qloginName" name="loginName" class="searchTabinput" style="width:100px;"/></td>
	        <td class="search_toright_td" style="width:55px;">手机号：</td>
	        <td class="search_toleft_td" style="width:115px;"><input type="text" id="qphone" name="phone" class="searchTabinput" style="width:100px;"/></td>
	        <td class="search_toright_td" style="width: 45px;">邮箱：</td>
	        <td class="search_toleft_td" style="width:115px;"><input type="text" id="qemail" name="email" class="searchTabinput" style="width:100px;"/></td>
	        <td class="search_toright_td" style="width:40px;">状态： </td>
	        <td class="search_toleft_td" style="width:100px;">
	            <select id="qlockedState" class="querySelect">
	                <option value="-1">--请选择--</option>
	                <option value="0">未冻结</option>
	                <option value="1">已冻结</option>
	            </select>
	        </td>
	        <td class="search_toright_td"  style="width:60px;">关联微信： </td>
	        <td class="search_toleft_td"  style="width:100px;">
	            <select id="qwxUserOpenId" class="querySelect">
	                <option value="-1">--请选择--</option>
	                <option value="0">否</option>
	                <option value="1">是</option>
	            </select>
	        </td>
	     <%--     <td class="toright_td" style="width:65px;">会员分组： </td>
	       <td class="toleft_td" style="width:90px;">
	            <select id="customerGroupId" class="querySelect">
	                <option value="choose">--请选择--</option>
	                <s:iterator value="#request.customerFansGroup" var="cfg">
	                    <option value="<s:property value='#cfg.id'/>"><s:property value='#cfg.name'/> </option>
	                </s:iterator>
	            </select>
	        </td> --%>
	        <td class="search_toleft_td">
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:queryCustomer()">查询</a>
				<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset()">重置</a>
	        </td>
	    </tr>
	</table>
	<table id="mgc"></table>
    <div class="editButton"  data-options="region:'south',border:false" >
        <a id="saveCoupon" class="easyui-linkbutton" icon="icon-save"  href="javascript:;">赠送</a>
        <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
</div>
</form>
</div>