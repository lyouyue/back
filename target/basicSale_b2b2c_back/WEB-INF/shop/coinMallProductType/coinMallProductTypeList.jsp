<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>积分商城分类信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <link  rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}basic/css/tree.css"/>
    <script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}shop/js/jquery.simple.coinMallProductType.tree.js"></script>
    <script type="text/javascript">
        $(function(){
            //表单验证
            $("#form1").validate({meta: "validate",
                submitHandler:function(form){
                    $(document).ready(
                            function() {
                                var options = {
                                    url : "${pageContext.request.contextPath}/back/coinMallProductType/saveOrEditCoinMallTuanProductType.action",
                                    type : "post",
                                    dataType:"json",
                                    success : function(data) {
                                        closeWin();
                                        location.reload();
                                    }
                                };
                                $("#form1").ajaxSubmit(options);
                            });
                }
            });
        });
        var simpleTreeCollection;
        //var name="";
        var id="";
        $(document).ready(function(){
            simpleTreeCollection = $('.simpleTree').simpleTree({
                autoclose: true,
                afterClick:function(node){
                    id=$('span:first',node).attr("pid");

                },
                afterDblClick:function(node){

                },
                afterMove:function(destination, source, pos){

                },
                afterAjax:function()
                {
                },
                animate:true
                //,docToFolderConvert:true
            });
            //获取单个对象，或者：var obj = document.getElementById('2')
            var obj = $("#2")[0];// 2 为需要展开的根目录id
            simpleTreeCollection.each(function(){
                this.nodeToggle(obj);//自动触发展开
            });
        });
        function addProductType(id){
            //准备初始数据 ,父亲分类
            createWindow(700,'auto',"&nbsp;&nbsp;添加积分商城分类","icon-add",false,"win");
            $("#addOrEditWin").css("display","");
            $("#detailWin").css("display","none");//隐藏修改窗口
            $("#typeId").val("");
            $("#sort").val("");
            $("#typeName").val("");
            $("#typeParentId").val(id);
        }
        //编辑
        function editProductType(id){
            $.ajax({
                type: "POST",
                dataType: "JSON",
                url: "${pageContext.request.contextPath}/back/coinMallProductType/getCoinMallProductTypeObject.action",
                data: {typeId:id},
                success: function(data){
                    //显示
                    createWindow(700,'auto',"&nbsp;&nbsp;修改积分商城分类","icon-edit",false,"win");
                    $("#addOrEditWin").css("display","");
                    $("#detailWin").css("display","none");//隐藏修改窗口
                    $("#typeId").val(data.typeId);
                    $("#typeParentId").val(data.typeParentId);
                    $("#typeName").val(data.typeName);
                    $("#sort").val(data.sort);
                }
            });
        }
        //详情
        function getProductTypeInfo(id){
            $.ajax({
                type: "POST",
                dataType: "JSON",
                url: "${pageContext.request.contextPath}/back/coinMallProductType/getCoinMallProductTypeObject.action",
                data: {typeId:id},
                success: function(data){
                    $("#dtypeName").html(data.typeName);
                    $("#dsort").html(data.sort);
                    //显示
                    createWindow(700,'auto',"&nbsp;&nbsp;积分商城分类详情","icon-add",false,"win");
                    $("#addOrEditWin").css("display","none");
                    $("#detailWin").css("display","");
                }
            });
        }
        //删除一个分类
        function editPurview(id){
        	$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
				if(data){//判断是否删除
	                $.ajax({
	                    type: "POST",
	                    dataType: "JSON",
	                    url: "${pageContext.request.contextPath}/back/coinMallProductType/delCoinMallProductType.action",
	                    data: {typeId:id},
	                    success: function(data){
	                        if(data.isSuccess=="true"){
	                            msgShow("系统提示", "<p class='tipInfo'>删除成功！</p>", "warning");  
	                            location.reload();
	                        }else{
	                            msgShow("系统提示", "<p class='tipInfo'>此分类下面还有子分类，请先删除子分类！</p>", "warning");  
	                        }
	                    }
	                });
            	}
        	});
		}
        //取消
        function cancel(){
            $("#addOrEditWin").css("display","none");
        }

        //提交
        function tijiao(){
            var typeId = $("#typeId").val();
            var typeParentId = $("#typeParentId").val();
            var typeName = $("#typeName").val();
            var sort = $("#sort").val();
            $.ajax({
                type: "POST",
                dataType: "JSON",
                url: "${pageContext.request.contextPath}/back/coinMallProductType/saveOrEditCoinMallTuanProductType.action",
                data: {"coinMallProductType.typeId":typeId,"coinMallProductType.typeParentId":typeParentId,"coinMallProductType.typeName":typeName,"coinMallProductType.sort":sort},
                success: function(data){
                    location.reload();
                    //location.href="${pageContext.request.contextPath}/category/getNodes.action?id="+categoryId;
                }
            });
        }

        //根据分类查询商品
        function findProductInfoByProductTypeId(id){
            location.href="${pageContext.request.contextPath}/back/coinMallProductType/gotoProductInfoListByTypeId.action?typeId="+id;
        }
        //根据分类查询品牌
/*        function findBrandByProductTypeId(id){
            location.href="${pageContext.request.contextPath}/coinMallProductType/gotoBrandListByTypeId.action?tuanProductTypeId="+id;
        }*/
        function createDetailWindow(title,iconCls,inline,winId){
            $('#win').css("display","");
            $('#win').window({
                title:title,iconCls:iconCls,minimizable:false,maximizable:true,closable:true,shadow:false,
                closed:true,draggable:true,resizable:true,inline:inline,width:900,height:'500',modal:true,top:30
            }).window('open');
        }
    </script>
</head>
<body>
<jsp:include page="../../util/item.jsp"/>
<div class="main">
    <div style="padding: 10px;height:550px;line-height:25px;border: 1px solid #ccc;">
        <div style="overflow: auto;height:525px;">
            <form action="a" target="Index" method="post">
                <ul class="simpleTree">
                    <li class="root" id='1' style="margin: 0 0 0 -13px;">
                        <ul>
                            <li id='2'>
                                <span style="padding-left:5px;">积分商城分类</span>
                                <a onclick="addProductType(0)" style="cursor:pointer;margin-left:10px;" class="folder">
                                    &nbsp;&nbsp;<img style="vertical-align: top;" src="${fileUrlConfig.sysFileVisitRoot_back}basic/images/tree/folder_add.png"/>&nbsp;添加
                                </a>
                                <ul class="ajax" style="margin-top:3px;">
                                    <li id='3'>
                                        {url:${basePath}/back/coinMallProductType/getNodes.action?id=0}
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </form>
        </div>
    </div>
    <!-- 新增分类  -->
    <div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
        <!-- 添加或者修改 -->
        <jsp:include page="addOrEditor.jsp"/>
        <!-- 详情页 -->
        <jsp:include page="detail.jsp"/>
    </div>
</div>
</body>
</html>
