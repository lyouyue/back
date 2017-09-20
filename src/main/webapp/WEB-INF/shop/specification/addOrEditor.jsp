<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript">
  var infos="";
  var imageUrl="";
  $(function(){//表单验证
  	$("#form1").validate({meta: "validate", 
       submitHandler:function(form){
       $(document).ready(
            function() {
               var options = {  
                     url : "${pageContext.request.contextPath}/back/specification/saveOrUpdateSpecification.action",  
                     type : "post",  
                     dataType:"json",
                     success : function(data) {
                    	 	closeWin();
                    	 	$("#tt").datagrid("clearSelections");//删除后取消所有选项
					 		$("#tt").datagrid("reload"); //保存后重新加载列表
					 		$("#specificationId").val(null);
					 		infos="";
					 		imageUrl="";
					 		$("input.button_save").removeAttr("disabled");//防止重复提交
	                      }
	                  };
               		var flag = true;
               		
               		//把填写的规格值追加成字符串
				       for(var i=0;i<newItemNumber;i++){
				    		var infoName= $("#sortValue"+i).val();
				    	  	var infoValue= $("#nameValue"+i).val();
				    	  	$("#nameValue"+i).attr("onBlur","validateValue(this);");
				    	  	//效验
				    	  	if(infoValue==null||infoValue==""){
				    	  		flag = false;
				    	  		var error=$("#error"+i).attr("id");
				    	  		if(error==null||error==""){
					    	  		$("#nameValue"+i).after("<label id='error"+i+"' style=' color: red;margin-left: 0.5em;position: relative;top: 0;width: 20em'>不可为空</label>");
				    	  		}
				    	  	}
				    	    infos+=infoName+","+infoValue;
				    		if((newItemNumber-1)!=i){
				    			 infos+="@";
				    		 }
				      	}
	   				  $("#info").val(infos);
	   				  $("#imageUrl").val(imageUrl);
	   				  if(flag){
		                  $("#form1").ajaxSubmit(options);  
		                  $("input.button_save").attr("disabled","disabled");//防止重复提交
	   				  }
               });
       }
    });
  })
  //验证属性值是否存在
  function validateValue(obj){
	  var value = $(obj).val();
	  if($(obj)!=null&&$(obj)!=""&&value!=""){
		  //obj.removeAttr("onblur");
		  var nextObj = $(obj).next();
		  if(nextObj!=null&&nextObj!=""){
			  nextObj.remove();
		  }
	  }else{
		  var idValue = $(obj).attr("id");
		  idValue = idValue.replace("nameValue","error");
		  var error=$("#"+idValue).attr("id");
		  if(error==null||error==""){
			  $(obj).after("<label id='"+idValue+"' style=' color: red;margin-left: 0.5em;position: relative;top: 0;width: 20em'>不可为空</label>");
		  }
	  }
  }
  //类型为文本图片上传隐藏
  function text(){
	$("#image").css("display","none");
	$("#imageValue").css("display","none");
	$(".iamgeValue").css("display","none");
  }
  //类型为图片，图片上传显示
  function image(){
	$("#image").css("display","");
	$("#imageValue").css("display","");
	$(".iamgeValue").css("display","");
  }
  //变量记录追加了几个文本
  var newItemNumber = 1;
  function addType(){
	  var html = "<tr>"+
                 "<td align='center'><input id='sortValue"+newItemNumber+"' type='text' name='sortValue"+newItemNumber+"' value='0' onblur='checkOrder(this);'/></td>"+
                 "<td align='center'><input id='nameValue"+newItemNumber+"' type='text' name='nameValue"+newItemNumber+"' onblur='validateValue(this);' value=''/></td>"+
                 "<td class='iamgeValue' style='display:none'>"+
              	 "<form id='photoForm_"+newItemNumber+"' method='post' enctype='multipart/form-data'>"+
		         "&nbsp;&nbsp;&nbsp;&nbsp;<input id='fileId' type='file' name='imagePath'/>"+
		         "<span id='mes_"+newItemNumber+"'></span>"+
		  	     "<input id='buttonId' type='button' value='上传预览' onclick='uploadPhoto("+newItemNumber+")'/>"+
		  	     "<span id='photo_"+newItemNumber+"'></span>"+ 
		  	     "</form></td>"+
                 "<td align='center'><a onclick='remove_tr($(this));' href='javascript:'>移除</a></td>"+
                 "</tr>";
      	$('#tr_model > tr:last').after(html);
		if($("#s_dtype_image").val=="1"){
			$("#image").css("display","");
			$("#imageValue").css("display","");
			$(".iamgeValue").css("display","");
		}
		newItemNumber++;
	  if($("#s_dtype_image").attr("checked")=="checked"){
		  $("#image").css("display","");
		  $("#imageValue").css("display","");
		  $(".iamgeValue").css("display","");
	  }
  }
  //移除文本
  function remove_tr(o){
	  o.parents('tr:first').remove();
  }
   //上传图片 
		function uploadPhoto(id) {
			$(document).ready(  
               function() {  
                    var options = {  
                        url : "${pageContext.request.contextPath}/back/specification/uploadImage.action",
                        type : "post",  
                        dataType:"json",
                        success : function(data) {
	                        if(data.photoUrl=="false1"){
	                          $("#mes_"+id).html(" <font style='color:red'>请选择上传图片</font>");
	                        }else if(data.photoUrl=="false2"){
	                          $("#mes_"+id).html(" <font style='color:red'>请上传jpg、png、gif格式的图片 ！</font>");
	                        }else{
	                         var s = id+"_"+data.photoUrl;
	                         imageUrl = imageUrl+","+s;
	                         $("#photoUrl").val(data.photoUrl);
	                         $("#photo_"+id).html("");
	                       	 $("#photo_"+id).html("<img src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='20px' height='20px' />");
	                        } 
                        }
                    };
                   $("#photoForm_"+id).ajaxSubmit(options);
            });  
		}
