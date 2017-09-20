package shop.prosceniumInstall.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletContext;
import net.sf.json.JSONObject;
import cms.article.pojo.CmsArticle;
import cms.article.service.IArticleService;
import cms.category.pojo.CmsCategory;
import cms.category.service.ICategoryService;
import org.apache.log4j.Logger;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductType;
import shop.product.service.IBrandService;
import shop.product.service.IBrandTypeService;
import shop.product.service.IProductTypeService;
import util.action.BaseAction;
/**
 * LiveUpdateCategoryInfoAction - 实时更新首页分类信息
 */
@SuppressWarnings("serial")
public class LiveUpdateCategoryInfoAction extends BaseAction{
	Logger logger = Logger.getLogger(this.getClass());
	private ICategoryService categoryService;//引用文章分类Service
	private IProductTypeService productTypeService;//套餐分类Service
	private IBrandTypeService brandTypeService;//品牌和分类Service
	private IBrandService brandService;//品牌Service
	@SuppressWarnings("unchecked")
	private Map categoryMap = new LinkedHashMap();//套餐分类
	@SuppressWarnings("unchecked")
	private Map categoryBrandMap = new LinkedHashMap();//套餐分类下的品牌
	private List<ProductType> productTypeList = new ArrayList<ProductType>();//套餐分类List
	/** 底部文章集合 **/
	private IArticleService articleService;//引用文章Service
	//跳转到更新基础信息页面
	public String gotoUpdateInfoPage(){
		return SUCCESS;
	}
	/**
	 * 更新首页分类信息方法
	 */
	public void updateCategoryInfo(){
		//产品分类,1级
		productTypeList = productTypeService.findObjects(" where o.isShow=1 and o.parentId=1");
		//产品分类2级
		for(ProductType pt : productTypeList){
			List<Brand> brandList = new ArrayList<Brand>();
			Map seondMap  = new LinkedHashMap();
			//获取二级
			List<ProductType> secondProductTypeList = productTypeService.findObjects(" where o.parentId='"+pt.getProductTypeId()+"' and o.isShow=1");
			pt.setChildProductType(secondProductTypeList);
			//查找三级
			for(ProductType spt : secondProductTypeList){
				List<ProductType> thirdProductTypeList = productTypeService.findObjects(" where o.parentId='"+spt.getProductTypeId()+"' and o.isShow=1");
				spt.setChildProductType(thirdProductTypeList);
				seondMap.put(spt, thirdProductTypeList);
			}
			//查询一级分类下的品牌信息
			List<BrandType> brandTypeList = brandTypeService.findSome(0, 3, " where o.productTypeId='"+pt.getProductTypeId()+"' and o.isShow=1");
			if(brandTypeList!=null && brandTypeList.size()>0){
				for(BrandType bt : brandTypeList){
					Brand brand = (Brand) brandService.getObjectByParams(" where o.brandId='"+bt.getBrandId()+"'");
					brandList.add(brand);
//					if(brandList.size()==3){
//						break;
//					}
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
		String isSuccess = "";
		if(servletContext!=null){
			isSuccess = "success";
		}else{
			isSuccess = "fail";
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter ot;
		try {
			ot = response.getWriter();
			ot.println(jo.toString());
			ot.flush();
			ot.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 全局底部文章加载
	 */
	public void findFooterArticle(){
		Map<String,List<CmsArticle>> footrtArticleMap = new LinkedHashMap<String,List<CmsArticle>>();
		List<CmsCategory>  cmsCategoryList = categoryService.findObjects(" where o.parentId = 92 ");
		for(CmsCategory cmsCategory : cmsCategoryList){
			List<CmsArticle> cmsArticlesList = articleService.findObjects("where o.isShow = 1 and o.categoryId = "+cmsCategory.getCategoryId());
			String str = cmsCategory.getCategoryName();
			footrtArticleMap.put(str, cmsArticlesList);
		}
		servletContext.setAttribute("footrtArticleMap", footrtArticleMap);
		String isSuccess = "";
		if(servletContext!=null){
			isSuccess = "success";
		}else{
			isSuccess = "fail";
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter ot;
		try {
			ot = response.getWriter();
			ot.println(jo.toString());
			ot.flush();
			ot.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
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
	public void setCategoryService(ICategoryService categoryService) {
		this.categoryService = categoryService;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public void setBrandTypeService(IBrandTypeService brandTypeService) {
		this.brandTypeService = brandTypeService;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}
	public void setArticleService(IArticleService articleService) {
		this.articleService = articleService;
	}
}
