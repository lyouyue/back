package util.other;

import java.util.List;

import shop.product.pojo.Brand;
/**
 * ProductTypeBean：套餐分类实体bean的封装，用于所有分类展示
 * @author 
 *
 */
public class AllProductTypeBean {
	//父分类ID
	private Integer productTypeId;
	//父分类名称
	private String sortName;
	//图片路径
	private String categoryImage;
	//子类集合（直接是本身对象集合）
	private List<AllProductTypeBean> productTypeList;
	/**套餐品牌集合**/
	private List<Brand> brandList;
	/**分类等级**/
	private Integer level;
	/**分类父ID**/
	private Integer parentId;
	/**加载类型**/
	private String loadType;//1:叶子   2：非叶子
	
	public Integer getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(Integer productTypeId) {
		this.productTypeId = productTypeId;
	}
	public String getSortName() {
		return sortName;
	}
	public void setSortName(String sortName) {
		this.sortName = sortName;
	}
	public String getCategoryImage() {
		return categoryImage;
	}
	public void setCategoryImage(String categoryImage) {
		this.categoryImage = categoryImage;
	}
	public List<AllProductTypeBean> getProductTypeList() {
		return productTypeList;
	}
	public void setProductTypeList(List<AllProductTypeBean> productTypeList) {
		this.productTypeList = productTypeList;
	}
	public Integer getLevel() {
		return level;
	}
	public void setLevel(Integer level) {
		this.level = level;
	}
	public List<Brand> getBrandList() {
		return brandList;
	}
	public void setBrandList(List<Brand> brandList) {
		this.brandList = brandList;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public String getLoadType() {
		return loadType;
	}
	public void setLoadType(String loadType) {
		this.loadType = loadType;
	}
}