package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang.StringUtils;

import org.apache.log4j.Logger;
import shop.measuringUnit.pojo.MeasuringUnit;
import shop.measuringUnit.pojo.ProductMeasuringUnit;
import shop.measuringUnit.service.IMeasuringUnitService;
import shop.measuringUnit.service.IProductMeasuringUnitService;
import shop.product.pojo.AttributeValue;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductAttrIndex;
import shop.product.pojo.ProductAttribute;
import shop.product.pojo.ProductImg;
import shop.product.pojo.ProductInfo;
import shop.product.pojo.ProductParameters;
import shop.product.pojo.ProductSpecificationValue;
import shop.product.pojo.Specification;
import shop.product.pojo.SpecificationValue;
import shop.product.service.IAddProductInfoService;
import shop.product.service.IAttributeValueService;
import shop.product.service.IBrandService;
import shop.product.service.IBrandTypeService;
import shop.product.service.IProductAttrIndexService;
import shop.product.service.IProductAttributeService;
import shop.product.service.IProductImgService;
import shop.product.service.IProductInfoService;
import shop.product.service.IProductParametersService;
import shop.product.service.IProductSpecificationValueService;
import shop.product.service.ISpecificationService;
import shop.product.service.ISpecificationValueService;
import shop.store.pojo.ShopInfo;
import shop.store.pojo.ShopProCategory;
import shop.store.service.IShopInfoService;
import shop.store.service.IShopProCateClassService;
import shop.store.service.IShopProCategoryService;
import shop.tags.pojo.ShopTradeTag;
import shop.tags.service.IShopProductTradeSituationTagService;
import shop.tags.service.IShopTradeSituationTagService;
import shop.tags.service.IShopTradeTagService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
import basic.service.IAreaService;
/**
 * 套餐Action
 * 
 *
 */
