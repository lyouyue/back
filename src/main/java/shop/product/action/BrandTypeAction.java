package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductType;
import shop.product.service.IBrandService;
import shop.product.service.IBrandTypeService;
import shop.product.service.IProductTypeService;
import util.action.BaseAction;
import util.other.Utils;

/**
 * 品牌和分类Action
 * 
 *
 */
@SuppressWarnings("serial")
public class BrandTypeAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private IBrandTypeService brandTypeService;//品牌分类Service
	private IProductTypeService ProductTypeService;//套餐分类Service
	private IBrandService brandService;//品牌Service
	private List<BrandType> brandTypeList = new ArrayList<BrandType>();//品牌分类List
	private List<ProductType> productTypeList = new ArrayList<ProductType>();//套餐分类List
	private String brandId;
	private Integer [] productTypeIds;
	private BrandType brandType;
	private String productTypeId;
	private String level;
	private String brandTypeId;
	private String id;
	private List<Map<String, Object>> list;
	/**品牌Id集合**/
	private Integer[] brandIds;
	//查选所有的分类和品牌已经选择的分类
	public String getProductTypeListByBrandId(){
		productTypeList = ProductTypeService.findObjects(null);
		brandTypeList = brandTypeService.findObjects(" where o.brandId='"+brandId+"'");
		request.setAttribute("brandId", brandId);
		return SUCCESS;
	}
	//给品牌添加分类
	public void saveBrandType(){
		brandId = brandType.getBrandId().toString();
		brandTypeList = brandTypeService.findObjects(" where o.brandId='"+brandId+"'");
		if(brandTypeList!=null && brandTypeList.size()>0){
			for(BrandType bt : brandTypeList){
				brandTypeService.deleteObjectByParams(" where o.brandTypeId='"+bt.getBrandTypeId()+"'");
			}
			if(productTypeIds!=null && productTypeIds.length>0){
				for(int i=0;i<productTypeIds.length;i++){
					BrandType brandType = new BrandType();
					brandType.setBrandId(Integer.parseInt(brandId));
					brandType.setProductTypeId(productTypeIds[i]);
					brandTypeService.saveOrUpdateObject(brandType);
				}
			}
		}else{
			if(productTypeIds!=null && productTypeIds.length>0){
				for(int i=0;i<productTypeIds.length;i++){
					BrandType brandType = new BrandType();
					brandType.setBrandId(Integer.parseInt(brandId));
					brandType.setProductTypeId(productTypeIds[i]);
					brandTypeService.saveOrUpdateObject(brandType);
				}
			}
		}
	}
	//根据分类查询品牌
	public String gotoBrandListByProductTypeId(){
		request.setAttribute("productTypeId",productTypeId);
		request.setAttribute("level",level);
		return SUCCESS;
	}
	//根据分类ID查询品牌
	 public void listBrandByProductTypeId() throws IOException{
		/*int totalRecordCount = brandService.getCount(", BrandType b where b.productTypeId='"+productTypeId+"' and b.brandId=o.brandId order by b.productTypeId");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Brand> brandList = brandService.findListByPageHelper(null,pageHelper,", BrandType b where b.productTypeId='"+productTypeId+"' and b.brandId=o.brandId order by b.productTypeId");*/
		String selectFlag=request.getParameter("selectFlag");
		String brandName=request.getParameter("brandName");
		String isShow=request.getParameter("isShow");
		String countHql = "select count(bt.brandTypeId) from Brand b, BrandType bt where bt.productTypeId='"+productTypeId+"' and bt.brandId=b.brandId ";
		String hql = "select b.brandId as brandId, bt.brandTypeId as brandTypeId, b.brandName as brandName,bt.isShow as isShow," +
				"b.brandBigImageUrl as brandBigImageUrl,b.isRecommend AS isRecommend,b.isHomePage AS isHomePage from Brand b, BrandType bt where bt.productTypeId='"+productTypeId+"' and bt.brandId=b.brandId ";
		if(Utils.objectIsNotEmpty(selectFlag)){
			if(Utils.objectIsNotEmpty(brandName)){
				hql+=" and b.brandName like'%"+brandName.trim()+"%'";
				countHql+=" and b.brandName like'%"+brandName.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(isShow)){
				hql+=" and bt.isShow ="+isShow;
				countHql+=" and bt.isShow ="+isShow;
			}
		}
		hql+=" order by bt.productTypeId ";
		int totalRecordCount = brandTypeService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> brandList = brandTypeService.findListMapPage(hql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", brandList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	 }
	//删除套餐和分类关系
	 public void deleteBrandType() throws IOException{
		Boolean isSuccess = brandTypeService.deleteObjectByParams(" where o.brandId='"+brandId+"'and o.productTypeId='"+productTypeId+"'");
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	 }
	 /**
	  * 查找所有品牌，除当前分类下已选择的
	  */
	public void findTypeBrand(){
		String hql="";
		 try {
			 /*String sql="SELECT firstWord FROM shop_brand GROUP BY firstWord";
			 List<Map<String, Object>> firstWordList =brandService.findListMapBySql(sql);*/
			 if(Utils.objectIsNotEmpty(id)){
				 hql ="select a.brandId as brandId,a.brandName,a.firstWord from shop_brand a  where a.brandId not in (select x.brandId as oldBrndId from shop_brandtype x where x.productTypeId="+productTypeId+") AND a.firstWord="+"'"+id+"'";
			 }else{
				 hql = "select a.brandId as brandId,a.brandName,a.firstWord from shop_brand a  where a.brandId not in (select x.brandId as oldBrndId from shop_brandtype x where x.productTypeId="+productTypeId+") AND a.firstWord='A'";
			 }
			 list = brandService.findListMapBySql(hql);
//			 String hql = "select a.brandId as brandId,a.brandName,a.firstWord from shop_brand a  where a.brandId not in (select x.brandId as oldBrndId from shop_brandtype x where x.productTypeId="+productTypeId+")";
//			 List<Map<String, Object>> list = brandService.findListMapBySql(hql);
			 Map<String, Object> jsonMap = new HashMap<String, Object>();
			 //jsonMap.put("firstWordList", firstWordList);
			 jsonMap.put("list", list);
			 JSONObject ja = JSONObject.fromObject(jsonMap);
			 response.setContentType("text/html;charset=utf-8");
			 PrintWriter out;
			 out = response.getWriter();
			 out.println(ja.toString());
			 out.flush();
			 out.close();
		 } catch (IOException e) {
			 String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		 }
	 }
	/**
	 * 批量保存品牌和分类关系
	 */
	public void saveMoreBrandType(){
		try {
			boolean flag = true;
			if(brandIds.length>0){
				flag = brandTypeService.saveMoreBrandType(brandIds, Integer.parseInt(productTypeId));
			}
			JSONObject ja = JSONObject.fromObject(flag);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out;
			out = response.getWriter();
			out.println(ja.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 更改显示状态
	 * @throws IOException
	 */
	public void updateIsShowState() throws IOException{
		brandTypeList = brandTypeService.findObjects(" where o.brandTypeId in ("+brandTypeId+")");
		for(BrandType bt:brandTypeList){
			if("1".equals(String.valueOf(bt.getIsShow()))){
				bt.setIsShow(0);
			}else{
				bt.setIsShow(1);
			}
			brandTypeService.saveOrUpdateObject(bt);
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**
	 * 复制分类id上级的所有品牌关联至自己
	 * @throws Exception
     */
	public void copyParentProductType() {
		boolean result = false;
		if (Utils.objectIsNotEmpty(productTypeId)) {
			PrintWriter out = null;
			JSONObject jo = new JSONObject();
			try {
				out = response.getWriter();
				result = brandTypeService.saveCopyParentProductType(Integer.parseInt(productTypeId));
				jo.accumulate("isSuccess", result);
				response.setContentType("text/html;charset=utf-8");
			} catch (Exception e) {
				jo.accumulate("isSuccess", false);
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}

	public List<BrandType> getBrandTypeList() {
		return brandTypeList;
	}
	public void setBrandTypeList(List<BrandType> brandTypeList) {
		this.brandTypeList = brandTypeList;
	}
	public List<ProductType> getProductTypeList() {
		return productTypeList;
	}
	public void setProductTypeList(List<ProductType> productTypeList) {
		this.productTypeList = productTypeList;
	}
	public String getBrandId() {
		return brandId;
	}
	public void setBrandId(String brandId) {
		this.brandId = brandId;
	}
	public Integer[] getProductTypeIds() {
		return productTypeIds;
	}
	public void setProductTypeIds(Integer[] productTypeIds) {
		this.productTypeIds = productTypeIds;
	}
	public BrandType getBrandType() {
		return brandType;
	}
	public void setBrandType(BrandType brandType) {
		this.brandType = brandType;
	}
	public void setBrandTypeService(IBrandTypeService brandTypeService) {
		this.brandTypeService = brandTypeService;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		ProductTypeService = productTypeService;
	}
	public String getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}
	public Integer[] getBrandIds() {
		return brandIds;
	}
	public void setBrandIds(Integer[] brandIds) {
		this.brandIds = brandIds;
	}
	public String getBrandTypeId() {
		return brandTypeId;
	}
	public void setBrandTypeId(String brandTypeId) {
		this.brandTypeId = brandTypeId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public List<Map<String, Object>> getList() {
		return list;
	}
	public void setList(List<Map<String, Object>> list) {
		this.list = list;
	}
	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	
}
