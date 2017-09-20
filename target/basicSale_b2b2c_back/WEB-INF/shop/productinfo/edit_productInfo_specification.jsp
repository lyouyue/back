<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
		//提交修改商品规格、价格和库存表单
		function updateProductSpecifications() {
			$(".addDisabled").removeAttr("disabled");
			$("#e_specificationsForm").validate({
				meta: "validate",
				submitHandler: function(form) {
					//控制保存按钮变灰，避免重复提交
					$("#e_btnSavespecifications").removeAttr("onclick");
					var submitFlag=validateUpdateSubmit();
					//表单提交
					if(submitFlag){
						var ropts ={
							url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductSpecification.action",
							type : "post",
							dataType:"json",
							success : function(data) {
								if(data.isSuccess){
									msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
									$("#tt").datagrid("reload");
									//删除选择规格部分
									$("#e_specificationSelect").empty();
									//删除添加规格表表头部分
									$("#e_specificationProductTable-title").empty();
									//删除添加规格表的每一行
									$(".e_selectedSpecificationValuesTD").remove();
									var productId = $("#e_productId_specifications").val();
									$.ajax({
										type: "POST",dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/productinfo/getProductInfoByProductId.action",
										data:{productId:productId},
										async:false,
										success: function(data){
											if(data!=null){
												//初始化规格
												initSpecification(data.specificationList,data.productInfo.goods,data.productInfo.productId);
											}
										}
									});
									//closeWin();
								}else{
									msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
								}
								$("#e_btnSavespecifications").attr("onclick","javascript:updateProductSpecifications();");
							}
						};
						$("#e_specificationsForm").ajaxSubmit(ropts);
					}else{
						$("#e_btnSavespecifications").attr("onclick","javascript:updateProductSpecifications();");
					}
				}
			});
			$("#e_specificationsForm").submit();
		}
		function validateUpdateSubmit(){
			//是否有重复
			var isRepeats = true;
			var specifications = new Array();
			var speciArray = new Array();
			//判断添加的规格值是否有重复的
			$("#e_specificationProductTable").find("tr:gt(0)").each(function(i) {//找到添加规格行
				var specificationValues = $(this).find("select").serialize();//找到当前行的所有规格值组下拉框，并把当前的规格值组序列化
				if(specificationValues!=""){
					var inputparam = $(this).find("input").serialize();//找到当前行的所有文本框，并序列化
					var count=specificationValues.split("&").length;
					var tmp=specificationValues.substring(0,specificationValues.indexOf("specification"));
					//替换所有的指定字符串为空“127-277-”
					//即将127-277-specification_2=4&127-277-specification_86=503&127-277-specification_87=506转化成
					//specification_2=4&specification_86=503&specification_87=506
					if(tmp!=""){
						var specificationValuesReplaced=specificationValues;
						specificationValuesReplaced=specificationValuesReplaced.replace(eval("/"+tmp+"/g"),'');
					}else{
						specificationValuesReplaced=specificationValues;
					}
					if ($.inArray(specificationValuesReplaced, speciArray)>=0) {//判断当前行的规格值是否存在之前的数组中
						msgShow("系统提示", "<p class='tipInfo'>商品规格重复！</p>", "warning");  
						isRepeats = false;
						$(".addDisabled").attr("disabled","disabled");
						return false;
					} else {
						speciArray.push(specificationValuesReplaced);//存放到规格的数组中，下次对比使用
						specifications.push(specificationValues +"@"+ inputparam);//保存使用的数组
					}
				}
			});
			/* 1137-2803-specification_90=270&1137-2803-specification_91=275
			@productId=2803&marketPrice=44&salesPrice=22&storeNumber=2,
			1137-2802-specification_90=270&1137-2802-specification_91=274
			@productId=2802&marketPrice=33&storeNumber=2,
			specification_90=270&specification_91=276@
			productId=0&marketPrice=22&salesPrice=11&storeNumber=1 */
			if (isRepeats) {
				isRepeats = changePrice(isRepeats);//校验价格不为空 且销售价不大于市场价
				if(isRepeats){
					$("#e_specifications").val(specifications);
					return true;
				}else{
					$(".addDisabled").attr("disabled","disabled");
					return false;
				}
			}else{
				$(".addDisabled").attr("disabled","disabled");
				 return false;
			}
			return true;
		}
		
		//新增的规格tr计数器，便于动态生成存放规格的tr
		var e_count_specificationValues_id_index=0;
		//存放当前分类下的所有规格，用于动态控制不同规格以及对应的规格值的展示
		var specificationArray=new Array();
		//初始化规格
		function initSpecification(specificationList,goods,productId) {
			var specificationHtmlStr="";
			if(specificationList!=null){
				for(var i=0;i<specificationList.length;i++){
					var specificationId=specificationList[i].specificationId;
					specificationArray.push(specificationId);
					var name=specificationList[i].name;
					var notes=specificationList[i].notes;
					var specification_param=specificationId+"_"+name+"_"+notes;
					specificationHtmlStr+="<div style='float:left;margin:5px 10px;'>";
					specificationHtmlStr+="<span style='display:block;'>";
					specificationHtmlStr+="<input disabled='disabled' onclick='changeSelectedSpecification("+specificationId+")' id='e_"+specificationId+"' class='check' name='specificationIds' type='checkbox' value='"+specification_param+"'/>";
					specificationHtmlStr+="&nbsp;<label for='e_"+specificationId+"'>"+name;
					specificationHtmlStr+="[&nbsp;"+notes+"&nbsp;]</label></span></div>";
				}
			}
			$("#e_specificationSelect").html(specificationHtmlStr);
			if(specificationHtmlStr!=""){
				initSelectedSpecificationValue(goods,productId);
			}
			//是否锁定复选框
			initLockCheckBox();
		}

		//初始化显示规格对应的规格值
		function initSelectedSpecificationValue(goods,productId){
			var specificationIdArray =new Array();
			$("#e_specificationSelect input:checked").each(function(i){
				var specificationValueStringArray=this.value.split("_");
				var specificationId=specificationValueStringArray[0];
				specificationIdArray.push(specificationId);
			});
			var selectedSpecificationValuesHtmlStr="";
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/productinfo/getGoodsProductSpecificationValue.action",
				async:false,
				data: {goods:goods,productId:productId},
				success: function(data){
					if(data!=null){
						var productInfoList = data.productInfoList;
						var data = data.psvGroupList;
						for(i=0;i<data[0].length;i++){
							var productSpecificationValueObj=data[0][i];
							var selectedSpecificationId=productSpecificationValueObj.specificationId;
							document.getElementById("e_"+selectedSpecificationId).checked=true;
						}
						var specificationProductHtmlStr="";
						$("#e_specificationProductTable-title").css("display","");
						var isOwnChecked=false;
						$("#e_specificationSelect input:checked").each(function(i){
							isOwnChecked=true;
							var specificationValueStringArray=this.value.split("_");
							var specificationId=specificationValueStringArray[0];
							var name=specificationValueStringArray[1];
							var notes=specificationValueStringArray[2];
							specificationProductHtmlStr+="<th style='text-align:center;padding:5px 10px;width:15%' id='specification_"+specificationId+"'>";
							specificationProductHtmlStr+="<span  style='margin:6px; display:inline;  white-space:nowrap;'>"+name+"</span>";
							specificationProductHtmlStr+="<span  style=''>[&nbsp;"+notes+"&nbsp;]</span></th>";
						});
						specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;市场价格</th>";
						specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;销售价格</th>";
						specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;商品库存</th>";
						specificationProductHtmlStr+="<th style='text-align:center;width:8%'>&nbsp;上/下架状态</th>";
						specificationProductHtmlStr+="<th style='text-align:center;'>操作</th>";
						$("#e_specificationProductTable-title").html(specificationProductHtmlStr);
						for(i=0;i<data.length;i++){
							var selectedSpecificationValuesHtmlStr="";
							e_count_specificationValues_id_index=i;
							var old_productId="";
							var priceAndStoreHtml="";
							for(j=0;j<data[i].length;j++){
								var productSpecificationValueObj=data[i][j];
								var goodId=productSpecificationValueObj.goodId;
								var productId=productSpecificationValueObj.productId;
								var specificationValueId=productSpecificationValueObj.specificationValueId;
								var specificationId=productSpecificationValueObj.specificationId;
									$.ajax({
										type: "POST",
										dataType: "JSON",
										url: "${pageContext.request.contextPath}/back/productinfo/getSpecificationValueBySpecificationId.action",
										async:false,
										data: {specificationId: specificationId},
										success: function(data){
											if(data!=null){
												var ssv_obj=$("#e_selectedSpecificationValues_"+e_count_specificationValues_id_index);
												if(ssv_obj.attr("id")==null){
													var ssvTrHtml="<tr class='e_selectedSpecificationValuesTD' id='e_selectedSpecificationValues_"+e_count_specificationValues_id_index+"'></tr>";//动态创建多组tr
													$("#e_specificationProductTable").append(ssvTrHtml);
												}
												specificationValueList=data;
												selectedSpecificationValuesHtmlStr+="<td class='e_specificationValue_"+specificationId+"'  style='text-align:center;'>";
												for(var k=0;k<productInfoList.length;k++){
													if(productInfoList[k]!=null&&productInfoList[k].productId==productId){
														//上下架显示 1下架 2上架
														if(k>0&&productInfoList[k].isPutSale==2){
															selectedSpecificationValuesHtmlStr+="<select disabled=disabled id='"+e_count_specificationValues_id_index+"_"+specificationId+"' class='e_disable_"+specificationId+" e_sort_"+specificationId+" addDisabled' name='"+goodId+"-"+productId+"-specification_"+specificationId+"'>";
														}else{
															selectedSpecificationValuesHtmlStr+="<select id='"+e_count_specificationValues_id_index+"_"+specificationId+"' class='e_disable_"+specificationId+" e_sort_"+specificationId+"' name='"+goodId+"-"+productId+"-specification_"+specificationId+"'>";
														}
													}
												}
												
												for(var i=0;i<specificationValueList.length;i++){
												var specificationValue=specificationValueList[i];
												if(specificationValueId==specificationValue.specificationValueId){
													selectedSpecificationValuesHtmlStr+="<option selected value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
												}else{
													selectedSpecificationValuesHtmlStr+="<option value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
												}
											}
											selectedSpecificationValuesHtmlStr+="</select></td>";
										}
									}
								});
								for(var k=0;k<productInfoList.length;k++){
									if(productInfoList[k]!=null&&productId!=old_productId&&productInfoList[k].productId==productId){
										priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_productId_"+e_count_specificationValues_id_index+"' type='hidden'  name='productIdParam' value='"+productInfoList[k].productId+"' />";
										priceAndStoreHtml+="<input id='e_marketPric_"+e_count_specificationValues_id_index+"' type='text'  name='marketPrice' value='"+productInfoList[k].marketPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										/* if(k>0){
											//上下架显示 1下架 2上架
											if(productInfoList[k].isPutSale==2){
												priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input disabled='disabled' id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
											}else{
												priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
											}
										}else{
											priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										} */
										priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+productInfoList[k].salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_storeNumber_"+e_count_specificationValues_id_index+"' type='text' name='storeNumber' value='"+productInfoList[k].storeNumber+"' class='{validate:{required:true,number:true,maxlength:[8]}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
										if(productInfoList[k].isPutSale==2){
											priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><font color='RED'>上架</font></td>";
										}else{
											priceAndStoreHtml+="<td class='e_delete_text' style='width:200px;text-align: center;'><font color='GREEN'>下架</font></td>";
										}
									}
								}
								old_productId = productId; 
							}
							selectedSpecificationValuesHtmlStr+=priceAndStoreHtml;
							if(i>0){
								selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='padding-left:10px; width:120px; white-space:nowrap;text-align: center;'><a href='javascript:removeSpecification("+productId+","+e_count_specificationValues_id_index+");' >[&nbsp;解除组关联&nbsp;]</a></td>";
							}else{
								selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='padding-left:10px; width:120px; white-space:nowrap;'></td>";
							}
							$("#e_selectedSpecificationValues_"+e_count_specificationValues_id_index).html(selectedSpecificationValuesHtmlStr);
						}
					}
				}
			});
		}
		//操作复选框显示选中的规格以及对应的规格值
		function changeSelectedSpecification(specificationId){
			var isChecked=$("#e_"+specificationId).attr("checked");
			if(isChecked!="checked"){
				$(".e_specificationValue_"+specificationId).hide();
				$(".e_disable_"+specificationId).attr("disabled",true);
			}else{
				var objsArray=$(".e_specificationValue_"+specificationId);
				if(objsArray!=null&&objsArray.length==0){
					var opSpecificationId=0;
					for(i=0;i<specificationArray.length;i++){
						if(specificationArray[i]==specificationId){
							if(i==0){
								opSpecificationId=specificationArray[i+1];
							}else{
								opSpecificationId=specificationArray[i-1];
							}
							break;
						}
					}
					var selectedSpecificationValuesHtmlStr=changeSelectedSpecificationValue(specificationId);
					$(".e_specificationValue_"+opSpecificationId).each(function(i){
						$(this).after(selectedSpecificationValuesHtmlStr);
					});
				}else{
					$(".e_specificationValue_"+specificationId).show();
					$(".e_disable_"+specificationId).attr("disabled",false);
				}
			}
			var check_objs=$("#e_specificationSelect input:checked");
			//if(check_objs.length<3){
				var selectedSpecificationValuesHtmlStr="";
				var specificationProductHtmlStr="";
				$("#e_specificationProductTable-title").css("display","");
				$("#e_specificationSelect input:checked").each(function(i){
					isOwnChecked=true;
					var specificationValueStringArray=this.value.split("_");
					var specificationId=specificationValueStringArray[0];
					var name=specificationValueStringArray[1];
					var notes=specificationValueStringArray[2];
					specificationProductHtmlStr+="<th style='text-align:center;padding:5px 10px;' id='specification_"+specificationId+"'>";
					specificationProductHtmlStr+="<span  style='margin:5px 15px 5px 5px; display:inline;'>"+name+"</span>";
					specificationProductHtmlStr+="<span  style='margin:0px;15px 5px 5px; display:inline;'>[&nbsp;"+notes+"&nbsp;]</span></th>";
					
				});
				specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;市场价格</th>";
				specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;销售价格</th>";
				specificationProductHtmlStr+="<th style='text-align:center;width:15%'><i class='ColorRed'>*</i>&nbsp;商品库存</th>";
				specificationProductHtmlStr+="<th style='text-align:center;width:8%'>&nbsp;上/下架状态</th>";
				specificationProductHtmlStr+="<th style='text-align:center;'>操作</th>";
				$("#e_specificationProductTable-title").html(specificationProductHtmlStr);
				if(check_objs.length==0){
					$(".e_delete_text").hide();
				}else{
					$(".e_delete_text").show();
				}
			//}else if(check_objs.length>2){
				//$("#"+specificationId).attr("checked",false);
				//$.messager.alert("提醒", "最多选择两个规格!");
			//}
		}
		//显示规格对应的规格值
		function changeSelectedSpecificationValue(specificationId){
			var selectedSpecificationValuesHtmlStr="";
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "${pageContext.request.contextPath}/back/productinfo/getSpecificationValueBySpecificationId.action",
				async:false,
				data: {specificationId: specificationId},
				success: function(data){
					specificationValueList=data;
					selectedSpecificationValuesHtmlStr+="<td style='text-align:center;' class='e_specificationValue_"+specificationId+"'>";
					selectedSpecificationValuesHtmlStr+="&nbsp;&nbsp;<select class='e_disable_"+specificationId+" e_sort_"+specificationId+"' name='specification_"+specificationId+"' style='margin-left:-6px;'>";
					for(var i=0;i<specificationValueList.length;i++){
						var specificationValue=specificationValueList[i];
						selectedSpecificationValuesHtmlStr+="<option value='"+specificationValue.specificationValueId+"'>"+specificationValue.name+"</option>";
					}
					selectedSpecificationValuesHtmlStr+="</select></td>";
				}
			});
			return selectedSpecificationValuesHtmlStr;
		}
		//添加规格值
		function addNewSpecificationValueUpdate(){
			var marketPrice=$("#e_marketPrice").val();
			var salesPrice=$("#e_salesPrice").val();
			var storeNumber=$("#e_storeNumber").val();
			var check_objs=$("#e_specificationSelect input:checked");
			if(check_objs!=null&&check_objs.length>0){
				e_count_specificationValues_id_index++;
				var newTrHtmlStr="<tr class='e_selectedSpecificationValuesTD' id='e_selectedSpecificationValues_"+e_count_specificationValues_id_index+"'>";
				var selectedSpecificationValuesHtmlStr="";
				var isOwnChecked=false;
				$("#e_specificationSelect input:checked").each(function(i){
					isOwnChecked=true;
					var specificationValueStringArray=this.value.split("_");
					var specificationId=specificationValueStringArray[0];
					var name=specificationValueStringArray[1];
					var notes=specificationValueStringArray[2];
					selectedSpecificationValuesHtmlStr+=changeSelectedSpecificationValue(specificationId);
				});
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_productId_"+e_count_specificationValues_id_index+"' type='hidden'  name='productIdParam' value='0' />";
				selectedSpecificationValuesHtmlStr+="<input id='e_marketPric_"+e_count_specificationValues_id_index+"' type='text'  name='marketPrice' value='"+marketPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_salesPric_"+e_count_specificationValues_id_index+"' type='text' name='salesPrice' value='"+salesPrice+"' class='{validate:{required:true,number:true}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><input id='e_storeNumber_"+e_count_specificationValues_id_index+"' type='text' name='storeNumber' value='"+storeNumber+"' class='{validate:{required:true,number:true,maxlength:[8]}} product_input' maxlength='9' style='width: 50px !important;'/></td>";
				selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='width:200px;text-align: center;'><font color='GREEN'>下架</font></td>";
				if(isOwnChecked){
					selectedSpecificationValuesHtmlStr+="<td class='e_delete_text' style='padding-left:10px; width:120px; white-space:nowrap;text-align: center;'><a class='opt_links' href='javascript:deleteSpecificationUpdate("+e_count_specificationValues_id_index+");'>删除</a></td>";
				}
				newTrHtmlStr+=selectedSpecificationValuesHtmlStr+"</tr>";
				$("#e_specificationProductTable").append(newTrHtmlStr);
				editLockCheckBox();//锁住复选框
			}else{
				msgShow("系统提示", "<p class='tipInfo'>至少选择一个规格！</p>", "warning");  
			}
		}
		// 删除规格商品
		function deleteSpecificationUpdate(specificationValues_id_index){
			$("#e_selectedSpecificationValues_"+specificationValues_id_index).remove();
			if($("#e_specificationProductTable tr").length==1){
				unEditLockCheckBox();
			}
		}
		// 异步解除当前商品所在组的规格以及规格值的关联关系
		function removeSpecification(productId,e_count_specificationValues_id_index){
			$.messager.confirm("系统提示", "<p class='tipInfo'>商品规格组解除后将无法恢复！</p>",function(data){
				var optionProductId = $("#e_productId").val();
				if(data){
					$.ajax({
						type: "POST",
						dataType: "JSON",
						url: "${pageContext.request.contextPath}/back/productinfo/removeProductSpecificationValueGoodsGuanlian.action",
						data: {productId: productId,optionProductId:optionProductId},
						success: function(data){
							if(data.isSuccess){
								$("#e_selectedSpecificationValues_"+e_count_specificationValues_id_index).remove();
							}
						}
					});
				}
				return true;
			});
		}
		function editLockCheckBox(){
			$("#e_specificationSelect input").each(function(i){
				$(this).attr("disabled","disabled");
			});
		}
		function initLockCheckBox(){
			if($("#e_specificationProductTable tr").length==1){
				unEditLockCheckBox();
			}
		}
		function unEditLockCheckBox(){
			$("#e_specificationSelect input").each(function(i){
				$(this).removeAttr("disabled");
			});
		}
	</script>
	<form action="" method="post" id="e_specificationsForm">
		<input type="hidden" id="e_productId_specifications" name="productId"/>
		<input id="e_specifications" type="hidden" name="specifications" value=""/>
		<!-- 添加规格-->
		<div style="margin-bottom:7px;">
			<span>
				<input type="button" class="yl_button" value="添加规格" onclick="addNewSpecificationValueUpdate()" style="margin-top:10px;margin-left: 14px;"/>
			</span>
		</div>
		<!-- 当前分类下的规格 begin-->
		<div id="e_specificationSelect"></div>
		<!-- 当前分类下的规格 end -->
		<!-- 规格值 begin-->
		<div style="height:auto; overflow-x:auto; overflow-y:hidden;  ">
			<table id="e_specificationProductTable" style="margin:15px; width:97%; height:auto;">
				<!--选定规格值名称 -->
				<tr id="e_specificationProductTable-title" class="titlebg"></tr>
				<!--选定规格值-->
				<tr id="e_selectedSpecificationValues_0" class="e_selectedSpecificationValuesTD"></tr>
			</table>
		</div>
		<!-- 规格值 end -->
		<div style="padding:10px 0;">
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="e_btnSavespecifications" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductSpecifications();" href="javascript:;">保存</a>
				<a id="e_btnCancelspecifications" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
