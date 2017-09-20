package shop.order.pojo;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 订单bean
 * @author 张攀攀
 *
 */
public class Orders extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 438406933695362923L;
	/**
	 * 订单Id
	 */
	private Integer ordersId;
	/**
	 * 客户Id
	 */
	private Integer customerId;
	/**
	 * 采购员id
	 */
	private Integer sonaccountId;
	/**
	 * 店铺id
	 */
	private Integer shopInfoId;
	/**
	 * 采购员姓名
	 */
	private String buyerName;
	/**
	 * 总订单号
	 */
	private String totalOrdersNo;
	/**
	 * 订单号
	 */
	private String ordersNo;
	/**
	 * 支付交易号
	 */
	private String dealId;
	/**
	 * 订单生成时间
	 */
	private Date createTime;
	/**
	 * 订单修改时间
	 */
	private Date updateTime;
	/**
	 * 州省地区
	 */
	private String regionLocation;
	/**
	 * 城市
	 */
	private String city;
	/**
	 * 国家
	 */
	private String country;
	/**
	 * 详细地址
	 */
	private String address;
	/**
	 * 收获人姓名
	 */
	private String consignee;
	/**
	 * 电子邮件
	 */
	private String email;
	/**
	 * 邮政编码
	 */
	private String postcode;
	/**
	 * 最佳配送时间(
	 * 1.只工作日送货(双休日、假日不用送);
	 * 2.工作日、双休日与假日均可送货;
	 * 3.只双休日、假日送货(工作日不用送)
	 * )
	 */
	private Integer bestSendDate;
	/**
	 * 标志性建筑
	 */
	private String flagContractor;
	/**
	 * 电话
	 */
	private String phone;
	/**
	 * 手机
	 */
	private String mobilePhone;
	/**
	 * 配送方式
	 * 1、快递公司
	 */
	private Integer sendType;
	/**
	 * 支付方式
	 * (1、货到付款 2、支付宝 3、银行汇款)
	 */
	private Integer payMode;
	/**
	 * 套餐总金额
	 */
	private BigDecimal totalAmount;
	/**
	 * 最终支付金额
	 */
	private BigDecimal finalAmount;
	/**
	 * 运费
	 */
	private BigDecimal freight;
	/**
	 * 是否使用优惠卷
	 * 0、否,1、是
	 */
	private Integer isUseCoupon;
	/**
	 * 用户优惠券ID
	 */
	private Integer customerDiscountCouponID;
	/**
	 * 订单使用优惠券金额
	 */
	private BigDecimal orderCouponAmount;
	/**
	 * 订单附言
	 */
	private String comments;
	/**
	 * 购买人IP
	 */
	private String ip;
	/**
	 * 货币类型
	 */
	private String currency;
	/**
	 * 订单状态
	 * (0、未处理(生成订单)；3、正在配货；4、已发货；5、已收货；6、订单取消；7、异常订单(退换货等、问题订单)；9、已评价；)
	 */
	private Integer ordersState;
	/**
	 * 缺货处理
	 * (1、等待所有套餐备齐后再发；2、取消订单；3、与店主协商；)
	 */
	private Integer oosOperator;
	/**
	 * 锁定操作
	 * (0：未锁定；1：已锁定)
	 */
	private Integer isLocked;
	/**
	 * 订单备注（客服留言）
	 */
	private String ordersRemark;
	/**
	 * 订单赠送金币总额
	 */
	private BigDecimal virtualCoin;
	/**使用金币数量**/
	private BigDecimal userCoin;
	/***金币兑换金额**/
	private BigDecimal changeAmount;
	/**
	 * 订单赠送金币总额
	 */
	private BigDecimal virtualCoinNumber;
	/**
	 * 已使用授信额度
	 */
	private BigDecimal useLineOfCredit;
	/**
	 * 是否开发票
	 */
	private Integer isInvoice;
	/**
	 * 发票企业名称
	 */
	private String companyNameForInvoice;
	/**
	 * 纳税人识别号
	 */
	private String taxpayerNumber;
	/**
	 * 发票地址
	 */
	private String addressForInvoice;
	/**
	 * 发票电话
	 */
	private String phoneForInvoice;
	/**
	 * 开户行
	 */
	private String openingBank;
	/**
	 * 账号
	 */
	private String bankAccountNumber;
	/**
	 * (买家)结算状态
	 */
	private Integer settlementStatus;
	/**
	 * (卖家)结算状态
	 */
	private Integer settlementStatusForSellers;
	/**
	 * 发票类型
	 */
	private Integer invoiceType;//1：不开发票;2：普通发票;3：增值税发票
	/**
	 * 发票内容
	 */
	private String invoiceInfo;
	/**
	 * 下单人类型
	 */
	private Integer customerType;
	/**
	 * 折扣比例
	 */
	private BigDecimal discount;
	/**
	 * 银行简码
	 */
	private String bankCode;
	/**
	 * 配送方式1:快递配送，2：线下自取
	 */
	private Integer distributionMode;
	/**
	 * 税费
	 */
	private BigDecimal taxation;
	/**
	 * 订单来源：1：普通正常下单；2：团购下单;3手机普通正常下单；4：手机团购下单；5：app普通下单
	 */
	private Integer orderSource;
	/**
	 * 会员折扣金额
	 */
	private BigDecimal membersDiscountPrice;
	/**
	 * 是否有退货
	 */
	private Integer isReturn;
	/**
	 * 是否返利
	 */
	private Integer isRebate;
	/**
	 * 一级返利总金额（以百为单位）
	 */
	private BigDecimal rebateAmount;
	/**
	 * 上二级返利总金额（以百为单位）
	 */
	private BigDecimal secRebateAmount;
	/**
	 * 上三级返利总金额（以百为单位）
	 */
	private BigDecimal thiRebateAmount;

	private BigDecimal	platPresentCoin;    		//	平台赠送积分
	private BigDecimal	birthMonthDiscount;    		//	生日月折扣值(以100为单位)
	private BigDecimal	birthMonthDiscountPrice;    //	生日月折扣减少总金额
	private Integer	customerLevel;    				//	会员等级
	private BigDecimal	platPromotionDiscountPrice; //	平台促销折扣减少总金额
	private BigDecimal	vipDeductionPrice;    		//	店铺VIP会员折扣减少总金额
	private BigDecimal	vipDiscount;    			//	店铺VIP会员折扣(以100为单位)

	/**
	 * 平台抽取营业额让利金额(不对应数据库字段)
	 */
	private BigDecimal rakeAmount;
	/**
	 * 退货返还财富券总金额(不对应数据库字段)
	 */
	private BigDecimal changeAmountTotal;
	/**
	 * 退货返还总金额(不对应数据库字段)
	 */
	private BigDecimal returnAmountTotal;
	private String useCouponsId;
	private String jgOrdersNo;
	
	public String getUseCouponsId() {
		return useCouponsId;
	}
	public void setUseCouponsId(String useCouponsId) {
		this.useCouponsId = useCouponsId;
	}
	public String getJgOrdersNo() {
		return jgOrdersNo;
	}
	public void setJgOrdersNo(String jgOrdersNo) {
		this.jgOrdersNo = jgOrdersNo;
	}
	public Integer getOrdersId() {
		return ordersId;
	}
	public void setOrdersId(Integer ordersId) {
		this.ordersId = ordersId;
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
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getRegionLocation() {
		return regionLocation;
	}
	public void setRegionLocation(String regionLocation) {
		this.regionLocation = regionLocation;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getConsignee() {
		return consignee;
	}
	public void setConsignee(String consignee) {
		this.consignee = consignee;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getMobilePhone() {
		return mobilePhone;
	}
	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}
	public String getFlagContractor() {
		return flagContractor;
	}
	public void setFlagContractor(String flagContractor) {
		this.flagContractor = flagContractor;
	}
	public Integer getSendType() {
		return sendType;
	}
	public void setSendType(Integer sendType) {
		this.sendType = sendType;
	}
	public Integer getPayMode() {
		return payMode;
	}
	public void setPayMode(Integer payMode) {
		this.payMode = payMode;
	}
	public BigDecimal getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}
	public BigDecimal getFinalAmount() {
		return finalAmount;
	}
	public void setFinalAmount(BigDecimal finalAmount) {
		this.finalAmount = finalAmount;
	}
	public BigDecimal getFreight() {
		return freight;
	}
	public void setFreight(BigDecimal freight) {
		this.freight = freight;
	}
	public Integer getIsUseCoupon() {
		return isUseCoupon;
	}
	public void setIsUseCoupon(Integer isUseCoupon) {
		this.isUseCoupon = isUseCoupon;
	}
	public String getCurrency() {
		return currency;
	}
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public Integer getOosOperator() {
		return oosOperator;
	}
	public void setOosOperator(Integer oosOperator) {
		this.oosOperator = oosOperator;
	}
	public Integer getBestSendDate() {
		return bestSendDate;
	}
	public void setBestSendDate(Integer bestSendDate) {
		this.bestSendDate = bestSendDate;
	}
	public Integer getIsLocked() {
		return isLocked;
	}
	public void setIsLocked(Integer isLocked) {
		this.isLocked = isLocked;
	}
	public Integer getOrdersState() {
		return ordersState;
	}
	public void setOrdersState(Integer ordersState) {
		this.ordersState = ordersState;
	}
	public String getOrdersRemark() {
		return ordersRemark;
	}
	public void setOrdersRemark(String ordersRemark) {
		this.ordersRemark = ordersRemark;
	}
	public Integer getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(Integer shopInfoId) {
		this.shopInfoId = shopInfoId;
	}
	public BigDecimal getVirtualCoin() {
		return virtualCoin;
	}
	public void setVirtualCoin(BigDecimal virtualCoin) {
		this.virtualCoin = virtualCoin;
	}
	public String getTotalOrdersNo() {
		return totalOrdersNo;
	}
	public void setTotalOrdersNo(String totalOrdersNo) {
		this.totalOrdersNo = totalOrdersNo;
	}
	public BigDecimal getUserCoin() {
		return userCoin;
	}
	public void setUserCoin(BigDecimal userCoin) {
		this.userCoin = userCoin;
	}
	public BigDecimal getChangeAmount() {
		return changeAmount;
	}
	public void setChangeAmount(BigDecimal changeAmount) {
		this.changeAmount = changeAmount;
	}
	public BigDecimal getUseLineOfCredit() {
		return useLineOfCredit;
	}
	public void setUseLineOfCredit(BigDecimal useLineOfCredit) {
		this.useLineOfCredit = useLineOfCredit;
	}
	public Integer getSonaccountId() {
		return sonaccountId;
	}
	public void setSonaccountId(Integer sonaccountId) {
		this.sonaccountId = sonaccountId;
	}
	public String getBuyerName() {
		return buyerName;
	}
	public void setBuyerName(String buyerName) {
		this.buyerName = buyerName;
	}
	public String getCompanyNameForInvoice() {
		return companyNameForInvoice;
	}
	public void setCompanyNameForInvoice(String companyNameForInvoice) {
		this.companyNameForInvoice = companyNameForInvoice;
	}
	public String getAddressForInvoice() {
		return addressForInvoice;
	}
	public void setAddressForInvoice(String addressForInvoice) {
		this.addressForInvoice = addressForInvoice;
	}
	public String getPhoneForInvoice() {
		return phoneForInvoice;
	}
	public void setPhoneForInvoice(String phoneForInvoice) {
		this.phoneForInvoice = phoneForInvoice;
	}
	public String getOpeningBank() {
		return openingBank;
	}
	public void setOpeningBank(String openingBank) {
		this.openingBank = openingBank;
	}
	public String getTaxpayerNumber() {
		return taxpayerNumber;
	}
	public void setTaxpayerNumber(String taxpayerNumber) {
		this.taxpayerNumber = taxpayerNumber;
	}
	public String getBankAccountNumber() {
		return bankAccountNumber;
	}
	public void setBankAccountNumber(String bankAccountNumber) {
		this.bankAccountNumber = bankAccountNumber;
	}
	public Integer getSettlementStatus() {
		return settlementStatus;
	}
	public void setSettlementStatus(Integer settlementStatus) {
		this.settlementStatus = settlementStatus;
	}
	public Integer getSettlementStatusForSellers() {
		return settlementStatusForSellers;
	}
	public void setSettlementStatusForSellers(Integer settlementStatusForSellers) {
		this.settlementStatusForSellers = settlementStatusForSellers;
	}
	public Integer getInvoiceType() {
		return invoiceType;
	}
	public void setInvoiceType(Integer invoiceType) {
		this.invoiceType = invoiceType;
	}
	public String getInvoiceInfo() {
		return invoiceInfo;
	}
	public void setInvoiceInfo(String invoiceInfo) {
		this.invoiceInfo = invoiceInfo;
	}
	public Integer getCustomerType() {
		return customerType;
	}
	public void setCustomerType(Integer customerType) {
		this.customerType = customerType;
	}
	public String getDealId() {
		return dealId;
	}
	public void setDealId(String dealId) {
		this.dealId = dealId;
	}
	public BigDecimal getVirtualCoinNumber() {
		return virtualCoinNumber;
	}
	public void setVirtualCoinNumber(BigDecimal virtualCoinNumber) {
		this.virtualCoinNumber = virtualCoinNumber;
	}
	public BigDecimal getDiscount() {
		return discount;
	}
	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}
	public BigDecimal getOrderCouponAmount() {
		return orderCouponAmount;
	}
	public void setOrderCouponAmount(BigDecimal orderCouponAmount) {
		this.orderCouponAmount = orderCouponAmount;
	}
	public String getBankCode() {
		return bankCode;
	}
	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}
	public Integer getDistributionMode() {
		return distributionMode;
	}
	public void setDistributionMode(Integer distributionMode) {
		this.distributionMode = distributionMode;
	}
	public BigDecimal getTaxation() {
		return taxation;
	}
	public void setTaxation(BigDecimal taxation) {
		this.taxation = taxation;
	}
	public Integer getOrderSource() {
		return orderSource;
	}
	public void setOrderSource(Integer orderSource) {
		this.orderSource = orderSource;
	}
	public BigDecimal getMembersDiscountPrice() {
		return membersDiscountPrice;
	}
	public void setMembersDiscountPrice(BigDecimal membersDiscountPrice) {
		this.membersDiscountPrice = membersDiscountPrice;
	}
	public Integer getCustomerDiscountCouponID() {
		return customerDiscountCouponID;
	}
	public void setCustomerDiscountCouponID(Integer customerDiscountCouponID) {
		this.customerDiscountCouponID = customerDiscountCouponID;
	}
	public Integer getIsInvoice() {
		return isInvoice;
	}
	public void setIsInvoice(Integer isInvoice) {
		this.isInvoice = isInvoice;
	}
	public Integer getIsReturn() {
		return isReturn;
	}
	public void setIsReturn(Integer isReturn) {
		this.isReturn = isReturn;
	}
	public Integer getIsRebate() {
		return isRebate;
	}
	public void setIsRebate(Integer isRebate) {
		this.isRebate = isRebate;
	}
	public BigDecimal getRebateAmount() {
		return rebateAmount;
	}
	public void setRebateAmount(BigDecimal rebateAmount) {
		this.rebateAmount = rebateAmount;
	}

	public BigDecimal getRakeAmount() {
		return rakeAmount;
	}
	public void setRakeAmount(BigDecimal rakeAmount) {
		this.rakeAmount = rakeAmount;
	}
	public BigDecimal getChangeAmountTotal() {
		return changeAmountTotal;
	}
	public void setChangeAmountTotal(BigDecimal changeAmountTotal) {
		this.changeAmountTotal = changeAmountTotal;
	}
	public BigDecimal getReturnAmountTotal() {
		return returnAmountTotal;
	}
	public void setReturnAmountTotal(BigDecimal returnAmountTotal) {
		this.returnAmountTotal = returnAmountTotal;
	}
	public BigDecimal getSecRebateAmount() {
		return secRebateAmount;
	}
	public void setSecRebateAmount(BigDecimal secRebateAmount) {
		this.secRebateAmount = secRebateAmount;
	}
	public BigDecimal getThiRebateAmount() {
		return thiRebateAmount;
	}
	public void setThiRebateAmount(BigDecimal thiRebateAmount) {
		this.thiRebateAmount = thiRebateAmount;
	}

	public BigDecimal getPlatPresentCoin() {
		return platPresentCoin;
	}

	public void setPlatPresentCoin(BigDecimal platPresentCoin) {
		this.platPresentCoin = platPresentCoin;
	}

	public BigDecimal getBirthMonthDiscount() {
		return birthMonthDiscount;
	}

	public void setBirthMonthDiscount(BigDecimal birthMonthDiscount) {
		this.birthMonthDiscount = birthMonthDiscount;
	}

	public BigDecimal getBirthMonthDiscountPrice() {
		return birthMonthDiscountPrice;
	}

	public void setBirthMonthDiscountPrice(BigDecimal birthMonthDiscountPrice) {
		this.birthMonthDiscountPrice = birthMonthDiscountPrice;
	}

	public Integer getCustomerLevel() {
		return customerLevel;
	}

	public void setCustomerLevel(Integer customerLevel) {
		this.customerLevel = customerLevel;
	}

	public BigDecimal getPlatPromotionDiscountPrice() {
		return platPromotionDiscountPrice;
	}

	public void setPlatPromotionDiscountPrice(BigDecimal platPromotionDiscountPrice) {
		this.platPromotionDiscountPrice = platPromotionDiscountPrice;
	}

	public BigDecimal getVipDeductionPrice() {
		return vipDeductionPrice;
	}

	public void setVipDeductionPrice(BigDecimal vipDeductionPrice) {
		this.vipDeductionPrice = vipDeductionPrice;
	}

	public BigDecimal getVipDiscount() {
		return vipDiscount;
	}

	public void setVipDiscount(BigDecimal vipDiscount) {
		this.vipDiscount = vipDiscount;
	}

	/**
	 * 根据传入的值来获得支付方式的枚举对象
	 * @param payMode
	 * @return
	 */
	public static PayMode getPayMode(Integer payMode) {
		if (payMode - PayMode.ALIPAY.getValue() == 0) return PayMode.ALIPAY;
		else if (payMode - PayMode.WXPAY.getValue() == 0) return PayMode.WXPAY;
		else if (payMode - PayMode.ALIEBANK.getValue() == 0) return PayMode.ALIEBANK;
		else if (payMode - PayMode.ACCOUNTPAY.getValue() == 0) return PayMode.ACCOUNTPAY;
		else if (payMode - PayMode.FASTMONEYPAY.getValue() == 0) return PayMode.FASTMONEYPAY;
		else if (payMode - PayMode.DELIVERYPAY.getValue() == 0) return PayMode.DELIVERYPAY;
		else if (payMode - PayMode.COINTRADE.getValue() == 0) return PayMode.COINTRADE;
		else if (payMode - PayMode.ALISCANCODEPAY.getValue() == 0) return PayMode.ALISCANCODEPAY;
		else if (payMode - PayMode.WXSCANCODEPAY.getValue() == 0) return PayMode.WXSCANCODEPAY;
		else return null;
	}

	/**
	 * 支付方式
	 *
	 * */
	public static enum PayMode {
		ALIPAY("支付宝支付", 1),
		WXPAY("微信支付", 2),
		ALIEBANK("支付宝（网银）", 3),
		ACCOUNTPAY("余额支付", 4),
		FASTMONEYPAY("快钱支付", 5),
		DELIVERYPAY("货到付款", 6),
		COINTRADE("金币抵扣", 7),
		ALISCANCODEPAY("支付宝（扫码）", 8),
		WXSCANCODEPAY("微信（扫码）", 9);
		// 成员变量
		private String name;
		private int value;
		// 构造方法
		private PayMode(String name, int value) {
			this.name = name;
			this.value = value;
		}
		// 普通方法
		public static String getName(int index) {
			for (PayMode s : PayMode.values()) {
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

	/**
	 * 订单来源
	 *
	 * */
	public static enum OrderSource {
		PC("正常购物pc下单", 1),
		PCGROUPON("pc团购下单", 2),
		PHONEWEB("手机web下单", 3),
		PHONEGROUPON("手机团购下单", 4),
		WECHAT("微信下单", 5),
		WECHATGROUPON("微信团购下单", 6),
		APPIOS("APP IOS下单", 7),
		APPANDROID("APP ANDROID下单", 8),
		PAINCBUYINGPC("抢购PC下单", 9),
		PAINCBUYINGPHONE("抢购PHONE下单", 10),
		PAINCBUYINGWECHAT("抢购微信下单", 11),
		PAINCBUYINGAPP("抢购APP下单", 12),
		COMBOPC("组合购PC下单", 13),
		COMBOPHONE("组合购PHONE下单", 14),
		COMBOWECHAT("组合购微信下单", 15),
		COMBOAPP("组合购APP下单", 16),
		COINMALLPC("积分商城PC下单", 17),
		COINMALLPHONE("积分商城PHONE下单", 18),
		COINMALLWECHAT("积分商城微信下单", 19),
		COINMALLAPP("积分商城APP下单", 20);
		// 成员变量
		private String name;
		private int value;
		// 构造方法
		private OrderSource(String name, int value) {
			this.name = name;
			this.value = value;
		}
		// 普通方法
		public static String getName(int index) {
			for (OrderSource s : OrderSource.values()) {
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