package shop.product.pojo;
import java.io.Serializable;
import util.pojo.BaseEntity;
/**
 * ProductSpecificationValue - 套餐规格值中间表
 */
public class ProductSpecificationValue extends BaseEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 890897881329359045L;
	private Long psvId;
	/**
	 * 套餐规格值ID
	 */
	private Integer specificationValueId;
	/**
	 * 套餐实体ID
	 */
	private Integer productId;
	/**
	 * 套餐规格ID
	 */
	private Integer specificationId;
	/**
	 * 套餐组ID
	 */
	private Integer goodId;
	/**
	 * 规格图片
	 */
	private String specificationImg;
	public Long getPsvId() {
		return psvId;
	}
	public void setPsvId(Long psvId) {
		this.psvId = psvId;
	}
	public Integer getSpecificationValueId() {
		return specificationValueId;
	}
	public void setSpecificationValueId(Integer specificationValueId) {
		this.specificationValueId = specificationValueId;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public Integer getSpecificationId() {
		return specificationId;
	}
	public void setSpecificationId(Integer specificationId) {
		this.specificationId = specificationId;
	}
	public Integer getGoodId() {
		return goodId;
	}
	public void setGoodId(Integer goodId) {
		this.goodId = goodId;
	}
	public String getSpecificationImg() {
		return specificationImg;
	}
	public void setSpecificationImg(String specificationImg) {
		this.specificationImg = specificationImg;
	}
}
