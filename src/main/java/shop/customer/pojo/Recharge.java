package shop.customer.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 充值记录表
 */
public class Recharge extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -4689963895426369204L;
	/**充值记录ID**/
	private Integer rechargeId;
	/**充值流水号**/
	private String rechargeCode;
	/**用户ID**/
	private Integer customerId;
	/**充值金额**/
	private BigDecimal rechargeAmount;
	/**充值类型 1:支付宝充值 、2:支付宝银联充值、3:快钱充值、4:后台快速充值**/
	private Integer rechargeType;
	/**充值时间**/
	private Date rechargeTime;
	/**状态  默认0：未支付 1：已支付**/
	private Integer state;
	
	public Integer getRechargeId() {
		return rechargeId;
	}
	public void setRechargeId(Integer rechargeId) {
		this.rechargeId = rechargeId;
	}
	public String getRechargeCode() {
		return rechargeCode;
	}
	public void setRechargeCode(String rechargeCode) {
		this.rechargeCode = rechargeCode;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public BigDecimal getRechargeAmount() {
		return rechargeAmount;
	}
	public void setRechargeAmount(BigDecimal rechargeAmount) {
		this.rechargeAmount = rechargeAmount;
	}
	public Integer getRechargeType() {
		return rechargeType;
	}
	public void setRechargeType(Integer rechargeType) {
		this.rechargeType = rechargeType;
	}
	public Date getRechargeTime() {
		return rechargeTime;
	}
	public void setRechargeTime(Date rechargeTime) {
		this.rechargeTime = rechargeTime;
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
}
