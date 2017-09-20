package shop.order.pojo;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 订单明细bean
 *
 * @author 张攀攀
 *
 */
public class OrdersList extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 8418159682138970816L;
	/**
	 * 订单明细ID
	 */
	private Integer orderDetailId;
	/**
	 * 订单ID
	 */
	private Integer ordersId;
	/**
	 * 订单号
	 */
	private String ordersNo;
	/**
	 * 套餐Id
	 */
	private Integer productId;
	/**
	 * 套餐全名称
	 */
	private String productFullName;
	/**
	 * 进货价
	 */
	private BigDecimal costPrice;
	/**
	 * 销售价
	 */
	private BigDecimal salesPrice;
	/**
	 * 市场价
	 */
	private BigDecimal marketPrice;
	/**
	 * 会员价格(N)
	 */
	private BigDecimal memberPrice;
	/**
	 * 数量
	 */
	private Integer count;
	/**
	 * 购买类型
	 */
	private Integer buyType;
	/**
	 * 套餐编号
	 */
	private String productCode;
	/**
	 *套餐图片LOGO
	 */
	private String logoImage;
	/**
	 *套餐品牌
	 */
	private Integer brandId;
	/**
	 *店铺
	 */
	private Integer shopInfoId;
	/**
	 *品牌名称
	 */
	private String brandName;
	/**
	 *店铺名称
	 */
	private String shopName;
	/**
	 *运费
	 */
	private BigDecimal freightPrice;
	/**
	 * 用户id
	 */
	private Integer customerId;
	/**
	 * 预计发货日
	 */
	private String stockUpDate;
	/**
	 * SKU订货号
	 */
	private String sku;
	/**
	 * 套餐条形码
	 */
	private String barCode;
	/**
	 * 赠送金币总额
	 */
	private BigDecimal virtualCoinNumber;
	/**
	 * 赠送金币时的比例
	 */
	private BigDecimal virtualCoinProportion;
	/**
	 * 使用金币抵扣数量
	 */
	private BigDecimal userCoin;
	/**
	 * 抵扣金额
	 */
	private BigDecimal changeAmount;
	/**
	 * 赠送金币
	 */
	private BigDecimal virtualCoin;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**折扣比例**/
	private BigDecimal discount;
	/**
	 * 会员折扣金额
	 */
	private BigDecimal membersDiscountPrice;
	/**
	 * 税费
	 */
	private BigDecimal tallagePrice;
	/**单个套餐上级返利金额**/
	private BigDecimal rebateAmountPro;
	/**
	 * 一级返利比例
	 */
	private BigDecimal upRatio;
	/**
	 * 二级返利比例
	 */
	private BigDecimal secRatio;
	/**
	 * 三级返利比例
	 */
	private BigDecimal thiRatio;
	/**
	 * 一级返利金额
	 */
	private BigDecimal upRatioAmount;
	/**
	 * 二级返利金额
	 */
	private BigDecimal secRatioAmount;
	/**
	 * 三级返利金额
	 */
	private BigDecimal thiRatioAmount;

	private BigDecimal platPresentCoin;				//平台赠送积分
	private BigDecimal discountTotalPrice;			//订单套餐折扣后总价（平台促销、生日月折扣、vip会员折扣）
	private BigDecimal birthMonthDiscountPrice;		//生日月折扣减少金额
	private BigDecimal platPromotionDiscount;		//平台促销折扣(以100为单位)
	private BigDecimal platPromotionDiscountPrice;	//平台促销折扣减少金额
	private BigDecimal couponAmount;				//优惠券抵扣减少金额
	private BigDecimal vipDeductionPrice;			//店铺VIP会员折扣减少金额

	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public Integer getOrdersId() {
		return ordersId;
	}
	public void setOrdersId(Integer ordersId) {
		this.ordersId = ordersId;
	}
	public String getOrdersNo() {
		return ordersNo;
	}
	public void setOrdersNo(String ordersNo) {
		this.ordersNo = ordersNo;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public BigDecimal getMarketPrice() {
		return marketPrice;
	}
	public void setMarketPrice(BigDecimal marketPrice) {
		this.marketPrice = marketPrice;
	}
	public BigDecimal getMemberPrice() {
		return memberPrice;
	}
	public void setMemberPrice(BigDecimal memberPrice) {
		this.memberPrice = memberPrice;
	}
	public Integer getBuyType() {
		return buyType;
	}
	public void setBuyType(Integer buyType) {
		this.buyType = buyType;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	public BigDecimal getSalesPrice() {
		return salesPrice;
	}
	public void setSalesPrice(BigDecimal salesPrice) {
		this.salesPrice = salesPrice;
	}
	public Integer getOrderDetailId() {
		return orderDetailId;
	}
	public void setOrderDetailId(Integer orderDetailId) {
		this.orderDetailId = orderDetailId;
	}
	public String getProductFullName() {
		return productFullName;
	}
	public void setProductFullName(String productFullName) {
		this.productFullName = productFullName;
	}
	public BigDecimal getCostPrice() {
		return costPrice;
	}
	public void setCostPrice(BigDecimal costPrice) {
		this.costPrice = costPrice;
	}
	public String getProductCode() {
		return productCode;
	}
	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}
	public String getLogoImage() {
		return logoImage;
	}
	public void setLogoImage(String logoImage) {
		this.logoImage = logoImage;
	}
	public Integer getBrandId() {
		return brandId;
	}
	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}
	public Integer getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(Integer shopInfoId) {
		this.shopInfoId = shopInfoId;
	}
	public String getBrandName() {
		return brandName;
	}
	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}
	public String getShopName() {
		return shopName;
	}
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}
	public BigDecimal getFreightPrice() {
		return freightPrice;
	}
	public void setFreightPrice(BigDecimal freightPrice) {
		this.freightPrice = freightPrice;
	}
	public String getStockUpDate() {
		return stockUpDate;
	}
	public void setStockUpDate(String stockUpDate) {
		this.stockUpDate = stockUpDate;
	}
	public String getSku() {
		return sku;
	}
	public void setSku(String sku) {
		this.sku = sku;
	}
	public String getBarCode() {
		return barCode;
	}
	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}
	public BigDecimal getVirtualCoinNumber() {
		return virtualCoinNumber;
	}
	public void setVirtualCoinNumber(BigDecimal virtualCoinNumber) {
		this.virtualCoinNumber = virtualCoinNumber;
	}
	public BigDecimal getVirtualCoinProportion() {
		return virtualCoinProportion;
	}
	public void setVirtualCoinProportion(BigDecimal virtualCoinProportion) {
		this.virtualCoinProportion = virtualCoinProportion;
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
	public BigDecimal getVirtualCoin() {
		return virtualCoin;
	}
	public void setVirtualCoin(BigDecimal virtualCoin) {
		this.virtualCoin = virtualCoin;
	}
	public BigDecimal getDiscount() {
		return discount;
	}
	public void setDiscount(BigDecimal discount) {
		this.discount = discount;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public BigDecimal getMembersDiscountPrice() {
		return membersDiscountPrice;
	}
	public void setMembersDiscountPrice(BigDecimal membersDiscountPrice) {
		this.membersDiscountPrice = membersDiscountPrice;
	}
	public BigDecimal getTallagePrice() {
		return tallagePrice;
	}
	public void setTallagePrice(BigDecimal tallagePrice) {
		this.tallagePrice = tallagePrice;
	}
	public BigDecimal getRebateAmountPro() {
		return rebateAmountPro;
	}
	public void setRebateAmountPro(BigDecimal rebateAmountPro) {
		this.rebateAmountPro = rebateAmountPro;
	}
	public BigDecimal getUpRatio() {
		return upRatio;
	}
	public void setUpRatio(BigDecimal upRatio) {
		this.upRatio = upRatio;
	}
	public BigDecimal getSecRatio() {
		return secRatio;
	}
	public void setSecRatio(BigDecimal secRatio) {
		this.secRatio = secRatio;
	}
	public BigDecimal getThiRatio() {
		return thiRatio;
	}
	public void setThiRatio(BigDecimal thiRatio) {
		this.thiRatio = thiRatio;
	}
	public BigDecimal getUpRatioAmount() {
		return upRatioAmount;
	}
	public void setUpRatioAmount(BigDecimal upRatioAmount) {
		this.upRatioAmount = upRatioAmount;
	}
	public BigDecimal getSecRatioAmount() {
		return secRatioAmount;
	}
	public void setSecRatioAmount(BigDecimal secRatioAmount) {
		this.secRatioAmount = secRatioAmount;
	}
	public BigDecimal getThiRatioAmount() {
		return thiRatioAmount;
	}
	public void setThiRatioAmount(BigDecimal thiRatioAmount) {
		this.thiRatioAmount = thiRatioAmount;
	}

	public BigDecimal getPlatPresentCoin() {
		return platPresentCoin;
	}

	public void setPlatPresentCoin(BigDecimal platPresentCoin) {
		this.platPresentCoin = platPresentCoin;
	}

	public BigDecimal getDiscountTotalPrice() {
		return discountTotalPrice;
	}

	public void setDiscountTotalPrice(BigDecimal discountTotalPrice) {
		this.discountTotalPrice = discountTotalPrice;
	}

	public BigDecimal getBirthMonthDiscountPrice() {
		return birthMonthDiscountPrice;
	}

	public void setBirthMonthDiscountPrice(BigDecimal birthMonthDiscountPrice) {
		this.birthMonthDiscountPrice = birthMonthDiscountPrice;
	}

	public BigDecimal getPlatPromotionDiscount() {
		return platPromotionDiscount;
	}

	public void setPlatPromotionDiscount(BigDecimal platPromotionDiscount) {
		this.platPromotionDiscount = platPromotionDiscount;
	}

	public BigDecimal getPlatPromotionDiscountPrice() {
		return platPromotionDiscountPrice;
	}

	public void setPlatPromotionDiscountPrice(BigDecimal platPromotionDiscountPrice) {
		this.platPromotionDiscountPrice = platPromotionDiscountPrice;
	}

	public BigDecimal getCouponAmount() {
		return couponAmount;
	}

	public void setCouponAmount(BigDecimal couponAmount) {
		this.couponAmount = couponAmount;
	}

	public BigDecimal getVipDeductionPrice() {
		return vipDeductionPrice;
	}

	public void setVipDeductionPrice(BigDecimal vipDeductionPrice) {
		this.vipDeductionPrice = vipDeductionPrice;
	}
}
