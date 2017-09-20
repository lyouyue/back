<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>积分商城商品信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
        $(function(){
            $("#tt").datagrid({//数据表格
                width:"auto",
                height:"auto",
                fitColumns: true,//宽度自适应
                align:"center",
                loadMsg:"正在处理，请等待......",
                //nowrap: false,//true是否将数据显示在一行
                striped: true,//true是否把一行条文化
                url:"${pageContext.request.contextPath}/back/coinMallProductType/listProductInfoByTypeId.action?typeId=${typeId}",
                queryParams:{pageSize:pageSize},
                idField:"id",//唯一性标示字段
                /* frozenColumns:[[//冻结字段
                 {field:"ck",checkbox:true}
                 ]], */
                columns:[[//未冻结字段
                    {field:"logoImg",title:"商品图片",width:55,
                        formatter:function(value,rowData,rowIndex){
                            return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+rowData.logoImg+"' width='60px' height='30px' />";
                        }
                    },
                    {field:"productName",title:"商品名称",width:120},
                    {field:"title",title:"标题",width:120},
                    {field:"allowExchangeNum",title:"当天允许兑换件数",width:87},
                    {field:"customerLevel",title:"兑换所需会员级别",width:87},
                    {field:"expenseCoin",title:"兑换所需积分",width:87},
                    {field:"originalPrice",title:"原销售价",width:55},
                    {field:"createTime",title:"创建时间",width:87},
                    {field:"isPublish",title:"是否发布",width:55,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="0"){ return "<font color='#0033FF'>未发布</font>";}
                        if(value=="1"){ return "<font color='#EE0000'>已发布</font>";}
                    }
                    },
                    {field:"isShow",title:"是否显示",width:100,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
                        if(value=="1"){ return "<font color='#0033FF'>显示</font>";}
                        if(value=="0"){ return "<font color='#EE0000'>不显示</font>";}
                    }
                    }
                ]],
                pagination:true,//显示分页栏
                rownumbers:true,//显示行号
                singleSelect:true,//true只可以选中一行
                toolbar:[{
                    text:"返回积分商城分类",
                    iconCls:"icon-back",
                    handler:function(){
                        location.href="${pageContext.request.contextPath}/back/coinMallProductType/gotoCoinMallProductType.action";
                    }
                },"-",{text:"刷新",
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
<jsp:include page="../../util/item.jsp"/>
<div class="main">
    <!-- <table class="searchTab">
    </table><br/> -->
    <table id="tt"></table>
    <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
    </div>
</div>
</body>
</html>
