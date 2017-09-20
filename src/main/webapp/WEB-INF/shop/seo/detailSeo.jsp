<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,500,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			  url: "${pageContext.request.contextPath}/back/shopseo/getShopseoObject.action",
			   data: {id:id},
			   dataType: "JSON",
			   success: function(data){
				   $("#d_categorySource").html(data.categorySource);
				   $("#d_title").html(data.title);
				   $("#d_keywords").html(data.keywords);
				   $("#d_description").html(data.description);
			   }
		});
	}
</script>
  <div id="detailWin" >
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="150px">来源类型:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_categorySource"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">标题:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_title"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">关键字:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_keywords"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">描述:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="440px">&nbsp;&nbsp;<span id="d_description"></span></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			 <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
		</div>
  </div>

