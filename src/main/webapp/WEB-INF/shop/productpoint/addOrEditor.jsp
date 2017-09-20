<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<div id="addOrEditWin" style="width:780px;height:500px;overflow-y:scroll;">
	<form id="form1" action="post">
		<table align="center" class="addOrEditTable">
			<tr>
		      <td class="toright_td" width="100px;">过期日期：</td>
		      <td class="toleft_td" height="10px;">&nbsp;&nbsp;
			        <input style="margin-top: 5px;" id="endTime" type="text" name="endTime" class="easyui-validatebox" required="true" missingMessage="日期必须填写" readonly >
			      	<img onClick="WdatePicker({el:'endTime',dateFmt:'yyyy-MM-dd'})" src="${pageContext.request.contextPath}/DatePicker/skin/datePicker.gif" width="15px" height="20px" align="middle" />
		      </td>
		    </tr>
			<tr>
				<td class="toright_td" width="100px;">套餐信息：</td>
				<td class="toleft_td" height="10px;">
					<div style="margin:10px 10px 0px 10px">
						套餐名称：<input type="text" name="productName" id="productName"/>
					 &nbsp;&nbsp;<span ><a href="javascript:getProductInfoList();" id="btn1" iconCls="icon-search" >查询</a></span>
					</div>
					<div style="margin:0px 10px 10px 10px;">
         				<table id="subTalbe" class="addOrEditTable" width="600px"></table>
   		 			</div>
				</td>
			</tr>
			</table>
			<div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
				<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
				<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
			</div>
	</form>
	<form id="form2"  method="post" style="display:none">
		<input type="hidden" name="productPoint.productPointId" id="dproductPointId"/>
		<input type="hidden" name="productPoint.endTime" id="dendTime"/>
		<input type="hidden" name="productPoint.proName" id="dproName"/>
		<input type="hidden" name="productPoint.productId" id="dproductId"/>
	    <table align="center" class="addOrEditTable" >
	        <tr>
		      <td class="toright_td" width="150px" >过期日期:</td>
		      <td class="toleft_td"  height="35px" width="150px">&nbsp;&nbsp;<span id="endTimeText"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">套餐名称:</td>
		      <td class="toleft_td"  height="35px" width="150px">&nbsp;&nbsp;<span id="proNameText"></span></td>
		    </tr>
		    <tr>
		      <td class="toright_td" width="150px">金币值:</td>
		      <td class="toleft_td" height="35px" width="150px">&nbsp;&nbsp;&nbsp;<input type="text" name="productPoint.integral" id="dintegral" class="{validate:{required:true,maxlength:[12]}}"/></td>
		    </tr>
	    </table>
	    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
			<input type="submit" id="save" class="button_save"  value=""/>&nbsp;
			<input type="button" id="close" class="button_close" onclick="closeWin()" value=""/>&nbsp;
		</div>
	</form>
</div>
