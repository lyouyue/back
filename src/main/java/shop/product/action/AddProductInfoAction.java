package shop.product.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import shop.product.pojo.ParamGroup;
import shop.product.pojo.ParamGroupInfo;
import shop.product.pojo.ProductAttr;
import shop.product.pojo.ProductAttrIndex;
import shop.product.pojo.ProductImg;
import shop.product.pojo.ProductInfo;
import shop.product.service.IAddProductInfoService;
import shop.product.service.IProductAttrIndexService;
import shop.product.service.IProductImgService;
import shop.store.service.IShopInfoService;
import shop.store.service.IShopProCateClassService;
import shop.store.service.IShopProCategoryService;
import shop.tags.service.IShopProductTradeSituationTagService;
import util.action.BaseAction;
import util.other.Utils;
import util.upload.ImageFileUploadUtil;
/**
 * FrontAddProductInfoAction - 前台卖家中心套餐添加修改查询ction
 */
public class AddProductInfoAction extends BaseAction{
	private static final long serialVersionUID = 260940050385308630L;
	Logger logger = Logger.getLogger(this.getClass());
	/**套餐Service**/
	@SuppressWarnings("unused")
	private IShopInfoService shopInfoService;
	/**前台套餐Service**/
	private IAddProductInfoService addProductInfoService;
	/**详细内容明细集合**/
	private List<ParamGroupInfo> listParamGroupInfo = new ArrayList<ParamGroupInfo>();
	/**详细参数内容集合**/
	private List<ParamGroup> listParamGroup;
	/**套餐其他页面的图片上传**/
	private List<File> otherUploadImgs;
	private List<String>  otherUploadImgsFileName;
	/**详情页面图片**/
	private List<File> listProductUploadImgs;
	/**详情页面图片名称**/
	private List<String>  listProductUploadImgsFileName;
	/**套餐详情的图片**/
	private List<ProductImg> listProductImage = new ArrayList<ProductImg>();
	/**套餐信息表**/
	private ProductInfo productInfo;
	/**套餐信息表**/
	private ProductAttrIndex productAttrIndex;
	/**保存的套餐的属性**/
	private List<ProductAttr> listProdAttr = new ArrayList<ProductAttr>();
	private String parameters;//得到规格
	/**店铺内部套餐分类和套餐关系Service**/
	private IShopProCateClassService shopProCateClassService;
	/**店铺内部套餐分类Service**/
	@SuppressWarnings("unused")
	private IShopProCategoryService shopProCategoryService;
	private String shopProCategoryId;//店铺内部分类ID
	private Integer productId;//套餐ID
	/**得到规格**/
	private String specifications;
	private String goods;//套餐分组
	private IProductImgService productImgService;//套餐图片Service
	private String title;//标题
	private String orders;//排序
	private String logoImg;//套餐logo图片
	private List<ProductImg> uproductImgList = new ArrayList<ProductImg>();//原来存储的图片
	private IShopProductTradeSituationTagService shopProductTradeSituationTagService;//套餐关联适用行业与使用场合service
	private IProductAttrIndexService productAttrIndexService;

