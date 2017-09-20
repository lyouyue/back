package shop.product.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;

import basic.pojo.Users;
import shop.product.pojo.Brand;
import shop.product.pojo.ParamGroup;
import shop.product.pojo.ParamGroupInfo;
import shop.product.pojo.ProductAttribute;
import shop.product.pojo.ProductImg;
import shop.product.pojo.ProductInfo;
import shop.product.pojo.ProductParameters;
import shop.product.pojo.ProductType;
import shop.product.service.IBrandService;
import shop.product.service.IProductAttributeService;
import shop.product.service.IProductImgService;
import shop.product.service.IProductInfoService;
import shop.product.service.IProductParametersService;
import shop.product.service.IProductTypeService;
import shop.store.pojo.ShopCategory;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopCategoryService;
import shop.store.service.IShopInfoService;
import shop.store.service.IShopProCategoryService;
import shop.tags.service.IShopProductTradeSituationTagService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.QRCode;
import util.other.Utils;
/**
 * 套餐Action
 * 
 *
 */
@SuppressWarnings("serial")
public class ProductInfoAction extends BaseAction {
	private IProductInfoService productInfoService;//套餐Service
	private IBrandService brandService;//品牌Service
	private List<Map> productInfoList;//套餐信息List
	private List<Brand> brandList = new ArrayList<Brand>();//品牌List
	/**套餐类**/
	private ProductInfo productInfo;
	/**店铺Service**/
	private IShopInfoService shopInfoService;
	/**套餐和适合行业标签及使用场合标签关联表Service**/
	private IShopProductTradeSituationTagService shopProductTradeSituationTagService;
	private Integer productId;
	private Integer isShow;
	private String ids;
	private String showplaces;//展示位置
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	/**套餐分类的父Id**/
	private String parentId ;
	/** 套餐分类service**/
	private IProductTypeService productTypeService;
	/**套餐分类的集合**/
	private List<ProductType> prodTypeList = new ArrayList<ProductType>();
	/**选择的分类（子节点）**/
	private Integer productTypeId;
	/**属性service**/
	private IProductAttributeService productAttributeService;
	/**参数service**/
	private IProductParametersService productParametersService;
	/**套餐分类的属性action**/
	private ProductAttributeAction productAttributeAction;
	/**详细参数内容集合**/
	private List<ParamGroup> listParamGroup;
	/**详细内容明细集合**/
	private List<ParamGroupInfo> listParamGroupInfo;
	/**套餐图片对象**/
	@SuppressWarnings("unused")
	private ProductImg productImgObj=new ProductImg();
	/**套餐图片service**/
	@SuppressWarnings("unused")
	private IProductImgService productImgService;
	/**店铺List**/
	private List<ShopInfo> shopInfoList = new ArrayList<ShopInfo>();
	/**套餐分类名称**/
	private String prodTypeNames;
	private String shopInfoProductType;
	private IShopCategoryService shopCategoryService;//店铺分类Service
	private List<ShopCategory> shopCategoryList = null;//店铺分类信息列表
	/**店铺内部套餐分类Service**/
	private IShopProCategoryService shopProCategoryService;

