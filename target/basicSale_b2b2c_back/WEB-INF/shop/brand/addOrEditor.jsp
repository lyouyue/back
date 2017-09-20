<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	$(function(){//表单验证
		//表单验证
		$("#form1").validate({meta: "validate", 
			submitHandler:function(form){
				var imageUrl1=$("#imageUrl1").val();
				var imageUrl2=$("#imageUrl2").val();
			if(imageUrl1 != null && imageUrl1 !='' || imageUrl2 != null && imageUrl2 !=''){
			if(imageUrl1 != null && imageUrl1 !=''){
			if(imageUrl2 != null && imageUrl2 !=''){
				$("#mymessage1").html("");
				$("#mymessage2").html("");
			$(document).ready(
				function() {  
					var options = {  
						url : "${pageContext.request.contextPath}/back/brand/saveOrUpdateBrand.action",  
						type : "post",  
						dataType:"json",
						success : function(data) { 
							closeWin();
							$("#tt").datagrid("clearSelections");//删除后取消所有选项
							$("#tt").datagrid("reload"); //保存后重新加载列表
							$("#brandId").val(null);
							$("input.button_save").removeAttr("disabled");//解除提交锁定
						}
					};
					$("#form1").ajaxSubmit(options);  
					$("input.button_save").attr("disabled","disabled");//防止重复提交
				});
				}else{
					$("#mymessage2").html("<font color='Red'>请上传品牌列表大图！</font>");
					if(imageUrl1!=null && imageUrl1!=''){}else{
						$("#mymessage1").html("<font color='Red'>请上传首页推荐品牌图片！</font>");
					}
				}
			}else{
				$("#mymessage1").html("<font color='Red'>请上传首页推荐品牌图片！</font>");
					if(imageUrl2!=null && imageUrl2!=''){}else{
						$("#mymessage2").html("<font color='Red'>请上传品牌列表大图！</font>");
					}
				}
			}else{
				$("#mymessage1").html("<font color='Red'>请上传首页推荐品牌图片！</font>");
				$("#mymessage2").html("<font color='Red'>请上传品牌列表大图！</font>");
			}
		}
	});
});
	//动态获取品牌首字母（暂不支持多音字）
	function getFirstWorld(value){
		if(value!=null&&$.trim(value)!=''){
			//小写字母
			var firstWordArray_down = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]; 
			//大写字母
			var firstWordArray_up = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]; 
			var firstWord = $.trim(value).substring(0,1);
			if(firstWordArray_up.indexOf(firstWord) > -1){
				$("#firstWord").val(firstWordArray_up[firstWordArray_up.indexOf(firstWord)]);
			}else if(firstWordArray_down.indexOf(firstWord) > -1){
				$("#firstWord").val(firstWordArray_up[firstWordArray_down.indexOf(firstWord)]);
			}else{
				$("#firstWord").val($.trim(wf.makePy(firstWord)));
			}
		}
	}
