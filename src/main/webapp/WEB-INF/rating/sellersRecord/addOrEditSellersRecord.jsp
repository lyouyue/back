<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
  <div id="addOrEditWin">
		<form id="form1"  method="post" action="">
			<input id="ratingRecordId" type="hidden" name="sellersRecord.ratingRecordId" value="" noclear="true"/>
			<input id="customerId" type="hidden" name="sellersRecord.customerId" value="${customerId}" noclear="true"/>
				<table align="center" class="addOrEditTable" width="750px;">
					<tr>
		      			<td class="toright_td" width="50px">操作人:</td>
		      			<td  class="toleft_td"><span style="color:green;font-weight:bolder">${sessionScope.users.userName}</span></td>
		    		</tr>
					<tr>
						<td class="toright_td" width="70px">等级策略:</td>
		     				<td class="toleft_td" width="300px" >
		     					<table >
		     						<tr>
		     							<th></th><th>卖家等级</th><th>卖家头衔</th><th>等级折扣值(%) </th><th>等级图标</th>
		     							<th>最小参考值</th><th>最大参考值</th>
		     						</tr>
		     							<s:iterator value="listSellersStrategy" var="lb" status="s">
		     						<tr>
		     							<td>
		     								<input  type="radio" id="level_<s:property value='#lb.sellersLevel'/>" name="sellersLevel" <s:if test="#s.index==0">checked="checked"</s:if> value="<s:property value='#lb.sellersLevel'/>">
		     							</td>
		     							<td><s:property value='#lb.sellersLevel' /></td>
		     							<td><s:property value='#lb.sellersRank' /></td>
		     							<td><s:property value='#lb.levelDiscountValue' /></td>
		     							<td><div><img src='<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/><s:property value='#lb.levelIcon' />' width='60px' height='50px' /></div></td>
		     							<td><s:property value='#lb.minRefValue' /></td>
		     							<td><s:property value='#lb.maxRefValue' /></td>
		     						</tr>
		     							</s:iterator>
		     					</table>
		     				</td>
		    		</tr>
		    		<tr>
				      <td class="toright_td" width="50px">备注:</td>
				      <td class="toleft_td">
				      	<textarea id="remark" rows="3" cols="40" style="width:200px;height:200px;visibility:hidden;" name="sellersRecord.remark" class="{validate:{required:true,maxlength:[250]}}"></textarea>
				      	<script type="text/javascript">
						       		var editor;
									KindEditor.ready(function(K){
									editor = K.create("#remark",{
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
			   <div class="editButton"  data-options="region:'south',border:false" >
					<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			   </div>
	  </form>
  </div>
