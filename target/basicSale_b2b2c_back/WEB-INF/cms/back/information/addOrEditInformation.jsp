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
                    url : "${pageContext.request.contextPath}/back/cmsInformation/saveOrUpdateCmsInformation.action",  
                    type : "post",  
                    dataType:"json",
                    success : function(data) { 
                   	 closeWin();
                   	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
					 $("#tt").datagrid("reload"); //保存后重新加载列表
					 $("#informationId").val(null);
                    }
                };  
                $("#content").val(KindEditor.instances[0].html());
                $("#form1").ajaxSubmit(options); 
                $("input.button_save").attr("disabled","disabled");//防止重复提交
             });
       }
    });
  });


</script>
 <div id="addOrEditWin">
		   <form id="photoForm" method="post" enctype="multipart/form-data">
		     <table style="text-align: center;width: 800px;" class="addOrEditTable">
		          <tr>
				      <td style="text-align: right;width: 150px;">信息图片:&nbsp;&nbsp; </td>
				      <td style="text-align: left;width: 440px;">
				      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file" name="imagePath"/>
				            <span id="mymessage"></span>
				  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto('cms','image_information')"/>
				  	        &nbsp;&nbsp;<!-- <font color="red">提示：请上传1000x400像素的图片</font> -->
				      </td>
				  </tr>
			 </table>
	   		</form>
		    <form id="form1"  method="post" action="">
		    <input type="hidden" name="cmsInformation.imgUrl" id="imageUrl" value=""/>
		     <input type="hidden" name="cmsInformation.informationId" id="informationId" value="" noclear="true"/>
		      <input type="hidden" name="cmsInformation.createTime" id="createTime" value=""/>
		       <input type="hidden" name="cmsInformation.publishUser" id="publishUser" value=""/>
			    <table style="text-align: center;width: 800px;" class="addOrEditTable">
			        <tr>
				      <td style="text-align: right;width: 94px;">图片预览 :&nbsp;&nbsp;</td>
				      <td style="text-align: left;width: 440px;">&nbsp;&nbsp;
				          &nbsp;&nbsp;&nbsp;&nbsp;<span id="photo"></span>
				      </td>
				    </tr>
				      <tr>
				      <td style="text-align: right;width: 94px;">标题:&nbsp;&nbsp;</td>
				      <td style="text-align: left;width: 440px;">&nbsp;&nbsp;&nbsp;<input id="title" type="text" name="cmsInformation.title" class="{validate:{required:true,maxlength:[200]}}"/></td>
				    </tr>
				    	<tr>
			      <td style="text-align: right;width: 150px;">信息分类:</td>
			      <td style="text-align: left;width: 440px;">&nbsp;&nbsp;
			           <select id="categoryId" name="cmsInformation.categoryId">
			              <option value="-1" selected="selected">请选择分类项</option>
						  <s:iterator value="#request.cmsInformationCategoryList">
						  	<option value="<s:property value="informationCategoryId"/>"><s:property value="categoryName"/></option>
						  </s:iterator>
			           </select>
			      </td>
		        </tr>
		        </tr> 
				    <tr>
				      <td style="text-align: right;width: 94px;">是否显示 :&nbsp;&nbsp;</td>
				      <td style="text-align: left;width: 440px;">&nbsp;&nbsp;
					      <input id="isShow_0"  type="radio" name="cmsInformation.isShow" value="0" />不显示
					      <input id="isShow_1"  type="radio" name="cmsInformation.isShow" value="1" checked="checked"/>显示
				      </td>
				    </tr>
				    <tr>
				      <td style="text-align: right;width: 94px;">摘要:&nbsp;&nbsp;</td>
				      <td style="text-align: left;width: 440px;">&nbsp;&nbsp;
				       <textarea  rows="3" cols="50" id="brief" name="cmsInformation.brief" class="{validate:{required:true,maxlength:[200]}}"></textarea>
				      </td>
				    </tr>
				    <tr>
				      <td style="text-align: right;width: 94px;">内容:&nbsp;&nbsp;</td>
				      <td style="text-align: left;width: 440px;">
				       <textarea id="content" style="width: 400px; height: 200px;" rows="8" cols="48" name="cmsInformation.content"></textarea>
				       <script type="text/javascript">
				       var editor;
				        KindEditor.ready(function(K) {
				                 editor = K.create('#content',{
				                  width:'98%',
				                  height:'400px',
									cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
									uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subSys=cms",
									fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subSys=cms",
				                    allowFileManager : false,
									allowPreviewEmoticons : false,
									resizeType : 2,
									items : [
										'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'cut', 'copy', 'paste',
										'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
										'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
										'superscript', 'clearhtml', 'selectall', '|', 'fullscreen', '|',
										'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
										'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', '|', 'multiimage', 
										'table', 'hr', 'emoticons', 'pagebreak', 'link', 'unlink'
									],
									filterMode : false
				            });
				        });
						</script>
				      </td>
				    </tr>
				   <!--  这个暂时保留，以后扩展用 
				    <tr>
				      <td class="toright_td" width="150px">外网访问地址:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;<input id="outUrl" type="text" name="cmsArticle.outUrl" class="{validate:{required:true,maxlength:[200]}}"/></td>
				    </tr>
				   -->
			    </table>
			    <div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
				</div>
			</form>
		  </div>