</script>
<div id="addOrEditWin">
	<form id="photoForm1" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="116px"><span style="color:red">* </span>首页推荐品牌:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="440px">
		      		&nbsp;&nbsp;<input id="fileId1" type="file"   name="imagePath"/>
		            <span id="mymessage1"></span>
		  	        <input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_brand','100px','40px','1')"/> 
		  	        <!-- <font color="red">推荐尺寸129*50</font> -->
		  	        <div class="imgMessage">提示：请上传规格宽191px，高77px的图片</div>
		      </td>
		      <td class="toright_td" width="100px"><span style="color:red">* </span>首页推荐品牌:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="130px">&nbsp;&nbsp;<span id="photo1"></span></td>
		  </tr> 
	 </table>
   	</form>
	<form id="photoForm2" method="post" enctype="multipart/form-data">
     <table align="center" class="addOrEditTable" width="600px;">
          <tr>
		      <td class="toright_td" width="116px"><span style="color:red">* </span>品牌列表大图:&nbsp;&nbsp; </td>
		      <td class="toleft_td" width="440px">
		      		&nbsp;&nbsp;<input id="fileId2" type="file"   name="imagePath"/>
		            <span id="mymessage2"></span>
		  	        <input id="buttonId2" type="button" value="上传预览" onclick="uploadPhoto('image_brand','100px','40px','2')"/>
		  	        <!--  <font color="red">推荐尺寸240*254</font> -->
		  	        <div class="imgMessage">提示：请上传规格宽180px，高60px的图片</div>
		      </td>
		      <td class="toright_td" width="100px">品牌列表大图:&nbsp;&nbsp;</td>
		      <td  class="toleft_td" width="130px">&nbsp;&nbsp;<span id="photo2"></span></td>
		  </tr> 
	 </table>
   	</form>
    <form id="form1"  method="post">
        <input id="brandId" type="hidden" name="brand.brandId" value="" noclear="true">
        <input id="imageUrl1" type="hidden" name="brand.brandBigImageUrl" value="">
        <input id="imageUrl2" type="hidden" name="brand.brandImageUrl" value="">
	    <table align="center" class="addOrEditTable" width="600px;">
		    <tr>
		      <td class="toright_td" width="195px"><span style="color:red">* </span>品牌名称:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;&nbsp;<input id="brandName" type="text" name="brand.brandName" onchange="getFirstWorld(this.value);" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    <!-- </tr>
		    <tr> -->
		      <td class="toright_td" width="195px"><span style="color:red">* </span>标题:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;&nbsp;<input id="title" type="text" name="brand.title" class="{validate:{required:true,maxlength:[50]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="195px">品牌归类:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;&nbsp;
			      <select id="firstWord" name="brand.firstWord">
		              <option value="A">A</option><option value="B">B</option><option value="C">C</option><option value="D">D</option>
		              <option value="E">E</option><option value="F">F</option><option value="G">G</option><option value="H">H</option>
		              <option value="I">I</option><option value="J">J</option><option value="K">K</option><option value="L">L</option>
		              <option value="M">M</option><option value="N">N</option><option value="O">O</option><option value="P">P</option>
		              <option value="Q">Q</option><option value="R">R</option><option value="S">S</option><option value="T">T</option>
		              <option value="U">U</option><option value="V">V</option><option value="W">W</option><option value="X">X</option>
		              <option value="Y">Y</option><option value="Z">Z</option><option value="0">0</option><option value="1">1</option>
		              <option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option>
		              <option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option>
		          </select>
		      </td>
		      <td class="toright_td" width="195px"><span style="color:red">* </span>简介:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;&nbsp;<input id="synopsis" type="text" name="brand.synopsis" class="{validate:{required:true,maxlength:[100]}}"/></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="195px"><span style="color:red">* </span>排序号:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;&nbsp;<input id="sortCode" type="text" name="brand.sortCode" class="{validate:{required:true,maxlength:[4],digits:true}}"/></td>
		      <td class="toright_td" width="195px">是否显示:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;<input id="isShow_0"  type="radio" name="brand.isShow" checked="checked" value="0"/>不显示&nbsp;&nbsp;&nbsp;<input id="isShow_1"  type="radio" name="brand.isShow" value="1"/>显示</td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="195px">品牌频道推荐:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;<input id="isRecommend_0"  type="radio" name="brand.isRecommend" checked="checked" value="0"/>否&nbsp;&nbsp;&nbsp;<input id="isRecommend_1"  type="radio" name="brand.isRecommend" value="1"/>是</td>
		      <td class="toright_td" width="195px">店铺首页品牌推荐:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="389px">&nbsp;<input id="isHomePage_0"  type="radio" name="brand.isHomePage" checked="checked" value="0"/>否&nbsp;&nbsp;&nbsp;<input id="isHomePage_1"  type="radio" name="brand.isHomePage" value="1"/>是</td>
		    </tr>
	</table>
	<div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
		<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
</div>
