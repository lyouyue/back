<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
		//提交修改套餐图片表单
		function updateProductSourceImg(){
			var isSubmit = true;
			if(isSubmit){
				//判断标题是否为空
				$(".listProductImage_title").each(function(i) {
					if(!($(this).val()!=null&&$(this).val()!='')){
						msgShow("系统提示", "<p class='tipInfo'>图片，标题必填！</p>", "warning");  
						isSubmit = false;
						return false;
					}
				});
			}
			if(isSubmit){
				//判断排序是否为空
				$(".listProductImage_orders").each(function(i) {
					if(!($(this).val()!=null&&$(this).val()!='')){
						msgShow("系统提示", "<p class='tipInfo'>图片，排序必填！</p>", "warning");  
						isSubmit = false;
						return false;
					}
				});
			}
			if(isSubmit){
				//判断排序是否为空
				$(".source").each(function(i) {
					if(!($(this).val()!=null&&$(this).val()!='')){
						msgShow("系统提示", "<p class='tipInfo'>图片，图片必须上传！</p>", "warning");  
						isSubmit = false;
						return false;
					}
				});
			}
			if(isSubmit){
				//控制保存按钮变灰，避免重复提交
				$("#e_btnSaveProductSourceImg").removeAttr("onclick");
				var ropts ={
					url : "${pageContext.request.contextPath}/back/productinfo/updateFrontProductSourceImg.action",
					type : "post",
					dataType:"json",
					success : function(data) {
						if(data.isSuccess){
							var productImgIdList = data.productImgIdList;
							$(".productImg").each(function(i) {
								$(this).val(productImgIdList[i]);
							});
							msgShow("提醒", "<p class='tipInfo'>修改成功！</p>", "warning");
							$("#tt").datagrid("reload");
						}else{
							msgShow("提醒", "<p class='tipInfo'>修改失败！</p>", "warning");
						}
						$("#e_btnSaveProductSourceImg").attr("onclick","javascript:updateProductSourceImg();");
					}
				};
				$("#productSourceImgForm").ajaxSubmit(ropts);
			}else{
				$("#e_btnSaveProductSourceImg").attr("onclick","javascript:updateProductSourceImg();");
			}
		}
		//初始化图片
		function initProductImg(productImgList){
			var $e_productImageTable = $("#e_productImageTable");
			var trHtml = "";
			if(productImgList!=null){
				for(var i=0;i<productImgList.length;i++){
					var Index=i;
					trHtml += "<tr class='e_imgs' id='e_img_"+ Index +"'> '+'<input class='source' type='hidden' name='listProductImage["+Index+"].source' id='e_source"+Index+"' value='"+productImgList[i].source+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].productId' id='e_productId"+Index+"' value='"+productImgList[i].productId+"'/>";
					trHtml+= "<input type='hidden' class='productImg' name='listProductImage["+Index+"].productImageId' id='e_productImageId"+Index+"' value='"+productImgList[i].productImageId+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].large' id='e_large"+Index+"' value='"+productImgList[i].large+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].medium' id='e_medium"+Index+"' value='"+productImgList[i].medium+"'/>";
					trHtml+= "<input type='hidden' name='listProductImage["+Index+"].thumbnail' id='e_thumbnail"+Index+"' value='"+productImgList[i].thumbnail+"'/>";
					//图片上传开始
					trHtml+= "<td style='text-align: center;'>";
					trHtml+= "<form id='e_photoForm_"+ Index +"' method='post' enctype='multipart/form-data'>";
					trHtml+= "<table align='center' class='addOrEditTable' width='740px' style='margin-top: 0;'>";
					trHtml+= "<tr>";
					trHtml+= "<td style='text-align: center;'>&nbsp;&nbsp;";
					trHtml+= "<span id='e_photo_"+ Index +"'><img id='e_photoImg_"+ Index +"' style='width:40px;height:40px;margin-left:-8px;margin-bottom:-8px;' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' src='${fileUrlConfig.uploadFileVisitRoot}"+productImgList[i].source+"'/></span>";
					trHtml+= "</td>";
					trHtml+= "<td  style='text-align: center;padding:7px 7px;' >";
					trHtml+= "<span id='e_mymessag"+ Index +"'></span>";
					trHtml+= "<input id='e_fileId_"+ Index +"' type='file' name='imagePath' style='width:145px;float:left;margin-top:5px;'/>";
					trHtml+= "<input id='e_buttonId_"+ Index +"' style='float:left;margin-top:3px;' type='button' value='上传预览' onclick='uploadProPhotoUpdate("+ Index +")'/>";
					trHtml+= "</td>";
					trHtml+= "</tr>"; 
					trHtml+= "</table>";
					trHtml+= "</form>";
					trHtml+= "</td>";
					//图片上传结束
					trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].title' value='"+productImgList[i].title+"' class='listProductImage_title product_input' maxlength='150' style='width:210px;'/> </td> ";
					trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].orders' value='"+productImgList[i].orders+"' class='listProductImage_orders product_input' maxlength='9' style='width: 50px !important;'/> </td>";
					trHtml+= "<td style='text-align: center;'> <a  href='javascript:;' class='opt_links deletopt' onclick='javascript:deleteProductImageUpdate("+Index+","+productImgList[i].productImageId+");'>删除</a> </td> </tr>";
				}
			}
			$e_productImageTable.append(trHtml);
		}
		//增加套餐图片
		function addProductImageHtmlUpdate(){
			var $e_productImageTable = $("#e_productImageTable");
			var Index = $(".e_imgs").length;
			var trHtml = "<tr class='e_imgs' id='e_img_"+ Index +"'> '+'<input class='source' type='hidden' name='listProductImage["+Index+"].source' id='e_source"+Index+"' value=''/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].productId' id='e_productId"+Index+"' value=''/>";
			trHtml+= "<input type='hidden' class='productImg' name='listProductImage["+Index+"].productImageId' id='e_productImageId"+Index+"' value=''/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].large' id='e_large"+Index+"' value='"+Index+"'/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].medium' id='e_medium"+Index+"' value='"+Index+"'/>";
			trHtml+= "<input type='hidden' name='listProductImage["+Index+"].thumbnail' id='e_thumbnail"+Index+"' value='"+Index+"'/>";
			//图片上传开始
			trHtml+= "<td style='text-align: center;'>";
			trHtml+= "<form id='e_photoForm_"+ Index +"' method='post' enctype='multipart/form-data'>";
			trHtml+= "<table align='center' class='addOrEditTable' width='740px' style='margin-top: 0;'>";
			trHtml+= "<tr>";
			trHtml+= "<td style='text-align: center;'>&nbsp;&nbsp;";
			trHtml+= "<span id='e_photo_"+ Index +"'><img id='e_photoImg_"+ Index +"' style='width:40px;height:40px;margin-left:-8px;margin-bottom:-8px;' src='${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png'/></span>";
			trHtml+= "</td>";
			trHtml+= "<td  style='text-align: center;padding:7px 7px;' >";
			trHtml+= "<span id='e_mymessag"+ Index +"'></span>";
			trHtml+= "<input id='e_fileId_"+ Index +"' type='file' name='imagePath' style='width:145px;float:left;margin-top:5px;'/>";
			trHtml+= "<input id='e_buttonId_"+ Index +"' style='float:left;margin-top:3px;' type='button' value='上传预览' onclick='uploadProPhotoUpdate("+ Index +")'/>";
			trHtml+= "</td>";
			trHtml+= "</tr>"; 
			trHtml+= "</table>";
			trHtml+= "</form>";
			trHtml+= "</td>";
			//图片上传结束
			
			trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].title' class='listProductImage_title product_input' maxlength='150' style='width:210px;'/> </td> ";
			trHtml+= "<td style='text-align: center;'> <input type='text' name='listProductImage["+Index+"].orders' class='listProductImage_orders product_input' maxlength='9' style='width: 50px !important;' value='"+getMaxSortNum('listProductImage_orders')+"'/> </td>";
			trHtml+= "<td style='text-align: center;'> <a  href='javascript:;' class='opt_links deletopt' onclick='javascript:deleteProductImageUpdate("+Index+",0);'>删除</a> </td> </tr>";
			$e_productImageTable.append(trHtml);
		}
		//上传图片
		function uploadProPhotoUpdate(imageIndex) {
			//添加上传提示信息，控制按钮不可用
				addFormPhotoMessageUpdate(imageIndex);
				$(document).ready( function() {
					var options = {
						//url : "${pageContext.request.contextPath}/back/upload/asyncUploadImage.action?imageInfoPath="+imageInfoPath,
						url : "${pageContext.request.contextPath}/back/productinfo/uploadImageFront.action?is_ajax=2",
						type : "post",
						dataType : "json",
						async:false,
						success : function(data) {
							//清空上传提示信息，恢复按钮可用
							clearFormPhotoMessageUpdate(imageIndex);
							if(data.photoUrl=="false"){
								msgShow("系统提示", "<p class='tipInfo'>文件扩展名不是PNG或JPG！</p>", "warning");  
							}else if(data.photoUrl=="false2"){
								msgShow("系统提示", "<p class='tipInfo'>请选择图片后再上传！</p>", "warning");  
							}else{
								var productImg = data.photoUrl;
								$("#e_photoImg_"+imageIndex).attr('src',data.uploadFileVisitRoot+productImg.source);
								$("#e_photoImg_"+imageIndex).attr('alt',data.uploadFileVisitRoot+productImg.source);
								$("#e_source"+imageIndex).val(productImg.source);
								$("#e_large"+imageIndex).val(productImg.large);
								$("#e_medium"+imageIndex).val(productImg.medium);
								$("#e_thumbnail"+imageIndex).val(productImg.thumbnail);
							}
						}
					};
					$("#e_photoForm_"+imageIndex).ajaxSubmit(options);
				});
		}
		//添加上传提示信息，控制按钮不可用
		function addFormPhotoMessageUpdate(imageIndex){
			$("#e_mymessag"+imageIndex).html("<font style='color:green'>文件提交中......</font>");//修改提示信息
			$("#e_buttonId_"+imageIndex).attr("disabled","true");//提交按钮不可用
		}
		
		//清空上传提示信息，恢复按钮可用
		function clearFormPhotoMessageUpdate(imageIndex){
			$("#e_mymessag"+imageIndex).html("");//清空提示信息
			$("#e_buttonId_"+imageIndex).removeAttr("disabled");//提交按钮恢复可用
		}
		// 删除套餐图片
		function deleteProductImageUpdate(value,productImageId){
			if(productImageId!=0&&productImageId!=null){
				$.messager.confirm("系统提示", "<p class='tipInfo'>套餐图片删除后将无法恢复！</p>",function(data){
					if(data){
							$.ajax({
								type: "POST",
								dataType: "JSON",
								url: "${pageContext.request.contextPath}/back/productinfo/deleteProductImg.action",
								data: {productImageId: productImageId},
								success: function(data){
									if(data.flag){
										$("#e_img_"+value).remove();
										msgShow("系统提示", "<p class='tipInfo'>删除图片成功！</p>", "warning");  
									}else{
										msgShow("系统提示", "<p class='tipInfo'>删除图片失败！</p>", "warning");  
									}
								}
							});
					}
					return true;
				});
			}else{
				$("#e_img_"+value).remove();
			}
		}
	</script>
	<form id="productSourceImgForm" action="" method="post" enctype="multipart/form-data">
		<input type="hidden" id="e_productId_sourceImg" name="productId"/>
		<input id="e_addProductImage" class="yl_button" type="button" value="添加滚动图片" onclick="javascript:addProductImageHtmlUpdate();" style="margin-top:10px;margin-left: 12px;"/>
		&nbsp;&nbsp;<span><font color="RED">提示：请上传800*800像素的图片！</font></span>
		<table id="e_productImageTable" style="margin: 11px;"  class="table_list" >
			<tr>
				<td width="28%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">图片上传预览</font></td>
				<td width="30%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">标题</font></td>
				<td width="22%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">排序</font></td>
				<td width="20%" style="text-align: center;"><font style="font-size: 12px;font-weight: bold;">操作</font></td>
			</tr>
		</table>
		<div style="padding:10px 0;">
			<div class="editButton"  data-options="region:'south',border:false" >
				<a id="e_btnSaveProductSourceImg" class="easyui-linkbutton" icon="icon-save" onclick="javascript:updateProductSourceImg();" href="javascript:;">保存</a>
				<a id="e_btnCancelSourceImg" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
			</div>
		</div>
	</form>
