<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
  $(function(){//表单验证
   //表单验证
		    $("#form1").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	              function() {  
                     var options = {  
                         url : "${pageContext.request.contextPath}/back/navigation/saveOrUpdateNavigation.action",  
                         type : "post",  
                         dataType:"json",
                         success : function(data) { 
                        	 closeWin();
                        	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
							 $("#tt").datagrid("reload"); //保存后重新加载列表
							 $("#navigationId").val(null);
                         }
                     };  
                     $("#form1").ajaxSubmit(options);  
                     $("input.button_save").attr("disabled","disabled");//防止重复提交

                  });
		       }
		    });
	});
	//查询计量单位是否已存在
	function checkMeasuringUnit(id){
		var value = $("#navigationName").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/navigation/checkNavigationName.action",
				data:{navigationName:value},
				success:function(data){
					var unitValue=$("#navigationName").val();
					if(unitValue.length<=20){
						if(data == "ok"){
							$("#nameMsg").html("<em style='color:green'>可用</em>");
							$("#save").css("display","");
						}else{
							$("#nameMsg").html("<em style='color:red'>已存在</em>");
							$("#navigationName").focus();
							$("#save").css("display","none");
						}
					}else{
						$("#nameMsg").html("");
						$("#navigationName").focus();
					}
				}
			});
		}else{
			$("#nameMsg").html("");
		}
	}
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="navigationId" type="hidden" name="navigation.navigationId" value="">
	    <table style="margin:10px auto;width:800px" class="addOrEditTable" >
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>前台导航条名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:230px" id="navigationName" type="text" name="navigation.navigationName" onchange="checkMeasuringUnit(this.id)" class="{validate:{required:true,maxlength:[20]}}"/>
		    	<span id="nameMsg"></span>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px"><span style="color:red">* </span>前台导航条url:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:230px" id="navigationUrl" type="text" name="navigation.navigationUrl" class="{validate:{required:true,maxlength:[300],url:true}}"/>
		    	<%-- <span><font color="red">提示：请添加链接前缀，如http://</font></span> --%>
		    </tr>
		    <tr>
		      <td class="toright_td"><span style="color:red">* </span>前台导航条排序号:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:230px" id="sortCode" type="text" name="navigation.sortCode" class="{validate:{required:true,maxlength:[10],number:true}}"/>
		    </tr>
		    <tr>
		      <td class="toright_td"><span style="color:red">* </span>是否使用:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;&nbsp;<input id="isUser_1"  type="radio" name="navigation.isUser" checked="checked" value="1"/>使用&nbsp;&nbsp;<input id="isUser_0"  type="radio" name="navigation.isUser" value="0"/>不使用</td>
		    </tr>
		    <tr>
		      <td class="toright_td"><span style="color:red">* </span>是否显示:&nbsp;&nbsp;</td>
		      <td class="toleft_td">&nbsp;&nbsp;&nbsp;<input id="isShowOnBar_1"  type="radio" name="navigation.isShowOnBar" checked="checked" value="1"/>显示&nbsp;&nbsp;<input id="isShowOnBar_0"  type="radio" name="navigation.isShowOnBar" value="0"/>不显示</td>
		    </tr>
		    <tr>
		      <td class="toright_td">前台导航条SEO标题:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:230px" id="seoTitle" type="text" name="navigation.seoTitle" class="{validate:{maxlength:[30]}}"/>
		    </tr>
		    <tr>
		      <td class="toright_td">前台导航条SEO关键字:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input style="width:230px" id="seoKeyWords" type="text" name="navigation.seoKeyWords" class="{validate:{maxlength:[30]}}"/>
		    </tr>
		    <tr>
		      <td class="toright_td">前台导航条SEO简介:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<textarea style="width:230px" id="seoDescrible" type="text" name="navigation.seoDescrible" class="{validate:{maxlength:[100]}}"></textarea>
		    </tr>
    </table>
    <div class="editButton"  data-options="region:'south',border:false" >
    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
    </div>
  </form>
</div>