public class EditProductInfoAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private static final long serialVersionUID = -87324409901731724L;
	/**店铺Service**/
	private IShopInfoService shopInfoService;
	/**套餐Service**/
	private IProductInfoService productInfoService;
	/**品牌Service**/
	private IBrandService brandService;
	/**店铺内部套餐分类Service**/
	private IShopProCategoryService shopProCategoryService;
	/** 适用行业标签service */
	private IShopTradeTagService shopTradeTagService;
	/**区域service**/
	private IAreaService areaService;
	/**适用行业与使用场合中间关联表service**/
	private IShopTradeSituationTagService shopTradeSituationTagService;
	/**属性service**/
	private IProductAttributeService productAttributeService;
	/**参数service**/
	private IProductParametersService productParametersService;
	/** 套餐和属性值中间表Service **/
	private IAttributeValueService attributeValueService;
	/**品牌分类Service**/
	private IBrandTypeService brandTypeService;
	/**套餐和计量单位中间表Service**/
	private IProductMeasuringUnitService productMeasuringUnitService;
	/**计量单位Service**/
	private IMeasuringUnitService measuringUnitService;
	/**套餐规格Service**/
	private ISpecificationService specificationService;
	private IProductAttrIndexService productAttrIndexService;
	private IProductImgService productImgService;//套餐图片
	/**店铺内部套餐分类和套餐关系Service**/
	private IShopProCateClassService shopProCateClassService;
	//套餐关联适用行业与使用场合service
	private IShopProductTradeSituationTagService shopProductTradeSituationTagService;
	//套餐规格值service
	private ISpecificationValueService specificationValueService;
	//套餐和规格值中间表Service
	private IProductSpecificationValueService productSpecificationValueService;
	private IAddProductInfoService addProductInfoService;

	private String ids;
	private Integer productId;//套餐ID
	private String shopInfoIds;/**店铺Id**/
	private String productIds;/**套餐ID组**/
	/**选中的店铺内部套餐分类ID**/
	private String selectshopProCategoryId;

	/**查找区域id**/
	private Integer areaId;
	/**套餐所属分组**/
	private String goods;
	/**分类id**/
	private Integer selectProductTypeId;
	/**套餐信息表**/
	private ProductInfo productInfo;
	private String customerName;
	private String shopName;
	/**品牌List**/
	private List<Brand> brandList;

	private List<ShopProCategory> shopProCategoryList;
	/**一级地址**/
	@SuppressWarnings("rawtypes")
	private List<Map> firstAreaList;
	/**二级地址**/
	@SuppressWarnings("rawtypes")
	private List<Map> secondAreaList;
	/**参数**/
	private ProductParameters productPara;
	/**属性list**/
	private List<ProductAttribute> listProductAttr;
	/**套餐属性值List**/
	private List<AttributeValue> attributeValueList ;
	/**套餐属性**/
	private JSONArray jaListProductAttr;
	private JSONArray jaattributeValueList;
	private JSONArray japaiList;
	/**套餐计量单位List**/
	private List<MeasuringUnit> measuringUnitList;
	/** 指定分类下的规格 **/
	List<Specification> specificationList;
	/**选择的套餐属性值List**/
	private List<ProductAttrIndex> paiList;
	private List<ProductImg> productImgList;//套餐的图片
	/** 套餐选择的规格值 **/
	private List<SpecificationValue> specificationValueList;
	/** 套餐选择的规格值 **/
	private List<ProductSpecificationValue> productSpecificationValueList;

	/**平台基础套餐**/
	private List<ProductInfo> productInfoList;

	private String shopInfoId;
	/**
	 * @功能：查询平台基础套餐
	 * @作者:
	 * @参数： @return
	 * @返回值：String
	 * @日期: 2016年5月6日 下午7:34:06
	 */
	public String gotoBasicProductList(){
		return SUCCESS;
	}
	public void getBasicProductList() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		hqlsb.append("where o.shopInfoProductType=1 and o.shopInfoId=1 ");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String sku = request.getParameter("sku");
			String isPutSale = request.getParameter("isPutSale");
			String isPass = request.getParameter("isPass");
			String prodName = request.getParameter("prodName");
			String productTypeId = request.getParameter("productTypeId");
			if(StringUtils.isNotEmpty(productTypeId)){
				hqlsb.append(" and o.productTypeId ="+productTypeId);
			}
			if(StringUtils.isNotEmpty(sku)){
				sku=sku.trim();
				hqlsb.append(" and o.sku like '%"+sku+"%'");
			}
			if(!"-1".equals(isPutSale)){
				hqlsb.append(" and o.isPutSale ="+isPutSale);
			}
			if(!"-1".equals(isPass)){
				hqlsb.append(" and o.isPass ="+isPass);
			}
			if(StringUtils.isNotEmpty(prodName)){
				prodName=prodName.trim();
				hqlsb.append(" and o.productFullName like '%"+prodName+"%'");
			}
		}

		int totalRecordCount = productInfoService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		productInfoList = productInfoService.findListByPageHelper(null, pageHelper,hqlsb.toString()+ " order by o.productId desc ");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", productInfoList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 查询审核通过的店铺集合
	 */
	public void findShopInfoList() throws Exception {
		StringBuffer hqlsb = new StringBuffer();
		//追加查询条件、审核通过（isPass1、待审核2、不通过3、通过）、未关闭（isClose0：不关闭1：关闭）
		hqlsb.append(" where shopInfoType!=1 and o.isPass=3 and o.isClose=0 ");
		if(StringUtils.isNotEmpty(customerName)){
			customerName=customerName.trim();
			hqlsb.append(" and o.customerName like '%"+customerName+"%'");
		}
		if(StringUtils.isNotEmpty(shopName)){
			shopName=shopName.trim();
			hqlsb.append(" and o.shopName like '%"+shopName+"%'");
		}

		int totalRecordCount = shopInfoService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<ShopInfo>shopInfoList = shopInfoService.findListByPageHelper(null, pageHelper,hqlsb.toString()+ " order by o.shopInfoId desc ");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", shopInfoList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();


	}
	/**
	 * @throws Exception
	 * @功能：将平台基础套餐拷贝一份给店铺
	 * @作者:
	 * @参数： @throws IOException
	 * @返回值：void
	 * @日期: 2016年5月8日 下午2:06:55
	 */
	public void copyBasicProductInfo() throws Exception{
		boolean success = false;
		addProductInfoService.saveCopyBasicProductInfo(shopInfoIds,productIds,selectshopProCategoryId);
		PrintWriter out = response.getWriter();
		out.println(success);
		out.flush();
		out.close();
	}
	/**
	 * @throws IOException
	 * @功能：删除套餐及所涉及到的表
	 * @作者:
	 * @参数： @param productIds 套餐Id字符串
	 * @参数： @return
	 * @返回值：boolean
	 * @日期: 2016年5月9日 下午2:36:21
	 */
	public void deleteProductAll() throws IOException{
		boolean success = false;
		//删除套餐及所涉及到的表
		success = addProductInfoService.deleteProductAll(productIds);
		PrintWriter out = response.getWriter();
		out.println(success);
		out.flush();
		out.close();
	}
	/**
	 * @功能：添加套餐页面
	 * @作者:
	 * @参数： @return
	 * @返回值：String
	 * @日期: 2016年5月16日 下午3:47:14
	 */
	public String addProductInfo(){
		//根据当前登录人得到店铺信息
		String shopInfoId = String.valueOf(getFileUrlConfig().get("basicShopInfoId"));
		if(Utils.stringIsNotEmpty(shopInfoId)){
			shopProCategoryList = shopProCategoryService.findObjects(" where o.shopInfoId='"+shopInfoId+"' and o.level=1 and o.isShow=1");
		}
		//查询适用行业相关标签信息
		List<ShopTradeTag> shopTradeTagList = shopTradeTagService.findObjects(" where o.useState=1 order by o.ttId desc");
		request.setAttribute("shopTradeTagList", shopTradeTagList);
		if(shopTradeTagList!=null&&shopTradeTagList.size()>0){
			request.setAttribute("firstShopTradeTag", JSONObject.fromObject(shopTradeTagList.get(0)).toString());
		}
		//一级地区parent=0
		String firstHql="select a.name as name,a.areaId as aid,a.parentId as parent from BasicArea a where a.parentId=0 order by a.areaId";
		firstAreaList=areaService.findListMapByHql(firstHql);
		return SUCCESS;
	}
	/**
	 * @throws IOException
	 * @功能：添加套餐页面异步查询信息
	 * @作者:
	 * @参数： @return
	 * @返回值：String
	 * @日期: 2016年9月20日 下午3:47:14
	 */
	public void queryAddProductInfo() throws IOException{
		//根据当前登录人得到店铺信息
		if(Utils.objectIsEmpty(shopInfoId)){
			shopInfoId = String.valueOf(getFileUrlConfig().get("basicShopInfoId"));
		}
		shopProCategoryList = shopProCategoryService.findObjects(" where o.shopInfoId='"+shopInfoId+"'");
		//查询适用行业相关标签信息
//		List<ShopTradeTag> shopTradeTagList = shopTradeTagService.findObjects(" where o.useState=1 order by o.ttId desc");
//		String firstShopTradeTag = "";
//		if(shopTradeTagList!=null&&shopTradeTagList.size()>0){
//			firstShopTradeTag = JSONObject.fromObject(shopTradeTagList.get(0)).toString();
//		}
		//一级地区parent=0
		String firstHql="select a.name as name,a.areaId as aid,a.parentId as parent from BasicArea a where a.parentId=0 order by a.areaId";
		firstAreaList=areaService.findListMapByHql(firstHql);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("shopProCategoryList", shopProCategoryList);
//		map.put("shopTradeTagList", shopTradeTagList);
//		map.put("firstShopTradeTag", firstShopTradeTag);
		map.put("firstAreaList", firstAreaList);
		JSONObject jo = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 跳转添加套餐页面
	 */
	public String addProduct() {
		//根据当前登录人得到店铺信息
		String shopInfoId = String.valueOf(getFileUrlConfig().get("basicShopInfoId"));
		if(Utils.stringIsNotEmpty(shopInfoId)){
			shopProCategoryList = shopProCategoryService.findObjects(" where o.shopInfoId='"+shopInfoId+"' and o.level=1 and o.isShow=1");
		}
		//查询适用行业相关标签信息
		List<ShopTradeTag> shopTradeTagList = shopTradeTagService.findObjects(" where o.useState=1 order by o.ttId desc");
		request.setAttribute("shopTradeTagList", shopTradeTagList);
		if(shopTradeTagList!=null&&shopTradeTagList.size()>0){
			request.setAttribute("firstShopTradeTag", JSONObject.fromObject(shopTradeTagList.get(0)).toString());
		}
		//一级地区parent=0
		String firstHql="select a.name as name,a.areaId as aid,a.parentId as parent from BasicArea a where a.parentId=0 order by a.areaId";
		firstAreaList=areaService.findListMapByHql(firstHql);
		return SUCCESS;
	}
	/**
	 * 通过适用行业ID获取相关联的适用场合信息
	 */
	@SuppressWarnings("rawtypes")
	public void getShopSituationTagInfoList() throws IOException{
		//获取ttId
		String ttId = request.getParameter("ttId");
		String hql="select a.tstId as tstId,c.tageName as tageName,c.stId as stId,c.useState as useState from ShopTradeSituationTag a ,ShopTradeTag b ,ShopSituationTag c where a.stId=c.stId and a.ttId=b.ttId and c.useState=1 and a.ttId="+ttId;
		List<Map> listMap = shopTradeSituationTagService.findListMapByHql(hql);
		JSONArray jo = JSONArray.fromObject(listMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 异步获取指定规格的规格值
	 */
	@SuppressWarnings("unchecked")
	public void getSpecificationValueBySpecificationId() {
		String specificationId = request.getParameter("specificationId");
		specificationValueList = (List<SpecificationValue>)specificationValueService.findObjects(null, " where o.specificationId=" + specificationId+" order by o.sort " );
		JSONArray jo = JSONArray.fromObject(specificationValueList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 不显示
	 * @throws IOException
	 */
	public void editProductInfoIsShow() throws IOException{
		Boolean isSuccess = false;
		if(Utils.stringIsNotEmpty(ids)){
			String[] productIds = ids.split(",");
			if(Utils.objectIsNotEmpty(productIds)){
				for(String prodId : productIds){
					ProductInfo productInfo = (ProductInfo) productInfoService.getObjectByParams(" where o.productId="+prodId+"");
					productInfo.setIsShow(0);
					productInfoService.saveOrUpdateObject(productInfo);
				}
				isSuccess=true;
			}
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(isSuccess);
		out.flush();
		out.close();
	}

	/**
	 * 根据套餐分类查询对应的品牌、参数和规格
	 */
	@SuppressWarnings("unchecked")
	public void selectOtherInfoByProductTypeId() throws IOException {
		if (selectProductTypeId != null) {
			// 指定分类下的参数
			productPara = (ProductParameters) productParametersService.getObjectByParams("where o.productTypeId=" + selectProductTypeId);
			// 指定分类下的属性
			listProductAttr = productAttributeService.findObjects(null, "where o.productTypeId=" + selectProductTypeId+"and isListShow = 1");
			attributeValueList = new ArrayList<AttributeValue>();
			String productAttrIds="";
			if (listProductAttr != null && listProductAttr.size() > 0) {
				for (int i=0;i<listProductAttr.size();i++) {
					if(i==listProductAttr.size()-1){
						productAttrIds+=listProductAttr.get(i).getProductAttrId();
					}else{
						productAttrIds+=listProductAttr.get(i).getProductAttrId()+",";
					}
				}
				attributeValueList = attributeValueService.findObjects(null," where productAttrId in ("+productAttrIds+")");
			}
			jaListProductAttr = JSONArray.fromObject(listProductAttr);
			// 查询分类下的品牌
			List<BrandType> brandTypeList = brandTypeService.findObjects(null, " where o.productTypeId=" + selectProductTypeId );
			brandList = new ArrayList<Brand>();
			if (brandTypeList != null && brandTypeList.size() > 0) {
				for (BrandType bt : brandTypeList) {
					Brand brand = (Brand) brandService.getObjectByParams(" where brandId=" + bt.getBrandId());
					if (brand != null) {
						brandList.add(brand);
					}
				}
			}
			Brand brand = (Brand) brandService.getObjectByParams(" where brandId=1" );
			if (brand != null) {
				brandList.add(brand);
			}
			//查询套餐计量单位名称
			List<ProductMeasuringUnit> productMeasuringUnitList = productMeasuringUnitService.findObjects(null, " where o.productTypeId=" + selectProductTypeId);
			measuringUnitList = new ArrayList<MeasuringUnit>();
			if (productMeasuringUnitList != null && productMeasuringUnitList.size() > 0) {
				for (ProductMeasuringUnit pmu : productMeasuringUnitList) {
					MeasuringUnit measuringUnit = (MeasuringUnit) measuringUnitService.getObjectByParams(" where measuringUnitId=" + pmu.getMeasuringUnitId()+"and useState=1");
					if (measuringUnit != null) {
						measuringUnitList.add(measuringUnit);
					}
				}
			}
			MeasuringUnit measuringUnit = (MeasuringUnit) measuringUnitService.getObjectByParams(" where measuringUnitId=1" );
			if (measuringUnit != null) {
				measuringUnitList.add(measuringUnit);
			}
			// 指定分类下的规格
			specificationList = specificationService.findObjects(null, " where o.productTypeId='" + selectProductTypeId + "'");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("productPara", productPara);
		map.put("listProductAttr", jaListProductAttr);
		map.put("attributeValueList", attributeValueList);
		map.put("brandList", brandList);
		map.put("measuringUnitList", measuringUnitList);
		map.put("specificationList", specificationList);
		JSONObject jo = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据套餐ID查询套餐
	@SuppressWarnings({ "unchecked" })
	public void getProductInfoByProductId() throws IOException{
		productInfo = (ProductInfo) productInfoService.getObjectByParams(" where o.productId=" + productId);
		selectProductTypeId = productInfo.getProductTypeId();// 选择的分类
		// 查询分类下的品牌
		List<BrandType> brandTypeList = brandTypeService.findObjects(null, " where o.productTypeId='" + selectProductTypeId + "'");
		brandList = new ArrayList<Brand>();
		if (brandTypeList != null && brandTypeList.size() > 0) {
			for (BrandType bt : brandTypeList) {
				Brand brand = (Brand) brandService.getObjectByParams(" where brandId='" + bt.getBrandId() + "'");
				if (brand != null) {
					brandList.add(brand);
				}
			}
		}
		Brand brand = (Brand) brandService.getObjectByParams(" where brandId=1" );
		if (brand != null) {
			brandList.add(brand);
		}
		//查询套餐计量单位名称
		List<ProductMeasuringUnit> productMeasuringUnitList = productMeasuringUnitService.findObjects(null, " where o.productTypeId=" + selectProductTypeId);
		measuringUnitList = new ArrayList<MeasuringUnit>();
		if (productMeasuringUnitList != null && productMeasuringUnitList.size() > 0) {
			for (ProductMeasuringUnit pmu : productMeasuringUnitList) {
				MeasuringUnit measuringUnit = (MeasuringUnit) measuringUnitService.getObjectByParams(" where measuringUnitId=" + pmu.getMeasuringUnitId()+"and useState = 1");
				if (measuringUnit != null) {
					measuringUnitList.add(measuringUnit);
				}
			}
		}
		MeasuringUnit measuringUnit = (MeasuringUnit) measuringUnitService.getObjectByParams(" where measuringUnitId=1");
		if (measuringUnit != null) {
			measuringUnitList.add(measuringUnit);
		}
		/*// 该套餐所属分类下的所有属性和参数(暂时不实现，依据新的结构需要重新开发)
		listProductAttr = productAttributeService.findObjects(null, "where o.productTypeId=" + selectProductTypeId);
		jaListProductAttr = JSONArray.fromObject(listProductAttr);*/
		// 指定分类下的参数
		productPara =  (ProductParameters) productParametersService.getObjectByParams("where o.productTypeId="+selectProductTypeId);
		//System.out.println(JSONObject.fromObject(productPara).toString());
		listProductAttr = productAttributeService.findObjects(null, "where o.productTypeId=" + selectProductTypeId+" and isListShow = 1");
		String productAttrIds="";
		if (listProductAttr != null && listProductAttr.size() > 0) {
			for (int i=0;i<listProductAttr.size();i++) {
				if(i==listProductAttr.size()-1){
					productAttrIds+=listProductAttr.get(i).getProductAttrId();
				}else{
					productAttrIds+=listProductAttr.get(i).getProductAttrId()+",";
				}
			}
			attributeValueList = attributeValueService.findObjects(null," where productAttrId in ("+productAttrIds+")");
			jaListProductAttr = JSONArray.fromObject(listProductAttr);
		}
		jaattributeValueList = JSONArray.fromObject(attributeValueList);
		//套餐的属性
		paiList = productAttrIndexService.findObjects(null, " where o.productId='" + productInfo.getProductId() +"'");
		japaiList = JSONArray.fromObject(paiList);
		//查询套餐的图片
		productImgList = productImgService.findObjects(null, " where o.productId='" + productInfo.getProductId() + "'");
		// 指定分类下的规格
		specificationList = specificationService.findObjects(null, " where o.productTypeId='" + selectProductTypeId + "'");
		//当前店铺中的内部分类
		shopProCategoryList = shopProCategoryService.findObjects(" where o.shopInfoId ="+productInfo.getShopInfoId());
		//当前套餐所属店铺的内部分类
		List<Map<String,Object>> listMap= shopProCateClassService.findListMapBySql("select a.shopProCategoryId from shop_shopprocateclass a where a.productId="+productInfo.getProductId());

		if(listMap.size()>0){
			 selectshopProCategoryId = String.valueOf(listMap.get(0).get("shopProCategoryId"));
		}

//		//查询当前套餐的关联标签信息
//			//1.查出基础的适用行业标签
//			List<ShopTradeTag> shopTradeTagList = shopTradeTagService.findObjects(" where o.useState=1 order by o.ttId desc");
//			request.setAttribute("shopTradeTagList", shopTradeTagList);
//			if(shopTradeTagList!=null&&shopTradeTagList.size()>0){
//				request.setAttribute("firstShopTradeTag", JSONObject.fromObject(shopTradeTagList.get(0)).toString());
//			}
//			//2.获取套餐关联标签信息 处理成jsonArray的格式传到前台
//			String sql="SELECT a.ttId as ttId,concat(group_concat(conv( oct(a.stId) , 8, 10))) as ids FROM shop_product_trade_situation_tag a where a.productId="+productInfo.getProductId()+" group by a.ttId order by a.ttId desc";
//			List<Map<String,Object>> shopProductTradeSituationTagListMap = shopProductTradeSituationTagService.findListMapBySql(sql);
//			System.out.println(JSONArray.fromObject(shopProductTradeSituationTagListMap).toString());
//			request.setAttribute("shopProductTradeSituationTagJsonArray", JSONArray.fromObject(shopProductTradeSituationTagListMap).toString());
		//一级地区parent=0
		String firstHql="select a.name as name,a.areaId as aid,a.parentId as parent from BasicArea a where a.parentId=0 order by a.areaId";
		firstAreaList=areaService.findListMapByHql(firstHql);
		//二级地区parent=productInfo.getDeliveryAddressProvince()
		String secondHql="select a.name as name,a.areaId as aid,a.parentId as parent from BasicArea a where a.parentId="+productInfo.getDeliveryAddressProvince()+" order by a.areaId";
		secondAreaList=areaService.findListMapByHql(secondHql);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("productPara", productPara);
		map.put("productInfo", productInfo);
		map.put("productImgList", productImgList);
		map.put("listProductAttr", jaListProductAttr);
		map.put("jattributeValueList", jaattributeValueList);
		map.put("japaiList", japaiList);
		map.put("firstAreaList", firstAreaList);
		map.put("secondAreaList", secondAreaList);
		map.put("shopProCategoryList", shopProCategoryList);
		map.put("selectshopProCategoryId", selectshopProCategoryId);
		map.put("brandList", brandList);
		map.put("measuringUnitList", measuringUnitList);
		map.put("specificationList", specificationList);
		JSONObject jo = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 根据areaId 查询下级区域
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void findAreaList() throws IOException{
		String firstHql="select a.name as name,a.areaId as aid,a.parentId as parentId from BasicArea a where a.parentId="+areaId+" order by a.areaId";
    	List<Map> areaList=areaService.findListMapByHql(firstHql);
    	JSONArray jo = JSONArray.fromObject(areaList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter pw;
		pw = response.getWriter();
		pw.write(String.valueOf(jo));
		pw.flush();
		pw.close();
	}
	/**
	 * 获取套餐组的规格值
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public void getGoodsProductSpecificationValue() throws IOException{
		// 套餐选定规格值
		List<List<ProductSpecificationValue>> psvGroupList=new ArrayList<List<ProductSpecificationValue>>();
		//指定当前套餐的所有规格值,先加到列表中，表示列表的第一个规格组为当前套餐的默认规格组
		productSpecificationValueList=productSpecificationValueService.findObjects(null, " where o.productId="+productId+" order by psvId");
		psvGroupList.add(productSpecificationValueList);
		if(!Utils.collectionIsNotEmpty(productInfoList)){
			productInfoList = new ArrayList<ProductInfo>();
		}
		productInfoList.add((ProductInfo)productInfoService.getObjectByParams(" where o.productId="+productId));
		//指定当前套餐所在组其他套餐的所有规格值
		productSpecificationValueList=productSpecificationValueService.findObjects(null, " where o.goodId="+goods+" and o.productId!="+productId+" order by psvId");
		if(productSpecificationValueList!=null&&productSpecificationValueList.size()>0){
			String old_productId="";
			List <ProductSpecificationValue> psvList=null;
			for(int i=0;i<productSpecificationValueList.size();i++){
				ProductSpecificationValue psv=productSpecificationValueList.get(i);
				String productId=psv.getProductId().toString();
				if(!old_productId.equals(productId)){
					productInfoList.add((ProductInfo) productInfoService.getObjectByParams(" where o.productId="+productId));
					if(i!=0){
						psvGroupList.add(psvList);
					}
					psvList=new ArrayList<ProductSpecificationValue>();
				}
				psvList.add(psv);
				old_productId=productId;
			}
			psvGroupList.add(psvList);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("psvGroupList", psvGroupList);
		map.put("productInfoList", productInfoList);
		JSONObject jo = JSONObject.fromObject(map);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 解除该套餐所在套餐组的规格以及对应的规格值的关联关系
	 */
	public void removeProductSpecificationValueGoodsGuanlian(){
		String optionProductId = request.getParameter("optionProductId");
		boolean isSuccess=addProductInfoService.removeProductSpecificationValueGoodsGuanlian(productId,optionProductId);
		JSONObject jo = new JSONObject();
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out;
		try {
			jo.accumulate("isSuccess", isSuccess);
			out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public List<Brand> getBrandList() {
		return brandList;
	}

	public void setBrandList(List<Brand> brandList) {
		this.brandList = brandList;
	}

	public List<ShopProCategory> getShopProCategoryList() {
		return shopProCategoryList;
	}

	public void setShopProCategoryList(List<ShopProCategory> shopProCategoryList) {
		this.shopProCategoryList = shopProCategoryList;
	}

	@SuppressWarnings("rawtypes")
	public List<Map> getFirstAreaList() {
		return firstAreaList;
	}

	@SuppressWarnings("rawtypes")
	public void setFirstAreaList(List<Map> firstAreaList) {
		this.firstAreaList = firstAreaList;
	}

	public Integer getSelectProductTypeId() {
		return selectProductTypeId;
	}

	public void setSelectProductTypeId(Integer selectProductTypeId) {
		this.selectProductTypeId = selectProductTypeId;
	}

	public ProductParameters getProductPara() {
		return productPara;
	}

	public void setProductPara(ProductParameters productPara) {
		this.productPara = productPara;
	}

	public List<ProductAttribute> getListProductAttr() {
		return listProductAttr;
	}

	public void setListProductAttr(List<ProductAttribute> listProductAttr) {
		this.listProductAttr = listProductAttr;
	}

	public List<AttributeValue> getAttributeValueList() {
		return attributeValueList;
	}

	public void setAttributeValueList(List<AttributeValue> attributeValueList) {
		this.attributeValueList = attributeValueList;
	}

	public JSONArray getJaListProductAttr() {
		return jaListProductAttr;
	}

	public void setJaListProductAttr(JSONArray jaListProductAttr) {
		this.jaListProductAttr = jaListProductAttr;
	}

	public List<MeasuringUnit> getMeasuringUnitList() {
		return measuringUnitList;
	}

	public void setMeasuringUnitList(List<MeasuringUnit> measuringUnitList) {
		this.measuringUnitList = measuringUnitList;
	}

	public List<Specification> getSpecificationList() {
		return specificationList;
	}

	public void setSpecificationList(List<Specification> specificationList) {
		this.specificationList = specificationList;
	}

	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}

	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}

	public void setShopProCategoryService(
			IShopProCategoryService shopProCategoryService) {
		this.shopProCategoryService = shopProCategoryService;
	}

	public void setShopTradeTagService(IShopTradeTagService shopTradeTagService) {
		this.shopTradeTagService = shopTradeTagService;
	}

	public void setAreaService(IAreaService areaService) {
		this.areaService = areaService;
	}

	public void setShopTradeSituationTagService(
			IShopTradeSituationTagService shopTradeSituationTagService) {
		this.shopTradeSituationTagService = shopTradeSituationTagService;
	}

	public void setProductAttributeService(
			IProductAttributeService productAttributeService) {
		this.productAttributeService = productAttributeService;
	}

	public void setProductParametersService(
			IProductParametersService productParametersService) {
		this.productParametersService = productParametersService;
	}

	public void setAttributeValueService(
			IAttributeValueService attributeValueService) {
		this.attributeValueService = attributeValueService;
	}

	public void setBrandTypeService(IBrandTypeService brandTypeService) {
		this.brandTypeService = brandTypeService;
	}

	public void setProductMeasuringUnitService(
			IProductMeasuringUnitService productMeasuringUnitService) {
		this.productMeasuringUnitService = productMeasuringUnitService;
	}

	public void setMeasuringUnitService(IMeasuringUnitService measuringUnitService) {
		this.measuringUnitService = measuringUnitService;
	}

	public void setSpecificationService(ISpecificationService specificationService) {
		this.specificationService = specificationService;
	}

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

	public ProductInfo getProductInfo() {
		return productInfo;
	}

	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
	}

	public JSONArray getJaattributeValueList() {
		return jaattributeValueList;
	}

	public void setJaattributeValueList(JSONArray jaattributeValueList) {
		this.jaattributeValueList = jaattributeValueList;
	}

	public JSONArray getJapaiList() {
		return japaiList;
	}

	public void setJapaiList(JSONArray japaiList) {
		this.japaiList = japaiList;
	}

	public List<ProductAttrIndex> getPaiList() {
		return paiList;
	}

	public void setPaiList(List<ProductAttrIndex> paiList) {
		this.paiList = paiList;
	}

	public List<ProductImg> getProductImgList() {
		return productImgList;
	}

	public void setProductImgList(List<ProductImg> productImgList) {
		this.productImgList = productImgList;
	}

	public String getSelectshopProCategoryId() {
		return selectshopProCategoryId;
	}

	public void setSelectshopProCategoryId(String selectshopProCategoryId) {
		this.selectshopProCategoryId = selectshopProCategoryId;
	}

	public void setProductAttrIndexService(
			IProductAttrIndexService productAttrIndexService) {
		this.productAttrIndexService = productAttrIndexService;
	}

	public void setProductImgService(IProductImgService productImgService) {
		this.productImgService = productImgService;
	}

	public void setShopProductTradeSituationTagService(
			IShopProductTradeSituationTagService shopProductTradeSituationTagService) {
		this.shopProductTradeSituationTagService = shopProductTradeSituationTagService;
	}

	@SuppressWarnings("rawtypes")
	public List<Map> getSecondAreaList() {
		return secondAreaList;
	}

	@SuppressWarnings("rawtypes")
	public void setSecondAreaList(List<Map> secondAreaList) {
		this.secondAreaList = secondAreaList;
	}

	public void setShopProCateClassService(
			IShopProCateClassService shopProCateClassService) {
		this.shopProCateClassService = shopProCateClassService;
	}

	public void setSpecificationValueService(
			ISpecificationValueService specificationValueService) {
		this.specificationValueService = specificationValueService;
	}

	public List<SpecificationValue> getSpecificationValueList() {
		return specificationValueList;
	}

	public void setSpecificationValueList(
			List<SpecificationValue> specificationValueList) {
		this.specificationValueList = specificationValueList;
	}

	public Integer getAreaId() {
		return areaId;
	}

	public void setAreaId(Integer areaId) {
		this.areaId = areaId;
	}

	public void setProductSpecificationValueService(
			IProductSpecificationValueService productSpecificationValueService) {
		this.productSpecificationValueService = productSpecificationValueService;
	}

	public List<ProductSpecificationValue> getProductSpecificationValueList() {
		return productSpecificationValueList;
	}

	public void setProductSpecificationValueList(
			List<ProductSpecificationValue> productSpecificationValueList) {
		this.productSpecificationValueList = productSpecificationValueList;
	}

	public String getGoods() {
		return goods;
	}

	public void setGoods(String goods) {
		this.goods = goods;
	}

	public void setAddProductInfoService(
			IAddProductInfoService addProductInfoService) {
		this.addProductInfoService = addProductInfoService;
	}

	public List<ProductInfo> getProductInfoList() {
		return productInfoList;
	}

	public void setProductInfoList(List<ProductInfo> productInfoList) {
		this.productInfoList = productInfoList;
	}
	public String getProductIds() {
		return productIds;
	}
	public void setProductIds(String productIds) {
		this.productIds = productIds;
	}
	public String getShopInfoIds() {
		return shopInfoIds;
	}
	public void setShopInfoIds(String shopInfoIds) {
		this.shopInfoIds = shopInfoIds;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public String getShopName() {
		return shopName;
	}
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}
	public String getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(String shopInfoId) {
		this.shopInfoId = shopInfoId;
	}

}