	// 异步上传文件路径
	private File imagePath;
	// 异步上传文件名称
	private String imagePathFileName;
	/**删除套餐详情图片传递的图片id**/
	private Integer productImageId;
	/**tab标记**/
	private Integer index;
	/*******************************end********************************************/
	/**
	 * 保存或者修改套餐
	 * @throws Exception
	 */
	public void saveOrUpdateFrontProduct() throws Exception{
		String basicShopInfoId = String.valueOf(getFileUrlConfig().get("basicShopInfoId"));
		//套餐图片处理
		if(otherUploadImgs!=null && otherUploadImgs.size()>0){
			String otherImg = ImageFileUploadUtil.uploadImageFile(otherUploadImgs.get(0), otherUploadImgsFileName.get(0), getFileUrlConfig(), "image_product");
			productInfo.setLogoImg(otherImg);
		}
		//套餐参数的处理
		if(listParamGroup!=null && listParamGroup.size()>0){
			for(ParamGroup pg:listParamGroup ){
				List<ParamGroupInfo> listPGI=new ArrayList<ParamGroupInfo>();
				for(ParamGroupInfo pgi:listParamGroupInfo){
					if(pg.getParamGroupId().equals(pgi.getPgiId())){
						listPGI.add(pgi);
					}
				}
				pg.setParamGroupInfo(listPGI);
			}
		}
		//套餐扩展属性处理
		String productAttribute = "";
		for(ProductAttr pa:listProdAttr){
			if(productAttribute==""){
				productAttribute = pa.getValue();
			}else{
				productAttribute = productAttribute+","+ pa.getValue();
			}
		}

		productInfo.setProductAttribute(productAttribute);//套餐属性值的保存
		if(listParamGroup!=null && listParamGroup.size()>0){
			JSONArray jbListPG = JSONArray.fromObject(listParamGroup);//json格式的套餐参数
			productInfo.setProductParametersValue(jbListPG.toString());
		}
		if(listProdAttr!=null && listProdAttr.size()>0){
			JSONArray jbListPA = JSONArray.fromObject(listProdAttr);//json格式的套餐属性
			productInfo.setProductAttributeValue(jbListPA.toString());
		}
		if(productInfo.getIsChargeFreight()==1){//不收取运费
			productInfo.setFreightPrice(new BigDecimal(0));//运费==0.0
		}
		productInfo.setCreateDate(new Date());
		productInfo.setUpdateDate(new Date());
		productInfo.setIsNew(1);//是否为新套餐
		productInfo.setIsTop(0);//是否置顶
		productInfo.setIsHot(0);//是否热销
		productInfo.setIsPutSale(1);//是否上架
		productInfo.setIsRecommend(0);//是否推荐
		productInfo.setTotalSales(0);//销售量
		productInfo.setIsShow(1);//是否显示为显示
		if(Utils.objectIsEmpty(productInfo.getShopInfoId())){//shopInfoId为空，平台基础套餐
			if(Utils.objectIsNotEmpty(basicShopInfoId)){
				productInfo.setShopInfoId(Integer.valueOf(basicShopInfoId));//店铺Id
			}else{
				productInfo.setShopInfoId(-1);//店铺Id
			}
			productInfo.setIsPass(3);//审核状态[0 未通过，1 已通过，2 待申请，3 待审核]：平台套餐默认为：3 待审核
			productInfo.setShopInfoProductType(1);//套餐的店铺类型[1、平台基础套餐；2 、平台店铺套餐]
		}else{//平台店铺套餐
			productInfo.setShopInfoProductType(2);//套餐的店铺类型[1、平台基础套餐；2 、平台店铺套餐]
			productInfo.setIsPass(2);//审核状态[0 未通过，1 已通过，2 待申请，3 待审核]：平台套餐默认为：3 待审核
		}
		//取分组的最大值
		Integer maxGoods = (Integer) addProductInfoService.getMaxDataSQL("select max(goods) from shop_productinfo");
		if(maxGoods==null){
			productInfo.setGoods(1);
		}else{
			productInfo.setGoods(maxGoods+1);
		}
		//获取套餐关联标签jsonArray信息
		String tages = request.getParameter("tages");
		JSONArray jsonArray=null;
		if(tages!=null&&!"".equals(tages)){
			jsonArray=JSONArray.fromObject(tages);
		}
		//套餐属性关系表的处理
		List<ProductAttrIndex> paiList = new ArrayList<ProductAttrIndex>();
		for(ProductAttr pa:listProdAttr){
			ProductAttrIndex pai = new ProductAttrIndex();
			pai.setProductAttrId(Integer.parseInt(pa.getName()));
			pai.setAttrValueId(Integer.parseInt(pa.getValue()));
			paiList.add(pai);
		}
		addProductInfoService.saveOrUpdateListProductInfo(shopProCategoryId,productInfo, parameters,listProductImage,fileUrlConfig,listProductUploadImgs,listProductUploadImgsFileName,jsonArray,paiList);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", true);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();

	}
	//前台修改店铺套餐基本信息
	public void updateFrontProductInfo() throws IOException{
		boolean isSuccess = false;
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			product.setIsPutSale(1);//是否上架
			//判断套餐是不是自营 1自营套餐 2店铺套餐
			if(Utils.objectIsNotEmpty(product)&&Utils.objectIsNotEmpty(product.getShopInfoProductType())&&product.getShopInfoProductType().compareTo(1)==0){
				product.setIsPass(3);//待审核
			}else{
				product.setIsPass(2);//待申请
			}
			/*if(Utils.objectIsNotEmpty(otherUploadImgs)&& otherUploadImgs.size()>0&&Utils.objectIsNotEmpty(otherUploadImgsFileName)){
				//套餐图片处理
				String otherImg = ImageFileUploadUtil.uploadImageFile(otherUploadImgs.get(0), otherUploadImgsFileName.get(0),getFileUrlConfig(), "image_product");
				product.setLogoImg(otherImg);
			}*/
			//把新修改的基本数据复制到原始数据里面
			product.setLogoImg(productInfo.getLogoImg());
			product.setDeliveryAddressProvince(productInfo.getDeliveryAddressProvince());//发货地
			product.setDeliveryAddressCities(productInfo.getDeliveryAddressCities());//发货地
			product.setProductCode(productInfo.getProductCode());//套餐编号
			product.setMarketPrice(productInfo.getMarketPrice());//市场价格
			product.setSalesPrice(productInfo.getSalesPrice());//销售价格
			product.setStoreNumber(productInfo.getStoreNumber());//库存
			product.setWeight(productInfo.getWeight());//套餐重量
			product.setMeasuringUnitName(productInfo.getMeasuringUnitName());//计量单位
			product.setPackingSpecifications(productInfo.getPackingSpecifications());//包装规格
			product.setNote(productInfo.getNote());//套餐备注
			product.setBarCode(productInfo.getBarCode());//条形码
			product.setSeoTitle(productInfo.getSeoTitle());//seo标题
			product.setSeoKeyWord(productInfo.getSeoKeyWord());//seo关键字
			product.setSeoDescription(productInfo.getSeoDescription());//seo描述
			product.setFunctionDesc(productInfo.getFunctionDesc());//功能介绍
			product.setManufacturerModel(productInfo.getManufacturerModel());//制造商型号
			product.setGiveAwayCoinNumber(productInfo.getGiveAwayCoinNumber());//赠送金币
			isSuccess = addProductInfoService.saveOrUpdateProduct(product,Integer.parseInt(shopProCategoryId));
			//套餐属性值处理
			/*String productAttribute = "";
			for(ProductAttr pa:listProdAttr){
				if(productAttribute==""){
					productAttribute = pa.getValue();
				}else{
					productAttribute = productAttribute+","+ pa.getValue();
				}
			}
			product.setProductAttribute(productAttribute);//套餐值的保存*/
			/*//删掉旧有的ProductAttrIndex类
			productAttrIndexService.deleteObjectsByIds("productId", product.getProductId()+"");
			//添加新的ProductAttrIndex类
			for(ProductAttr pa:listProdAttr){
				if(pa != null){
					ProductAttrIndex pai = new ProductAttrIndex();
					pai.setProductAttrId(Integer.parseInt(pa.getName()));
					pai.setAttrValueId(Integer.parseInt(pa.getValue()));
					pai.setProductId(product.getProductId());
					pai.setProductTypeId(product.getProductTypeId());
					productAttrIndexService.saveOrUpdateObject(pai);
				}
			}
			if(listProdAttr!=null && listProdAttr.size()>0){
				JSONArray jbListPA = JSONArray.fromObject(listProdAttr);//json格式的套餐属性
				product.setProductAttributeValue(jbListPA.toString());
			}
			//套餐参数的处理
			if(listParamGroup!=null && listParamGroup.size()>0){
				for(ParamGroup pg:listParamGroup ){
					List<ParamGroupInfo> listPGI=new ArrayList<ParamGroupInfo>();
					for(ParamGroupInfo pgi:listParamGroupInfo){
						if(pg.getParamGroupId().equals(pgi.getPgiId())){
							listPGI.add(pgi);
						}
					}
					pg.setParamGroupInfo(listPGI);
				}
			}
			if(listParamGroup!=null && listParamGroup.size()>0){
				JSONArray jbListPG = JSONArray.fromObject(listParamGroup);//json格式的套餐参数
				product.setProductParametersValue(jbListPG.toString());
			}
			*/
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//前台修改店铺套餐详情
	public void updateFrontProductFunctionDesc() throws IOException{
		boolean isSuccess = false;
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			product.setIsPutSale(1);//是否上架
			//判断套餐是不是自营 1自营套餐 2店铺套餐
			if(Utils.objectIsNotEmpty(product)&&Utils.objectIsNotEmpty(product.getShopInfoProductType())&&product.getShopInfoProductType().compareTo(1)==0){
				product.setIsPass(3);//待审核
			}else{
				product.setIsPass(2);//待申请
			}
			product.setFunctionDesc(productInfo.getFunctionDesc());
			ProductInfo product_new = (ProductInfo) addProductInfoService.saveOrUpdateObject(product);
			if(Utils.objectIsNotEmpty(product_new)&&Utils.objectIsNotEmpty(product_new.getProductId())){
				isSuccess = true;
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//前台修改店铺套餐图片
	public void updateFrontProductSourceImg() throws IOException{
		boolean isSuccess = false;
		List<Integer> productImgIdList = new ArrayList<Integer>();
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			if(Utils.objectIsNotEmpty(product)){
				product.setIsPutSale(1);//是否上架
				//判断套餐是不是自营 1自营套餐 2店铺套餐
				if(Utils.objectIsNotEmpty(product)&&Utils.objectIsNotEmpty(product.getShopInfoProductType())&&product.getShopInfoProductType().compareTo(1)==0){
					product.setIsPass(3);//待审核
				}else{
					product.setIsPass(2);//待申请
				}
				for(ProductImg pi:listProductImage){
					ProductImg productImg = new ProductImg();
					if(Utils.objectIsNotEmpty(pi.getProductImageId())){
						productImg.setProductImageId(pi.getProductImageId());
					}
					productImg.setLarge(pi.getLarge());
					productImg.setMedium(pi.getMedium());
					productImg.setOrders(pi.getOrders());
					productImg.setSource(pi.getSource());
					productImg.setThumbnail(pi.getThumbnail());
					productImg.setTitle(pi.getTitle());
					productImg.setProductId(product.getProductId());
					ProductImg productImgNew = (ProductImg) productImgService.saveOrUpdateObject(productImg);
					if(Utils.objectIsNotEmpty(productImgNew)){
						productImgIdList.add(productImgNew.getProductImageId());
					}
				}
				ProductInfo product_new = (ProductInfo) addProductInfoService.saveOrUpdateObject(product);
				if(Utils.objectIsNotEmpty(product_new)&&Utils.objectIsNotEmpty(product_new.getProductId())){
					isSuccess = true;
				}
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("isSuccess", isSuccess);
		jsonMap.put("productImgIdList", productImgIdList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		
	}
	//前台修改店铺套餐参数
	public void updateFrontProductParameters() throws IOException{
		boolean isSuccess = false;
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			product.setIsPutSale(1);//是否上架
			//判断套餐是不是自营 1自营套餐 2店铺套餐
			if(Utils.objectIsNotEmpty(product)&&Utils.objectIsNotEmpty(product.getShopInfoProductType())&&product.getShopInfoProductType().compareTo(1)==0){
				product.setIsPass(3);//待审核
			}else{
				product.setIsPass(2);//待申请
			}
			//套餐参数的处理
			if(listParamGroup!=null && listParamGroup.size()>0){
				for(ParamGroup pg:listParamGroup ){
					List<ParamGroupInfo> listPGI=new ArrayList<ParamGroupInfo>();
					for(ParamGroupInfo pgi:listParamGroupInfo){
						if(pg.getParamGroupId().equals(pgi.getPgiId())){
							listPGI.add(pgi);
						}
					}
					pg.setParamGroupInfo(listPGI);
				}
			}
			if(listParamGroup!=null && listParamGroup.size()>0){
				JSONArray jbListPG = JSONArray.fromObject(listParamGroup);//json格式的套餐参数
				product.setProductParametersValue(jbListPG.toString());
			}
			ProductInfo product_new = (ProductInfo) addProductInfoService.saveOrUpdateObject(product);
			if(Utils.objectIsNotEmpty(product_new)&&Utils.objectIsNotEmpty(product_new.getProductId())){
				isSuccess = true;
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//前台修改店铺套餐属性值
	public void updateFrontProductAttribute() throws IOException{
		boolean isSuccess = false;
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			//套餐属性值处理
			String productAttribute = "";
			for(ProductAttr pa:listProdAttr){
				if(productAttribute==""){
					productAttribute = pa.getValue();
				}else{
					productAttribute = productAttribute+","+ pa.getValue();
				}
			}
			product.setProductAttribute(productAttribute);//套餐值的保存
			//删掉旧有的ProductAttrIndex类
			productAttrIndexService.deleteObjectsByIds("productId", product.getProductId()+"");
			//添加新的ProductAttrIndex类
			for(ProductAttr pa:listProdAttr){
				if(pa != null){
					ProductAttrIndex pai = new ProductAttrIndex();
					pai.setProductAttrId(Integer.parseInt(pa.getName()));
					pai.setAttrValueId(Integer.parseInt(pa.getValue()));
					pai.setProductId(product.getProductId());
					pai.setProductTypeId(product.getProductTypeId());
					productAttrIndexService.saveOrUpdateObject(pai);
				}
			}
			if(listProdAttr!=null && listProdAttr.size()>0){
				JSONArray jbListPA = JSONArray.fromObject(listProdAttr);//json格式的套餐属性
				product.setProductAttributeValue(jbListPA.toString());
			}
			product.setIsPutSale(1);//是否上架
			//判断套餐是不是自营 1自营套餐 2店铺套餐
			if(Utils.objectIsNotEmpty(product)&&Utils.objectIsNotEmpty(product.getShopInfoProductType())&&product.getShopInfoProductType().compareTo(1)==0){
				product.setIsPass(3);//待审核
			}else{
				product.setIsPass(2);//待申请
			}
			ProductInfo product_new = (ProductInfo) addProductInfoService.saveOrUpdateObject(product);
			if(Utils.objectIsNotEmpty(product_new)&&Utils.objectIsNotEmpty(product_new.getProductId())){
				isSuccess = true;
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//前台修改店铺套餐介绍
	public String updateFrontProductReferral(){
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			if(productInfo!=null){
				product.setFunctionDesc(productInfo.getFunctionDesc());
			}
			//查询出同组的套餐
			List<ProductInfo> productList = addProductInfoService.findObjects(" where o.goods='"+goods+"'");
			//循环更新套餐
			for(ProductInfo p : productList){
				product.setProductId(p.getProductId());
				addProductInfoService.saveOrUpdateObject(product);
			}
		}
		return SUCCESS;
	}
	//前台修改店铺套餐图片
	public String updateFrontProductImg(){
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			if(otherUploadImgs!=null && otherUploadImgs.size()>0){
				//套餐图片处理
				String LogoImg = ImageFileUploadUtil.uploadImageFile(otherUploadImgs.get(0), otherUploadImgsFileName.get(0),getFileUrlConfig(), "image_product");
				product.setLogoImg(LogoImg);
			}
			addProductInfoService.saveOrUpdateProdImg(product, listProductImage);
		}
		return SUCCESS;
	}
	//前台修改店铺套餐参数
	public String updateFrontProductParameter() throws UnsupportedEncodingException{
		if(productId!=null){
			ProductInfo product = (ProductInfo) addProductInfoService.getObjectByParams(" where o.productId="+productId);
			if(listParamGroup!=null && listParamGroup.size()>0){
				JSONArray jbListPG = JSONArray.fromObject(listParamGroup);//json格式的套餐参数
				product.setProductParametersValue(jbListPG.toString());
			}
			//查询出同组的套餐
			List<ProductInfo> productList = addProductInfoService.findObjects(" where o.goods='"+goods+"'");
			//循环更新套餐
			for(ProductInfo p : productList){
				product.setProductId(p.getProductId());
				product.setIsPutSale(1);//是否上架
				//判断套餐是不是自营 1自营套餐 2店铺套餐
				if(Utils.objectIsNotEmpty(product)&&Utils.objectIsNotEmpty(product.getShopInfoProductType())&&product.getShopInfoProductType().compareTo(1)==0){
					product.setIsPass(3);//待审核
				}else{
					product.setIsPass(2);//待申请
				}
				addProductInfoService.saveOrUpdateObject(product);
			}
		}
		return SUCCESS;
	}
	//前台修改店铺套餐规格updateFrontProductSpecification
	public void updateFrontProductSpecification() throws Exception{
		boolean isSuccess = addProductInfoService.updateFrontProductSpecification(specifications,productId);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 异步ajax 图片上传
	 * @throws IOException
	 */
	public void uploadImageFront() throws IOException  {
		try {
			JSONObject jo = new JSONObject();
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out;
			out = response.getWriter();
			ProductImg productImg = new ProductImg();
			if(Utils.objectIsNotEmpty(imagePath)&&Utils.objectIsNotEmpty(imagePathFileName)){
				productImg = addProductInfoService.uploadProductImage(imagePath, imagePathFileName, productImg, getFileUrlConfig());
				if(imagePathFileName.equals(productImg.getSource()) || imagePathFileName.equals("图片上传失败!")){
					jo.accumulate("photoUrl", "false");
				}else{
					jo.accumulate("photoUrl", productImg);
					jo.accumulate("uploadFileVisitRoot", (String) getFileUrlConfig().get("uploadFileVisitRoot"));
				}
			}else{
				jo.accumulate("photoUrl", "false2");
			}
			out.println(jo.toString());
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/***
	 * 异步删除套餐详情图片
	 */
	public void deleteProductImg(){
		try {
			if(productImageId!=null){
				boolean flag = productImgService.deleteObjectByParams("where o.productImageId="+productImageId);
				JSONObject jo = new JSONObject();
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out;
				out = response.getWriter();
				jo.accumulate("flag", flag);
				out.println(jo.toString());
			}
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	public Integer getProductImageId() {
		return productImageId;
	}
	public void setProductImageId(Integer productImageId) {
		this.productImageId = productImageId;
	}
	public List<ParamGroupInfo> getListParamGroupInfo() {
		return listParamGroupInfo;
	}
	public void setListParamGroupInfo(List<ParamGroupInfo> listParamGroupInfo) {
		this.listParamGroupInfo = listParamGroupInfo;
	}
	public List<ParamGroup> getListParamGroup() {
		return listParamGroup;
	}
	public void setListParamGroup(List<ParamGroup> listParamGroup) {
		this.listParamGroup = listParamGroup;
	}
	public List<File> getOtherUploadImgs() {
		return otherUploadImgs;
	}
	public void setOtherUploadImgs(List<File> otherUploadImgs) {
		this.otherUploadImgs = otherUploadImgs;
	}
	public List<String> getOtherUploadImgsFileName() {
		return otherUploadImgsFileName;
	}
	public void setOtherUploadImgsFileName(List<String> otherUploadImgsFileName) {
		this.otherUploadImgsFileName = otherUploadImgsFileName;
	}
	public List<ProductImg> getListProductImage() {
		return listProductImage;
	}
	public void setListProductImage(List<ProductImg> listProductImage) {
		this.listProductImage = listProductImage;
	}
	public ProductInfo getProductInfo() {
		return productInfo;
	}
	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
	}
	public List<ProductAttr> getListProdAttr() {
		return listProdAttr;
	}
	public void setListProdAttr(List<ProductAttr> listProdAttr) {
		this.listProdAttr = listProdAttr;
	}
	public String getParameters() {
		return parameters;
	}
	public void setParameters(String parameters) {
		this.parameters = parameters;
	}
	public List<File> getListProductUploadImgs() {
		return listProductUploadImgs;
	}
	public void setListProductUploadImgs(List<File> listProductUploadImgs) {
		this.listProductUploadImgs = listProductUploadImgs;
	}
	public List<String> getListProductUploadImgsFileName() {
		return listProductUploadImgsFileName;
	}
	public void setListProductUploadImgsFileName(
			List<String> listProductUploadImgsFileName) {
		this.listProductUploadImgsFileName = listProductUploadImgsFileName;
	}
	public void setShopProCateClassService(
			IShopProCateClassService shopProCateClassService) {
		this.shopProCateClassService = shopProCateClassService;
	}
	public void setShopProCategoryService(
			IShopProCategoryService shopProCategoryService) {
		this.shopProCategoryService = shopProCategoryService;
	}
	public String getShopProCategoryId() {
		return shopProCategoryId;
	}
	public void setShopProCategoryId(String shopProCategoryId) {
		this.shopProCategoryId = shopProCategoryId;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public String getGoods() {
		return goods;
	}
	public void setGoods(String goods) {
		this.goods = goods;
	}
	public void setProductImgService(IProductImgService productImgService) {
		this.productImgService = productImgService;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getOrders() {
		return orders;
	}
	public void setOrders(String orders) {
		this.orders = orders;
	}
	public String getLogoImg() {
		return logoImg;
	}
	public void setLogoImg(String logoImg) {
		this.logoImg = logoImg;
	}
	public List<ProductImg> getUproductImgList() {
		return uproductImgList;
	}
	public void setUproductImgList(List<ProductImg> uproductImgList) {
		this.uproductImgList = uproductImgList;
	}
	public File getImagePath() {
		return imagePath;
	}
	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}
	public String getImagePathFileName() {
		return imagePathFileName;
	}
	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}
	public Integer getIndex() {
		return index;
	}
	public void setIndex(Integer index) {
		this.index = index;
	}
	public void setShopProductTradeSituationTagService(
			IShopProductTradeSituationTagService shopProductTradeSituationTagService) {
		this.shopProductTradeSituationTagService = shopProductTradeSituationTagService;
	}
	public ProductAttrIndex getProductAttrIndex() {
		return productAttrIndex;
	}
	public void setProductAttrIndex(ProductAttrIndex productAttrIndex) {
		this.productAttrIndex = productAttrIndex;
	}
	public void setProductAttrIndexService(
			IProductAttrIndexService productAttrIndexService) {
		this.productAttrIndexService = productAttrIndexService;
	}
	public void setAddProductInfoService(
			IAddProductInfoService addProductInfoService) {
		this.addProductInfoService = addProductInfoService;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public String getSpecifications() {
		return specifications;
	}
	public void setSpecifications(String specifications) {
		this.specifications = specifications;
	}
}
