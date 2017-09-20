<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
   <form id="form1"  method="post" action="">
      <input id="settlementIdHid" type="hidden" value="" noclear="true"/>
	  <div id="checkWin" style="display: none;">
		    <table align="center" class="addOrEditTable" width="600px;">
			    <tr>
			      <td class="toright_td" width="150px">状态:&nbsp;&nbsp;</td>
			      <td  class="toleft_td" width="440px">&nbsp;&nbsp;
			      		<input id="status_1"  type="radio" name="check" value="1"/>待审核
			      		<input id="status_2"  type="radio" name="check" value="2"/>审核通过
			      		<input id="status_3"  type="radio" name="check" value="3"/>审核未通过
			      
			      </td>
			    </tr>
		    </table>
		   <div class="editButton"  data-options="region:'south',border:false" >
				<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="tijiao(0)" href="javascript:;">保存</a>
				<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		   </div>
	  </div>
	  <div id="paymentInfoWin" style="display: none;">
		  <div style="margin-left: 5%;margin-right: 5%; width: 90%;">
			  <h3>支付信息:</h3>
			  <textarea id="paymentInfo" rows="5" cols="" style="width: 85%; margin-top: 0px;" ></textarea><span id="paymentInfoError"></span>
			  <br/><span style="font: 12px;azimuth: left;">如：对方收款账号，交易号，金额，时间等</span>
		  </div>
		  <div class="editButton"  data-options="region:'south',border:false" >
			  <a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="tijiao(1)" href="javascript:;">保存</a>
			  <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		  </div>
	  </div>
  </form>
  <!-- 查看备注信息 -->
  <div id="paymentInfoWin2" style="display: none;">
	  <div style="margin-left: 5%;margin-right: 5%; width: 90%;">
		  <h3>结算信息:</h3>
		  <textarea id="paymentInfo2" rows="5" cols="" style="width: 85%; margin-top: 0px;" disabled="disabled" ></textarea>
	  </div>
	  <div class="editButton"  data-options="region:'south',border:false" >
		  <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
	  </div>
  </div>
