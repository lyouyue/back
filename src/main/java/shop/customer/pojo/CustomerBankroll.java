package shop.customer.pojo;

import java.io.Serializable;
import java.math.BigDecimal;

import util.pojo.BaseEntity;
/**
 * 账户资金表
 */
public class CustomerBankroll extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -5013800777227613975L;
	/**账户资金ID**/
	private Integer bankrollId;
	/**用户ID**/
    private Integer customerId;
    /**余额**/
    private BigDecimal balance;
    /**充值余额（充值总和）**/
    private BigDecimal rechargeBalance;
    /**消费总金额**/
    private BigDecimal sumAmount;
    /**已返利金额**/
    private BigDecimal rebateAmount;
    /**金币余额**/
	private BigDecimal mallCoin;

	/**mysql函数统计的实时余额**/
	private BigDecimal balanceNow;
	/**mysql函数统计的实时金币余额**/
	private BigDecimal mallCoinNow;
	/**mysql函数统计的实时充值总余额**/
	private BigDecimal rechargeBalanceNow;

	public Integer getBankrollId() {
		return bankrollId;
	}
	public void setBankrollId(Integer bankrollId) {
		this.bankrollId = bankrollId;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public BigDecimal getBalance() {
		return balance;
	}
	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
	public BigDecimal getRechargeBalance() {
		return rechargeBalance;
	}
	public void setRechargeBalance(BigDecimal rechargeBalance) {
		this.rechargeBalance = rechargeBalance;
	}
	public BigDecimal getSumAmount() {
		return sumAmount;
	}
	public void setSumAmount(BigDecimal sumAmount) {
		this.sumAmount = sumAmount;
	}
	public BigDecimal getRebateAmount() {
		return rebateAmount;
	}
	public void setRebateAmount(BigDecimal rebateAmount) {
		this.rebateAmount = rebateAmount;
	}

	public BigDecimal getMallCoin() {
		return mallCoin;
	}

	public void setMallCoin(BigDecimal mallCoin) {
		this.mallCoin = mallCoin;
	}

	public BigDecimal getBalanceNow() {
		return balanceNow;
	}

	public void setBalanceNow(BigDecimal balanceNow) {
		this.balanceNow = balanceNow;
	}

	public BigDecimal getMallCoinNow() {
		return mallCoinNow;
	}

	public void setMallCoinNow(BigDecimal mallCoinNow) {
		this.mallCoinNow = mallCoinNow;
	}

	public BigDecimal getRechargeBalanceNow() {
		return rechargeBalanceNow;
	}

	public void setRechargeBalanceNow(BigDecimal rechargeBalanceNow) {
		this.rechargeBalanceNow = rechargeBalanceNow;
	}
}
