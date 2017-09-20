package shop.product.pojo;
import java.io.Serializable;
import util.pojo.BaseEntity;
/**
 * 品牌和分类实体类
 * 
 *
 */
public class BrandType extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 3763080673077880478L;
	/**
	 * 品牌分类ID
	 */
	private Integer brandTypeId;
	/**
	 * 品牌ID
	 */
	private Integer brandId;
	/**
	 * 分类ID
	 */
	private Integer productTypeId;
	/**
	 * 是否显示
	 */
	private Integer isShow;
	public Integer getBrandTypeId() {
		return brandTypeId;
	}
	public void setBrandTypeId(Integer brandTypeId) {
		this.brandTypeId = brandTypeId;
	}
	public Integer getBrandId() {
		return brandId;
	}
	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}
	public Integer getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(Integer productTypeId) {
		this.productTypeId = productTypeId;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
}
