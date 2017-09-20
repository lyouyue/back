<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>抢购商品信息</title>
    <jsp:include page="../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">

        Date.prototype.format = function(format){
            var o = {
                "M+" : this.getMonth()+1, //month
                "d+" : this.getDate(), //day
                "h+" : this.getHours(), //hour
                "m+" : this.getMinutes(), //minute
                "s+" : this.getSeconds(), //second
                "q+" : Math.floor((this.getMonth()+3)/3), //quarter
                "S" : this.getMilliseconds() //millisecond
            }

            if(/(y+)/.test(format)) {
                format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
            }

            for(var k in o) {
                if(new RegExp("("+ k +")").test(format)) {
                    format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
                }
            }
            return format;
        };

        $(function(){
            $("#tt").datagrid({//数据表格
                width:"auto",
                height:"auto",
                fitColumns: true,//宽度自适应
                align:"center",
                loadMsg:"正在处理，请等待......",
                //nowrap: false,//true是否将数据显示在一行
                striped: true,//true是否把一行条文化
                url:"${pageContext.request.contextPath}/back/panicBuying/listPanicBuying.action",
                queryParams:{pageSize:pageSize},
                idField:"panicId",//唯一性标示字段
                frozenColumns:[[//冻结字段
                    {field:"ck",checkbox:true}
                ]],
                columns:[[//未冻结字段
                    {field:"panicTitle",title:"抢购标题",width:"150"},
                    {field:"panicPrice",title:"抢购价",width:"150"},
                    {field:"logoImg",title:"图片",width:150,
                        formatter:function(value,rowData,rowIndex){
                            return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.logoImg+"' width='60px' height='30px' />";
                        }
                    },
                    {field:"panicNum",title:"抢购个数",width:"150"},
                    {field:"buyNum",title:"已购个数",width:"150"},
                    {field:"startTime",title:"抢购开始时间",width:150,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        var d2 =new Date().format("yyyy-MM-dd");
                        if(Date.parse(value)-Date.parse(d2)<0){
                            return "<span style='color:red'>"+value+"</span>";
                        }else{
                            return value;
                        }
                    }
                    },
                    {field:"isPublish",title:"是否发布",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="0"){ return "未发布";}
                        if(value=="1"){ return "已发布";}
                    }
                    },
                    {field:"isOver",title:"是否结束",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="1"){ return "已结束";}
                        if(value=="0"){ return "未结束";}
                    }
                    },
                    {field:"isShow",title:"是否显示",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="1"){ return "显示";}
                        if(value=="0"){ return "不显示";}
                    }
                    }
                ]],
                pagination:true,//显示分页栏
                rownumbers:true,//显示行号
                singleSelect:true,//true只可以选中一行
                toolbar:[
				<%
				if("recommend".equals((String)functionsMap.get(purviewId+"_recommend"))){
				%>
                    {
                        text:"查看显示首页推荐栏",
                        iconCls:"icon-search",
                        handler:function(){
                            var rows = $("#tt").datagrid("getSelected");//找到所有选中的行
                            if(rows==null){//没有选择修改项
                                msgShow("系统提示", "<p class='tipInfo'>请选择想要显示的商品！</p>", "warning");
                            }else{
                                if(rows.isShow==0){
                                    var panicId=rows.panicId;
                                    $.ajax({
                                        type: "POST",
                                        dataType: "JSON",
                                        url: "${pageContext.request.contextPath}/back/panicBuying/updateShow.action",
                                        data: {panicId:panicId},
                                        success: function(data){
                                            if(data.isSuccess=="true"){
                                                msgShow("系统提示", "<p class='tipInfo'>推荐栏显示成功！</p>", "warning");
                                                queryParams={pageSize:pageSize,currentPage:currentPage};
                                                $("#tt").datagrid("reload");
                                                pageSplit(pageSize,queryParams);//调用分页函数
                                            }else if(data.isSuccess=="false"){
                                                msgShow("系统提示", "<p class='tipInfo'>推荐栏显示失败！</p>", "warning");
                                            }
                                        }
                                    });
                                }else{
                                    msgShow("系统提示", "<p class='tipInfo'>该商品正在推荐栏显示中！</p>", "warning");
                                }
                            }
                        }
                    },"-",
                    <%
					}
					if("panic".equals((String)functionsMap.get(purviewId+"_panic"))){
					%>
                    {
                        text:"查看商品抢购记录",
                        iconCls:"icon-search",
                        handler:function(){
                            $("#panicRecord").css("display","");
                            createWindow(1250,"auto","&nbsp;&nbsp;商品抢购记录","icon-tip",false,"panicRecord");
                            $("#ttc").datagrid({//数据表格
                                width:"auto",
                                height:"auto",
                                fitColumns: true,//宽度自适应
                                align:"center",
                                loadMsg:"正在处理，请等待......",
                                striped: true,//true是否把一行条文化
                                url:"${pageContext.request.contextPath}/back/panicBuying/listPanicBuyingRecord.action",
                                queryParams:{pageSize:pageSize},
                                idField:"panicId",//唯一性标示字段
                                frozenColumns:[[//冻结字段
                                    {field:"ck",checkbox:true}
                                ]],
                                columns:[[//未冻结字段
                                    {field:"panicId",title:"抢购ID",width:"60"},
                                    {field:"productId",title:"商品ID",width:"60"},
                                    {field:"shopInfoId",title:"店铺ID",width:"60"},
                                    {field:"panicTitle",title:"抢购标题",width:"200"},
                                    {field:"productName",title:"商品名称",width:"100"},
                                    {field:"panicPrice",title:"抢购价",width:"60"},
                                    {field:"logoImg",title:"商品图片",width:55,
                                        formatter:function(value,rowData,rowIndex){
                                            return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.logoImg+"' width='60px' height='30px' />";
                                        }
                                    },
                                    {field:"panicNum",title:"抢购个数",width:"60"},
                                    {field:"startTime",title:"抢购开始时间",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                                        var d2 =new Date().format("yyyy-MM-dd");
                                        if(Date.parse(value)-Date.parse(d2)<0){
                                            return "<span style='color:red'>"+value+"</span>";
                                        }else{
                                            return value;
                                        }
                                    }
                                    },
                                    {field:"createTime",title:"创建时间",width:120,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                                        var d2 =new Date().format("yyyy-MM-dd");
                                        if(Date.parse(value)-Date.parse(d2)<0){
                                            return "<span style='color:red'>"+value+"</span>";
                                        }else{
                                            return value;
                                        }
                                    }
                                    },
                                    {field:"publishUser",title:"操作人员",width:"100"},
                                ]],
                                    pagination:true,//显示分页栏
                                    rownumbers:true,//显示行号
                                    singleSelect:true,//true只可以选中一行
                            })
                            pageSplit(pageSize,queryParams);//调用分页函数
                        }
                    },"-",
                    <% 
					}
					%>
                    {text:"刷新",
    					iconCls:"icon-reload",
    					handler:function(){
    						$("#tt").datagrid("clearSelections");//删除后取消所有选项
    						$("#tt").datagrid("reload");
    					}
    				}
                ]
            });
            pageSplit(pageSize);//调用分页函数
        });

    </script>
    <style type="text/css">
        .linkbtn{margin-top: 5px;margin-right: 10px;}
        .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
        .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
        .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
    </style>
</head>
<body>
<jsp:include page="../util/item.jsp"/>
<!-- 查询框  -->
<div class="main">
    <table id="tt"></table>
    <div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
        <!--商品抢购记录-->
        <jsp:include page="panicBuyingRecordList.jsp"/>
    </div>
</div>
</body>
</html>
