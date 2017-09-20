package shop.product.pojo;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import org.compass.annotations.Index;
import org.compass.annotations.Searchable;
import org.compass.annotations.SearchableId;
import org.compass.annotations.SearchableProperty;
import org.compass.annotations.Store;

import util.pojo.BaseEntity;
/**
 * 套餐实体类
 * 
 *
 */
@SuppressWarnings("serial")
@Searchable
public class ProductInfo extends BaseEntity implements Serializable{
	private static long serialVersionUID = -4296800758519683653L;
	/**
	 * 套餐ID
	 */
	private Integer productId;
	/**
	 * 套餐的店铺类型[1、平台基础套餐；2 、平台店铺套餐]
	 */
	private Integer shopInfoProductType;
	/**
	 * 品牌ID
	 */
	private Integer brandId;
	/**
	 * 套餐分类ID
	 */
	private Integer productTypeId;
	/**
	 * 一级分类ID
	 */
	private Integer categoryLevel1;
	/**
	 * 二级分类ID
	 */
	private Integer categoryLevel2;
	/**
	 * 三级分类ID
	 */
	private Integer categoryLevel3;
	/**
	 * 四级分类ID
	 */
	private Integer categoryLevel4;
	/**
	 * 店铺ID
	 */
	private Integer shopInfoId;
	/**
	 * 套餐名称
	 */
	private String productName;
	/**
	 * 套餐全名称
	 */
	private String productFullName;
	/**
	 * 市场价格
	 */
	private BigDecimal marketPrice;
	/**
	 * 销售价
	 */
	private BigDecimal salesPrice;
	/**
	 * 销售价备份
	 */
	private BigDecimal salesPriceBack;
	/**
	 * 进货价
	 */
	private BigDecimal costPrice;
	/**
	 * 会员价格(N)
	 */
	private BigDecimal memberPrice;
	/**
	 * 上一级返利比例
	 */
	private BigDecimal upRatio;
	/**
	 * 上二级返利比例
	 */
	private BigDecimal secRatio;
	/**
	 * 上三级返利比例
	 */
	private BigDecimal thiRatio;
	/**
	 * 套餐重量
	 */
	private Double weight;
	/**
	 * 重量单位
	 */
	private String weightUnit;
	/**
	 * 计量单位名称
	 */
	private String measuringUnitName;
	/**
	 * 包装规格
	 */
	private String packingSpecifications;
	/**
	 * 套餐规格描述
	 */
	private String specification;
	/**
	 * 制造商型号
	 */
	private String manufacturerModel;
	/**
	 * 套餐描述
	 */
	private String describle;
	/**
	 * 创建时间
	 */
	private Date createDate;
	/**
	 * 更新时间
	 */
	private Date updateDate;
	/**
	 * 上架时间
	 */
	private Date putSaleDate;
	/**
	 * 是否上架
	 */
	private Integer isPutSale;
	/**
	 * 套餐编号
	 */
	private String productCode;
	/**
	 * 套餐功能简介
	 */
	private String functionDesc;
	/**
	 * 库存数
	 */
	private Integer storeNumber;
	/**
	 * 是否收取运费
	 * 1、不收取邮费，由店铺承担邮费。
	 * 2、收取邮费，由买家承担邮费。
	 */
	private Integer isChargeFreight;
	/**
	 * 运费价格
	 */
	private BigDecimal freightPrice;
	/**
	 * 套餐属性值
	 */
	private String productAttributeValue;
	/**
	 * 套餐参数值
	 */
	private String productParametersValue;
	/**
	 * 套餐规格归类组
	 */
	private Integer goods;
	/**
	 * 套餐数据同步标注
	 * 0：平台
	 * 1：店铺
	 */
	private Integer productRemark;
	/**
	 * 审核状态[0 未通过，1 已通过，2 待申请，3 待审核]
	 */
	private Integer isPass;
	/**
	 * 套餐备注
	 */
	private String note;
	/**
	 * 套餐搜索标签TAG
	 */
	private String productTag;
	/**
	 * SEO标题
	 */
	private String seoTitle;
	/**
	 * SEO关键字
	 */
	private String seoKeyWord;
	/**
	 * SEO描述
	 */
	private String seoDescription;
	/**
	 * 点击量(N)
	 */
	private Integer totalHits;
	/**
	 * 套餐销售量
	 */
	private Integer totalSales;
	/**
	 * 是否为推荐套餐
	 */
	private Integer isRecommend;
	/**
	 * 是否为新品套餐
	 */
	private Integer isNew;
	/**
	 * 是否为热销套餐
	 */
	private Integer isHot;
	/**
	 * 是否为顶置套餐
	 */
	private Integer isTop;
	/**套餐图片**/
	private String logoImg;
	/**套餐属性**/
	private String productAttribute;
	/**
	 * 是否显示
	 * 0：不显示
	 * 1：显示
	 */
	private Integer isShow;
	/**
	 * 买套餐送金币值
	 */
	private BigDecimal virtualCoinNumber;
	/**
	 * 赠送金币
	 */
	private BigDecimal giveAwayCoinNumber;
	/**
	 * 套餐条形码
	 */
	private String barCode;
	/***
	 * 套餐二维码
	 */
	private String qrCode;
	/**
	 * 预计发货日
	 */
	private Integer stockUpDate;
	/**
	 * 套餐省级发货地
	 */
	private Integer deliveryAddressProvince;
	/**
	 * 套餐地市级发货地
	 */
	private Integer deliveryAddressCities;
	/**
	 * SKU订货号
	 */
	private String sku;
	/**
	 * compass做关联查询品牌名称
	 */
	private String brandName;
	/**
	 * 虚拟套餐种类个数goodsCount
	 */
	private Integer goodsCount;
	/**
	 * 店铺名称
	 */
	private String shopName;
	/**
	 * 店铺是否通过
	 */
	private Integer tisPass;
	/**
	 * 店铺是否关闭
	 */
	private Integer tisClose;
	/**
	 * 企业信息审核人
	 */
	private String passUserName;
	/**
	 * 审核备注
	 */
	private String auditComment;

