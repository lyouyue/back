package promotion.pojo;
import java.io.Serializable;
/**
 * 为了满足业务需求封装的套餐名称和折扣价的实体类
 * 
 *
 */
public class ProductDiscount implements Serializable{
	private static final long serialVersionUID = -7795621309190054969L;
	/**
	 * 套餐折扣ID
	 */
	private Integer productDiscountId;
	/**
	 * 套餐ID
	 */
	private Integer productId;
	/**
	 * 套餐名称
	 */
	private String productName;
	/**
	 * 套餐折扣价
	 */
	private Double discount;
	public Integer getProductDiscountId() {
		return productDiscountId;
	}
	public void setProductDiscountId(Integer productDiscountId) {
		this.productDiscountId = productDiscountId;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public Double getDiscount() {
		return discount;
	}
	public void setDiscount(Double discount) {
		this.discount = discount;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
}
