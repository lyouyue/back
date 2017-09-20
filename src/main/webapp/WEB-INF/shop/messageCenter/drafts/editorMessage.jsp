<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml" >
<script type="text/javascript">
$(function(){
	$("input[name='messageCenter.toMemberId']").bind('click',function(){
		if(this.value=="all"){
			$("#toMemberId").attr("disabled","disabled").css("color","gray");
		}
		if(this.value==""){
			$("#toMemberId").removeAttr("disabled").css("color","black");
		}
	});
	$("#toMemberId").bind({ 
		focus:function(){ 
			if (this.value == this.defaultValue){ 
				$(this).css("color","black");
				this.value=""; 
			}
		}, 
		blur:function(){ 
			if (this.value == ""){ 
				$(this).css("color","gray");
				this.value = this.defaultValue; 
			} 
		} 
	}); 
});
</script>
 <div id="addOrEditWin">
		    <form id="form1"  method="post" action="">
		        <input id="messageId" type="hidden" name="messageCenter.messageId" >
		        <input id="fromMemberId" type="hidden" name="messageCenter.fromMemberId" >
		        <input id="fromMemberName" type="hidden" name="messageCenter.fromMemberName" >
		        <input id="toMemberName" type="hidden" name="messageCenter.toMemberName" >
		        <input id="messageOpen" type="hidden" name="messageCenter.messageOpen" >
		        <input id="messageState" type="hidden" name="messageCenter.messageState" >
		        <input id="messageType" type="hidden" name="messageCenter.messageType" >
		        <input id="messageIsMore" type="hidden" name="messageCenter.messageIsMore" >
		        <input id="ip" type="hidden"  name="messageCenter.ip"/>
			    <table align="center" class="addOrEditTable" width="700px;">
			    	<tr>
				      <td class="toright_td" width="140px">发送对象:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="400px">&nbsp;&nbsp;
						  <input id="toMemberId1"  type="radio" name="messageCenter.toMemberId" value="all" checked="checked"/>发送给所有会员
					      <input id="toMemberId2"  type="radio" name="messageCenter.toMemberId" value="" />发送给指定会员<br/>
					      &nbsp;&nbsp;<input id='toMemberId' style='width:390px;' disabled='disabled' value='可同时给5个人发私信，会员名之间请用逗号隔开'></input>				      
					  </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="140px">标题:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="400px">&nbsp;&nbsp;<input id="messageTitle" type="text" name="messageCenter.messageTitle" class="{validate:{required:true,maxlength:[50]}}" style="width: 390px;"/></td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="140px">内容:&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="400px">&nbsp;&nbsp;<textarea id="content"  style="width:390px;height:200px;" name="messageCenter.content" class="{validate:{required:true,maxlength:[250]}}"></textarea>
				      </td>
				    </tr>
				    <tr>
				      <td class="toright_td" width="140px">是否立即发送 :&nbsp;&nbsp;</td>
				      <td  class="toleft_td"  width="400px">&nbsp;&nbsp;
					      <input   type="radio" name="messageCenter.messageSendState" value="1" checked="checked"/>立即发送
				      </td>
				    </tr>
			    </table>
			    <div style="text-align:center;padding:5px 0;">
					<input type="submit" id="save"  class="button_save" value=""/>&nbsp;
					<input type="button" id="close" class="button_close" onclick="closeWin()"/>&nbsp;
				</div>
			</form>
		  </div>
</html>