<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>会员信息</title>
    <meta http-equiv="Cache-Control" content="no-cache"/>
    <meta http-equiv="Expires" content="-1"/>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#tt").datagrid({//数据表格
                /* title:"会员列表信息",
                 iconCls:"icon-save", */
                width: "auto",
                height: "auto",
                fitColumns: true,//宽度自适应
                align: "center",
                loadMsg: "正在处理，请等待......",
                //nowrap: false,//true是否将数据显示在一行
                striped: true,//true是否把一行条文化
                url: "${pageContext.request.contextPath}/back/customer/listCustomer.action",
                idField: "customerId",//唯一性标示字段
                frozenColumns: [[//冻结字段
                    {field: "ck", checkbox: true}
                ]],
                columns: [[//未冻结字段
                    /* {field:"customerId",title:"会员ID",width:40}, */
                    {
                        field: "loginName", title: "会员名称", width: 80, formatter: function (value, rowData, rowIndex) {  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        return "<a style='display:block;cursor: pointer;' id='" + rowData.customerId + "' onclick='showDetailInfo(this.id);'>" + rowData.loginName + "</a>";
                    }
                    },
                    {
                        field: "userType", title: "会员类型", width: 50, formatter: function (value, rowData, rowIndex) {
                        if (value == 1) {
                            return "买家";
                        } else if (value == 2) {
                            return "店铺";
                        } else {
                            return "其他";
                        }
                    }
                    },
                    {
                        field: "sex", title: "性别", width: 40,
                        formatter: function (value, rowData, rowIndex) {  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                            <s:iterator value="#application.keybook['sex']" var="kb">
                            if (value ==<s:property value="#kb.value"/>) {
                                return "<s:property value='#kb.name'/>";
                            }
                            </s:iterator>
                            return "保密";
                        }
                    },
                    /* {field:"trueName",title:"真实姓名",width:80}, */
                    {field: "phone", title: "手机号", width: 60},
                    {field: "email", title: "电子邮箱", width: 80},
                    {
                        field: "lockedState", title: "冻结状态", width: 50,
                        formatter: function (value, rowData, rowIndex) {  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                            if (value == "0") {
                                return "<font class='color_001'>未冻结</font>";
                            }
                            if (value == "1") {
                                return "<font class='color_002'>已冻结</font>";
                            }
                        }
                    },
                    {
                        field: "wxUserOpenId", title: "是否关联微信", width: 50,
                        formatter: function (value, rowData, rowIndex) {  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                            if (value == "0") {
                                return "<font class='color_002'>未关联</font>";
                            }
                            //if(value=="1"){ return "<font color='#0033FF'>是</font>";}
                            if (value == "1") {
                                return "<a style='display:block;cursor: pointer;color:#009933' id='" + rowData.customerId + "' onclick='showWxDetailInfo(this.id);'><font class='color_001'> 已关联</font></a>";
                            }
                        }
                    },
                    {field: "registerIp", title: "注册IP", width: 60},
                    {field: "registerDate", title: "注册时间", width: 80}
                ]],
                pagination: true,//显示分页栏
                rownumbers: true,//显示行号
                singleSelect: true,//true只可以选中一行
                toolbar: [//工具条
                    <%
                    if("freeze".equals((String)functionsMap.get(purviewId+"_freeze"))){
                    %>
                    {
                        text: "冻结操作",
                        iconCls: "icon-edit",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");
                            if (rows.length == 0) {
                                msgShow("系统提示", "<p class='tipInfo'>请选择要冻结的会员！</p>", "warning");
                            } else {
                                createWindow(800, 'auto', "&nbsp;&nbsp;会员冻结操作", "icon-tip", false, "congeal");
                                $("#photoForm").css("display", "none");
                                $("#form1").css("display", "none");
                                $("#form2").css("display", "none");
                                $("#detailWin").css("display", "none");
                                $("#lineOfCreditWin").css("display", "none");
                                $("#detailFansWin").css("display", "none");
                                $("#congeal").css("display", "");
                                $("#invoiceInfolWin").css("display", "none");
                                $("#rechargeWin").css("display", "none");
                                var ls = rows[0].lockedState;
                                $("#clockedState_" + ls).attr("checked", true);
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("recharge".equals((String)functionsMap.get(purviewId+"_recharge"))){
                    %>
                    {
                        text: "会员余额充值",
                        iconCls: "icon-edit",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                if (rows[0].type == 2) {//供应商
                                    msgShow("系统提示", "<p class='tipInfo'>店铺会员不能充值！</p>", "warning");
                                } else if (rows[0].type == 1 || rows[0].type == 3) {//普通会员
                                    $("#rechargeAmount").val("");
                                    createWindow(800, 'auto', "&nbsp;&nbsp;会员余额充值", "icon-edit", false, "rechargeWin");
                                    $("#detailWin").css("display", "none");
                                    $("#addOrEditWin").css("display", "none");
                                    $("#congeal").css("display", "none");
                                    $("#lineOfCreditWin").css("display", "none");
                                    $("#detailFansWin").css("display", "none");
                                    $("#invoiceInfolWin").css("display", "none");
                                    $("#rechargeWin").css("display", "");
                                    var customerId = rows[0].customerId;
                                    $("#pcustomerId").val(customerId);
                                }
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("rechargeSheet".equals((String)functionsMap.get(purviewId+"_rechargeSheet"))){
                    %>
                    {
                        text: "充值明细",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                location.href = "${pageContext.request.contextPath}/back/customer/gotoRechargePage.action?customerId=" + rows[0].customerId;
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("coinSheet".equals((String)functionsMap.get(purviewId+"_coinSheet"))){
                    %>
                    {
                        text: "金币明细",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                location.href = "${pageContext.request.contextPath}/back/customer/gotoCustomerMallCoinPage.action?customerId=" + rows[0].customerId;
                            }
                        }
                    }, "-",
                    <%
                    }if("upgradeShop".equals((String)functionsMap.get(purviewId+"_upgradeShop"))){
                    %>
                    {
                        text:"升级为店铺",
                        iconCls:"icon-reload",
                        handler:function(){

                            var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                $.messager.confirm("系统提示", "<p class='tipInfo'>确定升级为店铺吗?</p>",function(data){
                                    if(data){//判断是否删除
                                        $.ajax({
                                            type: "POST",dataType: "JSON",
                                            url: "${pageContext.request.contextPath}/back/customer/upgradeShop.action",
                                            data: {customerId: rows[0].customerId},
                                            success: function(data){
                                                msgShow("系统提示", "<p class='tipInfo'>"+data.info+"</p>", "warning");
                                                if(data.isSuccess) {
                                                    $("#tt").datagrid("clearSelections");//删除后取消所有选项
                                                    $("#tt").datagrid("reload");
                                                }
                                            }
                                        });
                                    }
                                });
                            }
                        }
                    }
                    ,"-",
                    <%
                      }
                    if("queryLowe".equals((String)functionsMap.get(purviewId+"_queryLowe"))){
                    %>
                    {
                        text: "查询推广员",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                location.href = "${pageContext.request.contextPath}/back/disCustomer/gotoLowePage.action?customerId=" + rows[0].customerId;
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("productCollect".equals((String)functionsMap.get(purviewId+"_productCollect"))){
                    %>
                    {
                        text: "套餐收藏",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                location.href = "${pageContext.request.contextPath}/back/customerCollectProduct/findCustomerCollectProductListByCustomerId.action?customerId=" + rows[0].customerId;
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("shopCollect".equals((String)functionsMap.get(purviewId+"_shopCollect"))){
                    %>
                    {
                        text: "店铺收藏",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                location.href = "${pageContext.request.contextPath}/back/customerCollectProduct/findCustomerCollectShopInfoListByCustomerId.action?customerId=" + rows[0].customerId;
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("address".equals((String)functionsMap.get(purviewId+"_address"))){
                    %>
                    {
                        text: "收货地址",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                location.href = "${pageContext.request.contextPath}/back/customerAcceptAddress/findAcceptAddressListByCustomerId.action?customerId=" + rows[0].customerId;
                            }
                        }
                    }, "-",
                    <%
                    }
                    if("invoice".equals((String)functionsMap.get(purviewId+"_invoice"))){
                    %>
                    {
                        text: "发票信息",
                        iconCls: "icon-search",
                        handler: function () {
                            var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
                            if (rows.length == 0) {//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择会员！</p>", "warning");
                            }
                            if (rows.length > 1) {//超过了一个选择项
                                msgShow("系统提示", "<p class='tipInfo'>只能够选择一项！</p>", "warning");
                            } else if (rows.length == 1) {
                                $("#detailWin").css("display", "none");
                                $("#addOrEditWin").css("display", "none");
                                $("#congeal").css("display", "none");
                                $("#lineOfCreditWin").css("display", "none");
                                $("#detailFansWin").css("display", "none");
                                $("#rechargeWin").css("display", "none");
                                $("#invoiceInfolWin").css("display", "");
                                createWindow(800, 'auto', "&nbsp;&nbsp;会员发票信息", "icon-search", false, "invoiceInfolWin");
                                $.ajax({
                                    type: "POST", dataType: "JSON",
                                    url: "${pageContext.request.contextPath}/back/customer/findInvoiceInfo.action",
                                    data: {ids: rows[0].customerId},
                                    success: function (data) {
                                        if (data.customerInvoice != null) {
                                            $("#d_invoiceTitle").html(data.customerInvoice.invoiceTitle);//发票抬头
                                            $("#d_invoiceInfo").html(data.customerInvoice.invoiceInfo);//发票内容
                                            $("#d_companyName").html(data.customerInvoice.companyName);//单位名称
                                            $("#d_taxpayerIdentificationCode").html(data.customerInvoice.taxpayerIdentificationCode);//纳税人识别编号
                                            $("#d_registeredAddress").html(data.customerInvoice.registeredAddress);//注册地址
                                            $("#d_registerePhone").html(data.customerInvoice.registerePhone);//注册电话
                                            $("#d_depositBank").html(data.customerInvoice.depositBank);//开户行
                                            $("#d_bankAccount").html(data.customerInvoice.bankAccount);//账号
                                        }
                                    }
                                });
                            }
                        }
                    }, "-",
                    <%
                    }
                    %>
                    /*		,"-",{
                     text:"分配客服",
                     iconCls:"icon-search",
                     handler:function(){
                     var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
                     if(rows.length==0){//没有选择修改项
                     $.messager.alert("提示","请选择会员");
                     }if(rows.length>1){//超过了一个选择项
                     $.messager.alert("提示","只能够选择一项");
                     }else if(rows.length==1){
                     //提交分配客服参数
                     $("#shopName").val(rows[0].loginName);
                     $("#ids").val(rows[0].customerId);
                     $("#formShopPar").submit();
                     }
                     }
                     } */
                    {
                        text: "刷新",
                        iconCls: "icon-reload",
                        handler: function () {
                            $("#tt").datagrid("clearSelections");//删除后取消所有选项
                            $("#tt").datagrid("reload");
                        }
                    }
                ]
            });
            pageSplit(pageSize);//调用分页函数
            //表单验证1
            $("#form1").validate({
                meta: "validate",
                submitHandler: function (form) {
                    $(document).ready(
                            function () {
                                var options = {
                                    url: "${pageContext.request.contextPath}/back/customer/saveOrUpdateCustomer.action",
                                    queryParams: {pageSize: pageSize},
                                    type: "post",
                                    dataType: "json",
                                    success: function (data) {
                                        closeWin();
                                        $("#tt").datagrid("clearSelections");//删除后取消所有选项
                                        $("#tt").datagrid("reload"); //保存后重新加载列表
                                    }
                                };
                                $("#form1").ajaxSubmit(options);
                                $("input.button_save").attr("disabled", "disabled");
                            });
                }
            });
            //表单验证2
            $("#form2").validate({
                meta: "validate",
                submitHandler: function (form) {
                    $(document).ready(
                            function () {
                                var options = {
                                    url: "${pageContext.request.contextPath}/back/customer/saveOrUpdateShopCustomer.action",
                                    type: "post",
                                    dataType: "json",
                                    success: function (data) {
                                        closeWin();
                                        $("#tt").datagrid("clearSelections");//删除后取消所有选项
                                        $("#tt").datagrid("reload"); //删除后重新加载列表
                                    }
                                };
                                $("#form2").ajaxSubmit(options);
                                $("input.button_save").attr("disabled", "disabled");
                            });
                }
            });


        });
        //提交1
        function submitForm() {
            $("#form1").submit();
        }
        //提交2
        function submitForm2() {
            $("#form2").submit();
        }

        //冻结状态操作
        function submitForm3() {
            var rows = $("#tt").datagrid("getSelections");
            var customerIds = "";
            for (var i = 0; i < rows.length; i++) {
                customerIds += rows[i].customerId + ",";
            }
            customerIds = customerIds.substring(0, customerIds.lastIndexOf(","));
            var lsCheckValue = $('input[name="clockedState"]:checked').val();
            $.post("${pageContext.request.contextPath}/back/customer/changeLockedState.action", {params: lsCheckValue, customerIds: customerIds}, function (data) {
                if (data.isSuccess == true) {
                    closeWin();
                    $("#tt").datagrid("clearSelections");
                    $("#tt").datagrid("reload");
                }
            }, 'json');
        }


        //详情
        function showDetailInfo(id) {
            createWindow(900, 360, "&nbsp;&nbsp;会员详情", "icon-tip", false, "detailWin", 20);
            $("#congeal").css("display", "none");
            $("#lineOfCreditWin").css("display", "none");
            $("#detailFansWin").css("display", "none");
            $("#invoiceInfolWin").css("display", "none");
            $("#rechargeWin").css("display", "none");
            $("#detailWin").css("display", "");
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/back/customer/getCustomerObject.action",
                data: {customerId: id},
                dataType: "JSON",
                success: function (data) {
                    var s = data.shopCustomerInfo;
                    var c = data.customer;
                    if (s.wxUserOpenId == 0 || s.wxUserOpenId == null) {
                        $("#dd_wxUserOpenId").html("<font class='color_002'>未关联</font>");
                    } else {
                        $("#dd_wxUserOpenId").html("<font class='color_001'>已关联</font>");
                    }
                    $("#dd_registerIp").html(c.registerIp);
                    $("#d_loginName").html(c.loginName);
                    var userType = data.customer.type;
                    var userTypeText = "";
                    if (userType == 1) {
                        userTypeText = "买家";
                    } else if (userType == 2) {
                        userTypeText = "卖家";
                    }
                    $("#d_type").html(userTypeText);
                    $("#d_customerId").html(c.customerId);
                    $("#dd_registerDate").html(c.registerDate);
                    $("#d_balance").html(data.balance + "元");
                    $("#d_photo").html("<img src='" + "<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>" + c.photoUrl + "' width='120px' height='120px' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' />");
                    <s:iterator value="#application.keybook['sex']" var="kb">
                    if (s.sex ==<s:property value="#kb.value"/>) {
                        $("#d_sex").html("<s:property value='#kb.name'/>");
                    }
                    </s:iterator>
                    $("#dd_birthday").html(data.format);
//						$("#d_trueName").html(s.trueName);
                    $("#d_phone").html(data.customer.phone);
                    $("#d_userEmail").html(data.customer.email);
                    $("#d_notes").html(s.notes);
                    if (data.customer.lockedState == 0) {
                        $("#d_lockedState").html("<font class='color_001'>未冻结</font>");
                    } else {
                        $("#d_lockedState").html("<font class='color_002'>已冻结</font>");
                    }
                }
            });
        }

        //微信粉丝详情
        function showWxDetailInfo(id) {
            createWindow(900, 400, "&nbsp;&nbsp;粉丝详情", "icon-tip", false, "detailFansWin");
            $("#congeal").css("display", "none");
            $("#lineOfCreditWin").css("display", "none");
            $("#detailFansWin").css("display", "none");
            $("#invoiceInfolWin").css("display", "none");
            $("#rechargeWin").css("display", "none");
            $("#detailWin").css("display", "none");
            $("#detailFansWin").css("display", "");
            $.ajax({
                type: "POST",
                url: "${pageContext.request.contextPath}/back/customer/getFansUserInfoObject.action",
                data: {customerId: id},
                dataType: "JSON",
                success: function (data) {
                    $("#d_customerId").html(data.customerId);
                    $("#d_openid").html(data.userOpenId);
                    $("#d_oginName").html(data.oginName);
                    $("#d_nickname").html(data.nickName);
                    <s:iterator value="#request.fansGroupListaa" var="kb">
                    if ("<s:property value='#kb.id'/>" == data.fansGroupId) {
                        $("#d_fansGroupId").html(<s:property value='#kb.name'/>);
                    }
                    </s:iterator>
                    if (data.subscribe == "0") {
                        $("#d_subscribe").html("否");
                    } else {
                        $("#d_subscribe").html("是");
                    }
                    if (data.bindingFlag == "0") {
                        $("#d_bindingFlag").html("否");
                    } else {
                        $("#d_bindingFlag").html("是");
                    }
                    <s:iterator value="#application.keybook['sex']" var="kb">
                    if (data.sex ==<s:property value="#kb.value"/>) {
                        $("#d_sex").html("<s:property value='#kb.name'/>");
                    }
                    </s:iterator>
                    $("#d_country").html(data.userCountry);
                    $("#d_province").html(data.userProvince);
                    $("#d_city").html(data.userCity);
                    $("#d_language").html(data.userLanguage);
                    $("#d_userSignature").html(data.userSignature);
                    $("#d_subscribeTime").html(formatTimeConvert(data.subscribe_time));
                    $("#d_unionid").html(data.unionid);
                    if (data.plateformRemark == "" || data.plateformRemark == null) {
                        $("#d_plateformRemark").html("/");
                    } else {
                        $("#d_plateformRemark").html(data.plateformRemark);
                    }
                    if (data.latitude != "") {
                        $("#d_latitude").html(data.latitude);
                    } else {
                        $("#d_latitude").html("/");
                    }
                    if (data.longitude != "") {
                        $("#d_longitude").html(data.longitude);
                    } else {
                        $("#d_longitude").html("/");
                    }
                    if (data.locationPrecision != "") {
                        $("#d_precision").html(data.locationPrecision);
                    } else {
                        $("#d_precision").html("/");
                    }
                    if (data.remark != "") {
                        $("#d_remark").html(data.remark);
                    } else {
                        $("#d_remark").html("/");
                    }
                }
            });
        }
        //上传图片
        function uploadPhoto() {
            $(document).ready(
                    function () {
                        var options = {
                            url: "${pageContext.request.contextPath}/back/customer/uploadImage.action",
                            type: "post",
                            dataType: "json",
                            success: function (data) {
                                if (data.photoUrl == "false1") {
                                    $("#mymessage").html(" <font style='color:red'>请选择上传图片</font>");
                                } else if (data.photoUrl == "false2") {
                                    $("#mymessage").html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
                                } else {
                                    $("#photoUrl").val(data.photoUrl);
                                    $("#photo").html("");
                                    $("#photo").html("<img src='" + data.uploadFileVisitRoot + data.photoUrl + "' width='120px' height='120px' />");
                                }
                            }
                        };
                        $("#photoForm").ajaxSubmit(options);
                    });
        }
        function query() {
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
                userType: $("#userType").val(),
            };
            $("#tt").datagrid("load", queryParams);
            pageSplit(pageSize, queryParams);//调用分页函数
        }
        function reset() {
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
            num = num.toString().replace(/\$|\,/g, '');
            if (isNaN(num))
                num = "0";
            sign = (num == (num = Math.abs(num)));
            num = Math.floor(num * 100 + 0.50000000001);
            cents = num % 100;
            num = Math.floor(num / 100).toString();
            if (cents < 10)
                cents = "0" + cents;
            for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
                num = num.substring(0, num.length - (4 * i + 3)) + ',' +
                        num.substring(num.length - (4 * i + 3));
            return (((sign) ? '' : '-') + num + '.' + cents);
        }
    </script>
</head>
<body>
<jsp:include page="../../util/item.jsp"/>

<form id="formShopPar" action="${pageContext.request.contextPath}/back/shopCustomerService/gotoShopCustomerServicePage.action" method="post">
    <input id="shopName" type="hidden" name="shopName"/>
    <input id="ids" type="hidden" name="ids"/>
</form>
<div class="main">
    <table class="searchTab">
        <tr>
            <td class="search_toright_td" style="width: 80px;">会员名称：</td>
            <td class="search_toleft_td" style="width: 125px;"><input type="text" id="qloginName" name="loginName" style="width: 110px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
            <td class="search_toright_td" style="width: 50px;">手机号：</td>
            <td class="search_toleft_td" style="width:125px;"><input type="text" id="qphone" name="phone" style="width: 110px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
            <td class="search_toright_td" style="width:40px;">邮箱：</td>
            <td class="search_toleft_td" style="width:125px;"><input type="text" id="qemail" name="email" style="width: 110px;" class="searchTabinput"/>&nbsp;&nbsp;</td>
            <td class="search_toright_td" style="width:40px;">状态 ：</td>
            <td class="search_toleft_td" style="width:100px;">
                <select id="qlockedState" style="width: 90px;" class="querySelect">
                    <option value="-1">--请选择--</option>
                    <option value="0">未冻结</option>
                    <option value="1">已冻结</option>
                </select>&nbsp;&nbsp;
            </td>
            <td class="search_toright_td" style="width:90px;">是否关联微信：</td>
            <td class="search_toleft_td" style="width:100px;">
                <select id="qwxUserOpenId" style="width: 90px;" class="querySelect">
                    <option value="-1">--请选择--</option>
                    <option value="0">未关联</option>
                    <option value="1">已关联</option>
                </select>&nbsp;&nbsp;
            </td>
            <td class="search_toright_td" style="width:60px;">会员类型：</td>
            <td class="search_toleft_td" style="width:100px;">
                <select id="userType" style="width: 90px;" class="querySelect">
                    <option value="-1">--请选择--</option>
                    <option value="1">买家</option>
                    <option value="2">店铺</option>
                </select>&nbsp;&nbsp;
            </td>
            <td class="search_toleft_td">
                <a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
                <a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
            </td>
        </tr>
    </table>
    <table id="tt"></table>
    <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
        <!-- 会员页面 -->
        <%--		  <jsp:include page="addOrEditor.jsp"/> --%>
        <!-- 个性页面 -->
        <%--		  <jsp:include page="SPaddOrEdit.jsp"/> --%>
        <form id="form1"></form>
        <!-- 详情页面 -->
        <jsp:include page="detail.jsp"/>
        <!-- 冻结 -->
        <jsp:include page="congeal.jsp"/>
        <!-- 授信额度管理 -->
        <jsp:include page="lineOfCredit.jsp"/>
        <!-- 粉丝信息 -->
        <jsp:include page="detailWxFansUserInfo.jsp"/>
        <!-- 发票信息 -->
        <jsp:include page="invoiceInfo.jsp"/>
        <!-- 充值信息 -->
        <jsp:include page="recharge.jsp"/>
    </div>
</div>
</body>
</html>
