package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.apache.commons.lang.StringUtils;

import org.apache.log4j.Logger;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductInfo;
import shop.product.pojo.ProductType;
import shop.product.service.IBrandService;
import shop.product.service.IBrandTypeService;
import shop.product.service.IProductInfoService;
import shop.product.service.IProductTypeService;
import util.action.BaseAction;
import util.other.Utils;
import basic.pojo.KeyBook;

/**
 * 套餐分类Action
 * 
 *
 */
@SuppressWarnings({ "serial", "unused" })
public class ProductTypeAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private IProductTypeService productTypeService;//套餐分类Service
	private IProductInfoService productInfoService;//套餐信息Service
	private String id;
	private String ids;
	private String productTypeId;
	private ProductType productType;
	private Integer productId;
	private IBrandTypeService brandTypeService;//品牌和分类Service
	private IBrandService brandService;//品牌Service
	private Map categoryMap = new LinkedHashMap();//套餐分类
	private Map categoryBrandMap = new LinkedHashMap();//套餐分类下的品牌
	private List<ProductType> productTypeList = new ArrayList<ProductType>();//套餐分类List
	/**分类级别**/
	private String level;
	/**分类总级别**/
	private Integer type_level;
	/**分类名称**/
	private String prodTypeNames;
	//管理分类
    public String gotoProductTypePage(){
    	return SUCCESS;
    }
    //回传tree节点数据
	@SuppressWarnings("unchecked")
	public void getNodes() {
		response.setContentType("text/xml;charset=utf-8");
		List<ProductType> list = productTypeService.queryByParentId(id);
		StringBuffer sbf = new StringBuffer();
		ProductType productType = null;
		sbf.append("<List>");
		for (Iterator ite = list.iterator(); ite.hasNext();) {
			productType = (ProductType) ite.next();
			if (productType != null) {
				sbf.append("<ProductType>");
				sbf.append("<name>").append(productType.getSortName()).append(
						"</name>");
				sbf.append("<id>").append(productType.getProductTypeId()).append(
						"</id>");
				sbf.append("<loadType>").append(productType.getLoadType()).append(
					"</loadType>");
				sbf.append("<level>").append(productType.getLevel()).append(
						"</level>");
				sbf.append("</ProductType>");
			}
		}
		sbf.append("</List>");
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println(sbf.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 跳转到套餐分类列表页
	 */
	@SuppressWarnings("unchecked")
	public String gotoProductTypeByLevelPage(){
		Map<String,List<KeyBook>> map = (Map<String, List<KeyBook>>) servletContext.getAttribute("keybook");
		type_level = Integer.parseInt(map.get("type_level").get(0).getValue());
		if(Utils.objectIsEmpty(productTypeId)){
			productTypeId=String.valueOf(1);
			level=String.valueOf(1);
		}else{
			productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+productTypeId);
			level=String.valueOf(productType.getLevel());
			//套餐分类导航
			getProductTypeName(productTypeId,productType.getParentId());
		}
		return SUCCESS;
	}
	/**
	 * 获取当前分类名称（无级限）
	 */
	public void getProductTypeName(String prodTypeId,Integer fatherTypeId){
		ProductType pt =  (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+prodTypeId);
		String label = pt.getSortName();
		if(StringUtils.isNotEmpty(prodTypeNames)){
			if(pt!=null && pt.getParentId()==0){
				prodTypeNames = label +"&nbsp;&gt;&nbsp;"+prodTypeNames;
			}else{
				prodTypeNames = label +"&nbsp;&gt;&nbsp;"+prodTypeNames;
			}
		}else{
			if(pt!=null && pt.getParentId()==0){
				prodTypeNames = label;
			}else{
				prodTypeNames = label;
			}
		}
		//递归
		if(pt!=null && pt.getParentId()!=0){
			getProductTypeName(String.valueOf(pt.getParentId()),fatherTypeId);
		}
	}
	//新增或许修改套餐分类 
	public void saveOrEditProductType() throws Exception {
		if(productType!=null){
			ProductType pt = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+productType.getParentId()+"'");
			if(productType.getProductTypeId()==null){//添加
				productType.setLoadType("1"); 
				productType.setLevel(pt.getLevel()+1);
				pt.setLoadType("2");
				productTypeService.saveOrUpdateObject(pt);
			}else{
				ProductType pt2 = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+productType.getProductTypeId()+"'");
				productType.setLoadType(pt2.getLoadType());
				productType.setLevel(pt2.getLevel());
			}
			productTypeService.saveOrUpdateObject(productType);
		}
	}
	 //得到分类对象
	 public void getProductTypeObject() throws Exception {
		    ProductType productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
			JSONObject jo = JSONObject.fromObject(productType);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	 //删除分类
	 @SuppressWarnings("unchecked")
	public void delProductType() throws Exception {
		Boolean isSuccess;
	    List list = productTypeService.queryByParentId(productTypeId);
	    if(list==null || list.size()==0){
	    	//判断当前删除节点是否关联套餐
	    	Integer count2 = productInfoService.getCount(" where o.productTypeId='"+productTypeId+"'");
	    	if(count2==0){
	    		//删除的时候要判断此节点的父类还有没有子类，如果没有了就要把父类改成叶子节点，否则不变
		    	productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		    	Integer parentId = productType.getParentId();
		    	isSuccess =  productTypeService.deleteObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		    	Integer count = productTypeService.getCount(" where o.parentId="+parentId+"");
		    	if(count==0){
		    		ProductType pt = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+parentId+"'");
		    		pt.setLoadType("1");
		    		productTypeService.saveOrUpdateObject(pt);
		    	}
	    	}else{
	    		isSuccess = false;
	    	}
	    }else{
	    	isSuccess = false;
	    }
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	 //根据分类查询套餐
	 public String gotoProductInfoListByProductTypeId(){
		 request.setAttribute("productTypeId",productTypeId);
		 return SUCCESS;
	 }
	 //根据分类ID查询套餐
	 public void listProductInfoByProductTypeId() throws IOException{
			int totalRecordCount = productInfoService.getCount(" where o.productTypeId="+productTypeId);
			pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
			List<ProductInfo> ProductInfoList = productInfoService.findListByPageHelper(null,pageHelper, " where o.productTypeId="+productTypeId);
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT); 
			Map<String, Object> jsonMap = new HashMap<String, Object>();
			jsonMap.put("total", totalRecordCount);
			jsonMap.put("rows", ProductInfoList);
			JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
	 }
	 //删除套餐和分类关系
	 public void deleteTypeProduct() throws IOException{
	 }
	 //更新初始化套餐分类信息
	 public void initProdutTypeInfo()throws IOException{
		 JSONObject jo = new JSONObject();
		 if (servletContext != null) {
				if (servletContext != null) {
					List<ProductType> categoryList = new ArrayList<ProductType>();
					//一级分类集合
					productTypeList = productTypeService.findObjects(" where o.isShow=1 and o.parentId=1 order by o.sortCode");
					for(ProductType pt : productTypeList){
						List<Brand> brandList = new ArrayList<Brand>();
						Map seondMap  = new LinkedHashMap();
						//二级分类集合
						List<ProductType> secondProductTypeList = productTypeService.findObjects(" where o.parentId='"+pt.getProductTypeId()+"' and o.isShow=1");
						pt.setChildProductType(secondProductTypeList);
						for(ProductType spt : secondProductTypeList){
							Map thirdMap  = new LinkedHashMap();
							//三级分类集合
							List<ProductType> thirdProductTypeList = productTypeService.findObjects(" where o.parentId='"+spt.getProductTypeId()+"' and o.isShow=1");
							spt.setChildProductType(thirdProductTypeList);
							for(ProductType tpt : thirdProductTypeList){
								//四级分类集合
								List<ProductType> fourProductTypeList = productTypeService.findObjects(" where o.parentId='"+tpt.getProductTypeId()+"' and o.isShow=1");
								tpt.setChildProductType(fourProductTypeList);
								thirdMap.put(tpt, fourProductTypeList);
							}
							seondMap.put(spt, thirdMap);
						}
						List<BrandType> brandTypeList = brandTypeService.findSome(0, 5, " where o.productTypeId='"+pt.getProductTypeId()+"' and o.isShow=1");
						if(brandTypeList!=null && brandTypeList.size()>0){
							for(BrandType bt : brandTypeList){
								Brand brand = (Brand) brandService.getObjectByParams(" where o.brandId='"+bt.getBrandId()+"' and o.isShow=1");
								if(brand!=null&&brand.getBrandId()!=null){
									brandList.add(brand);
								}
							}
						}
						categoryMap.put(pt, seondMap);
						categoryBrandMap.put(pt, brandList);
						pt.setBrandList(brandList);
					}
					servletContext.setAttribute("categoryMap", categoryMap);
					servletContext.setAttribute("categoryList", productTypeList);
					servletContext.setAttribute("categoryBrandMap", categoryBrandMap);
					productTypeList = productTypeService.findObjects(" where o.parentId not in(0)");
					servletContext.setAttribute("productTypeList", productTypeList);
					if(Utils.objectIsNotEmpty(categoryMap)){
						jo.accumulate("isSuccess", "true");
					}else{
						jo.accumulate("isSuccess", "false");
					}
				}
			}else{
				jo.accumulate("isSuccess", "false");
			}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	 }
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}
	public ProductType getProductType() {
		return productType;
	}
	public void setProductType(ProductType productType) {
		this.productType = productType;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public Map getCategoryMap() {
		return categoryMap;
	}
	public void setCategoryMap(Map categoryMap) {
		this.categoryMap = categoryMap;
	}
	public Map getCategoryBrandMap() {
		return categoryBrandMap;
	}
	public void setCategoryBrandMap(Map categoryBrandMap) {
		this.categoryBrandMap = categoryBrandMap;
	}
	public List<ProductType> getProductTypeList() {
		return productTypeList;
	}
	public void setProductTypeList(List<ProductType> productTypeList) {
		this.productTypeList = productTypeList;
	}
	public void setBrandTypeService(IBrandTypeService brandTypeService) {
		this.brandTypeService = brandTypeService;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}
	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	public Integer getType_level() {
		return type_level;
	}
	public void setType_level(Integer type_level) {
		this.type_level = type_level;
	}
	public String getProdTypeNames() {
		return prodTypeNames;
	}
	public void setProdTypeNames(String prodTypeNames) {
		this.prodTypeNames = prodTypeNames;
	}
	
}
