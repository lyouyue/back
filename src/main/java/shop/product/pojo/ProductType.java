package shop.product.pojo;
import java.io.Serializable;
import java.util.List;
import util.pojo.BaseEntity;
/**
 * 套餐分类实体类
 * 
 *
 */
public class ProductType extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 85976351945939995L;
	/**
	 * 
	 */
	private Integer productTypeId;//套餐分类ID
	/**
	 * 父ID
	 */
	private Integer parentId;
	/**
	 * 编号
	 */
	private String sortCode;
	/**
	 * 名称
	 */
	private String sortName;
	/**
	 * App名称
	 */
	private String sortAppName;
	/**
	 * 是否显示
	 * 0:不显示
	 * 1：显示
	 */
	private Integer isShow;
	/**
	 * 是否推荐
	 * 0:不推荐
	 * 1：推荐
	 */
	private Integer isRecommend;
	/**
	 * 分类图片
	 */
	private String categoryImage;
	/**
	 * 微信端分类图片
	 */
	private String categoryImageWx;
	/**
	 * App端分类图片
	 */
	private String categoryImageApp;
	/**
	 * 分类描述
	 */
	private String categoryDescription;
	/**
	 * 是否为叶子节点
	 */
	private String loadType;
	/**
	 * 所属级别
	 */
	private Integer level;
	/**
	 * 行业专用
	 */
	private Integer industrySpecific;
	private List<ProductType> childProductType;
	private List<Brand> brandList;
	//多级套餐分类名称（ 不对应数据库字段）
	private String prodTypeNames;
	
	public Integer getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(Integer productTypeId) {
		this.productTypeId = productTypeId;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public String getSortCode() {
		return sortCode;
	}
	public void setSortCode(String sortCode) {
		this.sortCode = sortCode;
	}
	public String getSortName() {
		return sortName;
	}
	public void setSortName(String sortName) {
		this.sortName = sortName;
	}
	public String getSortAppName() {
		return sortAppName;
	}
	public void setSortAppName(String sortAppName) {
		this.sortAppName = sortAppName;
	}
	public String getLoadType() {
		return loadType;
	}
	public void setLoadType(String loadType) {
		this.loadType = loadType;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public Integer getIsRecommend() {
		return isRecommend;
	}
	public void setIsRecommend(Integer isRecommend) {
		this.isRecommend = isRecommend;
	}
	public String getCategoryImage() {
		return categoryImage;
	}
	public void setCategoryImage(String categoryImage) {
		this.categoryImage = categoryImage;
	}
	public String getCategoryDescription() {
		return categoryDescription;
	}
	public void setCategoryDescription(String categoryDescription) {
		this.categoryDescription = categoryDescription;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public List<ProductType> getChildProductType() {
		return childProductType;
	}
	public void setChildProductType(List<ProductType> childProductType) {
		this.childProductType = childProductType;
	}
	public List<Brand> getBrandList() {
		return brandList;
	}
	public void setBrandList(List<Brand> brandList) {
		this.brandList = brandList;
	}
	public Integer getIndustrySpecific() {
		return industrySpecific;
	}
	public void setIndustrySpecific(Integer industrySpecific) {
		this.industrySpecific = industrySpecific;
	}
	public String getCategoryImageWx() {
		return categoryImageWx;
	}
	public void setCategoryImageWx(String categoryImageWx) {
		this.categoryImageWx = categoryImageWx;
	}
	public String getCategoryImageApp() {
		return categoryImageApp;
	}
	public void setCategoryImageApp(String categoryImageApp) {
		this.categoryImageApp = categoryImageApp;
	}
	public String getProdTypeNames() {
		return prodTypeNames;
	}
	public void setProdTypeNames(String prodTypeNames) {
		this.prodTypeNames = prodTypeNames;
	}
	
}
