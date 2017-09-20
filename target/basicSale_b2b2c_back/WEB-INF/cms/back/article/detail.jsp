<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
<style type="text/css">
#view_content img{max-width:550px; max-height:350px;}
</style>
  <div id="detailWin">
			<input id="view_articleId" type="hidden" name="cmsArticle.articleId" >
				<table align="center" class="addOrEditTable" width="850px">
					<tr>
					<td class="toright_td" width="150px">图片预览:</td>
					<td  class="toleft_td" colspan="3">&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="view_photo" ></span>
					</td>
				    </tr>
					<tr>
						<td class="toright_td" width="150px">标题:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_title"></span>
						</td>
					<!-- </tr>
					<tr> -->
						<td class="toright_td" width="150px">摘要:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_brief"></span>
						</td>
					</tr>
					<tr>
					<td class="toright_td" width="150px">排序:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_sortCode"></span>
						</td>
					<!-- </tr>
					<tr> -->
						<td class="toright_td" width="150px">是否显示 :&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_isShow"></span>
						</td>
					</tr>
					<tr>
						<td class="toright_td" width="150px">发布人:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_publishUser"></span>
						</td>
					<!-- </tr>
					<tr> -->
						<td class="toright_td" width="150px">修改人:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_modifyUser"></span>
						</td>
					</tr>
				    <%--<tr>
				      <td class="toright_td" width="150px">新闻类型 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td" width="440px">&nbsp;&nbsp;
				         <span id="view_articleType"></span>
				      </td>
				    </tr>
				    <tr style="display: none" id="view_acttId2" >
				      <td class="toright_td" width="150px">上传文档或图片:&nbsp;&nbsp;</td>
				      <td class="toleft_td"  width="440px">
				         <div id="attachmentsImgOrdoc" style="margin: 10px;"></div>
			        </td>
			      </tr>
			      <tr id="view_acttId" style="display: none">
				       <td class="toright_td" width="150px">播放地址:</td>
				       <td class="toleft_td"  width="440px">
				               <!-- 增加按钮  -->
				               <!-- 默认 文本框  -->
				               <div id="view_mainDiv">
				                 <div id="view_mainDiv_0">
					               <span id="view_attUrls_0"></span>
				                 </div>
				               </div>
				       </td>
				    </tr>
				     <tr>
				      <td class="toright_td" width="150px">设置精华:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
					      <span id="view_isEssence"></span>
				      </td>
				    </tr>
				    
				    <tr>
				      <td class="toright_td" width="150px">是否开放评价 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
				          <span id="view_isOpenDiscuss"></span>
				      </td>
				    </tr>--%>
					<tr>
						<td class="toright_td" width="150px">创建时间:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_createTime"></span>
						</td>
					<!-- </tr>
					<tr> -->
						<td class="toright_td" width="150px">修改时间:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_updateTime"></span>
						</td>
					</tr> 
					<tr>
						<td class="toright_td" width="150px">seo标题:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_seoTitle"></span>
						</td>
					<!-- </tr>
					<tr> -->
						<td class="toright_td" width="150px">seo关键词:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  width="440px">&nbsp;&nbsp;
							<span id="view_keywords"></span>
						</td>
					</tr>
					<tr>
						<td class="toright_td" width="150px">内容:&nbsp;&nbsp;</td>
						<td  class="toleft_td"  colspan="3">&nbsp;&nbsp;
							<div id="view_content"></div> 
						</td>
					</tr>
				    <%--<tr>
				      <td class="toright_td" width="150px">审核状态 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="440px">&nbsp;&nbsp;
					      <input  type="radio" name="cmsArticle.isPass" value="1" />已经审核
					      <input  type="radio" name="cmsArticle.isPass" value="0" />未审核
					      <input  type="radio" name="cmsArticle.isPass" value="2" />不通过 
				      </td>
				    </tr>--%>
			    </table>
				<div class="editButton"  data-options="region:'south',border:false" >
				    <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
				</div>
		  </div>
</html>