<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.validate.CardIdNo.js"></script>
	<script type="text/javascript">
		//提交
    	function submitForm(){
			var province=$("#province").val();
			var city=$("#cities").val();
			var district=$("#district").val();
			if(district==null||district==""){
				msgShow("系统提示", "<p class='tipInfo'>请选择区县！</p>", "warning");  
			}else{
				var responsibleAreas=province+","+city+","+district;
				$("#responsibleAreas").val(responsibleAreas);
				$("#form1").submit();
				$("#cityCourierId").val(null);
			}
    	}
    	function chengeArea(id,level){
			$.ajax({
	  			url:"${pageContext.request.contextPath}/back/cityCourier/findCityList.action",
	  			type:"post",
	  			dataType:"json",
	  			data:{id:id},
	  			success:function(data){
	  				if(data!=""){
	  					var areaList=data;
	  					var htmlOption="<option value=''>--请选择--</option>";
 						for(var i=0;i<areaList.length;i++){
 							htmlOption+="<option  value='" + areaList[i].areaId+"'>" + areaList[i].name+ "</option>";
 						}
	  					if(level==1){
	  						$("#cities").html(htmlOption);
	  					}if(level==2){
	  						$("#district").html(htmlOption);
	  					}
	  				}
	  				var firstArea=$("#province").val();
					if(firstArea==null||firstArea==""){
						$("#cities").html("<option value=''>--请选择--</option>");
						$("#district").html("<option value=''>--请选择--</option>");
					}
					var secondArea=$("#cities").val();
					if(secondArea==null||secondArea==""){
						$("#district").html("<option value=''>--请选择--</option>");
					}
	  			}
	 			});
		}
    </script>
	<div id="addOrEditWin">
	   <form id="form1"  method="post" action="">
	   	 <input type="hidden" id="cityCourierId" name="cityCourier.cityCourierId" >
	   	 <input type="hidden" id="responsibleAreas" name="cityCourier.responsibleAreas" >
	  	 <table align="center" class="addOrEditTable">
	  		<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>姓名(账号):&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="cityCourierName" type="text" name="cityCourier.cityCourierName" class="{validate:{required:true,maxlength:[20]}}" />
		      </td>
		    </tr>
	  		<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>责任区域:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;
		      	<select id="province" onchange="chengeArea(this.value,'1')" class="{validate:{required:true}}" style="text-align: left;width: 100px;">
	             <option value="">省</option>
				  <s:iterator value="provinceList" var="first">
					<option  value="<s:property value="#first.areaId"/>"><s:property value="#first.name"/></option>
					</s:iterator>
	           	</select>
	           	<select id="cities" onchange="chengeArea(this.value,'2')" class="{validate:{required:true}}" style="text-align: left;width: 100px;">
		             <option value="">地级市</option>
	           	</select>
	           	<select id="district" class="{validate:{required:true}}" style="text-align: left;width: 100px;">
		             <option value="">区(县)</option>
	           	</select>
		      </td>
		    </tr>
	  		<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>联系电话:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="phone" type="text" name="cityCourier.phone" class="{validate:{required:true,maxlength:[20],mobile:true}}" />
		      </td>
		    </tr>
	  		<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>联系地址:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="address" type="text" name="cityCourier.address" class="{validate:{required:true,maxlength:[100]}}" />
		      </td>
		    </tr>
	  		<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>身份证号:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="cardIdNo" type="text" name="cityCourier.cardIdNo" class="{validate:{required:true,maxlength:[20],IDCard:true}}" />
		      </td>
		    </tr>
	  		<tr>
		      <td class="toright_td" width="150px"><span style="color:red">*</span>入职时间:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;
		      <!-- <input id="entryTime" name="cityCourier.entryTime" style="width: 135px;height:14px;" class="{validate:{required:true}} Wdate" type="text" onFocus="WdatePicker()"/> -->
		      <input  type="text" name="cityCourier.entryTime" id="entryTime" style="width: 135px;height:14px;" onclick="WdatePicker({el:'entryTime',dateFmt:'yyyy-MM-dd'})" class="{validate:{required:true}} Wdate"/>&nbsp;
		      <label class="error" for="entryTime" generated="true"></label>
		      </td>
		    </tr>
	  		<tr>
		      <td class="toright_td" width="150px">介绍人:&nbsp;&nbsp;</td>
		      <td class="toleft_td" width="400px">&nbsp;&nbsp;<input id="introducer" type="text" name="cityCourier.introducer" class="{validate:{maxlength:[20]}}" />
		      </td>
		    </tr>
	   	 </table>
   		 <div class="editButton"  data-options="region:'south',border:false" >
              <a id="btnSubmit" class="easyui-linkbutton" icon="icon-save" href="javascript:submitForm()">保存</a> 
              <a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:closeWin()">取消</a>
          </div>
		</form>
	 </div>
