<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div id="editWin" style="width:680px;">
	<form id="form2" method="post">
		<input id="id" type="hidden" name="dayRecommend.id" >
		<input id="productId" type="hidden" name="dayRecommend.productId" >
		<table align="center" class="addOrEditTable">
			<tr>
				<td class="toright_td" width="150px">商品图片</td>
				<td class="toleft_td"><span id="logoImg"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">商品名称:</td>
				<td class="toleft_td"><span id="productName"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">商品编号:</td>
				<td class="toleft_td" width="530px;"><span id="productCode"></span></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">排序:</td>
				<td class="toleft_td">
					<input type="text" id="sort" style="width:110px;" maxlength="4" name="dayRecommend.sort" value="" class="{validate:{number:true}}"/>
				</td>
			</tr>
			<tr>
				<td class="toright_td" width="150px">是否显示:</td>
				<td class="toleft_td">
					<input  type="radio" id="isShow_0"  name="dayRecommend.isShow" value="0"/>不显示 &nbsp;&nbsp;
					<input  type="radio" id="isShow_1"  name="dayRecommend.isShow" value="1"/>显示
				</td>
			</tr>
			</table>
			<div class="editButton"  data-options="region:'south',border:false" >
		    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form2').submit()" href="javascript:;">保存</a>
		    	<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	    	</div>
	</form>
</div>
