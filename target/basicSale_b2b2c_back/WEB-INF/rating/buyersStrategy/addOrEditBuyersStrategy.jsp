<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	//查询级别是否存在
	function checkBuyersLevel(){
		var value = $("#buyersLevel").val();
		if(value != ""){
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/back/buyersStrategy/checkBuyersLevel.action",
				data:{buyersLevel:value},
				success:function(data){
					if(data == "ok"){
						$("#buyerRank_1").html("<em style='color:green'>&nbsp;&nbsp;未添加!</em>");
						$("#save").css("display","");
					}else{
						$("#buyerRank_1").html("<em style='color:red'>&nbsp;&nbsp;已存在!</em>");
						$("#loginName").focus();
						$("#save").css("display","none");
					}
				}
			});
		}else{
			$("#buyerRank_1").html("");
		}
	}
</script>
  <div id="addOrEditWin">
  		<!--//right-->
		<!-- 异步上传图片 -->
  		<form id="photoForm1" method="post" enctype="multipart/form-data">
			<table align="center" class="addOrEditTable" width="600px;">
				<tr>
					<td class="toright_td" width="125px"><span style="color:red">* </span>等级图标:&nbsp;&nbsp; </td>
					<td class="toleft_td" width="391px">
						&nbsp;&nbsp;<input id="fileId1" type="file"  name="imagePath"/>
							<span id="mymessage1"></span>
						<input id="buttonId1" type="button" value="上传预览" onclick="uploadPhoto('image_customer','75px','15px','1')"/>
							<%-- <span><font id="tishi" color="red"></font><font color="red">提示：请上传100x100像素的图像</font></span> --%>
						<div class="imgMessage">提示：请上传规格为宽72像素，高15像素的图片！</div>
					</td>
					<td class="toright_td" width="125px">图标预览:&nbsp;&nbsp;</td>
		      			<td  class="toleft_td"><div id="photo1" ></div></td>
				</tr> 
			</table>
		</form>
		<form id="form1"  method="post" action="">
			<input id="buyersLevelId" type="hidden" name="buyersStrategy.buyersLevelId" value="" noclear="true"/>
			<input id="imageUrl1" type="hidden" name="buyersStrategy.levelIcon" value=""/>
			<input id="buyerRank" type="hidden" name="buyersStrategy.buyerRank"/>
			<table align="center" class="addOrEditTable" width="600px;">
			<tr id="BLevel_1">
				<td class="toright_td" width="125px"><span style="color:red">* </span>会员等级:&nbsp;&nbsp;</td>
				<td  class="toleft_td" width="255px">&nbsp;&nbsp;
					<select id="buyersLevel" name="buyersLevel"  class="{validate:{required:true}}">
						<s:iterator value="#application.keybook['buyersStrategyLevel']" var="kb">
							<option onclick="checkBuyersLevel();" id="opt_<s:property value="#kb.value"/>" value="<s:property value="#kb.value"/>"><s:property value="#kb.name"/></option>
						</s:iterator>
					</select>
					<script type="text/javascript">
						$("#buyersLevel").change(function(){
							$("#buyerRank").val($("#opt_"+$(this).val()).text());
						});
					</script>
				</td>
				<td class="toright_td" width="125px"><span style="color:red">* </span>等级折扣值(%):&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="levelDiscountValue" type="text" name="buyersStrategy.levelDiscountValue" class="{validate:{required:true,number:true,maxlength:[2]}}"/>
				</td>
			</tr>
			<%-- <tr>
				<td class="toright_td" width="125px"><span style="color:red">* </span>会员头衔:&nbsp;&nbsp;</td>
				<td  class="toleft_td">&nbsp;&nbsp;
					<input id="buyerRank" type="text" name="buyersStrategy.buyerRank" readonly="readonly" class="{validate:{required:true}}"/>
					<span id="buyerRank_1"></span>
				</td>
				<td class="toright_td" width="125px">会员类型:&nbsp;&nbsp;</td>
				<td  class="toleft_td" width="255px">&nbsp;
					<input id="type_1"  type="radio" name="buyersStrategy.type" value="1" checked="checked">会员</input>&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="type_2"  type="radio" name="buyersStrategy.type" value="2">商家</input>
				</td>
			</tr> --%>
			<tr id="zxck">
				<td class="toright_td" width="125px"><span style="color:red">* </span>最小参考值（元）:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="minRefValue" type="text" name="buyersStrategy.minRefValue" class="{validate:{required:true,money:true,maxlength:[8]}}"/>
				</td>
				<td class="toright_td" width="125px"><span style="color:red">* </span>最大参考值（元）:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="maxRefValue" type="text" name="buyersStrategy.maxRefValue" class="{validate:{required:true,money:true,maxlength:[8]}}"/>
				</td>
			</tr>
			<%-- <tr id="sxed">
				<td class="toright_td" width="125px"><span style="color:red">* </span>授信额度（元）:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="lineOfCredit" type="text" name="buyersStrategy.lineOfCredit" class="{validate:{required:true,money:true,maxlength:[10]}}"/>
				</td>
				<td class="toright_td" width="125px"><span style="color:red">* </span>授信期限(天):&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;
					<input id="creditDate" type="text" name="buyersStrategy.creditDate" class="{validate:{required:true,number:true,maxlength:[3]}}"/>
				</td>
    		</tr> --%>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
  </div>
