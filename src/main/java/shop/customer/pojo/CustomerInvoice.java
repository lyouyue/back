package shop.customer.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 发票实体类
 * @author 张丁方
 * 2016-07-29
 */
public class CustomerInvoice  extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -8404926787106114244L;
	/**
	 * 发票Id
	 */
	private Integer invoiceId;
	/**
	 * 用户id
	 */
	private Integer customerId;
	/**
	 * 用户名称
	 */
	private String customerName;
	/**
	 * 发票类型：发票类型：1不开发票(数据表中不会出现此数据，只与前端保持一致)；2普通发票；3增值税发票；
	 */
	private Integer invoiceType;
	/**
	 * 发票状态：1表示默认,0表示不默认
	 */
	private Integer invoiceStatue;
	/**
	 * 发票抬头
	 */
	private String invoiceTitle;
	/**
	 * 发票内容
	 */
	private String invoiceInfo;
	/**
	 * 单位名称
	 */
	private String companyName;
	/**
	 * 纳税人识别码
	 */
	private String taxpayerIdentificationCode;
	/**
	 * 注册地址
	 */
	private String registeredAddress;
	/**
	 * 注册电话
	 */
	private String registerePhone;
	/**
	 * 开户银行
	 */
	private String depositBank;
	/**
	 * 银行账户
	 */
	private String bankAccount;
	/**
	 * 收票人姓名
	 */
	private String checkTakerName;
	/**
	 * 收票人电话
	 */
	private String checkTakerPhone;
	/**
	 * 收票地址
	 */
	private String checkTakerAddress;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**
	 *修改时间
	 */
	private Date updateTime;

	public Integer getInvoiceId() {
		return invoiceId;
	}
	public void setInvoiceId(Integer invoiceId) {
		this.invoiceId = invoiceId;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public Integer getInvoiceType() {
		return invoiceType;
	}
	public void setInvoiceType(Integer invoiceType) {
		this.invoiceType = invoiceType;
	}
	public String getInvoiceTitle() {
		return invoiceTitle;
	}
	public void setInvoiceTitle(String invoiceTitle) {
		this.invoiceTitle = invoiceTitle;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getTaxpayerIdentificationCode() {
		return taxpayerIdentificationCode;
	}
	public void setTaxpayerIdentificationCode(String taxpayerIdentificationCode) {
		this.taxpayerIdentificationCode = taxpayerIdentificationCode;
	}
	public String getRegisteredAddress() {
		return registeredAddress;
	}
	public void setRegisteredAddress(String registeredAddress) {
		this.registeredAddress = registeredAddress;
	}
	public String getRegisterePhone() {
		return registerePhone;
	}
	public void setRegisterePhone(String registerePhone) {
		this.registerePhone = registerePhone;
	}
	public String getDepositBank() {
		return depositBank;
	}
	public void setDepositBank(String depositBank) {
		this.depositBank = depositBank;
	}
	public String getBankAccount() {
		return bankAccount;
	}
	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}
	public String getCheckTakerName() {
		return checkTakerName;
	}
	public void setCheckTakerName(String checkTakerName) {
		this.checkTakerName = checkTakerName;
	}
	public String getCheckTakerPhone() {
		return checkTakerPhone;
	}
	public void setCheckTakerPhone(String checkTakerPhone) {
		this.checkTakerPhone = checkTakerPhone;
	}
	public String getCheckTakerAddress() {
		return checkTakerAddress;
	}
	public void setCheckTakerAddress(String checkTakerAddress) {
		this.checkTakerAddress = checkTakerAddress;
	}
	public Integer getInvoiceStatue() {
		return invoiceStatue;
	}
	public void setInvoiceStatue(Integer invoiceStatue) {
		this.invoiceStatue = invoiceStatue;
	}

	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getInvoiceInfo() {
		return invoiceInfo;
	}

	public void setInvoiceInfo(String invoiceInfo) {
		this.invoiceInfo = invoiceInfo;
	}

	/**
	 * 项目类型
	 * */
	public static enum InvoiceType {
		InvoiceTypeNOT("不要发票", 1),
		InvoiceTypeGeneral("普通发票",2),
		InvoiceTypeVAT("增值税发票",3);
		// 成员变量
		private String name;
		private int value;
		// 构造方法
		private InvoiceType(String name, int value) {
			this.name = name;
			this.value = value;
		}
		// 普通方法
		public static String getName(int index) {
			for (InvoiceType s : InvoiceType.values()) {
				if (s.getValue()==index) {
					return s.name;
				}
			}
			return null;
		}
		// get set 方法
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public int getValue() {
			return value;
		}
		public void setValue(int value) {
			this.value = value;
		}
	}
}