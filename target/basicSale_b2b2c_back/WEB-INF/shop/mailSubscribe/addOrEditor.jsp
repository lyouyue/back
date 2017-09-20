<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
<script type="text/javascript">

</script>
 <div id="addOrEditWin">
<!-- 		   <form id="photoForm" method="post" enctype="multipart/form-data">
		     <table align="center" class="addOrEditTable" width="780px;">
		          <tr>
				      <td class="toright_td" width="80px">文章图片:&nbsp;&nbsp; </td>
				      <td class="toleft_td"  width="650px">
				      &nbsp;&nbsp;&nbsp;&nbsp;<input id="fileId" type="file" name="imagePath"/>
				            <span id="mymessage"></span>
				  	        <input id="buttonId" type="button" value="上传预览" onclick="uploadPhoto()"/>
				      </td>
				  </tr> 
			 </table>
	   		</form> -->
	   		
		    <form id="form1"  method="post" action="${pageContext.request.contextPath}/back/mailSubscribe/saveOrUpdateMailSubscribe.action">
		        <input id="articleId" type="hidden" name="mailSubscribe.articleId" >
		        <input id="createTime" type="hidden" name="mailSubscribe.createTime" >
		        <input id="publishUser" type="hidden" name="mailSubscribe.publishUser" >
		        <input id="isSend" type="hidden" name="mailSubscribe.isSend" value="0">
			    <table align="center" class="addOrEditTable" width="780px;">
<!-- 			        <tr>
				      <td class="toright_td" width="80px">图片预览 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td" width="650px">&nbsp;&nbsp;
				          &nbsp;&nbsp;&nbsp;&nbsp;<span id="photo"></span>
				      </td>
				    </tr> -->
				    <tr>
				      <td class="toright_td" width="80px">标题:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="650px">&nbsp;&nbsp;<input id="title" type="text" name="mailSubscribe.title" class="{validate:{required:true,maxlength:[100]}}"/></td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="80px">摘要:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="650px">&nbsp;&nbsp;
				       <textarea rows="3" cols="50" id="brief" type="text" name="mailSubscribe.brief" class="{validate:{maxlength:[100]}}"></textarea>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="80px">内容:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="650px">&nbsp;&nbsp;
				      <input type="hidden"  name="mailSubscribe.content" id="contentBK"/>
				      <textarea id="content" style="width:650px;height:200px;visibility:hidden;" name=""></textarea>
				       <script type="text/javascript">
				       		var editor;
							KindEditor.ready(function(K){
									editor = K.create("#content",{
									cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
									uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subMode=cms",
									fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subMode=cms",
									allowFileManager : false,
									allowPreviewEmoticons : false,
									items : [
				                              'source', '|', 'undo', 'redo', '|', 'preview', 'print', 'cut', 'copy', 'paste',
				                              'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
				                              'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
				                              'superscript', 'clearhtml', 'selectall', '|', 'fullscreen', '|',
				                              'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
				                              'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image',
				                              'table', 'hr', 'emoticons', 'pagebreak', 'link', 'unlink'
				                          ],
					                    filterMode : false
								});
								prettyPrint();
							});
					   </script>
				      </td>
				    </tr>
			    </table>
			    <div style="text-align:center;padding:5px 0;">
					<input type="submit" id="save"  class="button_save" value="" style="cursor:pointer;"/>&nbsp;
					<input type="button" id="close" class="button_close" onclick="closeWin()" style="cursor:pointer;"/>&nbsp;
					
 					<%--<input type="button" name="getHtml" value="取得HTML" />
 					<input type="button" name="button" value="取得内容" onclick="javascript:alert(KindEditor.util.getData('content'));" />搜索
 					<input type="button" name="button" value="取得纯文本" onclick="javascript:alert(KindEditor.util.getPureData('content'));" />--%>
 					
				</div>
			</form>
		  </div>
</html>