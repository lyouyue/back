<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
 <div id="addOrEditWin">
			<form id="photoForm1" method="post" enctype="multipart/form-data">
				<table align="center" class="addOrEditTable" width="800px">
					<tr>
						<td class="toright_td" width="61px"><span style="color:red">* </span>新闻图片:&nbsp;&nbsp; </td>
						<td class="toleft_td"  width="228px" >
							&nbsp;&nbsp;<input id="fileId1" type="file" name="imagePath" style="width: 145px;"/>
							<span id="mymessage1"></span>
							<input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_article','30px','30px','1')"/>
							<div class="imgMessage">提示：请上传规格宽120px，高120px的图片</div>
						</td>
						<td class="toright_td" width="56px">图片预览 :&nbsp;&nbsp;</td>
						<td  class="toleft_td" width="202px">&nbsp;&nbsp;
							<span id="photo1"></span>
						</td>
					</tr> 
				</table>
			</form>
	   		
		    <form id="form1"  method="post" action="${pageContext.request.contextPath}/back/cmsArticle/saveOrUpdateArticle.action">
		        <input id="categoryId" type="hidden" value="${param.categoryId}" name="cmsArticle.categoryId" noclear="true" >
		        <input id="articleId" type="hidden" name="cmsArticle.articleId" >
		        <input id="imageUrl1" type="hidden" name="cmsArticle.imgUrl" >
		        <input id="imgTrueName" type="hidden" name="cmsArticle.imgTrueName" >
		        <input id="clickCount" type="hidden" name="cmsArticle.clickCount" >
		        <input id="isDeal" type="hidden" name="cmsArticle.isDeal" >
		        <input id="createTime" type="hidden" name="cmsArticle.createTime" >
		        <input id="isPass" type="hidden" name="cmsArticle.isPass" value="1" noclear="true" >
		        <input id="articleType"  type="hidden"  value="0"  name="cmsArticle.articleType" noclear="true" />
		        <input id="isEssence"  type="hidden" name="cmsArticle.isEssence" value="0" noclear="true" />
		        <input id="isOpenDiscuss"  type="hidden" name="cmsArticle.isOpenDiscuss" value="0" noclear="true" />
		        
			    <table align="center" class="addOrEditTable" width="740px">
			         <!-- <tr>
				      <td class="toright_td" width="80px">图片预览 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td" width="650px">&nbsp;&nbsp;
				          &nbsp;&nbsp;&nbsp;&nbsp;<span id="photo"></span>
				      </td>
				    </tr> -->
				    
				    <%--<tr>
				      <td class="toright_td" width="80px">新闻类型 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td" width="650px">&nbsp;&nbsp;
				         <input type="radio" onclick="selectType(this)" value="0"  name="cmsArticle.articleType" checked="checked"/>无
				         <input type="radio" onclick="selectType(this)" value="1"  name="cmsArticle.articleType"/>文档
				         <input type="radio" onclick="selectType(this)" value="2"  name="cmsArticle.articleType"/>图片
				         <input type="radio" onclick="selectType(this)" value="3"  name="cmsArticle.articleType"/>视频
				         <input type="radio" onclick="selectType(this)" value="4"  name="cmsArticle.articleType"/>音频
				      </td>
				   </tr>
				   <tr style="display: none" id="acttId2" >
				      <td class="toright_td" width="80px">上传文档或图片:&nbsp;&nbsp;</td>
				      <td class="toleft_td"  width="650px">
				        <div >
							<input type="hidden" name="attUrlsImg" id="urls"/>
							<div class="legend" style="margin:0px 0px 0px 20px;">
								<div style="float:left;" id="parentDiv"></div>
							</div>
							<div class="fieldset flash" id="fsUploadProgress"></div>
							<div style="clear:both"></div>
						</div>
						<div id="fjInfo" style="display:none"></div>
			         </td>
			      </tr>
			      <tr id="acttId" style="display: none">
				       <td class="toright_td" width="80px">播放地址:</td>
				       <td class="toleft_td"  width="650px">
				               <!-- 增加按钮  -->
				               <!-- 默认 文本框  -->
				               <div id="mainDiv">
				                 <div id="mainDiv_0">
					               <input type="text" id="attUrls_0" name="attUrls" />
					               <input type="button" value="删除" onclick="deleteAttUrls('mainDiv_0')"/> <input type="button" value="增加 " onclick="addInput()"/><br/>
				                 </div>
				               </div>
				       </td>
				    </tr>
				    --%>
				    <%--
				     <tr>
				      <td class="toright_td" width="80px">推荐:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="650px">&nbsp;&nbsp;
				          <input  type="radio" name="cmsArticle.isEssence" value="0" checked="checked"/>不推荐
					      <input  type="radio" name="cmsArticle.isEssence" value="1" />推荐
					      
				      </td>
				    </tr>
				    
				    <tr>
				      <td class="toright_td" width="94px">审核状态 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="400px">&nbsp;&nbsp;
					      <input  type="radio" name="cmsArticle.isPass" value="1" />已经审核
					      <input  type="radio" name="cmsArticle.isPass" value="0" />未审核
					      <input  type="radio" name="cmsArticle.isPass" value="2"/>不通过 
				      </td>
				    </tr>
				    
				    <tr>
				      <td class="toright_td" width="80px">是否开放评价 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="650px">&nbsp;&nbsp;
					      <input  type="radio" name="cmsArticle.isOpenDiscuss" value="1" checked="checked"/>开放
					      <input  type="radio" name="cmsArticle.isOpenDiscuss" value="0" />不开放
				      </td>
				    </tr>
				     --%>
				   <tr>
				      <td class="toright_td" width="80px"><span style="color:red">* </span>标题:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="170px">&nbsp;&nbsp;<input id="title" type="text" name="cmsArticle.title" class="{validate:{required:true,maxlength:[100]}}"/></td>
				    <!-- </tr>
				     <tr> -->
				      <td class="toright_td" width="40px"><span style="color:red">* </span>摘要:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="150px">&nbsp;&nbsp;<input id="brief" type="text" name="cmsArticle.brief" class="{validate:{required:true,maxlength:[100]}}"/>
				       <!-- <textarea rows="3" cols="50" id="brief" type="text" name="cmsArticle.brief" class="{validate:{maxlength:[100]}}"></textarea> -->
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="80px"><span style="color:red">* </span>排序:&nbsp;&nbsp;</td>
				      <!-- 
				      <td  class="toleft_td">&nbsp;&nbsp;<input id="sortCode" type="text" name="cmsArticle.sortCode" class="{validate:{required:true,maxlength:[11]},digits:true}}"/></td>
				       -->
				      <td  class="toleft_td"  width="170px">&nbsp;&nbsp;<input id="sortCode" type="text" name="cmsArticle.sortCode"  class="{validate:{required:true,maxlength:[11],digits:true}}"/></td>
				    <!-- </tr>
				    <tr> -->
				      <td class="toright_td" width="40px"><span style="color:red">* </span>是否显示 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="150px">&nbsp;&nbsp;
					      <input type="radio" name="cmsArticle.isShow" value="1" checked="checked"/>显示
					      <input type="radio" name="cmsArticle.isShow" value="0" />不显示
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="80px"><span style="color:red">* </span>seo标题:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="150px">&nbsp;&nbsp;<input id="seoTitle" type="text" name="cmsArticle.seoTitle" class="{validate:{required:true,maxlength:[100]}}"/>
				        <!--  <textarea rows="3" cols="50" id="seoTitle" type="text" name="cmsArticle.seoTitle" class="{validate:{maxlength:[100]}}"></textarea> -->
				      </td>
				    <!-- </tr>
				    <tr> -->
				      <td class="toright_td" width="40px"><span style="color:red">* </span>seo关键词:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="150px">&nbsp;&nbsp;<input id="keywords" type="text" name="cmsArticle.keywords" class="{validate:{required:true,maxlength:[100]}}"/>
				         <!-- <textarea rows="3" cols="50" id="keywords" type="text" name="cmsArticle.keywords" class="{validate:{maxlength:[150]}}"></textarea> -->
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="80px">内容:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="650px" height="120px" colspan="3">
				       <input type="hidden"  name="cmsArticle.content" id="contentBK"/>
				       <textarea id="content" style="width:650px;height:118px;visibility:hidden;" name=""></textarea>
				       <script type="text/javascript">
				       		var editor;
							KindEditor.ready(function(K){
									editor = K.create("#content",{
									cssPath:"${fileUrlConfig.sysFileVisitRoot_back}3thParty/kindeditor/plugins/code/prettify.css",
									uploadJson:"${pageContext.request.contextPath}/ke/uploadJson.jsp?subSys=cms",
									fileManageJson:"${pageContext.request.contextPath}/ke/fileManagerJson.jsp?subSys=cms",
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
				   <%--  这个暂时保留，以后扩展用 
				    <tr>
				      <td class="toright_td" width="140px">外网访问地址:&nbsp;&nbsp;</td>
				      <td  class="toleft_td">&nbsp;&nbsp;<input id="outUrl" type="text" name="cmsArticle.outUrl" class="{validate:{required:true,maxlength:[200]}}"/></td>
				    </tr>
				   --%>
			    </table>
			    <div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
	    			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
				</div>
			</form>
		  </div>
</html>