package phone.back.pojo;

import util.pojo.BaseEntity;
/**
 * 手机端分类
 * 
 *	2014-01-22
 */
public class PhoneHomeCategory extends BaseEntity{
	private static final long serialVersionUID = 1L;
	/**
	 * 分类ID
	 */
	private Integer categoryId;
	/**
	 * 分类名称
	 */
	private String categoryName;
	/**
	 * 分类描述
	 */
	private String categoryDescription;
	/**
	 * 分类图片
	 */
	private String categoryImage;
	/**
	 * 分类更多链接
	 */
	private String moreUrl;
	/**
	 * App分类更多链接
	 */
	private String moreAppUrl;
	/**
	 * 分类类型
	 * 1.首页轮播图  2.首页热销热卖  3.首页分类
	 */
	private Integer categoryType;
	/**
	 * 父分类ID
	 */
	private Integer parentId;
	/**
	 * 是否为叶子
	 * 0为叶子  1非叶子
	 */
	private Integer isLeaf;
	/**
	 * 分类级别
	 */
	private Integer level;
	/**
	 * 排序
	 */
	private Integer sortCode;
	/**
	 * SEO关键字
	 */
	private String keywords;
	/**
	 * 是否显示
	 */
	private Integer isShow;
	//setter getter
	public Integer getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getCategoryDescription() {
		return categoryDescription;
	}
	public void setCategoryDescription(String categoryDescription) {
		this.categoryDescription = categoryDescription;
	}
	public String getCategoryImage() {
		return categoryImage;
	}
	public void setCategoryImage(String categoryImage) {
		this.categoryImage = categoryImage;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public Integer getIsLeaf() {
		return isLeaf;
	}
	public void setIsLeaf(Integer isLeaf) {
		this.isLeaf = isLeaf;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public Integer getSortCode() {
		return sortCode;
	}
	public void setSortCode(Integer sortCode) {
		this.sortCode = sortCode;
	}
	public String getKeywords() {
		return keywords;
	}
	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public String getMoreUrl() {
		return moreUrl;
	}
	public void setMoreUrl(String moreUrl) {
		this.moreUrl = moreUrl;
	}
	public String getMoreAppUrl() {
		return moreAppUrl;
	}
	public void setMoreAppUrl(String moreAppUrl) {
		this.moreAppUrl = moreAppUrl;
	}
	public Integer getCategoryType() {
		return categoryType;
	}
	public void setCategoryType(Integer categoryType) {
		this.categoryType = categoryType;
	}
}
