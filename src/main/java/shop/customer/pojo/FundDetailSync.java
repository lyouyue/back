package shop.customer.pojo;

import util.pojo.BaseEntity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 资金流水明细表同步表
 */
public class FundDetailSync extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 3650767127452328391L;
	/**资金流水明细ID**/
	private Integer fundId;
	/**用户ID**/
	private Integer customerId;
	/**订单号 **/
	private String ordersNo;
	/**明细流水号**/
	private String fundDetailsCode;
	/**金额**/
	private BigDecimal amount;
	/**消费类型 1收入 2支出**/
	private Integer fundDetailsType;
	/**交易时间**/
	private Date transactionTime;
	/**来源【1充值，2返利，3余额消费，4提现】**/
	private Integer source;
	/**同步状态[1 未同步,2 已同步]**/
	private Integer status;

	public Integer getFundId() {
		return fundId;
	}
	public void setFundId(Integer fundId) {
		this.fundId = fundId;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public String getOrdersNo() {
		return ordersNo;
	}
	public void setOrdersNo(String ordersNo) {
		this.ordersNo = ordersNo;
	}
	public String getFundDetailsCode() {
		return fundDetailsCode;
	}
	public void setFundDetailsCode(String fundDetailsCode) {
		this.fundDetailsCode = fundDetailsCode;
	}
	public BigDecimal getAmount() {
		return amount;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public Integer getFundDetailsType() {
		return fundDetailsType;
	}
	public void setFundDetailsType(Integer fundDetailsType) {
		this.fundDetailsType = fundDetailsType;
	}
	public Date getTransactionTime() {
		return transactionTime;
	}
	public void setTransactionTime(Date transactionTime) {
		this.transactionTime = transactionTime;
	}

	public Integer getSource() {
		return source;
	}

	public void setSource(Integer source) {
		this.source = source;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}
}
