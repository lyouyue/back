package util.init;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.context.ServletContextAware;

import phone.back.pojo.PhoneKeyBook;
import phone.back.service.IPhoneKeyBookService;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductType;
import shop.product.service.IBrandService;
import shop.product.service.IBrandTypeService;
import shop.product.service.IProductTypeService;
import util.other.Utils;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.util.wx.WXBasicUtil;
import basic.pojo.KeyBook;
import basic.pojo.SystemConfig;
import basic.service.IKeyBookService;
import basic.service.ISystemConfigService;
import cms.article.service.IArticleService;
import cms.category.service.ICategoryService;
/**
 * 项目初始化加载数据字典
 */
@SuppressWarnings({"unused","rawtypes"})
public class InitializingKeyBook implements InitializingBean , ServletContextAware {
	//servlet 上下文
	private ServletContext servletContext;
	//keyBookService
	private IKeyBookService keyBookService;
	/**底部文章集合 **/
	private IArticleService articleService;//引用文章Service
	private ICategoryService categoryService;//引用文章分类Service
	private IProductTypeService productTypeService;//套餐分类Service
	private IBrandTypeService brandTypeService;//品牌和分类Service
	private IBrandService brandService;//品牌Service
	private Map categoryMap = new LinkedHashMap();//套餐分类
	private Map categoryBrandMap = new LinkedHashMap();//套餐分类下的品牌
	private List<ProductType> productTypeList = new ArrayList<ProductType>();//套餐分类List
	private IPhoneKeyBookService phoneKeyBookService;
	/**微信基础信息Service**/
	private IPublicNoInfoService publicNoInfoService;
	/**基础设置Service**/
	private ISystemConfigService systemConfigService;

	/**
	 * 项目初始化加载数据字典
	 *
	 * */
	@SuppressWarnings("unchecked")
	public void afterPropertiesSet() throws Exception {
		if (servletContext != null) {
			Map<String,List<KeyBook>> keybook = new HashMap<String,List<KeyBook>>();
			List<String> typeNameList = keyBookService.distinctType("type", "");//查找类型名称
			if (Utils.objectIsNotEmpty(typeNameList) && typeNameList.size() > 0) {
				for(String typeName : typeNameList){
					List<KeyBook> keyBookList = keyBookService.findObjects(" where o.type = '"+typeName+"' order by o.value asc");//根据类型名称查出对象集合
					keybook.put(typeName, keyBookList);
				}
			}
			servletContext.setAttribute("keybook", keybook);
			if (servletContext != null) {
				List<ProductType> categoryList = new ArrayList<ProductType>();
				//一级分类集合
				productTypeList = productTypeService.findObjects(" where o.isShow=1 and o.parentId=1 order by o.sortCode");
				if (Utils.objectIsNotEmpty(productTypeList) && productTypeList.size() > 0) {
					for (ProductType pt : productTypeList) {
						List<Brand> brandList = new ArrayList<Brand>();
						Map seondMap = new LinkedHashMap();
						//二级分类集合
						List<ProductType> secondProductTypeList = productTypeService.findObjects(" where o.parentId='" + pt.getProductTypeId() + "' and o.isShow=1");
						pt.setChildProductType(secondProductTypeList);
						for (ProductType spt : secondProductTypeList) {
							Map thirdMap = new LinkedHashMap();
							//三级分类集合
							List<ProductType> thirdProductTypeList = productTypeService.findObjects(" where o.parentId='" + spt.getProductTypeId() + "' and o.isShow=1");
							spt.setChildProductType(thirdProductTypeList);
							for (ProductType tpt : thirdProductTypeList) {
								//四级分类集合
								List<ProductType> fourProductTypeList = productTypeService.findObjects(" where o.parentId='" + tpt.getProductTypeId() + "' and o.isShow=1");
								tpt.setChildProductType(fourProductTypeList);
								thirdMap.put(tpt, fourProductTypeList);
							}
							seondMap.put(spt, thirdMap);
						}
						List<BrandType> brandTypeList = brandTypeService.findSome(0, 5, " where o.productTypeId='" + pt.getProductTypeId() + "' and o.isShow=1");
						if (brandTypeList != null && brandTypeList.size() > 0) {
							for (BrandType bt : brandTypeList) {
								Brand brand = (Brand) brandService.getObjectByParams(" where o.brandId='" + bt.getBrandId() + "' and o.isShow=1");
								if (brand != null && brand.getBrandId() != null) {
									brandList.add(brand);
								}
							}
						}
						categoryMap.put(pt, seondMap);
						categoryBrandMap.put(pt, brandList);
						pt.setBrandList(brandList);
					}
				}
				servletContext.setAttribute("categoryMap", categoryMap);
				servletContext.setAttribute("categoryList", productTypeList);
				servletContext.setAttribute("categoryBrandMap", categoryBrandMap);
				productTypeList = productTypeService.findObjects(" where o.parentId not in(0)");
				servletContext.setAttribute("productTypeList", productTypeList);
			}
			//加载手机端数据字典
			Map<String, List<PhoneKeyBook>> initPhoneKeyBooke = initPhoneKeyBooke();
			servletContext.setAttribute("phonekeybook", initPhoneKeyBooke);
			//初始化基础设置
			initSystemConfig();
			SystemConfig systemConfig = (SystemConfig) systemConfigService.getObjectByParams(" where o.type = 'access_token' ");
			if(Utils.objectIsNotEmpty(systemConfig) && "true".equals(systemConfig.getValue())){
				//加载微信基础信息
				List<PublicNoInfo> pList = publicNoInfoService.findObjects(null, null);
				if(Utils.objectIsNotEmpty(pList)&&pList.size()>0){
					PublicNoInfo publicNoInfo = pList.get(0);
					servletContext.setAttribute("publicNoInfo",publicNoInfo);
					Map<Object, Object> pMap=new HashMap<Object, Object>();
					for(PublicNoInfo p:pList){
						String accessToken = WXBasicUtil.getAccessToken(p.getAppId(), p.getAppSecret());
						pMap.put(p.getToUserName(), accessToken);
//					System.out.println(accessToken);
					}
					pMap.put("atTime", new Date());
					servletContext.setAttribute("accessTokens", pMap);
					String access_token = (String) pMap.get(publicNoInfo.getToUserName());
					String ticket = WXBasicUtil.getTicket(access_token);
					servletContext.setAttribute("ticket", ticket);
				}
			}
		}
	}

