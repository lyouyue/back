<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>

  <script type="text/javascript">
    var selectedPurviewId="";
    function sure(){
	  	var values="";
	  	$(".functions").each(function(i){
			  if(this.checked){
				  values+=this.value+","; 
			  }
		});
	  	if(values!=""){
	  		var returnString=values.substring(0,values.length-1);
		  	if(returnString==""){
		  		returnString=selectedPurviewId;
		  	}
		  	values=returnString;
	    	var indexValue=values.indexOf("_");
	    	if(indexValue==-1){//返回-1表示返回的字符串中没有“_”,即表示没有功能权限，只是返回了当前的模块权限的Id
	    		purviewId=values;//此时表示values为模块权限的Id
	        	$("#purview_"+purviewId).html("&nbsp;&nbsp;当前已无功能权限！");
	    	    $("#purviewValues_"+purviewId).val("");
	    	}else if(values!=null){
		    	var funcValues=values.split(",");
		    	var funcValue=funcValues[0];
		    	var funcs=funcValue.split("_");
		    	var purviewId=funcs[0];
		    	var functionNames="&nbsp;&nbsp;已选功能权限：";//组装已选的功能权限的名称
		    	for(i=0;i<funcValues.length ;i++){//对原始的字符串进行解析
		    		funcValue=funcValues[i];
		    		funcs=funcValue.split("_");
		    		functionNames+=funcs[1]+",";
		    	}
		    	$("#purview_"+purviewId).html(functionNames.substring(0,functionNames.length-1));
		    	$("#pu_"+purviewId).attr("checked","true");
		    	$("#purviewValues_"+purviewId).val(values);
	    	}
	  	}else{
	  		$("#purviewValues_"+selectedPurviewId).val("");
	  		$("#purview_"+selectedPurviewId).html("");
	  	}
	  	closeWin();
	  	
	}
    
    function selecFunction(purviewId,actorId){
    	$("#selectedFunctionDiv").html("");
    	$.ajax({
		   type: "POST", dataType: "JSON",
		   url: "${pageContext.request.contextPath}/back/actorPurview/getFunctionsListByPurviewId.action",
		   data: {purviewId:purviewId,actorId:actorId},
		   success: function(data){
			   createWindow(700,'auto',"&nbsp;&nbsp;选择功能权限","icon-add",false,"selectedFunctionWin",30,"freshWin");
			   var functionsList=data.functionsList;
			   var functionValues=data.functionValues;
			   var htmlStr="";
			   if(data.totalRecordCount>0){
				   htmlStr+="<table align='center' class='addOrEditTable' width='300px' height='600px'>";
				   htmlStr+="<tr class='titlebg'>";
				   htmlStr+="<td class='toright_td' width='80px'>选择</span></td>";
				   htmlStr+="<td  class='toleft_td'>&nbsp;&nbsp;功能权限名称</td>";
				   htmlStr+="</tr>";
				   for(var i=0;i<functionsList.length;i++){
					   var functions=functionsList[i];
					   htmlStr+="<tr>";
					   htmlStr+="<td align='right' width='50px'>";
					   htmlStr+="<input  id='"+functions.purviewId+"_"+functions.funValue+"' class='functions'  name='functions' type='checkbox' value='"+functions.purviewId+"_"+functions.funName+"_"+functions.funValue+"'/>";
					   htmlStr+="</td>";
					   htmlStr+="<td align='left'>&nbsp;&nbsp;"+functions.funName+"</td>";
					   htmlStr+="</tr>";
				   }
				   htmlStr+="</table>";
				   $("#selectedFunctionDiv").html(htmlStr);
				   //判断是否有选择的功能权限，有的话设置选中
				   if(functionValues!=undefined){
					   selectedPurviewId=functionValues.substring(0,functionValues.indexOf("_"));//获取当前选中的模块权限Id
					   var functionsArray=functionValues.split(",");
					   if(functionsArray.length>0){
							for(var i=0;i<functionsArray.length;i++){
								var functionsString=functionsArray[i];
								var functionsValuesArray=functionsString.split("_");
								$("#"+selectedPurviewId+"_"+functionsValuesArray[2]).attr("checked",true);
							}
						}
				   }
				   $("#sureButton").show();
				   $("#cancelButton").hide();
			   }else{
				   $("#sureButton").hide();
				   $("#cancelButton").show();
			   }
			   
		   }
		});
    }
    
  </script>
  <div id="selectedFunctionWin">
      <div id="selectedFunctionDiv"></div>
	  <div  id="sureButton" stlye="display:none;">
	  	  <div class='editButton'  data-options='region:'south',border:false'>
	      	<a id='btnSave' class='easyui-linkbutton' icon='icon-ok' onclick='sure()' href='javascript:;'>确定</a>
	      	<a id='btnCancel' class='easyui-linkbutton' icon='icon-cancel' onclick='closeWin()' href='javascript:;'>取消</a>
	      </div>
	  </div>
	  <div  id="cancelButton" style="display:none;">
	  	  <div style='margin-top:20px;font-size:14px;color:red;text-align: center;vertical-align: middle;'>此模块下没有对应的功能权限，请先添加功能权限后再选择!</div>
		  <div class='editButton'  data-options='region:'south',border:false'>
		  	<a id='btnCancel' class='easyui-linkbutton' icon='icon-cancel' onclick='closeWin()' href='javascript:;'>取消</a>
		  </div>
	  </div>
  </div>