</script>
<div id="addOrEditWin">
    <form id="form1"  method="post">
        <input id="specificationId" type="hidden" name="specification.specificationId" value=""/>
        <input id="info" type="hidden" name="info" value=""/>
        <input id="imageUrl" type="hidden" name="imageUrl" value=""/>
	    <table align="center" class="addOrEditTable" style="width: 800px;">
	    	<tr>
	    		<td align="center" style="font-weight:bold;" colspan="2">
	    			<span><font>规格信息</font></span>
	    		</td>
	    	</tr>
	    	<tr>
		      <td class="toright_td" width="150px">套餐分类名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;
		      		<select id="productTypeId" name="specification.productTypeId" class="{validate:{required:true}}">
		              <option value="">--请选择分类--</option>
			          <s:iterator value="#application.categoryMap" var="type1">
						  	<option value="<s:property value="#type1.key.productTypeId"/>"  >
						  	<s:property value="#type1.key.sortName"/>
						  	<s:iterator value="#type1.value" var="type2">
							  	<option value="<s:property value="#type2.key.productTypeId"/>"  >
							  		&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type2.key.sortName"/>
							  		<s:iterator value="#type2.value" var="type3">
							  		<option value="<s:property value="#type3.key.productTypeId"/>" >
							  			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type3.key.sortName"/>
							  			<s:iterator value="#type3.value" var="type4">
							  				<option value="<s:property value="#type4.productTypeId"/>" >
							  				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<s:property value="#type4.sortName"/>
							  			</s:iterator>
							  		</option>
							  		</s:iterator>	
							  	</option>
						  	</s:iterator>
						  	</option>
						  </s:iterator>
						  </select>
		      </td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">规格名称:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="name" type="text" name="specification.name" class="{validate:{required:true,maxlength:[150]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">规格备注:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="notes" type="text" name="specification.notes" class="{validate:{required:true,maxlength:[500]}}"></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">排序:</td>
		      <td class="toleft_td">&nbsp;&nbsp;<input id="sort" type="text" name="specification.sort" class="{validate:{required:true,number:true,maxlength:[5]}}"></td>
		    </tr>
		    <input id="s_dtype_text" type="hidden" name="specification.type" value="0" />
		    <%--<tr>
		      <td class="toright_td" width="150px">规格类型:&nbsp;&nbsp;</td>
			  <td class="toleft_td" colspan="3">
				  &nbsp;&nbsp;<input id="s_dtype_text" type="radio" name="specification.type" checked="checked" value="0" onclick="text();"/>文本
				  &nbsp;&nbsp;
				  <input id="s_dtype_image" type="radio" name="specification.type" value="1" onclick="image()"/>图片</td>
		    </tr> --%>
    </table>
      <div class="editButton"  data-options="region:'south',border:false" >
		<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	</div>
  </form>
  <div id="ggz" style="display: ">
  	  <table align="center" class="addOrEditTable" style="width: 800px; height: 30px;">
   		<tr>
    		<td align="center" style="font-weight:bold;" colspan="4">
    			<span><font>添加规格值:</font></span>
    		</td>
	    </tr>
    	<tr>
    		<td align="center" style="font-weight:bold;">排序</td>
    		<td align="center" style="font-weight:bold;">规格值</td>
    		<td id="image" style="display:none">规格图片</td>
    		<td>操作</td>
    	</tr>
    	<tbody id="tr_model">
   			<tr id="0"></tr>
            <tr id="1">
              <td align="center"><input id="sortValue0" type="text" name="sortValue0" value="0" onblur="checkOrder(this);"/></td>
              <td align="center"><input id="nameValue0" type="text" name="nameValue0" value="" onblur="validateValue(this);"/></td>
              <td class="iamgeValue" style="display:none">
              	<form id="photoForm_0" method="post" enctype="multipart/form-data">
		      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file"  name="imagePath"/>
		            <span id="mes_0"></span>
		  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto(0)"/>
		  	        <span id="photo_0"></span>
		  	    </form>
              </td>
              <td align="center"><!-- <a onclick="remove_tr($(this));" href="javascript:void(0);">移除</a> --></td>
            </tr>
         </tbody>
         <tbody>
             <tr>
               <td colspan="15"><a class="btn-add marginleft" id="add_type" href="javascript:addType();"> <span>添加一个规格值</span> </a></td>
             </tr>
         </tbody>
    </table>
  </div>
</div>