	//跳转到套餐列表页面
	public String gotoProductInfoPage(){
		//得到店铺Lis
		shopInfoList = shopInfoService.findObjects(null);
		//得到品牌Lis
		brandList = brandService.findObjects(null);
		shopCategoryList = shopCategoryService.findObjects("where o.shopCategoryId >1)");
		return SUCCESS;
	}
	/**
	 * 根据分类的父ID查询套餐分类的集合
	 * 做连动的时候使用的
	 * @throws IOException
	 */
	public void findProductType() throws IOException{
		prodTypeList = productTypeService.findObjects("where o.parentId="+parentId);
		JSONArray jo = JSONArray.fromObject(prodTypeList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		//return "toAddPage";
	}
	/**
	 * 查询套餐列表
	 * @author 刘钦楠
	 * @throws IOException
	 */
	public void listProductInfo() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hql = new StringBuffer(" select p.productId as productId,p.logoImg as logoImg,p.passUserName as passUserName,p.productFullName as productFullName,p.sku as sku,p.productCode as productCode,p.salesPrice as salesPrice,p.isPutSale as isPutSale,p.isPass as isPass,p.isRecommend as isRecommend,s.shopName as shopName,p.isShow as isShow,p.marketPrice AS marketPrice,DATE_FORMAT(p.createDate,'%Y-%m-%d %h:%m') as createDate from ProductInfo p,ShopInfo s where p.shopInfoId = s.shopInfoId");
		StringBuffer hql1 = new StringBuffer(" select count(p) from ProductInfo p,ShopInfo s where p.shopInfoId = s.shopInfoId");
		StringBuffer hqlsb = new StringBuffer();
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String sku = request.getParameter("sku");
			String isPutSale = request.getParameter("isPutSale");
			String isPass = request.getParameter("isPass");
			String prodName = request.getParameter("prodName");
			String shopName = request.getParameter("shopName");
			String productTypeId = request.getParameter("productTypeId");
//			String prodType = request.getParameter("prodType");
//			hqlsb.append(" where 1=1");
			if(StringUtils.isNotEmpty(productTypeId)){
				hqlsb.append(" and p.productTypeId ="+productTypeId);
			}
			if(StringUtils.isNotEmpty(sku)){
				sku=sku.trim();
				hqlsb.append(" and p.sku like '%"+sku+"%'");
			}
			if(!"-1".equals(isPutSale)){
				hqlsb.append(" and p.isPutSale ="+isPutSale);
			}
			if(!"-1".equals(isPass)){
				hqlsb.append(" and p.isPass ="+isPass);
			}
//			if(!"-1".equals(prodType)){
//				hqlsb.append(" and o.productTypeId ="+prodType);
//			}
			if(StringUtils.isNotEmpty(prodName)){
				prodName=prodName.trim();
				hqlsb.append(" and p.productName like '%"+prodName+"%'");
			}
			if(shopName!=null&&!"".equals(shopName.trim())){
				shopName=shopName.trim();
				hqlsb.append(" and s.shopName like '%"+shopName+"%'");
			}
		}
		hqlsb.append(" order by p.productId desc");
		hql1.append(hqlsb);
		int totalRecordCount = productInfoService.getCountByHQL(hql1.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		hql.append(hqlsb);
		productInfoList = productInfoService.findListMapPage(hql.toString(), pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", productInfoList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//修改套餐是否显示在列表中
	public void updateShowList() throws IOException {
		if(Utils.objectIsNotEmpty(productId)){
			ProductInfo product = (ProductInfo) productInfoService.getObjectByParams(" where o.productId='"+productId+"'");
			JSONObject jo = new JSONObject();
			if(isShow==1){
				product.setIsShow(1);
				productInfoService.saveOrUpdateObject(product);
			}else if(isShow==0){
				product.setIsShow(0);
				productInfoService.saveOrUpdateObject(product);
			}else{
				jo.accumulate("isSuccess", "false");
			}
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//保存或者修改
	public void saveOrUpdateProductInfo() throws Exception{
		boolean isSuccess = false;
		Users users = (Users) session.getAttribute("users");
		if(null!=productId){
			String isPutSale = request.getParameter("isPutSale");//是否上架
			String isPass = request.getParameter("isPass");//是否审核通过
//			String isTop = request.getParameter("isTop");
			String isRecommend = request.getParameter("isRecommend");//是否推荐
			String auditComment = request.getParameter("auditComment");//审核未通过原因
			String isShow=request.getParameter("isShow");
//			String isNew = request.getParameter("isNew");
//			String isHot = request.getParameter("isHot");
			productInfo = (ProductInfo) productInfoService.getObjectByParams(" where o.productId='"+productId+"'");
			if(productInfo!=null){
				String url = request.getContextPath();
				//String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+url+"/";
				String basePath = String.valueOf(getFileUrlConfig().get("phoneBasePath"));
				String addUrl = basePath+"/phone/gotoProductInfo.action?productId="+productInfo.getProductId();
				String codeUrl = QRCode.createQRPng(addUrl, null, getFileUrlConfig(), "shop" ,"image_product");
				productInfo.setQrCode(codeUrl);//套餐二维码
			}
			productInfo.setIsPutSale(Integer.parseInt(isPutSale));
			if(Integer.parseInt(isPutSale)==2){
				productInfo.setPutSaleDate(new Date());
			}
			productInfo.setIsShow(Integer.parseInt(isShow));
			productInfo.setIsPass(Integer.parseInt(isPass));
			productInfo.setAuditComment(auditComment);//审核备注
//			productInfo.setIsTop(Integer.parseInt(isTop));
			productInfo.setPassUserName(users.getUserName());
			productInfo.setIsRecommend(Integer.parseInt(isRecommend));
//			productInfo.setIsNew(Integer.parseInt(isNew));
//			productInfo.setIsHot(Integer.parseInt(isHot));
			productInfo.setUpdateDate(new Date());
			ProductInfo productInfo_new = (ProductInfo) productInfoService.saveOrUpdateObject(productInfo);
			if(Utils.objectIsNotEmpty(productInfo_new)&&productInfo_new.getProductId()!=null){
				isSuccess = true;
			}
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", isSuccess);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	/**
	 * 根据选择的分类查找属性和参数
	 * @throws IOException
	 */
	public void getAttrAndPara() throws IOException{
		ProductParameters productPara =  (ProductParameters) productParametersService.getObjectByParams("where o.productTypeId="+productTypeId);
		List<ProductAttribute> listProductAttr =  productAttributeService.findObjects("where o.productTypeId="+productTypeId);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("productPara", productPara);
		jsonMap.put("listProductAttr", listProductAttr);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取一条记录
	@SuppressWarnings("unchecked")
	public void getProductInfoObject() throws IOException{
		productInfo = (ProductInfo) productInfoService.getObjectByParams(" where o.productId='"+productId+"'");
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		getProductTypeName(productInfo.getProductTypeId());
		//获取分类end
		SimpleDateFormat formatter = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		String createDate ="";
		if(productInfo.getCreateDate()!=null){
			createDate = formatter.format(productInfo.getCreateDate());
		}
		String putSaleDate ="";
		if(productInfo.getPutSaleDate()!=null){
			putSaleDate = formatter.format(productInfo.getPutSaleDate());
		}
		String updateDate="";
		if(null!=productInfo.getUpdateDate()){
			updateDate = formatter.format(productInfo.getUpdateDate());
		}
		//查询套餐的图片
		List<ProductImg> productImgList = productImgService.findObjects(null, " where o.productId='" + productInfo.getProductId() + "'");
		//截取套餐规格
		String name = productInfo.getProductFullName();
		String specification="";
		if(name.indexOf("[") != -1){
			int indexStart = name.indexOf("[")+1;
			int endIndex =name.indexOf("]");
			specification = name.substring(indexStart,endIndex);
		}
		//获取属性begin
		String sql="select a.name as name, b.attrValueName as attrValueName from ProductAttribute a,AttributeValue b,ProductAttrIndex c where a.productAttrId=c.productAttrId and b.attrValueId = c.attrValueId and c.productId = "+productInfo.getProductId();
		List<Map> attrList = productAttributeService.findListMapByHql(sql);
		//获取属性end
		//获取属性begin
		String proCategory_hql="select b.shopProCategoryName as shopProCategoryName from ShopProCateClass a,ShopProCategory b where a.shopProCategoryId =b.shopProCategoryId and a.productId = "+productInfo.getProductId();
		List<Map> proCategoryList = shopProCategoryService.findListMapByHql(proCategory_hql);
		if(Utils.collectionIsNotEmpty(proCategoryList)){
			jsonMap.put("shopProCategoryName", proCategoryList.get(0).get("shopProCategoryName"));
		}
		//获取属性end

		//获取适用行业与使用场合begin
		/*String sql1="select b.tageName as stName,c.tageName as ttName from ShopProductTradeSituationTag a, ShopSituationTag b,ShopTradeTag c where a.ttId = c.ttId and a.stId = b.stId and b.useState = 1 and c.useState = 1 and a.productId= "+productInfo.getProductId();
		List<Map> tageNameList = shopProductTradeSituationTagService.findListMapByHql(sql1);
		*/
		if(Utils.objectIsNotEmpty(productInfo)&&Utils.objectIsNotEmpty(productInfo.getBrandId())){
			Brand brand = (Brand) brandService.getObjectById(String.valueOf(productInfo.getBrandId()));
			if(Utils.objectIsNotEmpty(brand)){
				jsonMap.put("brandName",brand.getBrandName());
			}
		}
		if(Utils.objectIsNotEmpty(productInfo)&&Utils.objectIsNotEmpty(productInfo.getBrandId())){
			ShopInfo shopInfo = (ShopInfo) shopInfoService.getObjectById(String.valueOf(productInfo.getShopInfoId()));
			if(Utils.objectIsNotEmpty(shopInfo)){
				jsonMap.put("shopName",shopInfo.getShopName());
			}
		}
		//获取适用行业与使用场合end
		jsonMap.put("createDate",createDate );
		jsonMap.put("putSaleDate", putSaleDate);
		jsonMap.put("updateDate", updateDate);
		jsonMap.put("productInfo", productInfo);
		jsonMap.put("productTypeName", prodTypeNames);
		jsonMap.put("specification", specification);
		jsonMap.put("productImgList", productImgList);
		jsonMap.put("attrList", attrList);
		//jsonMap.put("tageNameList", tageNameList);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 获取当前分类名称（无级限）
	 */
	public  void getProductTypeName(Integer prodTypeId){
		//获取当前的对象
		ProductType pt =  (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+prodTypeId);
		if(pt!=null){
			//加上超链接
			String aLabel =pt.getSortName();
			if(StringUtils.isNotEmpty(prodTypeNames)){
				prodTypeNames = aLabel +"&nbsp;&gt;&nbsp;"+prodTypeNames;
			}else{
				prodTypeNames = aLabel;
			}
		}
		//递归
		if(pt!=null && pt.getParentId()!=1){
			getProductTypeName(pt.getParentId());
		}
	}
	//根据id删除产品
	public void deleteProductInfo() throws IOException{
		Boolean isSuccess = productInfoService.deleteObjectsByIds("productId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	//批量生成二维码
	public void productInfoGeneratedQrCode() throws IOException{
		boolean isSuccess=false;
		String failureLog1="";
		String failureLog2="";
		Object phoneBasePath = getFileUrlConfig().get("phoneBasePath");
		if(Utils.objectIsNotEmpty(phoneBasePath)&&Utils.objectIsNotEmpty(shopInfoProductType)){
			String basePath = String.valueOf(phoneBasePath);
			//shopInfoProductType 1、平台基础套餐；2 、平台店铺套餐
			String sql="select productId as productId , productName as productName from shop_productinfo where shopInfoProductType="+shopInfoProductType;
			List<Map<String,Object>> productList=productInfoService.findListMapBySql(sql);
			if(Utils.objectIsNotEmpty(productList)&&productList.size()>0){
				int size=productList.size();
				for(int i=0;i<size;i++){
					if(Utils.objectIsNotEmpty(productList.get(i).get("productId"))){
						String addUrl = basePath+"/phone/gotoProductInfo.action?productId="+productList.get(i).get("productId");
						String codeUrl = QRCode.createQRPng(addUrl, null, fileUrlConfig, "shop" ,"image_product");
						isSuccess=productInfoService.updateBySQL("update shop_productinfo set qrCode='"+codeUrl+"' where productId="+productList.get(i).get("productId"));
						if(!isSuccess){
							if(i==size-1){
								failureLog2+=productList.get(i).get("productName");
							}else{
								failureLog2+=productList.get(i).get("productName")+",";
							}
						}
					}
				}
			}else{
				failureLog1="生成失败！";
			}
		}
		JSONObject jo=new JSONObject();
		jo.accumulate("failureLog1", failureLog1);
		if(Utils.objectIsNotEmpty(failureLog2)){
			jo.accumulate("failureLog2", "套餐名称为："+failureLog2+"的记录生成失败！");
		}else{
			jo.accumulate("failureLog2", failureLog2);
		}
		if(Utils.objectIsEmpty(failureLog1)&&Utils.objectIsEmpty(failureLog2)){
			isSuccess=true;
		}else{
			isSuccess=false;
		}
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter pw=response.getWriter();
		pw.print(jo.toString());
		pw.flush();
		pw.close();
	}
	/**
	 *修改返利比例
	 * @throws Exception
	 */
	public void updateRatio() throws Exception{
		ProductInfo oldproductinfo=null;
		oldproductinfo=(ProductInfo) productInfoService.getObjectByParams(" where o.productId='"+productId+"'");
			if(Utils.objectIsNotEmpty(oldproductinfo)){
				oldproductinfo.setUpRatio(productInfo.getUpRatio());
				oldproductinfo.setSecRatio(productInfo.getSecRatio());
				oldproductinfo.setThiRatio(productInfo.getThiRatio());
				oldproductinfo=(ProductInfo) productInfoService.saveOrUpdateObject(oldproductinfo);
			}
			JSONObject jo = new JSONObject();
			if(Utils.objectIsNotEmpty(oldproductinfo)){
				jo.accumulate("isSuccess", "true");
			}else{
				jo.accumulate("isSuccess", "false");
			}
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
	}

	public List<Map> getProductInfoList() {
		return productInfoList;
	}
	public void setProductInfoList(List<Map> productInfoList) {
		this.productInfoList = productInfoList;
	}
	public List<Brand> getBrandList() {
		return brandList;
	}
	public void setBrandList(List<Brand> brandList) {
		this.brandList = brandList;
	}
	public ProductInfo getProductInfo() {
		return productInfo;
	}
	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
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
	public String getShowplaces() {
		return showplaces;
	}
	public void setShowplaces(String showplaces) {
		this.showplaces = showplaces;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public List<ProductType> getProdTypeList() {
		return prodTypeList;
	}
	public void setProdTypeList(List<ProductType> prodTypeList) {
		this.prodTypeList = prodTypeList;
	}
	public void setProductAttributeService(
			IProductAttributeService productAttributeService) {
		this.productAttributeService = productAttributeService;
	}
	public void setProductParametersService(
			IProductParametersService productParametersService) {
		this.productParametersService = productParametersService;
	}
	public Integer getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(Integer productTypeId) {
		this.productTypeId = productTypeId;
	}
	public void setProductAttributeAction(
			ProductAttributeAction productAttributeAction) {
		this.productAttributeAction = productAttributeAction;
	}
	public List<ParamGroup> getListParamGroup() {
		return listParamGroup;
	}
	public void setListParamGroup(List<ParamGroup> listParamGroup) {
		this.listParamGroup = listParamGroup;
	}
	public List<ParamGroupInfo> getListParamGroupInfo() {
		return listParamGroupInfo;
	}
	public void setListParamGroupInfo(List<ParamGroupInfo> listParamGroupInfo) {
		this.listParamGroupInfo = listParamGroupInfo;
	}
	public void setProductImgService(IProductImgService productImgService) {
		this.productImgService = productImgService;
	}
	public List<ShopInfo> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<ShopInfo> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public void setShopProductTradeSituationTagService(
			IShopProductTradeSituationTagService shopProductTradeSituationTagService) {
		this.shopProductTradeSituationTagService = shopProductTradeSituationTagService;
	}

	public Integer getIsShow() {
		return isShow;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public List<ShopCategory> getShopCategoryList() {
		return shopCategoryList;
	}
	public void setShopCategoryList(List<ShopCategory> shopCategoryList) {
		this.shopCategoryList = shopCategoryList;
	}
	public void setShopCategoryService(IShopCategoryService shopCategoryService) {
		this.shopCategoryService = shopCategoryService;
	}
	public String getShopInfoProductType() {
		return shopInfoProductType;
	}
	public void setShopInfoProductType(String shopInfoProductType) {
		this.shopInfoProductType = shopInfoProductType;
	}
	public void setShopProCategoryService(
			IShopProCategoryService shopProCategoryService) {
		this.shopProCategoryService = shopProCategoryService;
	}

}
