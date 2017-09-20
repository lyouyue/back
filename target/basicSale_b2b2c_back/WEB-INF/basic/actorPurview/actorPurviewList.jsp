<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <title>选择权限</title>
  <base target="_self"></base>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <jsp:include page="../../util/import.jsp"/>
  <link rel="styleSheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/dtree/css/dtree.css"/>
  <script type="text/javascript" charset="UTF-8" src="${fileUrlConfig.sysFileVisitRoot_back}3thParty/dtree/js/dtree_actorPurview.js"></script>
  <script type="text/javascript" charset="UTF-8" language="javascript">
    //保存相关的模块权限以及对应的功能权限
    function save(){
         var options = {  
               url : "${pageContext.request.contextPath}/back/actorPurview/saveActorPurview.action",  
               type : "post",  
               dataType:"json",
               success : function(data) {
              	 msgShow("系统提示", "<p class='tipInfo'>权限分配成功！</p>", "info");
          	     window.close(); 
               }
         };  
         $("#form1").ajaxSubmit(options);  
	}
    
    //弹出功能权限的页面，操作后并返回相关操作结果
    function openFunctions(purviewId){
    	var actorId="<s:property value='actorId'/>";
    	selecFunction(purviewId,actorId);
    }
    
    //操作权限节点的选中变化
    function selectParentNode(purviewId,pId,isLeaf){
        var selectedFlag=$("#pu_"+purviewId).attr("checked");
        if(selectedFlag=="checked"){//如果当前节点选中，将父节点选中
        	$("#pu_"+pId).attr("checked","true");//上一级
        	//以下是选中上二级
        	var p_class=$("#pu_"+pId).attr("class");
        	if(p_class!=null&&p_class!=undefined)var p_class_values=p_class.split("_");
        	var p_pid=p_class_values[1];//上二级的权限id
        	$("#pu_"+p_pid).attr("checked","true");
        }else{//如果当前节点没有选中，将所有子节点不选中
        	$(".pid_"+purviewId).attr("checked",false);//下一级
        	var objs=$(".pid_"+purviewId);
        	for(var i=0;i<objs.length;i++){//下二级
        		var obj=objs[i];
        		$(".pid_"+obj.value).attr("checked",false);
        	}
        }
    }
  </script>
  </head>
  <body>
    <jsp:include page="../../util/item.jsp"/>
    <div class="main">
	    <div class="treeCommonMain">
	    	<div class="treeCommonBox"  style="margin:5px 0px 5px 10px;">
			  	<form action="" method="post" name="form1" id="form1">
			  		<input type="hidden" id="actorId" name="actorId" value="<s:property value="actorId"/>" noclear="true"/>
			  		<input id="purviewIds" type="hidden" name="purviewIds" />
			  		<!-- 初始化模块权限下已选的功能权限放在对应的隐藏域中 -->
			  		<div id="setFunctions"></div>
				 	<div class="dtree">
						<script type="text/javascript">
							var actorId=$("#actorId").val();
							var hiddenInputStr="";
							d = new dTree("d");	
							$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/actorPurview/getPurviewListByActorId.action",
								   async: false,
								   data: {actorId:actorId},
								   success: function(data){
									   var purviewList=data.purviewList;
									   var actorPurviewList=data.actorPurviewList;
									   for(var i=0;i<purviewList.length;i++){
										   var purview=purviewList[i];
										   d.add(purview.purviewId,purview.parentId,purview.purviewName,'');
										   var  flag=0;
										   for(var j=0;j<actorPurviewList.length;j++){
											   var actorPurview=actorPurviewList[j];
											   if(purview.purviewId==actorPurview.purviewId&&purview.isLeaf==1){//设置1表示已经找到之前已有的模块权限对应的功能权限并设置到隐藏域中 
												   flag=1;
												   hiddenInputStr+="<input name='functionValues' type='hidden' value='"+actorPurview.functions+"' id='purviewValues_"+purview.purviewId+"'/>";
											   }
										   }
										   if(flag==0){//设置0表示之前没有选择的模块权限，同时只创建对应的隐藏域
											   hiddenInputStr+="<input name='functionValues' type='hidden' value='' id='purviewValues_"+purview.purviewId+"'/>";
										   }
									   }
									   $("#setFunctions").html(hiddenInputStr);
									   document.write(d);
									    
									   //初始化菜单权限和功能权限的展示信息
									   for(var i=0;i<actorPurviewList.length;i++){
										   var actorPurview=actorPurviewList[i];
										   $("#pu_"+actorPurview.purviewId).attr("checked","true");
										   if(actorPurview.purviewId!=1){
								    	    	if(actorPurview.functions!=""){
												   var functions=actorPurview.functions;
								    	    	   var funcValues=functions.split(",");
								    	    	   var functionNames="&nbsp;&nbsp;已选功能权限：";//组装已选的功能权限的名称
								    		       for(var j=0;j<funcValues.length;j++){//对原始的字符串进行解析
								    		    		funcValue=funcValues[j];
								    		    		funcs=funcValue.split("_");
								    		    		functionNames+=funcs[1]+",";
								    		       }
									    	       $("#purview_"+actorPurview.purviewId).html(functionNames.substring(0,functionNames.length-1));
								    	    	}
										   }
									   }
								   }
							});
						</script>
						<div class="editButton" style="width:100px;">
					    	<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="save();" href="javascript:;">保存</a>
					    	<a id="btnSave" class="easyui-linkbutton" icon="icon-back" onclick="history.go(-1);" href="javascript:;">返回角色列表</a>
					    </div>
					</div>
				</form>
			</div>
		</div>
		
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
			<!-- 选择功能权限-->
			<jsp:include page="showFunctionsList.jsp"/>
		</div>
	</div>
  </body>
</html>
