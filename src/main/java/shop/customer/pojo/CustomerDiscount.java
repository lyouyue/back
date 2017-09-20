package shop.customer.pojo;
import java.io.Serializable;
import util.pojo.BaseEntity;
/**
 * 会员折扣实体
 * @author Wsy
 *
 */
public class CustomerDiscount extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -2078193593754642071L;
	private Integer customerDiscountId;//会员折扣ID
	private Integer customerId;//会员Id
	private Integer discountValue;//折扣值
	public Integer getCustomerDiscountId() {
		return customerDiscountId;
	}
	public void setCustomerDiscountId(Integer customerDiscountId) {
		this.customerDiscountId = customerDiscountId;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public Integer getDiscountValue() {
		return discountValue;
	}
	public void setDiscountValue(Integer discountValue) {
		this.discountValue = discountValue;
	}
}
