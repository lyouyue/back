<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
  <div id="detailWin">
		        <input id="view_articleId" type="hidden" name="cmsArticle.articleId" />
			    <table align="center" class="addOrEditTable" width="700px">
			         <tr>
				      <td class="toright_td" width="150px">图片预览 :</td>
				      <td  class="toleft_td">
				          <span id="d_photo"></span>
				      </td>
				    </tr>
				    
				    <tr>
				      <td class="toright_td" width="150px">主题 :</td>
				      <td  class="toleft_td">
				         <span id="d_title"></span>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="150px">简介:</td>
				      <td class="toleft_td" >
				         <span id="d_synopsis"></span>
			          </td>
			      	</tr>
				    <tr>
				      <td class="toright_td" width="150px">链接:</td>
				      <td class="toleft_td" >
				         <span id="d_interlinkage"></span>
			          </td>
			      	</tr>
				    <tr>
				      <td class="toright_td" width="150px">排序:</td>
				      <td class="toleft_td" >
				         <span id="d_sortCode"></span>
			          </td>
			      	</tr>
				    <tr>
				      <td class="toright_td" width="150px">是否显示:</td>
				      <td class="toleft_td" >
				         <span id="d_isShow"></span>
			          </td>
			      	</tr>
			    </table>
				<div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">关闭</a>
				</div>
		  </div>
