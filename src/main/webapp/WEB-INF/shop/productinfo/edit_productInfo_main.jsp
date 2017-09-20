<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<style type="text/css">
	#editProductWin{color: #595959; background-color:#FFF;font-size:12px !important;height:auto !important; height:100%;}
	#e_specificationSelect{overflow:hidden;}
	#e_totalProdAttr td{width:574px;height:30px;line-height:30px;}
	#e_totalProdAttr th{width:400px;height:30px;line-height:30px;}
</style>
<div id="editProductWin" >
	<div class="product_content">
		<!--right-->
		<div id="product_rightBox" >
			<div class="easyui-tabs" id="editTab">
				<!-- 修改套餐基本信息 -->
				<div title="基本信息" class="addProductByPT setWidth">
					<jsp:include page="edit_productInfo_basic.jsp"/>
				</div>
				<!-- 修改套餐FCK -->
				<div title="详情" class="setWidth">
					<jsp:include page="edit_productInfo_detail.jsp"/>
				</div>
				<!-- 修改套餐属性 -->
				<div title="属性" class="addProductByPT" style="margin: 10px;width: 994px; height: auto;">
					<jsp:include page="edit_productInfo_attribute.jsp"/>
				</div>
				<!-- 修改套餐参数 -->
				<div title="参数" class="addProductByPTProdPara">
					<jsp:include page="edit_productInfo_parameter.jsp"/>
				</div>
				<!-- 修改套餐图片 -->
				<div title="图片" class="addProductByPT" style="height:auto;min-height:410px;">
					<jsp:include page="edit_productInfo_picture.jsp"/>
				</div>
				<!-- 套餐规格 begin-->
				<div title="套餐规格" class="addProductByPT" style="height:auto;min-height:410px;">
					<jsp:include page="edit_productInfo_specification.jsp"/>
				</div>
				<!-- 套餐规格 end -->
			</div>
		</div>
	</div>
</div>