	/**
	 * 初始化加载手机数据字典
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, List<PhoneKeyBook>> initPhoneKeyBooke(){
		Map<String,List<PhoneKeyBook>> map = new HashMap<String,List<PhoneKeyBook>>();
		List<String> typeNameList = phoneKeyBookService.distinctType("type", "");//查找类型名称
		if (Utils.objectIsNotEmpty(typeNameList) && typeNameList.size() > 0) {
			for (String typeName : typeNameList) {
				List<PhoneKeyBook> homeKeyBookList = phoneKeyBookService.findObjects(null, " where o.type = '" + typeName + "' order by o.homeKeyBookId asc ");//根据类型名称查出对象集合
				map.put(typeName, homeKeyBookList);
			}
		}
		return map;
	}

	/**
	 * 初始化基础设置
	 */
	@SuppressWarnings("unchecked")
	public void initSystemConfig(){
		//全局基础设置
		Map<String,String> systemConfigFile = new HashMap<String,String>();
		List<SystemConfig> systemConfigList = systemConfigService.findObjects(null," order by o.id desc");
		if (Utils.objectIsNotEmpty(systemConfigList) && systemConfigList.size() > 0) {
			for (SystemConfig s : systemConfigList) {
				String key = s.getType();
				String value = s.getValue();
				systemConfigFile.put(key, value);
			}
		}
		servletContext.setAttribute("fileUrlConfig", systemConfigFile);
	}

	public IKeyBookService getKeyBookService() {
		return keyBookService;
	}
	public void setKeyBookService(IKeyBookService keyBookService) {
		this.keyBookService = keyBookService;
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
	public void setArticleService(IArticleService articleService) {
		this.articleService = articleService;
	}
	public void setCategoryService(ICategoryService categoryService) {
		this.categoryService = categoryService;
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
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public void setBrandTypeService(IBrandTypeService brandTypeService) {
		this.brandTypeService = brandTypeService;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}
	public void setPhoneKeyBookService(IPhoneKeyBookService phoneKeyBookService) {
		this.phoneKeyBookService = phoneKeyBookService;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}
	public void setSystemConfigService(ISystemConfigService systemConfigService) {
		this.systemConfigService = systemConfigService;
	}
}