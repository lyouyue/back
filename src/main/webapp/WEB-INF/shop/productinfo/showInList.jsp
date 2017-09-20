<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
    $(function(){
        $("#btnShowList").click(function(){
            var rows = $("#tt").datagrid("getSelected"); //找到所有选中的行
            var pid = rows.productId;
            var isShowValue=$("input[name='isShow'][type='radio']:checked").val();
            $.ajax({
                url : "${pageContext.request.contextPath}/back/productinfo/updateShowList.action",
                type : "post",
                dataType:"json",
                data:{productId:pid,isShow:isShowValue},
                success : function(data) {
                    if(data.isSuccess=="true"){
                        msgShow("系统提示", "<p class='tipInfo'>修改成功！</p>", "warning");
                        closeWin();
                        $("#tt").datagrid("reload"); //保存后重新加载列表
                        $("#productId").val(null);
                    }else if(data.isSuccess=="false"){
                        msgShow("系统提示", "<p class='tipInfo'>修改失败！</p>", "warning");
                    }
                }
            })
        })
    })
</script>
<div id="showInListWin">
    <form id="formShowList"  method="post" enctype="multipart/form-data">
        <input id="productId" type="hidden" name="productId" value="">
        <input type="hidden" name="isTop" value="0" noclear="true"/>
        <table align="center" class="addOrEditTable" width="900px;" style="margin-left:28px;">
            <tr>
                <td class="toright_td" width="150px">是否显示在列表:&nbsp;&nbsp;</td>
                <td class="toleft_td">
                    &nbsp;&nbsp;<input id="isShow_1" type="radio" name="isShow" value="1"/>显示
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input id="isShow_0" type="radio" name="isShow" value="0"/>不显示
                </td>
            </tr>
        </table>
        <div class="editButton"  data-options="region:'south',border:false" >
            <a id="btnShowList" class="easyui-linkbutton" icon="icon-save" href="javascript:;">保存</a>
            <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
        </div>
    </form>
</div>