	/********************************************END**********************************************/
	/**
	 * 套餐ID
	 */
	@SearchableId
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	/**
	 * 品牌ID
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getBrandId() {
		return brandId;
	}
	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}
	/**
	 * 套餐分类ID
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(Integer productTypeId) {
		this.productTypeId = productTypeId;
	}
	/**
	 * 套餐名称
	 */
	@SearchableProperty(index=Index.ANALYZED,store=Store.YES)//做存储也要分词
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	/**
	 * 套餐全名称
	 */
	@SearchableProperty(index=Index.ANALYZED,store=Store.YES)//做存储
	public String getProductFullName() {
		return productFullName;
	}
	public void setProductFullName(String productFullName) {
		this.productFullName = productFullName;
	}
	/**
	 * 市场价格
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public BigDecimal getMarketPrice() {
		return marketPrice;
	}
	public void setMarketPrice(BigDecimal marketPrice) {
		this.marketPrice = marketPrice;
	}
	/**
	 * 销售价
	 */
	@SearchableProperty(store = Store.YES)//做存储
	public BigDecimal getSalesPrice() {
		return salesPrice;
	}
	public void setSalesPrice(BigDecimal salesPrice) {
		this.salesPrice = salesPrice;
	}
	public BigDecimal getSalesPriceBack() {
		return salesPriceBack;
	}
	public void setSalesPriceBack(BigDecimal salesPriceBack) {
		this.salesPriceBack = salesPriceBack;
	}
	/**
	 * 进货价
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public BigDecimal getCostPrice() {
		return costPrice;
	}
	public void setCostPrice(BigDecimal costPrice) {
		this.costPrice = costPrice;
	}
	/**
	 * 会员价格(N)
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public BigDecimal getMemberPrice() {
		return memberPrice;
	}
	public void setMemberPrice(BigDecimal memberPrice) {
		this.memberPrice = memberPrice;
	}
	/**
	 * 套餐重量
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Double getWeight() {
		return weight;
	}
	public void setWeight(Double weight) {
		this.weight = weight;
	}
	/**
	 * 重量单位
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public String getWeightUnit() {
		return weightUnit;
	}
	public void setWeightUnit(String weightUnit) {
		this.weightUnit = weightUnit;
	}
	/**
	 * 套餐规格描述
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getSpecification() {
		return specification;
	}
	public void setSpecification(String specification) {
		this.specification = specification;
	}
	/**
	 * 套餐描述
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getDescrible() {
		return describle;
	}
	public void setDescrible(String describle) {
		this.describle = describle;
	}
	/**
	 * 创建时间
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	/**
	 * 更新时间
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	/**
	 * 上架时间
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Date getPutSaleDate() {
		return putSaleDate;
	}
	public void setPutSaleDate(Date putSaleDate) {
		this.putSaleDate = putSaleDate;
	}
	/**
	 * 是否上架
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsPutSale() {
		return isPutSale;
	}
	public void setIsPutSale(Integer isPutSale) {
		this.isPutSale = isPutSale;
	}
	/**
	 * 套餐编号
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getProductCode() {
		return productCode;
	}
	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}
	/**
	 * 套餐功能简介
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public String getFunctionDesc() {
		return functionDesc;
	}
	public void setFunctionDesc(String functionDesc) {
		this.functionDesc = functionDesc;
	}
	/**
	 * 库存数
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getStoreNumber() {
		return storeNumber;
	}
	public void setStoreNumber(Integer storeNumber) {
		this.storeNumber = storeNumber;
	}
	/**
	 * 是否收取运费
	 * 1、不收取邮费，由店铺承担邮费。
	 * 2、收取邮费，由买家承担邮费。
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsChargeFreight() {
		return isChargeFreight;
	}
	public void setIsChargeFreight(Integer isChargeFreight) {
		this.isChargeFreight = isChargeFreight;
	}
	/**
	 * 运费价格
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public BigDecimal getFreightPrice() {
		return freightPrice;
	}
	public void setFreightPrice(BigDecimal freightPrice) {
		this.freightPrice = freightPrice;
	}
	/**
	 * 套餐属性值
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getProductAttributeValue() {
		return productAttributeValue;
	}
	public void setProductAttributeValue(String productAttributeValue) {
		this.productAttributeValue = productAttributeValue;
	}
	/**
	 * 套餐参数值
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public String getProductParametersValue() {
		return productParametersValue;
	}
	public void setProductParametersValue(String productParametersValue) {
		this.productParametersValue = productParametersValue;
	}
	/**
	 * 套餐规格归类组
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getGoods() {
		return goods;
	}
	public void setGoods(Integer goods) {
		this.goods = goods;
	}
	/**
	 * 套餐数据同步标注
	 * 0：平台
	 * 1：店铺
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getProductRemark() {
		return productRemark;
	}
	public void setProductRemark(Integer productRemark) {
		this.productRemark = productRemark;
	}
	/**
	 * 审核状态
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsPass() {
		return isPass;
	}
	public void setIsPass(Integer isPass) {
		this.isPass = isPass;
	}
	/**
	 * 套餐备注
	 */
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	/**
	 * 套餐搜索标签TAG
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getProductTag() {
		return productTag;
	}
	public void setProductTag(String productTag) {
		this.productTag = productTag;
	}
	/**
	 * SEO标题
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getSeoTitle() {
		return seoTitle;
	}
	public void setSeoTitle(String seoTitle) {
		this.seoTitle = seoTitle;
	}
	/**
	 * SEO关键字
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getSeoKeyWord() {
		return seoKeyWord;
	}
	public void setSeoKeyWord(String seoKeyWord) {
		this.seoKeyWord = seoKeyWord;
	}
	/**
	 * SEO描述
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public String getSeoDescription() {
		return seoDescription;
	}
	public void setSeoDescription(String seoDescription) {
		this.seoDescription = seoDescription;
	}
	/**
	 * 点击量(N)
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getTotalHits() {
		return totalHits;
	}
	public void setTotalHits(Integer totalHits) {
		this.totalHits = totalHits;
	}
	/**
	 * 套餐销售量
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getTotalSales() {
		return totalSales;
	}
	public void setTotalSales(Integer totalSales) {
		this.totalSales = totalSales;
	}
	/**
	 * 是否为推荐套餐
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsRecommend() {
		return isRecommend;
	}
	public void setIsRecommend(Integer isRecommend) {
		this.isRecommend = isRecommend;
	}
	/**
	 * 是否为新品套餐
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsNew() {
		return isNew;
	}
	public void setIsNew(Integer isNew) {
		this.isNew = isNew;
	}
	/**
	 * 是否为热销套餐
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsHot() {
		return isHot;
	}
	public void setIsHot(Integer isHot) {
		this.isHot = isHot;
	}
	/**
	 * 是否为顶置套餐
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsTop() {
		return isTop;
	}
	public void setIsTop(Integer isTop) {
		this.isTop = isTop;
	}
	/**
	 * 店铺ID
	 */
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(Integer shopInfoId) {
		this.shopInfoId = shopInfoId;
	}
	/**套餐图片**/
	@SearchableProperty(store=Store.YES)//做存储
	public String getLogoImg() {
		return logoImg;
	}
	public void setLogoImg(String logoImg) {
		this.logoImg = logoImg;
	}
	/**套餐属性**/
	@SearchableProperty(store=Store.YES)//做存储
	public String getProductAttribute() {
		return productAttribute;
	}
	public void setProductAttribute(String productAttribute) {
		this.productAttribute = productAttribute;
	}
	/**
	 * 是否显示
	 * 0：不显示
	 * 1：显示
	 */
	@SearchableProperty(store=Store.YES)//做存储
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	/**
	 *买套餐送金币值
	 */
	public String getBarCode() {
		return barCode;
	}
	/**
	 * 预计出售日
	 */
	public Integer getStockUpDate() {
		return stockUpDate;
	}
	public void setStockUpDate(Integer stockUpDate) {
		this.stockUpDate = stockUpDate;
	}
	public BigDecimal getVirtualCoinNumber() {
		return virtualCoinNumber;
	}
	public void setVirtualCoinNumber(BigDecimal virtualCoinNumber) {
		this.virtualCoinNumber = virtualCoinNumber;
	}
	public void setBarCode(String barCode) {
		this.barCode = barCode;
	}
	public String getQrCode() {
		return qrCode;
	}
	public void setQrCode(String qrCode) {
		this.qrCode = qrCode;
	}
	public Integer getDeliveryAddressProvince() {
		return deliveryAddressProvince;
	}
	public void setDeliveryAddressProvince(Integer deliveryAddressProvince) {
		this.deliveryAddressProvince = deliveryAddressProvince;
	}
	public Integer getDeliveryAddressCities() {
		return deliveryAddressCities;
	}
	public void setDeliveryAddressCities(Integer deliveryAddressCities) {
		this.deliveryAddressCities = deliveryAddressCities;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public String getSku() {
		return sku;
	}
	public void setSku(String sku) {
		this.sku = sku;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public String getBrandName() {
		return brandName;
	}
	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}
	public String getMeasuringUnitName() {
		return measuringUnitName;
	}
	public void setMeasuringUnitName(String measuringUnitName) {
		this.measuringUnitName = measuringUnitName;
	}
	public String getPackingSpecifications() {
		return packingSpecifications;
	}
	public void setPackingSpecifications(String packingSpecifications) {
		this.packingSpecifications = packingSpecifications;
	}
	public String getManufacturerModel() {
		return manufacturerModel;
	}
	public void setManufacturerModel(String manufacturerModel) {
		this.manufacturerModel = manufacturerModel;
	}
	public Integer getGoodsCount() {
		return goodsCount;
	}
	public void setGoodsCount(Integer goodsCount) {
		this.goodsCount = goodsCount;
	}
	/*@SearchableComponent
	public ShopInfo getShopInfo() {
		return shopInfo;
	}
	public void setShopInfo(ShopInfo shopInfo) {
		this.shopInfo = shopInfo;
	}*/
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}
	public static void setSerialVersionUID(long serialVersionUID) {
		ProductInfo.serialVersionUID = serialVersionUID;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getCategoryLevel1() {
		return categoryLevel1;
	}
	public void setCategoryLevel1(Integer categoryLevel1) {
		this.categoryLevel1 = categoryLevel1;
	}
	public Integer getCategoryLevel2() {
		return categoryLevel2;
	}
	public void setCategoryLevel2(Integer categoryLevel2) {
		this.categoryLevel2 = categoryLevel2;
	}
	public Integer getCategoryLevel3() {
		return categoryLevel3;
	}
	public void setCategoryLevel3(Integer categoryLevel3) {
		this.categoryLevel3 = categoryLevel3;
	}
	public Integer getCategoryLevel4() {
		return categoryLevel4;
	}
	public void setCategoryLevel4(Integer categoryLevel4) {
		this.categoryLevel4 = categoryLevel4;
	}
	public BigDecimal getGiveAwayCoinNumber() {
		return giveAwayCoinNumber;
	}
	public void setGiveAwayCoinNumber(BigDecimal giveAwayCoinNumber) {
		this.giveAwayCoinNumber = giveAwayCoinNumber;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public String getShopName() {
		return shopName;
	}
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getTisPass() {
		return tisPass;
	}
	public void setTisPass(Integer tisPass) {
		this.tisPass = tisPass;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getTisClose() {
		return tisClose;
	}
	public void setTisClose(Integer tisClose) {
		this.tisClose = tisClose;
	}
	public String getPassUserName() {
		return passUserName;
	}
	public void setPassUserName(String passUserName) {
		this.passUserName = passUserName;
	}
	@SearchableProperty(index = Index.NOT_ANALYZED, store = Store.YES)//做存储
	public Integer getShopInfoProductType() {
		return shopInfoProductType;
	}
	public void setShopInfoProductType(Integer shopInfoProductType) {
		this.shopInfoProductType = shopInfoProductType;
	}
	public String getAuditComment() {
		return auditComment;
	}
	public void setAuditComment(String auditComment) {
		this.auditComment = auditComment;
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
	
}
